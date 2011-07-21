Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53534 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab1GUP0p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:26:45 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/25] iwlagn: remove legacy calibration command
Date: Thu, 21 Jul 2011 07:50:08 -0700
Message-Id: <1311259828-8415-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110721_172652_622329_B48B0AFB)
In-Reply-To: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IWL_PHY_CALIBRATE_DIFF_GAIN_CMD is for legacy device, remove it

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 200389d..1c0dea2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3155,7 +3155,6 @@ struct iwl_enhance_sensitivity_cmd {
 /* The default calibrate table size if not specified by firmware */
 #define IWL_DEFAULT_STANDARD_PHY_CALIBRATE_TBL_SIZE	18
 enum {
-	IWL_PHY_CALIBRATE_DIFF_GAIN_CMD		= 7,
 	IWL_PHY_CALIBRATE_DC_CMD		= 8,
 	IWL_PHY_CALIBRATE_LO_CMD		= 9,
 	IWL_PHY_CALIBRATE_TX_IQ_CMD		= 11,
@@ -3221,15 +3220,6 @@ struct iwl_calib_cmd {
 	u8 data[0];
 } __packed;
 
-/* IWL_PHY_CALIBRATE_DIFF_GAIN_CMD (7) */
-struct iwl_calib_diff_gain_cmd {
-	struct iwl_calib_hdr hdr;
-	s8 diff_gain_a;		/* see above */
-	s8 diff_gain_b;
-	s8 diff_gain_c;
-	u8 reserved1;
-} __packed;
-
 struct iwl_calib_xtal_freq_cmd {
 	struct iwl_calib_hdr hdr;
 	u8 cap_pin1;
-- 
1.7.0.4

