Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47950 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193Ab1GUP0v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:26:51 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 21/25] iwlagn: write iq invert register for 105/135 device
Date: Thu, 21 Jul 2011 07:50:24 -0700
Message-Id: <1311259828-8415-22-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110721_172719_489171_19EF8C88)
In-Reply-To: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For 105/135 series of devices, we need to do I/Q invert just like 2000
series devices.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index aff555c..00480e4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -319,7 +319,8 @@ struct iwl_cfg iwl2030_2bg_cfg = {
 	.need_temp_offset_calib = true,				\
 	.led_mode = IWL_LED_RF_STATE,				\
 	.adv_pm = true,						\
-	.rx_with_siso_diversity = true				\
+	.rx_with_siso_diversity = true,				\
+	.iq_invert = true					\
 
 struct iwl_cfg iwl105_bg_cfg = {
 	.name = "105 Series 1x1 BG",
@@ -345,7 +346,8 @@ struct iwl_cfg iwl105_bgn_cfg = {
 	.need_temp_offset_calib = true,				\
 	.led_mode = IWL_LED_RF_STATE,				\
 	.adv_pm = true,						\
-	.rx_with_siso_diversity = true				\
+	.rx_with_siso_diversity = true,				\
+	.iq_invert = true					\
 
 struct iwl_cfg iwl135_bg_cfg = {
 	.name = "135 Series 1x1 BG/BT",
-- 
1.7.0.4

