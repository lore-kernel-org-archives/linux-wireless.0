Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbcD1TTR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2016 15:19:17 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 05/11] rtl8xxxu: move rtl8188[cr] and rtl8192c related code into rtl8xxxu_8192c.c
Date: Thu, 28 Apr 2016 15:19:09 -0400
Message-Id: <1461871155-11826-6-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160428_211935_804211_EAC16931)
In-Reply-To: <1461871155-11826-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1461871155-11826-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This moves the code for rtl8188c, rtl8188r, and rtl8192c into it's own
file. This is purely a code moving exercise, there is no change to the
code itself.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/Makefile     |   2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |   1 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c | 588 +++++++++++++++++++++
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  | 567 --------------------
 4 files changed, 590 insertions(+), 568 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/Makefile b/drivers/net/wireless/realtek/rtl8xxxu/Makefile
index 7bdce80..1cf951e 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/Makefile
+++ b/drivers/net/wireless/realtek/rtl8xxxu/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_RTL8XXXU)	+= rtl8xxxu.o
 
 rtl8xxxu-y	:= rtl8xxxu_core.o rtl8xxxu_8192e.o rtl8xxxu_8723b.o \
-		   rtl8xxxu_8723a.o
+		   rtl8xxxu_8723a.o rtl8xxxu_8192c.o
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 6d179d6..d532933 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1421,6 +1421,7 @@ int rtl8xxxu_gen2_channel_to_group(int channel);
 bool rtl8xxxu_gen2_simularity_compare(struct rtl8xxxu_priv *priv,
 				      int result[][8], int c1, int c2);
 
+extern struct rtl8xxxu_fileops rtl8192cu_fops;
 extern struct rtl8xxxu_fileops rtl8192eu_fops;
 extern struct rtl8xxxu_fileops rtl8723au_fops;
 extern struct rtl8xxxu_fileops rtl8723bu_fops;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c
new file mode 100644
index 0000000..242bf0e
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c
@@ -0,0 +1,588 @@
+/*
+ * RTL8XXXU mac80211 USB driver - 8188c/8188r/8192c specific subdriver
+ *
+ * Copyright (c) 2014 - 2016 Jes Sorensen <Jes.Sorensen@redhat.com>
+ *
+ * Portions, notably calibration code:
+ * Copyright(c) 2007 - 2011 Realtek Corporation. All rights reserved.
+ *
+ * This driver was written as a replacement for the vendor provided
+ * rtl8723au driver. As the Realtek 8xxx chips are very similar in
+ * their programming interface, I have started adding support for
+ * additional 8xxx chips like the 8192cu, 8188cus, etc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/list.h>
+#include <linux/usb.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
+#include <linux/wireless.h>
+#include <linux/firmware.h>
+#include <linux/moduleparam.h>
+#include <net/mac80211.h>
+#include "rtl8xxxu.h"
+#include "rtl8xxxu_regs.h"
+
+#ifdef CONFIG_RTL8XXXU_UNTESTED
+static struct rtl8xxxu_power_base rtl8192c_power_base = {
+	.reg_0e00 = 0x07090c0c,
+	.reg_0e04 = 0x01020405,
+	.reg_0e08 = 0x00000000,
+	.reg_086c = 0x00000000,
+
+	.reg_0e10 = 0x0b0c0c0e,
+	.reg_0e14 = 0x01030506,
+	.reg_0e18 = 0x0b0c0d0e,
+	.reg_0e1c = 0x01030509,
+
+	.reg_0830 = 0x07090c0c,
+	.reg_0834 = 0x01020405,
+	.reg_0838 = 0x00000000,
+	.reg_086c_2 = 0x00000000,
+
+	.reg_083c = 0x0b0c0d0e,
+	.reg_0848 = 0x01030509,
+	.reg_084c = 0x0b0c0d0e,
+	.reg_0868 = 0x01030509,
+};
+
+static struct rtl8xxxu_power_base rtl8188r_power_base = {
+	.reg_0e00 = 0x06080808,
+	.reg_0e04 = 0x00040406,
+	.reg_0e08 = 0x00000000,
+	.reg_086c = 0x00000000,
+
+	.reg_0e10 = 0x04060608,
+	.reg_0e14 = 0x00020204,
+	.reg_0e18 = 0x04060608,
+	.reg_0e1c = 0x00020204,
+
+	.reg_0830 = 0x06080808,
+	.reg_0834 = 0x00040406,
+	.reg_0838 = 0x00000000,
+	.reg_086c_2 = 0x00000000,
+
+	.reg_083c = 0x04060608,
+	.reg_0848 = 0x00020204,
+	.reg_084c = 0x04060608,
+	.reg_0868 = 0x00020204,
+};
+
+static struct rtl8xxxu_rfregval rtl8192cu_radioa_2t_init_table[] = {
+	{0x00, 0x00030159}, {0x01, 0x00031284},
+	{0x02, 0x00098000}, {0x03, 0x00018c63},
+	{0x04, 0x000210e7}, {0x09, 0x0002044f},
+	{0x0a, 0x0001adb1}, {0x0b, 0x00054867},
+	{0x0c, 0x0008992e}, {0x0d, 0x0000e52c},
+	{0x0e, 0x00039ce7}, {0x0f, 0x00000451},
+	{0x19, 0x00000000}, {0x1a, 0x00010255},
+	{0x1b, 0x00060a00}, {0x1c, 0x000fc378},
+	{0x1d, 0x000a1250}, {0x1e, 0x0004445f},
+	{0x1f, 0x00080001}, {0x20, 0x0000b614},
+	{0x21, 0x0006c000}, {0x22, 0x00000000},
+	{0x23, 0x00001558}, {0x24, 0x00000060},
+	{0x25, 0x00000483}, {0x26, 0x0004f000},
+	{0x27, 0x000ec7d9}, {0x28, 0x000577c0},
+	{0x29, 0x00004783}, {0x2a, 0x00000001},
+	{0x2b, 0x00021334}, {0x2a, 0x00000000},
+	{0x2b, 0x00000054}, {0x2a, 0x00000001},
+	{0x2b, 0x00000808}, {0x2b, 0x00053333},
+	{0x2c, 0x0000000c}, {0x2a, 0x00000002},
+	{0x2b, 0x00000808}, {0x2b, 0x0005b333},
+	{0x2c, 0x0000000d}, {0x2a, 0x00000003},
+	{0x2b, 0x00000808}, {0x2b, 0x00063333},
+	{0x2c, 0x0000000d}, {0x2a, 0x00000004},
+	{0x2b, 0x00000808}, {0x2b, 0x0006b333},
+	{0x2c, 0x0000000d}, {0x2a, 0x00000005},
+	{0x2b, 0x00000808}, {0x2b, 0x00073333},
+	{0x2c, 0x0000000d}, {0x2a, 0x00000006},
+	{0x2b, 0x00000709}, {0x2b, 0x0005b333},
+	{0x2c, 0x0000000d}, {0x2a, 0x00000007},
+	{0x2b, 0x00000709}, {0x2b, 0x00063333},
+	{0x2c, 0x0000000d}, {0x2a, 0x00000008},
+	{0x2b, 0x0000060a}, {0x2b, 0x0004b333},
+	{0x2c, 0x0000000d}, {0x2a, 0x00000009},
+	{0x2b, 0x0000060a}, {0x2b, 0x00053333},
+	{0x2c, 0x0000000d}, {0x2a, 0x0000000a},
+	{0x2b, 0x0000060a}, {0x2b, 0x0005b333},
+	{0x2c, 0x0000000d}, {0x2a, 0x0000000b},
+	{0x2b, 0x0000060a}, {0x2b, 0x00063333},
+	{0x2c, 0x0000000d}, {0x2a, 0x0000000c},
+	{0x2b, 0x0000060a}, {0x2b, 0x0006b333},
+	{0x2c, 0x0000000d}, {0x2a, 0x0000000d},
+	{0x2b, 0x0000060a}, {0x2b, 0x00073333},
+	{0x2c, 0x0000000d}, {0x2a, 0x0000000e},
+	{0x2b, 0x0000050b}, {0x2b, 0x00066666},
+	{0x2c, 0x0000001a}, {0x2a, 0x000e0000},
+	{0x10, 0x0004000f}, {0x11, 0x000e31fc},
+	{0x10, 0x0006000f}, {0x11, 0x000ff9f8},
+	{0x10, 0x0002000f}, {0x11, 0x000203f9},
+	{0x10, 0x0003000f}, {0x11, 0x000ff500},
+	{0x10, 0x00000000}, {0x11, 0x00000000},
+	{0x10, 0x0008000f}, {0x11, 0x0003f100},
+	{0x10, 0x0009000f}, {0x11, 0x00023100},
+	{0x12, 0x00032000}, {0x12, 0x00071000},
+	{0x12, 0x000b0000}, {0x12, 0x000fc000},
+	{0x13, 0x000287b3}, {0x13, 0x000244b7},
+	{0x13, 0x000204ab}, {0x13, 0x0001c49f},
+	{0x13, 0x00018493}, {0x13, 0x0001429b},
+	{0x13, 0x00010299}, {0x13, 0x0000c29c},
+	{0x13, 0x000081a0}, {0x13, 0x000040ac},
+	{0x13, 0x00000020}, {0x14, 0x0001944c},
+	{0x14, 0x00059444}, {0x14, 0x0009944c},
+	{0x14, 0x000d9444}, {0x15, 0x0000f424},
+	{0x15, 0x0004f424}, {0x15, 0x0008f424},
+	{0x15, 0x000cf424}, {0x16, 0x000e0330},
+	{0x16, 0x000a0330}, {0x16, 0x00060330},
+	{0x16, 0x00020330}, {0x00, 0x00010159},
+	{0x18, 0x0000f401}, {0xfe, 0x00000000},
+	{0xfe, 0x00000000}, {0x1f, 0x00080003},
+	{0xfe, 0x00000000}, {0xfe, 0x00000000},
+	{0x1e, 0x00044457}, {0x1f, 0x00080000},
+	{0x00, 0x00030159},
+	{0xff, 0xffffffff}
+};
+
+static struct rtl8xxxu_rfregval rtl8192cu_radiob_2t_init_table[] = {
+	{0x00, 0x00030159}, {0x01, 0x00031284},
+	{0x02, 0x00098000}, {0x03, 0x00018c63},
+	{0x04, 0x000210e7}, {0x09, 0x0002044f},
+	{0x0a, 0x0001adb1}, {0x0b, 0x00054867},
+	{0x0c, 0x0008992e}, {0x0d, 0x0000e52c},
+	{0x0e, 0x00039ce7}, {0x0f, 0x00000451},
+	{0x12, 0x00032000}, {0x12, 0x00071000},
+	{0x12, 0x000b0000}, {0x12, 0x000fc000},
+	{0x13, 0x000287af}, {0x13, 0x000244b7},
+	{0x13, 0x000204ab}, {0x13, 0x0001c49f},
+	{0x13, 0x00018493}, {0x13, 0x00014297},
+	{0x13, 0x00010295}, {0x13, 0x0000c298},
+	{0x13, 0x0000819c}, {0x13, 0x000040a8},
+	{0x13, 0x0000001c}, {0x14, 0x0001944c},
+	{0x14, 0x00059444}, {0x14, 0x0009944c},
+	{0x14, 0x000d9444}, {0x15, 0x0000f424},
+	{0x15, 0x0004f424}, {0x15, 0x0008f424},
+	{0x15, 0x000cf424}, {0x16, 0x000e0330},
+	{0x16, 0x000a0330}, {0x16, 0x00060330},
+	{0x16, 0x00020330},
+	{0xff, 0xffffffff}
+};
+
+static struct rtl8xxxu_rfregval rtl8192cu_radioa_1t_init_table[] = {
+	{0x00, 0x00030159}, {0x01, 0x00031284},
+	{0x02, 0x00098000}, {0x03, 0x00018c63},
+	{0x04, 0x000210e7}, {0x09, 0x0002044f},
+	{0x0a, 0x0001adb1}, {0x0b, 0x00054867},
+	{0x0c, 0x0008992e}, {0x0d, 0x0000e52c},
+	{0x0e, 0x00039ce7}, {0x0f, 0x00000451},
+	{0x19, 0x00000000}, {0x1a, 0x00010255},
+	{0x1b, 0x00060a00}, {0x1c, 0x000fc378},
+	{0x1d, 0x000a1250}, {0x1e, 0x0004445f},
+	{0x1f, 0x00080001}, {0x20, 0x0000b614},
+	{0x21, 0x0006c000}, {0x22, 0x00000000},
+	{0x23, 0x00001558}, {0x24, 0x00000060},
+	{0x25, 0x00000483}, {0x26, 0x0004f000},
+	{0x27, 0x000ec7d9}, {0x28, 0x000577c0},
+	{0x29, 0x00004783}, {0x2a, 0x00000001},
+	{0x2b, 0x00021334}, {0x2a, 0x00000000},
+	{0x2b, 0x00000054}, {0x2a, 0x00000001},
+	{0x2b, 0x00000808}, {0x2b, 0x00053333},
+	{0x2c, 0x0000000c}, {0x2a, 0x00000002},
+	{0x2b, 0x00000808}, {0x2b, 0x0005b333},
+	{0x2c, 0x0000000d}, {0x2a, 0x00000003},
+	{0x2b, 0x00000808}, {0x2b, 0x00063333},
+	{0x2c, 0x0000000d}, {0x2a, 0x00000004},
+	{0x2b, 0x00000808}, {0x2b, 0x0006b333},
+	{0x2c, 0x0000000d}, {0x2a, 0x00000005},
+	{0x2b, 0x00000808}, {0x2b, 0x00073333},
+	{0x2c, 0x0000000d}, {0x2a, 0x00000006},
+	{0x2b, 0x00000709}, {0x2b, 0x0005b333},
+	{0x2c, 0x0000000d}, {0x2a, 0x00000007},
+	{0x2b, 0x00000709}, {0x2b, 0x00063333},
+	{0x2c, 0x0000000d}, {0x2a, 0x00000008},
+	{0x2b, 0x0000060a}, {0x2b, 0x0004b333},
+	{0x2c, 0x0000000d}, {0x2a, 0x00000009},
+	{0x2b, 0x0000060a}, {0x2b, 0x00053333},
+	{0x2c, 0x0000000d}, {0x2a, 0x0000000a},
+	{0x2b, 0x0000060a}, {0x2b, 0x0005b333},
+	{0x2c, 0x0000000d}, {0x2a, 0x0000000b},
+	{0x2b, 0x0000060a}, {0x2b, 0x00063333},
+	{0x2c, 0x0000000d}, {0x2a, 0x0000000c},
+	{0x2b, 0x0000060a}, {0x2b, 0x0006b333},
+	{0x2c, 0x0000000d}, {0x2a, 0x0000000d},
+	{0x2b, 0x0000060a}, {0x2b, 0x00073333},
+	{0x2c, 0x0000000d}, {0x2a, 0x0000000e},
+	{0x2b, 0x0000050b}, {0x2b, 0x00066666},
+	{0x2c, 0x0000001a}, {0x2a, 0x000e0000},
+	{0x10, 0x0004000f}, {0x11, 0x000e31fc},
+	{0x10, 0x0006000f}, {0x11, 0x000ff9f8},
+	{0x10, 0x0002000f}, {0x11, 0x000203f9},
+	{0x10, 0x0003000f}, {0x11, 0x000ff500},
+	{0x10, 0x00000000}, {0x11, 0x00000000},
+	{0x10, 0x0008000f}, {0x11, 0x0003f100},
+	{0x10, 0x0009000f}, {0x11, 0x00023100},
+	{0x12, 0x00032000}, {0x12, 0x00071000},
+	{0x12, 0x000b0000}, {0x12, 0x000fc000},
+	{0x13, 0x000287b3}, {0x13, 0x000244b7},
+	{0x13, 0x000204ab}, {0x13, 0x0001c49f},
+	{0x13, 0x00018493}, {0x13, 0x0001429b},
+	{0x13, 0x00010299}, {0x13, 0x0000c29c},
+	{0x13, 0x000081a0}, {0x13, 0x000040ac},
+	{0x13, 0x00000020}, {0x14, 0x0001944c},
+	{0x14, 0x00059444}, {0x14, 0x0009944c},
+	{0x14, 0x000d9444}, {0x15, 0x0000f405},
+	{0x15, 0x0004f405}, {0x15, 0x0008f405},
+	{0x15, 0x000cf405}, {0x16, 0x000e0330},
+	{0x16, 0x000a0330}, {0x16, 0x00060330},
+	{0x16, 0x00020330}, {0x00, 0x00010159},
+	{0x18, 0x0000f401}, {0xfe, 0x00000000},
+	{0xfe, 0x00000000}, {0x1f, 0x00080003},
+	{0xfe, 0x00000000}, {0xfe, 0x00000000},
+	{0x1e, 0x00044457}, {0x1f, 0x00080000},
+	{0x00, 0x00030159},
+	{0xff, 0xffffffff}
+};
+
+static struct rtl8xxxu_rfregval rtl8188ru_radioa_1t_highpa_table[] = {
+	{0x00, 0x00030159}, {0x01, 0x00031284},
+	{0x02, 0x00098000}, {0x03, 0x00018c63},
+	{0x04, 0x000210e7}, {0x09, 0x0002044f},
+	{0x0a, 0x0001adb0}, {0x0b, 0x00054867},
+	{0x0c, 0x0008992e}, {0x0d, 0x0000e529},
+	{0x0e, 0x00039ce7}, {0x0f, 0x00000451},
+	{0x19, 0x00000000}, {0x1a, 0x00000255},
+	{0x1b, 0x00060a00}, {0x1c, 0x000fc378},
+	{0x1d, 0x000a1250}, {0x1e, 0x0004445f},
+	{0x1f, 0x00080001}, {0x20, 0x0000b614},
+	{0x21, 0x0006c000}, {0x22, 0x0000083c},
+	{0x23, 0x00001558}, {0x24, 0x00000060},
+	{0x25, 0x00000483}, {0x26, 0x0004f000},
+	{0x27, 0x000ec7d9}, {0x28, 0x000977c0},
+	{0x29, 0x00004783}, {0x2a, 0x00000001},
+	{0x2b, 0x00021334}, {0x2a, 0x00000000},
+	{0x2b, 0x00000054}, {0x2a, 0x00000001},
+	{0x2b, 0x00000808}, {0x2b, 0x00053333},
+	{0x2c, 0x0000000c}, {0x2a, 0x00000002},
+	{0x2b, 0x00000808}, {0x2b, 0x0005b333},
+	{0x2c, 0x0000000d}, {0x2a, 0x00000003},
+	{0x2b, 0x00000808}, {0x2b, 0x00063333},
+	{0x2c, 0x0000000d}, {0x2a, 0x00000004},
+	{0x2b, 0x00000808}, {0x2b, 0x0006b333},
+	{0x2c, 0x0000000d}, {0x2a, 0x00000005},
+	{0x2b, 0x00000808}, {0x2b, 0x00073333},
+	{0x2c, 0x0000000d}, {0x2a, 0x00000006},
+	{0x2b, 0x00000709}, {0x2b, 0x0005b333},
+	{0x2c, 0x0000000d}, {0x2a, 0x00000007},
+	{0x2b, 0x00000709}, {0x2b, 0x00063333},
+	{0x2c, 0x0000000d}, {0x2a, 0x00000008},
+	{0x2b, 0x0000060a}, {0x2b, 0x0004b333},
+	{0x2c, 0x0000000d}, {0x2a, 0x00000009},
+	{0x2b, 0x0000060a}, {0x2b, 0x00053333},
+	{0x2c, 0x0000000d}, {0x2a, 0x0000000a},
+	{0x2b, 0x0000060a}, {0x2b, 0x0005b333},
+	{0x2c, 0x0000000d}, {0x2a, 0x0000000b},
+	{0x2b, 0x0000060a}, {0x2b, 0x00063333},
+	{0x2c, 0x0000000d}, {0x2a, 0x0000000c},
+	{0x2b, 0x0000060a}, {0x2b, 0x0006b333},
+	{0x2c, 0x0000000d}, {0x2a, 0x0000000d},
+	{0x2b, 0x0000060a}, {0x2b, 0x00073333},
+	{0x2c, 0x0000000d}, {0x2a, 0x0000000e},
+	{0x2b, 0x0000050b}, {0x2b, 0x00066666},
+	{0x2c, 0x0000001a}, {0x2a, 0x000e0000},
+	{0x10, 0x0004000f}, {0x11, 0x000e31fc},
+	{0x10, 0x0006000f}, {0x11, 0x000ff9f8},
+	{0x10, 0x0002000f}, {0x11, 0x000203f9},
+	{0x10, 0x0003000f}, {0x11, 0x000ff500},
+	{0x10, 0x00000000}, {0x11, 0x00000000},
+	{0x10, 0x0008000f}, {0x11, 0x0003f100},
+	{0x10, 0x0009000f}, {0x11, 0x00023100},
+	{0x12, 0x000d8000}, {0x12, 0x00090000},
+	{0x12, 0x00051000}, {0x12, 0x00012000},
+	{0x13, 0x00028fb4}, {0x13, 0x00024fa8},
+	{0x13, 0x000207a4}, {0x13, 0x0001c3b0},
+	{0x13, 0x000183a4}, {0x13, 0x00014398},
+	{0x13, 0x000101a4}, {0x13, 0x0000c198},
+	{0x13, 0x000080a4}, {0x13, 0x00004098},
+	{0x13, 0x00000000}, {0x14, 0x0001944c},
+	{0x14, 0x00059444}, {0x14, 0x0009944c},
+	{0x14, 0x000d9444}, {0x15, 0x0000f405},
+	{0x15, 0x0004f405}, {0x15, 0x0008f405},
+	{0x15, 0x000cf405}, {0x16, 0x000e0330},
+	{0x16, 0x000a0330}, {0x16, 0x00060330},
+	{0x16, 0x00020330}, {0x00, 0x00010159},
+	{0x18, 0x0000f401}, {0xfe, 0x00000000},
+	{0xfe, 0x00000000}, {0x1f, 0x00080003},
+	{0xfe, 0x00000000}, {0xfe, 0x00000000},
+	{0x1e, 0x00044457}, {0x1f, 0x00080000},
+	{0x00, 0x00030159},
+	{0xff, 0xffffffff}
+};
+
+static int rtl8192cu_load_firmware(struct rtl8xxxu_priv *priv)
+{
+	char *fw_name;
+	int ret;
+
+	if (!priv->vendor_umc)
+		fw_name = "rtlwifi/rtl8192cufw_TMSC.bin";
+	else if (priv->chip_cut || priv->rtl_chip == RTL8192C)
+		fw_name = "rtlwifi/rtl8192cufw_B.bin";
+	else
+		fw_name = "rtlwifi/rtl8192cufw_A.bin";
+
+	ret = rtl8xxxu_load_firmware(priv, fw_name);
+
+	return ret;
+}
+
+static int rtl8192cu_parse_efuse(struct rtl8xxxu_priv *priv)
+{
+	struct rtl8192cu_efuse *efuse = &priv->efuse_wifi.efuse8192;
+	int i;
+
+	if (efuse->rtl_id != cpu_to_le16(0x8129))
+		return -EINVAL;
+
+	ether_addr_copy(priv->mac_addr, efuse->mac_addr);
+
+	memcpy(priv->cck_tx_power_index_A,
+	       efuse->cck_tx_power_index_A,
+	       sizeof(efuse->cck_tx_power_index_A));
+	memcpy(priv->cck_tx_power_index_B,
+	       efuse->cck_tx_power_index_B,
+	       sizeof(efuse->cck_tx_power_index_B));
+
+	memcpy(priv->ht40_1s_tx_power_index_A,
+	       efuse->ht40_1s_tx_power_index_A,
+	       sizeof(efuse->ht40_1s_tx_power_index_A));
+	memcpy(priv->ht40_1s_tx_power_index_B,
+	       efuse->ht40_1s_tx_power_index_B,
+	       sizeof(efuse->ht40_1s_tx_power_index_B));
+	memcpy(priv->ht40_2s_tx_power_index_diff,
+	       efuse->ht40_2s_tx_power_index_diff,
+	       sizeof(efuse->ht40_2s_tx_power_index_diff));
+
+	memcpy(priv->ht20_tx_power_index_diff,
+	       efuse->ht20_tx_power_index_diff,
+	       sizeof(efuse->ht20_tx_power_index_diff));
+	memcpy(priv->ofdm_tx_power_index_diff,
+	       efuse->ofdm_tx_power_index_diff,
+	       sizeof(efuse->ofdm_tx_power_index_diff));
+
+	memcpy(priv->ht40_max_power_offset,
+	       efuse->ht40_max_power_offset,
+	       sizeof(efuse->ht40_max_power_offset));
+	memcpy(priv->ht20_max_power_offset,
+	       efuse->ht20_max_power_offset,
+	       sizeof(efuse->ht20_max_power_offset));
+
+	dev_info(&priv->udev->dev, "Vendor: %.7s\n",
+		 efuse->vendor_name);
+	dev_info(&priv->udev->dev, "Product: %.20s\n",
+		 efuse->device_name);
+
+	priv->power_base = &rtl8192c_power_base;
+
+	if (efuse->rf_regulatory & 0x20) {
+		sprintf(priv->chip_name, "8188RU");
+		priv->rtl_chip = RTL8188R;
+		priv->hi_pa = 1;
+		priv->no_pape = 1;
+		priv->power_base = &rtl8188r_power_base;
+	}
+
+	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_EFUSE) {
+		unsigned char *raw = priv->efuse_wifi.raw;
+
+		dev_info(&priv->udev->dev,
+			 "%s: dumping efuse (0x%02zx bytes):\n",
+			 __func__, sizeof(struct rtl8192cu_efuse));
+		for (i = 0; i < sizeof(struct rtl8192cu_efuse); i += 8) {
+			dev_info(&priv->udev->dev, "%02x: "
+				 "%02x %02x %02x %02x %02x %02x %02x %02x\n", i,
+				 raw[i], raw[i + 1], raw[i + 2],
+				 raw[i + 3], raw[i + 4], raw[i + 5],
+				 raw[i + 6], raw[i + 7]);
+		}
+	}
+	return 0;
+}
+
+static int rtl8192cu_init_phy_rf(struct rtl8xxxu_priv *priv)
+{
+	struct rtl8xxxu_rfregval *rftable;
+	int ret;
+
+	if (priv->rtl_chip == RTL8188R) {
+		rftable = rtl8188ru_radioa_1t_highpa_table;
+		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_A);
+	} else if (priv->rf_paths == 1) {
+		rftable = rtl8192cu_radioa_1t_init_table;
+		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_A);
+	} else {
+		rftable = rtl8192cu_radioa_2t_init_table;
+		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_A);
+		if (ret)
+			goto exit;
+		rftable = rtl8192cu_radiob_2t_init_table;
+		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_B);
+	}
+
+exit:
+	return ret;
+}
+
+static int rtl8192cu_power_on(struct rtl8xxxu_priv *priv)
+{
+	u8 val8;
+	u16 val16;
+	u32 val32;
+	int i;
+
+	for (i = 100; i; i--) {
+		val8 = rtl8xxxu_read8(priv, REG_APS_FSMCO);
+		if (val8 & APS_FSMCO_PFM_ALDN)
+			break;
+	}
+
+	if (!i) {
+		pr_info("%s: Poll failed\n", __func__);
+		return -ENODEV;
+	}
+
+	/*
+	 * RSV_CTRL 0x001C[7:0] = 0x00, unlock ISO/CLK/Power control register
+	 */
+	rtl8xxxu_write8(priv, REG_RSV_CTRL, 0x0);
+	rtl8xxxu_write8(priv, REG_SPS0_CTRL, 0x2b);
+	udelay(100);
+
+	val8 = rtl8xxxu_read8(priv, REG_LDOV12D_CTRL);
+	if (!(val8 & LDOV12D_ENABLE)) {
+		pr_info("%s: Enabling LDOV12D (%02x)\n", __func__, val8);
+		val8 |= LDOV12D_ENABLE;
+		rtl8xxxu_write8(priv, REG_LDOV12D_CTRL, val8);
+
+		udelay(100);
+
+		val8 = rtl8xxxu_read8(priv, REG_SYS_ISO_CTRL);
+		val8 &= ~SYS_ISO_MD2PP;
+		rtl8xxxu_write8(priv, REG_SYS_ISO_CTRL, val8);
+	}
+
+	/*
+	 * Auto enable WLAN
+	 */
+	val16 = rtl8xxxu_read16(priv, REG_APS_FSMCO);
+	val16 |= APS_FSMCO_MAC_ENABLE;
+	rtl8xxxu_write16(priv, REG_APS_FSMCO, val16);
+
+	for (i = 1000; i; i--) {
+		val16 = rtl8xxxu_read16(priv, REG_APS_FSMCO);
+		if (!(val16 & APS_FSMCO_MAC_ENABLE))
+			break;
+	}
+	if (!i) {
+		pr_info("%s: FSMCO_MAC_ENABLE poll failed\n", __func__);
+		return -EBUSY;
+	}
+
+	/*
+	 * Enable radio, GPIO, LED
+	 */
+	val16 = APS_FSMCO_HW_SUSPEND | APS_FSMCO_ENABLE_POWERDOWN |
+		APS_FSMCO_PFM_ALDN;
+	rtl8xxxu_write16(priv, REG_APS_FSMCO, val16);
+
+	/*
+	 * Release RF digital isolation
+	 */
+	val16 = rtl8xxxu_read16(priv, REG_SYS_ISO_CTRL);
+	val16 &= ~SYS_ISO_DIOR;
+	rtl8xxxu_write16(priv, REG_SYS_ISO_CTRL, val16);
+
+	val8 = rtl8xxxu_read8(priv, REG_APSD_CTRL);
+	val8 &= ~APSD_CTRL_OFF;
+	rtl8xxxu_write8(priv, REG_APSD_CTRL, val8);
+	for (i = 200; i; i--) {
+		val8 = rtl8xxxu_read8(priv, REG_APSD_CTRL);
+		if (!(val8 & APSD_CTRL_OFF_STATUS))
+			break;
+	}
+
+	if (!i) {
+		pr_info("%s: APSD_CTRL poll failed\n", __func__);
+		return -EBUSY;
+	}
+
+	/*
+	 * Enable MAC DMA/WMAC/SCHEDULE/SEC block
+	 */
+	val16 = rtl8xxxu_read16(priv, REG_CR);
+	val16 |= CR_HCI_TXDMA_ENABLE | CR_HCI_RXDMA_ENABLE |
+		CR_TXDMA_ENABLE | CR_RXDMA_ENABLE | CR_PROTOCOL_ENABLE |
+		CR_SCHEDULE_ENABLE | CR_MAC_TX_ENABLE | CR_MAC_RX_ENABLE;
+	rtl8xxxu_write16(priv, REG_CR, val16);
+
+	rtl8xxxu_write8(priv, 0xfe10, 0x19);
+
+	/*
+	 * Workaround for 8188RU LNA power leakage problem.
+	 */
+	if (priv->rtl_chip == RTL8188R) {
+		val32 = rtl8xxxu_read32(priv, REG_FPGA0_XCD_RF_PARM);
+		val32 &= ~BIT(1);
+		rtl8xxxu_write32(priv, REG_FPGA0_XCD_RF_PARM, val32);
+	}
+	return 0;
+}
+
+struct rtl8xxxu_fileops rtl8192cu_fops = {
+	.parse_efuse = rtl8192cu_parse_efuse,
+	.load_firmware = rtl8192cu_load_firmware,
+	.power_on = rtl8192cu_power_on,
+	.power_off = rtl8xxxu_power_off,
+	.reset_8051 = rtl8xxxu_reset_8051,
+	.llt_init = rtl8xxxu_init_llt_table,
+	.init_phy_bb = rtl8xxxu_gen1_init_phy_bb,
+	.init_phy_rf = rtl8192cu_init_phy_rf,
+	.phy_iq_calibrate = rtl8xxxu_gen1_phy_iq_calibrate,
+	.config_channel = rtl8xxxu_gen1_config_channel,
+	.parse_rx_desc = rtl8xxxu_parse_rxdesc16,
+	.enable_rf = rtl8xxxu_gen1_enable_rf,
+	.disable_rf = rtl8xxxu_gen1_disable_rf,
+	.usb_quirks = rtl8xxxu_gen1_usb_quirks,
+	.set_tx_power = rtl8xxxu_gen1_set_tx_power,
+	.update_rate_mask = rtl8xxxu_update_rate_mask,
+	.report_connect = rtl8xxxu_gen1_report_connect,
+	.writeN_block_size = 128,
+	.mbox_ext_reg = REG_HMBOX_EXT_0,
+	.mbox_ext_width = 2,
+	.tx_desc_size = sizeof(struct rtl8xxxu_txdesc32),
+	.rx_desc_size = sizeof(struct rtl8xxxu_rxdesc16),
+	.adda_1t_init = 0x0b1b25a0,
+	.adda_1t_path_on = 0x0bdb25a0,
+	.adda_2t_path_on_a = 0x04db25a4,
+	.adda_2t_path_on_b = 0x0b1b25a4,
+	.trxff_boundary = 0x27ff,
+	.pbp_rx = PBP_PAGE_SIZE_128,
+	.pbp_tx = PBP_PAGE_SIZE_128,
+	.mactable = rtl8xxxu_gen1_mac_init_table,
+};
+#endif
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 6434558..f035d15 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -153,52 +153,6 @@ struct rtl8xxxu_reg8val rtl8xxxu_gen1_mac_init_table[] = {
 	{0x70a, 0x65}, {0x70b, 0x87}, {0xffff, 0xff},
 };
 
-#ifdef CONFIG_RTL8XXXU_UNTESTED
-static struct rtl8xxxu_power_base rtl8188r_power_base = {
-	.reg_0e00 = 0x06080808,
-	.reg_0e04 = 0x00040406,
-	.reg_0e08 = 0x00000000,
-	.reg_086c = 0x00000000,
-
-	.reg_0e10 = 0x04060608,
-	.reg_0e14 = 0x00020204,
-	.reg_0e18 = 0x04060608,
-	.reg_0e1c = 0x00020204,
-
-	.reg_0830 = 0x06080808,
-	.reg_0834 = 0x00040406,
-	.reg_0838 = 0x00000000,
-	.reg_086c_2 = 0x00000000,
-
-	.reg_083c = 0x04060608,
-	.reg_0848 = 0x00020204,
-	.reg_084c = 0x04060608,
-	.reg_0868 = 0x00020204,
-};
-
-static struct rtl8xxxu_power_base rtl8192c_power_base = {
-	.reg_0e00 = 0x07090c0c,
-	.reg_0e04 = 0x01020405,
-	.reg_0e08 = 0x00000000,
-	.reg_086c = 0x00000000,
-
-	.reg_0e10 = 0x0b0c0c0e,
-	.reg_0e14 = 0x01030506,
-	.reg_0e18 = 0x0b0c0d0e,
-	.reg_0e1c = 0x01030509,
-
-	.reg_0830 = 0x07090c0c,
-	.reg_0834 = 0x01020405,
-	.reg_0838 = 0x00000000,
-	.reg_086c_2 = 0x00000000,
-
-	.reg_083c = 0x0b0c0d0e,
-	.reg_0848 = 0x01030509,
-	.reg_084c = 0x0b0c0d0e,
-	.reg_0868 = 0x01030509,
-};
-#endif
-
 static struct rtl8xxxu_reg32val rtl8723a_phy_1t_init_table[] = {
 	{0x800, 0x80040000}, {0x804, 0x00000003},
 	{0x808, 0x0000fc00}, {0x80c, 0x0000000a},
@@ -662,257 +616,6 @@ static struct rtl8xxxu_reg32val rtl8xxx_agc_highpa_table[] = {
 	{0xffff, 0xffffffff}
 };
 
-#ifdef CONFIG_RTL8XXXU_UNTESTED
-static struct rtl8xxxu_rfregval rtl8192cu_radioa_2t_init_table[] = {
-	{0x00, 0x00030159}, {0x01, 0x00031284},
-	{0x02, 0x00098000}, {0x03, 0x00018c63},
-	{0x04, 0x000210e7}, {0x09, 0x0002044f},
-	{0x0a, 0x0001adb1}, {0x0b, 0x00054867},
-	{0x0c, 0x0008992e}, {0x0d, 0x0000e52c},
-	{0x0e, 0x00039ce7}, {0x0f, 0x00000451},
-	{0x19, 0x00000000}, {0x1a, 0x00010255},
-	{0x1b, 0x00060a00}, {0x1c, 0x000fc378},
-	{0x1d, 0x000a1250}, {0x1e, 0x0004445f},
-	{0x1f, 0x00080001}, {0x20, 0x0000b614},
-	{0x21, 0x0006c000}, {0x22, 0x00000000},
-	{0x23, 0x00001558}, {0x24, 0x00000060},
-	{0x25, 0x00000483}, {0x26, 0x0004f000},
-	{0x27, 0x000ec7d9}, {0x28, 0x000577c0},
-	{0x29, 0x00004783}, {0x2a, 0x00000001},
-	{0x2b, 0x00021334}, {0x2a, 0x00000000},
-	{0x2b, 0x00000054}, {0x2a, 0x00000001},
-	{0x2b, 0x00000808}, {0x2b, 0x00053333},
-	{0x2c, 0x0000000c}, {0x2a, 0x00000002},
-	{0x2b, 0x00000808}, {0x2b, 0x0005b333},
-	{0x2c, 0x0000000d}, {0x2a, 0x00000003},
-	{0x2b, 0x00000808}, {0x2b, 0x00063333},
-	{0x2c, 0x0000000d}, {0x2a, 0x00000004},
-	{0x2b, 0x00000808}, {0x2b, 0x0006b333},
-	{0x2c, 0x0000000d}, {0x2a, 0x00000005},
-	{0x2b, 0x00000808}, {0x2b, 0x00073333},
-	{0x2c, 0x0000000d}, {0x2a, 0x00000006},
-	{0x2b, 0x00000709}, {0x2b, 0x0005b333},
-	{0x2c, 0x0000000d}, {0x2a, 0x00000007},
-	{0x2b, 0x00000709}, {0x2b, 0x00063333},
-	{0x2c, 0x0000000d}, {0x2a, 0x00000008},
-	{0x2b, 0x0000060a}, {0x2b, 0x0004b333},
-	{0x2c, 0x0000000d}, {0x2a, 0x00000009},
-	{0x2b, 0x0000060a}, {0x2b, 0x00053333},
-	{0x2c, 0x0000000d}, {0x2a, 0x0000000a},
-	{0x2b, 0x0000060a}, {0x2b, 0x0005b333},
-	{0x2c, 0x0000000d}, {0x2a, 0x0000000b},
-	{0x2b, 0x0000060a}, {0x2b, 0x00063333},
-	{0x2c, 0x0000000d}, {0x2a, 0x0000000c},
-	{0x2b, 0x0000060a}, {0x2b, 0x0006b333},
-	{0x2c, 0x0000000d}, {0x2a, 0x0000000d},
-	{0x2b, 0x0000060a}, {0x2b, 0x00073333},
-	{0x2c, 0x0000000d}, {0x2a, 0x0000000e},
-	{0x2b, 0x0000050b}, {0x2b, 0x00066666},
-	{0x2c, 0x0000001a}, {0x2a, 0x000e0000},
-	{0x10, 0x0004000f}, {0x11, 0x000e31fc},
-	{0x10, 0x0006000f}, {0x11, 0x000ff9f8},
-	{0x10, 0x0002000f}, {0x11, 0x000203f9},
-	{0x10, 0x0003000f}, {0x11, 0x000ff500},
-	{0x10, 0x00000000}, {0x11, 0x00000000},
-	{0x10, 0x0008000f}, {0x11, 0x0003f100},
-	{0x10, 0x0009000f}, {0x11, 0x00023100},
-	{0x12, 0x00032000}, {0x12, 0x00071000},
-	{0x12, 0x000b0000}, {0x12, 0x000fc000},
-	{0x13, 0x000287b3}, {0x13, 0x000244b7},
-	{0x13, 0x000204ab}, {0x13, 0x0001c49f},
-	{0x13, 0x00018493}, {0x13, 0x0001429b},
-	{0x13, 0x00010299}, {0x13, 0x0000c29c},
-	{0x13, 0x000081a0}, {0x13, 0x000040ac},
-	{0x13, 0x00000020}, {0x14, 0x0001944c},
-	{0x14, 0x00059444}, {0x14, 0x0009944c},
-	{0x14, 0x000d9444}, {0x15, 0x0000f424},
-	{0x15, 0x0004f424}, {0x15, 0x0008f424},
-	{0x15, 0x000cf424}, {0x16, 0x000e0330},
-	{0x16, 0x000a0330}, {0x16, 0x00060330},
-	{0x16, 0x00020330}, {0x00, 0x00010159},
-	{0x18, 0x0000f401}, {0xfe, 0x00000000},
-	{0xfe, 0x00000000}, {0x1f, 0x00080003},
-	{0xfe, 0x00000000}, {0xfe, 0x00000000},
-	{0x1e, 0x00044457}, {0x1f, 0x00080000},
-	{0x00, 0x00030159},
-	{0xff, 0xffffffff}
-};
-
-static struct rtl8xxxu_rfregval rtl8192cu_radiob_2t_init_table[] = {
-	{0x00, 0x00030159}, {0x01, 0x00031284},
-	{0x02, 0x00098000}, {0x03, 0x00018c63},
-	{0x04, 0x000210e7}, {0x09, 0x0002044f},
-	{0x0a, 0x0001adb1}, {0x0b, 0x00054867},
-	{0x0c, 0x0008992e}, {0x0d, 0x0000e52c},
-	{0x0e, 0x00039ce7}, {0x0f, 0x00000451},
-	{0x12, 0x00032000}, {0x12, 0x00071000},
-	{0x12, 0x000b0000}, {0x12, 0x000fc000},
-	{0x13, 0x000287af}, {0x13, 0x000244b7},
-	{0x13, 0x000204ab}, {0x13, 0x0001c49f},
-	{0x13, 0x00018493}, {0x13, 0x00014297},
-	{0x13, 0x00010295}, {0x13, 0x0000c298},
-	{0x13, 0x0000819c}, {0x13, 0x000040a8},
-	{0x13, 0x0000001c}, {0x14, 0x0001944c},
-	{0x14, 0x00059444}, {0x14, 0x0009944c},
-	{0x14, 0x000d9444}, {0x15, 0x0000f424},
-	{0x15, 0x0004f424}, {0x15, 0x0008f424},
-	{0x15, 0x000cf424}, {0x16, 0x000e0330},
-	{0x16, 0x000a0330}, {0x16, 0x00060330},
-	{0x16, 0x00020330},
-	{0xff, 0xffffffff}
-};
-
-static struct rtl8xxxu_rfregval rtl8192cu_radioa_1t_init_table[] = {
-	{0x00, 0x00030159}, {0x01, 0x00031284},
-	{0x02, 0x00098000}, {0x03, 0x00018c63},
-	{0x04, 0x000210e7}, {0x09, 0x0002044f},
-	{0x0a, 0x0001adb1}, {0x0b, 0x00054867},
-	{0x0c, 0x0008992e}, {0x0d, 0x0000e52c},
-	{0x0e, 0x00039ce7}, {0x0f, 0x00000451},
-	{0x19, 0x00000000}, {0x1a, 0x00010255},
-	{0x1b, 0x00060a00}, {0x1c, 0x000fc378},
-	{0x1d, 0x000a1250}, {0x1e, 0x0004445f},
-	{0x1f, 0x00080001}, {0x20, 0x0000b614},
-	{0x21, 0x0006c000}, {0x22, 0x00000000},
-	{0x23, 0x00001558}, {0x24, 0x00000060},
-	{0x25, 0x00000483}, {0x26, 0x0004f000},
-	{0x27, 0x000ec7d9}, {0x28, 0x000577c0},
-	{0x29, 0x00004783}, {0x2a, 0x00000001},
-	{0x2b, 0x00021334}, {0x2a, 0x00000000},
-	{0x2b, 0x00000054}, {0x2a, 0x00000001},
-	{0x2b, 0x00000808}, {0x2b, 0x00053333},
-	{0x2c, 0x0000000c}, {0x2a, 0x00000002},
-	{0x2b, 0x00000808}, {0x2b, 0x0005b333},
-	{0x2c, 0x0000000d}, {0x2a, 0x00000003},
-	{0x2b, 0x00000808}, {0x2b, 0x00063333},
-	{0x2c, 0x0000000d}, {0x2a, 0x00000004},
-	{0x2b, 0x00000808}, {0x2b, 0x0006b333},
-	{0x2c, 0x0000000d}, {0x2a, 0x00000005},
-	{0x2b, 0x00000808}, {0x2b, 0x00073333},
-	{0x2c, 0x0000000d}, {0x2a, 0x00000006},
-	{0x2b, 0x00000709}, {0x2b, 0x0005b333},
-	{0x2c, 0x0000000d}, {0x2a, 0x00000007},
-	{0x2b, 0x00000709}, {0x2b, 0x00063333},
-	{0x2c, 0x0000000d}, {0x2a, 0x00000008},
-	{0x2b, 0x0000060a}, {0x2b, 0x0004b333},
-	{0x2c, 0x0000000d}, {0x2a, 0x00000009},
-	{0x2b, 0x0000060a}, {0x2b, 0x00053333},
-	{0x2c, 0x0000000d}, {0x2a, 0x0000000a},
-	{0x2b, 0x0000060a}, {0x2b, 0x0005b333},
-	{0x2c, 0x0000000d}, {0x2a, 0x0000000b},
-	{0x2b, 0x0000060a}, {0x2b, 0x00063333},
-	{0x2c, 0x0000000d}, {0x2a, 0x0000000c},
-	{0x2b, 0x0000060a}, {0x2b, 0x0006b333},
-	{0x2c, 0x0000000d}, {0x2a, 0x0000000d},
-	{0x2b, 0x0000060a}, {0x2b, 0x00073333},
-	{0x2c, 0x0000000d}, {0x2a, 0x0000000e},
-	{0x2b, 0x0000050b}, {0x2b, 0x00066666},
-	{0x2c, 0x0000001a}, {0x2a, 0x000e0000},
-	{0x10, 0x0004000f}, {0x11, 0x000e31fc},
-	{0x10, 0x0006000f}, {0x11, 0x000ff9f8},
-	{0x10, 0x0002000f}, {0x11, 0x000203f9},
-	{0x10, 0x0003000f}, {0x11, 0x000ff500},
-	{0x10, 0x00000000}, {0x11, 0x00000000},
-	{0x10, 0x0008000f}, {0x11, 0x0003f100},
-	{0x10, 0x0009000f}, {0x11, 0x00023100},
-	{0x12, 0x00032000}, {0x12, 0x00071000},
-	{0x12, 0x000b0000}, {0x12, 0x000fc000},
-	{0x13, 0x000287b3}, {0x13, 0x000244b7},
-	{0x13, 0x000204ab}, {0x13, 0x0001c49f},
-	{0x13, 0x00018493}, {0x13, 0x0001429b},
-	{0x13, 0x00010299}, {0x13, 0x0000c29c},
-	{0x13, 0x000081a0}, {0x13, 0x000040ac},
-	{0x13, 0x00000020}, {0x14, 0x0001944c},
-	{0x14, 0x00059444}, {0x14, 0x0009944c},
-	{0x14, 0x000d9444}, {0x15, 0x0000f405},
-	{0x15, 0x0004f405}, {0x15, 0x0008f405},
-	{0x15, 0x000cf405}, {0x16, 0x000e0330},
-	{0x16, 0x000a0330}, {0x16, 0x00060330},
-	{0x16, 0x00020330}, {0x00, 0x00010159},
-	{0x18, 0x0000f401}, {0xfe, 0x00000000},
-	{0xfe, 0x00000000}, {0x1f, 0x00080003},
-	{0xfe, 0x00000000}, {0xfe, 0x00000000},
-	{0x1e, 0x00044457}, {0x1f, 0x00080000},
-	{0x00, 0x00030159},
-	{0xff, 0xffffffff}
-};
-
-static struct rtl8xxxu_rfregval rtl8188ru_radioa_1t_highpa_table[] = {
-	{0x00, 0x00030159}, {0x01, 0x00031284},
-	{0x02, 0x00098000}, {0x03, 0x00018c63},
-	{0x04, 0x000210e7}, {0x09, 0x0002044f},
-	{0x0a, 0x0001adb0}, {0x0b, 0x00054867},
-	{0x0c, 0x0008992e}, {0x0d, 0x0000e529},
-	{0x0e, 0x00039ce7}, {0x0f, 0x00000451},
-	{0x19, 0x00000000}, {0x1a, 0x00000255},
-	{0x1b, 0x00060a00}, {0x1c, 0x000fc378},
-	{0x1d, 0x000a1250}, {0x1e, 0x0004445f},
-	{0x1f, 0x00080001}, {0x20, 0x0000b614},
-	{0x21, 0x0006c000}, {0x22, 0x0000083c},
-	{0x23, 0x00001558}, {0x24, 0x00000060},
-	{0x25, 0x00000483}, {0x26, 0x0004f000},
-	{0x27, 0x000ec7d9}, {0x28, 0x000977c0},
-	{0x29, 0x00004783}, {0x2a, 0x00000001},
-	{0x2b, 0x00021334}, {0x2a, 0x00000000},
-	{0x2b, 0x00000054}, {0x2a, 0x00000001},
-	{0x2b, 0x00000808}, {0x2b, 0x00053333},
-	{0x2c, 0x0000000c}, {0x2a, 0x00000002},
-	{0x2b, 0x00000808}, {0x2b, 0x0005b333},
-	{0x2c, 0x0000000d}, {0x2a, 0x00000003},
-	{0x2b, 0x00000808}, {0x2b, 0x00063333},
-	{0x2c, 0x0000000d}, {0x2a, 0x00000004},
-	{0x2b, 0x00000808}, {0x2b, 0x0006b333},
-	{0x2c, 0x0000000d}, {0x2a, 0x00000005},
-	{0x2b, 0x00000808}, {0x2b, 0x00073333},
-	{0x2c, 0x0000000d}, {0x2a, 0x00000006},
-	{0x2b, 0x00000709}, {0x2b, 0x0005b333},
-	{0x2c, 0x0000000d}, {0x2a, 0x00000007},
-	{0x2b, 0x00000709}, {0x2b, 0x00063333},
-	{0x2c, 0x0000000d}, {0x2a, 0x00000008},
-	{0x2b, 0x0000060a}, {0x2b, 0x0004b333},
-	{0x2c, 0x0000000d}, {0x2a, 0x00000009},
-	{0x2b, 0x0000060a}, {0x2b, 0x00053333},
-	{0x2c, 0x0000000d}, {0x2a, 0x0000000a},
-	{0x2b, 0x0000060a}, {0x2b, 0x0005b333},
-	{0x2c, 0x0000000d}, {0x2a, 0x0000000b},
-	{0x2b, 0x0000060a}, {0x2b, 0x00063333},
-	{0x2c, 0x0000000d}, {0x2a, 0x0000000c},
-	{0x2b, 0x0000060a}, {0x2b, 0x0006b333},
-	{0x2c, 0x0000000d}, {0x2a, 0x0000000d},
-	{0x2b, 0x0000060a}, {0x2b, 0x00073333},
-	{0x2c, 0x0000000d}, {0x2a, 0x0000000e},
-	{0x2b, 0x0000050b}, {0x2b, 0x00066666},
-	{0x2c, 0x0000001a}, {0x2a, 0x000e0000},
-	{0x10, 0x0004000f}, {0x11, 0x000e31fc},
-	{0x10, 0x0006000f}, {0x11, 0x000ff9f8},
-	{0x10, 0x0002000f}, {0x11, 0x000203f9},
-	{0x10, 0x0003000f}, {0x11, 0x000ff500},
-	{0x10, 0x00000000}, {0x11, 0x00000000},
-	{0x10, 0x0008000f}, {0x11, 0x0003f100},
-	{0x10, 0x0009000f}, {0x11, 0x00023100},
-	{0x12, 0x000d8000}, {0x12, 0x00090000},
-	{0x12, 0x00051000}, {0x12, 0x00012000},
-	{0x13, 0x00028fb4}, {0x13, 0x00024fa8},
-	{0x13, 0x000207a4}, {0x13, 0x0001c3b0},
-	{0x13, 0x000183a4}, {0x13, 0x00014398},
-	{0x13, 0x000101a4}, {0x13, 0x0000c198},
-	{0x13, 0x000080a4}, {0x13, 0x00004098},
-	{0x13, 0x00000000}, {0x14, 0x0001944c},
-	{0x14, 0x00059444}, {0x14, 0x0009944c},
-	{0x14, 0x000d9444}, {0x15, 0x0000f405},
-	{0x15, 0x0004f405}, {0x15, 0x0008f405},
-	{0x15, 0x000cf405}, {0x16, 0x000e0330},
-	{0x16, 0x000a0330}, {0x16, 0x00060330},
-	{0x16, 0x00020330}, {0x00, 0x00010159},
-	{0x18, 0x0000f401}, {0xfe, 0x00000000},
-	{0xfe, 0x00000000}, {0x1f, 0x00080003},
-	{0xfe, 0x00000000}, {0xfe, 0x00000000},
-	{0x1e, 0x00044457}, {0x1f, 0x00080000},
-	{0x00, 0x00030159},
-	{0xff, 0xffffffff}
-};
-#endif
-
 static struct rtl8xxxu_rfregs rtl8xxxu_rfregs[] = {
 	{	/* RF_A */
 		.hssiparm1 = REG_FPGA0_XA_HSSI_PARM1,
@@ -2013,83 +1716,6 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 	return 0;
 }
 
-#ifdef CONFIG_RTL8XXXU_UNTESTED
-
-static int rtl8192cu_parse_efuse(struct rtl8xxxu_priv *priv)
-{
-	struct rtl8192cu_efuse *efuse = &priv->efuse_wifi.efuse8192;
-	int i;
-
-	if (efuse->rtl_id != cpu_to_le16(0x8129))
-		return -EINVAL;
-
-	ether_addr_copy(priv->mac_addr, efuse->mac_addr);
-
-	memcpy(priv->cck_tx_power_index_A,
-	       efuse->cck_tx_power_index_A,
-	       sizeof(efuse->cck_tx_power_index_A));
-	memcpy(priv->cck_tx_power_index_B,
-	       efuse->cck_tx_power_index_B,
-	       sizeof(efuse->cck_tx_power_index_B));
-
-	memcpy(priv->ht40_1s_tx_power_index_A,
-	       efuse->ht40_1s_tx_power_index_A,
-	       sizeof(efuse->ht40_1s_tx_power_index_A));
-	memcpy(priv->ht40_1s_tx_power_index_B,
-	       efuse->ht40_1s_tx_power_index_B,
-	       sizeof(efuse->ht40_1s_tx_power_index_B));
-	memcpy(priv->ht40_2s_tx_power_index_diff,
-	       efuse->ht40_2s_tx_power_index_diff,
-	       sizeof(efuse->ht40_2s_tx_power_index_diff));
-
-	memcpy(priv->ht20_tx_power_index_diff,
-	       efuse->ht20_tx_power_index_diff,
-	       sizeof(efuse->ht20_tx_power_index_diff));
-	memcpy(priv->ofdm_tx_power_index_diff,
-	       efuse->ofdm_tx_power_index_diff,
-	       sizeof(efuse->ofdm_tx_power_index_diff));
-
-	memcpy(priv->ht40_max_power_offset,
-	       efuse->ht40_max_power_offset,
-	       sizeof(efuse->ht40_max_power_offset));
-	memcpy(priv->ht20_max_power_offset,
-	       efuse->ht20_max_power_offset,
-	       sizeof(efuse->ht20_max_power_offset));
-
-	dev_info(&priv->udev->dev, "Vendor: %.7s\n",
-		 efuse->vendor_name);
-	dev_info(&priv->udev->dev, "Product: %.20s\n",
-		 efuse->device_name);
-
-	priv->power_base = &rtl8192c_power_base;
-
-	if (efuse->rf_regulatory & 0x20) {
-		sprintf(priv->chip_name, "8188RU");
-		priv->rtl_chip = RTL8188R;
-		priv->hi_pa = 1;
-		priv->no_pape = 1;
-		priv->power_base = &rtl8188r_power_base;
-	}
-
-	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_EFUSE) {
-		unsigned char *raw = priv->efuse_wifi.raw;
-
-		dev_info(&priv->udev->dev,
-			 "%s: dumping efuse (0x%02zx bytes):\n",
-			 __func__, sizeof(struct rtl8192cu_efuse));
-		for (i = 0; i < sizeof(struct rtl8192cu_efuse); i += 8) {
-			dev_info(&priv->udev->dev, "%02x: "
-				 "%02x %02x %02x %02x %02x %02x %02x %02x\n", i,
-				 raw[i], raw[i + 1], raw[i + 2],
-				 raw[i + 3], raw[i + 4], raw[i + 5],
-				 raw[i + 6], raw[i + 7]);
-		}
-	}
-	return 0;
-}
-
-#endif
-
 static int
 rtl8xxxu_read_efuse8(struct rtl8xxxu_priv *priv, u16 offset, u8 *data)
 {
@@ -2442,27 +2068,6 @@ exit:
 	return ret;
 }
 
-#ifdef CONFIG_RTL8XXXU_UNTESTED
-
-static int rtl8192cu_load_firmware(struct rtl8xxxu_priv *priv)
-{
-	char *fw_name;
-	int ret;
-
-	if (!priv->vendor_umc)
-		fw_name = "rtlwifi/rtl8192cufw_TMSC.bin";
-	else if (priv->chip_cut || priv->rtl_chip == RTL8192C)
-		fw_name = "rtlwifi/rtl8192cufw_B.bin";
-	else
-		fw_name = "rtlwifi/rtl8192cufw_A.bin";
-
-	ret = rtl8xxxu_load_firmware(priv, fw_name);
-
-	return ret;
-}
-
-#endif
-
 void rtl8xxxu_firmware_self_reset(struct rtl8xxxu_priv *priv)
 {
 	u16 val16;
@@ -2798,32 +2403,6 @@ int rtl8xxxu_init_phy_rf(struct rtl8xxxu_priv *priv,
 	return 0;
 }
 
-#ifdef CONFIG_RTL8XXXU_UNTESTED
-static int rtl8192cu_init_phy_rf(struct rtl8xxxu_priv *priv)
-{
-	struct rtl8xxxu_rfregval *rftable;
-	int ret;
-
-	if (priv->rtl_chip == RTL8188R) {
-		rftable = rtl8188ru_radioa_1t_highpa_table;
-		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_A);
-	} else if (priv->rf_paths == 1) {
-		rftable = rtl8192cu_radioa_1t_init_table;
-		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_A);
-	} else {
-		rftable = rtl8192cu_radioa_2t_init_table;
-		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_A);
-		if (ret)
-			goto exit;
-		rftable = rtl8192cu_radiob_2t_init_table;
-		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_B);
-	}
-
-exit:
-	return ret;
-}
-#endif
-
 static int rtl8xxxu_llt_write(struct rtl8xxxu_priv *priv, u8 address, u8 data)
 {
 	int ret = -EBUSY;
@@ -4151,115 +3730,6 @@ void rtl8xxxu_gen2_usb_quirks(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write32(priv, REG_TXDMA_OFFSET_CHK, val32);
 }
 
-#ifdef CONFIG_RTL8XXXU_UNTESTED
-
-static int rtl8192cu_power_on(struct rtl8xxxu_priv *priv)
-{
-	u8 val8;
-	u16 val16;
-	u32 val32;
-	int i;
-
-	for (i = 100; i; i--) {
-		val8 = rtl8xxxu_read8(priv, REG_APS_FSMCO);
-		if (val8 & APS_FSMCO_PFM_ALDN)
-			break;
-	}
-
-	if (!i) {
-		pr_info("%s: Poll failed\n", __func__);
-		return -ENODEV;
-	}
-
-	/*
-	 * RSV_CTRL 0x001C[7:0] = 0x00, unlock ISO/CLK/Power control register
-	 */
-	rtl8xxxu_write8(priv, REG_RSV_CTRL, 0x0);
-	rtl8xxxu_write8(priv, REG_SPS0_CTRL, 0x2b);
-	udelay(100);
-
-	val8 = rtl8xxxu_read8(priv, REG_LDOV12D_CTRL);
-	if (!(val8 & LDOV12D_ENABLE)) {
-		pr_info("%s: Enabling LDOV12D (%02x)\n", __func__, val8);
-		val8 |= LDOV12D_ENABLE;
-		rtl8xxxu_write8(priv, REG_LDOV12D_CTRL, val8);
-
-		udelay(100);
-
-		val8 = rtl8xxxu_read8(priv, REG_SYS_ISO_CTRL);
-		val8 &= ~SYS_ISO_MD2PP;
-		rtl8xxxu_write8(priv, REG_SYS_ISO_CTRL, val8);
-	}
-
-	/*
-	 * Auto enable WLAN
-	 */
-	val16 = rtl8xxxu_read16(priv, REG_APS_FSMCO);
-	val16 |= APS_FSMCO_MAC_ENABLE;
-	rtl8xxxu_write16(priv, REG_APS_FSMCO, val16);
-
-	for (i = 1000; i; i--) {
-		val16 = rtl8xxxu_read16(priv, REG_APS_FSMCO);
-		if (!(val16 & APS_FSMCO_MAC_ENABLE))
-			break;
-	}
-	if (!i) {
-		pr_info("%s: FSMCO_MAC_ENABLE poll failed\n", __func__);
-		return -EBUSY;
-	}
-
-	/*
-	 * Enable radio, GPIO, LED
-	 */
-	val16 = APS_FSMCO_HW_SUSPEND | APS_FSMCO_ENABLE_POWERDOWN |
-		APS_FSMCO_PFM_ALDN;
-	rtl8xxxu_write16(priv, REG_APS_FSMCO, val16);
-
-	/*
-	 * Release RF digital isolation
-	 */
-	val16 = rtl8xxxu_read16(priv, REG_SYS_ISO_CTRL);
-	val16 &= ~SYS_ISO_DIOR;
-	rtl8xxxu_write16(priv, REG_SYS_ISO_CTRL, val16);
-
-	val8 = rtl8xxxu_read8(priv, REG_APSD_CTRL);
-	val8 &= ~APSD_CTRL_OFF;
-	rtl8xxxu_write8(priv, REG_APSD_CTRL, val8);
-	for (i = 200; i; i--) {
-		val8 = rtl8xxxu_read8(priv, REG_APSD_CTRL);
-		if (!(val8 & APSD_CTRL_OFF_STATUS))
-			break;
-	}
-
-	if (!i) {
-		pr_info("%s: APSD_CTRL poll failed\n", __func__);
-		return -EBUSY;
-	}
-
-	/*
-	 * Enable MAC DMA/WMAC/SCHEDULE/SEC block
-	 */
-	val16 = rtl8xxxu_read16(priv, REG_CR);
-	val16 |= CR_HCI_TXDMA_ENABLE | CR_HCI_RXDMA_ENABLE |
-		CR_TXDMA_ENABLE | CR_RXDMA_ENABLE | CR_PROTOCOL_ENABLE |
-		CR_SCHEDULE_ENABLE | CR_MAC_TX_ENABLE | CR_MAC_RX_ENABLE;
-	rtl8xxxu_write16(priv, REG_CR, val16);
-
-	rtl8xxxu_write8(priv, 0xfe10, 0x19);
-
-	/*
-	 * Workaround for 8188RU LNA power leakage problem.
-	 */
-	if (priv->rtl_chip == RTL8188R) {
-		val32 = rtl8xxxu_read32(priv, REG_FPGA0_XCD_RF_PARM);
-		val32 &= ~BIT(1);
-		rtl8xxxu_write32(priv, REG_FPGA0_XCD_RF_PARM, val32);
-	}
-	return 0;
-}
-
-#endif
-
 void rtl8xxxu_power_off(struct rtl8xxxu_priv *priv)
 {
 	u8 val8;
@@ -6492,43 +5962,6 @@ static void rtl8xxxu_disconnect(struct usb_interface *interface)
 	ieee80211_free_hw(hw);
 }
 
-#ifdef CONFIG_RTL8XXXU_UNTESTED
-
-static struct rtl8xxxu_fileops rtl8192cu_fops = {
-	.parse_efuse = rtl8192cu_parse_efuse,
-	.load_firmware = rtl8192cu_load_firmware,
-	.power_on = rtl8192cu_power_on,
-	.power_off = rtl8xxxu_power_off,
-	.reset_8051 = rtl8xxxu_reset_8051,
-	.llt_init = rtl8xxxu_init_llt_table,
-	.init_phy_bb = rtl8xxxu_gen1_init_phy_bb,
-	.init_phy_rf = rtl8192cu_init_phy_rf,
-	.phy_iq_calibrate = rtl8xxxu_gen1_phy_iq_calibrate,
-	.config_channel = rtl8xxxu_gen1_config_channel,
-	.parse_rx_desc = rtl8xxxu_parse_rxdesc16,
-	.enable_rf = rtl8xxxu_gen1_enable_rf,
-	.disable_rf = rtl8xxxu_gen1_disable_rf,
-	.usb_quirks = rtl8xxxu_gen1_usb_quirks,
-	.set_tx_power = rtl8xxxu_gen1_set_tx_power,
-	.update_rate_mask = rtl8xxxu_update_rate_mask,
-	.report_connect = rtl8xxxu_gen1_report_connect,
-	.writeN_block_size = 128,
-	.mbox_ext_reg = REG_HMBOX_EXT_0,
-	.mbox_ext_width = 2,
-	.tx_desc_size = sizeof(struct rtl8xxxu_txdesc32),
-	.rx_desc_size = sizeof(struct rtl8xxxu_rxdesc16),
-	.adda_1t_init = 0x0b1b25a0,
-	.adda_1t_path_on = 0x0bdb25a0,
-	.adda_2t_path_on_a = 0x04db25a4,
-	.adda_2t_path_on_b = 0x0b1b25a4,
-	.trxff_boundary = 0x27ff,
-	.pbp_rx = PBP_PAGE_SIZE_128,
-	.pbp_tx = PBP_PAGE_SIZE_128,
-	.mactable = rtl8xxxu_gen1_mac_init_table,
-};
-
-#endif
-
 static struct usb_device_id dev_table[] = {
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x8724, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8723au_fops},
-- 
2.5.5

