Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43232 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab0KJSBF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 13:01:05 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/16] iwlwifi: Legacy isr only used by legacy devices
Date: Wed, 10 Nov 2010 09:56:39 -0800
Message-Id: <1289411810-23093-6-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move iwl_isr_legacy function to iwl_legacy.c since it only used
by legacy devices.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c   |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c   |   60 ----------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h   |    1 -
 drivers/net/wireless/iwlwifi/iwl-legacy.c |   62 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-legacy.h |    2 +
 5 files changed, 65 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index d216066..3854d5c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -51,6 +51,7 @@
 #include "iwl-led.h"
 #include "iwl-3945-led.h"
 #include "iwl-3945-debugfs.h"
+#include "iwl-legacy.h"
 
 #define IWL_DECLARE_RATE_INFO(r, ip, in, rp, rn, pp, np)    \
 	[IWL_RATE_##r##M_INDEX] = { IWL_RATE_##r##M_PLCP,   \
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 9809c57..88c6de7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1223,66 +1223,6 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 }
 EXPORT_SYMBOL(iwl_set_tx_power);
 
-irqreturn_t iwl_isr_legacy(int irq, void *data)
-{
-	struct iwl_priv *priv = data;
-	u32 inta, inta_mask;
-	u32 inta_fh;
-	unsigned long flags;
-	if (!priv)
-		return IRQ_NONE;
-
-	spin_lock_irqsave(&priv->lock, flags);
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
-	spin_unlock_irqrestore(&priv->lock, flags);
-	return IRQ_HANDLED;
-
- none:
-	/* re-enable interrupts here since we don't have anything to service. */
-	/* only Re-enable if diabled by irq */
-	if (test_bit(STATUS_INT_ENABLED, &priv->status))
-		iwl_enable_interrupts(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
-	return IRQ_NONE;
-}
-EXPORT_SYMBOL(iwl_isr_legacy);
-
 void iwl_send_bt_config(struct iwl_priv *priv)
 {
 	struct iwl_bt_cmd bt_cmd = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 39ea13c..81f2740 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -596,7 +596,6 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
 /*****************************************************
  * PCI						     *
  *****************************************************/
-irqreturn_t iwl_isr_legacy(int irq, void *data);
 
 static inline u16 iwl_pcie_link_ctl(struct iwl_priv *priv)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-legacy.c b/drivers/net/wireless/iwlwifi/iwl-legacy.c
index b735fef..f49e500 100644
--- a/drivers/net/wireless/iwlwifi/iwl-legacy.c
+++ b/drivers/net/wireless/iwlwifi/iwl-legacy.c
@@ -31,6 +31,7 @@
 
 #include "iwl-dev.h"
 #include "iwl-core.h"
+#include "iwl-helpers.h"
 #include "iwl-legacy.h"
 
 /**
@@ -558,3 +559,64 @@ void iwl_legacy_mac_bss_info_changed(struct ieee80211_hw *hw,
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 EXPORT_SYMBOL(iwl_legacy_mac_bss_info_changed);
+
+irqreturn_t iwl_isr_legacy(int irq, void *data)
+{
+	struct iwl_priv *priv = data;
+	u32 inta, inta_mask;
+	u32 inta_fh;
+	unsigned long flags;
+	if (!priv)
+		return IRQ_NONE;
+
+	spin_lock_irqsave(&priv->lock, flags);
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
+		IWL_DEBUG_ISR(priv,
+			"Ignore interrupt, inta == 0, inta_fh == 0\n");
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
+unplugged:
+	spin_unlock_irqrestore(&priv->lock, flags);
+	return IRQ_HANDLED;
+
+none:
+	/* re-enable interrupts here since we don't have anything to service. */
+	/* only Re-enable if diabled by irq */
+	if (test_bit(STATUS_INT_ENABLED, &priv->status))
+		iwl_enable_interrupts(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
+	return IRQ_NONE;
+}
+EXPORT_SYMBOL(iwl_isr_legacy);
diff --git a/drivers/net/wireless/iwlwifi/iwl-legacy.h b/drivers/net/wireless/iwlwifi/iwl-legacy.h
index 2a746cb..81d1ccd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-legacy.h
+++ b/drivers/net/wireless/iwlwifi/iwl-legacy.h
@@ -71,4 +71,6 @@ void iwl_legacy_mac_bss_info_changed(struct ieee80211_hw *hw,
 				     struct ieee80211_bss_conf *bss_conf,
 				     u32 changes);
 
+irqreturn_t iwl_isr_legacy(int irq, void *data);
+
 #endif /* __iwl_legacy_h__ */
-- 
1.7.0.4

