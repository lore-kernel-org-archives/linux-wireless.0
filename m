Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17575 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377Ab0FFG4n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 02:56:43 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/23] iwlwifi: do not clear data after chain noise calib
Date: Sat,  5 Jun 2010 23:56:22 -0700
Message-Id: <1275807398-18184-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
References: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

Chain noise calibration data are cleared after the calibration is done
in iwlagn_gain_computation() and iwl4965_gain_computation(). This cause
the debugfs entries for those data useless. To provide valid debugging
info, clear those data right before starting the calibration instead.

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   19 +++++++++++--------
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |   22 ++++++++++++----------
 2 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 4e377c8..a0669ea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -346,9 +346,19 @@ static void iwl4965_chain_noise_reset(struct iwl_priv *priv)
 {
 	struct iwl_chain_noise_data *data = &(priv->chain_noise_data);
 
-	if ((data->state == IWL_CHAIN_NOISE_ALIVE) && iwl_is_associated(priv)) {
+	if ((data->state == IWL_CHAIN_NOISE_ALIVE) &&
+	     iwl_is_associated(priv)) {
 		struct iwl_calib_diff_gain_cmd cmd;
 
+		/* clear data for chain noise calibration algorithm */
+		data->chain_noise_a = 0;
+		data->chain_noise_b = 0;
+		data->chain_noise_c = 0;
+		data->chain_signal_a = 0;
+		data->chain_signal_b = 0;
+		data->chain_signal_c = 0;
+		data->beacon_count = 0;
+
 		memset(&cmd, 0, sizeof(cmd));
 		cmd.hdr.op_code = IWL_PHY_CALIBRATE_DIFF_GAIN_CMD;
 		cmd.diff_gain_a = 0;
@@ -419,13 +429,6 @@ static void iwl4965_gain_computation(struct iwl_priv *priv,
 		/* Mark so we run this algo only once! */
 		data->state = IWL_CHAIN_NOISE_CALIBRATED;
 	}
-	data->chain_noise_a = 0;
-	data->chain_noise_b = 0;
-	data->chain_noise_c = 0;
-	data->chain_signal_a = 0;
-	data->chain_signal_b = 0;
-	data->chain_signal_c = 0;
-	data->beacon_count = 0;
 }
 
 static void iwl4965_bg_txpower_work(struct work_struct *work)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index 25851ec..3f765ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -176,14 +176,6 @@ static void iwlagn_gain_computation(struct iwl_priv *priv,
 		data->radio_write = 1;
 		data->state = IWL_CHAIN_NOISE_CALIBRATED;
 	}
-
-	data->chain_noise_a = 0;
-	data->chain_noise_b = 0;
-	data->chain_noise_c = 0;
-	data->chain_signal_a = 0;
-	data->chain_signal_b = 0;
-	data->chain_signal_c = 0;
-	data->beacon_count = 0;
 }
 
 static void iwlagn_chain_noise_reset(struct iwl_priv *priv)
@@ -191,10 +183,20 @@ static void iwlagn_chain_noise_reset(struct iwl_priv *priv)
 	struct iwl_chain_noise_data *data = &priv->chain_noise_data;
 	int ret;
 
-	if ((data->state == IWL_CHAIN_NOISE_ALIVE) && iwl_is_associated(priv)) {
+	if ((data->state == IWL_CHAIN_NOISE_ALIVE) &&
+	     iwl_is_associated(priv)) {
 		struct iwl_calib_chain_noise_reset_cmd cmd;
-		memset(&cmd, 0, sizeof(cmd));
 
+		/* clear data for chain noise calibration algorithm */
+		data->chain_noise_a = 0;
+		data->chain_noise_b = 0;
+		data->chain_noise_c = 0;
+		data->chain_signal_a = 0;
+		data->chain_signal_b = 0;
+		data->chain_signal_c = 0;
+		data->beacon_count = 0;
+
+		memset(&cmd, 0, sizeof(cmd));
 		cmd.hdr.op_code = IWL_PHY_CALIBRATE_CHAIN_NOISE_RESET_CMD;
 		cmd.hdr.first_group = 0;
 		cmd.hdr.groups_num = 1;
-- 
1.7.0.4

