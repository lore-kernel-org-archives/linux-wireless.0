Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61297 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856AbYAWSPX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 13:15:23 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Joonwoo Park <joonwpark81@gmail.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] iwlwifi: do not schedule tasklet when rcv unused irq
Date: Wed, 23 Jan 2008 10:15:20 -0800
Message-Id: <1201112121-22340-6-git-send-email-reinette.chatre@intel.com> (sfid-20080123_181530_372979_0E05860E)
In-Reply-To: <1201112121-22340-5-git-send-email-reinette.chatre@intel.com>
References: <1201112121-22340-1-git-send-email-reinette.chatre@intel.com>
 <1201112121-22340-2-git-send-email-reinette.chatre@intel.com>
 <1201112121-22340-3-git-send-email-reinette.chatre@intel.com>
 <1201112121-22340-4-git-send-email-reinette.chatre@intel.com>
 <1201112121-22340-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Joonwoo Park <joonwpark81@gmail.com>

The nic controller's scheduler interrupt (CSR_INT_BIT_SCD) indicates
to the driver that scheduler finished to transmit the frame/frames.
This bit is not used and the tasklet should thus not be scheduled upon
its receipt.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h  |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   12 ++++++++----
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   12 ++++++++----
 4 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index e4e4a85..f0a390a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -373,7 +373,7 @@ struct iwl3945_eeprom {
 #define CSR_INT_BIT_HW_ERR       (1 << 29) /* DMA hardware error FH_INT[31] */
 #define CSR_INT_BIT_DNLD         (1 << 28) /* uCode Download */
 #define CSR_INT_BIT_FH_TX        (1 << 27) /* Tx DMA FH_INT[1:0] */
-#define CSR_INT_BIT_MAC_CLK_ACTV (1 << 26) /* NIC controller's clock toggled on/off */
+#define CSR_INT_BIT_SCD          (1 << 26) /* TXQ pointer advanced */
 #define CSR_INT_BIT_SW_ERR       (1 << 25) /* uCode error */
 #define CSR_INT_BIT_RF_KILL      (1 << 7)  /* HW RFKILL switch GP_CNTRL[27] toggled */
 #define CSR_INT_BIT_CT_KILL      (1 << 6)  /* Critical temp (chip too hot) rfkill */
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index ff71c09..ffe1e9d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -465,7 +465,7 @@ struct iwl4965_eeprom {
 #define CSR_INT_BIT_HW_ERR       (1 << 29) /* DMA hardware error FH_INT[31] */
 #define CSR_INT_BIT_DNLD         (1 << 28) /* uCode Download */
 #define CSR_INT_BIT_FH_TX        (1 << 27) /* Tx DMA FH_INT[1:0] */
-#define CSR_INT_BIT_MAC_CLK_ACTV (1 << 26) /* NIC controller's clock toggled on/off */
+#define CSR_INT_BIT_SCD          (1 << 26) /* TXQ pointer advanced */
 #define CSR_INT_BIT_SW_ERR       (1 << 25) /* uCode error */
 #define CSR_INT_BIT_RF_KILL      (1 << 7)  /* HW RFKILL switch GP_CNTRL[27] toggled */
 #define CSR_INT_BIT_CT_KILL      (1 << 6)  /* Critical temp (chip too hot) rfkill */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 1e9e953..ea24e7b 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4759,8 +4759,9 @@ static void iwl3945_irq_tasklet(struct iwl3945_priv *priv)
 #ifdef CONFIG_IWL3945_DEBUG
 	if (iwl3945_debug_level & (IWL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
-		if (inta & CSR_INT_BIT_MAC_CLK_ACTV)
-			IWL_DEBUG_ISR("Microcode started or stopped.\n");
+		if (inta & CSR_INT_BIT_SCD)
+			IWL_DEBUG_ISR("Scheduler finished to transmit "
+				      "the frame/frames.\n");
 
 		/* Alive notification via Rx interrupt will do the real work */
 		if (inta & CSR_INT_BIT_ALIVE)
@@ -4768,7 +4769,7 @@ static void iwl3945_irq_tasklet(struct iwl3945_priv *priv)
 	}
 #endif
 	/* Safely ignore these bits for debug checks below */
-	inta &= ~(CSR_INT_BIT_MAC_CLK_ACTV | CSR_INT_BIT_ALIVE);
+	inta &= ~(CSR_INT_BIT_SCD | CSR_INT_BIT_ALIVE);
 
 	/* HW RF KILL switch toggled (4965 only) */
 	if (inta & CSR_INT_BIT_RF_KILL) {
@@ -4904,8 +4905,11 @@ static irqreturn_t iwl3945_isr(int irq, void *data)
 	IWL_DEBUG_ISR("ISR inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
 		      inta, inta_mask, inta_fh);
 
+	inta &= ~CSR_INT_BIT_SCD;
+
 	/* iwl3945_irq_tasklet() will service interrupts and re-enable them */
-	tasklet_schedule(&priv->irq_tasklet);
+	if (likely(inta || inta_fh))
+		tasklet_schedule(&priv->irq_tasklet);
 unplugged:
 	spin_unlock(&priv->lock);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 9f23c3f..2e82af1 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -5137,8 +5137,9 @@ static void iwl4965_irq_tasklet(struct iwl4965_priv *priv)
 #ifdef CONFIG_IWL4965_DEBUG
 	if (iwl4965_debug_level & (IWL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
-		if (inta & CSR_INT_BIT_MAC_CLK_ACTV)
-			IWL_DEBUG_ISR("Microcode started or stopped.\n");
+		if (inta & CSR_INT_BIT_SCD)
+			IWL_DEBUG_ISR("Scheduler finished to transmit "
+				      "the frame/frames.\n");
 
 		/* Alive notification via Rx interrupt will do the real work */
 		if (inta & CSR_INT_BIT_ALIVE)
@@ -5146,7 +5147,7 @@ static void iwl4965_irq_tasklet(struct iwl4965_priv *priv)
 	}
 #endif
 	/* Safely ignore these bits for debug checks below */
-	inta &= ~(CSR_INT_BIT_MAC_CLK_ACTV | CSR_INT_BIT_ALIVE);
+	inta &= ~(CSR_INT_BIT_SCD | CSR_INT_BIT_ALIVE);
 
 	/* HW RF KILL switch toggled */
 	if (inta & CSR_INT_BIT_RF_KILL) {
@@ -5275,8 +5276,11 @@ static irqreturn_t iwl4965_isr(int irq, void *data)
 	IWL_DEBUG_ISR("ISR inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
 		      inta, inta_mask, inta_fh);
 
+	inta &= ~CSR_INT_BIT_SCD;
+
 	/* iwl4965_irq_tasklet() will service interrupts and re-enable them */
-	tasklet_schedule(&priv->irq_tasklet);
+	if (likely(inta || inta_fh))
+		tasklet_schedule(&priv->irq_tasklet);
 
  unplugged:
 	spin_unlock(&priv->lock);
-- 
1.5.3.4

