Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12449 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbYFLBty (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 21:49:54 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 19/29] iwlwifi: add bad length check for WEP keys
Date: Thu, 12 Jun 2008 09:47:09 +0800
Message-Id: <1213235239-2954-20-git-send-email-yi.zhu@intel.com> (sfid-20080612_041915_934747_E9A0814B)
In-Reply-To: <1213235239-2954-19-git-send-email-yi.zhu@intel.com>
References: <1213235239-2954-1-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-2-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-3-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-4-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-5-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-6-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-7-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-8-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-9-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-10-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-11-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-12-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-13-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-14-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-15-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-16-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-17-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-18-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-19-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch adds a check for bad length in set key flow. This solves the
Oops reported by Thomas Backlund, Joonwoo Park and Ian Schram.
It also adds some debug printing that can be useful.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    1 +
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   18 +++++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index a093f5b..b58f796 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1002,6 +1002,7 @@ struct iwl_wep_cmd {
 #define WEP_KEY_WEP_TYPE 1
 #define WEP_KEYS_MAX 4
 #define WEP_INVALID_OFFSET 0xff
+#define WEP_KEY_LEN_64 5
 #define WEP_KEY_LEN_128 13
 
 /******************************************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index b3caed4..3e257cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -488,6 +488,8 @@ int iwl_remove_default_wep_key(struct iwl_priv *priv,
 	priv->default_wep_key--;
 	memset(&priv->wep_keys[keyconf->keyidx], 0, sizeof(priv->wep_keys[0]));
 	ret = iwl_send_static_wepkey_cmd(priv, 1);
+	IWL_DEBUG_WEP("Remove default WEP key: idx=%d ret=%d\n",
+		      keyconf->keyidx, ret);
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 	return ret;
@@ -500,6 +502,12 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 	int ret;
 	unsigned long flags;
 
+	if (keyconf->keylen != WEP_KEY_LEN_128 &&
+	    keyconf->keylen != WEP_KEY_LEN_64) {
+		IWL_DEBUG_WEP("Bad WEP key length %d\n", keyconf->keylen);
+		return -EINVAL;
+	}
+
 	keyconf->flags &= ~IEEE80211_KEY_FLAG_GENERATE_IV;
 	keyconf->hw_key_idx = HW_KEY_DEFAULT;
 	priv->stations[IWL_AP_ID].keyinfo.alg = ALG_WEP;
@@ -516,6 +524,8 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 							keyconf->keylen);
 
 	ret = iwl_send_static_wepkey_cmd(priv, 0);
+	IWL_DEBUG_WEP("Set default WEP key: len=%d idx=%d ret=%d\n",
+		keyconf->keylen, keyconf->keyidx, ret);
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 	return ret;
@@ -662,6 +672,9 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 	key_flags = le16_to_cpu(priv->stations[sta_id].sta.key.key_flags);
 	keyidx = (key_flags >> STA_KEY_FLG_KEYID_POS) & 0x3;
 
+	IWL_DEBUG_WEP("Remove dynamic key: idx=%d sta=%d\n",
+		      keyconf->keyidx, sta_id);
+
 	if (keyconf->keyidx != keyidx) {
 		/* We need to remove a key with index different that the one
 		 * in the uCode. This means that the key we need to remove has
@@ -686,7 +699,6 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 
-	IWL_DEBUG_INFO("hwcrypto: clear ucode station key info\n");
 	ret =  iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 	return ret;
@@ -716,6 +728,10 @@ int iwl_set_dynamic_key(struct iwl_priv *priv,
 		ret = -EINVAL;
 	}
 
+	IWL_DEBUG_WEP("Set dynamic key: alg= %d len=%d idx=%d sta=%d ret=%d\n",
+		      keyconf->alg, keyconf->keylen, keyconf->keyidx,
+		      sta_id, ret);
+
 	return ret;
 }
 EXPORT_SYMBOL(iwl_set_dynamic_key);
-- 
1.5.3.6

