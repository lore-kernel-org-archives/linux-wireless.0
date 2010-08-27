Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:62079 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754409Ab0H0Q4v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 12:56:51 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/27] iwlwifi: move AP sta ID to context
Date: Fri, 27 Aug 2010 09:59:39 -0700
Message-Id: <1282928395-32762-12-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Each context needs to use a different AP sta
ID, so we need to move that into the context
struct instead of hardcoding it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    5 +++--
 drivers/net/wireless/iwlwifi/iwl-sta.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 +
 5 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5e1df24..a67b04b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3585,7 +3585,7 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	switch (cmd) {
 	case SET_KEY:
 		if (is_default_wep_key)
-			ret = iwl_set_default_wep_key(priv, key);
+			ret = iwl_set_default_wep_key(priv, vif_priv->ctx, key);
 		else
 			ret = iwl_set_dynamic_key(priv, vif_priv->ctx,
 						  key, sta_id);
@@ -4208,6 +4208,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv->contexts[IWL_RXON_CTX_BSS].rxon_timing_cmd = REPLY_RXON_TIMING;
 	priv->contexts[IWL_RXON_CTX_BSS].rxon_assoc_cmd = REPLY_RXON_ASSOC;
 	priv->contexts[IWL_RXON_CTX_BSS].qos_cmd = REPLY_QOS_PARAM;
+	priv->contexts[IWL_RXON_CTX_BSS].ap_sta_id = IWL_AP_ID;
 	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 1);
 
 	SET_IEEE80211_DEV(hw, &pdev->dev);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index a332ec5..d1400a0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1129,7 +1129,7 @@ struct iwl_rxon_context {
 
 	struct iwl_qos_info qos_data;
 
-	u8 bcast_sta_id;
+	u8 bcast_sta_id, ap_sta_id;
 
 	u8 rxon_cmd, rxon_assoc_cmd, rxon_timing_cmd;
 	u8 qos_cmd;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 2923562..f5500cc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -236,7 +236,7 @@ static u8 iwl_prep_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 	u16 rate;
 
 	if (is_ap)
-		sta_id = IWL_AP_ID;
+		sta_id = ctx->ap_sta_id;
 	else if (is_broadcast_ether_addr(addr))
 		sta_id = ctx->bcast_sta_id;
 	else
@@ -810,6 +810,7 @@ int iwl_remove_default_wep_key(struct iwl_priv *priv,
 EXPORT_SYMBOL(iwl_remove_default_wep_key);
 
 int iwl_set_default_wep_key(struct iwl_priv *priv,
+			    struct iwl_rxon_context *ctx,
 			    struct ieee80211_key_conf *keyconf)
 {
 	int ret;
@@ -824,7 +825,7 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 
 	keyconf->flags &= ~IEEE80211_KEY_FLAG_GENERATE_IV;
 	keyconf->hw_key_idx = HW_KEY_DEFAULT;
-	priv->stations[IWL_AP_ID].keyinfo.cipher = keyconf->cipher;
+	priv->stations[ctx->ap_sta_id].keyinfo.cipher = keyconf->cipher;
 
 	priv->wep_keys[keyconf->keyidx].key_size = keyconf->keylen;
 	memcpy(&priv->wep_keys[keyconf->keyidx].key, &keyconf->key,
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 269a3ed..b7f7006 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -46,6 +46,7 @@
 int iwl_remove_default_wep_key(struct iwl_priv *priv,
 			       struct ieee80211_key_conf *key);
 int iwl_set_default_wep_key(struct iwl_priv *priv,
+			    struct iwl_rxon_context *ctx,
 			    struct ieee80211_key_conf *key);
 int iwl_restore_default_wep_keys(struct iwl_priv *priv);
 int iwl_set_dynamic_key(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 6b56295..29d1376 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4021,6 +4021,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv->contexts[IWL_RXON_CTX_BSS].rxon_timing_cmd = REPLY_RXON_TIMING;
 	priv->contexts[IWL_RXON_CTX_BSS].rxon_assoc_cmd = REPLY_RXON_ASSOC;
 	priv->contexts[IWL_RXON_CTX_BSS].qos_cmd = REPLY_QOS_PARAM;
+	priv->contexts[IWL_RXON_CTX_BSS].ap_sta_id = IWL_AP_ID;
 
 	/*
 	 * Disabling hardware scan means that mac80211 will perform scans
-- 
1.7.0.4

