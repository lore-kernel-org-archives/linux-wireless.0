Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59705 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753560AbZBRXuX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 18:50:23 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6/8] iwl3945: use iwl_isr
Date: Wed, 18 Feb 2009 15:54:31 -0800
Message-Id: <1235001273-7808-7-git-send-email-reinette.chatre@intel.com> (sfid-20090219_005042_246156_E6787F55)
In-Reply-To: <1235001273-7808-6-git-send-email-reinette.chatre@intel.com>
References: <>
 <1235001273-7808-1-git-send-email-reinette.chatre@intel.com>
 <1235001273-7808-2-git-send-email-reinette.chatre@intel.com>
 <1235001273-7808-3-git-send-email-reinette.chatre@intel.com>
 <1235001273-7808-4-git-send-email-reinette.chatre@intel.com>
 <1235001273-7808-5-git-send-email-reinette.chatre@intel.com>
 <1235001273-7808-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

iwl3945 uses iwl_isr and deletes duplicated iwl3945_isr.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Acked-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   58 --------------------------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   59 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   59 +--------------------------
 4 files changed, 61 insertions(+), 116 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a3de6ad..3c053ea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1277,64 +1277,6 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-static irqreturn_t iwl_isr(int irq, void *data)
-{
-	struct iwl_priv *priv = data;
-	u32 inta, inta_mask;
-	u32 inta_fh;
-	if (!priv)
-		return IRQ_NONE;
-
-	spin_lock(&priv->lock);
-
-	/* Disable (but don't clear!) interrupts here to avoid
-	 *    back-to-back ISRs and sporadic interrupts from our NIC.
-	 * If we have something to service, the tasklet will re-enable ints.
-	 * If we *don't* have something, we'll re-enable before leaving here. */
-	inta_mask = iwl_read32(priv, CSR_INT_MASK);  /* just for debug */
-	iwl_write32(priv, CSR_INT_MASK, 0x00000000);
-
-	/* Discover which interrupts are active/pending */
-	inta = iwl_read32(priv, CSR_INT);
-	inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
-
-	/* Ignore interrupt if there's nothing in NIC to service.
-	 * This may be due to IRQ shared with another device,
-	 * or due to sporadic interrupts thrown from our NIC. */
-	if (!inta && !inta_fh) {
-		IWL_DEBUG_ISR(priv, "Ignore interrupt, inta == 0, inta_fh == 0\n");
-		goto none;
-	}
-
-	if ((inta == 0xFFFFFFFF) || ((inta & 0xFFFFFFF0) == 0xa5a5a5a0)) {
-		/* Hardware disappeared. It might have already raised
-		 * an interrupt */
-		IWL_WARN(priv, "HARDWARE GONE?? INTA == 0x%08x\n", inta);
-		goto unplugged;
-	}
-
-	IWL_DEBUG_ISR(priv, "ISR inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
-		      inta, inta_mask, inta_fh);
-
-	inta &= ~CSR_INT_BIT_SCD;
-
-	/* iwl_irq_tasklet() will service interrupts and re-enable them */
-	if (likely(inta || inta_fh))
-		tasklet_schedule(&priv->irq_tasklet);
-
- unplugged:
-	spin_unlock(&priv->lock);
-	return IRQ_HANDLED;
-
- none:
-	/* re-enable interrupts here since we don't have anything to service. */
-	/* only Re-enable if diabled by irq */
-	if (test_bit(STATUS_INT_ENABLED, &priv->status))
-		iwl_enable_interrupts(priv);
-	spin_unlock(&priv->lock);
-	return IRQ_NONE;
-}
-
 /******************************************************************************
  *
  * uCode download functions
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 61b9902..37069d4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1444,6 +1444,65 @@ void iwl_enable_interrupts(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_enable_interrupts);
 
+irqreturn_t iwl_isr(int irq, void *data)
+{
+	struct iwl_priv *priv = data;
+	u32 inta, inta_mask;
+	u32 inta_fh;
+	if (!priv)
+		return IRQ_NONE;
+
+	spin_lock(&priv->lock);
+
+	/* Disable (but don't clear!) interrupts here to avoid
+	 *    back-to-back ISRs and sporadic interrupts from our NIC.
+	 * If we have something to service, the tasklet will re-enable ints.
+	 * If we *don't* have something, we'll re-enable before leaving here. */
+	inta_mask = iwl_read32(priv, CSR_INT_MASK);  /* just for debug */
+	iwl_write32(priv, CSR_INT_MASK, 0x00000000);
+
+	/* Discover which interrupts are active/pending */
+	inta = iwl_read32(priv, CSR_INT);
+	inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
+
+	/* Ignore interrupt if there's nothing in NIC to service.
+	 * This may be due to IRQ shared with another device,
+	 * or due to sporadic interrupts thrown from our NIC. */
+	if (!inta && !inta_fh) {
+		IWL_DEBUG_ISR(priv, "Ignore interrupt, inta == 0, inta_fh == 0\n");
+		goto none;
+	}
+
+	if ((inta == 0xFFFFFFFF) || ((inta & 0xFFFFFFF0) == 0xa5a5a5a0)) {
+		/* Hardware disappeared. It might have already raised
+		 * an interrupt */
+		IWL_WARN(priv, "HARDWARE GONE?? INTA == 0x%08x\n", inta);
+		goto unplugged;
+	}
+
+	IWL_DEBUG_ISR(priv, "ISR inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
+		      inta, inta_mask, inta_fh);
+
+	inta &= ~CSR_INT_BIT_SCD;
+
+	/* iwl_irq_tasklet() will service interrupts and re-enable them */
+	if (likely(inta || inta_fh))
+		tasklet_schedule(&priv->irq_tasklet);
+
+ unplugged:
+	spin_unlock(&priv->lock);
+	return IRQ_HANDLED;
+
+ none:
+	/* re-enable interrupts here since we don't have anything to service. */
+	/* only Re-enable if diabled by irq */
+	if (test_bit(STATUS_INT_ENABLED, &priv->status))
+		iwl_enable_interrupts(priv);
+	spin_unlock(&priv->lock);
+	return IRQ_NONE;
+}
+EXPORT_SYMBOL(iwl_isr);
+
 int iwl_send_bt_config(struct iwl_priv *priv)
 {
 	struct iwl_bt_cmd bt_cmd = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index f2f75d1..7427d75 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -421,6 +421,7 @@ int iwl_send_card_state(struct iwl_priv *priv, u32 flags,
  *****************************************************/
 void iwl_disable_interrupts(struct iwl_priv *priv);
 void iwl_enable_interrupts(struct iwl_priv *priv);
+irqreturn_t iwl_isr(int irq, void *data);
 static inline u16 iwl_pcie_link_ctl(struct iwl_priv *priv)
 {
 	int pos;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 2763662..232db2c 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2325,63 +2325,6 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-static irqreturn_t iwl3945_isr(int irq, void *data)
-{
-	struct iwl_priv *priv = data;
-	u32 inta, inta_mask;
-	u32 inta_fh;
-	if (!priv)
-		return IRQ_NONE;
-
-	spin_lock(&priv->lock);
-
-	/* Disable (but don't clear!) interrupts here to avoid
-	 *    back-to-back ISRs and sporadic interrupts from our NIC.
-	 * If we have something to service, the tasklet will re-enable ints.
-	 * If we *don't* have something, we'll re-enable before leaving here. */
-	inta_mask = iwl_read32(priv, CSR_INT_MASK);  /* just for debug */
-	iwl_write32(priv, CSR_INT_MASK, 0x00000000);
-
-	/* Discover which interrupts are active/pending */
-	inta = iwl_read32(priv, CSR_INT);
-	inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
-
-	/* Ignore interrupt if there's nothing in NIC to service.
-	 * This may be due to IRQ shared with another device,
-	 * or due to sporadic interrupts thrown from our NIC. */
-	if (!inta && !inta_fh) {
-		IWL_DEBUG_ISR(priv, "Ignore interrupt, inta == 0, inta_fh == 0\n");
-		goto none;
-	}
-
-	if ((inta == 0xFFFFFFFF) || ((inta & 0xFFFFFFF0) == 0xa5a5a5a0)) {
-		/* Hardware disappeared */
-		IWL_WARN(priv, "HARDWARE GONE?? INTA == 0x%08x\n", inta);
-		goto unplugged;
-	}
-
-	IWL_DEBUG_ISR(priv, "ISR inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
-		      inta, inta_mask, inta_fh);
-
-	inta &= ~CSR_INT_BIT_SCD;
-
-	/* iwl3945_irq_tasklet() will service interrupts and re-enable them */
-	if (likely(inta || inta_fh))
-		tasklet_schedule(&priv->irq_tasklet);
-unplugged:
-	spin_unlock(&priv->lock);
-
-	return IRQ_HANDLED;
-
- none:
-	/* re-enable interrupts here since we don't have anything to service. */
-	/* only Re-enable if disabled by irq */
-	if (test_bit(STATUS_INT_ENABLED, &priv->status))
-		iwl_enable_interrupts(priv);
-	spin_unlock(&priv->lock);
-	return IRQ_NONE;
-}
-
 static int iwl3945_get_channels_for_scan(struct iwl_priv *priv,
 					 enum ieee80211_band band,
 				     u8 is_active, u8 n_probes,
@@ -5235,7 +5178,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	pci_enable_msi(priv->pci_dev);
 
-	err = request_irq(priv->pci_dev->irq, iwl3945_isr, IRQF_SHARED,
+	err = request_irq(priv->pci_dev->irq, iwl_isr, IRQF_SHARED,
 			  DRV_NAME, priv);
 	if (err) {
 		IWL_ERR(priv, "Error allocating IRQ %d\n", priv->pci_dev->irq);
-- 
1.5.4.3

