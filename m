Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:39511 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab0FYWnK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jun 2010 18:43:10 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 8/8] iwlwifi: add disable rf calibration support for 6000g2a and 6000g2b
Date: Fri, 25 Jun 2010 15:43:01 -0700
Message-Id: <1277505781-25268-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1277505781-25268-1-git-send-email-reinette.chatre@intel.com>
References: <1277505781-25268-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Radio calibration (chain noise and sensitivity) should be allowed to
be disabled from debugfs if compiled with CONFIG_IWLWIFI_DEBUGFS. For both
6000g2a and 6000g2b, the parameters are missing in "cfg", which cause
user can not disable the radio calibration manually; add the support to
allow the operation.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 61cf0b3..8577664 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -423,6 +423,8 @@ struct iwl_cfg iwl6000g2a_2abg_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
 	.need_dc_calib = true,
 };
 
@@ -456,6 +458,8 @@ struct iwl_cfg iwl6000g2a_2bg_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
 	.need_dc_calib = true,
 };
 
@@ -491,6 +495,8 @@ struct iwl_cfg iwl6000g2b_2agn_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
 	.need_dc_calib = true,
 };
 
@@ -524,6 +530,8 @@ struct iwl_cfg iwl6000g2b_2abg_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
 	.need_dc_calib = true,
 };
 
@@ -559,6 +567,8 @@ struct iwl_cfg iwl6000g2b_2bgn_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
 	.need_dc_calib = true,
 };
 
@@ -592,6 +602,8 @@ struct iwl_cfg iwl6000g2b_2bg_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
 	.need_dc_calib = true,
 };
 
@@ -627,6 +639,8 @@ struct iwl_cfg iwl6000g2b_bgn_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
 	.need_dc_calib = true,
 };
 
@@ -660,6 +674,8 @@ struct iwl_cfg iwl6000g2b_bg_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
 	.need_dc_calib = true,
 };
 
-- 
1.7.0.4

