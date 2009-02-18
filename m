Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2016 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556AbZBRXuX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 18:50:23 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/8] iwl3945: remove duplicate interrupt code
Date: Wed, 18 Feb 2009 15:54:30 -0800
Message-Id: <1235001273-7808-6-git-send-email-reinette.chatre@intel.com> (sfid-20090219_005040_420673_2EC825F4)
In-Reply-To: <1235001273-7808-5-git-send-email-reinette.chatre@intel.com>
References: <>
 <1235001273-7808-1-git-send-email-reinette.chatre@intel.com>
 <1235001273-7808-2-git-send-email-reinette.chatre@intel.com>
 <1235001273-7808-3-git-send-email-reinette.chatre@intel.com>
 <1235001273-7808-4-git-send-email-reinette.chatre@intel.com>
 <1235001273-7808-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Patch removes duplicate code to enable and disable interrupt.
iwl3945 now uses iwlwifi's functions.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Acked-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   37 +++++---------------------
 1 files changed, 7 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 62ec67a..2763662 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1982,14 +1982,6 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 	iwl3945_rx_queue_restock(priv);
 }
 
-static void iwl3945_enable_interrupts(struct iwl_priv *priv)
-{
-	IWL_DEBUG_ISR(priv, "Enabling interrupts\n");
-	set_bit(STATUS_INT_ENABLED, &priv->status);
-	iwl_write32(priv, CSR_INT_MASK, CSR_INI_SET_MASK);
-}
-
-
 /* call this function to flush any scheduled tasklet */
 static inline void iwl_synchronize_irq(struct iwl_priv *priv)
 {
@@ -1998,21 +1990,6 @@ static inline void iwl_synchronize_irq(struct iwl_priv *priv)
 	tasklet_kill(&priv->irq_tasklet);
 }
 
-
-static inline void iwl3945_disable_interrupts(struct iwl_priv *priv)
-{
-	clear_bit(STATUS_INT_ENABLED, &priv->status);
-
-	/* disable interrupts from uCode/NIC to host */
-	iwl_write32(priv, CSR_INT_MASK, 0x00000000);
-
-	/* acknowledge/clear/reset any interrupts still pending
-	 * from uCode or flow handler (Rx/Tx DMA) */
-	iwl_write32(priv, CSR_INT, 0xffffffff);
-	iwl_write32(priv, CSR_FH_INT_STATUS, 0xffffffff);
-	IWL_DEBUG_ISR(priv, "Disabled interrupts\n");
-}
-
 static const char *desc_lookup(int i)
 {
 	switch (i) {
@@ -2254,7 +2231,7 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 		IWL_ERR(priv, "Microcode HW error detected.  Restarting.\n");
 
 		/* Tell the device to stop sending interrupts */
-		iwl3945_disable_interrupts(priv);
+		iwl_disable_interrupts(priv);
 
 		iwl_irq_handle_error(priv);
 
@@ -2334,7 +2311,7 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 	/* Re-enable all interrupts */
 	/* only Re-enable if disabled by irq */
 	if (test_bit(STATUS_INT_ENABLED, &priv->status))
-		iwl3945_enable_interrupts(priv);
+		iwl_enable_interrupts(priv);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (priv->debug_level & (IWL_DL_ISR)) {
@@ -2400,7 +2377,7 @@ unplugged:
 	/* re-enable interrupts here since we don't have anything to service. */
 	/* only Re-enable if disabled by irq */
 	if (test_bit(STATUS_INT_ENABLED, &priv->status))
-		iwl3945_enable_interrupts(priv);
+		iwl_enable_interrupts(priv);
 	spin_unlock(&priv->lock);
 	return IRQ_NONE;
 }
@@ -3174,7 +3151,7 @@ static void __iwl3945_down(struct iwl_priv *priv)
 
 	/* tell the device to stop sending interrupts */
 	spin_lock_irqsave(&priv->lock, flags);
-	iwl3945_disable_interrupts(priv);
+	iwl_disable_interrupts(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 	iwl_synchronize_irq(priv);
 
@@ -3304,7 +3281,7 @@ static int __iwl3945_up(struct iwl_priv *priv)
 
 	/* clear (again), then enable host interrupts */
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
-	iwl3945_enable_interrupts(priv);
+	iwl_enable_interrupts(priv);
 
 	/* really make sure rfkill handshake bits are cleared */
 	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
@@ -5253,7 +5230,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	 * ********************/
 
 	spin_lock_irqsave(&priv->lock, flags);
-	iwl3945_disable_interrupts(priv);
+	iwl_disable_interrupts(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	pci_enable_msi(priv->pci_dev);
@@ -5348,7 +5325,7 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 	 * tasklet for the driver
 	 */
 	spin_lock_irqsave(&priv->lock, flags);
-	iwl3945_disable_interrupts(priv);
+	iwl_disable_interrupts(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	iwl_synchronize_irq(priv);
-- 
1.5.4.3

