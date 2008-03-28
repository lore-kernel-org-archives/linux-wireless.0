Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:30165 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755835AbYC1XZd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 19:25:33 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mabbas@linux.intel.com>,
	Joonwoo Park <joonwpark81@gmail.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/8] iwlwifi: fix race condition during driver unload
Date: Fri, 28 Mar 2008 16:21:08 -0700
Message-Id: <1206746472-10443-5-git-send-email-reinette.chatre@intel.com> (sfid-20080328_232537_298116_5C8336DE)
In-Reply-To: <1206746472-10443-4-git-send-email-reinette.chatre@intel.com>
References: <1206746472-10443-1-git-send-email-reinette.chatre@intel.com>
 <1206746472-10443-2-git-send-email-reinette.chatre@intel.com>
 <1206746472-10443-3-git-send-email-reinette.chatre@intel.com>
 <1206746472-10443-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mabbas@linux.intel.com>

This patch fixed the OOPS when load the driver while rf-kill is on then
unload the driver right after load. a race condition caused the interupt
handler to schedule the tasklet which will run right after the driver pci_remove
causing invalid poiter OOPS.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   34 +++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   32 +++++++++++++++++++++++-
 2 files changed, 62 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 02b4245..ed85db7 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4153,6 +4153,16 @@ static void iwl3945_enable_interrupts(struct iwl3945_priv *priv)
 	iwl3945_write32(priv, CSR_INT_MASK, CSR_INI_SET_MASK);
 }
 
+
+/* call this function to flush any scheduled tasklet */
+static inline void iwl_synchronize_irq(struct iwl3945_priv *priv)
+{
+	/* wait to make sure we flush pedding tasklet*/
+	synchronize_irq(priv->pci_dev->irq);
+	tasklet_kill(&priv->irq_tasklet);
+}
+
+
 static inline void iwl3945_disable_interrupts(struct iwl3945_priv *priv)
 {
 	clear_bit(STATUS_INT_ENABLED, &priv->status);
@@ -4552,7 +4562,9 @@ static void iwl3945_irq_tasklet(struct iwl3945_priv *priv)
 	}
 
 	/* Re-enable all interrupts */
-	iwl3945_enable_interrupts(priv);
+	/* only Re-enable if disabled by irq */
+	if (test_bit(STATUS_INT_ENABLED, &priv->status))
+		iwl3945_enable_interrupts(priv);
 
 #ifdef CONFIG_IWL3945_DEBUG
 	if (iwl3945_debug_level & (IWL_DL_ISR)) {
@@ -4616,7 +4628,9 @@ unplugged:
 
  none:
 	/* re-enable interrupts here since we don't have anything to service. */
-	iwl3945_enable_interrupts(priv);
+	/* only Re-enable if disabled by irq */
+	if (test_bit(STATUS_INT_ENABLED, &priv->status))
+		iwl3945_enable_interrupts(priv);
 	spin_unlock(&priv->lock);
 	return IRQ_NONE;
 }
@@ -5906,7 +5920,10 @@ static void __iwl3945_down(struct iwl3945_priv *priv)
 	iwl3945_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
 
 	/* tell the device to stop sending interrupts */
+	spin_lock_irqsave(&priv->lock, flags);
 	iwl3945_disable_interrupts(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
+	iwl_synchronize_irq(priv);
 
 	if (priv->mac80211_registered)
 		ieee80211_stop_queues(priv->hw);
@@ -7944,6 +7961,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	struct ieee80211_hw *hw;
 	struct iwl_3945_cfg *cfg = (struct iwl_3945_cfg *)(ent->driver_data);
 	int i;
+	unsigned long flags;
 	DECLARE_MAC_BUF(mac);
 
 	/* Disabling hardware scan means that mac80211 will perform scans
@@ -8094,7 +8112,9 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv->power_mode = IWL_POWER_AC;
 	priv->user_txpower_limit = IWL_DEFAULT_TX_POWER;
 
+	spin_lock_irqsave(&priv->lock, flags);
 	iwl3945_disable_interrupts(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
 
 	err = sysfs_create_group(&pdev->dev.kobj, &iwl3945_attribute_group);
 	if (err) {
@@ -8181,6 +8201,7 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 	struct iwl3945_priv *priv = pci_get_drvdata(pdev);
 	struct list_head *p, *q;
 	int i;
+	unsigned long flags;
 
 	if (!priv)
 		return;
@@ -8191,6 +8212,15 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 
 	iwl3945_down(priv);
 
+	/* make sure we flush any pending irq or
+	 * tasklet for the driver
+	 */
+	spin_lock_irqsave(&priv->lock, flags);
+	iwl3945_disable_interrupts(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	iwl_synchronize_irq(priv);
+
 	/* Free MAC hash list for ADHOC */
 	for (i = 0; i < IWL_IBSS_MAC_HASH_SIZE; i++) {
 		list_for_each_safe(p, q, &priv->ibss_mac_hash[i]) {
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 96daece..7f2dca3 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -4285,6 +4285,14 @@ static void iwl4965_enable_interrupts(struct iwl_priv *priv)
 	iwl_write32(priv, CSR_INT_MASK, CSR_INI_SET_MASK);
 }
 
+/* call this function to flush any scheduled tasklet */
+static inline void iwl_synchronize_irq(struct iwl_priv *priv)
+{
+	/* wait to make sure we flush pedding tasklet*/
+	synchronize_irq(priv->pci_dev->irq);
+	tasklet_kill(&priv->irq_tasklet);
+}
+
 static inline void iwl4965_disable_interrupts(struct iwl_priv *priv)
 {
 	clear_bit(STATUS_INT_ENABLED, &priv->status);
@@ -4668,7 +4676,9 @@ static void iwl4965_irq_tasklet(struct iwl_priv *priv)
 	}
 
 	/* Re-enable all interrupts */
-	iwl4965_enable_interrupts(priv);
+	/* only Re-enable if diabled by irq */
+	if (test_bit(STATUS_INT_ENABLED, &priv->status))
+		iwl4965_enable_interrupts(priv);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (iwl_debug_level & (IWL_DL_ISR)) {
@@ -4733,7 +4743,9 @@ static irqreturn_t iwl4965_isr(int irq, void *data)
 
  none:
 	/* re-enable interrupts here since we don't have anything to service. */
-	iwl4965_enable_interrupts(priv);
+	/* only Re-enable if diabled by irq */
+	if (test_bit(STATUS_INT_ENABLED, &priv->status))
+		iwl4965_enable_interrupts(priv);
 	spin_unlock(&priv->lock);
 	return IRQ_NONE;
 }
@@ -5773,7 +5785,10 @@ static void __iwl4965_down(struct iwl_priv *priv)
 	iwl_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
 
 	/* tell the device to stop sending interrupts */
+	spin_lock_irqsave(&priv->lock, flags);
 	iwl4965_disable_interrupts(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
+	iwl_synchronize_irq(priv);
 
 	if (priv->mac80211_registered)
 		ieee80211_stop_queues(priv->hw);
@@ -7997,6 +8012,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	struct iwl_priv *priv;
 	struct ieee80211_hw *hw;
 	struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
+	unsigned long flags;
 	DECLARE_MAC_BUF(mac);
 
 	/************************
@@ -8134,7 +8150,9 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	/********************
 	 * 8. Setup services
 	 ********************/
+	spin_lock_irqsave(&priv->lock, flags);
 	iwl4965_disable_interrupts(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
 
 	err = sysfs_create_group(&pdev->dev.kobj, &iwl4965_attribute_group);
 	if (err) {
@@ -8183,6 +8201,7 @@ static void __devexit iwl4965_pci_remove(struct pci_dev *pdev)
 	struct iwl_priv *priv = pci_get_drvdata(pdev);
 	struct list_head *p, *q;
 	int i;
+	unsigned long flags;
 
 	if (!priv)
 		return;
@@ -8193,6 +8212,15 @@ static void __devexit iwl4965_pci_remove(struct pci_dev *pdev)
 
 	iwl4965_down(priv);
 
+	/* make sure we flush any pending irq or
+	 * tasklet for the driver
+	 */
+	spin_lock_irqsave(&priv->lock, flags);
+	iwl4965_disable_interrupts(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	iwl_synchronize_irq(priv);
+
 	/* Free MAC hash list for ADHOC */
 	for (i = 0; i < IWL_IBSS_MAC_HASH_SIZE; i++) {
 		list_for_each_safe(p, q, &priv->ibss_mac_hash[i]) {
-- 
1.5.3.4

