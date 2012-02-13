Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756499Ab2BMKYU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 05:24:20 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 14/24] iwlegacy: improve mac operation debuggability a bit
Date: Mon, 13 Feb 2012 11:23:21 +0100
Message-Id: <1329128611-6815-15-git-send-email-sgruszka@redhat.com> (sfid-20120213_112428_227165_44B74546)
In-Reply-To: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
References: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |   16 +++--
 drivers/net/wireless/iwlegacy/common.c   |   89 +++++++++++++++---------------
 2 files changed, 53 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 1743acc..99d7c72 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -2781,10 +2781,9 @@ il3945_mac_start(struct ieee80211_hw *hw)
 	struct il_priv *il = hw->priv;
 	int ret;
 
-	D_MAC80211("enter\n");
-
 	/* we should be verifying the device is ready to be opened */
 	mutex_lock(&il->mutex);
+	D_MAC80211("enter\n");
 
 	/* fetch ucode file from disk, alloc and copy to bus-master buffers ...
 	 * ucode filename and max sizes are card-specific. */
@@ -2940,15 +2939,19 @@ il3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	 * hardware will then not attempt to decrypt the frames.
 	 */
 	if (vif->type == NL80211_IFTYPE_ADHOC &&
-	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
+	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
+		D_MAC80211("leave - IBSS RSN\n");
 		return -EOPNOTSUPP;
+	}
 
 	static_key = !il_is_associated(il);
 
 	if (!static_key) {
 		sta_id = il_sta_id_or_broadcast(il, sta);
-		if (sta_id == IL_INVALID_STATION)
+		if (sta_id == IL_INVALID_STATION) {
+			D_MAC80211("leave - station not found\n");
 			return -EINVAL;
+		}
 	}
 
 	mutex_lock(&il->mutex);
@@ -2973,8 +2976,8 @@ il3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		ret = -EINVAL;
 	}
 
+	D_MAC80211("leave ret %d\n", ret);
 	mutex_unlock(&il->mutex);
-	D_MAC80211("leave\n");
 
 	return ret;
 }
@@ -2989,9 +2992,8 @@ il3945_mac_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	bool is_ap = vif->type == NL80211_IFTYPE_STATION;
 	u8 sta_id;
 
-	D_INFO("received request to add station %pM\n", sta->addr);
 	mutex_lock(&il->mutex);
-	D_INFO("proceeding to add station %pM\n", sta->addr);
+	D_INFO("station %pM\n", sta->addr);
 	sta_priv->common.sta_id = IL_INVALID_STATION;
 
 	ret = il_add_station_common(il, sta->addr, is_ap, sta, &sta_id);
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 21b355a..0d1a643 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -1523,12 +1523,13 @@ il_mac_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct il_priv *il = hw->priv;
 	int ret;
 
-	D_MAC80211("enter\n");
-
-	if (req->n_channels == 0)
+	if (req->n_channels == 0) {
+		IL_ERR("Can not scan on no channels.\n");
 		return -EINVAL;
+	}
 
 	mutex_lock(&il->mutex);
+	D_MAC80211("enter\n");
 
 	if (test_bit(S_SCANNING, &il->status)) {
 		D_SCAN("Scan already in progress.\n");
@@ -1543,9 +1544,8 @@ il_mac_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	ret = il_scan_initiate(il, vif);
 
-	D_MAC80211("leave\n");
-
 out_unlock:
+	D_MAC80211("leave ret %d\n", ret);
 	mutex_unlock(&il->mutex);
 
 	return ret;
@@ -2413,13 +2413,16 @@ il_mac_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct il_station_priv_common *sta_common = (void *)sta->drv_priv;
 	int ret;
 
-	D_INFO("received request to remove station %pM\n", sta->addr);
 	mutex_lock(&il->mutex);
-	D_INFO("proceeding to remove station %pM\n", sta->addr);
+	D_MAC80211("enter station %pM\n", sta->addr);
+
 	ret = il_remove_station(il, sta_common->sta_id, sta->addr);
 	if (ret)
 		IL_ERR("Error removing station %pM\n", sta->addr);
+
+	D_MAC80211("leave ret %d\n", ret);
 	mutex_unlock(&il->mutex);
+
 	return ret;
 }
 EXPORT_SYMBOL(il_mac_sta_remove);
@@ -4459,8 +4462,14 @@ int
 il_mac_tx_last_beacon(struct ieee80211_hw *hw)
 {
 	struct il_priv *il = hw->priv;
+	int ret;
 
-	return il->ibss_manager == IL_IBSS_MANAGER;
+	D_MAC80211("enter\n");
+
+	ret = (il->ibss_manager == IL_IBSS_MANAGER);
+
+	D_MAC80211("leave ret %d\n", ret);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(il_mac_tx_last_beacon);
 
@@ -4481,9 +4490,8 @@ il_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	struct il_priv *il = hw->priv;
 	int err;
 
-	D_MAC80211("enter: type %d, addr %pM\n", vif->type, vif->addr);
-
 	mutex_lock(&il->mutex);
+	D_MAC80211("enter: type %d, addr %pM\n", vif->type, vif->addr);
 
 	if (!il_is_ready_rf(il)) {
 		IL_WARN("Try to add interface when device not ready\n");
@@ -4506,9 +4514,9 @@ il_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	}
 
 out:
+	D_MAC80211("leave err %d\n", err);
 	mutex_unlock(&il->mutex);
 
-	D_MAC80211("leave\n");
 	return err;
 }
 EXPORT_SYMBOL(il_mac_add_interface);
@@ -4534,20 +4542,17 @@ il_mac_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct il_priv *il = hw->priv;
 
-	D_MAC80211("enter\n");
-
 	mutex_lock(&il->mutex);
+	D_MAC80211("enter: type %d, addr %pM\n", vif->type, vif->addr);
 
 	WARN_ON(il->vif != vif);
 	il->vif = NULL;
 
 	il_teardown_interface(il, vif, false);
-
 	memset(il->bssid, 0, ETH_ALEN);
-	mutex_unlock(&il->mutex);
 
 	D_MAC80211("leave\n");
-
+	mutex_unlock(&il->mutex);
 }
 EXPORT_SYMBOL(il_mac_remove_interface);
 
@@ -4633,10 +4638,14 @@ il_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct il_priv *il = hw->priv;
 	int err;
 
-	if (newp2p)
-		return -EOPNOTSUPP;
-
 	mutex_lock(&il->mutex);
+	D_MAC80211("enter: type %d, addr %pM newtype %d newp2p %d\n",
+		    vif->type, vif->addr, newtype, newp2p);
+
+	if (newp2p) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
 
 	if (!il->vif || !il_is_ready_rf(il)) {
 		/*
@@ -4663,7 +4672,9 @@ il_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	err = 0;
 
 out:
+	D_MAC80211("leave err %d\n", err);
 	mutex_unlock(&il->mutex);
+
 	return err;
 }
 EXPORT_SYMBOL(il_mac_change_interface);
@@ -4922,8 +4933,7 @@ il_mac_config(struct ieee80211_hw *hw, u32 changed)
 	bool ht_changed = false;
 
 	mutex_lock(&il->mutex);
-
-	D_MAC80211("enter to channel %d changed 0x%X\n", channel->hw_value,
+	D_MAC80211("enter: channel %d changed 0x%X\n", channel->hw_value,
 		   changed);
 
 	if (unlikely(test_bit(S_SCANNING, &il->status))) {
@@ -5052,8 +5062,9 @@ set_ch_out:
 		il_update_qos(il);
 
 out:
-	D_MAC80211("leave\n");
+	D_MAC80211("leave ret %d\n", ret);
 	mutex_unlock(&il->mutex);
+
 	return ret;
 }
 EXPORT_SYMBOL(il_mac_config);
@@ -5065,20 +5076,16 @@ il_mac_reset_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	unsigned long flags;
 
 	mutex_lock(&il->mutex);
-	D_MAC80211("enter\n");
+	D_MAC80211("enter: type %d, addr %pM\n", vif->type, vif->addr);
 
 	spin_lock_irqsave(&il->lock, flags);
-	memset(&il->current_ht_config, 0, sizeof(struct il_ht_config));
-	spin_unlock_irqrestore(&il->lock, flags);
 
-	spin_lock_irqsave(&il->lock, flags);
+	memset(&il->current_ht_config, 0, sizeof(struct il_ht_config));
 
 	/* new association get rid of ibss beacon skb */
 	if (il->beacon_skb)
 		dev_kfree_skb(il->beacon_skb);
-
 	il->beacon_skb = NULL;
-
 	il->timestamp = 0;
 
 	spin_unlock_irqrestore(&il->lock, flags);
@@ -5090,17 +5097,14 @@ il_mac_reset_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 		return;
 	}
 
-	/* we are restarting association process
-	 * clear RXON_FILTER_ASSOC_MSK bit
-	 */
+	/* we are restarting association process */
 	il->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	il_commit_rxon(il);
 
 	il_set_rate(il);
 
-	mutex_unlock(&il->mutex);
-
 	D_MAC80211("leave\n");
+	mutex_unlock(&il->mutex);
 }
 EXPORT_SYMBOL(il_mac_reset_tsf);
 
@@ -5226,11 +5230,11 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct il_priv *il = hw->priv;
 	int ret;
 
-	D_MAC80211("changes = 0x%X\n", changes);
-
 	mutex_lock(&il->mutex);
+	D_MAC80211("enter: changes 0x%x\n", changes);
 
 	if (!il_is_alive(il)) {
+		D_MAC80211("leave - not alive\n");
 		mutex_unlock(&il->mutex);
 		return;
 	}
@@ -5261,8 +5265,7 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		 * below/in post_associate will fail.
 		 */
 		if (il_scan_cancel_timeout(il, 100)) {
-			IL_WARN("Aborted scan still in progress after 100ms\n");
-			D_MAC80211("leaving - scan abort failed.\n");
+			D_MAC80211("leave - scan abort failed\n");
 			mutex_unlock(&il->mutex);
 			return;
 		}
@@ -5274,10 +5277,8 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 			/* currently needed in a few places */
 			memcpy(il->bssid, bss_conf->bssid, ETH_ALEN);
-		} else {
+		} else
 			il->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		}
-
 	}
 
 	/*
@@ -5364,18 +5365,16 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	}
 
 	if (changes & BSS_CHANGED_IBSS) {
-		ret =
-		    il->ops->manage_ibss_station(il, vif,
-							 bss_conf->ibss_joined);
+		ret = il->ops->manage_ibss_station(il, vif,
+						   bss_conf->ibss_joined);
 		if (ret)
 			IL_ERR("failed to %s IBSS station %pM\n",
 			       bss_conf->ibss_joined ? "add" : "remove",
 			       bss_conf->bssid);
 	}
 
-	mutex_unlock(&il->mutex);
-
 	D_MAC80211("leave\n");
+	mutex_unlock(&il->mutex);
 }
 EXPORT_SYMBOL(il_mac_bss_info_changed);
 
-- 
1.7.1

