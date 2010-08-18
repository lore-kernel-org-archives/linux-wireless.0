Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:49825 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab0HRTtS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 15:49:18 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH wireless-2.6] iwlwifi: use long monitor timer for 5300 series
Date: Wed, 18 Aug 2010 12:53:28 -0700
Message-Id: <1282161208-8587-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For 5000 series of devices, use long monitor timer to check
stuck tx queues.

This modification apply to all the 5000 series including 5300 and others.

Cc: stable@kernel.org [2.6.35]
Reported-by: drago01 <drago01@gmail.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
this patch is also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-5000.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 6bacdd5..b5629a9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -462,7 +462,7 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -493,7 +493,7 @@ struct iwl_cfg iwl5100_bgn_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
-- 
1.7.0.4

