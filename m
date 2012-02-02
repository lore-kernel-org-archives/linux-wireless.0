Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37622 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523Ab2BCAQw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 19:16:52 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/28] iwlwifi: move prepare_card_hw to start_hw
Date: Thu,  2 Feb 2012 15:09:03 -0800
Message-Id: <1328224159-18134-13-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120203_011759_872729_FA36F506)
In-Reply-To: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Kill the trans_ops->prepare_card_hw which is now useless.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c        |    6 ------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |   22 +++++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-trans.h      |    8 --------
 3 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 1c00691..5ab7f68 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1833,12 +1833,6 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	if (err)
 		goto out_free_traffic_mem;
 
-	if (iwl_trans_prepare_card_hw(trans(priv))) {
-		err = -EIO;
-		IWL_WARN(priv, "Failed, HW not ready\n");
-		goto out_free_traffic_mem;
-	}
-
 	/*****************
 	 * 4. Read EEPROM
 	 *****************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index ffbafb9..d1ab57a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -690,13 +690,14 @@ static int iwl_set_hw_ready(struct iwl_trans *trans)
 }
 
 /* Note: returns standard 0/-ERROR code */
-static int iwl_trans_pcie_prepare_card_hw(struct iwl_trans *trans)
+static int iwl_prepare_card_hw(struct iwl_trans *trans)
 {
 	int ret;
 
 	IWL_DEBUG_INFO(trans, "iwl_trans_prepare_card_hw enter\n");
 
 	ret = iwl_set_hw_ready(trans);
+	/* If the card is ready, exit 0 */
 	if (ret >= 0)
 		return 0;
 
@@ -788,7 +789,7 @@ static int iwl_trans_pcie_start_device(struct iwl_trans *trans)
 	trans_pcie->mcast_queue[IWL_RXON_CTX_PAN] = IWL_IPAN_MCAST_QUEUE;
 
 	if ((hw_params(trans).sku & EEPROM_SKU_CAP_AMT_ENABLE) &&
-	     iwl_trans_pcie_prepare_card_hw(trans)) {
+	     iwl_prepare_card_hw(trans)) {
 		IWL_WARN(trans, "Exit HW not ready\n");
 		return -EIO;
 	}
@@ -1254,16 +1255,24 @@ static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 		if (err) {
 			IWL_ERR(trans, "Error allocating IRQ %d\n",
 				trans->irq);
-			iwl_free_isr_ict(trans);
-			tasklet_kill(&trans_pcie->irq_tasklet);
-			return err;
+			goto error;
 		}
 
 		INIT_WORK(&trans_pcie->rx_replenish, iwl_bg_rx_replenish);
 		trans_pcie->irq_requested = true;
 	}
 
-	return 0;
+	err = iwl_prepare_card_hw(trans);
+	if (err) {
+		IWL_ERR(trans, "Error while preparing HW: %d", err);
+		goto error;
+	}
+	return err;
+
+error:
+	iwl_free_isr_ict(trans);
+	tasklet_kill(&trans_pcie->irq_tasklet);
+	return err;
 }
 
 static int iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
@@ -1931,7 +1940,6 @@ const struct iwl_trans_ops trans_ops_pcie = {
 	.start_hw = iwl_trans_pcie_start_hw,
 	.fw_alive = iwl_trans_pcie_fw_alive,
 	.start_device = iwl_trans_pcie_start_device,
-	.prepare_card_hw = iwl_trans_pcie_prepare_card_hw,
 	.stop_device = iwl_trans_pcie_stop_device,
 
 	.wake_any_queue = iwl_trans_pcie_wake_any_queue,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index ddc3a06..55b5dc3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -136,8 +136,6 @@ struct iwl_host_cmd {
  * @start_hw: starts the HW- from that point on, the HW can send interrupts
  * @start_device: allocates and inits all the resources for the transport
  *                layer.
- * @prepare_card_hw: claim the ownership on the HW. Will be called during
- *                   probe.
  * @fw_alive: called when the fw sends alive notification
  * @wake_any_queue: wake all the queues of a specfic context IWL_RXON_CTX_*
  * @stop_device:stops the whole device (embedded CPU put to reset)
@@ -167,7 +165,6 @@ struct iwl_trans_ops {
 	int (*start_hw)(struct iwl_trans *iwl_trans);
 	int (*start_device)(struct iwl_trans *trans);
 	void (*fw_alive)(struct iwl_trans *trans);
-	int (*prepare_card_hw)(struct iwl_trans *trans);
 	void (*stop_device)(struct iwl_trans *trans);
 
 	void (*wake_any_queue)(struct iwl_trans *trans,
@@ -284,11 +281,6 @@ static inline int iwl_trans_start_device(struct iwl_trans *trans)
 	return trans->ops->start_device(trans);
 }
 
-static inline int iwl_trans_prepare_card_hw(struct iwl_trans *trans)
-{
-	return trans->ops->prepare_card_hw(trans);
-}
-
 static inline void iwl_trans_stop_device(struct iwl_trans *trans)
 {
 	trans->ops->stop_device(trans);
-- 
1.7.0.4

