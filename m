Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58806 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755829Ab2DWVw7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:52:59 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 23/29] iwlwifi: move antenna definitions to config
Date: Mon, 23 Apr 2012 14:47:34 -0700
Message-Id: <1335217660-21950-24-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235312_025431_29D856B5)
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
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h |   10 +---------
 drivers/net/wireless/iwlwifi/iwl-config.h |   10 ++++++++++
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index 351717a..82d02e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -30,6 +30,7 @@
 #include <net/mac80211.h>
 
 #include "iwl-commands.h"
+#include "iwl-config.h"
 
 struct iwl_rate_info {
 	u8 plcp;	/* uCode API:  IWL_RATE_6M_PLCP, etc. */
@@ -280,15 +281,6 @@ enum iwl_table_type {
 #define is_a_band(tbl) ((tbl) == LQ_A)
 #define is_g_and(tbl) ((tbl) == LQ_G)
 
-#define	ANT_NONE	0x0
-#define	ANT_A		BIT(0)
-#define	ANT_B		BIT(1)
-#define	ANT_AB		(ANT_A | ANT_B)
-#define ANT_C		BIT(2)
-#define	ANT_AC		(ANT_A | ANT_C)
-#define ANT_BC		(ANT_B | ANT_C)
-#define ANT_ABC		(ANT_AB | ANT_C)
-
 #define IWL_MAX_MCS_DISPLAY_SIZE	12
 
 struct iwl_rate_mcs_info {
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 70a8f9f..67b28aa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -118,6 +118,16 @@ enum iwl_led_mode {
 #define IWL_LONG_WD_TIMEOUT	10000
 #define IWL_MAX_WD_TIMEOUT	120000
 
+/* Antenna presence definitions */
+#define	ANT_NONE	0x0
+#define	ANT_A		BIT(0)
+#define	ANT_B		BIT(1)
+#define ANT_C		BIT(2)
+#define	ANT_AB		(ANT_A | ANT_B)
+#define	ANT_AC		(ANT_A | ANT_C)
+#define ANT_BC		(ANT_B | ANT_C)
+#define ANT_ABC		(ANT_A | ANT_B | ANT_C)
+
 
 /*
  * @max_ll_items: max number of OTP blocks
-- 
1.7.0.4

