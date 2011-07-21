Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32866 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab1GUP0t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:26:49 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 16/25] iwlagn: remove keyinfo cache
Date: Thu, 21 Jul 2011 07:50:19 -0700
Message-Id: <1311259828-8415-17-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110721_172725_838410_5E3B5842)
In-Reply-To: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

iwlagn keeps a copy of key stuff internally but
never actually uses it, so remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c |   22 ----------------------
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    8 --------
 2 files changed, 0 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 67b9c2b..395dee1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -234,7 +234,6 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 
 	keyconf->flags &= ~IEEE80211_KEY_FLAG_GENERATE_IV;
 	keyconf->hw_key_idx = HW_KEY_DEFAULT;
-	priv->stations[ctx->ap_sta_id].keyinfo.cipher = keyconf->cipher;
 
 	ctx->wep_keys[keyconf->keyidx].key_size = keyconf->keylen;
 	memcpy(&ctx->wep_keys[keyconf->keyidx].key, &keyconf->key,
@@ -272,13 +271,6 @@ static int iwl_set_wep_dynamic_key_info(struct iwl_priv *priv,
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 
-	priv->stations[sta_id].keyinfo.cipher = keyconf->cipher;
-	priv->stations[sta_id].keyinfo.keylen = keyconf->keylen;
-	priv->stations[sta_id].keyinfo.keyidx = keyconf->keyidx;
-
-	memcpy(priv->stations[sta_id].keyinfo.key,
-				keyconf->key, keyconf->keylen);
-
 	memcpy(&priv->stations[sta_id].sta.key.key[3],
 				keyconf->key, keyconf->keylen);
 
@@ -323,11 +315,6 @@ static int iwl_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
 	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
-	priv->stations[sta_id].keyinfo.cipher = keyconf->cipher;
-	priv->stations[sta_id].keyinfo.keylen = keyconf->keylen;
-
-	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key,
-	       keyconf->keylen);
 
 	memcpy(priv->stations[sta_id].sta.key.key, keyconf->key,
 	       keyconf->keylen);
@@ -373,9 +360,6 @@ static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 
-	priv->stations[sta_id].keyinfo.cipher = keyconf->cipher;
-	priv->stations[sta_id].keyinfo.keylen = 16;
-
 	if ((priv->stations[sta_id].sta.key.key_flags & STA_KEY_FLG_ENCRYPT_MSK)
 			== STA_KEY_FLG_NO_ENC)
 		priv->stations[sta_id].sta.key.key_offset =
@@ -388,10 +372,6 @@ static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
 
 	priv->stations[sta_id].sta.key.key_flags = key_flags;
 
-
-	/* This copy is acutally not needed: we get the key with each TX */
-	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key, 16);
-
 	memcpy(priv->stations[sta_id].sta.key.key, keyconf->key, 16);
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
@@ -477,8 +457,6 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 		&priv->ucode_key_table))
 		IWL_ERR(priv, "index %d not used in uCode key table.\n",
 			priv->stations[sta_id].sta.key.key_offset);
-	memset(&priv->stations[sta_id].keyinfo, 0,
-					sizeof(struct iwl_hw_key));
 	memset(&priv->stations[sta_id].sta.key, 0,
 					sizeof(struct iwl_keyinfo));
 	priv->stations[sta_id].sta.key.key_flags =
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 72ef50e..da90488 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -397,13 +397,6 @@ struct iwl_tid_data {
 	struct iwl_ht_agg agg;
 };
 
-struct iwl_hw_key {
-	u32 cipher;
-	int keylen;
-	u8 keyidx;
-	u8 key[32];
-};
-
 union iwl_ht_rate_supp {
 	u16 rates;
 	struct {
@@ -456,7 +449,6 @@ struct iwl_station_entry {
 	struct iwl_addsta_cmd sta;
 	struct iwl_tid_data tid[MAX_TID_COUNT];
 	u8 used, ctxid;
-	struct iwl_hw_key keyinfo;
 	struct iwl_link_quality_cmd *lq;
 };
 
-- 
1.7.0.4

