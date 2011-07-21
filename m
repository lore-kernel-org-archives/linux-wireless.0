Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53534 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab1GUP0p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:26:45 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/25] iwlagn: define valid init calibration mask
Date: Thu, 21 Jul 2011 07:50:09 -0700
Message-Id: <1311259828-8415-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110721_172649_613119_EDBD2087)
In-Reply-To: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the valid calibration mask for init calibration

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 1c0dea2..d7f20c8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3167,9 +3167,6 @@ enum {
 
 #define IWL_MAX_PHY_CALIBRATE_TBL_SIZE		(253)
 
-#define IWL_CALIB_INIT_CFG_ALL				cpu_to_le32(0xffffffff)
-#define IWL_CALIB_CFG_FLAG_SEND_COMPLETE_NTFY_MSK	cpu_to_le32(BIT(0))
-
 /* This enum defines the bitmap of various calibrations to enable in both
  * init ucode and runtime ucode through CALIBRATION_CFG_CMD.
  */
@@ -3187,6 +3184,19 @@ enum iwl_ucode_calib_cfg {
 	IWL_CALIB_CFG_TX_PWR_IDX		= BIT(10),
 };
 
+#define IWL_CALIB_INIT_CFG_ALL	cpu_to_le32(IWL_CALIB_CFG_RX_BB_IDX |	\
+					IWL_CALIB_CFG_DC_IDX |		\
+					IWL_CALIB_CFG_LO_IDX |		\
+					IWL_CALIB_CFG_TX_IQ_IDX |	\
+					IWL_CALIB_CFG_RX_IQ_IDX |	\
+					IWL_CALIB_CFG_NOISE_IDX |	\
+					IWL_CALIB_CFG_CRYSTAL_IDX |	\
+					IWL_CALIB_CFG_TEMPERATURE_IDX |	\
+					IWL_CALIB_CFG_PAPD_IDX |	\
+					IWL_CALIB_CFG_SENSITIVITY_IDX |	\
+					IWL_CALIB_CFG_TX_PWR_IDX)
+
+#define IWL_CALIB_CFG_FLAG_SEND_COMPLETE_NTFY_MSK	cpu_to_le32(BIT(0))
 
 struct iwl_calib_cfg_elmnt_s {
 	__le32 is_enable;
-- 
1.7.0.4

