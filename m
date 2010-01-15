Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62939 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758528Ab0AOVnu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2010 16:43:50 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/9] iwlwifi: set interrupt coalescing timer range and default
Date: Fri, 15 Jan 2010 13:43:37 -0800
Message-Id: <1263591821-14867-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1263591821-14867-1-git-send-email-reinette.chatre@intel.com>
References: <1263591821-14867-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For interrupt coalescing timer, the CSR_INT_COALESCING is an 8 bit
register in 32-usec unit, the range can go from 0x00 - 0xFF. set the
range and default timeout value for both calibration mode and operation mode.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h  |   15 +++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-rx.c   |    4 ++--
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 14f4829..f94a323 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -257,8 +257,8 @@ int iwl_hw_nic_init(struct iwl_priv *priv)
 	spin_lock_irqsave(&priv->lock, flags);
 	priv->cfg->ops->lib->apm_ops.init(priv);
 
-	/* Set interrupt coalescing timer to 512 usecs */
-	iwl_write8(priv, CSR_INT_COALESCING, 512 / 32);
+	/* Set interrupt coalescing calibration timer to default (512 usecs) */
+	iwl_write8(priv, CSR_INT_COALESCING, IWL_HOST_INT_CALIB_TIMEOUT_DEF);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 811bacf..400545a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1011,6 +1011,21 @@ struct iwl_event_log {
 	int wraps_more_count;
 };
 
+/*
+ * host interrupt timeout value
+ * used with setting interrupt coalescing timer
+ * the CSR_INT_COALESCING is an 8 bit register in 32-usec unit
+ *
+ * default interrupt coalescing timer is 64 x 32 = 2048 usecs
+ * default interrupt coalescing calibration timer is 16 x 32 = 512 usecs
+ */
+#define IWL_HOST_INT_TIMEOUT_MAX	(0xFF)
+#define IWL_HOST_INT_TIMEOUT_DEF	(0x40)
+#define IWL_HOST_INT_TIMEOUT_MIN	(0x0)
+#define IWL_HOST_INT_CALIB_TIMEOUT_MAX	(0xFF)
+#define IWL_HOST_INT_CALIB_TIMEOUT_DEF	(0x10)
+#define IWL_HOST_INT_CALIB_TIMEOUT_MIN	(0x0)
+
 struct iwl_priv {
 
 	/* ieee device used by generic ieee processing code */
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 5bbe5f1..07bdba9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -473,8 +473,8 @@ int iwl_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 			   (rb_timeout << FH_RCSR_RX_CONFIG_REG_IRQ_RBTH_POS)|
 			   (rfdnlog << FH_RCSR_RX_CONFIG_RBDCB_SIZE_POS));
 
-	/* Set interrupt coalescing timer to 64 x 32 = 2048 usecs */
-	iwl_write8(priv, CSR_INT_COALESCING, 0x40);
+	/* Set interrupt coalescing timer to default (2048 usecs) */
+	iwl_write8(priv, CSR_INT_COALESCING, IWL_HOST_INT_TIMEOUT_DEF);
 
 	return 0;
 }
-- 
1.6.3.3

