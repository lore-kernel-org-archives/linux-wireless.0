Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:64470 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbaEORFI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:05:08 -0400
Received: by mail-wg0-f48.google.com with SMTP id b13so3808455wgh.7
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 10:05:07 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/24] iwlwifi: cause build error on missing newline
Date: Thu, 15 May 2014 20:04:27 +0300
Message-Id: <1400173481-9047-10-git-send-email-egrumbach@gmail.com> (sfid-20140515_190516_905536_05FA3CDF)
In-Reply-To: <5374F373.6040902@gmail.com>
References: <5374F373.6040902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If a (debug) message is missing a newline, cause build error
so we don't keep reintroducing this problem.

This also prevents using a non-constant argument as the format
string which is a good idea anyway (e.g. for security reasons.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h | 41 +++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index c8cbdbe..2950835 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -47,12 +47,32 @@ void __iwl_warn(struct device *dev, const char *fmt, ...) __printf(2, 3);
 void __iwl_info(struct device *dev, const char *fmt, ...) __printf(2, 3);
 void __iwl_crit(struct device *dev, const char *fmt, ...) __printf(2, 3);
 
+/* not all compilers can evaluate strlen() at compile time, so use sizeof() */
+#define CHECK_FOR_NEWLINE(f) BUILD_BUG_ON(f[sizeof(f) - 2] != '\n')
+
 /* No matter what is m (priv, bus, trans), this will work */
-#define IWL_ERR(m, f, a...) __iwl_err((m)->dev, false, false, f, ## a)
-#define IWL_ERR_DEV(d, f, a...) __iwl_err((d), false, false, f, ## a)
-#define IWL_WARN(m, f, a...) __iwl_warn((m)->dev, f, ## a)
-#define IWL_INFO(m, f, a...) __iwl_info((m)->dev, f, ## a)
-#define IWL_CRIT(m, f, a...) __iwl_crit((m)->dev, f, ## a)
+#define IWL_ERR_DEV(d, f, a...)						\
+	do {								\
+		CHECK_FOR_NEWLINE(f);					\
+		__iwl_err((d), false, false, f, ## a);			\
+	} while (0)
+#define IWL_ERR(m, f, a...)						\
+	IWL_ERR_DEV((m)->dev, f, ## a)
+#define IWL_WARN(m, f, a...)						\
+	do {								\
+		CHECK_FOR_NEWLINE(f);					\
+		__iwl_warn((m)->dev, f, ## a);				\
+	} while (0)
+#define IWL_INFO(m, f, a...)						\
+	do {								\
+		CHECK_FOR_NEWLINE(f);					\
+		__iwl_info((m)->dev, f, ## a);				\
+	} while (0)
+#define IWL_CRIT(m, f, a...)						\
+	do {								\
+		CHECK_FOR_NEWLINE(f);					\
+		__iwl_crit((m)->dev, f, ## a);				\
+	} while (0)
 
 #if defined(CONFIG_IWLWIFI_DEBUG) || defined(CONFIG_IWLWIFI_DEVICE_TRACING)
 void __iwl_dbg(struct device *dev,
@@ -72,12 +92,17 @@ do {									\
 		       DUMP_PREFIX_OFFSET, 16, 1, p, len, 1);		\
 } while (0)
 
+#define __IWL_DEBUG_DEV(dev, level, limit, fmt, args...)		\
+	do {								\
+		CHECK_FOR_NEWLINE(fmt);					\
+		__iwl_dbg(dev, level, limit, __func__, fmt, ##args);	\
+	} while (0)
 #define IWL_DEBUG(m, level, fmt, args...)				\
-	__iwl_dbg((m)->dev, level, false, __func__, fmt, ##args)
+	__IWL_DEBUG_DEV((m)->dev, level, false, fmt, ##args)
 #define IWL_DEBUG_DEV(dev, level, fmt, args...)				\
-	__iwl_dbg((dev), level, false, __func__, fmt, ##args)
+	__IWL_DEBUG_DEV(dev, level, false, fmt, ##args)
 #define IWL_DEBUG_LIMIT(m, level, fmt, args...)				\
-	__iwl_dbg((m)->dev, level, true, __func__, fmt, ##args)
+	__IWL_DEBUG_DEV((m)->dev, level, true, fmt, ##args)
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 #define iwl_print_hex_dump(m, level, p, len)				\
-- 
1.8.3.2

