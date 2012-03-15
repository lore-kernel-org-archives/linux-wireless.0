Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21182 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161448Ab2COU2F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 16:28:05 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/26] iwlwifi: move valid_contexts to priv
Date: Thu, 15 Mar 2012 13:26:53 -0700
Message-Id: <1331843226-29860-14-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120315_212818_045256_91B48CED)
In-Reply-To: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

No other component is accessing it any more,
so it can move to the correct place in priv.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-shared.h   |    2 --
 6 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 53b9a11..d07e0d2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -228,7 +228,7 @@ int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
 				 IWL_SCD_BE_MSK | IWL_SCD_BK_MSK |
 				 IWL_SCD_MGMT_MSK;
 	if ((flush_control & BIT(IWL_RXON_CTX_PAN)) &&
-	    (priv->shrd->valid_contexts != BIT(IWL_RXON_CTX_BSS)))
+	    (priv->valid_contexts != BIT(IWL_RXON_CTX_BSS)))
 		flush_cmd.fifo_control |= IWL_PAN_SCD_VO_MSK |
 				IWL_PAN_SCD_VI_MSK | IWL_PAN_SCD_BE_MSK |
 				IWL_PAN_SCD_BK_MSK | IWL_PAN_SCD_MGMT_MSK |
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 9494d75..0a6b014 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -312,7 +312,7 @@ int iwlagn_set_pan_params(struct iwl_priv *priv)
 	int slot0 = 300, slot1 = 0;
 	int ret;
 
-	if (priv->shrd->valid_contexts == BIT(IWL_RXON_CTX_BSS))
+	if (priv->valid_contexts == BIT(IWL_RXON_CTX_BSS))
 		return 0;
 
 	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c9079af..fa18968 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -583,9 +583,9 @@ static void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags)
 	 * The default context is always valid,
 	 * the PAN context depends on uCode.
 	 */
-	priv->shrd->valid_contexts = BIT(IWL_RXON_CTX_BSS);
+	priv->valid_contexts = BIT(IWL_RXON_CTX_BSS);
 	if (ucode_flags & IWL_UCODE_TLV_FLAGS_PAN)
-		priv->shrd->valid_contexts |= BIT(IWL_RXON_CTX_PAN);
+		priv->valid_contexts |= BIT(IWL_RXON_CTX_PAN);
 
 	for (i = 0; i < NUM_IWL_RXON_CTX; i++)
 		priv->contexts[i].ctxid = i;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 297508d..6178b99 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -739,6 +739,7 @@ struct iwl_priv {
 	struct workqueue_struct *workqueue;
 
 	enum ieee80211_band band;
+	u8 valid_contexts;
 
 	void (*pre_rx_handler)(struct iwl_priv *priv,
 			       struct iwl_rx_cmd_buffer *rxb);
@@ -1006,7 +1007,7 @@ iwl_rxon_ctx_from_vif(struct ieee80211_vif *vif)
 #define for_each_context(priv, ctx)				\
 	for (ctx = &priv->contexts[IWL_RXON_CTX_BSS];		\
 	     ctx < &priv->contexts[NUM_IWL_RXON_CTX]; ctx++)	\
-		if (priv->shrd->valid_contexts & BIT(ctx->ctxid))
+		if (priv->valid_contexts & BIT(ctx->ctxid))
 
 static inline int iwl_is_associated_ctx(struct iwl_rxon_context *ctx)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 1bd021a..b0c40c8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -1006,7 +1006,7 @@ static int iwlagn_mac_remain_on_channel(struct ieee80211_hw *hw,
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_PAN];
 	int err = 0;
 
-	if (!(priv->shrd->valid_contexts & BIT(IWL_RXON_CTX_PAN)))
+	if (!(priv->valid_contexts & BIT(IWL_RXON_CTX_PAN)))
 		return -EOPNOTSUPP;
 
 	if (!(ctx->interface_modes & BIT(NL80211_IFTYPE_P2P_CLIENT)))
@@ -1094,7 +1094,7 @@ static int iwlagn_mac_cancel_remain_on_channel(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
-	if (!(priv->shrd->valid_contexts & BIT(IWL_RXON_CTX_PAN)))
+	if (!(priv->valid_contexts & BIT(IWL_RXON_CTX_PAN)))
 		return -EOPNOTSUPP;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index e4f619c..c19c096 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -338,7 +338,6 @@ struct iwl_cfg {
  *
  * @status: STATUS_*
  * @wowlan: are we running wowlan uCode
- * @valid_contexts: microcode/device supports multiple contexts
  * @bus: pointer to the bus layer data
  * @cfg: see struct iwl_cfg
  * @priv: pointer to the upper layer data
@@ -352,7 +351,6 @@ struct iwl_cfg {
  */
 struct iwl_shared {
 	unsigned long status;
-	u8 valid_contexts;
 
 	const struct iwl_cfg *cfg;
 	struct iwl_trans *trans;
-- 
1.7.0.4

