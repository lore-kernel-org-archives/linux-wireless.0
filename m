Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:42532 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab2L0Lw5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 06:52:57 -0500
Subject: [PATCH 5/7] ath6kl: convert ath6kl_info/err/warn macros to real
	functions
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com
Date: Thu, 27 Dec 2012 13:44:47 +0200
Message-ID: <20121227114447.27069.54329.stgit@localhost6.localdomain6> (sfid-20121227_125310_781763_6DBF0411)
In-Reply-To: <20121227114156.27069.30223.stgit@localhost6.localdomain6>
References: <20121227114156.27069.30223.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After this it's cleaner to add trace calls. And besides, I prefer C over
CPP.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.h |   53 +++++++++++++++++++++++++++----
 1 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
index f97cd4e..06f47f5 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.h
+++ b/drivers/net/wireless/ath/ath6kl/debug.h
@@ -52,12 +52,53 @@ extern unsigned int debug_mask;
 extern __printf(2, 3)
 int ath6kl_printk(const char *level, const char *fmt, ...);
 
-#define ath6kl_info(fmt, ...)				\
-	ath6kl_printk(KERN_INFO, fmt, ##__VA_ARGS__)
-#define ath6kl_err(fmt, ...)					\
-	ath6kl_printk(KERN_ERR, fmt, ##__VA_ARGS__)
-#define ath6kl_warn(fmt, ...)					\
-	ath6kl_printk(KERN_WARNING, fmt, ##__VA_ARGS__)
+static inline __printf(1,2) int ath6kl_info(const char *fmt, ...)
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
+
+static inline __printf(1,2) int ath6kl_err(const char *fmt, ...)
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
+
+static inline __printf(1,2) int ath6kl_warn(const char *fmt, ...)
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
 
 enum ath6kl_war {
 	ATH6KL_WAR_INVALID_RATE,

