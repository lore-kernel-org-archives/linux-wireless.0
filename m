Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61675 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1AWKZ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Jan 2011 05:25:27 -0500
Received: by bwz15 with SMTP id 15so2792892bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 23 Jan 2011 02:25:26 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: wrong values are returned in gpio_power_write()
Date: Sun, 23 Jan 2011 12:25:27 +0200
Message-Id: <1295778327-20545-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Return values were assigned to incorrect var / weren't assigned.
fix it, and defer mutex_lock after the sanity checks.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 36e7ec1..1f85dc2 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -261,27 +261,25 @@ static ssize_t gpio_power_write(struct file *file,
 	unsigned long value;
 	int ret;
 
-	mutex_lock(&wl->mutex);
-
 	len = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, user_buf, len)) {
-		ret = -EFAULT;
-		goto out;
+		return -EFAULT;
 	}
 	buf[len] = '\0';
 
 	ret = strict_strtoul(buf, 0, &value);
 	if (ret < 0) {
 		wl1271_warning("illegal value in gpio_power");
-		goto out;
+		return -EINVAL;
 	}
 
+	mutex_lock(&wl->mutex);
+
 	if (value)
 		wl1271_power_on(wl);
 	else
 		wl1271_power_off(wl);
 
-out:
 	mutex_unlock(&wl->mutex);
 	return count;
 }
-- 
1.7.0.4

