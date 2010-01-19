Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44687 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab0ASNXT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 08:23:19 -0500
Subject: [PATCH] mac80211: pass station instead of address to
 update_tkip_key
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jan 2010 14:21:42 +0100
Message-ID: <1263907302.12555.27.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a TKIP key is updated, we should pass the station
pointer instead of just the address, since drivers can
use that to store their own data.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/b43/main.c        |   10 +++++++---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    7 +++++--
 include/net/mac80211.h                 |    5 +++--
 net/mac80211/driver-ops.h              |    7 ++++---
 net/mac80211/driver-trace.h            |   10 +++++-----
 net/mac80211/tkip.c                    |    9 +--------
 6 files changed, 25 insertions(+), 23 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2010-01-16 20:18:14.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/main.c	2010-01-19 14:20:57.000000000 +0100
@@ -844,8 +844,9 @@ static void rx_tkip_phase1_write(struct 
 }
 
 static void b43_op_update_tkip_key(struct ieee80211_hw *hw,
-			struct ieee80211_key_conf *keyconf, const u8 *addr,
-			u32 iv32, u16 *phase1key)
+				   struct ieee80211_key_conf *keyconf,
+				   struct ieee80211_sta *sta,
+				   u32 iv32, u16 *phase1key)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev;
@@ -863,7 +864,10 @@ static void b43_op_update_tkip_key(struc
 	keymac_write(dev, index, NULL);	/* First zero out mac to avoid race */
 
 	rx_tkip_phase1_write(dev, index, iv32, phase1key);
-	keymac_write(dev, index, addr);
+	/* only pairwise TKIP keys are supported right now */
+	if (WARN_ON(!sta))
+		goto out_unlock;
+	keymac_write(dev, index, sta->addr);
 
 out_unlock:
 	mutex_unlock(&wl->mutex);
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2010-01-16 20:18:16.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn.c	2010-01-19 14:20:57.000000000 +0100
@@ -2839,14 +2839,17 @@ void iwl_config_ap(struct iwl_priv *priv
 }
 
 static void iwl_mac_update_tkip_key(struct ieee80211_hw *hw,
-			struct ieee80211_key_conf *keyconf, const u8 *addr,
+			struct ieee80211_key_conf *keyconf,
+			struct ieee80211_sta *sta,
 			u32 iv32, u16 *phase1key)
 {
 
 	struct iwl_priv *priv = hw->priv;
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
-	iwl_update_tkip_key(priv, keyconf, addr, iv32, phase1key);
+	iwl_update_tkip_key(priv, keyconf,
+			    sta ? sta->addr : iwl_bcast_addr,
+			    iv32, phase1key);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
--- wireless-testing.orig/include/net/mac80211.h	2010-01-17 15:36:27.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2010-01-19 14:20:57.000000000 +0100
@@ -1618,8 +1618,9 @@ struct ieee80211_ops {
 		       struct ieee80211_vif *vif, struct ieee80211_sta *sta,
 		       struct ieee80211_key_conf *key);
 	void (*update_tkip_key)(struct ieee80211_hw *hw,
-			struct ieee80211_key_conf *conf, const u8 *address,
-			u32 iv32, u16 *phase1key);
+				struct ieee80211_key_conf *conf,
+				struct ieee80211_sta *sta,
+				u32 iv32, u16 *phase1key);
 	int (*hw_scan)(struct ieee80211_hw *hw,
 		       struct cfg80211_scan_request *req);
 	void (*sw_scan_start)(struct ieee80211_hw *hw);
--- wireless-testing.orig/net/mac80211/driver-ops.h	2010-01-16 20:18:21.000000000 +0100
+++ wireless-testing/net/mac80211/driver-ops.h	2010-01-19 14:20:57.000000000 +0100
@@ -138,15 +138,16 @@ static inline int drv_set_key(struct iee
 
 static inline void drv_update_tkip_key(struct ieee80211_local *local,
 				       struct ieee80211_key_conf *conf,
-				       const u8 *address, u32 iv32,
+				       struct sta_info *sta, u32 iv32,
 				       u16 *phase1key)
 {
 	might_sleep();
 
 	if (local->ops->update_tkip_key)
-		local->ops->update_tkip_key(&local->hw, conf, address,
+		local->ops->update_tkip_key(&local->hw, conf,
+					    sta ? &sta->sta : NULL,
 					    iv32, phase1key);
-	trace_drv_update_tkip_key(local, conf, address, iv32);
+	trace_drv_update_tkip_key(local, conf, sta, iv32);
 }
 
 static inline int drv_hw_scan(struct ieee80211_local *local,
--- wireless-testing.orig/net/mac80211/driver-trace.h	2010-01-16 20:18:21.000000000 +0100
+++ wireless-testing/net/mac80211/driver-trace.h	2010-01-19 14:20:57.000000000 +0100
@@ -332,25 +332,25 @@ TRACE_EVENT(drv_set_key,
 TRACE_EVENT(drv_update_tkip_key,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_key_conf *conf,
-		 const u8 *address, u32 iv32),
+		 struct sta_info *sta, u32 iv32),
 
 	TP_ARGS(local, conf, address, iv32),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
-		__array(u8, addr, 6)
+		STA_ENTRY
 		__field(u32, iv32)
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
-		memcpy(__entry->addr, address, 6);
+		STA_ASSIGN;
 		__entry->iv32 = iv32;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT " addr:%pM iv32:%#x",
-		LOCAL_PR_ARG, __entry->addr, __entry->iv32
+		LOCAL_PR_FMT STA_PR_FMT " iv32:%#x",
+		LOCAL_PR_ARG,STA_PR_ARG, __entry->iv32
 	)
 );
 
--- wireless-testing.orig/net/mac80211/tkip.c	2010-01-16 20:19:10.000000000 +0100
+++ wireless-testing/net/mac80211/tkip.c	2010-01-19 14:20:57.000000000 +0100
@@ -304,14 +304,7 @@ int ieee80211_tkip_decrypt_data(struct c
 	if (key->local->ops->update_tkip_key &&
 	    key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
 	    key->u.tkip.rx[queue].state != TKIP_STATE_PHASE1_HW_UPLOADED) {
-		static const u8 bcast[ETH_ALEN] =
-		{0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-		const u8 *sta_addr = key->sta->sta.addr;
-
-		if (is_multicast_ether_addr(ra))
-			sta_addr = bcast;
-
-		drv_update_tkip_key(key->local, &key->conf, sta_addr,
+		drv_update_tkip_key(key->local, &key->conf, key->sta,
 				iv32, key->u.tkip.rx[queue].p1k);
 		key->u.tkip.rx[queue].state = TKIP_STATE_PHASE1_HW_UPLOADED;
 	}


