Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:18467 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756354AbYCECKS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 21:10:18 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 01/11] iwlwifi: removing unused priv->config
Date: Tue,  4 Mar 2008 18:09:22 -0800
Message-Id: <1204682972-26004-2-git-send-email-reinette.chatre@intel.com> (sfid-20080305_021050_817068_6F2562D8)
In-Reply-To: <1204682972-26004-1-git-send-email-reinette.chatre@intel.com>
References: <1204682972-26004-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch removes unused variable in iwlYYYY_priv

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 +--
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    3 +--
 4 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index dde389d..d36ae00 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -800,7 +800,6 @@ struct iwl3945_priv {
 	struct iwl3945_tx_queue txq[IWL_MAX_NUM_QUEUES];
 
 	unsigned long status;
-	u32 config;
 
 	int last_rx_rssi;	/* From Rx packet statisitics */
 	int last_rx_noise;	/* From beacon statistics */
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index ce17e4f..cc0745b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -1104,7 +1104,6 @@ struct iwl4965_priv {
 	u32 scd_base_addr;	/* scheduler sram base address */
 
 	unsigned long status;
-	u32 config;
 
 	int last_rx_rssi;	/* From Rx packet statisitics */
 	int last_rx_noise;	/* From beacon statistics */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 0fab832..139a4a2 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4506,8 +4506,7 @@ static void iwl3945_dump_nic_error_log(struct iwl3945_priv *priv)
 
 	if (ERROR_START_OFFSET <= count * ERROR_ELEM_SIZE) {
 		IWL_ERROR("Start IWL Error Log Dump:\n");
-		IWL_ERROR("Status: 0x%08lX, Config: %08X count: %d\n",
-			  priv->status, priv->config, count);
+		IWL_ERROR("Status: 0x%08lX, count: %d\n", priv->status, count);
 	}
 
 	IWL_ERROR("Desc       Time       asrtPC  blink2 "
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 20d012d..99a9f82 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -4886,8 +4886,7 @@ static void iwl4965_dump_nic_error_log(struct iwl4965_priv *priv)
 
 	if (ERROR_START_OFFSET <= count * ERROR_ELEM_SIZE) {
 		IWL_ERROR("Start IWL Error Log Dump:\n");
-		IWL_ERROR("Status: 0x%08lX, Config: %08X count: %d\n",
-			  priv->status, priv->config, count);
+		IWL_ERROR("Status: 0x%08lX, count: %d\n", priv->status, count);
 	}
 
 	desc = iwl4965_read_targ_mem(priv, base + 1 * sizeof(u32));
-- 
1.5.3.4

