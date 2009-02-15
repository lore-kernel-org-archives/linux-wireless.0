Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57886 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbZBOLp6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 06:45:58 -0500
Subject: [PATCH v2] mac80211: split IBSS/managed code
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20090213203641.199830@gmx.net> (sfid-20090213_213711_951136_CAB188EF)
References: <1234396421.16004.67.camel@johannes.local>
	 <20090213203641.199830@gmx.net> (sfid-20090213_213711_951136_CAB188EF)
Content-Type: text/plain
Date: Sun, 15 Feb 2009 12:44:28 +0100
Message-Id: <1234698268.4219.64.camel@johannes.local> (sfid-20090215_124613_163758_8C6AA50F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch splits out the ibss code and data from managed (station) mode.
The reason to do this is to better separate the state machines, and have
the code be contained better so it gets easier to determine what exactly
a given change will affect, that in turn makes it easier to understand.

This is quite some churn, especially because I split sdata->u.sta into
sdata->u.mgd and sdata->u.ibss, but I think it's easier to maintain that
way. I've also shuffled around some code -- null function sending is only
applicable to managed interfaces so put that into that file, some other
functions are needed from various places so put them into util, and also
rearranged the prototypes in ieee80211_i.h accordingly.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
v2: fix bug with skb queue vs. internal state machine requests -- the reason
    my initial testing worked fine regardless was that I didn't have any AP
    in the vicinity that would lead to beacon processing all the time.
    I have not found any indication that there's a problem with beaconing,
    in fact my N810 joins the IBSS fine when I disable probe responses.

This passed my, fairly rigorous, testing:
 * associate to AP
 * create IBSS
 * create different IBSS
 * down
 * up
 * create another IBSS
 * associate to AP
without any trouble.

It somewhat paves the way to making managed mode entirely optional
should that ever be desired. I didn't do it because that would add
a lot of #ifdefs especially in the wext code.

 net/mac80211/Makefile         |    1 
 net/mac80211/agg-rx.c         |    6 
 net/mac80211/agg-tx.c         |    5 
 net/mac80211/cfg.c            |   45 -
 net/mac80211/debugfs_netdev.c |   48 -
 net/mac80211/ht.c             |    6 
 net/mac80211/ibss.c           |  888 ++++++++++++++++++++++
 net/mac80211/ieee80211_i.h    |  117 ++
 net/mac80211/iface.c          |   76 +
 net/mac80211/key.c            |    2 
 net/mac80211/main.c           |    9 
 net/mac80211/mlme.c           | 1642 ++++++++++--------------------------------
 net/mac80211/rx.c             |   37 
 net/mac80211/scan.c           |   43 -
 net/mac80211/spectmgmt.c      |   26 
 net/mac80211/tx.c             |   11 
 net/mac80211/util.c           |  176 ++++
 net/mac80211/wext.c           |  141 ++-
 18 files changed, 1801 insertions(+), 1478 deletions(-)

--- wireless-testing.orig/net/mac80211/Makefile	2009-02-15 12:22:49.000000000 +0100
+++ wireless-testing/net/mac80211/Makefile	2009-02-15 12:22:54.000000000 +0100
@@ -9,6 +9,7 @@ mac80211-y := \
 	wpa.o \
 	scan.o \
 	ht.o agg-tx.o agg-rx.o \
+	ibss.o \
 	mlme.o \
 	iface.o \
 	rate.o \
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/net/mac80211/ibss.c	2009-02-15 12:43:56.000000000 +0100
@@ -0,0 +1,888 @@
+/*
+ * IBSS mode implementation
+ * Copyright 2003-2008, Jouni Malinen <j@w1.fi>
+ * Copyright 2004, Instant802 Networks, Inc.
+ * Copyright 2005, Devicescape Software, Inc.
+ * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
+ * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
+ * Copyright 2009, Johannes Berg <johannes@sipsolutions.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/if_ether.h>
+#include <linux/skbuff.h>
+#include <linux/if_arp.h>
+#include <linux/etherdevice.h>
+#include <linux/rtnetlink.h>
+#include <net/mac80211.h>
+#include <asm/unaligned.h>
+
+#include "ieee80211_i.h"
+#include "rate.h"
+
+#define IEEE80211_SCAN_INTERVAL (2 * HZ)
+#define IEEE80211_SCAN_INTERVAL_SLOW (15 * HZ)
+#define IEEE80211_IBSS_JOIN_TIMEOUT (7 * HZ)
+
+#define IEEE80211_IBSS_MERGE_INTERVAL (30 * HZ)
+#define IEEE80211_IBSS_INACTIVITY_LIMIT (60 * HZ)
+
+#define IEEE80211_IBSS_MAX_STA_ENTRIES 128
+
+
+static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
+					struct ieee80211_mgmt *mgmt,
+					size_t len)
+{
+	u16 auth_alg, auth_transaction, status_code;
+
+	if (len < 24 + 6)
+		return;
+
+	auth_alg = le16_to_cpu(mgmt->u.auth.auth_alg);
+	auth_transaction = le16_to_cpu(mgmt->u.auth.auth_transaction);
+	status_code = le16_to_cpu(mgmt->u.auth.status_code);
+
+	/*
+	 * IEEE 802.11 standard does not require authentication in IBSS
+	 * networks and most implementations do not seem to use it.
+	 * However, try to reply to authentication attempts if someone
+	 * has actually implemented this.
+	 */
+	if (auth_alg == WLAN_AUTH_OPEN && auth_transaction == 1)
+		ieee80211_send_auth(sdata, 2, WLAN_AUTH_OPEN, NULL, 0,
+				    sdata->u.ibss.bssid, 0);
+}
+
+static int __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
+				     const u8 *bssid, const int beacon_int,
+				     const int freq,
+				     const size_t supp_rates_len,
+				     const u8 *supp_rates,
+				     const u16 capability)
+{
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct ieee80211_local *local = sdata->local;
+	int res = 0, rates, i, j;
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *mgmt;
+	u8 *pos;
+	struct ieee80211_supported_band *sband;
+	union iwreq_data wrqu;
+
+	if (local->ops->reset_tsf) {
+		/* Reset own TSF to allow time synchronization work. */
+		local->ops->reset_tsf(local_to_hw(local));
+	}
+
+	if ((ifibss->flags & IEEE80211_IBSS_PREV_BSSID_SET) &&
+	   memcmp(ifibss->bssid, bssid, ETH_ALEN) == 0)
+		return res;
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400);
+	if (!skb) {
+		printk(KERN_DEBUG "%s: failed to allocate buffer for probe "
+		       "response\n", sdata->dev->name);
+		return -ENOMEM;
+	}
+
+	if (!(ifibss->flags & IEEE80211_IBSS_PREV_BSSID_SET)) {
+		/* Remove possible STA entries from other IBSS networks. */
+		sta_info_flush_delayed(sdata);
+	}
+
+	memcpy(ifibss->bssid, bssid, ETH_ALEN);
+	res = ieee80211_if_config(sdata, IEEE80211_IFCC_BSSID);
+	if (res)
+		return res;
+
+	local->hw.conf.beacon_int = beacon_int >= 10 ? beacon_int : 10;
+
+	sdata->drop_unencrypted = capability &
+		WLAN_CAPABILITY_PRIVACY ? 1 : 0;
+
+	res = ieee80211_set_freq(sdata, freq);
+
+	if (res)
+		return res;
+
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
+	/* Build IBSS probe response */
+
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	mgmt = (struct ieee80211_mgmt *)
+		skb_put(skb, 24 + sizeof(mgmt->u.beacon));
+	memset(mgmt, 0, 24 + sizeof(mgmt->u.beacon));
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_PROBE_RESP);
+	memset(mgmt->da, 0xff, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->bssid, ifibss->bssid, ETH_ALEN);
+	mgmt->u.beacon.beacon_int =
+		cpu_to_le16(local->hw.conf.beacon_int);
+	mgmt->u.beacon.capab_info = cpu_to_le16(capability);
+
+	pos = skb_put(skb, 2 + ifibss->ssid_len);
+	*pos++ = WLAN_EID_SSID;
+	*pos++ = ifibss->ssid_len;
+	memcpy(pos, ifibss->ssid, ifibss->ssid_len);
+
+	rates = supp_rates_len;
+	if (rates > 8)
+		rates = 8;
+	pos = skb_put(skb, 2 + rates);
+	*pos++ = WLAN_EID_SUPP_RATES;
+	*pos++ = rates;
+	memcpy(pos, supp_rates, rates);
+
+	if (sband->band == IEEE80211_BAND_2GHZ) {
+		pos = skb_put(skb, 2 + 1);
+		*pos++ = WLAN_EID_DS_PARAMS;
+		*pos++ = 1;
+		*pos++ = ieee80211_frequency_to_channel(freq);
+	}
+
+	pos = skb_put(skb, 2 + 2);
+	*pos++ = WLAN_EID_IBSS_PARAMS;
+	*pos++ = 2;
+	/* FIX: set ATIM window based on scan results */
+	*pos++ = 0;
+	*pos++ = 0;
+
+	if (supp_rates_len > 8) {
+		rates = supp_rates_len - 8;
+		pos = skb_put(skb, 2 + rates);
+		*pos++ = WLAN_EID_EXT_SUPP_RATES;
+		*pos++ = rates;
+		memcpy(pos, &supp_rates[8], rates);
+	}
+
+	ifibss->probe_resp = skb;
+
+	ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON |
+				   IEEE80211_IFCC_BEACON_ENABLED);
+
+
+	rates = 0;
+	for (i = 0; i < supp_rates_len; i++) {
+		int bitrate = (supp_rates[i] & 0x7f) * 5;
+		for (j = 0; j < sband->n_bitrates; j++)
+			if (sband->bitrates[j].bitrate == bitrate)
+				rates |= BIT(j);
+	}
+
+	ieee80211_sta_def_wmm_params(sdata, supp_rates_len, supp_rates);
+
+	ifibss->flags |= IEEE80211_IBSS_PREV_BSSID_SET;
+	ifibss->state = IEEE80211_IBSS_MLME_JOINED;
+	mod_timer(&ifibss->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
+
+	memset(&wrqu, 0, sizeof(wrqu));
+	memcpy(wrqu.ap_addr.sa_data, bssid, ETH_ALEN);
+	wireless_send_event(sdata->dev, SIOCGIWAP, &wrqu, NULL);
+
+	return res;
+}
+
+static int ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
+				   struct ieee80211_bss *bss)
+{
+	return __ieee80211_sta_join_ibss(sdata,
+					 bss->cbss.bssid,
+					 bss->cbss.beacon_interval,
+					 bss->cbss.channel->center_freq,
+					 bss->supp_rates_len, bss->supp_rates,
+					 bss->cbss.capability);
+}
+
+static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
+				  struct ieee80211_mgmt *mgmt,
+				  size_t len,
+				  struct ieee80211_rx_status *rx_status,
+				  struct ieee802_11_elems *elems,
+				  bool beacon)
+{
+	struct ieee80211_local *local = sdata->local;
+	int freq;
+	struct ieee80211_bss *bss;
+	struct sta_info *sta;
+	struct ieee80211_channel *channel;
+	u64 beacon_timestamp, rx_timestamp;
+	u32 supp_rates = 0;
+	enum ieee80211_band band = rx_status->band;
+
+	if (elems->ds_params && elems->ds_params_len == 1)
+		freq = ieee80211_channel_to_frequency(elems->ds_params[0]);
+	else
+		freq = rx_status->freq;
+
+	channel = ieee80211_get_channel(local->hw.wiphy, freq);
+
+	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
+		return;
+
+	if (sdata->vif.type == NL80211_IFTYPE_ADHOC && elems->supp_rates &&
+	    memcmp(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN) == 0) {
+		supp_rates = ieee80211_sta_get_rates(local, elems, band);
+
+		rcu_read_lock();
+
+		sta = sta_info_get(local, mgmt->sa);
+		if (sta) {
+			u32 prev_rates;
+
+			prev_rates = sta->sta.supp_rates[band];
+			/* make sure mandatory rates are always added */
+			sta->sta.supp_rates[band] = supp_rates |
+				ieee80211_mandatory_rates(local, band);
+
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+			if (sta->sta.supp_rates[band] != prev_rates)
+				printk(KERN_DEBUG "%s: updated supp_rates set "
+				    "for %pM based on beacon info (0x%llx | "
+				    "0x%llx -> 0x%llx)\n",
+				    sdata->dev->name,
+				    sta->sta.addr,
+				    (unsigned long long) prev_rates,
+				    (unsigned long long) supp_rates,
+				    (unsigned long long) sta->sta.supp_rates[band]);
+#endif
+		} else
+			ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, supp_rates);
+
+		rcu_read_unlock();
+	}
+
+	bss = ieee80211_bss_info_update(local, rx_status, mgmt, len, elems,
+					channel, beacon);
+	if (!bss)
+		return;
+
+	/* was just updated in ieee80211_bss_info_update */
+	beacon_timestamp = bss->cbss.tsf;
+
+	/* check if we need to merge IBSS */
+
+	/* merge only on beacons (???) */
+	if (!beacon)
+		goto put_bss;
+
+	/* we use a fixed BSSID */
+	if (sdata->u.ibss.flags & IEEE80211_IBSS_BSSID_SET)
+		goto put_bss;
+
+	/* not an IBSS */
+	if (!(bss->cbss.capability & WLAN_CAPABILITY_IBSS))
+		goto put_bss;
+
+	/* different channel */
+	if (bss->cbss.channel != local->oper_channel)
+		goto put_bss;
+
+	/* different SSID */
+	if (elems->ssid_len != sdata->u.ibss.ssid_len ||
+	    memcmp(elems->ssid, sdata->u.ibss.ssid,
+				sdata->u.ibss.ssid_len))
+		goto put_bss;
+
+	if (rx_status->flag & RX_FLAG_TSFT) {
+		/*
+		 * For correct IBSS merging we need mactime; since mactime is
+		 * defined as the time the first data symbol of the frame hits
+		 * the PHY, and the timestamp of the beacon is defined as "the
+		 * time that the data symbol containing the first bit of the
+		 * timestamp is transmitted to the PHY plus the transmitting
+		 * STA's delays through its local PHY from the MAC-PHY
+		 * interface to its interface with the WM" (802.11 11.1.2)
+		 * - equals the time this bit arrives at the receiver - we have
+		 * to take into account the offset between the two.
+		 *
+		 * E.g. at 1 MBit that means mactime is 192 usec earlier
+		 * (=24 bytes * 8 usecs/byte) than the beacon timestamp.
+		 */
+		int rate;
+
+		if (rx_status->flag & RX_FLAG_HT)
+			rate = 65; /* TODO: HT rates */
+		else
+			rate = local->hw.wiphy->bands[band]->
+				bitrates[rx_status->rate_idx].bitrate;
+
+		rx_timestamp = rx_status->mactime + (24 * 8 * 10 / rate);
+	} else if (local && local->ops && local->ops->get_tsf)
+		/* second best option: get current TSF */
+		rx_timestamp = local->ops->get_tsf(local_to_hw(local));
+	else
+		/* can't merge without knowing the TSF */
+		rx_timestamp = -1LLU;
+
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+	printk(KERN_DEBUG "RX beacon SA=%pM BSSID="
+	       "%pM TSF=0x%llx BCN=0x%llx diff=%lld @%lu\n",
+	       mgmt->sa, mgmt->bssid,
+	       (unsigned long long)rx_timestamp,
+	       (unsigned long long)beacon_timestamp,
+	       (unsigned long long)(rx_timestamp - beacon_timestamp),
+	       jiffies);
+#endif
+
+	if (beacon_timestamp > rx_timestamp) {
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+		printk(KERN_DEBUG "%s: beacon TSF higher than "
+		       "local TSF - IBSS merge with BSSID %pM\n",
+		       sdata->dev->name, mgmt->bssid);
+#endif
+		ieee80211_sta_join_ibss(sdata, bss);
+		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, supp_rates);
+	}
+
+ put_bss:
+	ieee80211_rx_bss_put(local, bss);
+}
+
+/*
+ * Add a new IBSS station, will also be called by the RX code when,
+ * in IBSS mode, receiving a frame from a yet-unknown station, hence
+ * must be callable in atomic context.
+ */
+struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
+					u8 *bssid,u8 *addr, u32 supp_rates)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+	int band = local->hw.conf.channel->band;
+
+	/* TODO: Could consider removing the least recently used entry and
+	 * allow new one to be added. */
+	if (local->num_sta >= IEEE80211_IBSS_MAX_STA_ENTRIES) {
+		if (net_ratelimit()) {
+			printk(KERN_DEBUG "%s: No room for a new IBSS STA "
+			       "entry %pM\n", sdata->dev->name, addr);
+		}
+		return NULL;
+	}
+
+	if (compare_ether_addr(bssid, sdata->u.ibss.bssid))
+		return NULL;
+
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+	printk(KERN_DEBUG "%s: Adding new IBSS station %pM (dev=%s)\n",
+	       wiphy_name(local->hw.wiphy), addr, sdata->dev->name);
+#endif
+
+	sta = sta_info_alloc(sdata, addr, GFP_ATOMIC);
+	if (!sta)
+		return NULL;
+
+	set_sta_flags(sta, WLAN_STA_AUTHORIZED);
+
+	/* make sure mandatory rates are always added */
+	sta->sta.supp_rates[band] = supp_rates |
+			ieee80211_mandatory_rates(local, band);
+
+	rate_control_rate_init(sta);
+
+	if (sta_info_insert(sta))
+		return NULL;
+
+	return sta;
+}
+
+static int ieee80211_sta_active_ibss(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	int active = 0;
+	struct sta_info *sta;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+		if (sta->sdata == sdata &&
+		    time_after(sta->last_rx + IEEE80211_IBSS_MERGE_INTERVAL,
+			       jiffies)) {
+			active++;
+			break;
+		}
+	}
+
+	rcu_read_unlock();
+
+	return active;
+}
+
+
+static void ieee80211_sta_merge_ibss(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+
+	mod_timer(&ifibss->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
+
+	ieee80211_sta_expire(sdata, IEEE80211_IBSS_INACTIVITY_LIMIT);
+	if (ieee80211_sta_active_ibss(sdata))
+		return;
+
+	if ((ifibss->flags & IEEE80211_IBSS_BSSID_SET) &&
+	    (!(ifibss->flags & IEEE80211_IBSS_AUTO_CHANNEL_SEL)))
+		return;
+
+	printk(KERN_DEBUG "%s: No active IBSS STAs - trying to scan for other "
+	       "IBSS networks with same SSID (merge)\n", sdata->dev->name);
+
+	/* XXX maybe racy? */
+	if (sdata->local->scan_req)
+		return;
+
+	memcpy(sdata->local->int_scan_req.ssids[0].ssid,
+	       ifibss->ssid, IEEE80211_MAX_SSID_LEN);
+	sdata->local->int_scan_req.ssids[0].ssid_len = ifibss->ssid_len;
+	ieee80211_request_scan(sdata, &sdata->local->int_scan_req);
+}
+
+static int ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_supported_band *sband;
+	u8 *pos;
+	u8 bssid[ETH_ALEN];
+	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
+	u16 capability;
+	int i;
+
+	if (ifibss->flags & IEEE80211_IBSS_BSSID_SET) {
+		memcpy(bssid, ifibss->bssid, ETH_ALEN);
+	} else {
+		/* Generate random, not broadcast, locally administered BSSID. Mix in
+		 * own MAC address to make sure that devices that do not have proper
+		 * random number generator get different BSSID. */
+		get_random_bytes(bssid, ETH_ALEN);
+		for (i = 0; i < ETH_ALEN; i++)
+			bssid[i] ^= sdata->dev->dev_addr[i];
+		bssid[0] &= ~0x01;
+		bssid[0] |= 0x02;
+	}
+
+	printk(KERN_DEBUG "%s: Creating new IBSS network, BSSID %pM\n",
+	       sdata->dev->name, bssid);
+
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
+	if (local->hw.conf.beacon_int == 0)
+		local->hw.conf.beacon_int = 100;
+
+	capability = WLAN_CAPABILITY_IBSS;
+
+	if (sdata->default_key)
+		capability |= WLAN_CAPABILITY_PRIVACY;
+	else
+		sdata->drop_unencrypted = 0;
+
+	pos = supp_rates;
+	for (i = 0; i < sband->n_bitrates; i++) {
+		int rate = sband->bitrates[i].bitrate;
+		*pos++ = (u8) (rate / 5);
+	}
+
+	return __ieee80211_sta_join_ibss(sdata,
+					 bssid, local->hw.conf.beacon_int,
+					 local->hw.conf.channel->center_freq,
+					 sband->n_bitrates, supp_rates,
+					 capability);
+}
+
+static int ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_bss *bss;
+	const u8 *bssid = NULL;
+	int active_ibss;
+
+	if (ifibss->ssid_len == 0)
+		return -EINVAL;
+
+	active_ibss = ieee80211_sta_active_ibss(sdata);
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+	printk(KERN_DEBUG "%s: sta_find_ibss (active_ibss=%d)\n",
+	       sdata->dev->name, active_ibss);
+#endif /* CONFIG_MAC80211_IBSS_DEBUG */
+
+	if (active_ibss)
+		return 0;
+
+	if (ifibss->flags & IEEE80211_IBSS_BSSID_SET)
+		bssid = ifibss->bssid;
+	bss = (void *)cfg80211_get_bss(local->hw.wiphy, NULL, bssid,
+				       ifibss->ssid, ifibss->ssid_len,
+				       WLAN_CAPABILITY_IBSS,
+				       WLAN_CAPABILITY_IBSS);
+
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+	if (bss)
+		printk(KERN_DEBUG "   sta_find_ibss: selected %pM current "
+		       "%pM\n", bss->cbss.bssid, ifibss->bssid);
+#endif /* CONFIG_MAC80211_IBSS_DEBUG */
+
+	if (bss &&
+	    (!(ifibss->flags & IEEE80211_IBSS_PREV_BSSID_SET) ||
+	     memcmp(ifibss->bssid, bss->cbss.bssid, ETH_ALEN))) {
+		int ret;
+
+		printk(KERN_DEBUG "%s: Selected IBSS BSSID %pM"
+		       " based on configured SSID\n",
+		       sdata->dev->name, bss->cbss.bssid);
+
+		ret = ieee80211_sta_join_ibss(sdata, bss);
+		ieee80211_rx_bss_put(local, bss);
+		return ret;
+	} else if (bss)
+		ieee80211_rx_bss_put(local, bss);
+
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+	printk(KERN_DEBUG "   did not try to join ibss\n");
+#endif /* CONFIG_MAC80211_IBSS_DEBUG */
+
+	/* Selected IBSS not found in current scan results - try to scan */
+	if (ifibss->state == IEEE80211_IBSS_MLME_JOINED &&
+	    !ieee80211_sta_active_ibss(sdata)) {
+		mod_timer(&ifibss->timer, jiffies +
+					  IEEE80211_IBSS_MERGE_INTERVAL);
+	} else if (time_after(jiffies, local->last_scan_completed +
+					IEEE80211_SCAN_INTERVAL)) {
+		printk(KERN_DEBUG "%s: Trigger new scan to find an IBSS to "
+		       "join\n", sdata->dev->name);
+
+		/* XXX maybe racy? */
+		if (local->scan_req)
+			return -EBUSY;
+
+		memcpy(local->int_scan_req.ssids[0].ssid,
+		       ifibss->ssid, IEEE80211_MAX_SSID_LEN);
+		local->int_scan_req.ssids[0].ssid_len = ifibss->ssid_len;
+		return ieee80211_request_scan(sdata, &local->int_scan_req);
+	} else if (ifibss->state != IEEE80211_IBSS_MLME_JOINED) {
+		int interval = IEEE80211_SCAN_INTERVAL;
+
+		if (time_after(jiffies, ifibss->ibss_join_req +
+			       IEEE80211_IBSS_JOIN_TIMEOUT)) {
+			if (!(local->oper_channel->flags &
+						IEEE80211_CHAN_NO_IBSS))
+				return ieee80211_sta_create_ibss(sdata);
+			printk(KERN_DEBUG "%s: IBSS not allowed on"
+			       " %d MHz\n", sdata->dev->name,
+			       local->hw.conf.channel->center_freq);
+
+			/* No IBSS found - decrease scan interval and continue
+			 * scanning. */
+			interval = IEEE80211_SCAN_INTERVAL_SLOW;
+		}
+
+		ifibss->state = IEEE80211_IBSS_MLME_SEARCH;
+		mod_timer(&ifibss->timer, jiffies + interval);
+		return 0;
+	}
+
+	return 0;
+}
+
+static void ieee80211_rx_mgmt_probe_req(struct ieee80211_sub_if_data *sdata,
+					struct ieee80211_mgmt *mgmt,
+					size_t len)
+{
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct ieee80211_local *local = sdata->local;
+	int tx_last_beacon;
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *resp;
+	u8 *pos, *end;
+
+	if (ifibss->state != IEEE80211_IBSS_MLME_JOINED ||
+	    len < 24 + 2 || !ifibss->probe_resp)
+		return;
+
+	if (local->ops->tx_last_beacon)
+		tx_last_beacon = local->ops->tx_last_beacon(local_to_hw(local));
+	else
+		tx_last_beacon = 1;
+
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+	printk(KERN_DEBUG "%s: RX ProbeReq SA=%pM DA=%pM BSSID=%pM"
+	       " (tx_last_beacon=%d)\n",
+	       sdata->dev->name, mgmt->sa, mgmt->da,
+	       mgmt->bssid, tx_last_beacon);
+#endif /* CONFIG_MAC80211_IBSS_DEBUG */
+
+	if (!tx_last_beacon)
+		return;
+
+	if (memcmp(mgmt->bssid, ifibss->bssid, ETH_ALEN) != 0 &&
+	    memcmp(mgmt->bssid, "\xff\xff\xff\xff\xff\xff", ETH_ALEN) != 0)
+		return;
+
+	end = ((u8 *) mgmt) + len;
+	pos = mgmt->u.probe_req.variable;
+	if (pos[0] != WLAN_EID_SSID ||
+	    pos + 2 + pos[1] > end) {
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+		printk(KERN_DEBUG "%s: Invalid SSID IE in ProbeReq "
+		       "from %pM\n",
+		       sdata->dev->name, mgmt->sa);
+#endif
+		return;
+	}
+	if (pos[1] != 0 &&
+	    (pos[1] != ifibss->ssid_len ||
+	     memcmp(pos + 2, ifibss->ssid, ifibss->ssid_len) != 0)) {
+		/* Ignore ProbeReq for foreign SSID */
+		return;
+	}
+
+	/* Reply with ProbeResp */
+	skb = skb_copy(ifibss->probe_resp, GFP_KERNEL);
+	if (!skb)
+		return;
+
+	resp = (struct ieee80211_mgmt *) skb->data;
+	memcpy(resp->da, mgmt->sa, ETH_ALEN);
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+	printk(KERN_DEBUG "%s: Sending ProbeResp to %pM\n",
+	       sdata->dev->name, resp->da);
+#endif /* CONFIG_MAC80211_IBSS_DEBUG */
+	ieee80211_tx_skb(sdata, skb, 0);
+}
+
+static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
+					 struct ieee80211_mgmt *mgmt,
+					 size_t len,
+					 struct ieee80211_rx_status *rx_status)
+{
+	size_t baselen;
+	struct ieee802_11_elems elems;
+
+	if (memcmp(mgmt->da, sdata->dev->dev_addr, ETH_ALEN))
+		return; /* ignore ProbeResp to foreign address */
+
+	baselen = (u8 *) mgmt->u.probe_resp.variable - (u8 *) mgmt;
+	if (baselen > len)
+		return;
+
+	ieee802_11_parse_elems(mgmt->u.probe_resp.variable, len - baselen,
+				&elems);
+
+	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems, false);
+}
+
+static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
+				     struct ieee80211_mgmt *mgmt,
+				     size_t len,
+				     struct ieee80211_rx_status *rx_status)
+{
+	size_t baselen;
+	struct ieee802_11_elems elems;
+
+	/* Process beacon from the current BSS */
+	baselen = (u8 *) mgmt->u.beacon.variable - (u8 *) mgmt;
+	if (baselen > len)
+		return;
+
+	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems);
+
+	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems, true);
+}
+
+static void ieee80211_ibss_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
+					  struct sk_buff *skb)
+{
+	struct ieee80211_rx_status *rx_status;
+	struct ieee80211_mgmt *mgmt;
+	u16 fc;
+
+	rx_status = (struct ieee80211_rx_status *) skb->cb;
+	mgmt = (struct ieee80211_mgmt *) skb->data;
+	fc = le16_to_cpu(mgmt->frame_control);
+
+	switch (fc & IEEE80211_FCTL_STYPE) {
+	case IEEE80211_STYPE_PROBE_REQ:
+		ieee80211_rx_mgmt_probe_req(sdata, mgmt, skb->len);
+		break;
+	case IEEE80211_STYPE_PROBE_RESP:
+		ieee80211_rx_mgmt_probe_resp(sdata, mgmt, skb->len,
+					     rx_status);
+		break;
+	case IEEE80211_STYPE_BEACON:
+		ieee80211_rx_mgmt_beacon(sdata, mgmt, skb->len,
+					 rx_status);
+		break;
+	case IEEE80211_STYPE_AUTH:
+		ieee80211_rx_mgmt_auth_ibss(sdata, mgmt, skb->len);
+		break;
+	}
+
+	kfree_skb(skb);
+}
+
+static void ieee80211_ibss_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data, u.ibss.work);
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_ibss *ifibss;
+	struct sk_buff *skb;
+
+	if (!netif_running(sdata->dev))
+		return;
+
+	if (local->sw_scanning || local->hw_scanning)
+		return;
+
+	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_ADHOC))
+		return;
+	ifibss = &sdata->u.ibss;
+
+	while ((skb = skb_dequeue(&ifibss->skb_queue)))
+		ieee80211_ibss_rx_queued_mgmt(sdata, skb);
+
+	if (!test_and_clear_bit(IEEE80211_IBSS_REQ_RUN, &ifibss->request))
+		return;
+
+	switch (ifibss->state) {
+	case IEEE80211_IBSS_MLME_SEARCH:
+		ieee80211_sta_find_ibss(sdata);
+		break;
+	case IEEE80211_IBSS_MLME_JOINED:
+		ieee80211_sta_merge_ibss(sdata);
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	}
+}
+
+static void ieee80211_ibss_timer(unsigned long data)
+{
+	struct ieee80211_sub_if_data *sdata =
+		(struct ieee80211_sub_if_data *) data;
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct ieee80211_local *local = sdata->local;
+
+	set_bit(IEEE80211_IBSS_REQ_RUN, &ifibss->request);
+	queue_work(local->hw.workqueue, &ifibss->work);
+}
+
+void ieee80211_ibss_setup_sdata(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+
+	INIT_WORK(&ifibss->work, ieee80211_ibss_work);
+	setup_timer(&ifibss->timer, ieee80211_ibss_timer,
+		    (unsigned long) sdata);
+	skb_queue_head_init(&ifibss->skb_queue);
+
+	ifibss->flags |= IEEE80211_IBSS_AUTO_BSSID_SEL |
+			IEEE80211_IBSS_AUTO_CHANNEL_SEL;
+}
+
+int ieee80211_ibss_set_ssid(struct ieee80211_sub_if_data *sdata, char *ssid, size_t len)
+{
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+
+	if (len > IEEE80211_MAX_SSID_LEN)
+		return -EINVAL;
+
+	if (ifibss->ssid_len != len || memcmp(ifibss->ssid, ssid, len) != 0) {
+		memset(ifibss->ssid, 0, sizeof(ifibss->ssid));
+		memcpy(ifibss->ssid, ssid, len);
+		ifibss->ssid_len = len;
+	}
+
+	ifibss->flags &= ~IEEE80211_IBSS_PREV_BSSID_SET;
+
+	if (len)
+		ifibss->flags |= IEEE80211_IBSS_SSID_SET;
+	else
+		ifibss->flags &= ~IEEE80211_IBSS_SSID_SET;
+
+	ifibss->ibss_join_req = jiffies;
+	ifibss->state = IEEE80211_IBSS_MLME_SEARCH;
+	return ieee80211_sta_find_ibss(sdata);
+}
+
+int ieee80211_ibss_get_ssid(struct ieee80211_sub_if_data *sdata, char *ssid, size_t *len)
+{
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+
+	memcpy(ssid, ifibss->ssid, ifibss->ssid_len);
+	*len = ifibss->ssid_len;
+
+	return 0;
+}
+
+int ieee80211_ibss_set_bssid(struct ieee80211_sub_if_data *sdata, u8 *bssid)
+{
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+
+	if (is_valid_ether_addr(bssid)) {
+		memcpy(ifibss->bssid, bssid, ETH_ALEN);
+		ifibss->flags |= IEEE80211_IBSS_BSSID_SET;
+	} else {
+		memset(ifibss->bssid, 0, ETH_ALEN);
+		ifibss->flags &= ~IEEE80211_IBSS_BSSID_SET;
+	}
+
+	if (netif_running(sdata->dev)) {
+		if (ieee80211_if_config(sdata, IEEE80211_IFCC_BSSID)) {
+			printk(KERN_DEBUG "%s: Failed to config new BSSID to "
+			       "the low-level driver\n", sdata->dev->name);
+		}
+	}
+
+	return ieee80211_ibss_set_ssid(sdata, ifibss->ssid, ifibss->ssid_len);
+}
+
+/* scan finished notification */
+void ieee80211_ibss_notify_scan_completed(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
+	struct ieee80211_if_ibss *ifibss;
+
+	if (sdata && sdata->vif.type == NL80211_IFTYPE_ADHOC) {
+		ifibss = &sdata->u.ibss;
+		if ((!(ifibss->flags & IEEE80211_IBSS_PREV_BSSID_SET)) ||
+		    !ieee80211_sta_active_ibss(sdata))
+			ieee80211_sta_find_ibss(sdata);
+	}
+}
+
+ieee80211_rx_result
+ieee80211_ibss_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
+		       struct ieee80211_rx_status *rx_status)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_mgmt *mgmt;
+	u16 fc;
+
+	if (skb->len < 24)
+		return RX_DROP_MONITOR;
+
+	mgmt = (struct ieee80211_mgmt *) skb->data;
+	fc = le16_to_cpu(mgmt->frame_control);
+
+	switch (fc & IEEE80211_FCTL_STYPE) {
+	case IEEE80211_STYPE_PROBE_RESP:
+	case IEEE80211_STYPE_BEACON:
+		memcpy(skb->cb, rx_status, sizeof(*rx_status));
+	case IEEE80211_STYPE_PROBE_REQ:
+	case IEEE80211_STYPE_AUTH:
+		skb_queue_tail(&sdata->u.ibss.skb_queue, skb);
+		queue_work(local->hw.workqueue, &sdata->u.ibss.work);
+		return RX_QUEUED;
+	}
+
+	return RX_DROP_MONITOR;
+}
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-02-15 12:22:49.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-02-15 12:37:29.000000000 +0100
@@ -239,7 +239,7 @@ struct mesh_preq_queue {
 	u8 flags;
 };
 
-/* flags used in struct ieee80211_if_sta.flags */
+/* flags used in struct ieee80211_if_managed.flags */
 #define IEEE80211_STA_SSID_SET		BIT(0)
 #define IEEE80211_STA_BSSID_SET		BIT(1)
 #define IEEE80211_STA_PREV_BSSID_SET	BIT(2)
@@ -262,31 +262,30 @@ struct mesh_preq_queue {
 #define IEEE80211_STA_REQ_AUTH 2
 #define IEEE80211_STA_REQ_RUN  3
 
-/* STA/IBSS MLME states */
-enum ieee80211_sta_mlme_state {
-	IEEE80211_STA_MLME_DISABLED,
-	IEEE80211_STA_MLME_DIRECT_PROBE,
-	IEEE80211_STA_MLME_AUTHENTICATE,
-	IEEE80211_STA_MLME_ASSOCIATE,
-	IEEE80211_STA_MLME_ASSOCIATED,
-	IEEE80211_STA_MLME_IBSS_SEARCH,
-	IEEE80211_STA_MLME_IBSS_JOINED,
-};
-
 /* bitfield of allowed auth algs */
 #define IEEE80211_AUTH_ALG_OPEN BIT(0)
 #define IEEE80211_AUTH_ALG_SHARED_KEY BIT(1)
 #define IEEE80211_AUTH_ALG_LEAP BIT(2)
 
-struct ieee80211_if_sta {
+struct ieee80211_if_managed {
 	struct timer_list timer;
 	struct timer_list chswitch_timer;
 	struct work_struct work;
 	struct work_struct chswitch_work;
+
 	u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
+
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
-	enum ieee80211_sta_mlme_state state;
 	size_t ssid_len;
+
+	enum {
+		IEEE80211_STA_MLME_DISABLED,
+		IEEE80211_STA_MLME_DIRECT_PROBE,
+		IEEE80211_STA_MLME_AUTHENTICATE,
+		IEEE80211_STA_MLME_ASSOCIATE,
+		IEEE80211_STA_MLME_ASSOCIATED,
+	} state;
+
 	u16 aid;
 	u16 ap_capab, capab;
 	u8 *extra_ie; /* to be added to the end of AssocReq */
@@ -319,10 +318,6 @@ struct ieee80211_if_sta {
 		IEEE80211_MFP_REQUIRED
 	} mfp; /* management frame protection */
 
-	unsigned long ibss_join_req;
-	struct sk_buff *probe_resp; /* ProbeResp template for IBSS */
-	u32 supp_rates_bits[IEEE80211_NUM_BANDS];
-
 	int wmm_last_param_set;
 
 	/* Extra IE data for management frames */
@@ -342,6 +337,42 @@ struct ieee80211_if_sta {
 	size_t ie_disassoc_len;
 };
 
+enum ieee80211_ibss_flags {
+	IEEE80211_IBSS_AUTO_CHANNEL_SEL		= BIT(0),
+	IEEE80211_IBSS_AUTO_BSSID_SEL		= BIT(1),
+	IEEE80211_IBSS_BSSID_SET		= BIT(2),
+	IEEE80211_IBSS_PREV_BSSID_SET		= BIT(3),
+	IEEE80211_IBSS_SSID_SET			= BIT(4),
+};
+
+enum ieee80211_ibss_request {
+	IEEE80211_IBSS_REQ_RUN	= 0,
+};
+
+struct ieee80211_if_ibss {
+	struct timer_list timer;
+	struct work_struct work;
+
+	struct sk_buff_head skb_queue;
+
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
+	u8 ssid_len;
+
+	u32 flags;
+
+	u8 bssid[ETH_ALEN];
+
+	unsigned long request;
+
+	unsigned long ibss_join_req;
+	struct sk_buff *probe_resp; /* ProbeResp template for IBSS */
+
+	enum {
+		IEEE80211_IBSS_MLME_SEARCH,
+		IEEE80211_IBSS_MLME_JOINED,
+	} state;
+};
+
 struct ieee80211_if_mesh {
 	struct work_struct work;
 	struct timer_list housekeeping_timer;
@@ -445,7 +476,8 @@ struct ieee80211_sub_if_data {
 		struct ieee80211_if_ap ap;
 		struct ieee80211_if_wds wds;
 		struct ieee80211_if_vlan vlan;
-		struct ieee80211_if_sta sta;
+		struct ieee80211_if_managed mgd;
+		struct ieee80211_if_ibss ibss;
 #ifdef CONFIG_MAC80211_MESH
 		struct ieee80211_if_mesh mesh;
 #endif
@@ -892,34 +924,39 @@ void ieee80211_tx_set_protected(struct i
 void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 				      u32 changed);
 void ieee80211_configure_filter(struct ieee80211_local *local);
+u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata);
 
 /* wireless extensions */
 extern const struct iw_handler_def ieee80211_iw_handler_def;
 
-/* STA/IBSS code */
+/* STA code */
 void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata);
-void ieee80211_scan_work(struct work_struct *work);
-void ieee80211_sta_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
-			   struct ieee80211_rx_status *rx_status);
+ieee80211_rx_result ieee80211_sta_rx_mgmt(struct ieee80211_sub_if_data *sdata,
+					  struct sk_buff *skb,
+					  struct ieee80211_rx_status *rx_status);
 int ieee80211_sta_set_ssid(struct ieee80211_sub_if_data *sdata, char *ssid, size_t len);
 int ieee80211_sta_get_ssid(struct ieee80211_sub_if_data *sdata, char *ssid, size_t *len);
 int ieee80211_sta_set_bssid(struct ieee80211_sub_if_data *sdata, u8 *bssid);
-void ieee80211_sta_req_auth(struct ieee80211_sub_if_data *sdata,
-			    struct ieee80211_if_sta *ifsta);
-struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
-					u8 *bssid, u8 *addr, u32 supp_rates);
+void ieee80211_sta_req_auth(struct ieee80211_sub_if_data *sdata);
 int ieee80211_sta_deauthenticate(struct ieee80211_sub_if_data *sdata, u16 reason);
 int ieee80211_sta_disassociate(struct ieee80211_sub_if_data *sdata, u16 reason);
-u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata);
-u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
-			    struct ieee802_11_elems *elems,
-			    enum ieee80211_band band);
-void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
-			      u8 *ssid, size_t ssid_len);
 void ieee80211_send_pspoll(struct ieee80211_local *local,
 			   struct ieee80211_sub_if_data *sdata);
 
+/* IBSS code */
+int ieee80211_ibss_set_ssid(struct ieee80211_sub_if_data *sdata, char *ssid, size_t len);
+int ieee80211_ibss_get_ssid(struct ieee80211_sub_if_data *sdata, char *ssid, size_t *len);
+int ieee80211_ibss_set_bssid(struct ieee80211_sub_if_data *sdata, u8 *bssid);
+void ieee80211_ibss_notify_scan_completed(struct ieee80211_local *local);
+void ieee80211_ibss_setup_sdata(struct ieee80211_sub_if_data *sdata);
+ieee80211_rx_result
+ieee80211_ibss_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
+		       struct ieee80211_rx_status *rx_status);
+struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
+					u8 *bssid, u8 *addr, u32 supp_rates);
+
 /* scan/BSS handling */
+void ieee80211_scan_work(struct work_struct *work);
 int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
 			   struct cfg80211_scan_request *req);
 int ieee80211_scan_results(struct ieee80211_local *local,
@@ -1051,6 +1088,20 @@ void ieee80211_wake_queue_by_reason(stru
 void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int queue,
 				    enum queue_stop_reason reason);
 
+void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
+			 u16 transaction, u16 auth_alg,
+			 u8 *extra, size_t extra_len,
+			 const u8 *bssid, int encrypt);
+void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
+			      u8 *ssid, size_t ssid_len);
+
+void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
+				  const size_t supp_rates_len,
+				  const u8 *supp_rates);
+u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
+			    struct ieee802_11_elems *elems,
+			    enum ieee80211_band band);
+
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
 #else
--- wireless-testing.orig/net/mac80211/main.c	2009-02-15 12:22:49.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-02-15 12:22:54.000000000 +0100
@@ -169,9 +169,10 @@ int ieee80211_if_config(struct ieee80211
 
 	memset(&conf, 0, sizeof(conf));
 
-	if (sdata->vif.type == NL80211_IFTYPE_STATION ||
-	    sdata->vif.type == NL80211_IFTYPE_ADHOC)
-		conf.bssid = sdata->u.sta.bssid;
+	if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		conf.bssid = sdata->u.mgd.bssid;
+	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		conf.bssid = sdata->u.ibss.bssid;
 	else if (sdata->vif.type == NL80211_IFTYPE_AP)
 		conf.bssid = sdata->dev->dev_addr;
 	else if (ieee80211_vif_is_mesh(&sdata->vif)) {
@@ -210,7 +211,7 @@ int ieee80211_if_config(struct ieee80211
 					!!rcu_dereference(sdata->u.ap.beacon);
 				break;
 			case NL80211_IFTYPE_ADHOC:
-				conf.enable_beacon = !!sdata->u.sta.probe_resp;
+				conf.enable_beacon = !!sdata->u.ibss.probe_resp;
 				break;
 			case NL80211_IFTYPE_MESH_POINT:
 				conf.enable_beacon = true;
--- wireless-testing.orig/net/mac80211/tx.c	2009-02-15 12:22:49.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2009-02-15 12:22:54.000000000 +0100
@@ -1633,7 +1633,7 @@ int ieee80211_subif_start_xmit(struct sk
 	case NL80211_IFTYPE_STATION:
 		fc |= cpu_to_le16(IEEE80211_FCTL_TODS);
 		/* BSSID SA DA */
-		memcpy(hdr.addr1, sdata->u.sta.bssid, ETH_ALEN);
+		memcpy(hdr.addr1, sdata->u.mgd.bssid, ETH_ALEN);
 		memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
 		memcpy(hdr.addr3, skb->data, ETH_ALEN);
 		hdrlen = 24;
@@ -1642,7 +1642,7 @@ int ieee80211_subif_start_xmit(struct sk
 		/* DA SA BSSID */
 		memcpy(hdr.addr1, skb->data, ETH_ALEN);
 		memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
-		memcpy(hdr.addr3, sdata->u.sta.bssid, ETH_ALEN);
+		memcpy(hdr.addr3, sdata->u.ibss.bssid, ETH_ALEN);
 		hdrlen = 24;
 		break;
 	default:
@@ -1928,7 +1928,6 @@ struct sk_buff *ieee80211_beacon_get(str
 	struct ieee80211_tx_info *info;
 	struct ieee80211_sub_if_data *sdata = NULL;
 	struct ieee80211_if_ap *ap = NULL;
-	struct ieee80211_if_sta *ifsta = NULL;
 	struct beacon_data *beacon;
 	struct ieee80211_supported_band *sband;
 	enum ieee80211_band band = local->hw.conf.channel->band;
@@ -1980,13 +1979,13 @@ struct sk_buff *ieee80211_beacon_get(str
 		} else
 			goto out;
 	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
+		struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 		struct ieee80211_hdr *hdr;
-		ifsta = &sdata->u.sta;
 
-		if (!ifsta->probe_resp)
+		if (!ifibss->probe_resp)
 			goto out;
 
-		skb = skb_copy(ifsta->probe_resp, GFP_ATOMIC);
+		skb = skb_copy(ifibss->probe_resp, GFP_ATOMIC);
 		if (!skb)
 			goto out;
 
--- wireless-testing.orig/net/mac80211/wext.c	2009-02-15 12:22:49.000000000 +0100
+++ wireless-testing/net/mac80211/wext.c	2009-02-15 12:22:54.000000000 +0100
@@ -132,13 +132,12 @@ static int ieee80211_ioctl_siwgenie(stru
 	if (sdata->flags & IEEE80211_SDATA_USERSPACE_MLME)
 		return -EOPNOTSUPP;
 
-	if (sdata->vif.type == NL80211_IFTYPE_STATION ||
-	    sdata->vif.type == NL80211_IFTYPE_ADHOC) {
+	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		int ret = ieee80211_sta_set_extra_ie(sdata, extra, data->length);
 		if (ret)
 			return ret;
-		sdata->u.sta.flags &= ~IEEE80211_STA_AUTO_BSSID_SEL;
-		ieee80211_sta_req_auth(sdata, &sdata->u.sta);
+		sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_BSSID_SEL;
+		ieee80211_sta_req_auth(sdata);
 		return 0;
 	}
 
@@ -255,16 +254,19 @@ static int ieee80211_ioctl_siwfreq(struc
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type == NL80211_IFTYPE_ADHOC ||
-	    sdata->vif.type == NL80211_IFTYPE_STATION)
-		sdata->u.sta.flags &= ~IEEE80211_STA_AUTO_CHANNEL_SEL;
+	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		sdata->u.ibss.flags &= ~IEEE80211_IBSS_AUTO_CHANNEL_SEL;
+	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_CHANNEL_SEL;
 
 	/* freq->e == 0: freq->m = channel; otherwise freq = m * 10^e */
 	if (freq->e == 0) {
 		if (freq->m < 0) {
-			if (sdata->vif.type == NL80211_IFTYPE_ADHOC ||
-			    sdata->vif.type == NL80211_IFTYPE_STATION)
-				sdata->u.sta.flags |=
+			if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+				sdata->u.ibss.flags |=
+					IEEE80211_IBSS_AUTO_CHANNEL_SEL;
+			else if (sdata->vif.type == NL80211_IFTYPE_STATION)
+				sdata->u.mgd.flags |=
 					IEEE80211_STA_AUTO_CHANNEL_SEL;
 			return 0;
 		} else
@@ -301,32 +303,35 @@ static int ieee80211_ioctl_siwessid(stru
 {
 	struct ieee80211_sub_if_data *sdata;
 	size_t len = data->length;
+	int ret;
 
 	/* iwconfig uses nul termination in SSID.. */
 	if (len > 0 && ssid[len - 1] == '\0')
 		len--;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (sdata->vif.type == NL80211_IFTYPE_STATION ||
-	    sdata->vif.type == NL80211_IFTYPE_ADHOC) {
-		int ret;
+	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		if (sdata->flags & IEEE80211_SDATA_USERSPACE_MLME) {
 			if (len > IEEE80211_MAX_SSID_LEN)
 				return -EINVAL;
-			memcpy(sdata->u.sta.ssid, ssid, len);
-			sdata->u.sta.ssid_len = len;
+			memcpy(sdata->u.mgd.ssid, ssid, len);
+			sdata->u.mgd.ssid_len = len;
 			return 0;
 		}
+
 		if (data->flags)
-			sdata->u.sta.flags &= ~IEEE80211_STA_AUTO_SSID_SEL;
+			sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_SSID_SEL;
 		else
-			sdata->u.sta.flags |= IEEE80211_STA_AUTO_SSID_SEL;
+			sdata->u.mgd.flags |= IEEE80211_STA_AUTO_SSID_SEL;
+
 		ret = ieee80211_sta_set_ssid(sdata, ssid, len);
 		if (ret)
 			return ret;
-		ieee80211_sta_req_auth(sdata, &sdata->u.sta);
+
+		ieee80211_sta_req_auth(sdata);
 		return 0;
-	}
+	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		return ieee80211_ibss_set_ssid(sdata, ssid, len);
 
 	return -EOPNOTSUPP;
 }
@@ -340,8 +345,7 @@ static int ieee80211_ioctl_giwessid(stru
 
 	struct ieee80211_sub_if_data *sdata;
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (sdata->vif.type == NL80211_IFTYPE_STATION ||
-	    sdata->vif.type == NL80211_IFTYPE_ADHOC) {
+	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		int res = ieee80211_sta_get_ssid(sdata, ssid, &len);
 		if (res == 0) {
 			data->length = len;
@@ -349,6 +353,14 @@ static int ieee80211_ioctl_giwessid(stru
 		} else
 			data->flags = 0;
 		return res;
+	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
+		int res = ieee80211_ibss_get_ssid(sdata, ssid, &len);
+		if (res == 0) {
+			data->length = len;
+			data->flags = 1;
+		} else
+			data->flags = 0;
+		return res;
 	}
 
 	return -EOPNOTSUPP;
@@ -362,26 +374,35 @@ static int ieee80211_ioctl_siwap(struct 
 	struct ieee80211_sub_if_data *sdata;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (sdata->vif.type == NL80211_IFTYPE_STATION ||
-	    sdata->vif.type == NL80211_IFTYPE_ADHOC) {
+	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		int ret;
 		if (sdata->flags & IEEE80211_SDATA_USERSPACE_MLME) {
-			memcpy(sdata->u.sta.bssid, (u8 *) &ap_addr->sa_data,
+			memcpy(sdata->u.mgd.bssid, (u8 *) &ap_addr->sa_data,
 			       ETH_ALEN);
 			return 0;
 		}
 		if (is_zero_ether_addr((u8 *) &ap_addr->sa_data))
-			sdata->u.sta.flags |= IEEE80211_STA_AUTO_BSSID_SEL |
+			sdata->u.mgd.flags |= IEEE80211_STA_AUTO_BSSID_SEL |
 				IEEE80211_STA_AUTO_CHANNEL_SEL;
 		else if (is_broadcast_ether_addr((u8 *) &ap_addr->sa_data))
-			sdata->u.sta.flags |= IEEE80211_STA_AUTO_BSSID_SEL;
+			sdata->u.mgd.flags |= IEEE80211_STA_AUTO_BSSID_SEL;
 		else
-			sdata->u.sta.flags &= ~IEEE80211_STA_AUTO_BSSID_SEL;
+			sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_BSSID_SEL;
 		ret = ieee80211_sta_set_bssid(sdata, (u8 *) &ap_addr->sa_data);
 		if (ret)
 			return ret;
-		ieee80211_sta_req_auth(sdata, &sdata->u.sta);
+		ieee80211_sta_req_auth(sdata);
 		return 0;
+	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
+		if (is_zero_ether_addr((u8 *) &ap_addr->sa_data))
+			sdata->u.ibss.flags |= IEEE80211_IBSS_AUTO_BSSID_SEL |
+					       IEEE80211_IBSS_AUTO_CHANNEL_SEL;
+		else if (is_broadcast_ether_addr((u8 *) &ap_addr->sa_data))
+			sdata->u.ibss.flags |= IEEE80211_IBSS_AUTO_BSSID_SEL;
+		else
+			sdata->u.ibss.flags &= ~IEEE80211_IBSS_AUTO_BSSID_SEL;
+
+		return ieee80211_ibss_set_bssid(sdata, (u8 *) &ap_addr->sa_data);
 	} else if (sdata->vif.type == NL80211_IFTYPE_WDS) {
 		/*
 		 * If it is necessary to update the WDS peer address
@@ -410,17 +431,20 @@ static int ieee80211_ioctl_giwap(struct 
 	struct ieee80211_sub_if_data *sdata;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (sdata->vif.type == NL80211_IFTYPE_STATION ||
-	    sdata->vif.type == NL80211_IFTYPE_ADHOC) {
-		if (sdata->u.sta.state == IEEE80211_STA_MLME_ASSOCIATED ||
-		    sdata->u.sta.state == IEEE80211_STA_MLME_IBSS_JOINED) {
+	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+		if (sdata->u.mgd.state == IEEE80211_STA_MLME_ASSOCIATED) {
 			ap_addr->sa_family = ARPHRD_ETHER;
-			memcpy(&ap_addr->sa_data, sdata->u.sta.bssid, ETH_ALEN);
-			return 0;
-		} else {
+			memcpy(&ap_addr->sa_data, sdata->u.mgd.bssid, ETH_ALEN);
+		} else
 			memset(&ap_addr->sa_data, 0, ETH_ALEN);
-			return 0;
-		}
+		return 0;
+	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
+		if (sdata->u.ibss.state == IEEE80211_IBSS_MLME_JOINED) {
+			ap_addr->sa_family = ARPHRD_ETHER;
+			memcpy(&ap_addr->sa_data, sdata->u.ibss.bssid, ETH_ALEN);
+		} else
+			memset(&ap_addr->sa_data, 0, ETH_ALEN);
+		return 0;
 	} else if (sdata->vif.type == NL80211_IFTYPE_WDS) {
 		ap_addr->sa_family = ARPHRD_ETHER;
 		memcpy(&ap_addr->sa_data, sdata->u.wds.remote_addr, ETH_ALEN);
@@ -486,7 +510,7 @@ static int ieee80211_ioctl_giwrate(struc
 
 	rcu_read_lock();
 
-	sta = sta_info_get(local, sdata->u.sta.bssid);
+	sta = sta_info_get(local, sdata->u.mgd.bssid);
 
 	if (sta && !(sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS))
 		rate->value = sband->bitrates[sta->last_tx_rate.idx].bitrate;
@@ -687,8 +711,7 @@ static int ieee80211_ioctl_siwmlme(struc
 	struct iw_mlme *mlme = (struct iw_mlme *) extra;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
-	    sdata->vif.type != NL80211_IFTYPE_ADHOC)
+	if (!(sdata->vif.type == NL80211_IFTYPE_STATION))
 		return -EINVAL;
 
 	switch (mlme->cmd) {
@@ -784,8 +807,7 @@ static int ieee80211_ioctl_giwencode(str
 	erq->flags |= IW_ENCODE_ENABLED;
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-		struct ieee80211_if_sta *ifsta = &sdata->u.sta;
-		switch (ifsta->auth_alg) {
+		switch (sdata->u.mgd.auth_alg) {
 		case WLAN_AUTH_OPEN:
 		case WLAN_AUTH_LEAP:
 			erq->flags |= IW_ENCODE_OPEN;
@@ -849,7 +871,7 @@ static int ieee80211_ioctl_siwpower(stru
 		ret = ieee80211_hw_config(local,
 					  IEEE80211_CONF_CHANGE_DYNPS_TIMEOUT);
 
-	if (!(sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED))
+	if (!(sdata->u.mgd.flags & IEEE80211_STA_ASSOCIATED))
 		return ret;
 
 	if (conf->dynamic_ps_timeout > 0 &&
@@ -908,10 +930,10 @@ static int ieee80211_ioctl_siwauth(struc
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 			if (data->value & (IW_AUTH_CIPHER_WEP40 |
 			    IW_AUTH_CIPHER_WEP104 | IW_AUTH_CIPHER_TKIP))
-				sdata->u.sta.flags |=
+				sdata->u.mgd.flags |=
 					IEEE80211_STA_TKIP_WEP_USED;
 			else
-				sdata->u.sta.flags &=
+				sdata->u.mgd.flags &=
 					~IEEE80211_STA_TKIP_WEP_USED;
 		}
 		break;
@@ -922,21 +944,20 @@ static int ieee80211_ioctl_siwauth(struc
 		if (sdata->vif.type != NL80211_IFTYPE_STATION)
 			ret = -EINVAL;
 		else {
-			sdata->u.sta.flags &= ~IEEE80211_STA_PRIVACY_INVOKED;
+			sdata->u.mgd.flags &= ~IEEE80211_STA_PRIVACY_INVOKED;
 			/*
 			 * Privacy invoked by wpa_supplicant, store the
 			 * value and allow associating to a protected
 			 * network without having a key up front.
 			 */
 			if (data->value)
-				sdata->u.sta.flags |=
+				sdata->u.mgd.flags |=
 					IEEE80211_STA_PRIVACY_INVOKED;
 		}
 		break;
 	case IW_AUTH_80211_AUTH_ALG:
-		if (sdata->vif.type == NL80211_IFTYPE_STATION ||
-		    sdata->vif.type == NL80211_IFTYPE_ADHOC)
-			sdata->u.sta.auth_algs = data->value;
+		if (sdata->vif.type == NL80211_IFTYPE_STATION)
+			sdata->u.mgd.auth_algs = data->value;
 		else
 			ret = -EOPNOTSUPP;
 		break;
@@ -945,17 +966,16 @@ static int ieee80211_ioctl_siwauth(struc
 			ret = -EOPNOTSUPP;
 			break;
 		}
-		if (sdata->vif.type == NL80211_IFTYPE_STATION ||
-		    sdata->vif.type == NL80211_IFTYPE_ADHOC) {
+		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 			switch (data->value) {
 			case IW_AUTH_MFP_DISABLED:
-				sdata->u.sta.mfp = IEEE80211_MFP_DISABLED;
+				sdata->u.mgd.mfp = IEEE80211_MFP_DISABLED;
 				break;
 			case IW_AUTH_MFP_OPTIONAL:
-				sdata->u.sta.mfp = IEEE80211_MFP_OPTIONAL;
+				sdata->u.mgd.mfp = IEEE80211_MFP_OPTIONAL;
 				break;
 			case IW_AUTH_MFP_REQUIRED:
-				sdata->u.sta.mfp = IEEE80211_MFP_REQUIRED;
+				sdata->u.mgd.mfp = IEEE80211_MFP_REQUIRED;
 				break;
 			default:
 				ret = -EINVAL;
@@ -980,9 +1000,9 @@ static struct iw_statistics *ieee80211_g
 
 	rcu_read_lock();
 
-	if (sdata->vif.type == NL80211_IFTYPE_STATION ||
-	    sdata->vif.type == NL80211_IFTYPE_ADHOC)
-		sta = sta_info_get(local, sdata->u.sta.bssid);
+	if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		sta = sta_info_get(local, sdata->u.mgd.bssid);
+
 	if (!sta) {
 		wstats->discard.fragment = 0;
 		wstats->discard.misc = 0;
@@ -1011,9 +1031,8 @@ static int ieee80211_ioctl_giwauth(struc
 
 	switch (data->flags & IW_AUTH_INDEX) {
 	case IW_AUTH_80211_AUTH_ALG:
-		if (sdata->vif.type == NL80211_IFTYPE_STATION ||
-		    sdata->vif.type == NL80211_IFTYPE_ADHOC)
-			data->value = sdata->u.sta.auth_algs;
+		if (sdata->vif.type == NL80211_IFTYPE_STATION)
+			data->value = sdata->u.mgd.auth_algs;
 		else
 			ret = -EOPNOTSUPP;
 		break;
--- wireless-testing.orig/net/mac80211/agg-rx.c	2009-02-15 12:22:49.000000000 +0100
+++ wireless-testing/net/mac80211/agg-rx.c	2009-02-15 12:22:54.000000000 +0100
@@ -129,7 +129,6 @@ static void ieee80211_send_addba_resp(st
 				      u8 dialog_token, u16 status, u16 policy,
 				      u16 buf_size, u16 timeout)
 {
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
@@ -151,8 +150,9 @@ static void ieee80211_send_addba_resp(st
 	if (sdata->vif.type == NL80211_IFTYPE_AP ||
 	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		memcpy(mgmt->bssid, sdata->dev->dev_addr, ETH_ALEN);
-	else
-		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
+	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
+
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
 
--- wireless-testing.orig/net/mac80211/agg-tx.c	2009-02-15 12:22:49.000000000 +0100
+++ wireless-testing/net/mac80211/agg-tx.c	2009-02-15 12:22:54.000000000 +0100
@@ -49,7 +49,6 @@ static void ieee80211_send_addba_request
 					 u16 agg_size, u16 timeout)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	u16 capab;
@@ -69,8 +68,8 @@ static void ieee80211_send_addba_request
 	if (sdata->vif.type == NL80211_IFTYPE_AP ||
 	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		memcpy(mgmt->bssid, sdata->dev->dev_addr, ETH_ALEN);
-	else
-		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
+	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
 
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
--- wireless-testing.orig/net/mac80211/ht.c	2009-02-15 12:22:49.000000000 +0100
+++ wireless-testing/net/mac80211/ht.c	2009-02-15 12:22:54.000000000 +0100
@@ -169,7 +169,6 @@ void ieee80211_send_delba(struct ieee802
 			  u16 initiator, u16 reason_code)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	u16 params;
@@ -190,8 +189,9 @@ void ieee80211_send_delba(struct ieee802
 	if (sdata->vif.type == NL80211_IFTYPE_AP ||
 	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		memcpy(mgmt->bssid, sdata->dev->dev_addr, ETH_ALEN);
-	else
-		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
+	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
+
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
 
--- wireless-testing.orig/net/mac80211/scan.c	2009-02-15 12:22:49.000000000 +0100
+++ wireless-testing/net/mac80211/scan.c	2009-02-15 12:22:54.000000000 +0100
@@ -207,36 +207,6 @@ ieee80211_scan_rx(struct ieee80211_sub_i
 	return RX_QUEUED;
 }
 
-void ieee80211_send_nullfunc(struct ieee80211_local *local,
-				    struct ieee80211_sub_if_data *sdata,
-				    int powersave)
-{
-	struct sk_buff *skb;
-	struct ieee80211_hdr *nullfunc;
-	__le16 fc;
-
-	skb = dev_alloc_skb(local->hw.extra_tx_headroom + 24);
-	if (!skb) {
-		printk(KERN_DEBUG "%s: failed to allocate buffer for nullfunc "
-		       "frame\n", sdata->dev->name);
-		return;
-	}
-	skb_reserve(skb, local->hw.extra_tx_headroom);
-
-	nullfunc = (struct ieee80211_hdr *) skb_put(skb, 24);
-	memset(nullfunc, 0, 24);
-	fc = cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_NULLFUNC |
-			 IEEE80211_FCTL_TODS);
-	if (powersave)
-		fc |= cpu_to_le16(IEEE80211_FCTL_PM);
-	nullfunc->frame_control = fc;
-	memcpy(nullfunc->addr1, sdata->u.sta.bssid, ETH_ALEN);
-	memcpy(nullfunc->addr2, sdata->dev->dev_addr, ETH_ALEN);
-	memcpy(nullfunc->addr3, sdata->u.sta.bssid, ETH_ALEN);
-
-	ieee80211_tx_skb(sdata, skb, 0);
-}
-
 void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
@@ -287,7 +257,7 @@ void ieee80211_scan_completed(struct iee
 
 		/* Tell AP we're back */
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-			if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {
+			if (sdata->u.mgd.flags & IEEE80211_STA_ASSOCIATED) {
 				ieee80211_send_nullfunc(local, sdata, 0);
 				netif_tx_wake_all_queues(sdata->dev);
 			}
@@ -305,6 +275,7 @@ void ieee80211_scan_completed(struct iee
 
  done:
 	ieee80211_mlme_notify_scan_completed(local);
+	ieee80211_ibss_notify_scan_completed(local);
 	ieee80211_mesh_notify_scan_completed(local);
 }
 EXPORT_SYMBOL(ieee80211_scan_completed);
@@ -442,7 +413,7 @@ int ieee80211_start_scan(struct ieee8021
 					    IEEE80211_IFCC_BEACON_ENABLED);
 
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-			if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {
+			if (sdata->u.mgd.flags & IEEE80211_STA_ASSOCIATED) {
 				netif_tx_stop_all_queues(sdata->dev);
 				ieee80211_send_nullfunc(local, sdata, 1);
 			}
@@ -477,7 +448,7 @@ int ieee80211_request_scan(struct ieee80
 			   struct cfg80211_scan_request *req)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_if_sta *ifsta;
+	struct ieee80211_if_managed *ifmgd;
 
 	if (!req)
 		return -EINVAL;
@@ -502,9 +473,9 @@ int ieee80211_request_scan(struct ieee80
 		return -EBUSY;
 	}
 
-	ifsta = &sdata->u.sta;
-	set_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request);
-	queue_work(local->hw.workqueue, &ifsta->work);
+	ifmgd = &sdata->u.mgd;
+	set_bit(IEEE80211_STA_REQ_SCAN, &ifmgd->request);
+	queue_work(local->hw.workqueue, &ifmgd->work);
 
 	return 0;
 }
--- wireless-testing.orig/net/mac80211/iface.c	2009-02-15 12:22:49.000000000 +0100
+++ wireless-testing/net/mac80211/iface.c	2009-02-15 12:22:54.000000000 +0100
@@ -236,7 +236,10 @@ static int ieee80211_open(struct net_dev
 		break;
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
-		sdata->u.sta.flags &= ~IEEE80211_STA_PREV_BSSID_SET;
+		if (sdata->vif.type == NL80211_IFTYPE_STATION)
+			sdata->u.mgd.flags &= ~IEEE80211_STA_PREV_BSSID_SET;
+		else
+			sdata->u.ibss.flags &= ~IEEE80211_IBSS_PREV_BSSID_SET;
 		/* fall through */
 	default:
 		conf.vif = &sdata->vif;
@@ -321,11 +324,10 @@ static int ieee80211_open(struct net_dev
 	 * yet be effective. Trigger execution of ieee80211_sta_work
 	 * to fix this.
 	 */
-	if (sdata->vif.type == NL80211_IFTYPE_STATION ||
-	    sdata->vif.type == NL80211_IFTYPE_ADHOC) {
-		struct ieee80211_if_sta *ifsta = &sdata->u.sta;
-		queue_work(local->hw.workqueue, &ifsta->work);
-	}
+	if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		queue_work(local->hw.workqueue, &sdata->u.mgd.work);
+	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		queue_work(local->hw.workqueue, &sdata->u.ibss.work);
 
 	netif_tx_start_all_queues(dev);
 
@@ -452,15 +454,13 @@ static int ieee80211_stop(struct net_dev
 		netif_addr_unlock_bh(local->mdev);
 		break;
 	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_ADHOC:
 		/* Announce that we are leaving the network. */
-		if (sdata->u.sta.state != IEEE80211_STA_MLME_DISABLED)
+		if (sdata->u.mgd.state != IEEE80211_STA_MLME_DISABLED)
 			ieee80211_sta_deauthenticate(sdata,
 						WLAN_REASON_DEAUTH_LEAVING);
-
-		memset(sdata->u.sta.bssid, 0, ETH_ALEN);
-		del_timer_sync(&sdata->u.sta.chswitch_timer);
-		del_timer_sync(&sdata->u.sta.timer);
+		memset(sdata->u.mgd.bssid, 0, ETH_ALEN);
+		del_timer_sync(&sdata->u.mgd.chswitch_timer);
+		del_timer_sync(&sdata->u.mgd.timer);
 		/*
 		 * If the timer fired while we waited for it, it will have
 		 * requeued the work. Now the work will be running again
@@ -468,8 +468,8 @@ static int ieee80211_stop(struct net_dev
 		 * whether the interface is running, which, at this point,
 		 * it no longer is.
 		 */
-		cancel_work_sync(&sdata->u.sta.work);
-		cancel_work_sync(&sdata->u.sta.chswitch_work);
+		cancel_work_sync(&sdata->u.mgd.work);
+		cancel_work_sync(&sdata->u.mgd.chswitch_work);
 		/*
 		 * When we get here, the interface is marked down.
 		 * Call synchronize_rcu() to wait for the RX path
@@ -477,13 +477,22 @@ static int ieee80211_stop(struct net_dev
 		 * frames at this very time on another CPU.
 		 */
 		synchronize_rcu();
-		skb_queue_purge(&sdata->u.sta.skb_queue);
+		skb_queue_purge(&sdata->u.mgd.skb_queue);
 
-		sdata->u.sta.flags &= ~(IEEE80211_STA_PRIVACY_INVOKED |
+		sdata->u.mgd.flags &= ~(IEEE80211_STA_PRIVACY_INVOKED |
 					IEEE80211_STA_TKIP_WEP_USED);
-		kfree(sdata->u.sta.extra_ie);
-		sdata->u.sta.extra_ie = NULL;
-		sdata->u.sta.extra_ie_len = 0;
+		kfree(sdata->u.mgd.extra_ie);
+		sdata->u.mgd.extra_ie = NULL;
+		sdata->u.mgd.extra_ie_len = 0;
+		/* fall through */
+	case NL80211_IFTYPE_ADHOC:
+		if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
+			memset(sdata->u.ibss.bssid, 0, ETH_ALEN);
+			del_timer_sync(&sdata->u.ibss.timer);
+			cancel_work_sync(&sdata->u.ibss.work);
+			synchronize_rcu();
+			skb_queue_purge(&sdata->u.ibss.skb_queue);
+		}
 		/* fall through */
 	case NL80211_IFTYPE_MESH_POINT:
 		if (ieee80211_vif_is_mesh(&sdata->vif)) {
@@ -629,19 +638,20 @@ static void ieee80211_teardown_sdata(str
 		if (ieee80211_vif_is_mesh(&sdata->vif))
 			mesh_rmc_free(sdata);
 		break;
-	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
-		kfree(sdata->u.sta.extra_ie);
-		kfree(sdata->u.sta.assocreq_ies);
-		kfree(sdata->u.sta.assocresp_ies);
-		kfree_skb(sdata->u.sta.probe_resp);
-		kfree(sdata->u.sta.ie_probereq);
-		kfree(sdata->u.sta.ie_proberesp);
-		kfree(sdata->u.sta.ie_auth);
-		kfree(sdata->u.sta.ie_assocreq);
-		kfree(sdata->u.sta.ie_reassocreq);
-		kfree(sdata->u.sta.ie_deauth);
-		kfree(sdata->u.sta.ie_disassoc);
+		kfree_skb(sdata->u.ibss.probe_resp);
+		break;
+	case NL80211_IFTYPE_STATION:
+		kfree(sdata->u.mgd.extra_ie);
+		kfree(sdata->u.mgd.assocreq_ies);
+		kfree(sdata->u.mgd.assocresp_ies);
+		kfree(sdata->u.mgd.ie_probereq);
+		kfree(sdata->u.mgd.ie_proberesp);
+		kfree(sdata->u.mgd.ie_auth);
+		kfree(sdata->u.mgd.ie_assocreq);
+		kfree(sdata->u.mgd.ie_reassocreq);
+		kfree(sdata->u.mgd.ie_deauth);
+		kfree(sdata->u.mgd.ie_disassoc);
 		break;
 	case NL80211_IFTYPE_WDS:
 	case NL80211_IFTYPE_AP_VLAN:
@@ -708,9 +718,11 @@ static void ieee80211_setup_sdata(struct
 		INIT_LIST_HEAD(&sdata->u.ap.vlans);
 		break;
 	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_ADHOC:
 		ieee80211_sta_setup_sdata(sdata);
 		break;
+	case NL80211_IFTYPE_ADHOC:
+		ieee80211_ibss_setup_sdata(sdata);
+		break;
 	case NL80211_IFTYPE_MESH_POINT:
 		if (ieee80211_vif_is_mesh(&sdata->vif))
 			ieee80211_mesh_init_sdata(sdata);
--- wireless-testing.orig/net/mac80211/mlme.c	2009-02-15 12:22:49.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-02-15 12:22:54.000000000 +0100
@@ -15,11 +15,8 @@
 #include <linux/if_ether.h>
 #include <linux/skbuff.h>
 #include <linux/if_arp.h>
-#include <linux/wireless.h>
-#include <linux/random.h>
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
-#include <net/iw_handler.h>
 #include <net/mac80211.h>
 #include <asm/unaligned.h>
 
@@ -35,15 +32,6 @@
 #define IEEE80211_MONITORING_INTERVAL (2 * HZ)
 #define IEEE80211_PROBE_INTERVAL (60 * HZ)
 #define IEEE80211_RETRY_AUTH_INTERVAL (1 * HZ)
-#define IEEE80211_SCAN_INTERVAL (2 * HZ)
-#define IEEE80211_SCAN_INTERVAL_SLOW (15 * HZ)
-#define IEEE80211_IBSS_JOIN_TIMEOUT (7 * HZ)
-
-#define IEEE80211_IBSS_MERGE_INTERVAL (30 * HZ)
-#define IEEE80211_IBSS_INACTIVITY_LIMIT (60 * HZ)
-
-#define IEEE80211_IBSS_MAX_STA_ENTRIES 128
-
 
 /* utils */
 static int ecw2cw(int ecw)
@@ -92,43 +80,6 @@ static int ieee80211_compatible_rates(st
 	return count;
 }
 
-/* also used by mesh code */
-u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
-			    struct ieee802_11_elems *elems,
-			    enum ieee80211_band band)
-{
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_rate *bitrates;
-	size_t num_rates;
-	u32 supp_rates;
-	int i, j;
-	sband = local->hw.wiphy->bands[band];
-
-	if (!sband) {
-		WARN_ON(1);
-		sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-	}
-
-	bitrates = sband->bitrates;
-	num_rates = sband->n_bitrates;
-	supp_rates = 0;
-	for (i = 0; i < elems->supp_rates_len +
-		     elems->ext_supp_rates_len; i++) {
-		u8 rate = 0;
-		int own_rate;
-		if (i < elems->supp_rates_len)
-			rate = elems->supp_rates[i];
-		else if (elems->ext_supp_rates)
-			rate = elems->ext_supp_rates
-				[i - elems->supp_rates_len];
-		own_rate = 5 * (rate & 0x7f);
-		for (j = 0; j < num_rates; j++)
-			if (bitrates[j].bitrate == own_rate)
-				supp_rates |= BIT(j);
-	}
-	return supp_rates;
-}
-
 /* frame sending functions */
 
 static void add_extra_ies(struct sk_buff *skb, u8 *ies, size_t ies_len)
@@ -137,113 +88,9 @@ static void add_extra_ies(struct sk_buff
 		memcpy(skb_put(skb, ies_len), ies, ies_len);
 }
 
-/* also used by scanning code */
-void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
-			      u8 *ssid, size_t ssid_len)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_supported_band *sband;
-	struct sk_buff *skb;
-	struct ieee80211_mgmt *mgmt;
-	u8 *pos, *supp_rates, *esupp_rates = NULL;
-	int i;
-
-	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*mgmt) + 200 +
-			    sdata->u.sta.ie_probereq_len);
-	if (!skb) {
-		printk(KERN_DEBUG "%s: failed to allocate buffer for probe "
-		       "request\n", sdata->dev->name);
-		return;
-	}
-	skb_reserve(skb, local->hw.extra_tx_headroom);
-
-	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
-	memset(mgmt, 0, 24);
-	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-					  IEEE80211_STYPE_PROBE_REQ);
-	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
-	if (dst) {
-		memcpy(mgmt->da, dst, ETH_ALEN);
-		memcpy(mgmt->bssid, dst, ETH_ALEN);
-	} else {
-		memset(mgmt->da, 0xff, ETH_ALEN);
-		memset(mgmt->bssid, 0xff, ETH_ALEN);
-	}
-	pos = skb_put(skb, 2 + ssid_len);
-	*pos++ = WLAN_EID_SSID;
-	*pos++ = ssid_len;
-	memcpy(pos, ssid, ssid_len);
-
-	supp_rates = skb_put(skb, 2);
-	supp_rates[0] = WLAN_EID_SUPP_RATES;
-	supp_rates[1] = 0;
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-
-	for (i = 0; i < sband->n_bitrates; i++) {
-		struct ieee80211_rate *rate = &sband->bitrates[i];
-		if (esupp_rates) {
-			pos = skb_put(skb, 1);
-			esupp_rates[1]++;
-		} else if (supp_rates[1] == 8) {
-			esupp_rates = skb_put(skb, 3);
-			esupp_rates[0] = WLAN_EID_EXT_SUPP_RATES;
-			esupp_rates[1] = 1;
-			pos = &esupp_rates[2];
-		} else {
-			pos = skb_put(skb, 1);
-			supp_rates[1]++;
-		}
-		*pos = rate->bitrate / 5;
-	}
-
-	add_extra_ies(skb, sdata->u.sta.ie_probereq,
-		      sdata->u.sta.ie_probereq_len);
-
-	ieee80211_tx_skb(sdata, skb, 0);
-}
-
-static void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
-				struct ieee80211_if_sta *ifsta,
-				int transaction, u8 *extra, size_t extra_len,
-				int encrypt)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct sk_buff *skb;
-	struct ieee80211_mgmt *mgmt;
-
-	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
-			    sizeof(*mgmt) + 6 + extra_len +
-			    sdata->u.sta.ie_auth_len);
-	if (!skb) {
-		printk(KERN_DEBUG "%s: failed to allocate buffer for auth "
-		       "frame\n", sdata->dev->name);
-		return;
-	}
-	skb_reserve(skb, local->hw.extra_tx_headroom);
-
-	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24 + 6);
-	memset(mgmt, 0, 24 + 6);
-	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-					  IEEE80211_STYPE_AUTH);
-	if (encrypt)
-		mgmt->frame_control |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
-	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
-	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
-	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
-	mgmt->u.auth.auth_alg = cpu_to_le16(ifsta->auth_alg);
-	mgmt->u.auth.auth_transaction = cpu_to_le16(transaction);
-	ifsta->auth_transaction = transaction + 1;
-	mgmt->u.auth.status_code = cpu_to_le16(0);
-	if (extra)
-		memcpy(skb_put(skb, extra_len), extra, extra_len);
-	add_extra_ies(skb, sdata->u.sta.ie_auth, sdata->u.sta.ie_auth_len);
-
-	ieee80211_tx_skb(sdata, skb, encrypt);
-}
-
-static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
-				 struct ieee80211_if_sta *ifsta)
+static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 {
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
@@ -256,17 +103,17 @@ static void ieee80211_send_assoc(struct 
 	u32 rates = 0;
 	size_t e_ies_len;
 
-	if (ifsta->flags & IEEE80211_STA_PREV_BSSID_SET) {
-		e_ies = sdata->u.sta.ie_reassocreq;
-		e_ies_len = sdata->u.sta.ie_reassocreq_len;
+	if (ifmgd->flags & IEEE80211_IBSS_PREV_BSSID_SET) {
+		e_ies = sdata->u.mgd.ie_reassocreq;
+		e_ies_len = sdata->u.mgd.ie_reassocreq_len;
 	} else {
-		e_ies = sdata->u.sta.ie_assocreq;
-		e_ies_len = sdata->u.sta.ie_assocreq_len;
+		e_ies = sdata->u.mgd.ie_assocreq;
+		e_ies_len = sdata->u.mgd.ie_assocreq_len;
 	}
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
-			    sizeof(*mgmt) + 200 + ifsta->extra_ie_len +
-			    ifsta->ssid_len + e_ies_len);
+			    sizeof(*mgmt) + 200 + ifmgd->extra_ie_len +
+			    ifmgd->ssid_len + e_ies_len);
 	if (!skb) {
 		printk(KERN_DEBUG "%s: failed to allocate buffer for assoc "
 		       "frame\n", sdata->dev->name);
@@ -276,7 +123,7 @@ static void ieee80211_send_assoc(struct 
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
-	capab = ifsta->capab;
+	capab = ifmgd->capab;
 
 	if (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ) {
 		if (!(local->hw.flags & IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE))
@@ -285,9 +132,9 @@ static void ieee80211_send_assoc(struct 
 			capab |= WLAN_CAPABILITY_SHORT_PREAMBLE;
 	}
 
-	bss = ieee80211_rx_bss_get(local, ifsta->bssid,
+	bss = ieee80211_rx_bss_get(local, ifmgd->bssid,
 				   local->hw.conf.channel->center_freq,
-				   ifsta->ssid, ifsta->ssid_len);
+				   ifmgd->ssid, ifmgd->ssid_len);
 	if (bss) {
 		if (bss->cbss.capability & WLAN_CAPABILITY_PRIVACY)
 			capab |= WLAN_CAPABILITY_PRIVACY;
@@ -312,18 +159,18 @@ static void ieee80211_send_assoc(struct 
 
 	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
 	memset(mgmt, 0, 24);
-	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
+	memcpy(mgmt->da, ifmgd->bssid, ETH_ALEN);
 	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
-	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
+	memcpy(mgmt->bssid, ifmgd->bssid, ETH_ALEN);
 
-	if (ifsta->flags & IEEE80211_STA_PREV_BSSID_SET) {
+	if (ifmgd->flags & IEEE80211_STA_PREV_BSSID_SET) {
 		skb_put(skb, 10);
 		mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 						  IEEE80211_STYPE_REASSOC_REQ);
 		mgmt->u.reassoc_req.capab_info = cpu_to_le16(capab);
 		mgmt->u.reassoc_req.listen_interval =
 				cpu_to_le16(local->hw.conf.listen_interval);
-		memcpy(mgmt->u.reassoc_req.current_ap, ifsta->prev_bssid,
+		memcpy(mgmt->u.reassoc_req.current_ap, ifmgd->prev_bssid,
 		       ETH_ALEN);
 	} else {
 		skb_put(skb, 4);
@@ -335,10 +182,10 @@ static void ieee80211_send_assoc(struct 
 	}
 
 	/* SSID */
-	ies = pos = skb_put(skb, 2 + ifsta->ssid_len);
+	ies = pos = skb_put(skb, 2 + ifmgd->ssid_len);
 	*pos++ = WLAN_EID_SSID;
-	*pos++ = ifsta->ssid_len;
-	memcpy(pos, ifsta->ssid, ifsta->ssid_len);
+	*pos++ = ifmgd->ssid_len;
+	memcpy(pos, ifmgd->ssid, ifmgd->ssid_len);
 
 	/* add all rates which were marked to be used above */
 	supp_rates_len = rates_len;
@@ -393,12 +240,12 @@ static void ieee80211_send_assoc(struct 
 		}
 	}
 
-	if (ifsta->extra_ie) {
-		pos = skb_put(skb, ifsta->extra_ie_len);
-		memcpy(pos, ifsta->extra_ie, ifsta->extra_ie_len);
+	if (ifmgd->extra_ie) {
+		pos = skb_put(skb, ifmgd->extra_ie_len);
+		memcpy(pos, ifmgd->extra_ie, ifmgd->extra_ie_len);
 	}
 
-	if (wmm && (ifsta->flags & IEEE80211_STA_WMM_ENABLED)) {
+	if (wmm && (ifmgd->flags & IEEE80211_STA_WMM_ENABLED)) {
 		pos = skb_put(skb, 9);
 		*pos++ = WLAN_EID_VENDOR_SPECIFIC;
 		*pos++ = 7; /* len */
@@ -418,11 +265,11 @@ static void ieee80211_send_assoc(struct 
 	 * mode (11a/b/g) if any one of these ciphers is
 	 * configured as pairwise.
 	 */
-	if (wmm && (ifsta->flags & IEEE80211_STA_WMM_ENABLED) &&
+	if (wmm && (ifmgd->flags & IEEE80211_STA_WMM_ENABLED) &&
 	    sband->ht_cap.ht_supported &&
 	    (ht_ie = ieee80211_bss_get_ie(bss, WLAN_EID_HT_INFORMATION)) &&
 	    ht_ie[1] >= sizeof(struct ieee80211_ht_info) &&
-	    (!(ifsta->flags & IEEE80211_STA_TKIP_WEP_USED))) {
+	    (!(ifmgd->flags & IEEE80211_STA_TKIP_WEP_USED))) {
 		struct ieee80211_ht_info *ht_info =
 			(struct ieee80211_ht_info *)(ht_ie + 2);
 		u16 cap = sband->ht_cap.cap;
@@ -459,11 +306,11 @@ static void ieee80211_send_assoc(struct 
 
 	add_extra_ies(skb, e_ies, e_ies_len);
 
-	kfree(ifsta->assocreq_ies);
-	ifsta->assocreq_ies_len = (skb->data + skb->len) - ies;
-	ifsta->assocreq_ies = kmalloc(ifsta->assocreq_ies_len, GFP_KERNEL);
-	if (ifsta->assocreq_ies)
-		memcpy(ifsta->assocreq_ies, ies, ifsta->assocreq_ies_len);
+	kfree(ifmgd->assocreq_ies);
+	ifmgd->assocreq_ies_len = (skb->data + skb->len) - ies;
+	ifmgd->assocreq_ies = kmalloc(ifmgd->assocreq_ies_len, GFP_KERNEL);
+	if (ifmgd->assocreq_ies)
+		memcpy(ifmgd->assocreq_ies, ies, ifmgd->assocreq_ies_len);
 
 	ieee80211_tx_skb(sdata, skb, 0);
 }
@@ -473,18 +320,18 @@ static void ieee80211_send_deauth_disass
 					   u16 stype, u16 reason)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	u8 *ies;
 	size_t ies_len;
 
 	if (stype == IEEE80211_STYPE_DEAUTH) {
-		ies = sdata->u.sta.ie_deauth;
-		ies_len = sdata->u.sta.ie_deauth_len;
+		ies = sdata->u.mgd.ie_deauth;
+		ies_len = sdata->u.mgd.ie_deauth_len;
 	} else {
-		ies = sdata->u.sta.ie_disassoc;
-		ies_len = sdata->u.sta.ie_disassoc_len;
+		ies = sdata->u.mgd.ie_disassoc;
+		ies_len = sdata->u.mgd.ie_disassoc_len;
 	}
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*mgmt) +
@@ -498,9 +345,9 @@ static void ieee80211_send_deauth_disass
 
 	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
 	memset(mgmt, 0, 24);
-	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
+	memcpy(mgmt->da, ifmgd->bssid, ETH_ALEN);
 	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
-	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
+	memcpy(mgmt->bssid, ifmgd->bssid, ETH_ALEN);
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT | stype);
 	skb_put(skb, 2);
 	/* u.deauth.reason_code == u.disassoc.reason_code */
@@ -508,13 +355,13 @@ static void ieee80211_send_deauth_disass
 
 	add_extra_ies(skb, ies, ies_len);
 
-	ieee80211_tx_skb(sdata, skb, ifsta->flags & IEEE80211_STA_MFP_ENABLED);
+	ieee80211_tx_skb(sdata, skb, ifmgd->flags & IEEE80211_STA_MFP_ENABLED);
 }
 
 void ieee80211_send_pspoll(struct ieee80211_local *local,
 			   struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_pspoll *pspoll;
 	struct sk_buff *skb;
 	u16 fc;
@@ -531,43 +378,20 @@ void ieee80211_send_pspoll(struct ieee80
 	memset(pspoll, 0, sizeof(*pspoll));
 	fc = IEEE80211_FTYPE_CTL | IEEE80211_STYPE_PSPOLL | IEEE80211_FCTL_PM;
 	pspoll->frame_control = cpu_to_le16(fc);
-	pspoll->aid = cpu_to_le16(ifsta->aid);
+	pspoll->aid = cpu_to_le16(ifmgd->aid);
 
 	/* aid in PS-Poll has its two MSBs each set to 1 */
 	pspoll->aid |= cpu_to_le16(1 << 15 | 1 << 14);
 
-	memcpy(pspoll->bssid, ifsta->bssid, ETH_ALEN);
+	memcpy(pspoll->bssid, ifmgd->bssid, ETH_ALEN);
 	memcpy(pspoll->ta, sdata->dev->dev_addr, ETH_ALEN);
 
 	ieee80211_tx_skb(sdata, skb, 0);
-
-	return;
 }
 
 /* MLME */
-static void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
-					 const size_t supp_rates_len,
-					 const u8 *supp_rates)
-{
-	struct ieee80211_local *local = sdata->local;
-	int i, have_higher_than_11mbit = 0;
-
-	/* cf. IEEE 802.11 9.2.12 */
-	for (i = 0; i < supp_rates_len; i++)
-		if ((supp_rates[i] & 0x7f) * 5 > 110)
-			have_higher_than_11mbit = 1;
-
-	if (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ &&
-	    have_higher_than_11mbit)
-		sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
-	else
-		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
-
-	ieee80211_set_wmm_default(sdata);
-}
-
 static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
-				     struct ieee80211_if_sta *ifsta,
+				     struct ieee80211_if_managed *ifmgd,
 				     u8 *wmm_param, size_t wmm_param_len)
 {
 	struct ieee80211_tx_queue_params params;
@@ -575,7 +399,7 @@ static void ieee80211_sta_wmm_params(str
 	int count;
 	u8 *pos;
 
-	if (!(ifsta->flags & IEEE80211_STA_WMM_ENABLED))
+	if (!(ifmgd->flags & IEEE80211_STA_WMM_ENABLED))
 		return;
 
 	if (!wmm_param)
@@ -584,9 +408,9 @@ static void ieee80211_sta_wmm_params(str
 	if (wmm_param_len < 8 || wmm_param[5] /* version */ != 1)
 		return;
 	count = wmm_param[6] & 0x0f;
-	if (count == ifsta->wmm_last_param_set)
+	if (count == ifmgd->wmm_last_param_set)
 		return;
-	ifsta->wmm_last_param_set = count;
+	ifmgd->wmm_last_param_set = count;
 
 	pos = wmm_param + 8;
 	left = wmm_param_len - 8;
@@ -671,7 +495,7 @@ static u32 ieee80211_handle_bss_capabili
 {
 	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 #endif
 	u32 changed = 0;
 	bool use_protection;
@@ -694,7 +518,7 @@ static u32 ieee80211_handle_bss_capabili
 			printk(KERN_DEBUG "%s: CTS protection %s (BSSID=%pM)\n",
 			       sdata->dev->name,
 			       use_protection ? "enabled" : "disabled",
-			       ifsta->bssid);
+			       ifmgd->bssid);
 		}
 #endif
 		bss_conf->use_cts_prot = use_protection;
@@ -708,7 +532,7 @@ static u32 ieee80211_handle_bss_capabili
 			       " (BSSID=%pM)\n",
 			       sdata->dev->name,
 			       use_short_preamble ? "short" : "long",
-			       ifsta->bssid);
+			       ifmgd->bssid);
 		}
 #endif
 		bss_conf->use_short_preamble = use_short_preamble;
@@ -722,7 +546,7 @@ static u32 ieee80211_handle_bss_capabili
 			       " (BSSID=%pM)\n",
 			       sdata->dev->name,
 			       use_short_slot ? "short" : "long",
-			       ifsta->bssid);
+			       ifmgd->bssid);
 		}
 #endif
 		bss_conf->use_short_slot = use_short_slot;
@@ -732,57 +556,57 @@ static u32 ieee80211_handle_bss_capabili
 	return changed;
 }
 
-static void ieee80211_sta_send_apinfo(struct ieee80211_sub_if_data *sdata,
-					struct ieee80211_if_sta *ifsta)
+static void ieee80211_sta_send_apinfo(struct ieee80211_sub_if_data *sdata)
 {
 	union iwreq_data wrqu;
+
 	memset(&wrqu, 0, sizeof(wrqu));
-	if (ifsta->flags & IEEE80211_STA_ASSOCIATED)
-		memcpy(wrqu.ap_addr.sa_data, sdata->u.sta.bssid, ETH_ALEN);
+	if (sdata->u.mgd.flags & IEEE80211_STA_ASSOCIATED)
+		memcpy(wrqu.ap_addr.sa_data, sdata->u.mgd.bssid, ETH_ALEN);
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 	wireless_send_event(sdata->dev, SIOCGIWAP, &wrqu, NULL);
 }
 
-static void ieee80211_sta_send_associnfo(struct ieee80211_sub_if_data *sdata,
-					 struct ieee80211_if_sta *ifsta)
+static void ieee80211_sta_send_associnfo(struct ieee80211_sub_if_data *sdata)
 {
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	char *buf;
 	size_t len;
 	int i;
 	union iwreq_data wrqu;
 
-	if (!ifsta->assocreq_ies && !ifsta->assocresp_ies)
+	if (!ifmgd->assocreq_ies && !ifmgd->assocresp_ies)
 		return;
 
-	buf = kmalloc(50 + 2 * (ifsta->assocreq_ies_len +
-				ifsta->assocresp_ies_len), GFP_KERNEL);
+	buf = kmalloc(50 + 2 * (ifmgd->assocreq_ies_len +
+				ifmgd->assocresp_ies_len), GFP_KERNEL);
 	if (!buf)
 		return;
 
 	len = sprintf(buf, "ASSOCINFO(");
-	if (ifsta->assocreq_ies) {
+	if (ifmgd->assocreq_ies) {
 		len += sprintf(buf + len, "ReqIEs=");
-		for (i = 0; i < ifsta->assocreq_ies_len; i++) {
+		for (i = 0; i < ifmgd->assocreq_ies_len; i++) {
 			len += sprintf(buf + len, "%02x",
-				       ifsta->assocreq_ies[i]);
+				       ifmgd->assocreq_ies[i]);
 		}
 	}
-	if (ifsta->assocresp_ies) {
-		if (ifsta->assocreq_ies)
+	if (ifmgd->assocresp_ies) {
+		if (ifmgd->assocreq_ies)
 			len += sprintf(buf + len, " ");
 		len += sprintf(buf + len, "RespIEs=");
-		for (i = 0; i < ifsta->assocresp_ies_len; i++) {
+		for (i = 0; i < ifmgd->assocresp_ies_len; i++) {
 			len += sprintf(buf + len, "%02x",
-				       ifsta->assocresp_ies[i]);
+				       ifmgd->assocresp_ies[i]);
 		}
 	}
 	len += sprintf(buf + len, ")");
 
 	if (len > IW_CUSTOM_MAX) {
 		len = sprintf(buf, "ASSOCRESPIE=");
-		for (i = 0; i < ifsta->assocresp_ies_len; i++) {
+		for (i = 0; i < ifmgd->assocresp_ies_len; i++) {
 			len += sprintf(buf + len, "%02x",
-				       ifsta->assocresp_ies[i]);
+				       ifmgd->assocresp_ies[i]);
 		}
 	}
 
@@ -797,20 +621,20 @@ static void ieee80211_sta_send_associnfo
 
 
 static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
-				     struct ieee80211_if_sta *ifsta,
 				     u32 bss_info_changed)
 {
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_conf *conf = &local_to_hw(local)->conf;
 
 	struct ieee80211_bss *bss;
 
 	bss_info_changed |= BSS_CHANGED_ASSOC;
-	ifsta->flags |= IEEE80211_STA_ASSOCIATED;
+	ifmgd->flags |= IEEE80211_STA_ASSOCIATED;
 
-	bss = ieee80211_rx_bss_get(local, ifsta->bssid,
+	bss = ieee80211_rx_bss_get(local, ifmgd->bssid,
 				   conf->channel->center_freq,
-				   ifsta->ssid, ifsta->ssid_len);
+				   ifmgd->ssid, ifmgd->ssid_len);
 	if (bss) {
 		/* set timing information */
 		sdata->vif.bss_conf.beacon_int = bss->cbss.beacon_interval;
@@ -823,11 +647,11 @@ static void ieee80211_set_associated(str
 		ieee80211_rx_bss_put(local, bss);
 	}
 
-	ifsta->flags |= IEEE80211_STA_PREV_BSSID_SET;
-	memcpy(ifsta->prev_bssid, sdata->u.sta.bssid, ETH_ALEN);
-	ieee80211_sta_send_associnfo(sdata, ifsta);
+	ifmgd->flags |= IEEE80211_STA_PREV_BSSID_SET;
+	memcpy(ifmgd->prev_bssid, sdata->u.mgd.bssid, ETH_ALEN);
+	ieee80211_sta_send_associnfo(sdata);
 
-	ifsta->last_probe = jiffies;
+	ifmgd->last_probe = jiffies;
 	ieee80211_led_assoc(local, 1);
 
 	sdata->vif.bss_conf.assoc = 1;
@@ -856,70 +680,74 @@ static void ieee80211_set_associated(str
 	netif_tx_start_all_queues(sdata->dev);
 	netif_carrier_on(sdata->dev);
 
-	ieee80211_sta_send_apinfo(sdata, ifsta);
+	ieee80211_sta_send_apinfo(sdata);
 }
 
-static void ieee80211_direct_probe(struct ieee80211_sub_if_data *sdata,
-				   struct ieee80211_if_sta *ifsta)
+static void ieee80211_direct_probe(struct ieee80211_sub_if_data *sdata)
 {
-	ifsta->direct_probe_tries++;
-	if (ifsta->direct_probe_tries > IEEE80211_AUTH_MAX_TRIES) {
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+
+	ifmgd->direct_probe_tries++;
+	if (ifmgd->direct_probe_tries > IEEE80211_AUTH_MAX_TRIES) {
 		printk(KERN_DEBUG "%s: direct probe to AP %pM timed out\n",
-		       sdata->dev->name, ifsta->bssid);
-		ifsta->state = IEEE80211_STA_MLME_DISABLED;
-		ieee80211_sta_send_apinfo(sdata, ifsta);
+		       sdata->dev->name, ifmgd->bssid);
+		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
+		ieee80211_sta_send_apinfo(sdata);
 
 		/*
 		 * Most likely AP is not in the range so remove the
 		 * bss information associated to the AP
 		 */
-		ieee80211_rx_bss_remove(sdata, ifsta->bssid,
+		ieee80211_rx_bss_remove(sdata, ifmgd->bssid,
 				sdata->local->hw.conf.channel->center_freq,
-				ifsta->ssid, ifsta->ssid_len);
+				ifmgd->ssid, ifmgd->ssid_len);
 		return;
 	}
 
 	printk(KERN_DEBUG "%s: direct probe to AP %pM try %d\n",
-			sdata->dev->name, ifsta->bssid,
-			ifsta->direct_probe_tries);
+			sdata->dev->name, ifmgd->bssid,
+			ifmgd->direct_probe_tries);
 
-	ifsta->state = IEEE80211_STA_MLME_DIRECT_PROBE;
+	ifmgd->state = IEEE80211_STA_MLME_DIRECT_PROBE;
 
-	set_bit(IEEE80211_STA_REQ_DIRECT_PROBE, &ifsta->request);
+	set_bit(IEEE80211_STA_REQ_DIRECT_PROBE, &ifmgd->request);
 
 	/* Direct probe is sent to broadcast address as some APs
 	 * will not answer to direct packet in unassociated state.
 	 */
 	ieee80211_send_probe_req(sdata, NULL,
-				 ifsta->ssid, ifsta->ssid_len);
+				 ifmgd->ssid, ifmgd->ssid_len);
 
-	mod_timer(&ifsta->timer, jiffies + IEEE80211_AUTH_TIMEOUT);
+	mod_timer(&ifmgd->timer, jiffies + IEEE80211_AUTH_TIMEOUT);
 }
 
 
-static void ieee80211_authenticate(struct ieee80211_sub_if_data *sdata,
-				   struct ieee80211_if_sta *ifsta)
+static void ieee80211_authenticate(struct ieee80211_sub_if_data *sdata)
 {
-	ifsta->auth_tries++;
-	if (ifsta->auth_tries > IEEE80211_AUTH_MAX_TRIES) {
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+
+	ifmgd->auth_tries++;
+	if (ifmgd->auth_tries > IEEE80211_AUTH_MAX_TRIES) {
 		printk(KERN_DEBUG "%s: authentication with AP %pM"
 		       " timed out\n",
-		       sdata->dev->name, ifsta->bssid);
-		ifsta->state = IEEE80211_STA_MLME_DISABLED;
-		ieee80211_sta_send_apinfo(sdata, ifsta);
-		ieee80211_rx_bss_remove(sdata, ifsta->bssid,
+		       sdata->dev->name, ifmgd->bssid);
+		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
+		ieee80211_sta_send_apinfo(sdata);
+		ieee80211_rx_bss_remove(sdata, ifmgd->bssid,
 				sdata->local->hw.conf.channel->center_freq,
-				ifsta->ssid, ifsta->ssid_len);
+				ifmgd->ssid, ifmgd->ssid_len);
 		return;
 	}
 
-	ifsta->state = IEEE80211_STA_MLME_AUTHENTICATE;
+	ifmgd->state = IEEE80211_STA_MLME_AUTHENTICATE;
 	printk(KERN_DEBUG "%s: authenticate with AP %pM\n",
-	       sdata->dev->name, ifsta->bssid);
+	       sdata->dev->name, ifmgd->bssid);
 
-	ieee80211_send_auth(sdata, ifsta, 1, NULL, 0, 0);
+	ieee80211_send_auth(sdata, 1, ifmgd->auth_alg, NULL, 0,
+			    ifmgd->bssid, 0);
+	ifmgd->auth_transaction = 2;
 
-	mod_timer(&ifsta->timer, jiffies + IEEE80211_AUTH_TIMEOUT);
+	mod_timer(&ifmgd->timer, jiffies + IEEE80211_AUTH_TIMEOUT);
 }
 
 /*
@@ -927,27 +755,28 @@ static void ieee80211_authenticate(struc
  * if self disconnected or a reason code from the AP.
  */
 static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
-				   struct ieee80211_if_sta *ifsta, bool deauth,
-				   bool self_disconnected, u16 reason)
+				   bool deauth, bool self_disconnected,
+				   u16 reason)
 {
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	u32 changed = 0, config_changed = 0;
 
 	rcu_read_lock();
 
-	sta = sta_info_get(local, ifsta->bssid);
+	sta = sta_info_get(local, ifmgd->bssid);
 	if (!sta) {
 		rcu_read_unlock();
 		return;
 	}
 
 	if (deauth) {
-		ifsta->direct_probe_tries = 0;
-		ifsta->auth_tries = 0;
+		ifmgd->direct_probe_tries = 0;
+		ifmgd->auth_tries = 0;
 	}
-	ifsta->assoc_scan_tries = 0;
-	ifsta->assoc_tries = 0;
+	ifmgd->assoc_scan_tries = 0;
+	ifmgd->assoc_tries = 0;
 
 	netif_tx_stop_all_queues(sdata->dev);
 	netif_carrier_off(sdata->dev);
@@ -963,20 +792,20 @@ static void ieee80211_set_disassoc(struc
 				IEEE80211_STYPE_DISASSOC, reason);
 	}
 
-	ifsta->flags &= ~IEEE80211_STA_ASSOCIATED;
+	ifmgd->flags &= ~IEEE80211_STA_ASSOCIATED;
 	changed |= ieee80211_reset_erp_info(sdata);
 
 	ieee80211_led_assoc(local, 0);
 	changed |= BSS_CHANGED_ASSOC;
 	sdata->vif.bss_conf.assoc = false;
 
-	ieee80211_sta_send_apinfo(sdata, ifsta);
+	ieee80211_sta_send_apinfo(sdata);
 
 	if (self_disconnected || reason == WLAN_REASON_DISASSOC_STA_HAS_LEFT) {
-		ifsta->state = IEEE80211_STA_MLME_DISABLED;
-		ieee80211_rx_bss_remove(sdata, ifsta->bssid,
+		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
+		ieee80211_rx_bss_remove(sdata, ifmgd->bssid,
 				sdata->local->hw.conf.channel->center_freq,
-				ifsta->ssid, ifsta->ssid_len);
+				ifmgd->ssid, ifmgd->ssid_len);
 	}
 
 	rcu_read_unlock();
@@ -999,7 +828,7 @@ static void ieee80211_set_disassoc(struc
 
 	rcu_read_lock();
 
-	sta = sta_info_get(local, ifsta->bssid);
+	sta = sta_info_get(local, ifmgd->bssid);
 	if (!sta) {
 		rcu_read_unlock();
 		return;
@@ -1020,27 +849,27 @@ static int ieee80211_sta_wep_configured(
 	return 1;
 }
 
-static int ieee80211_privacy_mismatch(struct ieee80211_sub_if_data *sdata,
-				      struct ieee80211_if_sta *ifsta)
+static int ieee80211_privacy_mismatch(struct ieee80211_sub_if_data *sdata)
 {
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_bss *bss;
 	int bss_privacy;
 	int wep_privacy;
 	int privacy_invoked;
 
-	if (!ifsta || (ifsta->flags & IEEE80211_STA_MIXED_CELL))
+	if (!ifmgd || (ifmgd->flags & IEEE80211_STA_MIXED_CELL))
 		return 0;
 
-	bss = ieee80211_rx_bss_get(local, ifsta->bssid,
+	bss = ieee80211_rx_bss_get(local, ifmgd->bssid,
 				   local->hw.conf.channel->center_freq,
-				   ifsta->ssid, ifsta->ssid_len);
+				   ifmgd->ssid, ifmgd->ssid_len);
 	if (!bss)
 		return 0;
 
 	bss_privacy = !!(bss->cbss.capability & WLAN_CAPABILITY_PRIVACY);
 	wep_privacy = !!ieee80211_sta_wep_configured(sdata);
-	privacy_invoked = !!(ifsta->flags & IEEE80211_STA_PRIVACY_INVOKED);
+	privacy_invoked = !!(ifmgd->flags & IEEE80211_STA_PRIVACY_INVOKED);
 
 	ieee80211_rx_bss_put(local, bss);
 
@@ -1050,41 +879,42 @@ static int ieee80211_privacy_mismatch(st
 	return 1;
 }
 
-static void ieee80211_associate(struct ieee80211_sub_if_data *sdata,
-				struct ieee80211_if_sta *ifsta)
+static void ieee80211_associate(struct ieee80211_sub_if_data *sdata)
 {
-	ifsta->assoc_tries++;
-	if (ifsta->assoc_tries > IEEE80211_ASSOC_MAX_TRIES) {
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+
+	ifmgd->assoc_tries++;
+	if (ifmgd->assoc_tries > IEEE80211_ASSOC_MAX_TRIES) {
 		printk(KERN_DEBUG "%s: association with AP %pM"
 		       " timed out\n",
-		       sdata->dev->name, ifsta->bssid);
-		ifsta->state = IEEE80211_STA_MLME_DISABLED;
-		ieee80211_sta_send_apinfo(sdata, ifsta);
-		ieee80211_rx_bss_remove(sdata, ifsta->bssid,
+		       sdata->dev->name, ifmgd->bssid);
+		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
+		ieee80211_sta_send_apinfo(sdata);
+		ieee80211_rx_bss_remove(sdata, ifmgd->bssid,
 				sdata->local->hw.conf.channel->center_freq,
-				ifsta->ssid, ifsta->ssid_len);
+				ifmgd->ssid, ifmgd->ssid_len);
 		return;
 	}
 
-	ifsta->state = IEEE80211_STA_MLME_ASSOCIATE;
+	ifmgd->state = IEEE80211_STA_MLME_ASSOCIATE;
 	printk(KERN_DEBUG "%s: associate with AP %pM\n",
-	       sdata->dev->name, ifsta->bssid);
-	if (ieee80211_privacy_mismatch(sdata, ifsta)) {
+	       sdata->dev->name, ifmgd->bssid);
+	if (ieee80211_privacy_mismatch(sdata)) {
 		printk(KERN_DEBUG "%s: mismatch in privacy configuration and "
 		       "mixed-cell disabled - abort association\n", sdata->dev->name);
-		ifsta->state = IEEE80211_STA_MLME_DISABLED;
+		ifmgd->state = IEEE80211_STA_MLME_DISABLED;
 		return;
 	}
 
-	ieee80211_send_assoc(sdata, ifsta);
+	ieee80211_send_assoc(sdata);
 
-	mod_timer(&ifsta->timer, jiffies + IEEE80211_ASSOC_TIMEOUT);
+	mod_timer(&ifmgd->timer, jiffies + IEEE80211_ASSOC_TIMEOUT);
 }
 
 
-static void ieee80211_associated(struct ieee80211_sub_if_data *sdata,
-				 struct ieee80211_if_sta *ifsta)
+static void ieee80211_associated(struct ieee80211_sub_if_data *sdata)
 {
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	int disassoc;
@@ -1094,38 +924,38 @@ static void ieee80211_associated(struct 
 	 * for better APs. */
 	/* TODO: remove expired BSSes */
 
-	ifsta->state = IEEE80211_STA_MLME_ASSOCIATED;
+	ifmgd->state = IEEE80211_STA_MLME_ASSOCIATED;
 
 	rcu_read_lock();
 
-	sta = sta_info_get(local, ifsta->bssid);
+	sta = sta_info_get(local, ifmgd->bssid);
 	if (!sta) {
 		printk(KERN_DEBUG "%s: No STA entry for own AP %pM\n",
-		       sdata->dev->name, ifsta->bssid);
+		       sdata->dev->name, ifmgd->bssid);
 		disassoc = 1;
 	} else {
 		disassoc = 0;
 		if (time_after(jiffies,
 			       sta->last_rx + IEEE80211_MONITORING_INTERVAL)) {
-			if (ifsta->flags & IEEE80211_STA_PROBEREQ_POLL) {
+			if (ifmgd->flags & IEEE80211_STA_PROBEREQ_POLL) {
 				printk(KERN_DEBUG "%s: No ProbeResp from "
 				       "current AP %pM - assume out of "
 				       "range\n",
-				       sdata->dev->name, ifsta->bssid);
+				       sdata->dev->name, ifmgd->bssid);
 				disassoc = 1;
 			} else
-				ieee80211_send_probe_req(sdata, ifsta->bssid,
-							 ifsta->ssid,
-							 ifsta->ssid_len);
-			ifsta->flags ^= IEEE80211_STA_PROBEREQ_POLL;
+				ieee80211_send_probe_req(sdata, ifmgd->bssid,
+							 ifmgd->ssid,
+							 ifmgd->ssid_len);
+			ifmgd->flags ^= IEEE80211_STA_PROBEREQ_POLL;
 		} else {
-			ifsta->flags &= ~IEEE80211_STA_PROBEREQ_POLL;
-			if (time_after(jiffies, ifsta->last_probe +
+			ifmgd->flags &= ~IEEE80211_STA_PROBEREQ_POLL;
+			if (time_after(jiffies, ifmgd->last_probe +
 				       IEEE80211_PROBE_INTERVAL)) {
-				ifsta->last_probe = jiffies;
-				ieee80211_send_probe_req(sdata, ifsta->bssid,
-							 ifsta->ssid,
-							 ifsta->ssid_len);
+				ifmgd->last_probe = jiffies;
+				ieee80211_send_probe_req(sdata, ifmgd->bssid,
+							 ifmgd->ssid,
+							 ifmgd->ssid_len);
 			}
 		}
 	}
@@ -1133,25 +963,25 @@ static void ieee80211_associated(struct 
 	rcu_read_unlock();
 
 	if (disassoc)
-		ieee80211_set_disassoc(sdata, ifsta, true, true,
+		ieee80211_set_disassoc(sdata, true, true,
 					WLAN_REASON_PREV_AUTH_NOT_VALID);
 	else
-		mod_timer(&ifsta->timer, jiffies +
+		mod_timer(&ifmgd->timer, jiffies +
 				      IEEE80211_MONITORING_INTERVAL);
 }
 
 
-static void ieee80211_auth_completed(struct ieee80211_sub_if_data *sdata,
-				     struct ieee80211_if_sta *ifsta)
+static void ieee80211_auth_completed(struct ieee80211_sub_if_data *sdata)
 {
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+
 	printk(KERN_DEBUG "%s: authenticated\n", sdata->dev->name);
-	ifsta->flags |= IEEE80211_STA_AUTHENTICATED;
-	ieee80211_associate(sdata, ifsta);
+	ifmgd->flags |= IEEE80211_STA_AUTHENTICATED;
+	ieee80211_associate(sdata);
 }
 
 
 static void ieee80211_auth_challenge(struct ieee80211_sub_if_data *sdata,
-				     struct ieee80211_if_sta *ifsta,
 				     struct ieee80211_mgmt *mgmt,
 				     size_t len)
 {
@@ -1162,59 +992,37 @@ static void ieee80211_auth_challenge(str
 	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems);
 	if (!elems.challenge)
 		return;
-	ieee80211_send_auth(sdata, ifsta, 3, elems.challenge - 2,
-			    elems.challenge_len + 2, 1);
-}
-
-static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
-					struct ieee80211_if_sta *ifsta,
-					struct ieee80211_mgmt *mgmt,
-					size_t len)
-{
-	u16 auth_alg, auth_transaction, status_code;
-
-	if (len < 24 + 6)
-		return;
-
-	auth_alg = le16_to_cpu(mgmt->u.auth.auth_alg);
-	auth_transaction = le16_to_cpu(mgmt->u.auth.auth_transaction);
-	status_code = le16_to_cpu(mgmt->u.auth.status_code);
-
-	/*
-	 * IEEE 802.11 standard does not require authentication in IBSS
-	 * networks and most implementations do not seem to use it.
-	 * However, try to reply to authentication attempts if someone
-	 * has actually implemented this.
-	 */
-	if (auth_alg == WLAN_AUTH_OPEN && auth_transaction == 1)
-		ieee80211_send_auth(sdata, ifsta, 2, NULL, 0, 0);
+	ieee80211_send_auth(sdata, 3, sdata->u.mgd.auth_alg,
+			    elems.challenge - 2, elems.challenge_len + 2,
+			    sdata->u.mgd.bssid, 1);
+	sdata->u.mgd.auth_transaction = 4;
 }
 
 static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
-				   struct ieee80211_if_sta *ifsta,
 				   struct ieee80211_mgmt *mgmt,
 				   size_t len)
 {
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	u16 auth_alg, auth_transaction, status_code;
 
-	if (ifsta->state != IEEE80211_STA_MLME_AUTHENTICATE)
+	if (ifmgd->state != IEEE80211_STA_MLME_AUTHENTICATE)
 		return;
 
 	if (len < 24 + 6)
 		return;
 
-	if (memcmp(ifsta->bssid, mgmt->sa, ETH_ALEN) != 0)
+	if (memcmp(ifmgd->bssid, mgmt->sa, ETH_ALEN) != 0)
 		return;
 
-	if (memcmp(ifsta->bssid, mgmt->bssid, ETH_ALEN) != 0)
+	if (memcmp(ifmgd->bssid, mgmt->bssid, ETH_ALEN) != 0)
 		return;
 
 	auth_alg = le16_to_cpu(mgmt->u.auth.auth_alg);
 	auth_transaction = le16_to_cpu(mgmt->u.auth.auth_transaction);
 	status_code = le16_to_cpu(mgmt->u.auth.status_code);
 
-	if (auth_alg != ifsta->auth_alg ||
-	    auth_transaction != ifsta->auth_transaction)
+	if (auth_alg != ifmgd->auth_alg ||
+	    auth_transaction != ifmgd->auth_transaction)
 		return;
 
 	if (status_code != WLAN_STATUS_SUCCESS) {
@@ -1223,15 +1031,15 @@ static void ieee80211_rx_mgmt_auth(struc
 			const int num_algs = ARRAY_SIZE(algs);
 			int i, pos;
 			algs[0] = algs[1] = algs[2] = 0xff;
-			if (ifsta->auth_algs & IEEE80211_AUTH_ALG_OPEN)
+			if (ifmgd->auth_algs & IEEE80211_AUTH_ALG_OPEN)
 				algs[0] = WLAN_AUTH_OPEN;
-			if (ifsta->auth_algs & IEEE80211_AUTH_ALG_SHARED_KEY)
+			if (ifmgd->auth_algs & IEEE80211_AUTH_ALG_SHARED_KEY)
 				algs[1] = WLAN_AUTH_SHARED_KEY;
-			if (ifsta->auth_algs & IEEE80211_AUTH_ALG_LEAP)
+			if (ifmgd->auth_algs & IEEE80211_AUTH_ALG_LEAP)
 				algs[2] = WLAN_AUTH_LEAP;
-			if (ifsta->auth_alg == WLAN_AUTH_OPEN)
+			if (ifmgd->auth_alg == WLAN_AUTH_OPEN)
 				pos = 0;
-			else if (ifsta->auth_alg == WLAN_AUTH_SHARED_KEY)
+			else if (ifmgd->auth_alg == WLAN_AUTH_SHARED_KEY)
 				pos = 1;
 			else
 				pos = 2;
@@ -1239,101 +1047,101 @@ static void ieee80211_rx_mgmt_auth(struc
 				pos++;
 				if (pos >= num_algs)
 					pos = 0;
-				if (algs[pos] == ifsta->auth_alg ||
+				if (algs[pos] == ifmgd->auth_alg ||
 				    algs[pos] == 0xff)
 					continue;
 				if (algs[pos] == WLAN_AUTH_SHARED_KEY &&
 				    !ieee80211_sta_wep_configured(sdata))
 					continue;
-				ifsta->auth_alg = algs[pos];
+				ifmgd->auth_alg = algs[pos];
 				break;
 			}
 		}
 		return;
 	}
 
-	switch (ifsta->auth_alg) {
+	switch (ifmgd->auth_alg) {
 	case WLAN_AUTH_OPEN:
 	case WLAN_AUTH_LEAP:
-		ieee80211_auth_completed(sdata, ifsta);
+		ieee80211_auth_completed(sdata);
 		break;
 	case WLAN_AUTH_SHARED_KEY:
-		if (ifsta->auth_transaction == 4)
-			ieee80211_auth_completed(sdata, ifsta);
+		if (ifmgd->auth_transaction == 4)
+			ieee80211_auth_completed(sdata);
 		else
-			ieee80211_auth_challenge(sdata, ifsta, mgmt, len);
+			ieee80211_auth_challenge(sdata, mgmt, len);
 		break;
 	}
 }
 
 
 static void ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
-				     struct ieee80211_if_sta *ifsta,
 				     struct ieee80211_mgmt *mgmt,
 				     size_t len)
 {
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	u16 reason_code;
 
 	if (len < 24 + 2)
 		return;
 
-	if (memcmp(ifsta->bssid, mgmt->sa, ETH_ALEN))
+	if (memcmp(ifmgd->bssid, mgmt->sa, ETH_ALEN))
 		return;
 
 	reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
 
-	if (ifsta->flags & IEEE80211_STA_AUTHENTICATED)
+	if (ifmgd->flags & IEEE80211_STA_AUTHENTICATED)
 		printk(KERN_DEBUG "%s: deauthenticated (Reason: %u)\n",
 				sdata->dev->name, reason_code);
 
-	if (ifsta->state == IEEE80211_STA_MLME_AUTHENTICATE ||
-	    ifsta->state == IEEE80211_STA_MLME_ASSOCIATE ||
-	    ifsta->state == IEEE80211_STA_MLME_ASSOCIATED) {
-		ifsta->state = IEEE80211_STA_MLME_DIRECT_PROBE;
-		mod_timer(&ifsta->timer, jiffies +
+	if (ifmgd->state == IEEE80211_STA_MLME_AUTHENTICATE ||
+	    ifmgd->state == IEEE80211_STA_MLME_ASSOCIATE ||
+	    ifmgd->state == IEEE80211_STA_MLME_ASSOCIATED) {
+		ifmgd->state = IEEE80211_STA_MLME_DIRECT_PROBE;
+		mod_timer(&ifmgd->timer, jiffies +
 				      IEEE80211_RETRY_AUTH_INTERVAL);
 	}
 
-	ieee80211_set_disassoc(sdata, ifsta, true, false, 0);
-	ifsta->flags &= ~IEEE80211_STA_AUTHENTICATED;
+	ieee80211_set_disassoc(sdata, true, false, 0);
+	ifmgd->flags &= ~IEEE80211_STA_AUTHENTICATED;
 }
 
 
 static void ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
-				       struct ieee80211_if_sta *ifsta,
 				       struct ieee80211_mgmt *mgmt,
 				       size_t len)
 {
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	u16 reason_code;
 
 	if (len < 24 + 2)
 		return;
 
-	if (memcmp(ifsta->bssid, mgmt->sa, ETH_ALEN))
+	if (memcmp(ifmgd->bssid, mgmt->sa, ETH_ALEN))
 		return;
 
 	reason_code = le16_to_cpu(mgmt->u.disassoc.reason_code);
 
-	if (ifsta->flags & IEEE80211_STA_ASSOCIATED)
+	if (ifmgd->flags & IEEE80211_STA_ASSOCIATED)
 		printk(KERN_DEBUG "%s: disassociated (Reason: %u)\n",
 				sdata->dev->name, reason_code);
 
-	if (ifsta->state == IEEE80211_STA_MLME_ASSOCIATED) {
-		ifsta->state = IEEE80211_STA_MLME_ASSOCIATE;
-		mod_timer(&ifsta->timer, jiffies +
+	if (ifmgd->state == IEEE80211_STA_MLME_ASSOCIATED) {
+		ifmgd->state = IEEE80211_STA_MLME_ASSOCIATE;
+		mod_timer(&ifmgd->timer, jiffies +
 				      IEEE80211_RETRY_AUTH_INTERVAL);
 	}
 
-	ieee80211_set_disassoc(sdata, ifsta, false, false, reason_code);
+	ieee80211_set_disassoc(sdata, false, false, reason_code);
 }
 
 
 static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
-					 struct ieee80211_if_sta *ifsta,
 					 struct ieee80211_mgmt *mgmt,
 					 size_t len,
 					 int reassoc)
 {
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
 	struct sta_info *sta;
@@ -1350,13 +1158,13 @@ static void ieee80211_rx_mgmt_assoc_resp
 	/* AssocResp and ReassocResp have identical structure, so process both
 	 * of them in this function. */
 
-	if (ifsta->state != IEEE80211_STA_MLME_ASSOCIATE)
+	if (ifmgd->state != IEEE80211_STA_MLME_ASSOCIATE)
 		return;
 
 	if (len < 24 + 6)
 		return;
 
-	if (memcmp(ifsta->bssid, mgmt->sa, ETH_ALEN) != 0)
+	if (memcmp(ifmgd->bssid, mgmt->sa, ETH_ALEN) != 0)
 		return;
 
 	capab_info = le16_to_cpu(mgmt->u.assoc_resp.capab_info);
@@ -1381,7 +1189,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 		       "comeback duration %u TU (%u ms)\n",
 		       sdata->dev->name, tu, ms);
 		if (ms > IEEE80211_ASSOC_TIMEOUT)
-			mod_timer(&ifsta->timer,
+			mod_timer(&ifmgd->timer,
 				  jiffies + msecs_to_jiffies(ms));
 		return;
 	}
@@ -1392,7 +1200,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 		/* if this was a reassociation, ensure we try a "full"
 		 * association next time. This works around some broken APs
 		 * which do not correctly reject reassociation requests. */
-		ifsta->flags &= ~IEEE80211_STA_PREV_BSSID_SET;
+		ifmgd->flags &= ~IEEE80211_STA_PREV_BSSID_SET;
 		return;
 	}
 
@@ -1408,23 +1216,23 @@ static void ieee80211_rx_mgmt_assoc_resp
 	}
 
 	printk(KERN_DEBUG "%s: associated\n", sdata->dev->name);
-	ifsta->aid = aid;
-	ifsta->ap_capab = capab_info;
+	ifmgd->aid = aid;
+	ifmgd->ap_capab = capab_info;
 
-	kfree(ifsta->assocresp_ies);
-	ifsta->assocresp_ies_len = len - (pos - (u8 *) mgmt);
-	ifsta->assocresp_ies = kmalloc(ifsta->assocresp_ies_len, GFP_KERNEL);
-	if (ifsta->assocresp_ies)
-		memcpy(ifsta->assocresp_ies, pos, ifsta->assocresp_ies_len);
+	kfree(ifmgd->assocresp_ies);
+	ifmgd->assocresp_ies_len = len - (pos - (u8 *) mgmt);
+	ifmgd->assocresp_ies = kmalloc(ifmgd->assocresp_ies_len, GFP_KERNEL);
+	if (ifmgd->assocresp_ies)
+		memcpy(ifmgd->assocresp_ies, pos, ifmgd->assocresp_ies_len);
 
 	rcu_read_lock();
 
 	/* Add STA entry for the AP */
-	sta = sta_info_get(local, ifsta->bssid);
+	sta = sta_info_get(local, ifmgd->bssid);
 	if (!sta) {
 		newsta = true;
 
-		sta = sta_info_alloc(sdata, ifsta->bssid, GFP_ATOMIC);
+		sta = sta_info_alloc(sdata, ifmgd->bssid, GFP_ATOMIC);
 		if (!sta) {
 			printk(KERN_DEBUG "%s: failed to alloc STA entry for"
 			       " the AP\n", sdata->dev->name);
@@ -1505,7 +1313,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 
 	rate_control_rate_init(sta);
 
-	if (ifsta->flags & IEEE80211_STA_MFP_ENABLED)
+	if (ifmgd->flags & IEEE80211_STA_MFP_ENABLED)
 		set_sta_flags(sta, WLAN_STA_MFP);
 
 	if (elems.wmm_param)
@@ -1524,11 +1332,11 @@ static void ieee80211_rx_mgmt_assoc_resp
 	rcu_read_unlock();
 
 	if (elems.wmm_param)
-		ieee80211_sta_wmm_params(local, ifsta, elems.wmm_param,
+		ieee80211_sta_wmm_params(local, ifmgd, elems.wmm_param,
 					 elems.wmm_param_len);
 
 	if (elems.ht_info_elem && elems.wmm_param &&
-	    (ifsta->flags & IEEE80211_STA_WMM_ENABLED))
+	    (ifmgd->flags & IEEE80211_STA_WMM_ENABLED))
 		changed |= ieee80211_enable_ht(sdata, elems.ht_info_elem,
 					       ap_ht_cap_flags);
 
@@ -1536,162 +1344,11 @@ static void ieee80211_rx_mgmt_assoc_resp
 	 * ieee80211_set_associated() will tell the driver */
 	bss_conf->aid = aid;
 	bss_conf->assoc_capability = capab_info;
-	ieee80211_set_associated(sdata, ifsta, changed);
-
-	ieee80211_associated(sdata, ifsta);
-}
-
-
-static int __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
-				     struct ieee80211_if_sta *ifsta,
-				     const u8 *bssid, const int beacon_int,
-				     const int freq,
-				     const size_t supp_rates_len,
-				     const u8 *supp_rates,
-				     const u16 capability)
-{
-	struct ieee80211_local *local = sdata->local;
-	int res = 0, rates, i, j;
-	struct sk_buff *skb;
-	struct ieee80211_mgmt *mgmt;
-	u8 *pos;
-	struct ieee80211_supported_band *sband;
-	union iwreq_data wrqu;
-
-	if (local->ops->reset_tsf) {
-		/* Reset own TSF to allow time synchronization work. */
-		local->ops->reset_tsf(local_to_hw(local));
-	}
-
-	if ((ifsta->flags & IEEE80211_STA_PREV_BSSID_SET) &&
-	   memcmp(ifsta->bssid, bssid, ETH_ALEN) == 0)
-		return res;
-
-	skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400 +
-			    sdata->u.sta.ie_proberesp_len);
-	if (!skb) {
-		printk(KERN_DEBUG "%s: failed to allocate buffer for probe "
-		       "response\n", sdata->dev->name);
-		return -ENOMEM;
-	}
-
-	if (!(ifsta->flags & IEEE80211_STA_PREV_BSSID_SET)) {
-		/* Remove possible STA entries from other IBSS networks. */
-		sta_info_flush_delayed(sdata);
-	}
-
-	memcpy(ifsta->bssid, bssid, ETH_ALEN);
-	res = ieee80211_if_config(sdata, IEEE80211_IFCC_BSSID);
-	if (res)
-		return res;
-
-	local->hw.conf.beacon_int = beacon_int >= 10 ? beacon_int : 10;
-
-	sdata->drop_unencrypted = capability &
-		WLAN_CAPABILITY_PRIVACY ? 1 : 0;
-
-	res = ieee80211_set_freq(sdata, freq);
-
-	if (res)
-		return res;
-
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-
-	/* Build IBSS probe response */
-
-	skb_reserve(skb, local->hw.extra_tx_headroom);
-
-	mgmt = (struct ieee80211_mgmt *)
-		skb_put(skb, 24 + sizeof(mgmt->u.beacon));
-	memset(mgmt, 0, 24 + sizeof(mgmt->u.beacon));
-	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-					  IEEE80211_STYPE_PROBE_RESP);
-	memset(mgmt->da, 0xff, ETH_ALEN);
-	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
-	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
-	mgmt->u.beacon.beacon_int =
-		cpu_to_le16(local->hw.conf.beacon_int);
-	mgmt->u.beacon.capab_info = cpu_to_le16(capability);
-
-	pos = skb_put(skb, 2 + ifsta->ssid_len);
-	*pos++ = WLAN_EID_SSID;
-	*pos++ = ifsta->ssid_len;
-	memcpy(pos, ifsta->ssid, ifsta->ssid_len);
-
-	rates = supp_rates_len;
-	if (rates > 8)
-		rates = 8;
-	pos = skb_put(skb, 2 + rates);
-	*pos++ = WLAN_EID_SUPP_RATES;
-	*pos++ = rates;
-	memcpy(pos, supp_rates, rates);
-
-	if (sband->band == IEEE80211_BAND_2GHZ) {
-		pos = skb_put(skb, 2 + 1);
-		*pos++ = WLAN_EID_DS_PARAMS;
-		*pos++ = 1;
-		*pos++ = ieee80211_frequency_to_channel(freq);
-	}
-
-	pos = skb_put(skb, 2 + 2);
-	*pos++ = WLAN_EID_IBSS_PARAMS;
-	*pos++ = 2;
-	/* FIX: set ATIM window based on scan results */
-	*pos++ = 0;
-	*pos++ = 0;
-
-	if (supp_rates_len > 8) {
-		rates = supp_rates_len - 8;
-		pos = skb_put(skb, 2 + rates);
-		*pos++ = WLAN_EID_EXT_SUPP_RATES;
-		*pos++ = rates;
-		memcpy(pos, &supp_rates[8], rates);
-	}
-
-	add_extra_ies(skb, sdata->u.sta.ie_proberesp,
-		      sdata->u.sta.ie_proberesp_len);
+	ieee80211_set_associated(sdata, changed);
 
-	ifsta->probe_resp = skb;
-
-	ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON |
-				   IEEE80211_IFCC_BEACON_ENABLED);
-
-
-	rates = 0;
-	for (i = 0; i < supp_rates_len; i++) {
-		int bitrate = (supp_rates[i] & 0x7f) * 5;
-		for (j = 0; j < sband->n_bitrates; j++)
-			if (sband->bitrates[j].bitrate == bitrate)
-				rates |= BIT(j);
-	}
-	ifsta->supp_rates_bits[local->hw.conf.channel->band] = rates;
-
-	ieee80211_sta_def_wmm_params(sdata, supp_rates_len, supp_rates);
-
-	ifsta->flags |= IEEE80211_STA_PREV_BSSID_SET;
-	ifsta->state = IEEE80211_STA_MLME_IBSS_JOINED;
-	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
-
-	ieee80211_led_assoc(local, true);
-
-	memset(&wrqu, 0, sizeof(wrqu));
-	memcpy(wrqu.ap_addr.sa_data, bssid, ETH_ALEN);
-	wireless_send_event(sdata->dev, SIOCGIWAP, &wrqu, NULL);
-
-	return res;
+	ieee80211_associated(sdata);
 }
 
-static int ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
-				   struct ieee80211_if_sta *ifsta,
-				   struct ieee80211_bss *bss)
-{
-	return __ieee80211_sta_join_ibss(sdata, ifsta,
-					 bss->cbss.bssid,
-					 bss->cbss.beacon_interval,
-					 bss->cbss.channel->center_freq,
-					 bss->supp_rates_len, bss->supp_rates,
-					 bss->cbss.capability);
-}
 
 static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 				  struct ieee80211_mgmt *mgmt,
@@ -1703,11 +1360,7 @@ static void ieee80211_rx_bss_info(struct
 	struct ieee80211_local *local = sdata->local;
 	int freq;
 	struct ieee80211_bss *bss;
-	struct sta_info *sta;
 	struct ieee80211_channel *channel;
-	u64 beacon_timestamp, rx_timestamp;
-	u32 supp_rates = 0;
-	enum ieee80211_band band = rx_status->band;
 
 	if (elems->ds_params && elems->ds_params_len == 1)
 		freq = ieee80211_channel_to_frequency(elems->ds_params[0]);
@@ -1719,133 +1372,18 @@ static void ieee80211_rx_bss_info(struct
 	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
 		return;
 
-	if (sdata->vif.type == NL80211_IFTYPE_ADHOC && elems->supp_rates &&
-	    memcmp(mgmt->bssid, sdata->u.sta.bssid, ETH_ALEN) == 0) {
-		supp_rates = ieee80211_sta_get_rates(local, elems, band);
-
-		rcu_read_lock();
-
-		sta = sta_info_get(local, mgmt->sa);
-		if (sta) {
-			u32 prev_rates;
-
-			prev_rates = sta->sta.supp_rates[band];
-			/* make sure mandatory rates are always added */
-			sta->sta.supp_rates[band] = supp_rates |
-				ieee80211_mandatory_rates(local, band);
-
-#ifdef CONFIG_MAC80211_IBSS_DEBUG
-			if (sta->sta.supp_rates[band] != prev_rates)
-				printk(KERN_DEBUG "%s: updated supp_rates set "
-				    "for %pM based on beacon info (0x%llx | "
-				    "0x%llx -> 0x%llx)\n",
-				    sdata->dev->name,
-				    sta->sta.addr,
-				    (unsigned long long) prev_rates,
-				    (unsigned long long) supp_rates,
-				    (unsigned long long) sta->sta.supp_rates[band]);
-#endif
-		} else {
-			ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, supp_rates);
-		}
-
-		rcu_read_unlock();
-	}
-
 	bss = ieee80211_bss_info_update(local, rx_status, mgmt, len, elems,
 					channel, beacon);
 	if (!bss)
 		return;
 
 	if (elems->ch_switch_elem && (elems->ch_switch_elem_len == 3) &&
-	    (memcmp(mgmt->bssid, sdata->u.sta.bssid, ETH_ALEN) == 0)) {
+	    (memcmp(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN) == 0)) {
 		struct ieee80211_channel_sw_ie *sw_elem =
 			(struct ieee80211_channel_sw_ie *)elems->ch_switch_elem;
 		ieee80211_process_chanswitch(sdata, sw_elem, bss);
 	}
 
-	/* was just updated in ieee80211_bss_info_update */
-	beacon_timestamp = bss->cbss.tsf;
-
-	if (sdata->vif.type != NL80211_IFTYPE_ADHOC)
-		goto put_bss;
-
-	/* check if we need to merge IBSS */
-
-	/* merge only on beacons (???) */
-	if (!beacon)
-		goto put_bss;
-
-	/* we use a fixed BSSID */
-	if (sdata->u.sta.flags & IEEE80211_STA_BSSID_SET)
-		goto put_bss;
-
-	/* not an IBSS */
-	if (!(bss->cbss.capability & WLAN_CAPABILITY_IBSS))
-		goto put_bss;
-
-	/* different channel */
-	if (bss->cbss.channel != local->oper_channel)
-		goto put_bss;
-
-	/* different SSID */
-	if (elems->ssid_len != sdata->u.sta.ssid_len ||
-	    memcmp(elems->ssid, sdata->u.sta.ssid,
-				sdata->u.sta.ssid_len))
-		goto put_bss;
-
-	if (rx_status->flag & RX_FLAG_TSFT) {
-		/*
-		 * For correct IBSS merging we need mactime; since mactime is
-		 * defined as the time the first data symbol of the frame hits
-		 * the PHY, and the timestamp of the beacon is defined as "the
-		 * time that the data symbol containing the first bit of the
-		 * timestamp is transmitted to the PHY plus the transmitting
-		 * STA's delays through its local PHY from the MAC-PHY
-		 * interface to its interface with the WM" (802.11 11.1.2)
-		 * - equals the time this bit arrives at the receiver - we have
-		 * to take into account the offset between the two.
-		 *
-		 * E.g. at 1 MBit that means mactime is 192 usec earlier
-		 * (=24 bytes * 8 usecs/byte) than the beacon timestamp.
-		 */
-		int rate;
-
-		if (rx_status->flag & RX_FLAG_HT)
-			rate = 65; /* TODO: HT rates */
-		else
-			rate = local->hw.wiphy->bands[band]->
-				bitrates[rx_status->rate_idx].bitrate;
-
-		rx_timestamp = rx_status->mactime + (24 * 8 * 10 / rate);
-	} else if (local && local->ops && local->ops->get_tsf)
-		/* second best option: get current TSF */
-		rx_timestamp = local->ops->get_tsf(local_to_hw(local));
-	else
-		/* can't merge without knowing the TSF */
-		rx_timestamp = -1LLU;
-
-#ifdef CONFIG_MAC80211_IBSS_DEBUG
-	printk(KERN_DEBUG "RX beacon SA=%pM BSSID="
-	       "%pM TSF=0x%llx BCN=0x%llx diff=%lld @%lu\n",
-	       mgmt->sa, mgmt->bssid,
-	       (unsigned long long)rx_timestamp,
-	       (unsigned long long)beacon_timestamp,
-	       (unsigned long long)(rx_timestamp - beacon_timestamp),
-	       jiffies);
-#endif
-
-	if (beacon_timestamp > rx_timestamp) {
-#ifdef CONFIG_MAC80211_IBSS_DEBUG
-		printk(KERN_DEBUG "%s: beacon TSF higher than "
-		       "local TSF - IBSS merge with BSSID %pM\n",
-		       sdata->dev->name, mgmt->bssid);
-#endif
-		ieee80211_sta_join_ibss(sdata, &sdata->u.sta, bss);
-		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, supp_rates);
-	}
-
- put_bss:
 	ieee80211_rx_bss_put(local, bss);
 }
 
@@ -1857,7 +1395,6 @@ static void ieee80211_rx_mgmt_probe_resp
 {
 	size_t baselen;
 	struct ieee802_11_elems elems;
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 
 	if (memcmp(mgmt->da, sdata->dev->dev_addr, ETH_ALEN))
 		return; /* ignore ProbeResp to foreign address */
@@ -1873,20 +1410,19 @@ static void ieee80211_rx_mgmt_probe_resp
 
 	/* direct probe may be part of the association flow */
 	if (test_and_clear_bit(IEEE80211_STA_REQ_DIRECT_PROBE,
-							&ifsta->request)) {
+	    &sdata->u.mgd.request)) {
 		printk(KERN_DEBUG "%s direct probe responded\n",
 		       sdata->dev->name);
-		ieee80211_authenticate(sdata, ifsta);
+		ieee80211_authenticate(sdata);
 	}
 }
 
-
 static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_mgmt *mgmt,
 				     size_t len,
 				     struct ieee80211_rx_status *rx_status)
 {
-	struct ieee80211_if_sta *ifsta;
+	struct ieee80211_if_managed *ifmgd;
 	size_t baselen;
 	struct ieee802_11_elems elems;
 	struct ieee80211_local *local = sdata->local;
@@ -1905,21 +1441,22 @@ static void ieee80211_rx_mgmt_beacon(str
 
 	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return;
-	ifsta = &sdata->u.sta;
 
-	if (!(ifsta->flags & IEEE80211_STA_ASSOCIATED) ||
-	    memcmp(ifsta->bssid, mgmt->bssid, ETH_ALEN) != 0)
+	ifmgd = &sdata->u.mgd;
+
+	if (!(ifmgd->flags & IEEE80211_STA_ASSOCIATED) ||
+	    memcmp(ifmgd->bssid, mgmt->bssid, ETH_ALEN) != 0)
 		return;
 
 	if (rx_status->freq != local->hw.conf.channel->center_freq)
 		return;
 
-	ieee80211_sta_wmm_params(local, ifsta, elems.wmm_param,
+	ieee80211_sta_wmm_params(local, ifmgd, elems.wmm_param,
 				 elems.wmm_param_len);
 
 	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK &&
 	    local->hw.conf.flags & IEEE80211_CONF_PS) {
-		directed_tim = ieee80211_check_tim(&elems, ifsta->aid);
+		directed_tim = ieee80211_check_tim(&elems, ifmgd->aid);
 
 		if (directed_tim) {
 			if (local->hw.conf.dynamic_ps_timeout > 0) {
@@ -1961,7 +1498,7 @@ static void ieee80211_rx_mgmt_beacon(str
 
 		rcu_read_lock();
 
-		sta = sta_info_get(local, ifsta->bssid);
+		sta = sta_info_get(local, ifmgd->bssid);
 		if (!sta) {
 			rcu_read_unlock();
 			return;
@@ -1997,85 +1534,16 @@ static void ieee80211_rx_mgmt_beacon(str
 	ieee80211_bss_info_change_notify(sdata, changed);
 }
 
-
-static void ieee80211_rx_mgmt_probe_req(struct ieee80211_sub_if_data *sdata,
-					struct ieee80211_if_sta *ifsta,
-					struct ieee80211_mgmt *mgmt,
-					size_t len)
-{
-	struct ieee80211_local *local = sdata->local;
-	int tx_last_beacon;
-	struct sk_buff *skb;
-	struct ieee80211_mgmt *resp;
-	u8 *pos, *end;
-
-	if (ifsta->state != IEEE80211_STA_MLME_IBSS_JOINED ||
-	    len < 24 + 2 || !ifsta->probe_resp)
-		return;
-
-	if (local->ops->tx_last_beacon)
-		tx_last_beacon = local->ops->tx_last_beacon(local_to_hw(local));
-	else
-		tx_last_beacon = 1;
-
-#ifdef CONFIG_MAC80211_IBSS_DEBUG
-	printk(KERN_DEBUG "%s: RX ProbeReq SA=%pM DA=%pM BSSID=%pM"
-	       " (tx_last_beacon=%d)\n",
-	       sdata->dev->name, mgmt->sa, mgmt->da,
-	       mgmt->bssid, tx_last_beacon);
-#endif /* CONFIG_MAC80211_IBSS_DEBUG */
-
-	if (!tx_last_beacon)
-		return;
-
-	if (memcmp(mgmt->bssid, ifsta->bssid, ETH_ALEN) != 0 &&
-	    memcmp(mgmt->bssid, "\xff\xff\xff\xff\xff\xff", ETH_ALEN) != 0)
-		return;
-
-	end = ((u8 *) mgmt) + len;
-	pos = mgmt->u.probe_req.variable;
-	if (pos[0] != WLAN_EID_SSID ||
-	    pos + 2 + pos[1] > end) {
-#ifdef CONFIG_MAC80211_IBSS_DEBUG
-		printk(KERN_DEBUG "%s: Invalid SSID IE in ProbeReq "
-		       "from %pM\n",
-		       sdata->dev->name, mgmt->sa);
-#endif
-		return;
-	}
-	if (pos[1] != 0 &&
-	    (pos[1] != ifsta->ssid_len ||
-	     memcmp(pos + 2, ifsta->ssid, ifsta->ssid_len) != 0)) {
-		/* Ignore ProbeReq for foreign SSID */
-		return;
-	}
-
-	/* Reply with ProbeResp */
-	skb = skb_copy(ifsta->probe_resp, GFP_KERNEL);
-	if (!skb)
-		return;
-
-	resp = (struct ieee80211_mgmt *) skb->data;
-	memcpy(resp->da, mgmt->sa, ETH_ALEN);
-#ifdef CONFIG_MAC80211_IBSS_DEBUG
-	printk(KERN_DEBUG "%s: Sending ProbeResp to %pM\n",
-	       sdata->dev->name, resp->da);
-#endif /* CONFIG_MAC80211_IBSS_DEBUG */
-	ieee80211_tx_skb(sdata, skb, 0);
-}
-
-void ieee80211_sta_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
-			   struct ieee80211_rx_status *rx_status)
+ieee80211_rx_result ieee80211_sta_rx_mgmt(struct ieee80211_sub_if_data *sdata,
+					  struct sk_buff *skb,
+					  struct ieee80211_rx_status *rx_status)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_if_sta *ifsta;
 	struct ieee80211_mgmt *mgmt;
 	u16 fc;
 
 	if (skb->len < 24)
-		goto fail;
-
-	ifsta = &sdata->u.sta;
+		return RX_DROP_MONITOR;
 
 	mgmt = (struct ieee80211_mgmt *) skb->data;
 	fc = le16_to_cpu(mgmt->frame_control);
@@ -2090,147 +1558,68 @@ void ieee80211_sta_rx_mgmt(struct ieee80
 	case IEEE80211_STYPE_REASSOC_RESP:
 	case IEEE80211_STYPE_DEAUTH:
 	case IEEE80211_STYPE_DISASSOC:
-		skb_queue_tail(&ifsta->skb_queue, skb);
-		queue_work(local->hw.workqueue, &ifsta->work);
-		return;
+		skb_queue_tail(&sdata->u.mgd.skb_queue, skb);
+		queue_work(local->hw.workqueue, &sdata->u.mgd.work);
+		return RX_QUEUED;
 	}
 
- fail:
-	kfree_skb(skb);
+	return RX_DROP_MONITOR;
 }
 
 static void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 					 struct sk_buff *skb)
 {
 	struct ieee80211_rx_status *rx_status;
-	struct ieee80211_if_sta *ifsta;
 	struct ieee80211_mgmt *mgmt;
 	u16 fc;
 
-	ifsta = &sdata->u.sta;
-
 	rx_status = (struct ieee80211_rx_status *) skb->cb;
 	mgmt = (struct ieee80211_mgmt *) skb->data;
 	fc = le16_to_cpu(mgmt->frame_control);
 
-	if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
-		switch (fc & IEEE80211_FCTL_STYPE) {
-		case IEEE80211_STYPE_PROBE_REQ:
-			ieee80211_rx_mgmt_probe_req(sdata, ifsta, mgmt,
-						    skb->len);
-			break;
-		case IEEE80211_STYPE_PROBE_RESP:
-			ieee80211_rx_mgmt_probe_resp(sdata, mgmt, skb->len,
-						     rx_status);
-			break;
-		case IEEE80211_STYPE_BEACON:
-			ieee80211_rx_mgmt_beacon(sdata, mgmt, skb->len,
-						 rx_status);
-			break;
-		case IEEE80211_STYPE_AUTH:
-			ieee80211_rx_mgmt_auth_ibss(sdata, ifsta, mgmt,
-						    skb->len);
-			break;
-		}
-	} else { /* NL80211_IFTYPE_STATION */
-		switch (fc & IEEE80211_FCTL_STYPE) {
-		case IEEE80211_STYPE_PROBE_RESP:
-			ieee80211_rx_mgmt_probe_resp(sdata, mgmt, skb->len,
-						     rx_status);
-			break;
-		case IEEE80211_STYPE_BEACON:
-			ieee80211_rx_mgmt_beacon(sdata, mgmt, skb->len,
-						 rx_status);
-			break;
-		case IEEE80211_STYPE_AUTH:
-			ieee80211_rx_mgmt_auth(sdata, ifsta, mgmt, skb->len);
-			break;
-		case IEEE80211_STYPE_ASSOC_RESP:
-			ieee80211_rx_mgmt_assoc_resp(sdata, ifsta, mgmt,
-						     skb->len, 0);
-			break;
-		case IEEE80211_STYPE_REASSOC_RESP:
-			ieee80211_rx_mgmt_assoc_resp(sdata, ifsta, mgmt,
-						     skb->len, 1);
-			break;
-		case IEEE80211_STYPE_DEAUTH:
-			ieee80211_rx_mgmt_deauth(sdata, ifsta, mgmt, skb->len);
-			break;
-		case IEEE80211_STYPE_DISASSOC:
-			ieee80211_rx_mgmt_disassoc(sdata, ifsta, mgmt,
-						   skb->len);
-			break;
-		}
+	switch (fc & IEEE80211_FCTL_STYPE) {
+	case IEEE80211_STYPE_PROBE_RESP:
+		ieee80211_rx_mgmt_probe_resp(sdata, mgmt, skb->len,
+					     rx_status);
+		break;
+	case IEEE80211_STYPE_BEACON:
+		ieee80211_rx_mgmt_beacon(sdata, mgmt, skb->len,
+					 rx_status);
+		break;
+	case IEEE80211_STYPE_AUTH:
+		ieee80211_rx_mgmt_auth(sdata, mgmt, skb->len);
+		break;
+	case IEEE80211_STYPE_ASSOC_RESP:
+		ieee80211_rx_mgmt_assoc_resp(sdata, mgmt, skb->len, 0);
+		break;
+	case IEEE80211_STYPE_REASSOC_RESP:
+		ieee80211_rx_mgmt_assoc_resp(sdata, mgmt, skb->len, 1);
+		break;
+	case IEEE80211_STYPE_DEAUTH:
+		ieee80211_rx_mgmt_deauth(sdata, mgmt, skb->len);
+		break;
+	case IEEE80211_STYPE_DISASSOC:
+		ieee80211_rx_mgmt_disassoc(sdata, mgmt, skb->len);
+		break;
 	}
 
 	kfree_skb(skb);
 }
 
-
-static int ieee80211_sta_active_ibss(struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_local *local = sdata->local;
-	int active = 0;
-	struct sta_info *sta;
-
-	rcu_read_lock();
-
-	list_for_each_entry_rcu(sta, &local->sta_list, list) {
-		if (sta->sdata == sdata &&
-		    time_after(sta->last_rx + IEEE80211_IBSS_MERGE_INTERVAL,
-			       jiffies)) {
-			active++;
-			break;
-		}
-	}
-
-	rcu_read_unlock();
-
-	return active;
-}
-
-
-static void ieee80211_sta_merge_ibss(struct ieee80211_sub_if_data *sdata,
-				     struct ieee80211_if_sta *ifsta)
-{
-	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
-
-	ieee80211_sta_expire(sdata, IEEE80211_IBSS_INACTIVITY_LIMIT);
-	if (ieee80211_sta_active_ibss(sdata))
-		return;
-
-	if ((sdata->u.sta.flags & IEEE80211_STA_BSSID_SET) &&
-	    (!(sdata->u.sta.flags & IEEE80211_STA_AUTO_CHANNEL_SEL)))
-		return;
-
-	printk(KERN_DEBUG "%s: No active IBSS STAs - trying to scan for other "
-	       "IBSS networks with same SSID (merge)\n", sdata->dev->name);
-
-	/* XXX maybe racy? */
-	if (sdata->local->scan_req)
-		return;
-
-	memcpy(sdata->local->int_scan_req.ssids[0].ssid,
-	       ifsta->ssid, IEEE80211_MAX_SSID_LEN);
-	sdata->local->int_scan_req.ssids[0].ssid_len = ifsta->ssid_len;
-	ieee80211_request_scan(sdata, &sdata->local->int_scan_req);
-}
-
-
 static void ieee80211_sta_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
 
-	set_bit(IEEE80211_STA_REQ_RUN, &ifsta->request);
-	queue_work(local->hw.workqueue, &ifsta->work);
+	set_bit(IEEE80211_STA_REQ_RUN, &ifmgd->request);
+	queue_work(local->hw.workqueue, &ifmgd->work);
 }
 
-static void ieee80211_sta_reset_auth(struct ieee80211_sub_if_data *sdata,
-				     struct ieee80211_if_sta *ifsta)
+static void ieee80211_sta_reset_auth(struct ieee80211_sub_if_data *sdata)
 {
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
 
 	if (local->ops->reset_tsf) {
@@ -2238,191 +1627,39 @@ static void ieee80211_sta_reset_auth(str
 		local->ops->reset_tsf(local_to_hw(local));
 	}
 
-	ifsta->wmm_last_param_set = -1; /* allow any WMM update */
+	ifmgd->wmm_last_param_set = -1; /* allow any WMM update */
 
 
-	if (ifsta->auth_algs & IEEE80211_AUTH_ALG_OPEN)
-		ifsta->auth_alg = WLAN_AUTH_OPEN;
-	else if (ifsta->auth_algs & IEEE80211_AUTH_ALG_SHARED_KEY)
-		ifsta->auth_alg = WLAN_AUTH_SHARED_KEY;
-	else if (ifsta->auth_algs & IEEE80211_AUTH_ALG_LEAP)
-		ifsta->auth_alg = WLAN_AUTH_LEAP;
+	if (ifmgd->auth_algs & IEEE80211_AUTH_ALG_OPEN)
+		ifmgd->auth_alg = WLAN_AUTH_OPEN;
+	else if (ifmgd->auth_algs & IEEE80211_AUTH_ALG_SHARED_KEY)
+		ifmgd->auth_alg = WLAN_AUTH_SHARED_KEY;
+	else if (ifmgd->auth_algs & IEEE80211_AUTH_ALG_LEAP)
+		ifmgd->auth_alg = WLAN_AUTH_LEAP;
 	else
-		ifsta->auth_alg = WLAN_AUTH_OPEN;
-	ifsta->auth_transaction = -1;
-	ifsta->flags &= ~IEEE80211_STA_ASSOCIATED;
-	ifsta->assoc_scan_tries = 0;
-	ifsta->direct_probe_tries = 0;
-	ifsta->auth_tries = 0;
-	ifsta->assoc_tries = 0;
+		ifmgd->auth_alg = WLAN_AUTH_OPEN;
+	ifmgd->auth_transaction = -1;
+	ifmgd->flags &= ~IEEE80211_STA_ASSOCIATED;
+	ifmgd->assoc_scan_tries = 0;
+	ifmgd->direct_probe_tries = 0;
+	ifmgd->auth_tries = 0;
+	ifmgd->assoc_tries = 0;
 	netif_tx_stop_all_queues(sdata->dev);
 	netif_carrier_off(sdata->dev);
 }
 
-static int ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata,
-				     struct ieee80211_if_sta *ifsta)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_supported_band *sband;
-	u8 *pos;
-	u8 bssid[ETH_ALEN];
-	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
-	u16 capability;
-	int i;
-
-	if (sdata->u.sta.flags & IEEE80211_STA_BSSID_SET) {
-		memcpy(bssid, ifsta->bssid, ETH_ALEN);
-	} else {
-		/* Generate random, not broadcast, locally administered BSSID. Mix in
-		 * own MAC address to make sure that devices that do not have proper
-		 * random number generator get different BSSID. */
-		get_random_bytes(bssid, ETH_ALEN);
-		for (i = 0; i < ETH_ALEN; i++)
-			bssid[i] ^= sdata->dev->dev_addr[i];
-		bssid[0] &= ~0x01;
-		bssid[0] |= 0x02;
-	}
-
-	printk(KERN_DEBUG "%s: Creating new IBSS network, BSSID %pM\n",
-	       sdata->dev->name, bssid);
-
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-
-	if (local->hw.conf.beacon_int == 0)
-		local->hw.conf.beacon_int = 100;
-
-	capability = WLAN_CAPABILITY_IBSS;
-
-	if (sdata->default_key)
-		capability |= WLAN_CAPABILITY_PRIVACY;
-	else
-		sdata->drop_unencrypted = 0;
-
-	pos = supp_rates;
-	for (i = 0; i < sband->n_bitrates; i++) {
-		int rate = sband->bitrates[i].bitrate;
-		*pos++ = (u8) (rate / 5);
-	}
-
-	return __ieee80211_sta_join_ibss(sdata, ifsta,
-					 bssid, local->hw.conf.beacon_int,
-					 local->hw.conf.channel->center_freq,
-					 sband->n_bitrates, supp_rates,
-					 capability);
-}
-
-
-static int ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata,
-				   struct ieee80211_if_sta *ifsta)
+static int ieee80211_sta_config_auth(struct ieee80211_sub_if_data *sdata)
 {
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_bss *bss;
-	int active_ibss;
-
-	if (ifsta->ssid_len == 0)
-		return -EINVAL;
-
-	active_ibss = ieee80211_sta_active_ibss(sdata);
-#ifdef CONFIG_MAC80211_IBSS_DEBUG
-	printk(KERN_DEBUG "%s: sta_find_ibss (active_ibss=%d)\n",
-	       sdata->dev->name, active_ibss);
-#endif /* CONFIG_MAC80211_IBSS_DEBUG */
-
-	if (active_ibss)
-		return 0;
-
-	if (ifsta->flags & IEEE80211_STA_BSSID_SET)
-		bss = ieee80211_rx_bss_get(local, ifsta->bssid, 0,
-					   ifsta->ssid, ifsta->ssid_len);
-	else
-		bss = (void *)cfg80211_get_ibss(local->hw.wiphy,
-						NULL,
-						ifsta->ssid, ifsta->ssid_len);
-
-#ifdef CONFIG_MAC80211_IBSS_DEBUG
-	if (bss)
-		printk(KERN_DEBUG "   sta_find_ibss: selected %pM current "
-		       "%pM\n", bss->cbss.bssid, ifsta->bssid);
-#endif /* CONFIG_MAC80211_IBSS_DEBUG */
-
-	if (bss &&
-	    (!(ifsta->flags & IEEE80211_STA_PREV_BSSID_SET) ||
-	     memcmp(ifsta->bssid, bss->cbss.bssid, ETH_ALEN))) {
-		int ret;
-
-		printk(KERN_DEBUG "%s: Selected IBSS BSSID %pM"
-		       " based on configured SSID\n",
-		       sdata->dev->name, bss->cbss.bssid);
-
-		ret = ieee80211_sta_join_ibss(sdata, ifsta, bss);
-		ieee80211_rx_bss_put(local, bss);
-		return ret;
-	} else if (bss)
-		ieee80211_rx_bss_put(local, bss);
-
-#ifdef CONFIG_MAC80211_IBSS_DEBUG
-	printk(KERN_DEBUG "   did not try to join ibss\n");
-#endif /* CONFIG_MAC80211_IBSS_DEBUG */
-
-	/* Selected IBSS not found in current scan results - try to scan */
-	if (ifsta->state == IEEE80211_STA_MLME_IBSS_JOINED &&
-	    !ieee80211_sta_active_ibss(sdata)) {
-		mod_timer(&ifsta->timer, jiffies +
-				      IEEE80211_IBSS_MERGE_INTERVAL);
-	} else if (time_after(jiffies, local->last_scan_completed +
-			      IEEE80211_SCAN_INTERVAL)) {
-		printk(KERN_DEBUG "%s: Trigger new scan to find an IBSS to "
-		       "join\n", sdata->dev->name);
-
-		/* XXX maybe racy? */
-		if (local->scan_req)
-			return -EBUSY;
-
-		memcpy(local->int_scan_req.ssids[0].ssid,
-		       ifsta->ssid, IEEE80211_MAX_SSID_LEN);
-		local->int_scan_req.ssids[0].ssid_len = ifsta->ssid_len;
-		return ieee80211_request_scan(sdata, &local->int_scan_req);
-	} else if (ifsta->state != IEEE80211_STA_MLME_IBSS_JOINED) {
-		int interval = IEEE80211_SCAN_INTERVAL;
-
-		if (time_after(jiffies, ifsta->ibss_join_req +
-			       IEEE80211_IBSS_JOIN_TIMEOUT)) {
-			if ((ifsta->flags & IEEE80211_STA_CREATE_IBSS) &&
-			    (!(local->oper_channel->flags &
-					IEEE80211_CHAN_NO_IBSS)))
-				return ieee80211_sta_create_ibss(sdata, ifsta);
-			if (ifsta->flags & IEEE80211_STA_CREATE_IBSS) {
-				printk(KERN_DEBUG "%s: IBSS not allowed on"
-				       " %d MHz\n", sdata->dev->name,
-				       local->hw.conf.channel->center_freq);
-			}
-
-			/* No IBSS found - decrease scan interval and continue
-			 * scanning. */
-			interval = IEEE80211_SCAN_INTERVAL_SLOW;
-		}
-
-		ifsta->state = IEEE80211_STA_MLME_IBSS_SEARCH;
-		mod_timer(&ifsta->timer, jiffies + interval);
-		return 0;
-	}
-
-	return 0;
-}
-
-
-static int ieee80211_sta_config_auth(struct ieee80211_sub_if_data *sdata,
-				     struct ieee80211_if_sta *ifsta)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_bss *bss;
-	u8 *bssid = ifsta->bssid, *ssid = ifsta->ssid;
-	u8 ssid_len = ifsta->ssid_len;
+	u8 *bssid = ifmgd->bssid, *ssid = ifmgd->ssid;
+	u8 ssid_len = ifmgd->ssid_len;
 	u16 capa_mask = WLAN_CAPABILITY_ESS;
 	u16 capa_val = WLAN_CAPABILITY_ESS;
 	struct ieee80211_channel *chan = local->oper_channel;
 
-	if (ifsta->flags & (IEEE80211_STA_AUTO_SSID_SEL |
+	if (ifmgd->flags & (IEEE80211_STA_AUTO_SSID_SEL |
 			    IEEE80211_STA_AUTO_BSSID_SEL |
 			    IEEE80211_STA_AUTO_CHANNEL_SEL)) {
 		capa_mask |= WLAN_CAPABILITY_PRIVACY;
@@ -2430,13 +1667,13 @@ static int ieee80211_sta_config_auth(str
 			capa_val |= WLAN_CAPABILITY_PRIVACY;
 	}
 
-	if (ifsta->flags & IEEE80211_STA_AUTO_CHANNEL_SEL)
+	if (ifmgd->flags & IEEE80211_STA_AUTO_CHANNEL_SEL)
 		chan = NULL;
 
-	if (ifsta->flags & IEEE80211_STA_AUTO_BSSID_SEL)
+	if (ifmgd->flags & IEEE80211_STA_AUTO_BSSID_SEL)
 		bssid = NULL;
 
-	if (ifsta->flags & IEEE80211_STA_AUTO_SSID_SEL) {
+	if (ifmgd->flags & IEEE80211_STA_AUTO_SSID_SEL) {
 		ssid = NULL;
 		ssid_len = 0;
 	}
@@ -2447,16 +1684,16 @@ static int ieee80211_sta_config_auth(str
 
 	if (bss) {
 		ieee80211_set_freq(sdata, bss->cbss.channel->center_freq);
-		if (!(ifsta->flags & IEEE80211_STA_SSID_SET))
+		if (!(ifmgd->flags & IEEE80211_STA_SSID_SET))
 			ieee80211_sta_set_ssid(sdata, bss->ssid,
 					       bss->ssid_len);
 		ieee80211_sta_set_bssid(sdata, bss->cbss.bssid);
 		ieee80211_sta_def_wmm_params(sdata, bss->supp_rates_len,
 						    bss->supp_rates);
-		if (sdata->u.sta.mfp == IEEE80211_MFP_REQUIRED)
-			sdata->u.sta.flags |= IEEE80211_STA_MFP_ENABLED;
+		if (sdata->u.mgd.mfp == IEEE80211_MFP_REQUIRED)
+			sdata->u.mgd.flags |= IEEE80211_STA_MFP_ENABLED;
 		else
-			sdata->u.sta.flags &= ~IEEE80211_STA_MFP_ENABLED;
+			sdata->u.mgd.flags &= ~IEEE80211_STA_MFP_ENABLED;
 
 		/* Send out direct probe if no probe resp was received or
 		 * the one we have is outdated
@@ -2464,31 +1701,31 @@ static int ieee80211_sta_config_auth(str
 		if (!bss->last_probe_resp ||
 		    time_after(jiffies, bss->last_probe_resp
 					+ IEEE80211_SCAN_RESULT_EXPIRE))
-			ifsta->state = IEEE80211_STA_MLME_DIRECT_PROBE;
+			ifmgd->state = IEEE80211_STA_MLME_DIRECT_PROBE;
 		else
-			ifsta->state = IEEE80211_STA_MLME_AUTHENTICATE;
+			ifmgd->state = IEEE80211_STA_MLME_AUTHENTICATE;
 
 		ieee80211_rx_bss_put(local, bss);
-		ieee80211_sta_reset_auth(sdata, ifsta);
+		ieee80211_sta_reset_auth(sdata);
 		return 0;
 	} else {
-		if (ifsta->assoc_scan_tries < IEEE80211_ASSOC_SCANS_MAX_TRIES) {
-			ifsta->assoc_scan_tries++;
+		if (ifmgd->assoc_scan_tries < IEEE80211_ASSOC_SCANS_MAX_TRIES) {
+			ifmgd->assoc_scan_tries++;
 			/* XXX maybe racy? */
 			if (local->scan_req)
 				return -1;
 			memcpy(local->int_scan_req.ssids[0].ssid,
-			       ifsta->ssid, IEEE80211_MAX_SSID_LEN);
-			if (ifsta->flags & IEEE80211_STA_AUTO_SSID_SEL)
+			       ifmgd->ssid, IEEE80211_MAX_SSID_LEN);
+			if (ifmgd->flags & IEEE80211_STA_AUTO_SSID_SEL)
 				local->int_scan_req.ssids[0].ssid_len = 0;
 			else
-				local->int_scan_req.ssids[0].ssid_len = ifsta->ssid_len;
+				local->int_scan_req.ssids[0].ssid_len = ifmgd->ssid_len;
 			ieee80211_start_scan(sdata, &local->int_scan_req);
-			ifsta->state = IEEE80211_STA_MLME_AUTHENTICATE;
-			set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
+			ifmgd->state = IEEE80211_STA_MLME_AUTHENTICATE;
+			set_bit(IEEE80211_STA_REQ_AUTH, &ifmgd->request);
 		} else {
-			ifsta->assoc_scan_tries = 0;
-			ifsta->state = IEEE80211_STA_MLME_DISABLED;
+			ifmgd->assoc_scan_tries = 0;
+			ifmgd->state = IEEE80211_STA_MLME_DISABLED;
 		}
 	}
 	return -1;
@@ -2498,9 +1735,9 @@ static int ieee80211_sta_config_auth(str
 static void ieee80211_sta_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
-		container_of(work, struct ieee80211_sub_if_data, u.sta.work);
+		container_of(work, struct ieee80211_sub_if_data, u.mgd.work);
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_if_sta *ifsta;
+	struct ieee80211_if_managed *ifmgd;
 	struct sk_buff *skb;
 
 	if (!netif_running(sdata->dev))
@@ -2509,60 +1746,53 @@ static void ieee80211_sta_work(struct wo
 	if (local->sw_scanning || local->hw_scanning)
 		return;
 
-	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION &&
-		    sdata->vif.type != NL80211_IFTYPE_ADHOC))
+	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION))
 		return;
-	ifsta = &sdata->u.sta;
+	ifmgd = &sdata->u.mgd;
 
-	while ((skb = skb_dequeue(&ifsta->skb_queue)))
+	while ((skb = skb_dequeue(&ifmgd->skb_queue)))
 		ieee80211_sta_rx_queued_mgmt(sdata, skb);
 
-	if (ifsta->state != IEEE80211_STA_MLME_DIRECT_PROBE &&
-	    ifsta->state != IEEE80211_STA_MLME_AUTHENTICATE &&
-	    ifsta->state != IEEE80211_STA_MLME_ASSOCIATE &&
-	    test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request)) {
+	if (ifmgd->state != IEEE80211_STA_MLME_DIRECT_PROBE &&
+	    ifmgd->state != IEEE80211_STA_MLME_AUTHENTICATE &&
+	    ifmgd->state != IEEE80211_STA_MLME_ASSOCIATE &&
+	    test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifmgd->request)) {
 		ieee80211_start_scan(sdata, local->scan_req);
 		return;
 	}
 
-	if (test_and_clear_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request)) {
-		if (ieee80211_sta_config_auth(sdata, ifsta))
+	if (test_and_clear_bit(IEEE80211_STA_REQ_AUTH, &ifmgd->request)) {
+		if (ieee80211_sta_config_auth(sdata))
 			return;
-		clear_bit(IEEE80211_STA_REQ_RUN, &ifsta->request);
-	} else if (!test_and_clear_bit(IEEE80211_STA_REQ_RUN, &ifsta->request))
+		clear_bit(IEEE80211_STA_REQ_RUN, &ifmgd->request);
+	} else if (!test_and_clear_bit(IEEE80211_STA_REQ_RUN, &ifmgd->request))
 		return;
 
-	switch (ifsta->state) {
+	switch (ifmgd->state) {
 	case IEEE80211_STA_MLME_DISABLED:
 		break;
 	case IEEE80211_STA_MLME_DIRECT_PROBE:
-		ieee80211_direct_probe(sdata, ifsta);
+		ieee80211_direct_probe(sdata);
 		break;
 	case IEEE80211_STA_MLME_AUTHENTICATE:
-		ieee80211_authenticate(sdata, ifsta);
+		ieee80211_authenticate(sdata);
 		break;
 	case IEEE80211_STA_MLME_ASSOCIATE:
-		ieee80211_associate(sdata, ifsta);
+		ieee80211_associate(sdata);
 		break;
 	case IEEE80211_STA_MLME_ASSOCIATED:
-		ieee80211_associated(sdata, ifsta);
-		break;
-	case IEEE80211_STA_MLME_IBSS_SEARCH:
-		ieee80211_sta_find_ibss(sdata, ifsta);
-		break;
-	case IEEE80211_STA_MLME_IBSS_JOINED:
-		ieee80211_sta_merge_ibss(sdata, ifsta);
+		ieee80211_associated(sdata);
 		break;
 	default:
 		WARN_ON(1);
 		break;
 	}
 
-	if (ieee80211_privacy_mismatch(sdata, ifsta)) {
+	if (ieee80211_privacy_mismatch(sdata)) {
 		printk(KERN_DEBUG "%s: privacy configuration mismatch and "
 		       "mixed-cell disabled - disassociate\n", sdata->dev->name);
 
-		ieee80211_set_disassoc(sdata, ifsta, false, true,
+		ieee80211_set_disassoc(sdata, false, true,
 					WLAN_REASON_UNSPECIFIED);
 	}
 }
@@ -2571,155 +1801,99 @@ static void ieee80211_restart_sta_timer(
 {
 	if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		queue_work(sdata->local->hw.workqueue,
-			   &sdata->u.sta.work);
+			   &sdata->u.mgd.work);
 }
 
 /* interface setup */
 void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_sta *ifsta;
+	struct ieee80211_if_managed *ifmgd;
 
-	ifsta = &sdata->u.sta;
-	INIT_WORK(&ifsta->work, ieee80211_sta_work);
-	INIT_WORK(&ifsta->chswitch_work, ieee80211_chswitch_work);
-	setup_timer(&ifsta->timer, ieee80211_sta_timer,
+	ifmgd = &sdata->u.mgd;
+	INIT_WORK(&ifmgd->work, ieee80211_sta_work);
+	INIT_WORK(&ifmgd->chswitch_work, ieee80211_chswitch_work);
+	setup_timer(&ifmgd->timer, ieee80211_sta_timer,
 		    (unsigned long) sdata);
-	setup_timer(&ifsta->chswitch_timer, ieee80211_chswitch_timer,
+	setup_timer(&ifmgd->chswitch_timer, ieee80211_chswitch_timer,
 		    (unsigned long) sdata);
-	skb_queue_head_init(&ifsta->skb_queue);
+	skb_queue_head_init(&ifmgd->skb_queue);
 
-	ifsta->capab = WLAN_CAPABILITY_ESS;
-	ifsta->auth_algs = IEEE80211_AUTH_ALG_OPEN |
+	ifmgd->capab = WLAN_CAPABILITY_ESS;
+	ifmgd->auth_algs = IEEE80211_AUTH_ALG_OPEN |
 		IEEE80211_AUTH_ALG_SHARED_KEY;
-	ifsta->flags |= IEEE80211_STA_CREATE_IBSS |
+	ifmgd->flags |= IEEE80211_STA_CREATE_IBSS |
 		IEEE80211_STA_AUTO_BSSID_SEL |
 		IEEE80211_STA_AUTO_CHANNEL_SEL;
 	if (ieee80211_num_regular_queues(&sdata->local->hw) >= 4)
-		ifsta->flags |= IEEE80211_STA_WMM_ENABLED;
-}
-
-/*
- * Add a new IBSS station, will also be called by the RX code when,
- * in IBSS mode, receiving a frame from a yet-unknown station, hence
- * must be callable in atomic context.
- */
-struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
-					u8 *bssid,u8 *addr, u32 supp_rates)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct sta_info *sta;
-	int band = local->hw.conf.channel->band;
-
-	/* TODO: Could consider removing the least recently used entry and
-	 * allow new one to be added. */
-	if (local->num_sta >= IEEE80211_IBSS_MAX_STA_ENTRIES) {
-		if (net_ratelimit()) {
-			printk(KERN_DEBUG "%s: No room for a new IBSS STA "
-			       "entry %pM\n", sdata->dev->name, addr);
-		}
-		return NULL;
-	}
-
-	if (compare_ether_addr(bssid, sdata->u.sta.bssid))
-		return NULL;
-
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	printk(KERN_DEBUG "%s: Adding new IBSS station %pM (dev=%s)\n",
-	       wiphy_name(local->hw.wiphy), addr, sdata->dev->name);
-#endif
-
-	sta = sta_info_alloc(sdata, addr, GFP_ATOMIC);
-	if (!sta)
-		return NULL;
-
-	set_sta_flags(sta, WLAN_STA_AUTHORIZED);
-
-	/* make sure mandatory rates are always added */
-	sta->sta.supp_rates[band] = supp_rates |
-			ieee80211_mandatory_rates(local, band);
-
-	rate_control_rate_init(sta);
-
-	if (sta_info_insert(sta))
-		return NULL;
-
-	return sta;
+		ifmgd->flags |= IEEE80211_STA_WMM_ENABLED;
 }
 
 /* configuration hooks */
-void ieee80211_sta_req_auth(struct ieee80211_sub_if_data *sdata,
-			    struct ieee80211_if_sta *ifsta)
+void ieee80211_sta_req_auth(struct ieee80211_sub_if_data *sdata)
 {
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
 
-	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION))
 		return;
 
-	if ((ifsta->flags & (IEEE80211_STA_BSSID_SET |
+	if ((ifmgd->flags & (IEEE80211_STA_BSSID_SET |
 			     IEEE80211_STA_AUTO_BSSID_SEL)) &&
-	    (ifsta->flags & (IEEE80211_STA_SSID_SET |
+	    (ifmgd->flags & (IEEE80211_STA_SSID_SET |
 			     IEEE80211_STA_AUTO_SSID_SEL))) {
 
-		if (ifsta->state == IEEE80211_STA_MLME_ASSOCIATED)
-			ieee80211_set_disassoc(sdata, ifsta, true, true,
+		if (ifmgd->state == IEEE80211_STA_MLME_ASSOCIATED)
+			ieee80211_set_disassoc(sdata, true, true,
 					       WLAN_REASON_DEAUTH_LEAVING);
 
-		set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
-		queue_work(local->hw.workqueue, &ifsta->work);
+		set_bit(IEEE80211_STA_REQ_AUTH, &ifmgd->request);
+		queue_work(local->hw.workqueue, &ifmgd->work);
 	}
 }
 
 int ieee80211_sta_set_ssid(struct ieee80211_sub_if_data *sdata, char *ssid, size_t len)
 {
-	struct ieee80211_if_sta *ifsta;
+	struct ieee80211_if_managed *ifmgd;
 
 	if (len > IEEE80211_MAX_SSID_LEN)
 		return -EINVAL;
 
-	ifsta = &sdata->u.sta;
+	ifmgd = &sdata->u.mgd;
 
-	if (ifsta->ssid_len != len || memcmp(ifsta->ssid, ssid, len) != 0) {
-		memset(ifsta->ssid, 0, sizeof(ifsta->ssid));
-		memcpy(ifsta->ssid, ssid, len);
-		ifsta->ssid_len = len;
+	if (ifmgd->ssid_len != len || memcmp(ifmgd->ssid, ssid, len) != 0) {
+		memset(ifmgd->ssid, 0, sizeof(ifmgd->ssid));
+		memcpy(ifmgd->ssid, ssid, len);
+		ifmgd->ssid_len = len;
 	}
 
-	ifsta->flags &= ~IEEE80211_STA_PREV_BSSID_SET;
+	ifmgd->flags &= ~IEEE80211_STA_PREV_BSSID_SET;
 
 	if (len)
-		ifsta->flags |= IEEE80211_STA_SSID_SET;
+		ifmgd->flags |= IEEE80211_STA_SSID_SET;
 	else
-		ifsta->flags &= ~IEEE80211_STA_SSID_SET;
-
-	if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
-		ifsta->ibss_join_req = jiffies;
-		ifsta->state = IEEE80211_STA_MLME_IBSS_SEARCH;
-		return ieee80211_sta_find_ibss(sdata, ifsta);
-	}
+		ifmgd->flags &= ~IEEE80211_STA_SSID_SET;
 
 	return 0;
 }
 
 int ieee80211_sta_get_ssid(struct ieee80211_sub_if_data *sdata, char *ssid, size_t *len)
 {
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
-	memcpy(ssid, ifsta->ssid, ifsta->ssid_len);
-	*len = ifsta->ssid_len;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	memcpy(ssid, ifmgd->ssid, ifmgd->ssid_len);
+	*len = ifmgd->ssid_len;
 	return 0;
 }
 
 int ieee80211_sta_set_bssid(struct ieee80211_sub_if_data *sdata, u8 *bssid)
 {
-	struct ieee80211_if_sta *ifsta;
-
-	ifsta = &sdata->u.sta;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	if (is_valid_ether_addr(bssid)) {
-		memcpy(ifsta->bssid, bssid, ETH_ALEN);
-		ifsta->flags |= IEEE80211_STA_BSSID_SET;
+		memcpy(ifmgd->bssid, bssid, ETH_ALEN);
+		ifmgd->flags |= IEEE80211_STA_BSSID_SET;
 	} else {
-		memset(ifsta->bssid, 0, ETH_ALEN);
-		ifsta->flags &= ~IEEE80211_STA_BSSID_SET;
+		memset(ifmgd->bssid, 0, ETH_ALEN);
+		ifmgd->flags &= ~IEEE80211_STA_BSSID_SET;
 	}
 
 	if (netif_running(sdata->dev)) {
@@ -2729,47 +1903,44 @@ int ieee80211_sta_set_bssid(struct ieee8
 		}
 	}
 
-	return ieee80211_sta_set_ssid(sdata, ifsta->ssid, ifsta->ssid_len);
+	return ieee80211_sta_set_ssid(sdata, ifmgd->ssid, ifmgd->ssid_len);
 }
 
 int ieee80211_sta_set_extra_ie(struct ieee80211_sub_if_data *sdata, char *ie, size_t len)
 {
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
-	kfree(ifsta->extra_ie);
+	kfree(ifmgd->extra_ie);
 	if (len == 0) {
-		ifsta->extra_ie = NULL;
-		ifsta->extra_ie_len = 0;
+		ifmgd->extra_ie = NULL;
+		ifmgd->extra_ie_len = 0;
 		return 0;
 	}
-	ifsta->extra_ie = kmalloc(len, GFP_KERNEL);
-	if (!ifsta->extra_ie) {
-		ifsta->extra_ie_len = 0;
+	ifmgd->extra_ie = kmalloc(len, GFP_KERNEL);
+	if (!ifmgd->extra_ie) {
+		ifmgd->extra_ie_len = 0;
 		return -ENOMEM;
 	}
-	memcpy(ifsta->extra_ie, ie, len);
-	ifsta->extra_ie_len = len;
+	memcpy(ifmgd->extra_ie, ie, len);
+	ifmgd->extra_ie_len = len;
 	return 0;
 }
 
 int ieee80211_sta_deauthenticate(struct ieee80211_sub_if_data *sdata, u16 reason)
 {
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
-
 	printk(KERN_DEBUG "%s: deauthenticating by local choice (reason=%d)\n",
 	       sdata->dev->name, reason);
 
-	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
-	    sdata->vif.type != NL80211_IFTYPE_ADHOC)
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return -EINVAL;
 
-	ieee80211_set_disassoc(sdata, ifsta, true, true, reason);
+	ieee80211_set_disassoc(sdata, true, true, reason);
 	return 0;
 }
 
 int ieee80211_sta_disassociate(struct ieee80211_sub_if_data *sdata, u16 reason)
 {
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	printk(KERN_DEBUG "%s: disassociating by local choice (reason=%d)\n",
 	       sdata->dev->name, reason);
@@ -2777,10 +1948,10 @@ int ieee80211_sta_disassociate(struct ie
 	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return -EINVAL;
 
-	if (!(ifsta->flags & IEEE80211_STA_ASSOCIATED))
-		return -1;
+	if (!(ifmgd->flags & IEEE80211_STA_ASSOCIATED))
+		return -ENOLINK;
 
-	ieee80211_set_disassoc(sdata, ifsta, false, true, reason);
+	ieee80211_set_disassoc(sdata, false, true, reason);
 	return 0;
 }
 
@@ -2788,14 +1959,6 @@ int ieee80211_sta_disassociate(struct ie
 void ieee80211_mlme_notify_scan_completed(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
-	struct ieee80211_if_sta *ifsta;
-
-	if (sdata && sdata->vif.type == NL80211_IFTYPE_ADHOC) {
-		ifsta = &sdata->u.sta;
-		if ((!(ifsta->flags & IEEE80211_STA_PREV_BSSID_SET)) ||
-		    !ieee80211_sta_active_ibss(sdata))
-			ieee80211_sta_find_ibss(sdata, ifsta);
-	}
 
 	/* Restart STA timers */
 	rcu_read_lock();
@@ -2842,3 +2005,36 @@ void ieee80211_dynamic_ps_timer(unsigned
 
 	queue_work(local->hw.workqueue, &local->dynamic_ps_enable_work);
 }
+
+void ieee80211_send_nullfunc(struct ieee80211_local *local,
+			     struct ieee80211_sub_if_data *sdata,
+			     int powersave)
+{
+	struct sk_buff *skb;
+	struct ieee80211_hdr *nullfunc;
+	__le16 fc;
+
+	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION))
+		return;
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + 24);
+	if (!skb) {
+		printk(KERN_DEBUG "%s: failed to allocate buffer for nullfunc "
+		       "frame\n", sdata->dev->name);
+		return;
+	}
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	nullfunc = (struct ieee80211_hdr *) skb_put(skb, 24);
+	memset(nullfunc, 0, 24);
+	fc = cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_NULLFUNC |
+			 IEEE80211_FCTL_TODS);
+	if (powersave)
+		fc |= cpu_to_le16(IEEE80211_FCTL_PM);
+	nullfunc->frame_control = fc;
+	memcpy(nullfunc->addr1, sdata->u.mgd.bssid, ETH_ALEN);
+	memcpy(nullfunc->addr2, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(nullfunc->addr3, sdata->u.mgd.bssid, ETH_ALEN);
+
+	ieee80211_tx_skb(sdata, skb, 0);
+}
--- wireless-testing.orig/net/mac80211/cfg.c	2009-02-15 12:22:49.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2009-02-15 12:22:54.000000000 +0100
@@ -1180,45 +1180,45 @@ static int set_mgmt_extra_ie_sta(struct 
 				 u8 subtype, u8 *ies, size_t ies_len)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	switch (subtype) {
 	case IEEE80211_STYPE_PROBE_REQ >> 4:
 		if (local->ops->hw_scan)
 			break;
-		kfree(ifsta->ie_probereq);
-		ifsta->ie_probereq = ies;
-		ifsta->ie_probereq_len = ies_len;
+		kfree(ifmgd->ie_probereq);
+		ifmgd->ie_probereq = ies;
+		ifmgd->ie_probereq_len = ies_len;
 		return 0;
 	case IEEE80211_STYPE_PROBE_RESP >> 4:
-		kfree(ifsta->ie_proberesp);
-		ifsta->ie_proberesp = ies;
-		ifsta->ie_proberesp_len = ies_len;
+		kfree(ifmgd->ie_proberesp);
+		ifmgd->ie_proberesp = ies;
+		ifmgd->ie_proberesp_len = ies_len;
 		return 0;
 	case IEEE80211_STYPE_AUTH >> 4:
-		kfree(ifsta->ie_auth);
-		ifsta->ie_auth = ies;
-		ifsta->ie_auth_len = ies_len;
+		kfree(ifmgd->ie_auth);
+		ifmgd->ie_auth = ies;
+		ifmgd->ie_auth_len = ies_len;
 		return 0;
 	case IEEE80211_STYPE_ASSOC_REQ >> 4:
-		kfree(ifsta->ie_assocreq);
-		ifsta->ie_assocreq = ies;
-		ifsta->ie_assocreq_len = ies_len;
+		kfree(ifmgd->ie_assocreq);
+		ifmgd->ie_assocreq = ies;
+		ifmgd->ie_assocreq_len = ies_len;
 		return 0;
 	case IEEE80211_STYPE_REASSOC_REQ >> 4:
-		kfree(ifsta->ie_reassocreq);
-		ifsta->ie_reassocreq = ies;
-		ifsta->ie_reassocreq_len = ies_len;
+		kfree(ifmgd->ie_reassocreq);
+		ifmgd->ie_reassocreq = ies;
+		ifmgd->ie_reassocreq_len = ies_len;
 		return 0;
 	case IEEE80211_STYPE_DEAUTH >> 4:
-		kfree(ifsta->ie_deauth);
-		ifsta->ie_deauth = ies;
-		ifsta->ie_deauth_len = ies_len;
+		kfree(ifmgd->ie_deauth);
+		ifmgd->ie_deauth = ies;
+		ifmgd->ie_deauth_len = ies_len;
 		return 0;
 	case IEEE80211_STYPE_DISASSOC >> 4:
-		kfree(ifsta->ie_disassoc);
-		ifsta->ie_disassoc = ies;
-		ifsta->ie_disassoc_len = ies_len;
+		kfree(ifmgd->ie_disassoc);
+		ifmgd->ie_disassoc = ies;
+		ifmgd->ie_disassoc_len = ies_len;
 		return 0;
 	}
 
@@ -1248,7 +1248,6 @@ static int ieee80211_set_mgmt_extra_ie(s
 
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_ADHOC:
 		ret = set_mgmt_extra_ie_sta(sdata, params->subtype,
 					    ies, ies_len);
 		break;
--- wireless-testing.orig/net/mac80211/debugfs_netdev.c	2009-02-15 12:22:49.000000000 +0100
+++ wireless-testing/net/mac80211/debugfs_netdev.c	2009-02-15 12:22:54.000000000 +0100
@@ -94,31 +94,31 @@ IEEE80211_IF_FILE(drop_unencrypted, drop
 IEEE80211_IF_FILE(force_unicast_rateidx, force_unicast_rateidx, DEC);
 IEEE80211_IF_FILE(max_ratectrl_rateidx, max_ratectrl_rateidx, DEC);
 
-/* STA/IBSS attributes */
-IEEE80211_IF_FILE(state, u.sta.state, DEC);
-IEEE80211_IF_FILE(bssid, u.sta.bssid, MAC);
-IEEE80211_IF_FILE(prev_bssid, u.sta.prev_bssid, MAC);
-IEEE80211_IF_FILE(ssid_len, u.sta.ssid_len, SIZE);
-IEEE80211_IF_FILE(aid, u.sta.aid, DEC);
-IEEE80211_IF_FILE(ap_capab, u.sta.ap_capab, HEX);
-IEEE80211_IF_FILE(capab, u.sta.capab, HEX);
-IEEE80211_IF_FILE(extra_ie_len, u.sta.extra_ie_len, SIZE);
-IEEE80211_IF_FILE(auth_tries, u.sta.auth_tries, DEC);
-IEEE80211_IF_FILE(assoc_tries, u.sta.assoc_tries, DEC);
-IEEE80211_IF_FILE(auth_algs, u.sta.auth_algs, HEX);
-IEEE80211_IF_FILE(auth_alg, u.sta.auth_alg, DEC);
-IEEE80211_IF_FILE(auth_transaction, u.sta.auth_transaction, DEC);
+/* STA attributes */
+IEEE80211_IF_FILE(state, u.mgd.state, DEC);
+IEEE80211_IF_FILE(bssid, u.mgd.bssid, MAC);
+IEEE80211_IF_FILE(prev_bssid, u.mgd.prev_bssid, MAC);
+IEEE80211_IF_FILE(ssid_len, u.mgd.ssid_len, SIZE);
+IEEE80211_IF_FILE(aid, u.mgd.aid, DEC);
+IEEE80211_IF_FILE(ap_capab, u.mgd.ap_capab, HEX);
+IEEE80211_IF_FILE(capab, u.mgd.capab, HEX);
+IEEE80211_IF_FILE(extra_ie_len, u.mgd.extra_ie_len, SIZE);
+IEEE80211_IF_FILE(auth_tries, u.mgd.auth_tries, DEC);
+IEEE80211_IF_FILE(assoc_tries, u.mgd.assoc_tries, DEC);
+IEEE80211_IF_FILE(auth_algs, u.mgd.auth_algs, HEX);
+IEEE80211_IF_FILE(auth_alg, u.mgd.auth_alg, DEC);
+IEEE80211_IF_FILE(auth_transaction, u.mgd.auth_transaction, DEC);
 
 static ssize_t ieee80211_if_fmt_flags(
 	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
 {
 	return scnprintf(buf, buflen, "%s%s%s%s%s%s%s\n",
-		 sdata->u.sta.flags & IEEE80211_STA_SSID_SET ? "SSID\n" : "",
-		 sdata->u.sta.flags & IEEE80211_STA_BSSID_SET ? "BSSID\n" : "",
-		 sdata->u.sta.flags & IEEE80211_STA_PREV_BSSID_SET ? "prev BSSID\n" : "",
-		 sdata->u.sta.flags & IEEE80211_STA_AUTHENTICATED ? "AUTH\n" : "",
-		 sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED ? "ASSOC\n" : "",
-		 sdata->u.sta.flags & IEEE80211_STA_PROBEREQ_POLL ? "PROBEREQ POLL\n" : "",
+		 sdata->u.mgd.flags & IEEE80211_STA_SSID_SET ? "SSID\n" : "",
+		 sdata->u.mgd.flags & IEEE80211_STA_BSSID_SET ? "BSSID\n" : "",
+		 sdata->u.mgd.flags & IEEE80211_STA_PREV_BSSID_SET ? "prev BSSID\n" : "",
+		 sdata->u.mgd.flags & IEEE80211_STA_AUTHENTICATED ? "AUTH\n" : "",
+		 sdata->u.mgd.flags & IEEE80211_STA_ASSOCIATED ? "ASSOC\n" : "",
+		 sdata->u.mgd.flags & IEEE80211_STA_PROBEREQ_POLL ? "PROBEREQ POLL\n" : "",
 		 sdata->vif.bss_conf.use_cts_prot ? "CTS prot\n" : "");
 }
 __IEEE80211_IF_FILE(flags);
@@ -283,9 +283,11 @@ static void add_files(struct ieee80211_s
 #endif
 		break;
 	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_ADHOC:
 		add_sta_files(sdata);
 		break;
+	case NL80211_IFTYPE_ADHOC:
+		/* XXX */
+		break;
 	case NL80211_IFTYPE_AP:
 		add_ap_files(sdata);
 		break;
@@ -418,9 +420,11 @@ static void del_files(struct ieee80211_s
 #endif
 		break;
 	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_ADHOC:
 		del_sta_files(sdata);
 		break;
+	case NL80211_IFTYPE_ADHOC:
+		/* XXX */
+		break;
 	case NL80211_IFTYPE_AP:
 		del_ap_files(sdata);
 		break;
--- wireless-testing.orig/net/mac80211/key.c	2009-02-15 12:22:49.000000000 +0100
+++ wireless-testing/net/mac80211/key.c	2009-02-15 12:22:54.000000000 +0100
@@ -400,7 +400,7 @@ void ieee80211_key_link(struct ieee80211
 			 */
 
 			/* same here, the AP could be using QoS */
-			ap = sta_info_get(key->local, key->sdata->u.sta.bssid);
+			ap = sta_info_get(key->local, key->sdata->u.mgd.bssid);
 			if (ap) {
 				if (test_sta_flags(ap, WLAN_STA_WME))
 					key->conf.flags |=
--- wireless-testing.orig/net/mac80211/rx.c	2009-02-15 12:22:49.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-02-15 12:22:54.000000000 +0100
@@ -838,7 +838,7 @@ ieee80211_rx_h_sta_process(struct ieee80
 	if (rx->sdata->vif.type == NL80211_IFTYPE_ADHOC) {
 		u8 *bssid = ieee80211_get_bssid(hdr, rx->skb->len,
 						NL80211_IFTYPE_ADHOC);
-		if (compare_ether_addr(bssid, rx->sdata->u.sta.bssid) == 0)
+		if (compare_ether_addr(bssid, rx->sdata->u.ibss.bssid) == 0)
 			sta->last_rx = jiffies;
 	} else
 	if (!is_multicast_ether_addr(hdr->addr1) ||
@@ -1702,13 +1702,13 @@ static void ieee80211_process_sa_query_r
 		return;
 	}
 
-	if (compare_ether_addr(mgmt->sa, sdata->u.sta.bssid) != 0 ||
-	    compare_ether_addr(mgmt->bssid, sdata->u.sta.bssid) != 0) {
+	if (compare_ether_addr(mgmt->sa, sdata->u.mgd.bssid) != 0 ||
+	    compare_ether_addr(mgmt->bssid, sdata->u.mgd.bssid) != 0) {
 		/* Not from the current AP. */
 		return;
 	}
 
-	if (sdata->u.sta.state == IEEE80211_STA_MLME_ASSOCIATE) {
+	if (sdata->u.mgd.state == IEEE80211_STA_MLME_ASSOCIATE) {
 		/* Association in progress; ignore SA Query */
 		return;
 	}
@@ -1727,7 +1727,7 @@ static void ieee80211_process_sa_query_r
 	memset(resp, 0, 24);
 	memcpy(resp->da, mgmt->sa, ETH_ALEN);
 	memcpy(resp->sa, sdata->dev->dev_addr, ETH_ALEN);
-	memcpy(resp->bssid, sdata->u.sta.bssid, ETH_ALEN);
+	memcpy(resp->bssid, sdata->u.mgd.bssid, ETH_ALEN);
 	resp->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
 	skb_put(skb, 1 + sizeof(resp->u.action.u.sa_query));
@@ -1745,7 +1745,6 @@ ieee80211_rx_h_action(struct ieee80211_r
 {
 	struct ieee80211_local *local = rx->local;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *) rx->skb->data;
 	struct ieee80211_bss *bss;
 	int len = rx->skb->len;
@@ -1803,6 +1802,10 @@ ieee80211_rx_h_action(struct ieee80211_r
 	case WLAN_CATEGORY_SPECTRUM_MGMT:
 		if (local->hw.conf.channel->band != IEEE80211_BAND_5GHZ)
 			return RX_DROP_MONITOR;
+
+		if (sdata->vif.type != NL80211_IFTYPE_STATION)
+			return RX_DROP_MONITOR;
+
 		switch (mgmt->u.action.u.measurement.action_code) {
 		case WLAN_ACTION_SPCT_MSR_REQ:
 			if (len < (IEEE80211_MIN_ACTION_SIZE +
@@ -1815,12 +1818,13 @@ ieee80211_rx_h_action(struct ieee80211_r
 				   sizeof(mgmt->u.action.u.chan_switch)))
 				return RX_DROP_MONITOR;
 
-			if (memcmp(mgmt->bssid, ifsta->bssid, ETH_ALEN) != 0)
+			if (memcmp(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN))
 				return RX_DROP_MONITOR;
 
-			bss = ieee80211_rx_bss_get(local, ifsta->bssid,
+			bss = ieee80211_rx_bss_get(local, sdata->u.mgd.bssid,
 					   local->hw.conf.channel->center_freq,
-					   ifsta->ssid, ifsta->ssid_len);
+					   sdata->u.mgd.ssid,
+					   sdata->u.mgd.ssid_len);
 			if (!bss)
 				return RX_DROP_MONITOR;
 
@@ -1876,11 +1880,14 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_
 	    sdata->vif.type != NL80211_IFTYPE_ADHOC)
 		return RX_DROP_MONITOR;
 
-	if (sdata->flags & IEEE80211_SDATA_USERSPACE_MLME)
-		return RX_DROP_MONITOR;
 
-	ieee80211_sta_rx_mgmt(sdata, rx->skb, rx->status);
-	return RX_QUEUED;
+	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+		if (sdata->flags & IEEE80211_SDATA_USERSPACE_MLME)
+			return RX_DROP_MONITOR;
+		return ieee80211_sta_rx_mgmt(sdata, rx->skb, rx->status);
+	}
+
+	return ieee80211_ibss_rx_mgmt(sdata, rx->skb, rx->status);
 }
 
 static void ieee80211_rx_michael_mic_report(struct net_device *dev,
@@ -2083,7 +2090,7 @@ static int prepare_for_handlers(struct i
 	case NL80211_IFTYPE_STATION:
 		if (!bssid)
 			return 0;
-		if (!ieee80211_bssid_match(bssid, sdata->u.sta.bssid)) {
+		if (!ieee80211_bssid_match(bssid, sdata->u.mgd.bssid)) {
 			if (!(rx->flags & IEEE80211_RX_IN_SCAN))
 				return 0;
 			rx->flags &= ~IEEE80211_RX_RA_MATCH;
@@ -2101,7 +2108,7 @@ static int prepare_for_handlers(struct i
 		if (ieee80211_is_beacon(hdr->frame_control)) {
 			return 1;
 		}
-		else if (!ieee80211_bssid_match(bssid, sdata->u.sta.bssid)) {
+		else if (!ieee80211_bssid_match(bssid, sdata->u.ibss.bssid)) {
 			if (!(rx->flags & IEEE80211_RX_IN_SCAN))
 				return 0;
 			rx->flags &= ~IEEE80211_RX_RA_MATCH;
--- wireless-testing.orig/net/mac80211/spectmgmt.c	2009-02-15 12:22:49.000000000 +0100
+++ wireless-testing/net/mac80211/spectmgmt.c	2009-02-15 12:22:54.000000000 +0100
@@ -88,16 +88,16 @@ void ieee80211_process_measurement_req(s
 void ieee80211_chswitch_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
-		container_of(work, struct ieee80211_sub_if_data, u.sta.chswitch_work);
+		container_of(work, struct ieee80211_sub_if_data, u.mgd.chswitch_work);
 	struct ieee80211_bss *bss;
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	if (!netif_running(sdata->dev))
 		return;
 
-	bss = ieee80211_rx_bss_get(sdata->local, ifsta->bssid,
+	bss = ieee80211_rx_bss_get(sdata->local, ifmgd->bssid,
 				   sdata->local->hw.conf.channel->center_freq,
-				   ifsta->ssid, ifsta->ssid_len);
+				   ifmgd->ssid, ifmgd->ssid_len);
 	if (!bss)
 		goto exit;
 
@@ -108,7 +108,7 @@ void ieee80211_chswitch_work(struct work
 
 	ieee80211_rx_bss_put(sdata->local, bss);
 exit:
-	ifsta->flags &= ~IEEE80211_STA_CSA_RECEIVED;
+	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
 	ieee80211_wake_queues_by_reason(&sdata->local->hw,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
 }
@@ -117,9 +117,9 @@ void ieee80211_chswitch_timer(unsigned l
 {
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
-	queue_work(sdata->local->hw.workqueue, &ifsta->chswitch_work);
+	queue_work(sdata->local->hw.workqueue, &ifmgd->chswitch_work);
 }
 
 void ieee80211_process_chanswitch(struct ieee80211_sub_if_data *sdata,
@@ -127,14 +127,14 @@ void ieee80211_process_chanswitch(struct
 				  struct ieee80211_bss *bss)
 {
 	struct ieee80211_channel *new_ch;
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	int new_freq = ieee80211_channel_to_frequency(sw_elem->new_ch_num);
 
 	/* FIXME: Handle ADHOC later */
 	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return;
 
-	if (ifsta->state != IEEE80211_STA_MLME_ASSOCIATED)
+	if (ifmgd->state != IEEE80211_STA_MLME_ASSOCIATED)
 		return;
 
 	if (sdata->local->sw_scanning || sdata->local->hw_scanning)
@@ -143,7 +143,7 @@ void ieee80211_process_chanswitch(struct
 	/* Disregard subsequent beacons if we are already running a timer
 	   processing a CSA */
 
-	if (ifsta->flags & IEEE80211_STA_CSA_RECEIVED)
+	if (ifmgd->flags & IEEE80211_STA_CSA_RECEIVED)
 		return;
 
 	new_ch = ieee80211_get_channel(sdata->local->hw.wiphy, new_freq);
@@ -153,12 +153,12 @@ void ieee80211_process_chanswitch(struct
 	sdata->local->csa_channel = new_ch;
 
 	if (sw_elem->count <= 1) {
-		queue_work(sdata->local->hw.workqueue, &ifsta->chswitch_work);
+		queue_work(sdata->local->hw.workqueue, &ifmgd->chswitch_work);
 	} else {
 		ieee80211_stop_queues_by_reason(&sdata->local->hw,
 						IEEE80211_QUEUE_STOP_REASON_CSA);
-		ifsta->flags |= IEEE80211_STA_CSA_RECEIVED;
-		mod_timer(&ifsta->chswitch_timer,
+		ifmgd->flags |= IEEE80211_STA_CSA_RECEIVED;
+		mod_timer(&ifmgd->chswitch_timer,
 			  jiffies +
 			  msecs_to_jiffies(sw_elem->count *
 					   bss->cbss.beacon_interval));
--- wireless-testing.orig/net/mac80211/util.c	2009-02-15 12:22:49.000000000 +0100
+++ wireless-testing/net/mac80211/util.c	2009-02-15 12:22:54.000000000 +0100
@@ -750,6 +750,27 @@ void ieee80211_set_wmm_default(struct ie
 		local->ops->conf_tx(local_to_hw(local), i, &qparam);
 }
 
+void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
+				  const size_t supp_rates_len,
+				  const u8 *supp_rates)
+{
+	struct ieee80211_local *local = sdata->local;
+	int i, have_higher_than_11mbit = 0;
+
+	/* cf. IEEE 802.11 9.2.12 */
+	for (i = 0; i < supp_rates_len; i++)
+		if ((supp_rates[i] & 0x7f) * 5 > 110)
+			have_higher_than_11mbit = 1;
+
+	if (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ &&
+	    have_higher_than_11mbit)
+		sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
+	else
+		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
+
+	ieee80211_set_wmm_default(sdata);
+}
+
 void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 		      int encrypt)
 {
@@ -816,3 +837,158 @@ u32 ieee80211_mandatory_rates(struct iee
 			mandatory_rates |= BIT(i);
 	return mandatory_rates;
 }
+
+void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
+			 u16 transaction, u16 auth_alg,
+			 u8 *extra, size_t extra_len,
+			 const u8 *bssid, int encrypt)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *mgmt;
+	const u8 *ie_auth = NULL;
+	int ie_auth_len = 0;
+
+	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+		ie_auth_len = sdata->u.mgd.ie_auth_len;
+		ie_auth = sdata->u.mgd.ie_auth;
+	}
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
+			    sizeof(*mgmt) + 6 + extra_len + ie_auth_len);
+	if (!skb) {
+		printk(KERN_DEBUG "%s: failed to allocate buffer for auth "
+		       "frame\n", sdata->dev->name);
+		return;
+	}
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24 + 6);
+	memset(mgmt, 0, 24 + 6);
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_AUTH);
+	if (encrypt)
+		mgmt->frame_control |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
+	memcpy(mgmt->da, bssid, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->bssid, bssid, ETH_ALEN);
+	mgmt->u.auth.auth_alg = cpu_to_le16(auth_alg);
+	mgmt->u.auth.auth_transaction = cpu_to_le16(transaction);
+	mgmt->u.auth.status_code = cpu_to_le16(0);
+	if (extra)
+		memcpy(skb_put(skb, extra_len), extra, extra_len);
+	if (ie_auth)
+		memcpy(skb_put(skb, ie_auth_len), ie_auth, ie_auth_len);
+
+	ieee80211_tx_skb(sdata, skb, encrypt);
+}
+
+void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
+			      u8 *ssid, size_t ssid_len)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_supported_band *sband;
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *mgmt;
+	u8 *pos, *supp_rates, *esupp_rates = NULL, *extra_preq_ie = NULL;
+	int i, extra_preq_ie_len = 0;
+
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_STATION:
+		extra_preq_ie_len = sdata->u.mgd.ie_probereq_len;
+		extra_preq_ie = sdata->u.mgd.ie_probereq;
+		break;
+	default:
+		break;
+	}
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*mgmt) + 200 +
+			    extra_preq_ie_len);
+	if (!skb) {
+		printk(KERN_DEBUG "%s: failed to allocate buffer for probe "
+		       "request\n", sdata->dev->name);
+		return;
+	}
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
+	memset(mgmt, 0, 24);
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_PROBE_REQ);
+	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
+	if (dst) {
+		memcpy(mgmt->da, dst, ETH_ALEN);
+		memcpy(mgmt->bssid, dst, ETH_ALEN);
+	} else {
+		memset(mgmt->da, 0xff, ETH_ALEN);
+		memset(mgmt->bssid, 0xff, ETH_ALEN);
+	}
+	pos = skb_put(skb, 2 + ssid_len);
+	*pos++ = WLAN_EID_SSID;
+	*pos++ = ssid_len;
+	memcpy(pos, ssid, ssid_len);
+
+	supp_rates = skb_put(skb, 2);
+	supp_rates[0] = WLAN_EID_SUPP_RATES;
+	supp_rates[1] = 0;
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
+	for (i = 0; i < sband->n_bitrates; i++) {
+		struct ieee80211_rate *rate = &sband->bitrates[i];
+		if (esupp_rates) {
+			pos = skb_put(skb, 1);
+			esupp_rates[1]++;
+		} else if (supp_rates[1] == 8) {
+			esupp_rates = skb_put(skb, 3);
+			esupp_rates[0] = WLAN_EID_EXT_SUPP_RATES;
+			esupp_rates[1] = 1;
+			pos = &esupp_rates[2];
+		} else {
+			pos = skb_put(skb, 1);
+			supp_rates[1]++;
+		}
+		*pos = rate->bitrate / 5;
+	}
+
+	if (extra_preq_ie)
+		memcpy(skb_put(skb, extra_preq_ie_len), extra_preq_ie,
+		       extra_preq_ie_len);
+
+	ieee80211_tx_skb(sdata, skb, 0);
+}
+
+u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
+			    struct ieee802_11_elems *elems,
+			    enum ieee80211_band band)
+{
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_rate *bitrates;
+	size_t num_rates;
+	u32 supp_rates;
+	int i, j;
+	sband = local->hw.wiphy->bands[band];
+
+	if (!sband) {
+		WARN_ON(1);
+		sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	}
+
+	bitrates = sband->bitrates;
+	num_rates = sband->n_bitrates;
+	supp_rates = 0;
+	for (i = 0; i < elems->supp_rates_len +
+		     elems->ext_supp_rates_len; i++) {
+		u8 rate = 0;
+		int own_rate;
+		if (i < elems->supp_rates_len)
+			rate = elems->supp_rates[i];
+		else if (elems->ext_supp_rates)
+			rate = elems->ext_supp_rates
+				[i - elems->supp_rates_len];
+		own_rate = 5 * (rate & 0x7f);
+		for (j = 0; j < num_rates; j++)
+			if (bitrates[j].bitrate == own_rate)
+				supp_rates |= BIT(j);
+	}
+	return supp_rates;
+}


