Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:48588 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644Ab1AaLh4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 06:37:56 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 03:37:36 -0800
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <Luis.rodriguez@atheors.com>, <mcgrof@gmail.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 1/1] compat-wireless: Fix ath9k debug log issue.
Date: Mon, 31 Jan 2011 17:07:45 +0530
Message-ID: <1296473865-18529-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k debug logs are not shown as we are using recursive vsnprintf
which are supported in kernel 2.6.36 and above. use vprintk for older
kernels.

This patch has fixed the issue.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 patches/37-vsnprintk.patch |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)
 create mode 100644 patches/37-vsnprintk.patch

diff --git a/patches/37-vsnprintk.patch b/patches/37-vsnprintk.patch
new file mode 100644
index 0000000..93d1a00
--- /dev/null
+++ b/patches/37-vsnprintk.patch
@@ -0,0 +1,28 @@
+diff --git a/drivers/net/wireless/ath/main.c b/drivers/net/wireless/ath/main.c
+index c325202..e3e60d4 100644
+--- a/drivers/net/wireless/ath/main.c
++++ b/drivers/net/wireless/ath/main.c
+@@ -60,16 +60,23 @@ EXPORT_SYMBOL(ath_rxbuf_alloc);
+ int ath_printk(const char *level, struct ath_common *common,
+ 	       const char *fmt, ...)
+ {
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	struct va_format vaf;
++#endif
+ 	va_list args;
+ 	int rtn;
+ 
+ 	va_start(args, fmt);
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	vaf.fmt = fmt;
+ 	vaf.va = &args;
+ 
+ 	rtn = printk("%sath: %pV", level, &vaf);
++#else
++	printk("%sath: ", level);
++	rtn = vprintk(fmt, args);
++#endif
+ 
+ 	va_end(args);
+ 
-- 
1.7.0.4

