Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55855 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541Ab1ISQQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 12:16:11 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 6/9] ath6kl: Remove the unused node table implementation
Date: Mon, 19 Sep 2011 19:15:04 +0300
Message-ID: <1316448907-10166-7-git-send-email-jouni@qca.qualcomm.com> (sfid-20110919_181616_824368_2D8D6A59)
In-Reply-To: <1316448907-10166-1-git-send-email-jouni@qca.qualcomm.com>
References: <1316448907-10166-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that the scan results are reported directly to the cfg80211 BSS
table there is no need for maintaining this internal node table
implementation for scan results. Remove the definitions and node
table functions.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/Makefile   |    1 -
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   52 ------
 drivers/net/wireless/ath/ath6kl/common.h   |   83 ----------
 drivers/net/wireless/ath/ath6kl/core.h     |    2 -
 drivers/net/wireless/ath/ath6kl/init.c     |    5 -
 drivers/net/wireless/ath/ath6kl/node.c     |  234 ----------------------------
 drivers/net/wireless/ath/ath6kl/wmi.c      |   37 -----
 drivers/net/wireless/ath/ath6kl/wmi.h      |    8 -
 8 files changed, 0 insertions(+), 422 deletions(-)
 delete mode 100644 drivers/net/wireless/ath/ath6kl/node.c

diff --git a/drivers/net/wireless/ath/ath6kl/Makefile b/drivers/net/wireless/ath/ath6kl/Makefile
index 5fe0920..8f7a0d1 100644
--- a/drivers/net/wireless/ath/ath6kl/Makefile
+++ b/drivers/net/wireless/ath/ath6kl/Makefile
@@ -31,7 +31,6 @@ ath6kl-y += init.o
 ath6kl-y += main.o
 ath6kl-y += txrx.o
 ath6kl-y += wmi.o
-ath6kl-y += node.o
 ath6kl-y += sdio.o
 ath6kl-$(CONFIG_NL80211_TESTMODE) += testmode.o
 
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 5ede3d2..b328437 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -626,55 +626,6 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl *ar, u8 reason,
 	ar->sme_state = SME_DISCONNECTED;
 }
 
-static inline bool is_ch_11a(u16 ch)
-{
-	return (!((ch >= 2412) && (ch <= 2484)));
-}
-
-/* struct ath6kl_node_table::nt_nodelock is locked when calling this */
-void ath6kl_cfg80211_scan_node(struct wiphy *wiphy, struct bss *ni)
-{
-	struct ieee80211_mgmt *mgmt;
-	struct ieee80211_channel *channel;
-	struct ieee80211_supported_band *band;
-	struct ath6kl_common_ie *cie;
-	s32 signal;
-	int freq;
-
-	cie = &ni->ni_cie;
-
-	if (is_ch_11a(cie->ie_chan))
-		band = wiphy->bands[IEEE80211_BAND_5GHZ]; /* 11a */
-	else if ((cie->ie_erp) || (cie->ie_xrates))
-		band = wiphy->bands[IEEE80211_BAND_2GHZ]; /* 11g */
-	else
-		band = wiphy->bands[IEEE80211_BAND_2GHZ]; /* 11b */
-
-	freq = cie->ie_chan;
-	channel = ieee80211_get_channel(wiphy, freq);
-	signal = ni->ni_snr * 100;
-
-	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
-		   "%s: bssid %pM ch %d freq %d size %d\n", __func__,
-		   ni->ni_macaddr, channel->hw_value, freq, ni->ni_framelen);
-	/*
-	 * Both Beacon and Probe Response frames have same payload structure,
-	 * so it is fine to share the parser for both.
-	 */
-	if (ni->ni_framelen < 8 + 2 + 2)
-		return;
-	mgmt = (struct ieee80211_mgmt *) (ni->ni_buf -
-					  offsetof(struct ieee80211_mgmt, u));
-	cfg80211_inform_bss(wiphy, channel, ni->ni_macaddr,
-			    le64_to_cpu(mgmt->u.beacon.timestamp),
-			    le16_to_cpu(mgmt->u.beacon.capab_info),
-			    le16_to_cpu(mgmt->u.beacon.beacon_int),
-			    mgmt->u.beacon.variable,
-			    ni->ni_buf + ni->ni_framelen -
-			    mgmt->u.beacon.variable,
-			    signal, GFP_ATOMIC);
-}
-
 static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 				struct cfg80211_scan_request *request)
 {
@@ -768,9 +719,6 @@ void ath6kl_cfg80211_scan_complete_event(struct ath6kl *ar, int status)
 		goto out;
 	}
 
-	/* Translate data to cfg80211 mgmt format */
-	wlan_iterate_nodes(&ar->scan_table, ar->wdev->wiphy);
-
 	cfg80211_scan_done(ar->scan_req, false);
 
 	if (ar->scan_req->n_ssids && ar->scan_req->ssids[0].ssid_len) {
diff --git a/drivers/net/wireless/ath/ath6kl/common.h b/drivers/net/wireless/ath/ath6kl/common.h
index 6b0d456..b92f0e5 100644
--- a/drivers/net/wireless/ath/ath6kl/common.h
+++ b/drivers/net/wireless/ath/ath6kl/common.h
@@ -75,94 +75,11 @@ enum crypto_type {
 	AES_CRYPT           = 0x08,
 };
 
-#define ATH6KL_NODE_HASHSIZE 32
-/* simple hash is enough for variation of macaddr */
-#define ATH6KL_NODE_HASH(addr)   \
-	(((const u8 *)(addr))[ETH_ALEN - 1] % \
-	 ATH6KL_NODE_HASHSIZE)
-
-/*
- * Table of ath6kl_node instances.  Each ieee80211com
- * has at least one for holding the scan candidates.
- * When operating as an access point or in ibss mode there
- * is a second table for associated stations or neighbors.
- */
-struct ath6kl_node_table {
-	spinlock_t nt_nodelock;	/* on node table */
-	struct bss *nt_node_first;	/* information of all nodes */
-	struct bss *nt_node_last;	/* information of all nodes */
-	struct bss *nt_hash[ATH6KL_NODE_HASHSIZE];
-	const char *nt_name;	/* for debugging */
-	u32 nt_node_age;		/* node aging time */
-};
-
-#define WLAN_NODE_INACT_TIMEOUT_MSEC    120000
-#define WLAN_NODE_INACT_CNT		4
-
-struct ath6kl_common_ie {
-	u16 ie_chan;
-	u8 *ie_tstamp;
-	u8 *ie_ssid;
-	u8 *ie_rates;
-	u8 *ie_xrates;
-	u8 *ie_country;
-	u8 *ie_wpa;
-	u8 *ie_rsn;
-	u8 *ie_wmm;
-	u8 *ie_ath;
-	u16 ie_capInfo;
-	u16 ie_beaconInt;
-	u8 *ie_tim;
-	u8 *ie_chswitch;
-	u8 ie_erp;
-	u8 *ie_wsc;
-	u8 *ie_htcap;
-	u8 *ie_htop;
-};
-
-struct bss {
-	u8 ni_macaddr[ETH_ALEN];
-	u8 ni_snr;
-	s16 ni_rssi;
-	struct bss *ni_list_next;
-	struct bss *ni_list_prev;
-	struct bss *ni_hash_next;
-	struct bss *ni_hash_prev;
-	struct ath6kl_common_ie ni_cie;
-	u8 *ni_buf;
-	u16 ni_framelen;
-	struct ath6kl_node_table *ni_table;
-	u32 ni_refcnt;
-
-	u32 ni_tstamp;
-	u32 ni_actcnt;
-};
-
 struct htc_endpoint_credit_dist;
 struct ath6kl;
 enum htc_credit_dist_reason;
 struct htc_credit_state_info;
 
-struct bss *wlan_node_alloc(int wh_size);
-void wlan_node_free(struct bss *ni);
-void wlan_setup_node(struct ath6kl_node_table *nt, struct bss *ni,
-		     const u8 *mac_addr);
-struct bss *wlan_find_node(struct ath6kl_node_table *nt,
-			   const u8 *mac_addr);
-void wlan_node_reclaim(struct ath6kl_node_table *nt, struct bss *ni);
-void wlan_free_allnodes(struct ath6kl_node_table *nt);
-void wlan_iterate_nodes(struct ath6kl_node_table *nt, void *arg);
-
-void wlan_node_table_init(struct ath6kl_node_table *nt);
-void wlan_node_table_cleanup(struct ath6kl_node_table *nt);
-
-void wlan_refresh_inactive_nodes(struct ath6kl *ar);
-
-struct bss *wlan_find_ssid_node(struct ath6kl_node_table *nt, u8 *ssid,
-				  u32 ssid_len, bool is_wpa2, bool match_ssid);
-
-void wlan_node_return(struct ath6kl_node_table *nt, struct bss *ni);
-
 int ath6k_setup_credit_dist(void *htc_handle,
 			    struct htc_credit_state_info *cred_info);
 void ath6k_credit_distribute(struct htc_credit_state_info *cred_inf,
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index a9b3b17..9e6abb8 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -503,7 +503,6 @@ struct ath6kl {
 
 	struct workqueue_struct *ath6kl_wq;
 
-	struct ath6kl_node_table scan_table;
 	struct dentry *debugfs_phy;
 
 	u32 send_action_id;
@@ -626,5 +625,4 @@ void aggr_recv_addba_req_evt(struct ath6kl *ar, u8 tid, u16 seq_no,
 void ath6kl_wakeup_event(void *dev);
 void ath6kl_target_failure(struct ath6kl *ar);
 
-void ath6kl_cfg80211_scan_node(struct wiphy *wiphy, struct bss *ni);
 #endif /* CORE_H */
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 1834e9a..7e10f71 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1418,8 +1418,6 @@ static int ath6kl_init(struct net_device *dev)
 
 	ath6kl_dbg(ATH6KL_DBG_TRC, "%s: got wmi @ 0x%p.\n", __func__, ar->wmi);
 
-	wlan_node_table_init(&ar->scan_table);
-
 	/*
 	 * The reason we have to wait for the target here is that the
 	 * driver layer has to init BMI in order to set the host block
@@ -1501,7 +1499,6 @@ err_rxbuf_cleanup:
 err_cleanup_scatter:
 	ath6kl_hif_cleanup_scatter(ar);
 err_node_cleanup:
-	wlan_node_table_cleanup(&ar->scan_table);
 	ath6kl_wmi_shutdown(ar->wmi);
 	clear_bit(WMI_ENABLED, &ar->flag);
 	ar->wmi = NULL;
@@ -1658,8 +1655,6 @@ void ath6kl_destroy(struct net_device *dev, unsigned int unregister)
 
 	free_netdev(dev);
 
-	wlan_node_table_cleanup(&ar->scan_table);
-
 	kfree(ar->fw_board);
 	kfree(ar->fw_otp);
 	kfree(ar->fw);
diff --git a/drivers/net/wireless/ath/ath6kl/node.c b/drivers/net/wireless/ath/ath6kl/node.c
deleted file mode 100644
index 131205c..0000000
--- a/drivers/net/wireless/ath/ath6kl/node.c
+++ /dev/null
@@ -1,234 +0,0 @@
-/*
- * Copyright (c) 2004-2011 Atheros Communications Inc.
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#include "htc.h"
-#include "wmi.h"
-#include "debug.h"
-
-struct bss *wlan_node_alloc(int wh_size)
-{
-	struct bss *ni;
-
-	ni = kzalloc(sizeof(struct bss), GFP_ATOMIC);
-
-	if ((ni != NULL) && wh_size) {
-		ni->ni_buf = kmalloc(wh_size, GFP_ATOMIC);
-		if (ni->ni_buf == NULL) {
-			kfree(ni);
-			return NULL;
-		}
-	}
-
-	return ni;
-}
-
-void wlan_node_free(struct bss *ni)
-{
-	kfree(ni->ni_buf);
-	kfree(ni);
-}
-
-void wlan_setup_node(struct ath6kl_node_table *nt, struct bss *ni,
-		     const u8 *mac_addr)
-{
-	int hash;
-
-	memcpy(ni->ni_macaddr, mac_addr, ETH_ALEN);
-	hash = ATH6KL_NODE_HASH(mac_addr);
-	ni->ni_refcnt = 1;
-
-	ni->ni_tstamp = jiffies_to_msecs(jiffies);
-	ni->ni_actcnt = WLAN_NODE_INACT_CNT;
-
-	spin_lock_bh(&nt->nt_nodelock);
-
-	/* insert at the end of the node list */
-	ni->ni_list_next = NULL;
-	ni->ni_list_prev = nt->nt_node_last;
-	if (nt->nt_node_last != NULL)
-		nt->nt_node_last->ni_list_next = ni;
-
-	nt->nt_node_last = ni;
-	if (nt->nt_node_first == NULL)
-		nt->nt_node_first = ni;
-
-	/* insert into the hash list */
-	ni->ni_hash_next = nt->nt_hash[hash];
-	if (ni->ni_hash_next != NULL)
-		nt->nt_hash[hash]->ni_hash_prev = ni;
-
-	ni->ni_hash_prev = NULL;
-	nt->nt_hash[hash] = ni;
-
-	spin_unlock_bh(&nt->nt_nodelock);
-}
-
-struct bss *wlan_find_node(struct ath6kl_node_table *nt,
-			   const u8 *mac_addr)
-{
-	struct bss *ni, *found_ni = NULL;
-	int hash;
-
-	spin_lock_bh(&nt->nt_nodelock);
-
-	hash = ATH6KL_NODE_HASH(mac_addr);
-	for (ni = nt->nt_hash[hash]; ni; ni = ni->ni_hash_next) {
-		if (memcmp(ni->ni_macaddr, mac_addr, ETH_ALEN) == 0) {
-			ni->ni_refcnt++;
-			found_ni = ni;
-			break;
-		}
-	}
-
-	spin_unlock_bh(&nt->nt_nodelock);
-
-	return found_ni;
-}
-
-void wlan_node_reclaim(struct ath6kl_node_table *nt, struct bss *ni)
-{
-	int hash;
-
-	spin_lock_bh(&nt->nt_nodelock);
-
-	if (ni->ni_list_prev == NULL)
-		/* fix list head */
-		nt->nt_node_first = ni->ni_list_next;
-	else
-		ni->ni_list_prev->ni_list_next = ni->ni_list_next;
-
-	if (ni->ni_list_next == NULL)
-		/* fix list tail */
-		nt->nt_node_last = ni->ni_list_prev;
-	else
-		ni->ni_list_next->ni_list_prev = ni->ni_list_prev;
-
-	if (ni->ni_hash_prev == NULL) {
-		/* first in list so fix the list head */
-		hash = ATH6KL_NODE_HASH(ni->ni_macaddr);
-		nt->nt_hash[hash] = ni->ni_hash_next;
-	} else {
-		ni->ni_hash_prev->ni_hash_next = ni->ni_hash_next;
-	}
-
-	if (ni->ni_hash_next != NULL)
-		ni->ni_hash_next->ni_hash_prev = ni->ni_hash_prev;
-
-	wlan_node_free(ni);
-
-	spin_unlock_bh(&nt->nt_nodelock);
-}
-
-static void wlan_node_dec_free(struct bss *ni)
-{
-	if ((ni->ni_refcnt--) == 1)
-		wlan_node_free(ni);
-}
-
-void wlan_free_allnodes(struct ath6kl_node_table *nt)
-{
-	struct bss *ni;
-
-	while ((ni = nt->nt_node_first) != NULL)
-		wlan_node_reclaim(nt, ni);
-}
-
-void wlan_iterate_nodes(struct ath6kl_node_table *nt, void *arg)
-{
-	struct bss *ni;
-
-	spin_lock_bh(&nt->nt_nodelock);
-	for (ni = nt->nt_node_first; ni; ni = ni->ni_list_next) {
-			ni->ni_refcnt++;
-			ath6kl_cfg80211_scan_node(arg, ni);
-			wlan_node_dec_free(ni);
-	}
-	spin_unlock_bh(&nt->nt_nodelock);
-}
-
-void wlan_node_table_init(struct ath6kl_node_table *nt)
-{
-	ath6kl_dbg(ATH6KL_DBG_WLAN_NODE, "node table = 0x%lx\n",
-		   (unsigned long)nt);
-
-	memset(nt, 0, sizeof(struct ath6kl_node_table));
-
-	spin_lock_init(&nt->nt_nodelock);
-
-	nt->nt_node_age = WLAN_NODE_INACT_TIMEOUT_MSEC;
-}
-
-void wlan_refresh_inactive_nodes(struct ath6kl *ar)
-{
-	struct ath6kl_node_table *nt = &ar->scan_table;
-	struct bss *bss;
-	u32 now;
-
-	now = jiffies_to_msecs(jiffies);
-	bss = nt->nt_node_first;
-	while (bss != NULL) {
-		/* refresh all nodes except the current bss */
-		if (memcmp(ar->bssid, bss->ni_macaddr, ETH_ALEN) != 0) {
-			if (((now - bss->ni_tstamp) > nt->nt_node_age)
-			    || --bss->ni_actcnt == 0) {
-				wlan_node_reclaim(nt, bss);
-			}
-		}
-		bss = bss->ni_list_next;
-	}
-}
-
-void wlan_node_table_cleanup(struct ath6kl_node_table *nt)
-{
-	wlan_free_allnodes(nt);
-}
-
-struct bss *wlan_find_ssid_node(struct ath6kl_node_table *nt, u8 * ssid,
-				u32 ssid_len, bool is_wpa2, bool match_ssid)
-{
-	struct bss *ni, *found_ni = NULL;
-	u8 *ie_ssid;
-
-	spin_lock_bh(&nt->nt_nodelock);
-
-	for (ni = nt->nt_node_first; ni; ni = ni->ni_list_next) {
-
-		ie_ssid = ni->ni_cie.ie_ssid;
-
-		if ((ie_ssid[1] <= IEEE80211_MAX_SSID_LEN) &&
-		    (memcmp(ssid, &ie_ssid[2], ssid_len) == 0)) {
-
-				if (match_ssid ||
-				    (is_wpa2 && ni->ni_cie.ie_rsn != NULL) ||
-				    (!is_wpa2 && ni->ni_cie.ie_wpa != NULL)) {
-					ni->ni_refcnt++;
-					found_ni = ni;
-					break;
-				}
-		}
-	}
-
-	spin_unlock_bh(&nt->nt_nodelock);
-
-	return found_ni;
-}
-
-void wlan_node_return(struct ath6kl_node_table *nt, struct bss *ni)
-{
-	spin_lock_bh(&nt->nt_nodelock);
-	wlan_node_dec_free(ni);
-	spin_unlock_bh(&nt->nt_nodelock);
-}
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index ff13e0b..3ade9a1 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2457,43 +2457,6 @@ s32 ath6kl_wmi_get_rate(s8 rate_index)
 	return wmi_rate_tbl[(u32) rate_index][0];
 }
 
-void ath6kl_wmi_node_return(struct wmi *wmi, struct bss *bss)
-{
-	if (bss)
-		wlan_node_return(&wmi->parent_dev->scan_table, bss);
-}
-
-struct bss *ath6kl_wmi_find_ssid_node(struct wmi *wmi, u8 * ssid,
-				      u32 ssid_len, bool is_wpa2,
-				      bool match_ssid)
-{
-	struct bss *node = NULL;
-
-	node = wlan_find_ssid_node(&wmi->parent_dev->scan_table, ssid,
-				  ssid_len, is_wpa2, match_ssid);
-	return node;
-}
-
-struct bss *ath6kl_wmi_find_node(struct wmi *wmi, const u8 * mac_addr)
-{
-	struct bss *ni = NULL;
-
-	ni = wlan_find_node(&wmi->parent_dev->scan_table, mac_addr);
-
-	return ni;
-}
-
-void ath6kl_wmi_node_free(struct wmi *wmi, const u8 * mac_addr)
-{
-	struct bss *ni = NULL;
-
-	ni = wlan_find_node(&wmi->parent_dev->scan_table, mac_addr);
-	if (ni != NULL)
-		wlan_node_reclaim(&wmi->parent_dev->scan_table, ni);
-
-	return;
-}
-
 static int ath6kl_wmi_get_pmkid_list_event_rx(struct wmi *wmi, u8 *datap,
 					      u32 len)
 {
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index f036e78..f65bc0d 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -2181,8 +2181,6 @@ int ath6kl_wmi_implicit_create_pstream(struct wmi *wmi, struct sk_buff *skb,
 				       u8 *ac);
 
 int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb);
-struct bss *ath6kl_wmi_find_node(struct wmi *wmi, const u8 *mac_addr);
-void ath6kl_wmi_node_free(struct wmi *wmi, const u8 *mac_addr);
 
 int ath6kl_wmi_cmd_send(struct wmi *wmi, struct sk_buff *skb,
 			enum wmi_cmd_id cmd_id, enum wmi_sync_flag sync_flag);
@@ -2253,12 +2251,6 @@ s32 ath6kl_wmi_get_rate(s8 rate_index);
 int ath6kl_wmi_set_ip_cmd(struct wmi *wmi, struct wmi_set_ip_cmd *ip_cmd);
 int ath6kl_wmi_set_roam_lrssi_cmd(struct wmi *wmi, u8 lrssi);
 
-struct bss *ath6kl_wmi_find_ssid_node(struct wmi *wmi, u8 *ssid,
-				      u32 ssid_len, bool is_wpa2,
-				      bool match_ssid);
-
-void ath6kl_wmi_node_return(struct wmi *wmi, struct bss *bss);
-
 /* AP mode */
 int ath6kl_wmi_ap_profile_commit(struct wmi *wmip, struct wmi_connect_cmd *p);
 
-- 
1.7.4.1

