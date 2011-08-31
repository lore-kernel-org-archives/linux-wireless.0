Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58541 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab1HaLsh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 07:48:37 -0400
Received: by wyh22 with SMTP id 22so61839wyh.19
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 04:48:35 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: use kstrtoul_from_user
Date: Wed, 31 Aug 2011 14:50:13 +0300
Message-Id: <1314791413-32358-1-git-send-email-eliad@wizery.com> (sfid-20110831_134840_290178_F57420B4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

simplify code by calling kstrtoul_from_user() (instead of
copy_from_user() + kstrtoul())

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |   46 +++-----------------------------
 1 files changed, 5 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index d59354f..a9af5af 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -265,18 +265,10 @@ static ssize_t gpio_power_write(struct file *file,
 			   size_t count, loff_t *ppos)
 {
 	struct wl1271 *wl = file->private_data;
-	char buf[10];
-	size_t len;
 	unsigned long value;
 	int ret;
 
-	len = min(count, sizeof(buf) - 1);
-	if (copy_from_user(buf, user_buf, len)) {
-		return -EFAULT;
-	}
-	buf[len] = '\0';
-
-	ret = kstrtoul(buf, 0, &value);
+	ret = kstrtoul_from_user(user_buf, count, 10, &value);
 	if (ret < 0) {
 		wl1271_warning("illegal value in gpio_power");
 		return -EINVAL;
@@ -427,17 +419,10 @@ static ssize_t dtim_interval_write(struct file *file,
 				   size_t count, loff_t *ppos)
 {
 	struct wl1271 *wl = file->private_data;
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
+	ret = kstrtoul_from_user(user_buf, count, 10, &value);
 	if (ret < 0) {
 		wl1271_warning("illegal value for dtim_interval");
 		return -EINVAL;
@@ -492,17 +477,10 @@ static ssize_t beacon_interval_write(struct file *file,
 				     size_t count, loff_t *ppos)
 {
 	struct wl1271 *wl = file->private_data;
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
+	ret = kstrtoul_from_user(user_buf, count, 10, &value);
 	if (ret < 0) {
 		wl1271_warning("illegal value for beacon_interval");
 		return -EINVAL;
@@ -542,17 +520,10 @@ static ssize_t rx_streaming_interval_write(struct file *file,
 			   size_t count, loff_t *ppos)
 {
 	struct wl1271 *wl = file->private_data;
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
+	ret = kstrtoul_from_user(user_buf, count, 10, &value);
 	if (ret < 0) {
 		wl1271_warning("illegal value in rx_streaming_interval!");
 		return -EINVAL;
@@ -601,17 +572,10 @@ static ssize_t rx_streaming_always_write(struct file *file,
 			   size_t count, loff_t *ppos)
 {
 	struct wl1271 *wl = file->private_data;
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
+	ret = kstrtoul_from_user(user_buf, count, 10, &value);
 	if (ret < 0) {
 		wl1271_warning("illegal value in rx_streaming_write!");
 		return -EINVAL;
-- 
1.7.6.401.g6a319

