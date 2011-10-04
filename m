Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:56215 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932258Ab1JDO61 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 10:58:27 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3.2] iwlagn: separate init calib and rt calib
Date: Tue,  4 Oct 2011 07:10:19 -0700
Message-Id: <1317737419-2049-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111004_165830_621805_016E0823)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My previous patch for init calib cfg disable a set of calibration for both
init and runtime which cause performance issue, Fix it

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
hese patches will be also available later from wireless branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h |   10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 90ca2d0..afd4b4c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1222,7 +1222,7 @@ static int iwlagn_send_calib_cfg_rt(struct iwl_priv *priv, u32 cfg)
 	};
 
 	memset(&calib_cfg_cmd, 0, sizeof(calib_cfg_cmd));
-	calib_cfg_cmd.ucd_calib_cfg.once.is_enable = IWL_CALIB_INIT_CFG_ALL;
+	calib_cfg_cmd.ucd_calib_cfg.once.is_enable = IWL_CALIB_RT_CFG_ALL;
 	calib_cfg_cmd.ucd_calib_cfg.once.start = cpu_to_le32(cfg);
 
 	return iwl_trans_send_cmd(trans(priv), &cmd);
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 9a5d993..69d5f85 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3216,6 +3216,16 @@ enum iwl_ucode_calib_cfg {
 					IWL_CALIB_CFG_RX_IQ_IDX |	\
 					IWL_CALIB_CFG_CRYSTAL_IDX)
 
+#define IWL_CALIB_RT_CFG_ALL	cpu_to_le32(IWL_CALIB_CFG_RX_BB_IDX |	\
+					IWL_CALIB_CFG_DC_IDX |		\
+					IWL_CALIB_CFG_LO_IDX |		\
+					IWL_CALIB_CFG_TX_IQ_IDX |	\
+					IWL_CALIB_CFG_RX_IQ_IDX |	\
+					IWL_CALIB_CFG_TEMPERATURE_IDX |	\
+					IWL_CALIB_CFG_PAPD_IDX |	\
+					IWL_CALIB_CFG_TX_PWR_IDX |	\
+					IWL_CALIB_CFG_CRYSTAL_IDX)
+
 #define IWL_CALIB_CFG_FLAG_SEND_COMPLETE_NTFY_MSK	cpu_to_le32(BIT(0))
 
 struct iwl_calib_cfg_elmnt_s {
-- 
1.7.0.4

