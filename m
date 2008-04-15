Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17848 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbYDOEQR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 00:16:17 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 06/12] iwlwifi: maintain uCode key table state
Date: Mon, 14 Apr 2008 21:16:08 -0700
Message-Id: <1208232974-3828-7-git-send-email-reinette.chatre@intel.com> (sfid-20080415_051623_873201_EB401E19)
In-Reply-To: <1208232974-3828-6-git-send-email-reinette.chatre@intel.com>
References: <1208232974-3828-1-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-2-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-3-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-4-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-5-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch fix book keeping of key table in the driver
to be synchronized with uCode

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   28 ++++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-sta.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   10 ++++++--
 4 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 23ab523..daf157a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -1116,6 +1116,7 @@ struct iwl_priv {
 	struct iwl_wep_key wep_keys[WEP_KEYS_MAX];
 	u8 default_wep_key;
 	u8 key_mapping_key;
+	unsigned long ucode_key_table;
 
 	/* Indication if ieee80211_ops->open has been called */
 	u8 is_open;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index cb96419..41238f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -36,6 +36,18 @@
 #include "iwl-io.h"
 #include "iwl-helpers.h"
 #include "iwl-4965.h"
+#include "iwl-sta.h"
+
+int iwl_get_free_ucode_key_index(struct iwl_priv *priv)
+{
+	int i;
+
+	for (i = 0; i < STA_KEY_MAX_NUM; i++)
+		if (test_and_set_bit(i, &priv->ucode_key_table))
+			return i;
+
+	return -1;
+}
 
 int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty)
 {
@@ -81,14 +93,19 @@ int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty)
 }
 
 int iwl_remove_default_wep_key(struct iwl_priv *priv,
-			       struct ieee80211_key_conf *key)
+			       struct ieee80211_key_conf *keyconf)
 {
 	int ret;
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
+
+	if (!test_and_clear_bit(keyconf->keyidx, &priv->ucode_key_table))
+		IWL_ERROR("index %d not used in uCode key table.\n",
+			  keyconf->keyidx);
+
 	priv->default_wep_key--;
-	memset(&priv->wep_keys[key->keyidx], 0, sizeof(priv->wep_keys[0]));
+	memset(&priv->wep_keys[keyconf->keyidx], 0, sizeof(priv->wep_keys[0]));
 	ret = iwl_send_static_wepkey_cmd(priv, 1);
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
@@ -108,6 +125,10 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 	spin_lock_irqsave(&priv->sta_lock, flags);
 	priv->default_wep_key++;
 
+	if (test_and_set_bit(keyconf->keyidx, &priv->ucode_key_table))
+		IWL_ERROR("index %d already used in uCode key table.\n",
+			keyconf->keyidx);
+
 	priv->wep_keys[keyconf->keyidx].key_size = keyconf->keylen;
 	memcpy(&priv->wep_keys[keyconf->keyidx].key, &keyconf->key,
 							keyconf->keylen);
@@ -151,7 +172,8 @@ int iwl_set_wep_dynamic_key_info(struct iwl_priv *priv,
 	memcpy(&priv->stations[sta_id].sta.key.key[3],
 				keyconf->key, keyconf->keylen);
 
-	priv->stations[sta_id].sta.key.key_offset = sta_id % 8; /* FIXME */
+	priv->stations[sta_id].sta.key.key_offset =
+				 iwl_get_free_ucode_key_index(priv);
 	priv->stations[sta_id].sta.key.key_flags = key_flags;
 
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 78e0254..3f1b205 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -37,6 +37,7 @@
 #include "iwl-io.h"
 #include "iwl-helpers.h"
 
+int iwl_get_free_ucode_key_index(struct iwl_priv *priv);
 int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty);
 int iwl_remove_default_wep_key(struct iwl_priv *priv,
 				struct ieee80211_key_conf *key);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 37ab1c5..da01896 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1140,8 +1140,8 @@ static int iwl4965_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
 	memcpy(priv->stations[sta_id].sta.key.key, keyconf->key,
 	       keyconf->keylen);
 
-	priv->stations[sta_id].sta.key.key_offset
-			= (sta_id % STA_KEY_MAX_NUM);/*FIXME*/
+	priv->stations[sta_id].sta.key.key_offset =
+				iwl_get_free_ucode_key_index(priv);
 	priv->stations[sta_id].sta.key.key_flags = key_flags;
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
@@ -1187,6 +1187,10 @@ static int iwl4965_clear_sta_key_info(struct iwl_priv *priv, u8 sta_id)
 	priv->key_mapping_key = 0;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
+	if (!test_and_clear_bit(priv->stations[sta_id].sta.key.key_offset,
+		&priv->ucode_key_table))
+		IWL_ERROR("index %d not used in uCode key table.\n",
+			priv->stations[sta_id].sta.key.key_offset);
 	memset(&priv->stations[sta_id].keyinfo, 0, sizeof(struct iwl4965_hw_key));
 	memset(&priv->stations[sta_id].sta.key, 0, sizeof(struct iwl4965_keyinfo));
 	priv->stations[sta_id].sta.key.key_flags = STA_KEY_FLG_NO_ENC;
@@ -6971,7 +6975,7 @@ static void iwl4965_mac_update_tkip_key(struct ieee80211_hw *hw,
 	spin_lock_irqsave(&priv->sta_lock, flags);
 
 	priv->stations[sta_id].sta.key.key_offset =
-					(sta_id % STA_KEY_MAX_NUM);/* FIXME */
+				iwl_get_free_ucode_key_index(priv);
 	priv->stations[sta_id].sta.key.key_flags = key_flags;
 	priv->stations[sta_id].sta.key.tkip_rx_tsc_byte2 = (u8) iv32;
 
-- 
1.5.3.4

