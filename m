Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:54400 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080Ab0H0Q4p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 12:56:45 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/27] iwlwifi: define PAN queues/FIFOs
Date: Fri, 27 Aug 2010 09:59:31 -0700
Message-Id: <1282928395-32762-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

PAN capable microcode has a different
queue assignment (not just more queues
for PAN) due to the way multicast is
handled for AP mode.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   10 +++++-----
 drivers/net/wireless/iwlwifi/iwl-agn.c       |    5 ++++-
 drivers/net/wireless/iwlwifi/iwl-dev.h       |   15 +++++++++++++--
 3 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index a9ea7a1..a7961bf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -57,11 +57,11 @@ static const s8 iwlagn_ipan_queue_to_tx_fifo[] = {
 	IWL_TX_FIFO_VI,
 	IWL_TX_FIFO_BE,
 	IWL_TX_FIFO_BK,
-	IWL_TX_FIFO_UNUSED, /* FIXME */
-	IWL_TX_FIFO_UNUSED, /* FIXME */
-	IWL_TX_FIFO_UNUSED, /* FIXME */
-	IWL_TX_FIFO_UNUSED, /* FIXME */
-	IWL_TX_FIFO_UNUSED, /* FIXME */
+	IWL_TX_FIFO_BK_IPAN,
+	IWL_TX_FIFO_BE_IPAN,
+	IWL_TX_FIFO_VI_IPAN,
+	IWL_TX_FIFO_VO_IPAN,
+	IWL_TX_FIFO_BE_IPAN,
 	IWLAGN_CMD_FIFO_NUM,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index cfc8e8d..5f67955 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3012,7 +3012,10 @@ static int __iwl_up(struct iwl_priv *priv)
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
 
 	/* must be initialised before iwl_hw_nic_init */
-	priv->cmd_queue = IWL_DEFAULT_CMD_QUEUE_NUM;
+	if (priv->valid_contexts != BIT(IWL_RXON_CTX_BSS))
+		priv->cmd_queue = IWL_IPAN_CMD_QUEUE_NUM;
+	else
+		priv->cmd_queue = IWL_DEFAULT_CMD_QUEUE_NUM;
 
 	ret = iwlagn_hw_nic_init(priv);
 	if (ret) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 7cafb26..8ec377d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -253,10 +253,14 @@ struct iwl_channel_info {
 	struct iwl3945_scan_power_info scan_pwr_info[IWL_NUM_SCAN_RATES];
 };
 
-#define IWL_TX_FIFO_BK		0
+#define IWL_TX_FIFO_BK		0	/* shared */
 #define IWL_TX_FIFO_BE		1
-#define IWL_TX_FIFO_VI		2
+#define IWL_TX_FIFO_VI		2	/* shared */
 #define IWL_TX_FIFO_VO		3
+#define IWL_TX_FIFO_BK_IPAN	IWL_TX_FIFO_BK
+#define IWL_TX_FIFO_BE_IPAN	4
+#define IWL_TX_FIFO_VI_IPAN	IWL_TX_FIFO_VI
+#define IWL_TX_FIFO_VO_IPAN	5
 #define IWL_TX_FIFO_UNUSED	-1
 
 /* Minimum number of queues. MAX_NUM is defined in hw specific files.
@@ -270,6 +274,13 @@ struct iwl_channel_info {
 #define IWL_DEFAULT_CMD_QUEUE_NUM	4
 #define IWL_IPAN_CMD_QUEUE_NUM		9
 
+/*
+ * This queue number is required for proper operation
+ * because the ucode will stop/start the scheduler as
+ * required.
+ */
+#define IWL_IPAN_MCAST_QUEUE		8
+
 /* Power management (not Tx power) structures */
 
 enum iwl_pwr_src {
-- 
1.7.0.4

