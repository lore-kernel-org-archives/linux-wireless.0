Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60197 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab0AUKkz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 05:40:55 -0500
Subject: [PATCH v3] mac80211: pass vif and station to update_tkip_key
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1263907302.12555.27.camel@johannes.local>
References: <1263907302.12555.27.camel@johannes.local>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jan 2010 11:40:47 +0100
Message-ID: <1264070448.11396.37.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a TKIP key is updated, we should pass the station
pointer instead of just the address, since drivers can
use that to store their own data. We also need to pass
the virtual interface pointer.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
This replaces my earlier patch, I realised that I need the virtual
interface pointer as well.

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 9c5c7c9..6fc1027 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -844,8 +844,10 @@ static void rx_tkip_phase1_write(struct b43_wldev *dev, u8 index, u32 iv32,
 }
 
 static void b43_op_update_tkip_key(struct ieee80211_hw *hw,
-			struct ieee80211_key_conf *keyconf, const u8 *addr,
-			u32 iv32, u16 *phase1key)
+				   struct ieee80211_vif *vif,
+				   struct ieee80211_key_conf *keyconf,
+				   struct ieee80211_sta *sta,
+				   u32 iv32, u16 *phase1key)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev;
@@ -863,7 +865,10 @@ static void b43_op_update_tkip_key(struct ieee80211_hw *hw,
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
index 417fa9b..96254fc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2833,14 +2833,18 @@ void iwl_config_ap(struct iwl_priv *priv)
 }
 
 static void iwl_mac_update_tkip_key(struct ieee80211_hw *hw,
-			struct ieee80211_key_conf *keyconf, const u8 *addr,
-			u32 iv32, u16 *phase1key)
+				    struct ieee80211_vif *vif,
+				    struct ieee80211_key_conf *keyconf,
+				    struct ieee80211_sta *sta,
+				    u32 iv32, u16 *phase1key)
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
index c90047d..9445ddf 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1610,8 +1610,10 @@ struct ieee80211_ops {
 		       struct ieee80211_vif *vif, struct ieee80211_sta *sta,
 		       struct ieee80211_key_conf *key);
 	void (*update_tkip_key)(struct ieee80211_hw *hw,
-			struct ieee80211_key_conf *conf, const u8 *address,
-			u32 iv32, u16 *phase1key);
+				struct ieee80211_vif *vif,
+				struct ieee80211_key_conf *conf,
+				struct ieee80211_sta *sta,
+				u32 iv32, u16 *phase1key);
 	int (*hw_scan)(struct ieee80211_hw *hw,
 		       struct cfg80211_scan_request *req);
 	void (*sw_scan_start)(struct ieee80211_hw *hw);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index de91d39..40c6e9a 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -137,16 +137,22 @@ static inline int drv_set_key(struct ieee80211_local *local,
 }
 
 static inline void drv_update_tkip_key(struct ieee80211_local *local,
+				       struct ieee80211_sub_if_data *sdata,
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
-					    iv32, phase1key);
-	trace_drv_update_tkip_key(local, conf, address, iv32);
+		local->ops->update_tkip_key(&local->hw, &sdata->vif, conf,
+					    ista, iv32, phase1key);
+	trace_drv_update_tkip_key(local, sdata, conf, ista, iv32);
 }
 
 static inline int drv_hw_scan(struct ieee80211_local *local,
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 0ea2581..fefa6e6 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -331,26 +331,29 @@ TRACE_EVENT(drv_set_key,
 
 TRACE_EVENT(drv_update_tkip_key,
 	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
 		 struct ieee80211_key_conf *conf,
-		 const u8 *address, u32 iv32),
+		 struct ieee80211_sta *sta, u32 iv32),
 
-	TP_ARGS(local, conf, address, iv32),
+	TP_ARGS(local, sdata, conf, sta, iv32),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
-		__array(u8, addr, 6)
+		VIF_ENTRY
+		STA_ENTRY
 		__field(u32, iv32)
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
-		memcpy(__entry->addr, address, 6);
+		VIF_ASSIGN;
+		STA_ASSIGN;
 		__entry->iv32 = iv32;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT " addr:%pM iv32:%#x",
-		LOCAL_PR_ARG, __entry->addr, __entry->iv32
+		LOCAL_PR_FMT VIF_PR_FMT STA_PR_FMT " iv32:%#x",
+		LOCAL_PR_ARG,VIF_PR_ARG,STA_PR_ARG, __entry->iv32
 	)
 );
 
diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index b73454a..4cf300a 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -303,14 +303,12 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 	if (key->local->ops->update_tkip_key &&
 	    key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
 	    key->u.tkip.rx[queue].state != TKIP_STATE_PHASE1_HW_UPLOADED) {
-		static const u8 bcast[ETH_ALEN] =
-		{0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-		const u8 *sta_addr = key->sta->sta.addr;
+		struct ieee80211_sub_if_data *sdata = key->sdata;
 
-		if (is_multicast_ether_addr(ra))
-			sta_addr = bcast;
-
-		drv_update_tkip_key(key->local, &key->conf, sta_addr,
+		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+			sdata = container_of(key->sdata->bss,
+					struct ieee80211_sub_if_data, u.ap);
+		drv_update_tkip_key(key->local, sdata, &key->conf, key->sta,
 				iv32, key->u.tkip.rx[queue].p1k);
 		key->u.tkip.rx[queue].state = TKIP_STATE_PHASE1_HW_UPLOADED;
 	}


