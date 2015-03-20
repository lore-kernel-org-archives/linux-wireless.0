Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42128 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbbCTKmE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 06:42:04 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove drop_unencrypted code
Date: Fri, 20 Mar 2015 11:41:58 +0100
Message-Id: <1426848118-15545-1-git-send-email-johannes@sipsolutions.net> (sfid-20150320_114214_762618_F0C15458)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This mechanism was historic, and only ever used by IBSS, which
also doesn't need to have it as it properly manages station's
802.1X PAE state (or, with WEP, always has a key.)

Remove the mechanism to clean up the code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs.c        |  2 --
 net/mac80211/debugfs_netdev.c |  2 --
 net/mac80211/ibss.c           |  4 ----
 net/mac80211/ieee80211_i.h    |  3 ---
 net/mac80211/iface.c          |  1 -
 net/mac80211/rx.c             |  3 +--
 net/mac80211/tx.c             | 17 +----------------
 7 files changed, 2 insertions(+), 30 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 74830ce25e74..23813ebb349c 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -274,8 +274,6 @@ void debugfs_hw_add(struct ieee80211_local *local)
 #ifdef CONFIG_MAC80211_DEBUG_COUNTERS
 	DEBUGFS_STATS_ADD(tx_handlers_drop, local->tx_handlers_drop);
 	DEBUGFS_STATS_ADD(tx_handlers_queued, local->tx_handlers_queued);
-	DEBUGFS_STATS_ADD(tx_handlers_drop_unencrypted,
-		local->tx_handlers_drop_unencrypted);
 	DEBUGFS_STATS_ADD(tx_handlers_drop_fragment,
 		local->tx_handlers_drop_fragment);
 	DEBUGFS_STATS_ADD(tx_handlers_drop_wep,
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index c68896adfa96..29236e832e44 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -177,7 +177,6 @@ static ssize_t ieee80211_if_write_##name(struct file *file,		\
 	IEEE80211_IF_FILE_R(name)
 
 /* common attributes */
-IEEE80211_IF_FILE(drop_unencrypted, drop_unencrypted, DEC);
 IEEE80211_IF_FILE(rc_rateidx_mask_2ghz, rc_rateidx_mask[IEEE80211_BAND_2GHZ],
 		  HEX);
 IEEE80211_IF_FILE(rc_rateidx_mask_5ghz, rc_rateidx_mask[IEEE80211_BAND_5GHZ],
@@ -562,7 +561,6 @@ IEEE80211_IF_FILE(dot11MeshAwakeWindowDuration,
 
 static void add_common_files(struct ieee80211_sub_if_data *sdata)
 {
-	DEBUGFS_ADD(drop_unencrypted);
 	DEBUGFS_ADD(rc_rateidx_mask_2ghz);
 	DEBUGFS_ADD(rc_rateidx_mask_5ghz);
 	DEBUGFS_ADD(rc_rateidx_mcs_mask_2ghz);
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index dec24d436e73..17eda3575d7d 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -249,8 +249,6 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	if (presp)
 		kfree_rcu(presp, rcu_head);
 
-	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
-
 	/* make a copy of the chandef, it could be modified below. */
 	chandef = *req_chandef;
 	chan = chandef.chan;
@@ -1303,8 +1301,6 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 
 	if (ifibss->privacy)
 		capability |= WLAN_CAPABILITY_PRIVACY;
-	else
-		sdata->drop_unencrypted = 0;
 
 	__ieee80211_sta_join_ibss(sdata, bssid, sdata->vif.bss_conf.beacon_int,
 				  &ifibss->chandef, ifibss->basic_rates,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0266c573c366..4f4bcc6c5dfe 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -818,8 +818,6 @@ struct ieee80211_sub_if_data {
 
 	unsigned long state;
 
-	int drop_unencrypted;
-
 	char name[IFNAMSIZ];
 
 	/* Fragment table for host-based reassembly */
@@ -1262,7 +1260,6 @@ struct ieee80211_local {
 	/* TX/RX handler statistics */
 	unsigned int tx_handlers_drop;
 	unsigned int tx_handlers_queued;
-	unsigned int tx_handlers_drop_unencrypted;
 	unsigned int tx_handlers_drop_fragment;
 	unsigned int tx_handlers_drop_wep;
 	unsigned int tx_handlers_drop_not_assoc;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 81a27516813e..9689d3b1133b 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1508,7 +1508,6 @@ int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* reset some values that shouldn't be kept across type changes */
-	sdata->drop_unencrypted = 0;
 	if (type == NL80211_IFTYPE_STATION)
 		sdata->u.mgd.use_4addr = false;
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6accd61ee54b..9eab44317c87 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1912,8 +1912,7 @@ static int ieee80211_drop_unencrypted(struct ieee80211_rx_data *rx, __le16 fc)
 	/* Drop unencrypted frames if key is set. */
 	if (unlikely(!ieee80211_has_protected(fc) &&
 		     !ieee80211_is_nullfunc(fc) &&
-		     ieee80211_is_data(fc) &&
-		     (rx->key || rx->sdata->drop_unencrypted)))
+		     ieee80211_is_data(fc) && rx->key))
 		return -EACCES;
 
 	return 0;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 7e7de811e6ad..0bae03bca49e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -593,23 +593,8 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 	else if (!is_multicast_ether_addr(hdr->addr1) &&
 		 (key = rcu_dereference(tx->sdata->default_unicast_key)))
 		tx->key = key;
-	else if (info->flags & IEEE80211_TX_CTL_INJECTED)
-		tx->key = NULL;
-	else if (!tx->sdata->drop_unencrypted)
-		tx->key = NULL;
-	else if (tx->skb->protocol == tx->sdata->control_port_protocol)
-		tx->key = NULL;
-	else if (ieee80211_is_robust_mgmt_frame(tx->skb) &&
-		 !(ieee80211_is_action(hdr->frame_control) &&
-		   tx->sta && test_sta_flag(tx->sta, WLAN_STA_MFP)))
-		tx->key = NULL;
-	else if (ieee80211_is_mgmt(hdr->frame_control) &&
-		 !ieee80211_is_robust_mgmt_frame(tx->skb))
+	else
 		tx->key = NULL;
-	else {
-		I802_DEBUG_INC(tx->local->tx_handlers_drop_unencrypted);
-		return TX_DROP;
-	}
 
 	if (tx->key) {
 		bool skip_hw = false;
-- 
2.1.4

