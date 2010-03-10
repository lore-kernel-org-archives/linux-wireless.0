Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:57656 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab0CJFWC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:22:02 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/24] iwlwifi: move ICT data to agn part of union
Date: Tue,  9 Mar 2010 21:21:31 -0800
Message-Id: <1268198512-6572-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
References: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since the ICT data is all AGN specific, it can
be the first data to create the _agn part of the
device-specific union in the priv struct.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-ict.c |   78 ++++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    8 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h     |   21 ++++---
 3 files changed, 56 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ict.c b/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
index d6b028b..4c5395e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
@@ -42,11 +42,12 @@
 /* Free dram table */
 void iwl_free_isr_ict(struct iwl_priv *priv)
 {
-	if (priv->ict_tbl_vir) {
+	if (priv->_agn.ict_tbl_vir) {
 		dma_free_coherent(&priv->pci_dev->dev,
 				  (sizeof(u32) * ICT_COUNT) + PAGE_SIZE,
-				  priv->ict_tbl_vir, priv->ict_tbl_dma);
-		priv->ict_tbl_vir = NULL;
+				  priv->_agn.ict_tbl_vir,
+				  priv->_agn.ict_tbl_dma);
+		priv->_agn.ict_tbl_vir = NULL;
 	}
 }
 
@@ -60,30 +61,31 @@ int iwl_alloc_isr_ict(struct iwl_priv *priv)
 	if (priv->cfg->use_isr_legacy)
 		return 0;
 	/* allocate shrared data table */
-	priv->ict_tbl_vir = dma_alloc_coherent(&priv->pci_dev->dev,
-					       (sizeof(u32) * ICT_COUNT) + PAGE_SIZE,
-					       &priv->ict_tbl_dma, GFP_KERNEL);
-	if (!priv->ict_tbl_vir)
+	priv->_agn.ict_tbl_vir =
+		dma_alloc_coherent(&priv->pci_dev->dev,
+				   (sizeof(u32) * ICT_COUNT) + PAGE_SIZE,
+				   &priv->_agn.ict_tbl_dma, GFP_KERNEL);
+	if (!priv->_agn.ict_tbl_vir)
 		return -ENOMEM;
 
 	/* align table to PAGE_SIZE boundry */
-	priv->aligned_ict_tbl_dma = ALIGN(priv->ict_tbl_dma, PAGE_SIZE);
+	priv->_agn.aligned_ict_tbl_dma = ALIGN(priv->_agn.ict_tbl_dma, PAGE_SIZE);
 
 	IWL_DEBUG_ISR(priv, "ict dma addr %Lx dma aligned %Lx diff %d\n",
-			     (unsigned long long)priv->ict_tbl_dma,
-			     (unsigned long long)priv->aligned_ict_tbl_dma,
-			(int)(priv->aligned_ict_tbl_dma - priv->ict_tbl_dma));
+			     (unsigned long long)priv->_agn.ict_tbl_dma,
+			     (unsigned long long)priv->_agn.aligned_ict_tbl_dma,
+			(int)(priv->_agn.aligned_ict_tbl_dma - priv->_agn.ict_tbl_dma));
 
-	priv->ict_tbl =  priv->ict_tbl_vir +
-			  (priv->aligned_ict_tbl_dma - priv->ict_tbl_dma);
+	priv->_agn.ict_tbl =  priv->_agn.ict_tbl_vir +
+			  (priv->_agn.aligned_ict_tbl_dma - priv->_agn.ict_tbl_dma);
 
 	IWL_DEBUG_ISR(priv, "ict vir addr %p vir aligned %p diff %d\n",
-			     priv->ict_tbl, priv->ict_tbl_vir,
-			(int)(priv->aligned_ict_tbl_dma - priv->ict_tbl_dma));
+			     priv->_agn.ict_tbl, priv->_agn.ict_tbl_vir,
+			(int)(priv->_agn.aligned_ict_tbl_dma - priv->_agn.ict_tbl_dma));
 
 	/* reset table and index to all 0 */
-	memset(priv->ict_tbl_vir,0, (sizeof(u32) * ICT_COUNT) + PAGE_SIZE);
-	priv->ict_index = 0;
+	memset(priv->_agn.ict_tbl_vir,0, (sizeof(u32) * ICT_COUNT) + PAGE_SIZE);
+	priv->_agn.ict_index = 0;
 
 	/* add periodic RX interrupt */
 	priv->inta_mask |= CSR_INT_BIT_RX_PERIODIC;
@@ -98,26 +100,26 @@ int iwl_reset_ict(struct iwl_priv *priv)
 	u32 val;
 	unsigned long flags;
 
-	if (!priv->ict_tbl_vir)
+	if (!priv->_agn.ict_tbl_vir)
 		return 0;
 
 	spin_lock_irqsave(&priv->lock, flags);
 	iwl_disable_interrupts(priv);
 
-	memset(&priv->ict_tbl[0], 0, sizeof(u32) * ICT_COUNT);
+	memset(&priv->_agn.ict_tbl[0], 0, sizeof(u32) * ICT_COUNT);
 
-	val = priv->aligned_ict_tbl_dma >> PAGE_SHIFT;
+	val = priv->_agn.aligned_ict_tbl_dma >> PAGE_SHIFT;
 
 	val |= CSR_DRAM_INT_TBL_ENABLE;
 	val |= CSR_DRAM_INIT_TBL_WRAP_CHECK;
 
 	IWL_DEBUG_ISR(priv, "CSR_DRAM_INT_TBL_REG =0x%X "
 			"aligned dma address %Lx\n",
-			val, (unsigned long long)priv->aligned_ict_tbl_dma);
+			val, (unsigned long long)priv->_agn.aligned_ict_tbl_dma);
 
 	iwl_write32(priv, CSR_DRAM_INT_TBL_REG, val);
-	priv->use_ict = true;
-	priv->ict_index = 0;
+	priv->_agn.use_ict = true;
+	priv->_agn.ict_index = 0;
 	iwl_write32(priv, CSR_INT, priv->inta_mask);
 	iwl_enable_interrupts(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -131,7 +133,7 @@ void iwl_disable_ict(struct iwl_priv *priv)
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	priv->use_ict = false;
+	priv->_agn.use_ict = false;
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
@@ -180,11 +182,11 @@ static irqreturn_t iwl_isr(int irq, void *data)
 	}
 #endif
 
-	priv->inta |= inta;
+	priv->_agn.inta |= inta;
 	/* iwl_irq_tasklet() will service interrupts and re-enable them */
 	if (likely(inta))
 		tasklet_schedule(&priv->irq_tasklet);
-	else if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->inta)
+	else if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->_agn.inta)
 		iwl_enable_interrupts(priv);
 
  unplugged:
@@ -194,7 +196,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
  none:
 	/* re-enable interrupts here since we don't have anything to service. */
 	/* only Re-enable if diabled by irq  and no schedules tasklet. */
-	if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->inta)
+	if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->_agn.inta)
 		iwl_enable_interrupts(priv);
 
 	spin_unlock(&priv->lock);
@@ -221,7 +223,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	/* dram interrupt table not set yet,
 	 * use legacy interrupt.
 	 */
-	if (!priv->use_ict)
+	if (!priv->_agn.use_ict)
 		return iwl_isr(irq, data);
 
 	spin_lock(&priv->lock);
@@ -238,20 +240,20 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	/* Ignore interrupt if there's nothing in NIC to service.
 	 * This may be due to IRQ shared with another device,
 	 * or due to sporadic interrupts thrown from our NIC. */
-	if (!priv->ict_tbl[priv->ict_index]) {
+	if (!priv->_agn.ict_tbl[priv->_agn.ict_index]) {
 		IWL_DEBUG_ISR(priv, "Ignore interrupt, inta == 0\n");
 		goto none;
 	}
 
 	/* read all entries that not 0 start with ict_index */
-	while (priv->ict_tbl[priv->ict_index]) {
+	while (priv->_agn.ict_tbl[priv->_agn.ict_index]) {
 
-		val |= le32_to_cpu(priv->ict_tbl[priv->ict_index]);
+		val |= le32_to_cpu(priv->_agn.ict_tbl[priv->_agn.ict_index]);
 		IWL_DEBUG_ISR(priv, "ICT index %d value 0x%08X\n",
-				priv->ict_index,
-				le32_to_cpu(priv->ict_tbl[priv->ict_index]));
-		priv->ict_tbl[priv->ict_index] = 0;
-		priv->ict_index = iwl_queue_inc_wrap(priv->ict_index,
+				priv->_agn.ict_index,
+				le32_to_cpu(priv->_agn.ict_tbl[priv->_agn.ict_index]));
+		priv->_agn.ict_tbl[priv->_agn.ict_index] = 0;
+		priv->_agn.ict_index = iwl_queue_inc_wrap(priv->_agn.ict_index,
 						     ICT_COUNT);
 
 	}
@@ -275,12 +277,12 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 			inta, inta_mask, val);
 
 	inta &= priv->inta_mask;
-	priv->inta |= inta;
+	priv->_agn.inta |= inta;
 
 	/* iwl_irq_tasklet() will service interrupts and re-enable them */
 	if (likely(inta))
 		tasklet_schedule(&priv->irq_tasklet);
-	else if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->inta) {
+	else if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->_agn.inta) {
 		/* Allow interrupt if was disabled by this handler and
 		 * no tasklet was schedules, We should not enable interrupt,
 		 * tasklet will enable it.
@@ -295,7 +297,7 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	/* re-enable interrupts here since we don't have anything to service.
 	 * only Re-enable if disabled by irq.
 	 */
-	if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->inta)
+	if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->_agn.inta)
 		iwl_enable_interrupts(priv);
 
 	spin_unlock(&priv->lock);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d7b8e44..d0fab87 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1259,9 +1259,9 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	/* Ack/clear/reset pending uCode interrupts.
 	 * Note:  Some bits in CSR_INT are "OR" of bits in CSR_FH_INT_STATUS,
 	 */
-	iwl_write32(priv, CSR_INT, priv->inta);
+	iwl_write32(priv, CSR_INT, priv->_agn.inta);
 
-	inta = priv->inta;
+	inta = priv->_agn.inta;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (iwl_get_debug_level(priv) & IWL_DL_ISR) {
@@ -1274,8 +1274,8 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	/* saved interrupt in inta variable now we can reset priv->inta */
-	priv->inta = 0;
+	/* saved interrupt in inta variable now we can reset priv->_agn.inta */
+	priv->_agn.inta = 0;
 
 	/* Now service all interrupt bits discovered above. */
 	if (inta & CSR_INT_BIT_HW_ERR) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index e6cae38..f9210b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1276,19 +1276,22 @@ struct iwl_priv {
 			u32 sta_supp_rates;
 		} _3945;
 #endif
+#if defined(CONFIG_IWLAGN) || defined(CONFIG_IWLAGN_MODULE)
+		struct {
+			/* INT ICT Table */
+			__le32 *ict_tbl;
+			void *ict_tbl_vir;
+			dma_addr_t ict_tbl_dma;
+			dma_addr_t aligned_ict_tbl_dma;
+			int ict_index;
+			u32 inta;
+			bool use_ict;
+		} _agn;
+#endif
 	};
 
 	struct iwl_hw_params hw_params;
 
-	/* INT ICT Table */
-	__le32 *ict_tbl;
-	dma_addr_t ict_tbl_dma;
-	dma_addr_t aligned_ict_tbl_dma;
-	int ict_index;
-	void *ict_tbl_vir;
-	u32 inta;
-	bool use_ict;
-
 	u32 inta_mask;
 	/* Current association information needed to configure the
 	 * hardware */
-- 
1.6.3.3

