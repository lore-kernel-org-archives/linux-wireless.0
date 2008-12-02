Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9103 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbYLBUNN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 15:13:13 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/11] iwlwifi: move disable/enable interrupts to iwl-core.c
Date: Tue,  2 Dec 2008 12:14:00 -0800
Message-Id: <1228248847-10424-5-git-send-email-reinette.chatre@intel.com> (sfid-20081202_211321_825953_BD47AA10)
In-Reply-To: <1228248847-10424-4-git-send-email-reinette.chatre@intel.com>
References: <>
 <1228248847-10424-1-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-2-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-3-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch moves iwl_enable_interrupts and iwl_disable_interrupts
functions to iwl-core.c

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   22 ----------------------
 drivers/net/wireless/iwlwifi/iwl-core.c |   25 +++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h |    6 ++++++
 3 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index de1ec54..9e1d57f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1259,13 +1259,6 @@ static void iwl_print_rx_config_cmd(struct iwl_priv *priv)
 }
 #endif
 
-static void iwl_enable_interrupts(struct iwl_priv *priv)
-{
-	IWL_DEBUG_ISR("Enabling interrupts\n");
-	set_bit(STATUS_INT_ENABLED, &priv->status);
-	iwl_write32(priv, CSR_INT_MASK, CSR_INI_SET_MASK);
-}
-
 /* call this function to flush any scheduled tasklet */
 static inline void iwl_synchronize_irq(struct iwl_priv *priv)
 {
@@ -1274,21 +1267,6 @@ static inline void iwl_synchronize_irq(struct iwl_priv *priv)
 	tasklet_kill(&priv->irq_tasklet);
 }
 
-static inline void iwl_disable_interrupts(struct iwl_priv *priv)
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
-	IWL_DEBUG_ISR("Disabled interrupts\n");
-}
-
-
 /**
  * iwl_irq_handle_error - called for HW or SW error interrupt from card
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 6aa332b..78d1ba7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -962,6 +962,30 @@ void iwl_uninit_drv(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_uninit_drv);
 
+
+void iwl_disable_interrupts(struct iwl_priv *priv)
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
+	IWL_DEBUG_ISR("Disabled interrupts\n");
+}
+EXPORT_SYMBOL(iwl_disable_interrupts);
+
+void iwl_enable_interrupts(struct iwl_priv *priv)
+{
+	IWL_DEBUG_ISR("Enabling interrupts\n");
+	set_bit(STATUS_INT_ENABLED, &priv->status);
+	iwl_write32(priv, CSR_INT_MASK, CSR_INI_SET_MASK);
+}
+EXPORT_SYMBOL(iwl_enable_interrupts);
+
 int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags)
 {
 	u32 stat_flags = 0;
@@ -1337,6 +1361,7 @@ void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_rf_kill_ct_config);
 
+
 /*
  * CARD_STATE_CMD
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 82bf263..f68883b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -313,6 +313,12 @@ int iwl_send_cmd_pdu_async(struct iwl_priv *priv, u8 id, u16 len,
 int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
 
 /*****************************************************
+ * PCI						     *
+ *****************************************************/
+void iwl_disable_interrupts(struct iwl_priv *priv);
+void iwl_enable_interrupts(struct iwl_priv *priv);
+
+/*****************************************************
 *  Error Handling Debugging
 ******************************************************/
 void iwl_dump_nic_error_log(struct iwl_priv *priv);
-- 
1.5.4.3

