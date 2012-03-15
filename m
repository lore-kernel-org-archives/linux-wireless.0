Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58230 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161435Ab2COU2G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 16:28:06 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/26] iwlwifi: use iwlagn_fw_error instead of iwl_nic_error
Date: Thu, 15 Mar 2012 13:26:54 -0700
Message-Id: <1331843226-29860-15-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120315_212839_677798_E9059B17)
In-Reply-To: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

In the process, make iwlagn_fw_error
a non-static function, as it is used
by more than one file.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h  |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index fa18968..3c49c04 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1562,7 +1562,7 @@ static void iwl_cmd_queue_full(struct iwl_op_mode *op_mode)
 
 	if (!iwl_check_for_ct_kill(priv)) {
 		IWL_ERR(priv, "Restarting adapter queue is full\n");
-		iwl_nic_error(op_mode);
+		iwlagn_fw_error(priv, false);
 	}
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 436611c..22fc363 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -132,6 +132,7 @@ int iwl_send_calib_results(struct iwl_priv *priv);
 int iwl_calib_set(struct iwl_priv *priv,
 		  const struct iwl_calib_hdr *cmd, int len);
 void iwl_calib_free_results(struct iwl_priv *priv);
+void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand);
 
 /* lib */
 int iwlagn_send_tx_power(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 46490d3..e59cb5b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -828,7 +828,7 @@ void iwl_print_rx_config_cmd(struct iwl_priv *priv,
 }
 #endif
 
-static void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
+void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 {
 	unsigned int reload_msec;
 	unsigned long reload_jiffies;
-- 
1.7.0.4

