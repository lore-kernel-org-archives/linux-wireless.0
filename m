Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7986 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653Ab1IVXBS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 19:01:18 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/12] iwlagn: use kcalloc when possible for array allocation
Date: Thu, 22 Sep 2011 15:14:53 -0700
Message-Id: <1316729700-1770-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110923_010148_066944_E5C75CE2)
In-Reply-To: <1316729700-1770-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316729700-1770-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

As everybody knows kcalloc checks the multiplication is safe and
that we don't run into overflow.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c     |   12 +++++++-----
 drivers/net/wireless/iwlwifi/iwl-core.c       |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-eeprom.c     |    5 +++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |   12 ++++++------
 4 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
index 495f936..289e5d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
@@ -641,11 +641,13 @@ void iwl_tt_initialize(struct iwl_priv *priv)
 
 	if (priv->cfg->base_params->adv_thermal_throttle) {
 		IWL_DEBUG_TEMP(priv, "Advanced Thermal Throttling\n");
-		tt->restriction = kzalloc(sizeof(struct iwl_tt_restriction) *
-					 IWL_TI_STATE_MAX, GFP_KERNEL);
-		tt->transaction = kzalloc(sizeof(struct iwl_tt_trans) *
-			IWL_TI_STATE_MAX * (IWL_TI_STATE_MAX - 1),
-			GFP_KERNEL);
+		tt->restriction = kcalloc(IWL_TI_STATE_MAX,
+					  sizeof(struct iwl_tt_restriction),
+					  GFP_KERNEL);
+		tt->transaction = kcalloc(IWL_TI_STATE_MAX *
+					  (IWL_TI_STATE_MAX - 1),
+					  sizeof(struct iwl_tt_trans),
+					  GFP_KERNEL);
 		if (!tt->restriction || !tt->transaction) {
 			IWL_ERR(priv, "Fallback to Legacy Throttling\n");
 			priv->thermal_throttle.advanced_tt = false;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index cea6520..fc400bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -125,12 +125,12 @@ int iwl_init_geos(struct iwl_priv *priv)
 		return 0;
 	}
 
-	channels = kzalloc(sizeof(struct ieee80211_channel) *
-			   priv->channel_count, GFP_KERNEL);
+	channels = kcalloc(priv->channel_count,
+			   sizeof(struct ieee80211_channel), GFP_KERNEL);
 	if (!channels)
 		return -ENOMEM;
 
-	rates = kzalloc((sizeof(struct ieee80211_rate) * IWL_RATE_COUNT_LEGACY),
+	rates = kcalloc(IWL_RATE_COUNT_LEGACY, sizeof(struct ieee80211_rate),
 			GFP_KERNEL);
 	if (!rates) {
 		kfree(channels);
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 0b66941..a4e43bd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -899,8 +899,9 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 	IWL_DEBUG_EEPROM(priv, "Parsing data for %d channels.\n",
 			priv->channel_count);
 
-	priv->channel_info = kzalloc(sizeof(struct iwl_channel_info) *
-				     priv->channel_count, GFP_KERNEL);
+	priv->channel_info = kcalloc(priv->channel_count,
+				     sizeof(struct iwl_channel_info),
+				     GFP_KERNEL);
 	if (!priv->channel_info) {
 		IWL_ERR(priv, "Could not allocate channel_info\n");
 		priv->channel_count = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 781f6aa..416e992 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -304,8 +304,8 @@ static int iwl_trans_txq_alloc(struct iwl_trans *trans,
 
 	txq->q.n_window = slots_num;
 
-	txq->meta = kzalloc(sizeof(txq->meta[0]) * slots_num, GFP_KERNEL);
-	txq->cmd = kzalloc(sizeof(txq->cmd[0]) * slots_num, GFP_KERNEL);
+	txq->meta = kcalloc(slots_num, sizeof(txq->meta[0]), GFP_KERNEL);
+	txq->cmd = kcalloc(slots_num, sizeof(txq->cmd[0]), GFP_KERNEL);
 
 	if (!txq->meta || !txq->cmd)
 		goto error;
@@ -322,8 +322,8 @@ static int iwl_trans_txq_alloc(struct iwl_trans *trans,
 	/* Driver private data, only for Tx (not command) queues,
 	 * not shared with device. */
 	if (txq_id != trans->shrd->cmd_queue) {
-		txq->skbs = kzalloc(sizeof(txq->skbs[0]) *
-				   TFD_QUEUE_SIZE_MAX, GFP_KERNEL);
+		txq->skbs = kcalloc(TFD_QUEUE_SIZE_MAX, sizeof(txq->skbs[0]),
+				    GFP_KERNEL);
 		if (!txq->skbs) {
 			IWL_ERR(trans, "kmalloc for auxiliary BD "
 				  "structures failed\n");
@@ -534,8 +534,8 @@ static int iwl_trans_tx_alloc(struct iwl_trans *trans)
 		goto error;
 	}
 
-	trans_pcie->txq = kzalloc(sizeof(struct iwl_tx_queue) *
-			hw_params(trans).max_txq_num, GFP_KERNEL);
+	trans_pcie->txq = kcalloc(hw_params(trans).max_txq_num,
+				  sizeof(struct iwl_tx_queue), GFP_KERNEL);
 	if (!trans_pcie->txq) {
 		IWL_ERR(trans, "Not enough memory for txq\n");
 		ret = ENOMEM;
-- 
1.7.0.4

