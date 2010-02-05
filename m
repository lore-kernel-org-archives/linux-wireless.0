Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49135 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751Ab0BETeQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 14:34:16 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ben Cahill <ben.m.cahill@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/3] iwlwifi: Add chain noise scaling factor
Date: Fri,  5 Feb 2010 11:33:46 -0800
Message-Id: <1265398428-8048-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1265398428-8048-1-git-send-email-reinette.chatre@intel.com>
References: <1265398428-8048-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

6x50 device requires a different scaling factor for Rx gain values sent to
device via PHY_CALIBRATION_CMD (CHAIN_NOISE_GAIN_CMD).  Rather than create
a new iwlXXXX_gain_computation() function, add new chain_noise_scale member
to struct iwl_cfg, and keep using iwl5000_gain_computation().

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    2 ++
 drivers/net/wireless/iwlwifi/iwl-5000.c |   21 +++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-6000.c |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 +
 4 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 9d18206..694ceef 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -247,6 +247,7 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.chain_noise_scale = 1000,
 };
 
 struct iwl_cfg iwl1000_bg_cfg = {
@@ -274,6 +275,7 @@ struct iwl_cfg iwl1000_bg_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.chain_noise_scale = 1000,
 };
 
 MODULE_FIRMWARE(IWL1000_MODULE_FIRMWARE(IWL1000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 6d59889..f3d662c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -179,14 +179,24 @@ static void iwl5000_gain_computation(struct iwl_priv *priv,
 			data->delta_gain_code[i] = 0;
 			continue;
 		}
-		delta_g = (1000 * ((s32)average_noise[default_chain] -
+
+		delta_g = (priv->cfg->chain_noise_scale *
+			((s32)average_noise[default_chain] -
 			(s32)average_noise[i])) / 1500;
+
 		/* bound gain by 2 bits value max, 3rd bit is sign */
 		data->delta_gain_code[i] =
 			min(abs(delta_g), (long) CHAIN_NOISE_MAX_DELTA_GAIN_CODE);
 
 		if (delta_g < 0)
-			/* set negative sign */
+			/*
+			 * set negative sign ...
+			 * note to Intel developers:  This is uCode API format,
+			 *   not the format of any internal device registers.
+			 *   Do not change this format for e.g. 6050 or similar
+			 *   devices.  Change format only if more resolution
+			 *   (i.e. more than 2 bits magnitude) is needed.
+			 */
 			data->delta_gain_code[i] |= (1 << 2);
 	}
 
@@ -1587,6 +1597,7 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
+	.chain_noise_scale = 1000,
 };
 
 struct iwl_cfg iwl5100_bgn_cfg = {
@@ -1612,6 +1623,7 @@ struct iwl_cfg iwl5100_bgn_cfg = {
 	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
+	.chain_noise_scale = 1000,
 };
 
 struct iwl_cfg iwl5100_abg_cfg = {
@@ -1635,6 +1647,7 @@ struct iwl_cfg iwl5100_abg_cfg = {
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
+	.chain_noise_scale = 1000,
 };
 
 struct iwl_cfg iwl5100_agn_cfg = {
@@ -1660,6 +1673,7 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
+	.chain_noise_scale = 1000,
 };
 
 struct iwl_cfg iwl5350_agn_cfg = {
@@ -1685,6 +1699,7 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
+	.chain_noise_scale = 1000,
 };
 
 struct iwl_cfg iwl5150_agn_cfg = {
@@ -1710,6 +1725,7 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
+	.chain_noise_scale = 1000,
 };
 
 struct iwl_cfg iwl5150_abg_cfg = {
@@ -1733,6 +1749,7 @@ struct iwl_cfg iwl5150_abg_cfg = {
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
+	.chain_noise_scale = 1000,
 };
 
 MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index a9f8551..1719825 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -324,6 +324,7 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.chain_noise_scale = 1000,
 };
 
 struct iwl_cfg iwl6000i_2abg_cfg = {
@@ -354,6 +355,7 @@ struct iwl_cfg iwl6000i_2abg_cfg = {
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.chain_noise_scale = 1000,
 };
 
 struct iwl_cfg iwl6000i_2bg_cfg = {
@@ -384,6 +386,7 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.chain_noise_scale = 1000,
 };
 
 struct iwl_cfg iwl6050_2agn_cfg = {
@@ -415,6 +418,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.chain_noise_scale = 1500,
 };
 
 struct iwl_cfg iwl6050_2abg_cfg = {
@@ -445,6 +449,7 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.chain_noise_scale = 1500,
 };
 
 struct iwl_cfg iwl6000_3agn_cfg = {
@@ -476,6 +481,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.chain_noise_scale = 1000,
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index ec1fe1d..49795b9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -293,6 +293,7 @@ struct iwl_cfg {
 	bool support_ct_kill_exit;
 	const bool support_wimax_coexist;
 	u8 plcp_delta_threshold;
+	s32 chain_noise_scale;
 };
 
 /***************************
-- 
1.6.3.3

