Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9892 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932967Ab1LFH5I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Dec 2011 02:57:08 -0500
From: Vivek Natarajan <nataraja@qualcomm.com>
To: <rodrigue@qca.qualcomm.com>, <mcgrof@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] compat-wireless: Fix ath6kl debug log issue.
Date: Tue, 6 Dec 2011 13:26:36 +0530
Message-ID: <1323158196-4169-1-git-send-email-nataraja@qca.qualcomm.com> (sfid-20111206_085727_534891_B7F261FD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Like ath9k, the ath6kl debug logs were not shown for kernels < 2.6.36.
This patches fixes the issue.

Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
---
 patches/37-vsnprintk.patch |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/patches/37-vsnprintk.patch b/patches/37-vsnprintk.patch
index 8217de9..fe81956 100644
--- a/patches/37-vsnprintk.patch
+++ b/patches/37-vsnprintk.patch
@@ -1,3 +1,29 @@
+--- a/drivers/net/wireless/ath/ath6kl/debug.c
++++ b/drivers/net/wireless/ath/ath6kl/debug.c
+@@ -39,16 +39,23 @@ struct ath6kl_fwlog_slot {
+ 
+ int ath6kl_printk(const char *level, const char *fmt, ...)
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
+ 	rtn = printk("%sath6kl: %pV", level, &vaf);
++#else
++	printk("%sath6kl: ", level);
++	rtn = vprintk(fmt, args);
++#endif
+ 
+ 	va_end(args);
+ 
 --- a/drivers/net/wireless/ath/main.c
 +++ b/drivers/net/wireless/ath/main.c
 @@ -59,15 +59,22 @@ EXPORT_SYMBOL(ath_rxbuf_alloc);
-- 
1.7.1

