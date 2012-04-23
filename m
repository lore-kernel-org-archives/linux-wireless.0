Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:47893 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755792Ab2DWVw4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:52:56 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/29] iwlwifi: move iwl_have_debug_level
Date: Mon, 23 Apr 2012 14:47:21 -0700
Message-Id: <1335217660-21950-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235346_633110_936641EF)
In-Reply-To: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This function belongs into the debugging framework.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h  |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-shared.h |    5 -----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index d3e1783..a7f3f33 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -32,6 +32,12 @@
 #include "iwl-shared.h"
 #include "iwl-devtrace.h"
 
+
+static inline bool iwl_have_debug_level(u32 level)
+{
+	return iwlagn_mod_params.debug_level & level;
+}
+
 void __iwl_err(struct device *dev, bool rfkill_prefix, bool only_trace,
 		const char *fmt, ...);
 void __iwl_warn(struct device *dev, const char *fmt, ...);
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 2abf4bb..e37dee4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -121,9 +121,4 @@ struct iwl_mod_params {
 	bool auto_agg;
 };
 
-static inline bool iwl_have_debug_level(u32 level)
-{
-	return iwlagn_mod_params.debug_level & level;
-}
-
 #endif /* #__iwl_shared_h__ */
-- 
1.7.0.4

