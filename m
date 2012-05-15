Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51028 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932635Ab2EONBU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 09:01:20 -0400
Message-ID: <1337086877.4546.4.camel@jlt3.sipsolutions.net> (sfid-20120515_150123_514896_C25341BD)
Subject: [PATCH] iwlwifi: add __printf argument checking
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 15 May 2012 15:01:17 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Joe Perches suggested adding the __printf attribute
to the __iwl_dbg function to check arguments; add it
to all of the logging functions (err, warn, info, dbg
and crit.)

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
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


