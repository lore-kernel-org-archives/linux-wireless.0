Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:58927 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758336Ab3EGNgQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 09:36:16 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>, <arik@wizery.com>, <eliad@wizery.com>
Subject: [PATCH 2/2] wlcore: move sysfs handling to a separate file
Date: Tue, 7 May 2013 16:34:50 +0300
Message-ID: <1367933690-6169-2-git-send-email-coelho@ti.com> (sfid-20130507_153619_356173_D3D112C0)
In-Reply-To: <1367933690-6169-1-git-send-email-coelho@ti.com>
References: <1367933690-6169-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of doing all the sysfs file handling in the main file, move it
to a new sysfs source file to reduce the amount of code in a single
file.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/Makefile |    2 +-
 drivers/net/wireless/ti/wlcore/main.c   |  178 +------------------------
 drivers/net/wireless/ti/wlcore/sysfs.c  |  216 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/sysfs.h  |   28 ++++
 4 files changed, 249 insertions(+), 175 deletions(-)
 create mode 100644 drivers/net/wireless/ti/wlcore/sysfs.c
 create mode 100644 drivers/net/wireless/ti/wlcore/sysfs.h

diff --git a/drivers/net/wireless/ti/wlcore/Makefile b/drivers/net/wireless/ti/wlcore/Makefile
index b21398f..4f23931 100644
--- a/drivers/net/wireless/ti/wlcore/Makefile
+++ b/drivers/net/wireless/ti/wlcore/Makefile
@@ -1,5 +1,5 @@
 wlcore-objs		= main.o cmd.o io.o event.o tx.o rx.o ps.o acx.o \
-			  boot.o init.o debugfs.o scan.o
+			  boot.o init.o debugfs.o scan.o sysfs.o
 
 wlcore_spi-objs 	= spi.o
 wlcore_sdio-objs	= sdio.o
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 04074f7..f2ee40d 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -39,6 +39,7 @@
 #include "testmode.h"
 #include "scan.h"
 #include "hw_ops.h"
+#include "sysfs.h"
 
 #define WL1271_BOOT_RETRIES 3
 
@@ -5387,151 +5388,6 @@ u8 wlcore_rate_to_idx(struct wl1271 *wl, u8 rate, enum ieee80211_band band)
 	return idx;
 }
 
-static ssize_t wl1271_sysfs_show_bt_coex_state(struct device *dev,
-					       struct device_attribute *attr,
-					       char *buf)
-{
-	struct wl1271 *wl = dev_get_drvdata(dev);
-	ssize_t len;
-
-	len = PAGE_SIZE;
-
-	mutex_lock(&wl->mutex);
-	len = snprintf(buf, len, "%d\n\n0 - off\n1 - on\n",
-		       wl->sg_enabled);
-	mutex_unlock(&wl->mutex);
-
-	return len;
-
-}
-
-static ssize_t wl1271_sysfs_store_bt_coex_state(struct device *dev,
-						struct device_attribute *attr,
-						const char *buf, size_t count)
-{
-	struct wl1271 *wl = dev_get_drvdata(dev);
-	unsigned long res;
-	int ret;
-
-	ret = kstrtoul(buf, 10, &res);
-	if (ret < 0) {
-		wl1271_warning("incorrect value written to bt_coex_mode");
-		return count;
-	}
-
-	mutex_lock(&wl->mutex);
-
-	res = !!res;
-
-	if (res == wl->sg_enabled)
-		goto out;
-
-	wl->sg_enabled = res;
-
-	if (unlikely(wl->state != WLCORE_STATE_ON))
-		goto out;
-
-	ret = wl1271_ps_elp_wakeup(wl);
-	if (ret < 0)
-		goto out;
-
-	wl1271_acx_sg_enable(wl, wl->sg_enabled);
-	wl1271_ps_elp_sleep(wl);
-
- out:
-	mutex_unlock(&wl->mutex);
-	return count;
-}
-
-static DEVICE_ATTR(bt_coex_state, S_IRUGO | S_IWUSR,
-		   wl1271_sysfs_show_bt_coex_state,
-		   wl1271_sysfs_store_bt_coex_state);
-
-static ssize_t wl1271_sysfs_show_hw_pg_ver(struct device *dev,
-					   struct device_attribute *attr,
-					   char *buf)
-{
-	struct wl1271 *wl = dev_get_drvdata(dev);
-	ssize_t len;
-
-	len = PAGE_SIZE;
-
-	mutex_lock(&wl->mutex);
-	if (wl->hw_pg_ver >= 0)
-		len = snprintf(buf, len, "%d\n", wl->hw_pg_ver);
-	else
-		len = snprintf(buf, len, "n/a\n");
-	mutex_unlock(&wl->mutex);
-
-	return len;
-}
-
-static DEVICE_ATTR(hw_pg_ver, S_IRUGO,
-		   wl1271_sysfs_show_hw_pg_ver, NULL);
-
-static ssize_t wl1271_sysfs_read_fwlog(struct file *filp, struct kobject *kobj,
-				       struct bin_attribute *bin_attr,
-				       char *buffer, loff_t pos, size_t count)
-{
-	struct device *dev = container_of(kobj, struct device, kobj);
-	struct wl1271 *wl = dev_get_drvdata(dev);
-	ssize_t len;
-	int ret;
-
-	ret = mutex_lock_interruptible(&wl->mutex);
-	if (ret < 0)
-		return -ERESTARTSYS;
-
-	/* Let only one thread read the log at a time, blocking others */
-	while (wl->fwlog_size == 0) {
-		DEFINE_WAIT(wait);
-
-		prepare_to_wait_exclusive(&wl->fwlog_waitq,
-					  &wait,
-					  TASK_INTERRUPTIBLE);
-
-		if (wl->fwlog_size != 0) {
-			finish_wait(&wl->fwlog_waitq, &wait);
-			break;
-		}
-
-		mutex_unlock(&wl->mutex);
-
-		schedule();
-		finish_wait(&wl->fwlog_waitq, &wait);
-
-		if (signal_pending(current))
-			return -ERESTARTSYS;
-
-		ret = mutex_lock_interruptible(&wl->mutex);
-		if (ret < 0)
-			return -ERESTARTSYS;
-	}
-
-	/* Check if the fwlog is still valid */
-	if (wl->fwlog_size < 0) {
-		mutex_unlock(&wl->mutex);
-		return 0;
-	}
-
-	/* Seeking is not supported - old logs are not kept. Disregard pos. */
-	len = min(count, (size_t)wl->fwlog_size);
-	wl->fwlog_size -= len;
-	memcpy(buffer, wl->fwlog, len);
-
-	/* Make room for new messages */
-	memmove(wl->fwlog, wl->fwlog + len, wl->fwlog_size);
-
-	mutex_unlock(&wl->mutex);
-
-	return len;
-}
-
-static struct bin_attribute fwlog_attr = {
-	.attr = {.name = "fwlog", .mode = S_IRUSR},
-	.read = wl1271_sysfs_read_fwlog,
-};
-
 static void wl12xx_derive_mac_addresses(struct wl1271 *wl, u32 oui, u32 nic)
 {
 	int i;
@@ -5970,11 +5826,8 @@ int wlcore_free_hw(struct wl1271 *wl)
 	wake_up_interruptible_all(&wl->fwlog_waitq);
 	mutex_unlock(&wl->mutex);
 
-	device_remove_bin_file(wl->dev, &fwlog_attr);
-
-	device_remove_file(wl->dev, &dev_attr_hw_pg_ver);
+	wlcore_sysfs_free(wl);
 
-	device_remove_file(wl->dev, &dev_attr_bt_coex_state);
 	kfree(wl->buffer_32);
 	kfree(wl->mbox);
 	free_page((unsigned long)wl->fwlog);
@@ -6083,36 +5936,13 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 	if (ret)
 		goto out_irq;
 
-	/* Create sysfs file to control bt coex state */
-	ret = device_create_file(wl->dev, &dev_attr_bt_coex_state);
-	if (ret < 0) {
-		wl1271_error("failed to create sysfs file bt_coex_state");
+	ret = wlcore_sysfs_init(wl);
+	if (ret)
 		goto out_unreg;
-	}
-
-	/* Create sysfs file to get HW PG version */
-	ret = device_create_file(wl->dev, &dev_attr_hw_pg_ver);
-	if (ret < 0) {
-		wl1271_error("failed to create sysfs file hw_pg_ver");
-		goto out_bt_coex_state;
-	}
-
-	/* Create sysfs file for the FW log */
-	ret = device_create_bin_file(wl->dev, &fwlog_attr);
-	if (ret < 0) {
-		wl1271_error("failed to create sysfs file fwlog");
-		goto out_hw_pg_ver;
-	}
 
 	wl->initialized = true;
 	goto out;
 
-out_hw_pg_ver:
-	device_remove_file(wl->dev, &dev_attr_hw_pg_ver);
-
-out_bt_coex_state:
-	device_remove_file(wl->dev, &dev_attr_bt_coex_state);
-
 out_unreg:
 	wl1271_unregister_hw(wl);
 
diff --git a/drivers/net/wireless/ti/wlcore/sysfs.c b/drivers/net/wireless/ti/wlcore/sysfs.c
new file mode 100644
index 0000000..8e58349
--- /dev/null
+++ b/drivers/net/wireless/ti/wlcore/sysfs.c
@@ -0,0 +1,216 @@
+/*
+ * This file is part of wlcore
+ *
+ * Copyright (C) 2013 Texas Instruments Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include "wlcore.h"
+#include "debug.h"
+#include "ps.h"
+#include "sysfs.h"
+
+static ssize_t wl1271_sysfs_show_bt_coex_state(struct device *dev,
+					       struct device_attribute *attr,
+					       char *buf)
+{
+	struct wl1271 *wl = dev_get_drvdata(dev);
+	ssize_t len;
+
+	len = PAGE_SIZE;
+
+	mutex_lock(&wl->mutex);
+	len = snprintf(buf, len, "%d\n\n0 - off\n1 - on\n",
+		       wl->sg_enabled);
+	mutex_unlock(&wl->mutex);
+
+	return len;
+
+}
+
+static ssize_t wl1271_sysfs_store_bt_coex_state(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	struct wl1271 *wl = dev_get_drvdata(dev);
+	unsigned long res;
+	int ret;
+
+	ret = kstrtoul(buf, 10, &res);
+	if (ret < 0) {
+		wl1271_warning("incorrect value written to bt_coex_mode");
+		return count;
+	}
+
+	mutex_lock(&wl->mutex);
+
+	res = !!res;
+
+	if (res == wl->sg_enabled)
+		goto out;
+
+	wl->sg_enabled = res;
+
+	if (unlikely(wl->state != WLCORE_STATE_ON))
+		goto out;
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	wl1271_acx_sg_enable(wl, wl->sg_enabled);
+	wl1271_ps_elp_sleep(wl);
+
+ out:
+	mutex_unlock(&wl->mutex);
+	return count;
+}
+
+static DEVICE_ATTR(bt_coex_state, S_IRUGO | S_IWUSR,
+		   wl1271_sysfs_show_bt_coex_state,
+		   wl1271_sysfs_store_bt_coex_state);
+
+static ssize_t wl1271_sysfs_show_hw_pg_ver(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct wl1271 *wl = dev_get_drvdata(dev);
+	ssize_t len;
+
+	len = PAGE_SIZE;
+
+	mutex_lock(&wl->mutex);
+	if (wl->hw_pg_ver >= 0)
+		len = snprintf(buf, len, "%d\n", wl->hw_pg_ver);
+	else
+		len = snprintf(buf, len, "n/a\n");
+	mutex_unlock(&wl->mutex);
+
+	return len;
+}
+
+static DEVICE_ATTR(hw_pg_ver, S_IRUGO,
+		   wl1271_sysfs_show_hw_pg_ver, NULL);
+
+static ssize_t wl1271_sysfs_read_fwlog(struct file *filp, struct kobject *kobj,
+				       struct bin_attribute *bin_attr,
+				       char *buffer, loff_t pos, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct wl1271 *wl = dev_get_drvdata(dev);
+	ssize_t len;
+	int ret;
+
+	ret = mutex_lock_interruptible(&wl->mutex);
+	if (ret < 0)
+		return -ERESTARTSYS;
+
+	/* Let only one thread read the log at a time, blocking others */
+	while (wl->fwlog_size == 0) {
+		DEFINE_WAIT(wait);
+
+		prepare_to_wait_exclusive(&wl->fwlog_waitq,
+					  &wait,
+					  TASK_INTERRUPTIBLE);
+
+		if (wl->fwlog_size != 0) {
+			finish_wait(&wl->fwlog_waitq, &wait);
+			break;
+		}
+
+		mutex_unlock(&wl->mutex);
+
+		schedule();
+		finish_wait(&wl->fwlog_waitq, &wait);
+
+		if (signal_pending(current))
+			return -ERESTARTSYS;
+
+		ret = mutex_lock_interruptible(&wl->mutex);
+		if (ret < 0)
+			return -ERESTARTSYS;
+	}
+
+	/* Check if the fwlog is still valid */
+	if (wl->fwlog_size < 0) {
+		mutex_unlock(&wl->mutex);
+		return 0;
+	}
+
+	/* Seeking is not supported - old logs are not kept. Disregard pos. */
+	len = min(count, (size_t)wl->fwlog_size);
+	wl->fwlog_size -= len;
+	memcpy(buffer, wl->fwlog, len);
+
+	/* Make room for new messages */
+	memmove(wl->fwlog, wl->fwlog + len, wl->fwlog_size);
+
+	mutex_unlock(&wl->mutex);
+
+	return len;
+}
+
+static struct bin_attribute fwlog_attr = {
+	.attr = {.name = "fwlog", .mode = S_IRUSR},
+	.read = wl1271_sysfs_read_fwlog,
+};
+
+int wlcore_sysfs_init(struct wl1271 *wl)
+{
+	int ret;
+
+	/* Create sysfs file to control bt coex state */
+	ret = device_create_file(wl->dev, &dev_attr_bt_coex_state);
+	if (ret < 0) {
+		wl1271_error("failed to create sysfs file bt_coex_state");
+		goto out;
+	}
+
+	/* Create sysfs file to get HW PG version */
+	ret = device_create_file(wl->dev, &dev_attr_hw_pg_ver);
+	if (ret < 0) {
+		wl1271_error("failed to create sysfs file hw_pg_ver");
+		goto out_bt_coex_state;
+	}
+
+	/* Create sysfs file for the FW log */
+	ret = device_create_bin_file(wl->dev, &fwlog_attr);
+	if (ret < 0) {
+		wl1271_error("failed to create sysfs file fwlog");
+		goto out_hw_pg_ver;
+	}
+
+	goto out;
+
+out_hw_pg_ver:
+	device_remove_file(wl->dev, &dev_attr_hw_pg_ver);
+
+out_bt_coex_state:
+	device_remove_file(wl->dev, &dev_attr_bt_coex_state);
+
+out:
+	return ret;
+}
+
+void wlcore_sysfs_free(struct wl1271 *wl)
+{
+	device_remove_bin_file(wl->dev, &fwlog_attr);
+
+	device_remove_file(wl->dev, &dev_attr_hw_pg_ver);
+
+	device_remove_file(wl->dev, &dev_attr_bt_coex_state);
+}
diff --git a/drivers/net/wireless/ti/wlcore/sysfs.h b/drivers/net/wireless/ti/wlcore/sysfs.h
new file mode 100644
index 0000000..c148892
--- /dev/null
+++ b/drivers/net/wireless/ti/wlcore/sysfs.h
@@ -0,0 +1,28 @@
+/*
+ * This file is part of wlcore
+ *
+ * Copyright (C) 2013 Texas Instruments Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __SYSFS_H__
+#define __SYSFS_H__
+
+int wlcore_sysfs_init(struct wl1271 *wl);
+void wlcore_sysfs_free(struct wl1271 *wl);
+
+#endif
-- 
1.7.10.4

