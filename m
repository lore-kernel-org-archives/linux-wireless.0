Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38318 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab2EPUk5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 16:40:57 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/3] iwlwifi: add __printf argument checking
Date: Wed, 16 May 2012 22:40:51 +0200
Message-Id: <1337200851-20469-4-git-send-email-johannes@sipsolutions.net> (sfid-20120516_224111_220363_A215918A)
In-Reply-To: <1337200851-20469-1-git-send-email-johannes@sipsolutions.net>
References: <1337200851-20469-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Joe Perches suggested adding the __printf attribute
to the __iwl_dbg function to check arguments; add it
to all of the logging functions (err, warn, info, dbg
and crit.)

Change-Id: I7a2ffcd3f625ff29c65519b0c3d474bace884f9d
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-on: http://git-mwg.jer.intel.com/gerrit/2022
Tested-by: Jenkins
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 8376b84..f6bf91c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -38,10 +38,10 @@ static inline bool iwl_have_debug_level(u32 level)
 }
 
 void __iwl_err(struct device *dev, bool rfkill_prefix, bool only_trace,
-		const char *fmt, ...);
-void __iwl_warn(struct device *dev, const char *fmt, ...);
-void __iwl_info(struct device *dev, const char *fmt, ...);
-void __iwl_crit(struct device *dev, const char *fmt, ...);
+		const char *fmt, ...) __printf(4, 5);
+void __iwl_warn(struct device *dev, const char *fmt, ...) __printf(2, 3);
+void __iwl_info(struct device *dev, const char *fmt, ...) __printf(2, 3);
+void __iwl_crit(struct device *dev, const char *fmt, ...) __printf(2, 3);
 
 /* No matter what is m (priv, bus, trans), this will work */
 #define IWL_ERR(m, f, a...) __iwl_err((m)->dev, false, false, f, ## a)
@@ -52,9 +52,9 @@ void __iwl_crit(struct device *dev, const char *fmt, ...);
 #if defined(CONFIG_IWLWIFI_DEBUG) || defined(CONFIG_IWLWIFI_DEVICE_TRACING)
 void __iwl_dbg(struct device *dev,
 	       u32 level, bool limit, const char *function,
-	       const char *fmt, ...);
+	       const char *fmt, ...) __printf(5, 6);
 #else
-static inline void
+__printf(5, 6) static inline void
 __iwl_dbg(struct device *dev,
 	  u32 level, bool limit, const char *function,
 	  const char *fmt, ...)
-- 
1.7.10

