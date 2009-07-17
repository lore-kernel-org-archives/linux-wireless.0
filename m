Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:47318 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964882AbZGQQae (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 12:30:34 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 14/14] iwlwifi: change iwl_enable/disable_interrupts to "inline"
Date: Fri, 17 Jul 2009 09:30:27 -0700
Message-Id: <1247848227-24031-15-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1247848227-24031-14-git-send-email-reinette.chatre@intel.com>
References: <1247848227-24031-1-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-2-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-3-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-4-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-5-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-6-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-7-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-8-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-9-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-10-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-11-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-12-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-13-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-14-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

iwl_enable_interrupts is being called inside the interrupt,
change from function call to inline

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c    |   25 -------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h    |    2 --
 drivers/net/wireless/iwlwifi/iwl-helpers.h |   21 +++++++++++++++++++++
 3 files changed, 21 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 6989cbc..ea68939 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1546,31 +1546,6 @@ void iwl_uninit_drv(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_uninit_drv);
 
-
-void iwl_disable_interrupts(struct iwl_priv *priv)
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
-EXPORT_SYMBOL(iwl_disable_interrupts);
-
-void iwl_enable_interrupts(struct iwl_priv *priv)
-{
-	IWL_DEBUG_ISR(priv, "Enabling interrupts\n");
-	set_bit(STATUS_INT_ENABLED, &priv->status);
-	iwl_write32(priv, CSR_INT_MASK, priv->inta_mask);
-}
-EXPORT_SYMBOL(iwl_enable_interrupts);
-
-
 #define ICT_COUNT (PAGE_SIZE/sizeof(u32))
 
 /* Free dram table */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 018030b..d339336 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -458,8 +458,6 @@ int iwl_send_card_state(struct iwl_priv *priv, u32 flags,
 /*****************************************************
  * PCI						     *
  *****************************************************/
-void iwl_disable_interrupts(struct iwl_priv *priv);
-void iwl_enable_interrupts(struct iwl_priv *priv);
 irqreturn_t iwl_isr_legacy(int irq, void *data);
 int iwl_reset_ict(struct iwl_priv *priv);
 void iwl_disable_ict(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index a1328c3..bd0b12e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -145,4 +145,25 @@ static inline void iwl_stop_queue(struct iwl_priv *priv, u8 queue)
 #define ieee80211_stop_queue DO_NOT_USE_ieee80211_stop_queue
 #define ieee80211_wake_queue DO_NOT_USE_ieee80211_wake_queue
 
+static inline void iwl_disable_interrupts(struct iwl_priv *priv)
+{
+	clear_bit(STATUS_INT_ENABLED, &priv->status);
+
+	/* disable interrupts from uCode/NIC to host */
+	iwl_write32(priv, CSR_INT_MASK, 0x00000000);
+
+	/* acknowledge/clear/reset any interrupts still pending
+	 * from uCode or flow handler (Rx/Tx DMA) */
+	iwl_write32(priv, CSR_INT, 0xffffffff);
+	iwl_write32(priv, CSR_FH_INT_STATUS, 0xffffffff);
+	IWL_DEBUG_ISR(priv, "Disabled interrupts\n");
+}
+
+static inline void iwl_enable_interrupts(struct iwl_priv *priv)
+{
+	IWL_DEBUG_ISR(priv, "Enabling interrupts\n");
+	set_bit(STATUS_INT_ENABLED, &priv->status);
+	iwl_write32(priv, CSR_INT_MASK, priv->inta_mask);
+}
+
 #endif				/* __iwl_helpers_h__ */
-- 
1.5.6.3

