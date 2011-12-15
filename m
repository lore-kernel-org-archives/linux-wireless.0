Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:53912 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089Ab1LOM6b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 07:58:31 -0500
Received: by lagw12 with SMTP id w12so1093949lag.2
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 04:58:28 -0800 (PST)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH] wl12xx: alloc buffer in driver_state_read to prevent compilation warning
Date: Thu, 15 Dec 2011 14:58:08 +0200
Message-Id: <1323953888-10988-1-git-send-email-coelho@ti.com> (sfid-20111215_135835_465205_A66526C5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When compiling wl12xx for x86, there was a warning complaining about
the size of the buffer we were allocating in the stack:

drivers/net/wireless/wl12xx/debugfs.c: In function 'driver_state_read':
drivers/net/wireless/wl12xx/debugfs.c:380:1: warning: the frame size of 1040 bytes is larger than 1024 bytes

To prevent this, allocate the buffer in the heap instead.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 2e14b43..15eb3a9 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -317,12 +317,19 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 {
 	struct wl1271 *wl = file->private_data;
 	int res = 0;
-	char buf[1024];
+	ssize_t ret;
+	char *buf;
+
+#define DRIVER_STATE_BUF_LEN 1024
+
+	buf = kmalloc(DRIVER_STATE_BUF_LEN, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 
 	mutex_lock(&wl->mutex);
 
 #define DRIVER_STATE_PRINT(x, fmt)   \
-	(res += scnprintf(buf + res, sizeof(buf) - res,\
+	(res += scnprintf(buf + res, DRIVER_STATE_BUF_LEN - res,\
 			  #x " = " fmt "\n", wl->x))
 
 #define DRIVER_STATE_PRINT_LONG(x) DRIVER_STATE_PRINT(x, "%ld")
@@ -373,10 +380,13 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 #undef DRIVER_STATE_PRINT_LHEX
 #undef DRIVER_STATE_PRINT_STR
 #undef DRIVER_STATE_PRINT
+#undef DRIVER_STATE_BUF_LEN
 
 	mutex_unlock(&wl->mutex);
 
-	return simple_read_from_buffer(user_buf, count, ppos, buf, res);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, res);
+	kfree(buf);
+	return ret;
 }
 
 static const struct file_operations driver_state_ops = {
-- 
1.7.4.1

