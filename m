Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:25118 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757085Ab0GWQNz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 12:13:55 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/10] iwlagn: add .cfg flag to idenfity the need for bt statistics
Date: Fri, 23 Jul 2010 09:15:31 -0700
Message-Id: <1279901739-10541-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1279901739-10541-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1279901739-10541-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Only WiFi/BT combo devices need to use bluetooth version of statistics
notification; adding the flag in .cfg file to indicate the need for
using different data structure.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 0955219..a4e58d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -500,6 +500,7 @@ struct iwl_cfg iwl6000g2b_2agn_cfg = {
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
 	.need_dc_calib = true,
+	.bt_statistics = true,
 };
 
 struct iwl_cfg iwl6000g2b_2abg_cfg = {
@@ -535,6 +536,7 @@ struct iwl_cfg iwl6000g2b_2abg_cfg = {
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
 	.need_dc_calib = true,
+	.bt_statistics = true,
 };
 
 struct iwl_cfg iwl6000g2b_2bgn_cfg = {
@@ -572,6 +574,7 @@ struct iwl_cfg iwl6000g2b_2bgn_cfg = {
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
 	.need_dc_calib = true,
+	.bt_statistics = true,
 };
 
 struct iwl_cfg iwl6000g2b_2bg_cfg = {
@@ -607,6 +610,7 @@ struct iwl_cfg iwl6000g2b_2bg_cfg = {
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
 	.need_dc_calib = true,
+	.bt_statistics = true,
 };
 
 struct iwl_cfg iwl6000g2b_bgn_cfg = {
@@ -644,6 +648,7 @@ struct iwl_cfg iwl6000g2b_bgn_cfg = {
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
 	.need_dc_calib = true,
+	.bt_statistics = true,
 };
 
 struct iwl_cfg iwl6000g2b_bg_cfg = {
@@ -679,6 +684,7 @@ struct iwl_cfg iwl6000g2b_bg_cfg = {
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
 	.need_dc_calib = true,
+	.bt_statistics = true,
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index fcbba3d..2954a52 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -335,6 +335,7 @@ struct iwl_cfg {
 	u8 scan_rx_antennas[IEEE80211_NUM_BANDS];
 	u8 scan_tx_antennas[IEEE80211_NUM_BANDS];
 	const bool need_dc_calib;
+	const bool bt_statistics;
 };
 
 /***************************
-- 
1.7.0.4

