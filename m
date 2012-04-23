Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58806 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841Ab2DWVw7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:52:59 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 21/29] iwlwifi: move watchdog definitions to config
Date: Mon, 23 Apr 2012 14:47:32 -0700
Message-Id: <1335217660-21950-22-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235327_354111_630A877A)
In-Reply-To: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since they're used in the config, they
should be declared in iwl-config.h.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-config.h |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 71e6285..70a8f9f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -112,6 +112,12 @@ enum iwl_led_mode {
 #define IWL_MAX_PLCP_ERR_THRESHOLD_MAX		255
 #define IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE	0
 
+/* TX queue watchdog timeouts in mSecs */
+#define IWL_WATCHHDOG_DISABLED	0
+#define IWL_DEF_WD_TIMEOUT	2000
+#define IWL_LONG_WD_TIMEOUT	10000
+#define IWL_MAX_WD_TIMEOUT	120000
+
 
 /*
  * @max_ll_items: max number of OTP blocks
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 80cd942..7994be3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -535,12 +535,6 @@ struct iwl_event_log {
 
 #define IWL_DELAY_NEXT_FORCE_RF_RESET  (HZ*3)
 
-/* TX queue watchdog timeouts in mSecs */
-#define IWL_WATCHHDOG_DISABLED	(0)
-#define IWL_DEF_WD_TIMEOUT	(2000)
-#define IWL_LONG_WD_TIMEOUT	(10000)
-#define IWL_MAX_WD_TIMEOUT	(120000)
-
 /* BT Antenna Coupling Threshold (dB) */
 #define IWL_BT_ANTENNA_COUPLING_THRESHOLD	(35)
 
-- 
1.7.0.4

