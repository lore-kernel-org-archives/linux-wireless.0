Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:36760 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbYE2IiB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:38:01 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 42/43] iwlwifi: send calibration results as HUGE commands
Date: Thu, 29 May 2008 16:35:27 +0800
Message-Id: <1212050128-17132-43-git-send-email-yi.zhu@intel.com> (sfid-20080529_103815_949581_73332D96)
In-Reply-To: <1212050128-17132-42-git-send-email-yi.zhu@intel.com>
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-2-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-3-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-4-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-5-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-6-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-7-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-8-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-9-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-10-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-11-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-12-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-13-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-14-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-15-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-16-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-17-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-18-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-19-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-20-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-21-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-22-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-23-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-24-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-25-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-26-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-27-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-28-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-29-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-30-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-31-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-32-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-33-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-34-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-35-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-36-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-37-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-38-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-39-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-40-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-41-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-42-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch saves memory by reducing the size of the entry in the txq. It
was 640 because of the calibration commands. Calibration commands are now
sent as HUGE commands (using the extra 1024 bytes at the end of the command
txq), hence, there is no need for 640 in every entry any more.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |   45 ++++++++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    2 +-
 2 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 9ef4468..7e525ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -428,28 +428,37 @@ static int iwl5000_send_calib_results(struct iwl_priv *priv)
 {
 	int ret = 0;
 
-	if (priv->calib_results.lo_res)
-		ret = iwl_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
-					priv->calib_results.lo_res_len,
-					priv->calib_results.lo_res);
-	if (ret)
-		goto err;
+	struct iwl_host_cmd hcmd = {
+		.id = REPLY_PHY_CALIBRATION_CMD,
+		.meta.flags = CMD_SIZE_HUGE,
+	};
 
+	if (priv->calib_results.lo_res) {
+		hcmd.len = priv->calib_results.lo_res_len;
+		hcmd.data = priv->calib_results.lo_res;
+		ret = iwl_send_cmd_sync(priv, &hcmd);
 
-	if (priv->calib_results.tx_iq_res)
-		ret = iwl_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
-				priv->calib_results.tx_iq_res_len,
-				priv->calib_results.tx_iq_res);
+		if (ret)
+			goto err;
+	}
 
-	if (ret)
-		goto err;
+	if (priv->calib_results.tx_iq_res) {
+		hcmd.len = priv->calib_results.tx_iq_res_len;
+		hcmd.data = priv->calib_results.tx_iq_res;
+		ret = iwl_send_cmd_sync(priv, &hcmd);
 
-	if (priv->calib_results.tx_iq_perd_res)
-		ret = iwl_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
-				      priv->calib_results.tx_iq_perd_res_len,
-				      priv->calib_results.tx_iq_perd_res);
-	if (ret)
-		goto err;
+		if (ret)
+			goto err;
+	}
+
+	if (priv->calib_results.tx_iq_perd_res) {
+		hcmd.len = priv->calib_results.tx_iq_perd_res_len;
+		hcmd.data = priv->calib_results.tx_iq_perd_res;
+		ret = iwl_send_cmd_sync(priv, &hcmd);
+
+		if (ret)
+			goto err;
+	}
 
 	return 0;
 err:
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index a2b9817..802f1a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -307,7 +307,7 @@ struct iwl_cmd_meta {
 
 } __attribute__ ((packed));
 
-#define IWL_CMD_MAX_PAYLOAD 640
+#define IWL_CMD_MAX_PAYLOAD 320
 
 /**
  * struct iwl_cmd
-- 
1.5.3.6

