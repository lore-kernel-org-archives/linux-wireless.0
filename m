Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36299 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbYIFVdI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 17:33:08 -0400
Subject: [PATCH] mac80211: start moving scan code from mlme
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 06 Sep 2008 23:32:58 +0200
Message-Id: <1220736778.21016.1.camel@johannes.berg> (sfid-20080906_233314_612397_61E90402)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a first patch to move some code from mlme.c to a
new file called scan.c. The end result will hopefully be
a more manageable mlme.c.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/Makefile      |    1 
 net/mac80211/ieee80211_i.h |   13 -
 net/mac80211/mlme.c        |  554 +--------------------------------------------
 net/mac80211/scan.c        |  547 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 576 insertions(+), 539 deletions(-)

--- everything.orig/net/mac80211/Makefile	2008-09-06 22:23:05.000000000 +0200
+++ everything/net/mac80211/Makefile	2008-09-06 22:23:11.000000000 +0200
@@ -7,6 +7,7 @@ mac80211-y := \
 	sta_info.o \
 	wep.o \
 	wpa.o \
+	scan.o \
 	mlme.o \
 	iface.o \
 	rate.o \
--- everything.orig/net/mac80211/ieee80211_i.h	2008-09-06 22:25:52.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-09-06 22:39:46.000000000 +0200
@@ -53,6 +53,12 @@ struct ieee80211_local;
  * increased memory use (about 2 kB of RAM per entry). */
 #define IEEE80211_FRAGMENT_MAX 4
 
+/*
+ * Time after which we ignore scan results and no longer report/use
+ * them in any way.
+ */
+#define IEEE80211_SCAN_RESULT_EXPIRE (10 * HZ)
+
 struct ieee80211_fragment_entry {
 	unsigned long first_frag_time;
 	unsigned int seq;
@@ -924,8 +930,13 @@ u64 ieee80211_sta_get_rates(struct ieee8
 			    enum ieee80211_band band);
 void ieee80211_sta_tx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 		int encrypt);
+void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
+			      u8 *ssid, size_t ssid_len);
 void ieee802_11_parse_elems(u8 *start, size_t len,
-				   struct ieee802_11_elems *elems);
+			    struct ieee802_11_elems *elems);
+void ieee80211_mlme_notify_scan_completed(struct ieee80211_local *local);
+int ieee80211_sta_start_scan(struct ieee80211_sub_if_data *scan_sdata,
+			     u8 *ssid, size_t ssid_len);
 
 #ifdef CONFIG_MAC80211_MESH
 void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata);
--- everything.orig/net/mac80211/mlme.c	2008-09-06 22:21:15.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-06 22:32:02.000000000 +0200
@@ -46,10 +46,6 @@
 #define IEEE80211_SCAN_INTERVAL_SLOW (15 * HZ)
 #define IEEE80211_IBSS_JOIN_TIMEOUT (7 * HZ)
 
-#define IEEE80211_PROBE_DELAY (HZ / 33)
-#define IEEE80211_CHANNEL_TIME (HZ / 33)
-#define IEEE80211_PASSIVE_CHANNEL_TIME (HZ / 5)
-#define IEEE80211_SCAN_RESULT_EXPIRE (10 * HZ)
 #define IEEE80211_IBSS_MERGE_INTERVAL (30 * HZ)
 #define IEEE80211_IBSS_INACTIVITY_LIMIT (60 * HZ)
 #define IEEE80211_MESH_PEER_INACTIVITY_LIMIT (1800 * HZ)
@@ -341,8 +337,8 @@ static void ieee80211_send_auth(struct i
 	ieee80211_sta_tx(sdata, skb, encrypt);
 }
 
-static void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
-				     u8 *ssid, size_t ssid_len)
+void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
+			      u8 *ssid, size_t ssid_len)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
@@ -3424,538 +3420,6 @@ int ieee80211_sta_set_bssid(struct ieee8
 }
 
 
-static void ieee80211_send_nullfunc(struct ieee80211_local *local,
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
-	ieee80211_sta_tx(sdata, skb, 0);
-}
-
-
-static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
-{
-	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
-	    ieee80211_vif_is_mesh(&sdata->vif))
-		ieee80211_sta_timer((unsigned long)sdata);
-}
-
-void ieee80211_scan_completed(struct ieee80211_hw *hw)
-{
-	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_sub_if_data *sdata;
-	union iwreq_data wrqu;
-
-	local->last_scan_completed = jiffies;
-	memset(&wrqu, 0, sizeof(wrqu));
-	wireless_send_event(local->scan_sdata->dev, SIOCGIWSCAN, &wrqu, NULL);
-
-	if (local->sta_hw_scanning) {
-		local->sta_hw_scanning = 0;
-		if (ieee80211_hw_config(local))
-			printk(KERN_DEBUG "%s: failed to restore operational "
-			       "channel after scan\n", wiphy_name(local->hw.wiphy));
-		/* Restart STA timer for HW scan case */
-		rcu_read_lock();
-		list_for_each_entry_rcu(sdata, &local->interfaces, list)
-			ieee80211_restart_sta_timer(sdata);
-		rcu_read_unlock();
-
-		goto done;
-	}
-
-	local->sta_sw_scanning = 0;
-	if (ieee80211_hw_config(local))
-		printk(KERN_DEBUG "%s: failed to restore operational "
-		       "channel after scan\n", wiphy_name(local->hw.wiphy));
-
-
-	netif_tx_lock_bh(local->mdev);
-	netif_addr_lock(local->mdev);
-	local->filter_flags &= ~FIF_BCN_PRBRESP_PROMISC;
-	local->ops->configure_filter(local_to_hw(local),
-				     FIF_BCN_PRBRESP_PROMISC,
-				     &local->filter_flags,
-				     local->mdev->mc_count,
-				     local->mdev->mc_list);
-
-	netif_addr_unlock(local->mdev);
-	netif_tx_unlock_bh(local->mdev);
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		/* Tell AP we're back */
-		if (sdata->vif.type == IEEE80211_IF_TYPE_STA &&
-		    sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED)
-			ieee80211_send_nullfunc(local, sdata, 0);
-
-		ieee80211_restart_sta_timer(sdata);
-
-		netif_wake_queue(sdata->dev);
-	}
-	rcu_read_unlock();
-
- done:
-	sdata = local->scan_sdata;
-	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
-		struct ieee80211_if_sta *ifsta = &sdata->u.sta;
-		if (!(ifsta->flags & IEEE80211_STA_BSSID_SET) ||
-		    (!(ifsta->state == IEEE80211_STA_MLME_IBSS_JOINED) &&
-		    !ieee80211_sta_active_ibss(sdata)))
-			ieee80211_sta_find_ibss(sdata, ifsta);
-	}
-}
-EXPORT_SYMBOL(ieee80211_scan_completed);
-
-void ieee80211_sta_scan_work(struct work_struct *work)
-{
-	struct ieee80211_local *local =
-		container_of(work, struct ieee80211_local, scan_work.work);
-	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_channel *chan;
-	int skip;
-	unsigned long next_delay = 0;
-
-	if (!local->sta_sw_scanning)
-		return;
-
-	switch (local->scan_state) {
-	case SCAN_SET_CHANNEL:
-		/*
-		 * Get current scan band. scan_band may be IEEE80211_NUM_BANDS
-		 * after we successfully scanned the last channel of the last
-		 * band (and the last band is supported by the hw)
-		 */
-		if (local->scan_band < IEEE80211_NUM_BANDS)
-			sband = local->hw.wiphy->bands[local->scan_band];
-		else
-			sband = NULL;
-
-		/*
-		 * If we are at an unsupported band and have more bands
-		 * left to scan, advance to the next supported one.
-		 */
-		while (!sband && local->scan_band < IEEE80211_NUM_BANDS - 1) {
-			local->scan_band++;
-			sband = local->hw.wiphy->bands[local->scan_band];
-			local->scan_channel_idx = 0;
-		}
-
-		/* if no more bands/channels left, complete scan */
-		if (!sband || local->scan_channel_idx >= sband->n_channels) {
-			ieee80211_scan_completed(local_to_hw(local));
-			return;
-		}
-		skip = 0;
-		chan = &sband->channels[local->scan_channel_idx];
-
-		if (chan->flags & IEEE80211_CHAN_DISABLED ||
-		    (sdata->vif.type == IEEE80211_IF_TYPE_IBSS &&
-		     chan->flags & IEEE80211_CHAN_NO_IBSS))
-			skip = 1;
-
-		if (!skip) {
-			local->scan_channel = chan;
-			if (ieee80211_hw_config(local)) {
-				printk(KERN_DEBUG "%s: failed to set freq to "
-				       "%d MHz for scan\n", wiphy_name(local->hw.wiphy),
-				       chan->center_freq);
-				skip = 1;
-			}
-		}
-
-		/* advance state machine to next channel/band */
-		local->scan_channel_idx++;
-		if (local->scan_channel_idx >= sband->n_channels) {
-			/*
-			 * scan_band may end up == IEEE80211_NUM_BANDS, but
-			 * we'll catch that case above and complete the scan
-			 * if that is the case.
-			 */
-			local->scan_band++;
-			local->scan_channel_idx = 0;
-		}
-
-		if (skip)
-			break;
-
-		next_delay = IEEE80211_PROBE_DELAY +
-			     usecs_to_jiffies(local->hw.channel_change_time);
-		local->scan_state = SCAN_SEND_PROBE;
-		break;
-	case SCAN_SEND_PROBE:
-		next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
-		local->scan_state = SCAN_SET_CHANNEL;
-
-		if (local->scan_channel->flags & IEEE80211_CHAN_PASSIVE_SCAN)
-			break;
-		ieee80211_send_probe_req(sdata, NULL, local->scan_ssid,
-					 local->scan_ssid_len);
-		next_delay = IEEE80211_CHANNEL_TIME;
-		break;
-	}
-
-	if (local->sta_sw_scanning)
-		queue_delayed_work(local->hw.workqueue, &local->scan_work,
-				   next_delay);
-}
-
-
-static int ieee80211_sta_start_scan(struct ieee80211_sub_if_data *scan_sdata,
-				    u8 *ssid, size_t ssid_len)
-{
-	struct ieee80211_local *local = scan_sdata->local;
-	struct ieee80211_sub_if_data *sdata;
-
-	if (ssid_len > IEEE80211_MAX_SSID_LEN)
-		return -EINVAL;
-
-	/* MLME-SCAN.request (page 118)  page 144 (11.1.3.1)
-	 * BSSType: INFRASTRUCTURE, INDEPENDENT, ANY_BSS
-	 * BSSID: MACAddress
-	 * SSID
-	 * ScanType: ACTIVE, PASSIVE
-	 * ProbeDelay: delay (in microseconds) to be used prior to transmitting
-	 *    a Probe frame during active scanning
-	 * ChannelList
-	 * MinChannelTime (>= ProbeDelay), in TU
-	 * MaxChannelTime: (>= MinChannelTime), in TU
-	 */
-
-	 /* MLME-SCAN.confirm
-	  * BSSDescriptionSet
-	  * ResultCode: SUCCESS, INVALID_PARAMETERS
-	 */
-
-	if (local->sta_sw_scanning || local->sta_hw_scanning) {
-		if (local->scan_sdata == scan_sdata)
-			return 0;
-		return -EBUSY;
-	}
-
-	if (local->ops->hw_scan) {
-		int rc = local->ops->hw_scan(local_to_hw(local),
-					     ssid, ssid_len);
-		if (!rc) {
-			local->sta_hw_scanning = 1;
-			local->scan_sdata = scan_sdata;
-		}
-		return rc;
-	}
-
-	local->sta_sw_scanning = 1;
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		netif_stop_queue(sdata->dev);
-		if (sdata->vif.type == IEEE80211_IF_TYPE_STA &&
-		    (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED))
-			ieee80211_send_nullfunc(local, sdata, 1);
-	}
-	rcu_read_unlock();
-
-	if (ssid) {
-		local->scan_ssid_len = ssid_len;
-		memcpy(local->scan_ssid, ssid, ssid_len);
-	} else
-		local->scan_ssid_len = 0;
-	local->scan_state = SCAN_SET_CHANNEL;
-	local->scan_channel_idx = 0;
-	local->scan_band = IEEE80211_BAND_2GHZ;
-	local->scan_sdata = scan_sdata;
-
-	netif_addr_lock_bh(local->mdev);
-	local->filter_flags |= FIF_BCN_PRBRESP_PROMISC;
-	local->ops->configure_filter(local_to_hw(local),
-				     FIF_BCN_PRBRESP_PROMISC,
-				     &local->filter_flags,
-				     local->mdev->mc_count,
-				     local->mdev->mc_list);
-	netif_addr_unlock_bh(local->mdev);
-
-	/* TODO: start scan as soon as all nullfunc frames are ACKed */
-	queue_delayed_work(local->hw.workqueue, &local->scan_work,
-			   IEEE80211_CHANNEL_TIME);
-
-	return 0;
-}
-
-
-int ieee80211_sta_req_scan(struct ieee80211_sub_if_data *sdata, u8 *ssid, size_t ssid_len)
-{
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
-	struct ieee80211_local *local = sdata->local;
-
-	if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
-		return ieee80211_sta_start_scan(sdata, ssid, ssid_len);
-
-	if (local->sta_sw_scanning || local->sta_hw_scanning) {
-		if (local->scan_sdata == sdata)
-			return 0;
-		return -EBUSY;
-	}
-
-	ifsta->scan_ssid_len = ssid_len;
-	if (ssid_len)
-		memcpy(ifsta->scan_ssid, ssid, ssid_len);
-	set_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request);
-	queue_work(local->hw.workqueue, &ifsta->work);
-	return 0;
-}
-
-
-static void ieee80211_sta_add_scan_ies(struct iw_request_info *info,
-				       struct ieee80211_sta_bss *bss,
-				       char **current_ev, char *end_buf)
-{
-	u8 *pos, *end, *next;
-	struct iw_event iwe;
-
-	if (bss == NULL || bss->ies == NULL)
-		return;
-
-	/*
-	 * If needed, fragment the IEs buffer (at IE boundaries) into short
-	 * enough fragments to fit into IW_GENERIC_IE_MAX octet messages.
-	 */
-	pos = bss->ies;
-	end = pos + bss->ies_len;
-
-	while (end - pos > IW_GENERIC_IE_MAX) {
-		next = pos + 2 + pos[1];
-		while (next + 2 + next[1] - pos < IW_GENERIC_IE_MAX)
-			next = next + 2 + next[1];
-
-		memset(&iwe, 0, sizeof(iwe));
-		iwe.cmd = IWEVGENIE;
-		iwe.u.data.length = next - pos;
-		*current_ev = iwe_stream_add_point(info, *current_ev,
-						   end_buf, &iwe, pos);
-
-		pos = next;
-	}
-
-	if (end > pos) {
-		memset(&iwe, 0, sizeof(iwe));
-		iwe.cmd = IWEVGENIE;
-		iwe.u.data.length = end - pos;
-		*current_ev = iwe_stream_add_point(info, *current_ev,
-						   end_buf, &iwe, pos);
-	}
-}
-
-
-static char *
-ieee80211_sta_scan_result(struct ieee80211_local *local,
-			  struct iw_request_info *info,
-			  struct ieee80211_sta_bss *bss,
-			  char *current_ev, char *end_buf)
-{
-	struct iw_event iwe;
-	char *buf;
-
-	if (time_after(jiffies,
-		       bss->last_update + IEEE80211_SCAN_RESULT_EXPIRE))
-		return current_ev;
-
-	memset(&iwe, 0, sizeof(iwe));
-	iwe.cmd = SIOCGIWAP;
-	iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
-	memcpy(iwe.u.ap_addr.sa_data, bss->bssid, ETH_ALEN);
-	current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe,
-					  IW_EV_ADDR_LEN);
-
-	memset(&iwe, 0, sizeof(iwe));
-	iwe.cmd = SIOCGIWESSID;
-	if (bss_mesh_cfg(bss)) {
-		iwe.u.data.length = bss_mesh_id_len(bss);
-		iwe.u.data.flags = 1;
-		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-						  &iwe, bss_mesh_id(bss));
-	} else {
-		iwe.u.data.length = bss->ssid_len;
-		iwe.u.data.flags = 1;
-		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-						  &iwe, bss->ssid);
-	}
-
-	if (bss->capability & (WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_IBSS)
-	    || bss_mesh_cfg(bss)) {
-		memset(&iwe, 0, sizeof(iwe));
-		iwe.cmd = SIOCGIWMODE;
-		if (bss_mesh_cfg(bss))
-			iwe.u.mode = IW_MODE_MESH;
-		else if (bss->capability & WLAN_CAPABILITY_ESS)
-			iwe.u.mode = IW_MODE_MASTER;
-		else
-			iwe.u.mode = IW_MODE_ADHOC;
-		current_ev = iwe_stream_add_event(info, current_ev, end_buf,
-						  &iwe, IW_EV_UINT_LEN);
-	}
-
-	memset(&iwe, 0, sizeof(iwe));
-	iwe.cmd = SIOCGIWFREQ;
-	iwe.u.freq.m = ieee80211_frequency_to_channel(bss->freq);
-	iwe.u.freq.e = 0;
-	current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe,
-					  IW_EV_FREQ_LEN);
-
-	memset(&iwe, 0, sizeof(iwe));
-	iwe.cmd = SIOCGIWFREQ;
-	iwe.u.freq.m = bss->freq;
-	iwe.u.freq.e = 6;
-	current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe,
-					  IW_EV_FREQ_LEN);
-	memset(&iwe, 0, sizeof(iwe));
-	iwe.cmd = IWEVQUAL;
-	iwe.u.qual.qual = bss->qual;
-	iwe.u.qual.level = bss->signal;
-	iwe.u.qual.noise = bss->noise;
-	iwe.u.qual.updated = local->wstats_flags;
-	current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe,
-					  IW_EV_QUAL_LEN);
-
-	memset(&iwe, 0, sizeof(iwe));
-	iwe.cmd = SIOCGIWENCODE;
-	if (bss->capability & WLAN_CAPABILITY_PRIVACY)
-		iwe.u.data.flags = IW_ENCODE_ENABLED | IW_ENCODE_NOKEY;
-	else
-		iwe.u.data.flags = IW_ENCODE_DISABLED;
-	iwe.u.data.length = 0;
-	current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-					  &iwe, "");
-
-	ieee80211_sta_add_scan_ies(info, bss, &current_ev, end_buf);
-
-	if (bss->supp_rates_len > 0) {
-		/* display all supported rates in readable format */
-		char *p = current_ev + iwe_stream_lcp_len(info);
-		int i;
-
-		memset(&iwe, 0, sizeof(iwe));
-		iwe.cmd = SIOCGIWRATE;
-		/* Those two flags are ignored... */
-		iwe.u.bitrate.fixed = iwe.u.bitrate.disabled = 0;
-
-		for (i = 0; i < bss->supp_rates_len; i++) {
-			iwe.u.bitrate.value = ((bss->supp_rates[i] &
-							0x7f) * 500000);
-			p = iwe_stream_add_value(info, current_ev, p,
-					end_buf, &iwe, IW_EV_PARAM_LEN);
-		}
-		current_ev = p;
-	}
-
-	buf = kmalloc(30, GFP_ATOMIC);
-	if (buf) {
-		memset(&iwe, 0, sizeof(iwe));
-		iwe.cmd = IWEVCUSTOM;
-		sprintf(buf, "tsf=%016llx", (unsigned long long)(bss->timestamp));
-		iwe.u.data.length = strlen(buf);
-		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-						  &iwe, buf);
-		memset(&iwe, 0, sizeof(iwe));
-		iwe.cmd = IWEVCUSTOM;
-		sprintf(buf, " Last beacon: %dms ago",
-			jiffies_to_msecs(jiffies - bss->last_update));
-		iwe.u.data.length = strlen(buf);
-		current_ev = iwe_stream_add_point(info, current_ev,
-						  end_buf, &iwe, buf);
-		kfree(buf);
-	}
-
-	if (bss_mesh_cfg(bss)) {
-		u8 *cfg = bss_mesh_cfg(bss);
-		buf = kmalloc(50, GFP_ATOMIC);
-		if (buf) {
-			memset(&iwe, 0, sizeof(iwe));
-			iwe.cmd = IWEVCUSTOM;
-			sprintf(buf, "Mesh network (version %d)", cfg[0]);
-			iwe.u.data.length = strlen(buf);
-			current_ev = iwe_stream_add_point(info, current_ev,
-							  end_buf,
-							  &iwe, buf);
-			sprintf(buf, "Path Selection Protocol ID: "
-				"0x%02X%02X%02X%02X", cfg[1], cfg[2], cfg[3],
-							cfg[4]);
-			iwe.u.data.length = strlen(buf);
-			current_ev = iwe_stream_add_point(info, current_ev,
-							  end_buf,
-							  &iwe, buf);
-			sprintf(buf, "Path Selection Metric ID: "
-				"0x%02X%02X%02X%02X", cfg[5], cfg[6], cfg[7],
-							cfg[8]);
-			iwe.u.data.length = strlen(buf);
-			current_ev = iwe_stream_add_point(info, current_ev,
-							  end_buf,
-							  &iwe, buf);
-			sprintf(buf, "Congestion Control Mode ID: "
-				"0x%02X%02X%02X%02X", cfg[9], cfg[10],
-							cfg[11], cfg[12]);
-			iwe.u.data.length = strlen(buf);
-			current_ev = iwe_stream_add_point(info, current_ev,
-							  end_buf,
-							  &iwe, buf);
-			sprintf(buf, "Channel Precedence: "
-				"0x%02X%02X%02X%02X", cfg[13], cfg[14],
-							cfg[15], cfg[16]);
-			iwe.u.data.length = strlen(buf);
-			current_ev = iwe_stream_add_point(info, current_ev,
-							  end_buf,
-							  &iwe, buf);
-			kfree(buf);
-		}
-	}
-
-	return current_ev;
-}
-
-
-int ieee80211_sta_scan_results(struct ieee80211_local *local,
-			       struct iw_request_info *info,
-			       char *buf, size_t len)
-{
-	char *current_ev = buf;
-	char *end_buf = buf + len;
-	struct ieee80211_sta_bss *bss;
-
-	spin_lock_bh(&local->sta_bss_lock);
-	list_for_each_entry(bss, &local->sta_bss_list, list) {
-		if (buf + len - current_ev <= IW_EV_ADDR_LEN) {
-			spin_unlock_bh(&local->sta_bss_lock);
-			return -E2BIG;
-		}
-		current_ev = ieee80211_sta_scan_result(local, info, bss,
-						       current_ev, end_buf);
-	}
-	spin_unlock_bh(&local->sta_bss_lock);
-	return current_ev - buf;
-}
-
-
 int ieee80211_sta_set_extra_ie(struct ieee80211_sub_if_data *sdata, char *ie, size_t len)
 {
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
@@ -4245,3 +3709,17 @@ void ieee80211_sta_work(struct work_stru
 		ieee80211_set_disassoc(sdata, ifsta, 0);
 	}
 }
+
+void ieee80211_mlme_notify_scan_completed(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
+	struct ieee80211_if_sta *ifsta;
+
+	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
+		ifsta = &sdata->u.sta;
+		if (!(ifsta->flags & IEEE80211_STA_BSSID_SET) ||
+		    (!(ifsta->state == IEEE80211_STA_MLME_IBSS_JOINED) &&
+		    !ieee80211_sta_active_ibss(sdata)))
+			ieee80211_sta_find_ibss(sdata, ifsta);
+	}
+}
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ everything/net/mac80211/scan.c	2008-09-06 23:26:33.000000000 +0200
@@ -0,0 +1,547 @@
+/*
+ * BSS client mode implementation
+ * Copyright 2003, Jouni Malinen <jkmaline@cc.hut.fi>
+ * Copyright 2004, Instant802 Networks, Inc.
+ * Copyright 2005, Devicescape Software, Inc.
+ * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
+ * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/wireless.h>
+#include <linux/if_arp.h>
+#include <net/mac80211.h>
+#include <net/iw_handler.h>
+
+#include "ieee80211_i.h"
+
+#define IEEE80211_PROBE_DELAY (HZ / 33)
+#define IEEE80211_CHANNEL_TIME (HZ / 33)
+#define IEEE80211_PASSIVE_CHANNEL_TIME (HZ / 5)
+
+
+static void ieee80211_send_nullfunc(struct ieee80211_local *local,
+				    struct ieee80211_sub_if_data *sdata,
+				    int powersave)
+{
+	struct sk_buff *skb;
+	struct ieee80211_hdr *nullfunc;
+	__le16 fc;
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
+	memcpy(nullfunc->addr1, sdata->u.sta.bssid, ETH_ALEN);
+	memcpy(nullfunc->addr2, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(nullfunc->addr3, sdata->u.sta.bssid, ETH_ALEN);
+
+	ieee80211_sta_tx(sdata, skb, 0);
+}
+
+static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
+{
+	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
+	    ieee80211_vif_is_mesh(&sdata->vif))
+		ieee80211_sta_timer((unsigned long)sdata);
+}
+
+void ieee80211_scan_completed(struct ieee80211_hw *hw)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata;
+	union iwreq_data wrqu;
+
+	local->last_scan_completed = jiffies;
+	memset(&wrqu, 0, sizeof(wrqu));
+	wireless_send_event(local->scan_sdata->dev, SIOCGIWSCAN, &wrqu, NULL);
+
+	if (local->sta_hw_scanning) {
+		local->sta_hw_scanning = 0;
+		if (ieee80211_hw_config(local))
+			printk(KERN_DEBUG "%s: failed to restore operational "
+			       "channel after scan\n", wiphy_name(local->hw.wiphy));
+		/* Restart STA timer for HW scan case */
+		rcu_read_lock();
+		list_for_each_entry_rcu(sdata, &local->interfaces, list)
+			ieee80211_restart_sta_timer(sdata);
+		rcu_read_unlock();
+
+		goto done;
+	}
+
+	local->sta_sw_scanning = 0;
+	if (ieee80211_hw_config(local))
+		printk(KERN_DEBUG "%s: failed to restore operational "
+		       "channel after scan\n", wiphy_name(local->hw.wiphy));
+
+
+	netif_tx_lock_bh(local->mdev);
+	netif_addr_lock(local->mdev);
+	local->filter_flags &= ~FIF_BCN_PRBRESP_PROMISC;
+	local->ops->configure_filter(local_to_hw(local),
+				     FIF_BCN_PRBRESP_PROMISC,
+				     &local->filter_flags,
+				     local->mdev->mc_count,
+				     local->mdev->mc_list);
+
+	netif_addr_unlock(local->mdev);
+	netif_tx_unlock_bh(local->mdev);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		/* Tell AP we're back */
+		if (sdata->vif.type == IEEE80211_IF_TYPE_STA &&
+		    sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED)
+			ieee80211_send_nullfunc(local, sdata, 0);
+
+		ieee80211_restart_sta_timer(sdata);
+
+		netif_wake_queue(sdata->dev);
+	}
+	rcu_read_unlock();
+
+ done:
+ 	ieee80211_mlme_notify_scan_completed(local);
+}
+EXPORT_SYMBOL(ieee80211_scan_completed);
+
+void ieee80211_sta_scan_work(struct work_struct *work)
+{
+	struct ieee80211_local *local =
+		container_of(work, struct ieee80211_local, scan_work.work);
+	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *chan;
+	int skip;
+	unsigned long next_delay = 0;
+
+	if (!local->sta_sw_scanning)
+		return;
+
+	switch (local->scan_state) {
+	case SCAN_SET_CHANNEL:
+		/*
+		 * Get current scan band. scan_band may be IEEE80211_NUM_BANDS
+		 * after we successfully scanned the last channel of the last
+		 * band (and the last band is supported by the hw)
+		 */
+		if (local->scan_band < IEEE80211_NUM_BANDS)
+			sband = local->hw.wiphy->bands[local->scan_band];
+		else
+			sband = NULL;
+
+		/*
+		 * If we are at an unsupported band and have more bands
+		 * left to scan, advance to the next supported one.
+		 */
+		while (!sband && local->scan_band < IEEE80211_NUM_BANDS - 1) {
+			local->scan_band++;
+			sband = local->hw.wiphy->bands[local->scan_band];
+			local->scan_channel_idx = 0;
+		}
+
+		/* if no more bands/channels left, complete scan */
+		if (!sband || local->scan_channel_idx >= sband->n_channels) {
+			ieee80211_scan_completed(local_to_hw(local));
+			return;
+		}
+		skip = 0;
+		chan = &sband->channels[local->scan_channel_idx];
+
+		if (chan->flags & IEEE80211_CHAN_DISABLED ||
+		    (sdata->vif.type == IEEE80211_IF_TYPE_IBSS &&
+		     chan->flags & IEEE80211_CHAN_NO_IBSS))
+			skip = 1;
+
+		if (!skip) {
+			local->scan_channel = chan;
+			if (ieee80211_hw_config(local)) {
+				printk(KERN_DEBUG "%s: failed to set freq to "
+				       "%d MHz for scan\n", wiphy_name(local->hw.wiphy),
+				       chan->center_freq);
+				skip = 1;
+			}
+		}
+
+		/* advance state machine to next channel/band */
+		local->scan_channel_idx++;
+		if (local->scan_channel_idx >= sband->n_channels) {
+			/*
+			 * scan_band may end up == IEEE80211_NUM_BANDS, but
+			 * we'll catch that case above and complete the scan
+			 * if that is the case.
+			 */
+			local->scan_band++;
+			local->scan_channel_idx = 0;
+		}
+
+		if (skip)
+			break;
+
+		next_delay = IEEE80211_PROBE_DELAY +
+			     usecs_to_jiffies(local->hw.channel_change_time);
+		local->scan_state = SCAN_SEND_PROBE;
+		break;
+	case SCAN_SEND_PROBE:
+		next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
+		local->scan_state = SCAN_SET_CHANNEL;
+
+		if (local->scan_channel->flags & IEEE80211_CHAN_PASSIVE_SCAN)
+			break;
+		ieee80211_send_probe_req(sdata, NULL, local->scan_ssid,
+					 local->scan_ssid_len);
+		next_delay = IEEE80211_CHANNEL_TIME;
+		break;
+	}
+
+	if (local->sta_sw_scanning)
+		queue_delayed_work(local->hw.workqueue, &local->scan_work,
+				   next_delay);
+}
+
+
+int ieee80211_sta_start_scan(struct ieee80211_sub_if_data *scan_sdata,
+			     u8 *ssid, size_t ssid_len)
+{
+	struct ieee80211_local *local = scan_sdata->local;
+	struct ieee80211_sub_if_data *sdata;
+
+	if (ssid_len > IEEE80211_MAX_SSID_LEN)
+		return -EINVAL;
+
+	/* MLME-SCAN.request (page 118)  page 144 (11.1.3.1)
+	 * BSSType: INFRASTRUCTURE, INDEPENDENT, ANY_BSS
+	 * BSSID: MACAddress
+	 * SSID
+	 * ScanType: ACTIVE, PASSIVE
+	 * ProbeDelay: delay (in microseconds) to be used prior to transmitting
+	 *    a Probe frame during active scanning
+	 * ChannelList
+	 * MinChannelTime (>= ProbeDelay), in TU
+	 * MaxChannelTime: (>= MinChannelTime), in TU
+	 */
+
+	 /* MLME-SCAN.confirm
+	  * BSSDescriptionSet
+	  * ResultCode: SUCCESS, INVALID_PARAMETERS
+	 */
+
+	if (local->sta_sw_scanning || local->sta_hw_scanning) {
+		if (local->scan_sdata == scan_sdata)
+			return 0;
+		return -EBUSY;
+	}
+
+	if (local->ops->hw_scan) {
+		int rc = local->ops->hw_scan(local_to_hw(local),
+					     ssid, ssid_len);
+		if (!rc) {
+			local->sta_hw_scanning = 1;
+			local->scan_sdata = scan_sdata;
+		}
+		return rc;
+	}
+
+	local->sta_sw_scanning = 1;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		netif_stop_queue(sdata->dev);
+		if (sdata->vif.type == IEEE80211_IF_TYPE_STA &&
+		    (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED))
+			ieee80211_send_nullfunc(local, sdata, 1);
+	}
+	rcu_read_unlock();
+
+	if (ssid) {
+		local->scan_ssid_len = ssid_len;
+		memcpy(local->scan_ssid, ssid, ssid_len);
+	} else
+		local->scan_ssid_len = 0;
+	local->scan_state = SCAN_SET_CHANNEL;
+	local->scan_channel_idx = 0;
+	local->scan_band = IEEE80211_BAND_2GHZ;
+	local->scan_sdata = scan_sdata;
+
+	netif_addr_lock_bh(local->mdev);
+	local->filter_flags |= FIF_BCN_PRBRESP_PROMISC;
+	local->ops->configure_filter(local_to_hw(local),
+				     FIF_BCN_PRBRESP_PROMISC,
+				     &local->filter_flags,
+				     local->mdev->mc_count,
+				     local->mdev->mc_list);
+	netif_addr_unlock_bh(local->mdev);
+
+	/* TODO: start scan as soon as all nullfunc frames are ACKed */
+	queue_delayed_work(local->hw.workqueue, &local->scan_work,
+			   IEEE80211_CHANNEL_TIME);
+
+	return 0;
+}
+
+
+int ieee80211_sta_req_scan(struct ieee80211_sub_if_data *sdata, u8 *ssid, size_t ssid_len)
+{
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct ieee80211_local *local = sdata->local;
+
+	if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
+		return ieee80211_sta_start_scan(sdata, ssid, ssid_len);
+
+	if (local->sta_sw_scanning || local->sta_hw_scanning) {
+		if (local->scan_sdata == sdata)
+			return 0;
+		return -EBUSY;
+	}
+
+	ifsta->scan_ssid_len = ssid_len;
+	if (ssid_len)
+		memcpy(ifsta->scan_ssid, ssid, ssid_len);
+	set_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request);
+	queue_work(local->hw.workqueue, &ifsta->work);
+	return 0;
+}
+
+
+static void ieee80211_sta_add_scan_ies(struct iw_request_info *info,
+				       struct ieee80211_sta_bss *bss,
+				       char **current_ev, char *end_buf)
+{
+	u8 *pos, *end, *next;
+	struct iw_event iwe;
+
+	if (bss == NULL || bss->ies == NULL)
+		return;
+
+	/*
+	 * If needed, fragment the IEs buffer (at IE boundaries) into short
+	 * enough fragments to fit into IW_GENERIC_IE_MAX octet messages.
+	 */
+	pos = bss->ies;
+	end = pos + bss->ies_len;
+
+	while (end - pos > IW_GENERIC_IE_MAX) {
+		next = pos + 2 + pos[1];
+		while (next + 2 + next[1] - pos < IW_GENERIC_IE_MAX)
+			next = next + 2 + next[1];
+
+		memset(&iwe, 0, sizeof(iwe));
+		iwe.cmd = IWEVGENIE;
+		iwe.u.data.length = next - pos;
+		*current_ev = iwe_stream_add_point(info, *current_ev,
+						   end_buf, &iwe, pos);
+
+		pos = next;
+	}
+
+	if (end > pos) {
+		memset(&iwe, 0, sizeof(iwe));
+		iwe.cmd = IWEVGENIE;
+		iwe.u.data.length = end - pos;
+		*current_ev = iwe_stream_add_point(info, *current_ev,
+						   end_buf, &iwe, pos);
+	}
+}
+
+
+static char *
+ieee80211_sta_scan_result(struct ieee80211_local *local,
+			  struct iw_request_info *info,
+			  struct ieee80211_sta_bss *bss,
+			  char *current_ev, char *end_buf)
+{
+	struct iw_event iwe;
+	char *buf;
+
+	if (time_after(jiffies,
+		       bss->last_update + IEEE80211_SCAN_RESULT_EXPIRE))
+		return current_ev;
+
+	memset(&iwe, 0, sizeof(iwe));
+	iwe.cmd = SIOCGIWAP;
+	iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
+	memcpy(iwe.u.ap_addr.sa_data, bss->bssid, ETH_ALEN);
+	current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe,
+					  IW_EV_ADDR_LEN);
+
+	memset(&iwe, 0, sizeof(iwe));
+	iwe.cmd = SIOCGIWESSID;
+	if (bss_mesh_cfg(bss)) {
+		iwe.u.data.length = bss_mesh_id_len(bss);
+		iwe.u.data.flags = 1;
+		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
+						  &iwe, bss_mesh_id(bss));
+	} else {
+		iwe.u.data.length = bss->ssid_len;
+		iwe.u.data.flags = 1;
+		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
+						  &iwe, bss->ssid);
+	}
+
+	if (bss->capability & (WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_IBSS)
+	    || bss_mesh_cfg(bss)) {
+		memset(&iwe, 0, sizeof(iwe));
+		iwe.cmd = SIOCGIWMODE;
+		if (bss_mesh_cfg(bss))
+			iwe.u.mode = IW_MODE_MESH;
+		else if (bss->capability & WLAN_CAPABILITY_ESS)
+			iwe.u.mode = IW_MODE_MASTER;
+		else
+			iwe.u.mode = IW_MODE_ADHOC;
+		current_ev = iwe_stream_add_event(info, current_ev, end_buf,
+						  &iwe, IW_EV_UINT_LEN);
+	}
+
+	memset(&iwe, 0, sizeof(iwe));
+	iwe.cmd = SIOCGIWFREQ;
+	iwe.u.freq.m = ieee80211_frequency_to_channel(bss->freq);
+	iwe.u.freq.e = 0;
+	current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe,
+					  IW_EV_FREQ_LEN);
+
+	memset(&iwe, 0, sizeof(iwe));
+	iwe.cmd = SIOCGIWFREQ;
+	iwe.u.freq.m = bss->freq;
+	iwe.u.freq.e = 6;
+	current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe,
+					  IW_EV_FREQ_LEN);
+	memset(&iwe, 0, sizeof(iwe));
+	iwe.cmd = IWEVQUAL;
+	iwe.u.qual.qual = bss->qual;
+	iwe.u.qual.level = bss->signal;
+	iwe.u.qual.noise = bss->noise;
+	iwe.u.qual.updated = local->wstats_flags;
+	current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe,
+					  IW_EV_QUAL_LEN);
+
+	memset(&iwe, 0, sizeof(iwe));
+	iwe.cmd = SIOCGIWENCODE;
+	if (bss->capability & WLAN_CAPABILITY_PRIVACY)
+		iwe.u.data.flags = IW_ENCODE_ENABLED | IW_ENCODE_NOKEY;
+	else
+		iwe.u.data.flags = IW_ENCODE_DISABLED;
+	iwe.u.data.length = 0;
+	current_ev = iwe_stream_add_point(info, current_ev, end_buf,
+					  &iwe, "");
+
+	ieee80211_sta_add_scan_ies(info, bss, &current_ev, end_buf);
+
+	if (bss->supp_rates_len > 0) {
+		/* display all supported rates in readable format */
+		char *p = current_ev + iwe_stream_lcp_len(info);
+		int i;
+
+		memset(&iwe, 0, sizeof(iwe));
+		iwe.cmd = SIOCGIWRATE;
+		/* Those two flags are ignored... */
+		iwe.u.bitrate.fixed = iwe.u.bitrate.disabled = 0;
+
+		for (i = 0; i < bss->supp_rates_len; i++) {
+			iwe.u.bitrate.value = ((bss->supp_rates[i] &
+							0x7f) * 500000);
+			p = iwe_stream_add_value(info, current_ev, p,
+					end_buf, &iwe, IW_EV_PARAM_LEN);
+		}
+		current_ev = p;
+	}
+
+	buf = kmalloc(30, GFP_ATOMIC);
+	if (buf) {
+		memset(&iwe, 0, sizeof(iwe));
+		iwe.cmd = IWEVCUSTOM;
+		sprintf(buf, "tsf=%016llx", (unsigned long long)(bss->timestamp));
+		iwe.u.data.length = strlen(buf);
+		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
+						  &iwe, buf);
+		memset(&iwe, 0, sizeof(iwe));
+		iwe.cmd = IWEVCUSTOM;
+		sprintf(buf, " Last beacon: %dms ago",
+			jiffies_to_msecs(jiffies - bss->last_update));
+		iwe.u.data.length = strlen(buf);
+		current_ev = iwe_stream_add_point(info, current_ev,
+						  end_buf, &iwe, buf);
+		kfree(buf);
+	}
+
+	if (bss_mesh_cfg(bss)) {
+		u8 *cfg = bss_mesh_cfg(bss);
+		buf = kmalloc(50, GFP_ATOMIC);
+		if (buf) {
+			memset(&iwe, 0, sizeof(iwe));
+			iwe.cmd = IWEVCUSTOM;
+			sprintf(buf, "Mesh network (version %d)", cfg[0]);
+			iwe.u.data.length = strlen(buf);
+			current_ev = iwe_stream_add_point(info, current_ev,
+							  end_buf,
+							  &iwe, buf);
+			sprintf(buf, "Path Selection Protocol ID: "
+				"0x%02X%02X%02X%02X", cfg[1], cfg[2], cfg[3],
+							cfg[4]);
+			iwe.u.data.length = strlen(buf);
+			current_ev = iwe_stream_add_point(info, current_ev,
+							  end_buf,
+							  &iwe, buf);
+			sprintf(buf, "Path Selection Metric ID: "
+				"0x%02X%02X%02X%02X", cfg[5], cfg[6], cfg[7],
+							cfg[8]);
+			iwe.u.data.length = strlen(buf);
+			current_ev = iwe_stream_add_point(info, current_ev,
+							  end_buf,
+							  &iwe, buf);
+			sprintf(buf, "Congestion Control Mode ID: "
+				"0x%02X%02X%02X%02X", cfg[9], cfg[10],
+							cfg[11], cfg[12]);
+			iwe.u.data.length = strlen(buf);
+			current_ev = iwe_stream_add_point(info, current_ev,
+							  end_buf,
+							  &iwe, buf);
+			sprintf(buf, "Channel Precedence: "
+				"0x%02X%02X%02X%02X", cfg[13], cfg[14],
+							cfg[15], cfg[16]);
+			iwe.u.data.length = strlen(buf);
+			current_ev = iwe_stream_add_point(info, current_ev,
+							  end_buf,
+							  &iwe, buf);
+			kfree(buf);
+		}
+	}
+
+	return current_ev;
+}
+
+
+int ieee80211_sta_scan_results(struct ieee80211_local *local,
+			       struct iw_request_info *info,
+			       char *buf, size_t len)
+{
+	char *current_ev = buf;
+	char *end_buf = buf + len;
+	struct ieee80211_sta_bss *bss;
+
+	spin_lock_bh(&local->sta_bss_lock);
+	list_for_each_entry(bss, &local->sta_bss_list, list) {
+		if (buf + len - current_ev <= IW_EV_ADDR_LEN) {
+			spin_unlock_bh(&local->sta_bss_lock);
+			return -E2BIG;
+		}
+		current_ev = ieee80211_sta_scan_result(local, info, bss,
+						       current_ev, end_buf);
+	}
+	spin_unlock_bh(&local->sta_bss_lock);
+	return current_ev - buf;
+}


