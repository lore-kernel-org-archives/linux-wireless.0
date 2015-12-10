Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:34167 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbbLKBHx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2015 20:07:53 -0500
Received: by lbbcs9 with SMTP id cs9so61607253lbb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Dec 2015 17:07:52 -0800 (PST)
From: Anatoly Stepanov <drivengroove@gmail.com>
To: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com
Cc: linux-wireless@vger.kernel.org,
	Anatoly Stepanov <drivengroove@gmail.com>
Subject: [PATCH 01/01] staging: wilc1000: add missing address space specifier
Date: Thu, 10 Dec 2015 05:17:29 +0300
Message-Id: <1449713849-32245-2-git-send-email-drivengroove@gmail.com> (sfid-20151211_020756_218341_9B7985A2)
In-Reply-To: <1449713849-32245-1-git-send-email-drivengroove@gmail.com>
References: <1449713849-32245-1-git-send-email-drivengroove@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the following sparse warnings:
1. warning: incorrect type in argument 2 (different address spaces)
2. warning: incorrect type in initializer (incompatible argument 2 (different address spaces))

Signed-off-by: Anatoly Stepanov <drivengroove@gmail.com>
---
 drivers/staging/wilc1000/wilc_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index ae11186..877659f 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -87,7 +87,7 @@ static ssize_t wilc_debug_region_read(struct file *file, char __user *userbuf, s
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
 }
 
-static ssize_t wilc_debug_region_write(struct file *filp, const char *buf, size_t count, loff_t *ppos)
+static ssize_t wilc_debug_region_write(struct file *filp, const char __user *buf, size_t count, loff_t *ppos)
 {
 	char buffer[128] = {};
 	int flag;
-- 
2.1.0

