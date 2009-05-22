Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25549 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757529AbZEVRzR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 13:55:17 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/10] iwlcore: Add support for periodic RX interrupt
Date: Fri, 22 May 2009 11:01:52 -0700
Message-Id: <1243015315-13848-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1243015315-13848-7-git-send-email-reinette.chatre@intel.com>
References: <1243015315-13848-1-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-2-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-3-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-4-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-5-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-6-git-send-email-reinette.chatre@intel.com>
 <1243015315-13848-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

Periodic RX interrupt needed with ICT interrupt to prevent RX race.
Sending RX interrupt require many steps to be done in the
the device:
 1- write interrupt to current index in ICT table.
 2- dma RX frame.
 3- update RX shared data to indicate last write index.
 4- send interrupt.
This could lead to RX race, driver could receive RX interrupt
but the shared data changes does not reflect that.
this could lead to RX race, RX periodic will solve this race

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   40 ++++++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-core.c     |    8 +++--
 drivers/net/wireless/iwlwifi/iwl-csr.h      |    5 +++-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    5 ++-
 5 files changed, 46 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index be1058b..889574d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1107,9 +1107,9 @@ static void iwl_irq_tasklet_legacy(struct iwl_priv *priv)
 		priv->isr_stats.unhandled++;
 	}
 
-	if (inta & ~CSR_INI_SET_MASK) {
+	if (inta & ~(priv->inta_mask)) {
 		IWL_WARN(priv, "Disabled INTA bits 0x%08x were pending\n",
-			 inta & ~CSR_INI_SET_MASK);
+			 inta & ~priv->inta_mask);
 		IWL_WARN(priv, "   with FH_INT = 0x%08x\n", inta_fh);
 	}
 
@@ -1260,12 +1260,37 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	/* All uCode command responses, including Tx command responses,
 	 * Rx "responses" (frame-received notification), and other
 	 * notifications from uCode come through here*/
-	if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX)) {
+	if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX |
+			CSR_INT_BIT_RX_PERIODIC)) {
 		IWL_DEBUG_ISR(priv, "Rx interrupt\n");
-		iwl_write32(priv, CSR_FH_INT_STATUS, CSR49_FH_INT_RX_MASK);
+		if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX)) {
+			handled |= (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX);
+			iwl_write32(priv, CSR_FH_INT_STATUS,
+					CSR49_FH_INT_RX_MASK);
+		}
+		if (inta & CSR_INT_BIT_RX_PERIODIC) {
+			handled |= CSR_INT_BIT_RX_PERIODIC;
+			iwl_write32(priv, CSR_INT, CSR_INT_BIT_RX_PERIODIC);
+		}
+		/* Sending RX interrupt require many steps to be done in the
+		 * the device:
+		 * 1- write interrupt to current index in ICT table.
+		 * 2- dma RX frame.
+		 * 3- update RX shared data to indicate last write index.
+		 * 4- send interrupt.
+		 * This could lead to RX race, driver could receive RX interrupt
+		 * but the shared data changes does not reflect this.
+		 * this could lead to RX race, RX periodic will solve this race
+		 */
+		iwl_write32(priv, CSR_INT_PERIODIC_REG,
+			    CSR_INT_PERIODIC_DIS);
 		iwl_rx_handle(priv);
+		/* Only set RX periodic if real RX is received. */
+		if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX))
+			iwl_write32(priv, CSR_INT_PERIODIC_REG,
+				    CSR_INT_PERIODIC_ENA);
+
 		priv->isr_stats.rx++;
-		handled |= (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX);
 	}
 
 	if (inta & CSR_INT_BIT_FH_TX) {
@@ -1283,9 +1308,9 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 		priv->isr_stats.unhandled++;
 	}
 
-	if (inta & ~CSR_INI_SET_MASK) {
+	if (inta & ~(priv->inta_mask)) {
 		IWL_WARN(priv, "Disabled INTA bits 0x%08x were pending\n",
-			 inta & ~CSR_INI_SET_MASK);
+			 inta & ~priv->inta_mask);
 	}
 
 
@@ -2808,6 +2833,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	IWL_DEBUG_INFO(priv, "*** LOAD DRIVER ***\n");
 	priv->cfg = cfg;
 	priv->pci_dev = pdev;
+	priv->inta_mask = CSR_INI_SET_MASK;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	priv->debug_level = priv->cfg->mod_params->debug;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 12f0183..e93ddb7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1500,7 +1500,7 @@ void iwl_enable_interrupts(struct iwl_priv *priv)
 {
 	IWL_DEBUG_ISR(priv, "Enabling interrupts\n");
 	set_bit(STATUS_INT_ENABLED, &priv->status);
-	iwl_write32(priv, CSR_INT_MASK, CSR_INI_SET_MASK);
+	iwl_write32(priv, CSR_INT_MASK, priv->inta_mask);
 }
 EXPORT_SYMBOL(iwl_enable_interrupts);
 
@@ -1554,6 +1554,8 @@ int iwl_alloc_isr_ict(struct iwl_priv *priv)
 	memset(priv->ict_tbl_vir,0, (sizeof(u32) * ICT_COUNT) + PAGE_SIZE);
 	priv->ict_index = 0;
 
+	/* add periodic RX interrupt */
+	priv->inta_mask |= CSR_INT_BIT_RX_PERIODIC;
 	return 0;
 }
 EXPORT_SYMBOL(iwl_alloc_isr_ict);
@@ -1586,7 +1588,7 @@ int iwl_reset_ict(struct iwl_priv *priv)
 	iwl_write32(priv, CSR_DRAM_INT_TBL_REG, val);
 	priv->use_ict = true;
 	priv->ict_index = 0;
-	iwl_write32(priv, CSR_INT, CSR_INI_SET_MASK);
+	iwl_write32(priv, CSR_INT, priv->inta_mask);
 	iwl_enable_interrupts(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -1668,7 +1670,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	IWL_DEBUG_ISR(priv, "ISR inta 0x%08x, enabled 0x%08x ict 0x%08x\n",
 			inta, inta_mask, val);
 
-	inta &= CSR_INI_SET_MASK;
+	inta &= priv->inta_mask;
 	priv->inta |= inta;
 
 	/* iwl_irq_tasklet() will service interrupts and re-enable them */
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 34c123e..e2fafb8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -100,6 +100,7 @@
 #define CSR_DRAM_INT_TBL_REG	(CSR_BASE+0x0A0)
 #define CSR_GIO_CHICKEN_BITS    (CSR_BASE+0x100)
 
+#define CSR_INT_PERIODIC_REG	(CSR_BASE+0x005)
 /* Analog phase-lock-loop configuration  */
 #define CSR_ANA_PLL_CFG         (CSR_BASE+0x20c)
 /*
@@ -129,12 +130,14 @@
 #define CSR_HW_IF_CONFIG_REG_BIT_ME_OWN			(0x02000000)
 #define CSR_HW_IF_CONFIG_REG_BIT_WAKE_ME		(0x08000000)
 
+#define CSR_INT_PERIODIC_DIS			(0x00)
+#define CSR_INT_PERIODIC_ENA			(0xFF)
 
 /* interrupt flags in INTA, set by uCode or hardware (e.g. dma),
  * acknowledged (reset) by host writing "1" to flagged bits. */
 #define CSR_INT_BIT_FH_RX        (1 << 31) /* Rx DMA, cmd responses, FH_INT[17:16] */
 #define CSR_INT_BIT_HW_ERR       (1 << 29) /* DMA hardware error FH_INT[31] */
-#define CSR_INT_BIT_DNLD         (1 << 28) /* uCode Download */
+#define CSR_INT_BIT_RX_PERIODIC	 (1 << 28) /* Rx periodic */
 #define CSR_INT_BIT_FH_TX        (1 << 27) /* Tx DMA FH_INT[1:0] */
 #define CSR_INT_BIT_SCD          (1 << 26) /* TXQ pointer advanced */
 #define CSR_INT_BIT_SW_ERR       (1 << 25) /* uCode error */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 770cd1b..f9a3fd6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1058,6 +1058,7 @@ struct iwl_priv {
 	u32 inta;
 	bool use_ict;
 
+	u32 inta_mask;
 	/* Current association information needed to configure the
 	 * hardware */
 	u16 assoc_id;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index f0256bc..5c10b87 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1944,9 +1944,9 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 		priv->isr_stats.unhandled++;
 	}
 
-	if (inta & ~CSR_INI_SET_MASK) {
+	if (inta & ~priv->inta_mask) {
 		IWL_WARN(priv, "Disabled INTA bits 0x%08x were pending\n",
-			 inta & ~CSR_INI_SET_MASK);
+			 inta & ~priv->inta_mask);
 		IWL_WARN(priv, "   with FH_INT = 0x%08x\n", inta_fh);
 	}
 
@@ -4186,6 +4186,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	IWL_DEBUG_INFO(priv, "*** LOAD DRIVER ***\n");
 	priv->cfg = cfg;
 	priv->pci_dev = pdev;
+	priv->inta_mask = CSR_INI_SET_MASK;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	priv->debug_level = iwl3945_mod_params.debug;
-- 
1.5.6.3

