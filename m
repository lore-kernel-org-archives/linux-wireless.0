Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53534 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab1GUP0r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:26:47 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/25] iwlagn: move iwl_prepare_card_hw to the transport layer
Date: Thu, 21 Jul 2011 07:50:13 -0700
Message-Id: <1311259828-8415-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110721_172726_907273_C0B2FC96)
In-Reply-To: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This function is really related to the transport layer - move it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h   |    3 ---
 drivers/net/wireless/iwlwifi/iwl-dev.h   |    3 +++
 drivers/net/wireless/iwlwifi/iwl-trans.c |    8 +++++---
 drivers/net/wireless/iwlwifi/iwl-trans.h |    5 +++++
 5 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d0f6875..703c106 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3174,7 +3174,7 @@ int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
 	IWL_INFO(priv, "Detected %s, REV=0x%X\n",
 		priv->cfg->name, hw_rev);
 
-	if (iwl_prepare_card_hw(priv)) {
+	if (trans_prepare_card_hw(priv)) {
 		err = -EIO;
 		IWL_WARN(priv, "Failed, HW not ready\n");
 		goto out_free_traffic_mem;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index ffb6bd2..496ab99 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -122,9 +122,6 @@ static inline void iwl_set_calib_hdr(struct iwl_calib_hdr *hdr, u8 cmd)
 	hdr->data_valid = 1;
 }
 
-/* TODO: this one should be API of the transport layer */
-int iwl_prepare_card_hw(struct iwl_priv *priv);
-
 /* tx queue */
 void iwl_free_tfds_in_queue(struct iwl_priv *priv,
 			    int sta_id, int tid, int freed);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index ca15434..9a39836 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1236,6 +1236,8 @@ struct iwl_trans;
  * struct iwl_trans_ops - transport specific operations
  * @start_device: allocates and inits all the resources for the transport
  *                layer.
+ * @prepare_card_hw: claim the ownership on the HW. Will be called during
+ *                   probe.
  * @tx_start: starts and configures all the Tx fifo - usually done once the fw
  *           is alive.
  * @stop_device:stops the whole device (embedded CPU put to reset)
@@ -1259,6 +1261,7 @@ struct iwl_trans;
 struct iwl_trans_ops {
 
 	int (*start_device)(struct iwl_priv *priv);
+	int (*prepare_card_hw)(struct iwl_priv *priv);
 	void (*stop_device)(struct iwl_priv *priv);
 	void (*tx_start)(struct iwl_priv *priv);
 	void (*tx_free)(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index e9c7de9..88ab20a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -647,11 +647,11 @@ static int iwl_set_hw_ready(struct iwl_priv *priv)
 }
 
 /* Note: returns standard 0/-ERROR code */
-int iwl_prepare_card_hw(struct iwl_priv *priv)
+static int iwl_trans_prepare_card_hw(struct iwl_priv *priv)
 {
 	int ret;
 
-	IWL_DEBUG_INFO(priv, "iwl_prepare_card_hw enter\n");
+	IWL_DEBUG_INFO(priv, "iwl_trans_prepare_card_hw enter\n");
 
 	ret = iwl_set_hw_ready(priv);
 	if (ret >= 0)
@@ -682,7 +682,7 @@ static int iwl_trans_start_device(struct iwl_priv *priv)
 	priv->ucode_owner = IWL_OWNERSHIP_DRIVER;
 
 	if ((priv->cfg->sku & EEPROM_SKU_CAP_AMT_ENABLE) &&
-	     iwl_prepare_card_hw(priv)) {
+	     iwl_trans_prepare_card_hw(priv)) {
 		IWL_WARN(priv, "Exit HW not ready\n");
 		return -EIO;
 	}
@@ -1123,7 +1123,9 @@ static void iwl_trans_free(struct iwl_priv *priv)
 
 static const struct iwl_trans_ops trans_ops = {
 	.start_device = iwl_trans_start_device,
+	.prepare_card_hw = iwl_trans_prepare_card_hw,
 	.stop_device = iwl_trans_stop_device,
+
 	.tx_start = iwl_trans_tx_start,
 
 	.rx_free = iwl_trans_rx_free,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 9e801d8..fca0181 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -69,6 +69,11 @@ static inline int trans_start_device(struct iwl_priv *priv)
 	return priv->trans.ops->start_device(priv);
 }
 
+static inline int trans_prepare_card_hw(struct iwl_priv *priv)
+{
+	return priv->trans.ops->prepare_card_hw(priv);
+}
+
 static inline void trans_stop_device(struct iwl_priv *priv)
 {
 	priv->trans.ops->stop_device(priv);
-- 
1.7.0.4

