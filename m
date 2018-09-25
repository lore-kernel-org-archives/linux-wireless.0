Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0261C43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 06:25:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B2D521480
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 06:25:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B2D521480
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbeIYMbU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 08:31:20 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:12212 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726507AbeIYMbT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 08:31:19 -0400
X-IronPort-AV: E=Sophos;i="5.54,301,1534834800"; 
   d="scan'208";a="20543249"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 24 Sep 2018 23:25:20 -0700
Received: from ajaysk-VirtualBox.microchip.com (10.10.76.4) by
 chn-sv-exch03.mchp-main.com (10.10.76.49) with Microsoft SMTP Server id
 14.3.352.0; Mon, 24 Sep 2018 23:25:19 -0700
From:   Ajay Singh <ajay.kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v3 25/29] staging: wilc1000: remove wilc_debugfs.c file as its not used
Date:   Tue, 25 Sep 2018 11:53:40 +0530
Message-ID: <1537856624-22157-26-git-send-email-ajay.kathat@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1537856624-22157-1-git-send-email-ajay.kathat@microchip.com>
References: <1537856624-22157-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Deleted wilc_debugfs.c file as it's not used.

Earlier discussion link:
[1]. https://www.spinics.net/lists/linux-wireless/msg176076.html

Suggested-by: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/Makefile       |   5 +-
 drivers/staging/wilc1000/wilc_debugfs.c | 115 --------------------------------
 2 files changed, 2 insertions(+), 118 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/wilc_debugfs.c

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index ee7e26b..5718bc4 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -4,12 +4,11 @@ obj-$(CONFIG_WILC1000) += wilc1000.o
 ccflags-y += -DFIRMWARE_1002=\"atmel/wilc1002_firmware.bin\" \
 		-DFIRMWARE_1003=\"atmel/wilc1003_firmware.bin\"
 
-ccflags-y += -I$(src)/ -DWILC_ASIC_A0 -DWILC_DEBUGFS
+ccflags-y += -I$(src)/ -DWILC_ASIC_A0
 
 wilc1000-objs := wilc_wfi_cfgoperations.o linux_wlan.o linux_mon.o \
 			coreconfigurator.o host_interface.o \
-			wilc_wlan_cfg.o wilc_debugfs.o \
-			wilc_wlan.o
+			wilc_wlan_cfg.o wilc_wlan.o
 
 obj-$(CONFIG_WILC1000_SDIO) += wilc1000-sdio.o
 wilc1000-sdio-objs += wilc_sdio.o
diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
deleted file mode 100644
index 8001df6..0000000
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ /dev/null
@@ -1,115 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiaries.
- * All rights reserved.
- */
-
-#if defined(WILC_DEBUGFS)
-#include <linux/module.h>
-#include <linux/debugfs.h>
-
-#include "wilc_wlan_if.h"
-
-static struct dentry *wilc_dir;
-
-#define DEBUG           BIT(0)
-#define INFO            BIT(1)
-#define WRN             BIT(2)
-#define ERR             BIT(3)
-
-#define DBG_LEVEL_ALL	(DEBUG | INFO | WRN | ERR)
-static atomic_t WILC_DEBUG_LEVEL = ATOMIC_INIT(ERR);
-EXPORT_SYMBOL_GPL(WILC_DEBUG_LEVEL);
-
-static ssize_t wilc_debug_level_read(struct file *file, char __user *userbuf,
-				     size_t count, loff_t *ppos)
-{
-	char buf[128];
-	int res = 0;
-
-	/* only allow read from start */
-	if (*ppos > 0)
-		return 0;
-
-	res = scnprintf(buf, sizeof(buf), "Debug Level: %x\n",
-			atomic_read(&WILC_DEBUG_LEVEL));
-
-	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
-}
-
-static ssize_t wilc_debug_level_write(struct file *filp,
-				      const char __user *buf, size_t count,
-				      loff_t *ppos)
-{
-	int flag = 0;
-	int ret;
-
-	ret = kstrtouint_from_user(buf, count, 16, &flag);
-	if (ret)
-		return ret;
-
-	if (flag > DBG_LEVEL_ALL) {
-		pr_info("%s, value (0x%08x) is out of range, stay previous flag (0x%08x)\n",
-			__func__, flag, atomic_read(&WILC_DEBUG_LEVEL));
-		return -EINVAL;
-	}
-
-	atomic_set(&WILC_DEBUG_LEVEL, (int)flag);
-
-	if (flag == 0)
-		pr_info("Debug-level disabled\n");
-	else
-		pr_info("Debug-level enabled\n");
-
-	return count;
-}
-
-#define FOPS(_open, _read, _write, _poll) { \
-		.owner	= THIS_MODULE, \
-		.open	= (_open), \
-		.read	= (_read), \
-		.write	= (_write), \
-		.poll		= (_poll), \
-}
-
-struct wilc_debugfs_info_t {
-	const char *name;
-	int perm;
-	unsigned int data;
-	const struct file_operations fops;
-};
-
-static struct wilc_debugfs_info_t debugfs_info[] = {
-	{
-		"wilc_debug_level",
-		0666,
-		(DEBUG | ERR),
-		FOPS(NULL, wilc_debug_level_read, wilc_debug_level_write, NULL),
-	},
-};
-
-static int __init wilc_debugfs_init(void)
-{
-	int i;
-	struct wilc_debugfs_info_t *info;
-
-	wilc_dir = debugfs_create_dir("wilc_wifi", NULL);
-	for (i = 0; i < ARRAY_SIZE(debugfs_info); i++) {
-		info = &debugfs_info[i];
-		debugfs_create_file(info->name,
-				    info->perm,
-				    wilc_dir,
-				    &info->data,
-				    &info->fops);
-	}
-	return 0;
-}
-module_init(wilc_debugfs_init);
-
-static void __exit wilc_debugfs_remove(void)
-{
-	debugfs_remove_recursive(wilc_dir);
-}
-module_exit(wilc_debugfs_remove);
-
-#endif
-- 
2.7.4

