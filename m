Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49219 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584AbYDQXDm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 19:03:42 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/5] iwlwifi: HW crypto acceleration fixes
Date: Thu, 17 Apr 2008 16:03:36 -0700
Message-Id: <1208473420-16550-2-git-send-email-reinette.chatre@intel.com> (sfid-20080418_000350_323226_5193EC7E)
In-Reply-To: <1208473420-16550-1-git-send-email-reinette.chatre@intel.com>
References: <1208473420-16550-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch fixes several issues in security:

1) the uCode doesn't know about TKIP-MMIC failure, if uCode set
RX_RES_STATUS_BAD_ICV_MIC, it means ICV failure: drop the packet silently.
2) do not allocate room in the key table of the uCode is the set_key call
is a replacement of an old key
3) check the keyidx of the key in the uCode before removing it upon
disable_key call

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   53 ++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    3 --
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   53 ++++++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-sta.h      |    3 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   41 +--------------------
 5 files changed, 98 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 69a355b..ddcd1b2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2871,6 +2871,53 @@ static void iwl_update_rx_stats(struct iwl_priv *priv, u16 fc, u16 len)
 	priv->rx_stats[idx].bytes += len;
 }
 
+/*
+ * returns non-zero if packet should be dropped
+ */
+static int iwl4965_set_decrypted_flag(struct iwl_priv *priv,
+				      struct ieee80211_hdr *hdr,
+				      u32 decrypt_res,
+				      struct ieee80211_rx_status *stats)
+{
+	u16 fc = le16_to_cpu(hdr->frame_control);
+
+	if (priv->active_rxon.filter_flags & RXON_FILTER_DIS_DECRYPT_MSK)
+		return 0;
+
+	if (!(fc & IEEE80211_FCTL_PROTECTED))
+		return 0;
+
+	IWL_DEBUG_RX("decrypt_res:0x%x\n", decrypt_res);
+	switch (decrypt_res & RX_RES_STATUS_SEC_TYPE_MSK) {
+	case RX_RES_STATUS_SEC_TYPE_TKIP:
+		/* The uCode has got a bad phase 1 Key, pushes the packet.
+		 * Decryption will be done in SW. */
+		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
+		    RX_RES_STATUS_BAD_KEY_TTAK)
+			break;
+
+		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
+		    RX_RES_STATUS_BAD_ICV_MIC) {
+			/* bad ICV, the packet is destroyed since the
+			 * decryption is inplace, drop it */
+			IWL_DEBUG_RX("Packet destroyed\n");
+			return -1;
+		}
+	case RX_RES_STATUS_SEC_TYPE_WEP:
+	case RX_RES_STATUS_SEC_TYPE_CCMP:
+		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
+		    RX_RES_STATUS_DECRYPT_OK) {
+			IWL_DEBUG_RX("hw decrypt successfully!!!\n");
+			stats->flag |= RX_FLAG_DECRYPTED;
+		}
+		break;
+
+	default:
+		break;
+	}
+	return 0;
+}
+
 static u32 iwl4965_translate_rx_status(u32 decrypt_in)
 {
 	u32 decrypt_out = 0;
@@ -3000,8 +3047,10 @@ static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
 	stats->flag = 0;
 	hdr = (struct ieee80211_hdr *)rxb->skb->data;
 
-	if (!priv->cfg->mod_params->sw_crypto)
-		iwl4965_set_decrypted_flag(priv, rxb->skb, ampdu_status, stats);
+	/*  in case of HW accelerated crypto and bad decryption, drop */
+	if (!priv->cfg->mod_params->sw_crypto &&
+	    iwl4965_set_decrypted_flag(priv, hdr, ampdu_status, stats))
+		return;
 
 	if (priv->add_radiotap)
 		iwl4965_add_radiotap(priv, rxb->skb, rx_start, stats, ampdu_status);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 547c313..8672c88 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -673,9 +673,6 @@ extern unsigned int iwl4965_fill_beacon_frame(struct iwl_priv *priv,
 					const u8 *dest, int left);
 extern int iwl4965_rx_queue_update_write_ptr(struct iwl_priv *priv,
 					 struct iwl4965_rx_queue *q);
-extern void iwl4965_set_decrypted_flag(struct iwl_priv *priv, struct sk_buff *skb,
-				   u32 decrypt_res,
-				   struct ieee80211_rx_status *stats);
 extern __le16 *ieee80211_get_qos_ctrl(struct ieee80211_hdr *hdr);
 int iwl4965_init_geos(struct iwl_priv *priv);
 void iwl4965_free_geos(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index fa463ce..d39ac1c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -207,10 +207,14 @@ static int iwl_set_wep_dynamic_key_info(struct iwl_priv *priv,
 	memcpy(&priv->stations[sta_id].sta.key.key[3],
 				keyconf->key, keyconf->keylen);
 
-	priv->stations[sta_id].sta.key.key_offset =
+	if ((priv->stations[sta_id].sta.key.key_flags & STA_KEY_FLG_ENCRYPT_MSK)
+			== STA_KEY_FLG_NO_ENC)
+		priv->stations[sta_id].sta.key.key_offset =
 				 iwl_get_free_ucode_key_index(priv);
-	priv->stations[sta_id].sta.key.key_flags = key_flags;
+	/* else, we are overriding an existing key => no need to allocated room
+	 * in uCode. */
 
+	priv->stations[sta_id].sta.key.key_flags = key_flags;
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 
@@ -249,8 +253,13 @@ static int iwl_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
 	memcpy(priv->stations[sta_id].sta.key.key, keyconf->key,
 	       keyconf->keylen);
 
-	priv->stations[sta_id].sta.key.key_offset =
-				iwl_get_free_ucode_key_index(priv);
+	if ((priv->stations[sta_id].sta.key.key_flags & STA_KEY_FLG_ENCRYPT_MSK)
+			== STA_KEY_FLG_NO_ENC)
+		priv->stations[sta_id].sta.key.key_offset =
+				 iwl_get_free_ucode_key_index(priv);
+	/* else, we are overriding an existing key => no need to allocated room
+	 * in uCode. */
+
 	priv->stations[sta_id].sta.key.key_flags = key_flags;
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
@@ -278,8 +287,13 @@ static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
 	priv->stations[sta_id].keyinfo.alg = keyconf->alg;
 	priv->stations[sta_id].keyinfo.conf = keyconf;
 	priv->stations[sta_id].keyinfo.keylen = 16;
-	priv->stations[sta_id].sta.key.key_offset =
+
+	if ((priv->stations[sta_id].sta.key.key_flags & STA_KEY_FLG_ENCRYPT_MSK)
+			== STA_KEY_FLG_NO_ENC)
+		priv->stations[sta_id].sta.key.key_offset =
 				 iwl_get_free_ucode_key_index(priv);
+	/* else, we are overriding an existing key => no need to allocated room
+	 * in uCode. */
 
 	/* This copy is acutally not needed: we get the key with each TX */
 	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key, 16);
@@ -291,13 +305,31 @@ static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
 	return ret;
 }
 
-int iwl_remove_dynamic_key(struct iwl_priv *priv, u8 sta_id)
+int iwl_remove_dynamic_key(struct iwl_priv *priv,
+				struct ieee80211_key_conf *keyconf,
+				u8 sta_id)
 {
 	unsigned long flags;
+	int ret = 0;
+	u16 key_flags;
+	u8 keyidx;
 
 	priv->key_mapping_key = 0;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
+	key_flags = le16_to_cpu(priv->stations[sta_id].sta.key.key_flags);
+	keyidx = (key_flags >> STA_KEY_FLG_KEYID_POS) & 0x3;
+
+	if (keyconf->keyidx != keyidx) {
+		/* We need to remove a key with index different that the one
+		 * in the uCode. This means that the key we need to remove has
+		 * been replaced by another one with different index.
+		 * Don't do anything and return ok
+		 */
+		spin_unlock_irqrestore(&priv->sta_lock, flags);
+		return 0;
+	}
+
 	if (!test_and_clear_bit(priv->stations[sta_id].sta.key.key_offset,
 		&priv->ucode_key_table))
 		IWL_ERROR("index %d not used in uCode key table.\n",
@@ -306,13 +338,16 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv, u8 sta_id)
 					sizeof(struct iwl4965_hw_key));
 	memset(&priv->stations[sta_id].sta.key, 0,
 					sizeof(struct iwl4965_keyinfo));
-	priv->stations[sta_id].sta.key.key_flags = STA_KEY_FLG_NO_ENC;
+	priv->stations[sta_id].sta.key.key_flags =
+			STA_KEY_FLG_NO_ENC | STA_KEY_FLG_INVALID;
+	priv->stations[sta_id].sta.key.key_offset = WEP_INVALID_OFFSET;
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 	IWL_DEBUG_INFO("hwcrypto: clear ucode station key info\n");
-	return iwl4965_send_add_station(priv, &priv->stations[sta_id].sta, 0);
+	ret =  iwl4965_send_add_station(priv, &priv->stations[sta_id].sta, 0);
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	return ret;
 }
 
 int iwl_set_dynamic_key(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 44f272e..8955835 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -43,7 +43,8 @@ int iwl_remove_default_wep_key(struct iwl_priv *priv,
 				struct ieee80211_key_conf *key);
 int iwl_set_default_wep_key(struct iwl_priv *priv,
 				struct ieee80211_key_conf *key);
-int iwl_remove_dynamic_key(struct iwl_priv *priv, u8 sta_id);
 int iwl_set_dynamic_key(struct iwl_priv *priv,
 				struct ieee80211_key_conf *key, u8 sta_id);
+int iwl_remove_dynamic_key(struct iwl_priv *priv,
+				struct ieee80211_key_conf *key, u8 sta_id);
 #endif /* __iwl_sta_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 2dc4960..fe340fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2456,45 +2456,6 @@ void iwl4965_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
 	return;
 }
 
-void iwl4965_set_decrypted_flag(struct iwl_priv *priv, struct sk_buff *skb,
-			    u32 decrypt_res, struct ieee80211_rx_status *stats)
-{
-	u16 fc =
-	    le16_to_cpu(((struct ieee80211_hdr *)skb->data)->frame_control);
-
-	if (priv->active_rxon.filter_flags & RXON_FILTER_DIS_DECRYPT_MSK)
-		return;
-
-	if (!(fc & IEEE80211_FCTL_PROTECTED))
-		return;
-
-	IWL_DEBUG_RX("decrypt_res:0x%x\n", decrypt_res);
-	switch (decrypt_res & RX_RES_STATUS_SEC_TYPE_MSK) {
-	case RX_RES_STATUS_SEC_TYPE_TKIP:
-		/* The uCode has got a bad phase 1 Key, pushes the packet.
-		 * Decryption will be done in SW. */
-		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
-		    RX_RES_STATUS_BAD_KEY_TTAK)
-			break;
-
-		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
-		    RX_RES_STATUS_BAD_ICV_MIC)
-			stats->flag |= RX_FLAG_MMIC_ERROR;
-	case RX_RES_STATUS_SEC_TYPE_WEP:
-	case RX_RES_STATUS_SEC_TYPE_CCMP:
-		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
-		    RX_RES_STATUS_DECRYPT_OK) {
-			IWL_DEBUG_RX("hw decrypt successfully!!!\n");
-			stats->flag |= RX_FLAG_DECRYPTED;
-		}
-		break;
-
-	default:
-		break;
-	}
-}
-
-
 #define IWL_PACKET_RETRY_TIME HZ
 
 int iwl4965_is_duplicate_packet(struct iwl_priv *priv, struct ieee80211_hdr *header)
@@ -6874,7 +6835,7 @@ static int iwl4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		if (is_default_wep_key)
 			ret = iwl_remove_default_wep_key(priv, key);
 		else
-			ret = iwl_remove_dynamic_key(priv, sta_id);
+			ret = iwl_remove_dynamic_key(priv, key, sta_id);
 
 		IWL_DEBUG_MAC80211("disable hwcrypto key\n");
 		break;
-- 
1.5.3.4

