Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:44399 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757939Ab1DAPnk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 11:43:40 -0400
Received: by eyd9 with SMTP id 9so1083728eyd.28
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 08:43:38 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] wl12xx: use kstrtoul functions
Date: Fri,  1 Apr 2011 18:44:13 +0300
Message-Id: <1301672653-29946-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the new kstrtoul functions instead of the deprecated strict_strtoul().

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |    2 +-
 drivers/net/wireless/wl12xx/main.c    |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 8e75b09..70ab198 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -267,7 +267,7 @@ static ssize_t gpio_power_write(struct file *file,
 	}
 	buf[len] = '\0';
 
-	ret = strict_strtoul(buf, 0, &value);
+	ret = kstrtoul(buf, 0, &value);
 	if (ret < 0) {
 		wl1271_warning("illegal value in gpio_power");
 		return -EINVAL;
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 7126506..a5a5d01 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3397,8 +3397,7 @@ static ssize_t wl1271_sysfs_store_bt_coex_state(struct device *dev,
 	unsigned long res;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &res);
-
+	ret = kstrtoul(buf, 10, &res);
 	if (ret < 0) {
 		wl1271_warning("incorrect value written to bt_coex_mode");
 		return count;
-- 
1.7.1

