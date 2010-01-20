Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43342 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab0ATKLv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2010 05:11:51 -0500
Subject: [PATCH v2] mac80211: pass station instead of address to
 update_tkip_key
From: Johannes Berg <johannes@sipsolutions.net>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <646765f41001190606w389a7702ja5891fa60458c24a@mail.gmail.com>
References: <1263907302.12555.27.camel@johannes.local>
	 <646765f41001190606w389a7702ja5891fa60458c24a@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 11:11:46 +0100
Message-ID: <1263982306.14538.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211: pass station instead of address to update_tkip_key

When a TKIP key is updated, we should pass the station
pointer instead of just the address, since drivers can
use that to store their own data.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
v2: * compile-test and fixes, thanks Julian

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 9c5c7c9..2a3f048 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -844,8 +844,9 @@ static void rx_tkip_phase1_write(struct b43_wldev *dev, u8 index, u32 iv32,
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
@@ -863,7 +864,10 @@ static void b43_op_update_tkip_key(struct ieee80211_hw *hw,
 	keymac_write(dev, index, NULL);	/* First zero out mac to avoid race */
 
 	rx_tkip_phase1_write(dev, index, iv32, phase1key);
-	keymac_write(dev, index, addr);
+	/* only pairwise TKIP keys are supported right now */
+	if (WARN_ON(!sta))
+		goto out_unlock;
+	keymac_write(dev, index, sta->addr);
 
 out_unlock:
 	mutex_unlock(&wl->mutex);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 417fa9b..3724fb2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2833,14 +2833,17 @@ void iwl_config_ap(struct iwl_priv *priv)
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
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c90047d..3126191 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1610,8 +1610,9 @@ struct ieee80211_ops {
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
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index de91d39..6eeb0c6 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -138,15 +138,20 @@ static inline int drv_set_key(struct ieee80211_local *local,
 
 static inline void drv_update_tkip_key(struct ieee80211_local *local,
 				       struct ieee80211_key_conf *conf,
-				       const u8 *address, u32 iv32,
+				       struct sta_info *sta, u32 iv32,
 				       u16 *phase1key)
 {
+	struct ieee80211_sta *ista = NULL;
+
 	might_sleep();
 
+	if (sta)
+		ista = &sta->sta;
+
 	if (local->ops->update_tkip_key)
-		local->ops->update_tkip_key(&local->hw, conf, address,
+		local->ops->update_tkip_key(&local->hw, conf, ista,
 					    iv32, phase1key);
-	trace_drv_update_tkip_key(local, conf, address, iv32);
+	trace_drv_update_tkip_key(local, conf, ista, iv32);
 }
 
 static inline int drv_hw_scan(struct ieee80211_local *local,
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 0ea2581..bce0924 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -332,25 +332,25 @@ TRACE_EVENT(drv_set_key,
 TRACE_EVENT(drv_update_tkip_key,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_key_conf *conf,
-		 const u8 *address, u32 iv32),
+		 struct ieee80211_sta *sta, u32 iv32),
 
-	TP_ARGS(local, conf, address, iv32),
+	TP_ARGS(local, conf, sta, iv32),
 
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
 
diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index b73454a..41e5d28 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -303,14 +303,7 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
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


