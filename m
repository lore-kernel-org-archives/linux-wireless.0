Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32093 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbXLCLpM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 06:45:12 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ben Cahill <ben.m.cahill@intel.com>
Subject: [PATCH 20/34] iwlwifi: document temperature calculation
Date: Mon,  3 Dec 2007 13:43:32 +0200
Message-Id: <11966822314158-git-send-email-tomas.winkler@intel.com> (sfid-20071203_120558_257561_614D494A)
In-Reply-To: <11966822311588-git-send-email-tomas.winkler@intel.com>
References: <11966822261109-git-send-email-tomas.winkler@intel.com>
 <11966822291406-git-send-email-tomas.winkler@intel.com>
 <1196682229843-git-send-email-tomas.winkler@intel.com>
 <11966822293932-git-send-email-tomas.winkler@intel.com>
 <11966822291956-git-send-email-tomas.winkler@intel.com>
 <119668222978-git-send-email-tomas.winkler@intel.com>
 <11966822293340-git-send-email-tomas.winkler@intel.com>
 <11966822291143-git-send-email-tomas.winkler@intel.com>
 <11966822301152-git-send-email-tomas.winkler@intel.com>
 <11966822302864-git-send-email-tomas.winkler@intel.com>
 <1196682230902-git-send-email-tomas.winkler@intel.com>
 <11966822302932-git-send-email-tomas.winkler@intel.com>
 <11966822302681-git-send-email-tomas.winkler@intel.com>
 <11966822301936-git-send-email-tomas.winkler@intel.com>
 <11966822302007-git-send-email-tomas.winkler@intel.com>
 <1196682230754-git-send-email-tomas.winkler@intel.com>
 <1196682231211-git-send-email-tomas.winkler@intel.com>
 <11966822313647-git-send-email-tomas.winkler@intel.com>
 <11966822312049-git-send-email-tomas.winkler@intel.com>
 <11966822311588-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Document temperature calculation

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h |   57 ++++++++++++++++++++++-----
 1 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index 439ef64..412becf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -645,21 +645,43 @@ static inline int iwl4965_hw_valid_rtc_data_addr(u32 addr)
 	       (addr < KDR_RTC_DATA_UPPER_BOUND);
 }
 
-/********************* START TXPOWER *****************************************/
-
-enum {
-	CALIB_CH_GROUP_1 = 0,
-	CALIB_CH_GROUP_2 = 1,
-	CALIB_CH_GROUP_3 = 2,
-	CALIB_CH_GROUP_4 = 3,
-	CALIB_CH_GROUP_5 = 4,
-	CALIB_CH_GROUP_MAX
-};
+/********************* START TEMPERATURE *************************************/
 
-/* Temperature calibration offset is 3% 0C in Kelvin */
+/*
+ * 4965 temperature calculation.
+ *
+ * The driver must calculate the device temperature before calculating
+ * a txpower setting (amplifier gain is temperature dependent).  The
+ * calculation uses 4 measurements, 3 of which (R1, R2, R3) are calibration
+ * values used for the life of the driver, and one of which (R4) is the
+ * real-time temperature indicator.
+ *
+ * uCode provides all 4 values to the driver via the "initialize alive"
+ * notification (see struct iwl4965_init_alive_resp).  After the runtime uCode
+ * image loads, uCode updates the R4 value via statistics notifications
+ * (see STATISTICS_NOTIFICATION), which occur after each received beacon
+ * when associated, or can be requested via REPLY_STATISTICS_CMD.
+ *
+ * NOTE:  uCode provides the R4 value as a 23-bit signed value.  Driver
+ *        must sign-extend to 32 bits before applying formula below.
+ *
+ * Formula:
+ *
+ * degrees Kelvin = ((97 * 259 * (R4 - R2) / (R3 - R1)) / 100) + 8
+ *
+ * NOTE:  The basic formula is 259 * (R4-R2) / (R3-R1).  The 97/100 is
+ * an additional correction, which should be centered around 0 degrees
+ * Celsius (273 degrees Kelvin).  The 8 (3 percent of 273) compensates for
+ * centering the 97/100 correction around 0 degrees K.
+ *
+ * Add 273 to Kelvin value to find degrees Celsius, for comparing current
+ * temperature with factory-measured temperatures when calculating txpower
+ * settings.
+ */
 #define TEMPERATURE_CALIB_KELVIN_OFFSET 8
 #define TEMPERATURE_CALIB_A_VAL 259
 
+/* Limit range of calculated temperature to be between these Kelvin values */
 #define IWL_TX_POWER_TEMPERATURE_MIN  (263)
 #define IWL_TX_POWER_TEMPERATURE_MAX  (410)
 
@@ -667,6 +689,19 @@ enum {
 	(((t) < IWL_TX_POWER_TEMPERATURE_MIN) || \
 	 ((t) > IWL_TX_POWER_TEMPERATURE_MAX))
 
+/********************* END TEMPERATURE ***************************************/
+
+/********************* START TXPOWER *****************************************/
+
+enum {
+	CALIB_CH_GROUP_1 = 0,
+	CALIB_CH_GROUP_2 = 1,
+	CALIB_CH_GROUP_3 = 2,
+	CALIB_CH_GROUP_4 = 3,
+	CALIB_CH_GROUP_5 = 4,
+	CALIB_CH_GROUP_MAX
+};
+
 #define IWL_TX_POWER_MIMO_REGULATORY_COMPENSATION (6)
 
 #define IWL_TX_POWER_TARGET_POWER_MIN       (0)	/* 0 dBm = 1 milliwatt */
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
