Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53534 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab1GUP0o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:26:44 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/25] iwlagn: set correct calibration flag
Date: Thu, 21 Jul 2011 07:50:07 -0700
Message-Id: <1311259828-8415-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110721_172652_061761_82A8EF7E)
In-Reply-To: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set calibration config flag for complete notification

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-commands.h  |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 8936300..f5f5f06 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -190,7 +190,8 @@ static int iwlagn_send_calib_cfg(struct iwl_priv *priv)
 	calib_cfg_cmd.ucd_calib_cfg.once.is_enable = IWL_CALIB_INIT_CFG_ALL;
 	calib_cfg_cmd.ucd_calib_cfg.once.start = IWL_CALIB_INIT_CFG_ALL;
 	calib_cfg_cmd.ucd_calib_cfg.once.send_res = IWL_CALIB_INIT_CFG_ALL;
-	calib_cfg_cmd.ucd_calib_cfg.flags = IWL_CALIB_INIT_CFG_ALL;
+	calib_cfg_cmd.ucd_calib_cfg.flags =
+		IWL_CALIB_CFG_FLAG_SEND_COMPLETE_NTFY_MSK;
 
 	return trans_send_cmd(priv, &cmd);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 324a628..200389d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3168,7 +3168,8 @@ enum {
 
 #define IWL_MAX_PHY_CALIBRATE_TBL_SIZE		(253)
 
-#define IWL_CALIB_INIT_CFG_ALL	cpu_to_le32(0xffffffff)
+#define IWL_CALIB_INIT_CFG_ALL				cpu_to_le32(0xffffffff)
+#define IWL_CALIB_CFG_FLAG_SEND_COMPLETE_NTFY_MSK	cpu_to_le32(BIT(0))
 
 /* This enum defines the bitmap of various calibrations to enable in both
  * init ucode and runtime ucode through CALIBRATION_CFG_CMD.
-- 
1.7.0.4

