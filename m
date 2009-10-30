Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15110 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757447AbZJ3VgO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 17:36:14 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ben Cahill <ben.m.cahill@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/15] iwlwifi: remove unneeded locks from apm_stop() and stop_master()
Date: Fri, 30 Oct 2009 14:36:05 -0700
Message-Id: <1256938578-9638-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
References: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Since priv->reg_lock was added to keep multi-access register manipulation
atomic, priv->lock protection is no longer needed.  Remove this from
iwl_apm_stop_master() and iwl_apm_stop().

Add warning of timeout when polling for busmaster disablement confirmation,
and some comments.

NOTE:  This is needed to enable use of apm_ops.stop() within iwl_eeprom_init();
priv->lock does not get initialized until after this flow.  See patch
"remove power-wasting calls to apm_ops.init()"

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 1949f1a..9e71544 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1354,39 +1354,39 @@ EXPORT_SYMBOL(iwl_irq_handle_error);
 
 int iwl_apm_stop_master(struct iwl_priv *priv)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->lock, flags);
+	int ret = 0;
 
-	/* set stop master bit */
+	/* stop device's busmaster DMA activity */
 	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
 
-	iwl_poll_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_MASTER_DISABLED,
+	ret = iwl_poll_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_MASTER_DISABLED,
 			CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
+	if (ret)
+		IWL_WARN(priv, "Master Disable Timed Out, 100 usec\n");
 
-	spin_unlock_irqrestore(&priv->lock, flags);
 	IWL_DEBUG_INFO(priv, "stop master\n");
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(iwl_apm_stop_master);
 
 void iwl_apm_stop(struct iwl_priv *priv)
 {
-	unsigned long flags;
-
 	IWL_DEBUG_INFO(priv, "Stop card, put in low power state\n");
 
+	/* Stop device's DMA activity */
 	iwl_apm_stop_master(priv);
 
-	spin_lock_irqsave(&priv->lock, flags);
-
+	/* Reset the entire device */
 	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
 
 	udelay(10);
-	/* clear "init complete"  move adapter D0A* --> D0U state */
+
+	/*
+	 * Clear "initialization complete" bit to move adapter from
+	 * D0A* (powered-up Active) --> D0U* (Uninitialized) state.
+	 */
 	iwl_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-	spin_unlock_irqrestore(&priv->lock, flags);
 }
 EXPORT_SYMBOL(iwl_apm_stop);
 
-- 
1.5.6.3

