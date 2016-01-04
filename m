Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34505 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbcADTdx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2016 14:33:53 -0500
From: Hugo Camboulive <hugo.camboulive@gmail.com>
To: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Hugo Camboulive <hugo.camboulive@gmail.com>
Subject: [PATCH] staging: wilc1000: add missing __user attribute
Date: Mon,  4 Jan 2016 20:33:50 +0000
Message-Id: <1451939630-6336-1-git-send-email-hugo.camboulive@gmail.com> (sfid-20160104_203419_341742_5A8301DA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes a Sparse warning.

Signed-off-by: Hugo Camboulive <hugo.camboulive@gmail.com>
---
 drivers/staging/wilc1000/wilc_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index 27c653a..291e6fa 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -89,7 +89,7 @@ static ssize_t wilc_debug_region_read(struct file *file, char __user *userbuf, s
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
 }
 
-static ssize_t wilc_debug_region_write(struct file *filp, const char *buf, size_t count, loff_t *ppos)
+static ssize_t wilc_debug_region_write(struct file *filp, const char __user *buf, size_t count, loff_t *ppos)
 {
 	char buffer[128] = {};
 	int flag;
-- 
2.6.4

