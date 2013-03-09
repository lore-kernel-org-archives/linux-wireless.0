Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:44845 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab3CINFj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Mar 2013 08:05:39 -0500
Subject: [PATCH v2 5/7] ath6kl: convert ath6kl_info/err/warn macros to real
 functions
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Sat, 09 Mar 2013 15:05:36 +0200
Message-ID: <20130309130536.13371.10441.stgit@localhost6.localdomain6> (sfid-20130309_140541_193474_59BBD67C)
In-Reply-To: <20130309130223.13371.75809.stgit@localhost6.localdomain6>
References: <20130309130223.13371.75809.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After this it's cleaner to add trace calls.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |   51 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/debug.h |   10 ++----
 2 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index c557367..494ecfd 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -56,6 +56,57 @@ int ath6kl_printk(const char *level, const char *fmt, ...)
 }
 EXPORT_SYMBOL(ath6kl_printk);
 
+int ath6kl_info(const char *fmt, ...)
+{
+	struct va_format vaf = {
+		.fmt = fmt,
+	};
+	va_list args;
+	int ret;
+
+	va_start(args, fmt);
+	vaf.va = &args;
+	ret = ath6kl_printk(KERN_INFO, "%pV", &vaf);
+	va_end(args);
+
+	return ret;
+}
+EXPORT_SYMBOL(ath6kl_info);
+
+int ath6kl_err(const char *fmt, ...)
+{
+	struct va_format vaf = {
+		.fmt = fmt,
+	};
+	va_list args;
+	int ret;
+
+	va_start(args, fmt);
+	vaf.va = &args;
+	ret = ath6kl_printk(KERN_ERR, "%pV", &vaf);
+	va_end(args);
+
+	return ret;
+}
+EXPORT_SYMBOL(ath6kl_err);
+
+int ath6kl_warn(const char *fmt, ...)
+{
+	struct va_format vaf = {
+		.fmt = fmt,
+	};
+	va_list args;
+	int ret;
+
+	va_start(args, fmt);
+	vaf.va = &args;
+	ret = ath6kl_printk(KERN_WARNING, "%pV", &vaf);
+	va_end(args);
+
+	return ret;
+}
+EXPORT_SYMBOL(ath6kl_warn);
+
 #ifdef CONFIG_ATH6KL_DEBUG
 
 void ath6kl_dbg(enum ATH6K_DEBUG_MASK mask, const char *fmt, ...)
diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
index f97cd4e..653f2e9 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.h
+++ b/drivers/net/wireless/ath/ath6kl/debug.h
@@ -51,13 +51,9 @@ enum ATH6K_DEBUG_MASK {
 extern unsigned int debug_mask;
 extern __printf(2, 3)
 int ath6kl_printk(const char *level, const char *fmt, ...);
-
-#define ath6kl_info(fmt, ...)				\
-	ath6kl_printk(KERN_INFO, fmt, ##__VA_ARGS__)
-#define ath6kl_err(fmt, ...)					\
-	ath6kl_printk(KERN_ERR, fmt, ##__VA_ARGS__)
-#define ath6kl_warn(fmt, ...)					\
-	ath6kl_printk(KERN_WARNING, fmt, ##__VA_ARGS__)
+extern __printf(1,2) int ath6kl_info(const char *fmt, ...);
+extern __printf(1,2) int ath6kl_err(const char *fmt, ...);
+extern __printf(1,2) int ath6kl_warn(const char *fmt, ...);
 
 enum ath6kl_war {
 	ATH6KL_WAR_INVALID_RATE,

