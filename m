Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14451 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116AbYEOF4a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 01:56:30 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 17/26] iwlwifi: clean up and bug fix for security
Date: Thu, 15 May 2008 13:54:09 +0800
Message-Id: <1210830858-3410-18-git-send-email-yi.zhu@intel.com> (sfid-20080515_081615_562555_E91C0E42)
In-Reply-To: <1210830858-3410-17-git-send-email-yi.zhu@intel.com>
References: <1210830858-3410-1-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-2-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-3-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-4-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-5-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-6-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-7-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-8-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-9-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-10-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-11-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-12-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-13-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-14-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-15-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-16-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-17-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch cleans up code in security.

1) uses the new pointer to ieee80211_key_conf passed with the tx_control.
2) resolves bug reported by Mirco Tischler (sends ADD_STA in ASYNC mode)
3) resolves bug reported by Volker Braun regarding dynamic WEP
4) drops a WEP packet which has been garbaged by firmware. This can
happen upon rekeying.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 -
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   25 +++++++---------
 drivers/net/wireless/iwlwifi/iwl-sta.h      |    3 ++
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   41 ++++++++-------------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    3 +-
 6 files changed, 29 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 8f0852d..52c7eae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2389,6 +2389,7 @@ static int iwl4965_set_decrypted_flag(struct iwl_priv *priv,
 		    RX_RES_STATUS_BAD_KEY_TTAK)
 			break;
 
+	case RX_RES_STATUS_SEC_TYPE_WEP:
 		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
 		    RX_RES_STATUS_BAD_ICV_MIC) {
 			/* bad ICV, the packet is destroyed since the
@@ -2396,7 +2397,6 @@ static int iwl4965_set_decrypted_flag(struct iwl_priv *priv,
 			IWL_DEBUG_RX("Packet destroyed\n");
 			return -1;
 		}
-	case RX_RES_STATUS_SEC_TYPE_WEP:
 	case RX_RES_STATUS_SEC_TYPE_CCMP:
 		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
 		    RX_RES_STATUS_DECRYPT_OK) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 7a54682..305491f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -442,7 +442,6 @@ struct iwl_hw_key {
 	enum ieee80211_key_alg alg;
 	int keylen;
 	u8 keyidx;
-	struct ieee80211_key_conf *conf;
 	u8 key[32];
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index c8e468f..99ee1e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -324,7 +324,7 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 	unsigned long flags;
 
 	keyconf->flags &= ~IEEE80211_KEY_FLAG_GENERATE_IV;
-	keyconf->hw_key_idx = keyconf->keyidx;
+	keyconf->hw_key_idx = HW_KEY_DEFAULT;
 	priv->stations[IWL_AP_ID].keyinfo.alg = ALG_WEP;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
@@ -354,7 +354,6 @@ static int iwl_set_wep_dynamic_key_info(struct iwl_priv *priv,
 	int ret;
 
 	keyconf->flags &= ~IEEE80211_KEY_FLAG_GENERATE_IV;
-	keyconf->hw_key_idx = keyconf->keyidx;
 
 	key_flags |= (STA_KEY_FLG_WEP | STA_KEY_FLG_MAP_KEY_MSK);
 	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
@@ -411,7 +410,6 @@ static int iwl_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
 		key_flags |= STA_KEY_MULTICAST_MSK;
 
 	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
-	keyconf->hw_key_idx = keyconf->keyidx;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 	priv->stations[sta_id].keyinfo.alg = keyconf->alg;
@@ -449,12 +447,10 @@ static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
 
 	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
-	keyconf->hw_key_idx = keyconf->keyidx;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 
 	priv->stations[sta_id].keyinfo.alg = keyconf->alg;
-	priv->stations[sta_id].keyinfo.conf = keyconf;
 	priv->stations[sta_id].keyinfo.keylen = 16;
 
 	if ((priv->stations[sta_id].sta.key.key_flags & STA_KEY_FLG_ENCRYPT_MSK)
@@ -483,7 +479,7 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 	u16 key_flags;
 	u8 keyidx;
 
-	priv->key_mapping_key = 0;
+	priv->key_mapping_key--;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 	key_flags = le16_to_cpu(priv->stations[sta_id].sta.key.key_flags);
@@ -514,31 +510,32 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 
 	IWL_DEBUG_INFO("hwcrypto: clear ucode station key info\n");
-	ret =  iwl_send_add_sta(priv, &priv->stations[sta_id].sta, 0);
+	ret =  iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(iwl_remove_dynamic_key);
 
 int iwl_set_dynamic_key(struct iwl_priv *priv,
-				struct ieee80211_key_conf *key, u8 sta_id)
+				struct ieee80211_key_conf *keyconf, u8 sta_id)
 {
 	int ret;
 
-	priv->key_mapping_key = 1;
+	priv->key_mapping_key++;
+	keyconf->hw_key_idx = HW_KEY_DYNAMIC;
 
-	switch (key->alg) {
+	switch (keyconf->alg) {
 	case ALG_CCMP:
-		ret = iwl_set_ccmp_dynamic_key_info(priv, key, sta_id);
+		ret = iwl_set_ccmp_dynamic_key_info(priv, keyconf, sta_id);
 		break;
 	case ALG_TKIP:
-		ret = iwl_set_tkip_dynamic_key_info(priv, key, sta_id);
+		ret = iwl_set_tkip_dynamic_key_info(priv, keyconf, sta_id);
 		break;
 	case ALG_WEP:
-		ret = iwl_set_wep_dynamic_key_info(priv, key, sta_id);
+		ret = iwl_set_wep_dynamic_key_info(priv, keyconf, sta_id);
 		break;
 	default:
-		IWL_ERROR("Unknown alg: %s alg = %d\n", __func__, key->alg);
+		IWL_ERROR("Unknown alg: %s alg = %d\n", __func__, keyconf->alg);
 		ret = -EINVAL;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index ee25643..b643546 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -29,6 +29,9 @@
 #ifndef __iwl_sta_h__
 #define __iwl_sta_h__
 
+#define HW_KEY_DYNAMIC 0
+#define HW_KEY_DEFAULT 1
+
 int iwl_get_free_ucode_key_index(struct iwl_priv *priv);
 int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty);
 int iwl_remove_default_wep_key(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index a37ced5..f32cdda 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -639,16 +639,12 @@ static void iwl_tx_cmd_build_hwcrypto(struct iwl_priv *priv,
 				      struct sk_buff *skb_frag,
 				      int sta_id)
 {
-	struct iwl_hw_key *keyinfo = &priv->stations[sta_id].keyinfo;
-	struct iwl_wep_key *wepkey;
-	int keyidx = 0;
+	struct ieee80211_key_conf *keyconf = ctl->hw_key;
 
-	BUG_ON(ctl->hw_key->hw_key_idx > 3);
-
-	switch (keyinfo->alg) {
+	switch (keyconf->alg) {
 	case ALG_CCMP:
 		tx_cmd->sec_ctl = TX_CMD_SEC_CCM;
-		memcpy(tx_cmd->key, keyinfo->key, keyinfo->keylen);
+		memcpy(tx_cmd->key, keyconf->key, keyconf->keylen);
 		if (ctl->flags & IEEE80211_TXCTL_AMPDU)
 			tx_cmd->tx_flags |= TX_CMD_FLG_AGG_CCMP_MSK;
 		IWL_DEBUG_TX("tx_cmd with aes hwcrypto\n");
@@ -656,39 +652,26 @@ static void iwl_tx_cmd_build_hwcrypto(struct iwl_priv *priv,
 
 	case ALG_TKIP:
 		tx_cmd->sec_ctl = TX_CMD_SEC_TKIP;
-		ieee80211_get_tkip_key(keyinfo->conf, skb_frag,
+		ieee80211_get_tkip_key(keyconf, skb_frag,
 			IEEE80211_TKIP_P2_KEY, tx_cmd->key);
 		IWL_DEBUG_TX("tx_cmd with tkip hwcrypto\n");
 		break;
 
 	case ALG_WEP:
-		wepkey = &priv->wep_keys[ctl->hw_key->hw_key_idx];
-		tx_cmd->sec_ctl = 0;
-		if (priv->default_wep_key) {
-			/* the WEP key was sent as static */
-			keyidx = ctl->hw_key->hw_key_idx;
-			memcpy(&tx_cmd->key[3], wepkey->key,
-							wepkey->key_size);
-			if (wepkey->key_size == WEP_KEY_LEN_128)
-				tx_cmd->sec_ctl |= TX_CMD_SEC_KEY128;
-		} else {
-			/* the WEP key was sent as dynamic */
-			keyidx = keyinfo->keyidx;
-			memcpy(&tx_cmd->key[3], keyinfo->key,
-							keyinfo->keylen);
-			if (keyinfo->keylen == WEP_KEY_LEN_128)
-				tx_cmd->sec_ctl |= TX_CMD_SEC_KEY128;
-		}
-
 		tx_cmd->sec_ctl |= (TX_CMD_SEC_WEP |
-			(keyidx & TX_CMD_SEC_MSK) << TX_CMD_SEC_SHIFT);
+			(keyconf->keyidx & TX_CMD_SEC_MSK) << TX_CMD_SEC_SHIFT);
+
+		if (keyconf->keylen == WEP_KEY_LEN_128)
+			tx_cmd->sec_ctl |= TX_CMD_SEC_KEY128;
+
+		memcpy(&tx_cmd->key[3], keyconf->key, keyconf->keylen);
 
 		IWL_DEBUG_TX("Configuring packet for WEP encryption "
-			     "with key %d\n", keyidx);
+			     "with key %d\n", keyconf->keyidx);
 		break;
 
 	default:
-		printk(KERN_ERR "Unknown encode alg %d\n", keyinfo->alg);
+		printk(KERN_ERR "Unknown encode alg %d\n", keyconf->alg);
 		break;
 	}
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index a532a9e..40616db 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -4951,7 +4951,8 @@ static int iwl4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		if (cmd == SET_KEY)
 			is_default_wep_key = !priv->key_mapping_key;
 		else
-			is_default_wep_key = priv->default_wep_key;
+			is_default_wep_key =
+					(key->hw_key_idx == HW_KEY_DEFAULT);
 	}
 
 	switch (cmd) {
-- 
1.5.3.6

