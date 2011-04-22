Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51512 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932100Ab1DVRzO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2011 13:55:14 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/10] iwlagn: remove hw_ready variable
Date: Fri, 22 Apr 2011 10:33:18 -0700
Message-Id: <1303493598-10979-11-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1303493598-10979-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1303493598-10979-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This variable is only ever checked right after
the function that sets it, but the same function
will also return the status, so we can pass it
through instead of checking hw_ready later.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   29 +++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    1 -
 3 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 8216e5c..e202a40 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -2306,8 +2306,7 @@ int iwlagn_start_device(struct iwl_priv *priv)
 {
 	int ret;
 
-	iwl_prepare_card_hw(priv);
-	if (!priv->hw_ready) {
+	if (iwl_prepare_card_hw(priv)) {
 		IWL_WARN(priv, "Exit HW not ready\n");
 		return -EIO;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f30735b..a4f1009 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2367,9 +2367,10 @@ static void iwl_down(struct iwl_priv *priv)
 
 #define HW_READY_TIMEOUT (50)
 
+/* Note: returns poll_bit return value, which is >= 0 if success */
 static int iwl_set_hw_ready(struct iwl_priv *priv)
 {
-	int ret = 0;
+	int ret;
 
 	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 		CSR_HW_IF_CONFIG_REG_BIT_NIC_READY);
@@ -2379,25 +2380,21 @@ static int iwl_set_hw_ready(struct iwl_priv *priv)
 				CSR_HW_IF_CONFIG_REG_BIT_NIC_READY,
 				CSR_HW_IF_CONFIG_REG_BIT_NIC_READY,
 				HW_READY_TIMEOUT);
-	if (ret != -ETIMEDOUT)
-		priv->hw_ready = true;
-	else
-		priv->hw_ready = false;
 
-	IWL_DEBUG_INFO(priv, "hardware %s\n",
-		      (priv->hw_ready == 1) ? "ready" : "not ready");
+	IWL_DEBUG_INFO(priv, "hardware%s ready\n", ret < 0 ? " not" : "");
 	return ret;
 }
 
+/* Note: returns standard 0/-ERROR code */
 int iwl_prepare_card_hw(struct iwl_priv *priv)
 {
-	int ret = 0;
+	int ret;
 
 	IWL_DEBUG_INFO(priv, "iwl_prepare_card_hw enter\n");
 
 	ret = iwl_set_hw_ready(priv);
-	if (priv->hw_ready)
-		return ret;
+	if (ret >= 0)
+		return 0;
 
 	/* If HW is not ready, prepare the conditions to check again */
 	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
@@ -2407,10 +2404,13 @@ int iwl_prepare_card_hw(struct iwl_priv *priv)
 			~CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE,
 			CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE, 150000);
 
-	/* HW should be ready by now, check again. */
-	if (ret != -ETIMEDOUT)
-		iwl_set_hw_ready(priv);
+	if (ret < 0)
+		return ret;
 
+	/* HW should be ready by now, check again. */
+	ret = iwl_set_hw_ready(priv);
+	if (ret >= 0)
+		return 0;
 	return ret;
 }
 
@@ -3741,8 +3741,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * PCI Tx retries from interfering with C3 CPU state */
 	pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00);
 
-	iwl_prepare_card_hw(priv);
-	if (!priv->hw_ready) {
+	if (iwl_prepare_card_hw(priv)) {
 		IWL_WARN(priv, "Failed, HW not ready\n");
 		goto out_iounmap;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 857eb0e..197fa74 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1503,7 +1503,6 @@ struct iwl_priv {
 	struct timer_list statistics_periodic;
 	struct timer_list ucode_trace;
 	struct timer_list watchdog;
-	bool hw_ready;
 
 	struct iwl_event_log event_log;
 
-- 
1.7.0.4

