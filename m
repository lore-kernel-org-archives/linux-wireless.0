Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:37834 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaL2GYV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2014 01:24:21 -0500
Received: by mail-wg0-f50.google.com with SMTP id a1so18326252wgh.9
        for <linux-wireless@vger.kernel.org>; Sun, 28 Dec 2014 22:24:20 -0800 (PST)
Received: from muse.ger.corp.intel.com (85-250-108-142.bb.netvision.net.il. [85.250.108.142])
        by mx.google.com with ESMTPSA id gb10sm23488030wjb.21.2014.12.28.22.24.18
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 28 Dec 2014 22:24:19 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 02/13] wlcore: fix sparse warning
Date: Mon, 29 Dec 2014 08:24:02 +0200
Message-Id: <1419834253-18331-2-git-send-email-eliad@wizery.com> (sfid-20141229_072424_784947_B0371AA4)
In-Reply-To: <1419834253-18331-1-git-send-email-eliad@wizery.com>
References: <1419834253-18331-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use kstrtoul_from_user() for reading the user value,
and fix the following sparse warning:

drivers/net/wireless/ti/wlcore/debugfs.c:937:15: error: incompatible
types in comparison expression (different type sizes)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/debugfs.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index 0be21f6..68f3bf2 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -929,17 +929,10 @@ static ssize_t beacon_filtering_write(struct file *file,
 {
 	struct wl1271 *wl = file->private_data;
 	struct wl12xx_vif *wlvif;
-	char buf[10];
-	size_t len;
 	unsigned long value;
 	int ret;
 
-	len = min(count, sizeof(buf) - 1);
-	if (copy_from_user(buf, user_buf, len))
-		return -EFAULT;
-	buf[len] = '\0';
-
-	ret = kstrtoul(buf, 0, &value);
+	ret = kstrtoul_from_user(user_buf, count, 0, &value);
 	if (ret < 0) {
 		wl1271_warning("illegal value for beacon_filtering!");
 		return -EINVAL;
-- 
1.8.5.2.229.g4448466.dirty

