Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17848 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbYDOEQS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 00:16:18 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 05/12] iwlwifi: add 1X HW WEP support
Date: Mon, 14 Apr 2008 21:16:07 -0700
Message-Id: <1208232974-3828-6-git-send-email-reinette.chatre@intel.com> (sfid-20080415_051626_453124_B7F8392A)
In-Reply-To: <1208232974-3828-5-git-send-email-reinette.chatre@intel.com>
References: <1208232974-3828-1-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-2-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-3-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-4-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch adds support for HW encryption/decryption in 1X WEP.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   47 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-sta.h      |    3 ++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    9 ++++-
 4 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 93df29e..23ab523 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -461,6 +461,7 @@ struct iwl4965_tid_data {
 struct iwl4965_hw_key {
 	enum ieee80211_key_alg alg;
 	int keylen;
+	u8 keyidx;
 	struct ieee80211_key_conf *conf;
 	u8 key[32];
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index a48e228..cb96419 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -35,6 +35,7 @@
 #include "iwl-sta.h"
 #include "iwl-io.h"
 #include "iwl-helpers.h"
+#include "iwl-4965.h"
 
 int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty)
 {
@@ -117,3 +118,49 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 	return ret;
 }
 
+int iwl_set_wep_dynamic_key_info(struct iwl_priv *priv,
+				struct ieee80211_key_conf *keyconf,
+				u8 sta_id)
+{
+	unsigned long flags;
+	__le16 key_flags = 0;
+	int ret;
+
+	keyconf->flags &= ~IEEE80211_KEY_FLAG_GENERATE_IV;
+	keyconf->hw_key_idx = keyconf->keyidx;
+
+	key_flags |= (STA_KEY_FLG_WEP | STA_KEY_FLG_MAP_KEY_MSK);
+	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
+	key_flags &= ~STA_KEY_FLG_INVALID;
+
+	if (keyconf->keylen == WEP_KEY_LEN_128)
+		key_flags |= STA_KEY_FLG_KEY_SIZE_MSK;
+
+	if (sta_id == priv->hw_setting.bcast_sta_id)
+		key_flags |= STA_KEY_MULTICAST_MSK;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+
+	priv->stations[sta_id].keyinfo.alg = keyconf->alg;
+	priv->stations[sta_id].keyinfo.keylen = keyconf->keylen;
+	priv->stations[sta_id].keyinfo.keyidx = keyconf->keyidx;
+
+	memcpy(priv->stations[sta_id].keyinfo.key,
+				keyconf->key, keyconf->keylen);
+
+	memcpy(&priv->stations[sta_id].sta.key.key[3],
+				keyconf->key, keyconf->keylen);
+
+	priv->stations[sta_id].sta.key.key_offset = sta_id % 8; /* FIXME */
+	priv->stations[sta_id].sta.key.key_flags = key_flags;
+
+	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+
+	ret = iwl4965_send_add_station(priv,
+		&priv->stations[sta_id].sta, CMD_ASYNC);
+
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	return ret;
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 50e9f14..78e0254 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -42,5 +42,8 @@ int iwl_remove_default_wep_key(struct iwl_priv *priv,
 				struct ieee80211_key_conf *key);
 int iwl_set_default_wep_key(struct iwl_priv *priv,
 				struct ieee80211_key_conf *key);
+int iwl_set_wep_dynamic_key_info(struct iwl_priv *priv,
+				struct ieee80211_key_conf *keyconf,
+				u8 sta_id);
 
 #endif /* __iwl_sta_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index dfd2b75..37ab1c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1214,7 +1214,7 @@ static int iwl4965_set_dynamic_key(struct iwl_priv *priv,
 		ret = iwl4965_set_tkip_dynamic_key_info(priv, key, sta_id);
 		break;
 	case ALG_WEP:
-		ret = -EOPNOTSUPP;
+		ret = iwl_set_wep_dynamic_key_info(priv, key, sta_id);
 		break;
 	default:
 		IWL_ERROR("Unknown alg: %s alg = %d\n", __func__, key->alg);
@@ -2138,7 +2138,12 @@ static void iwl4965_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
 			if (wepkey->key_size == WEP_KEY_LEN_128)
 				cmd->cmd.tx.sec_ctl |= TX_CMD_SEC_KEY128;
 		} else {
-			IWL_ERROR("No support for WEP key mappings key\n");
+			/* the WEP key was sent as dynamic */
+			keyidx = keyinfo->keyidx;
+			memcpy(&cmd->cmd.tx.key[3], keyinfo->key,
+							keyinfo->keylen);
+			if (keyinfo->keylen == WEP_KEY_LEN_128)
+				cmd->cmd.tx.sec_ctl |= TX_CMD_SEC_KEY128;
 		}
 
 		cmd->cmd.tx.sec_ctl |= (TX_CMD_SEC_WEP |
-- 
1.5.3.4

