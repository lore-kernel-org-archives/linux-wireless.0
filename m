Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32825 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755836Ab2DWVw6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:52:58 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 20/29] iwlwifi: move PLCP defines to config
Date: Mon, 23 Apr 2012 14:47:31 -0700
Message-Id: <1335217660-21950-21-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235342_346783_A32A7936)
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
 drivers/net/wireless/iwlwifi/iwl-config.h |   12 ++++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h    |   11 -----------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 47bfd5e..71e6285 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -102,6 +102,18 @@ enum iwl_led_mode {
 };
 
 /*
+ * This is the threshold value of plcp error rate per 100mSecs.  It is
+ * used to set and check for the validity of plcp_delta.
+ */
+#define IWL_MAX_PLCP_ERR_THRESHOLD_MIN		1
+#define IWL_MAX_PLCP_ERR_THRESHOLD_DEF		50
+#define IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF	100
+#define IWL_MAX_PLCP_ERR_EXT_LONG_THRESHOLD_DEF	200
+#define IWL_MAX_PLCP_ERR_THRESHOLD_MAX		255
+#define IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE	0
+
+
+/*
  * @max_ll_items: max number of OTP blocks
  * @shadow_ram_support: shadow support for OTP memory
  * @led_compensation: compensate on the led on/off time per HW according
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 6853fc7..80cd942 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -533,17 +533,6 @@ struct iwl_event_log {
 	int wraps_more_count;
 };
 
-/*
- * This is the threshold value of plcp error rate per 100mSecs.  It is
- * used to set and check for the validity of plcp_delta.
- */
-#define IWL_MAX_PLCP_ERR_THRESHOLD_MIN	(1)
-#define IWL_MAX_PLCP_ERR_THRESHOLD_DEF	(50)
-#define IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF	(100)
-#define IWL_MAX_PLCP_ERR_EXT_LONG_THRESHOLD_DEF	(200)
-#define IWL_MAX_PLCP_ERR_THRESHOLD_MAX	(255)
-#define IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE	(0)
-
 #define IWL_DELAY_NEXT_FORCE_RF_RESET  (HZ*3)
 
 /* TX queue watchdog timeouts in mSecs */
-- 
1.7.0.4

