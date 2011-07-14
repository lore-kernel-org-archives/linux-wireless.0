Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:53097 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754564Ab1GNMyv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 08:54:51 -0400
Received: by wwi14 with SMTP id 14so243948wwi.17
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jul 2011 05:54:49 -0700 (PDT)
From: Gery Kahn <geryk@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH 2/2] wl12xx Export chip id to sysfs
Date: Thu, 14 Jul 2011 15:47:53 +0300
Message-Id: <1310647673-10144-2-git-send-email-geryk@ti.com> (sfid-20110714_145455_143940_9D6E964C)
In-Reply-To: <1310647673-10144-1-git-send-email-geryk@ti.com>
References: <1310647673-10144-1-git-send-email-geryk@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Export the chip id to userspace. This helps to change application behavior
according to architecture of the wl12xx chip.

Signed-off-by: Gery Kahn <geryk@ti.com>
---
 drivers/net/wireless/wl12xx/main.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index d65fef6..13a6cfa 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -4437,6 +4437,25 @@ static ssize_t wl1271_sysfs_show_hw_pg_ver(struct device *dev,
 static DEVICE_ATTR(hw_pg_ver, S_IRUGO,
 		   wl1271_sysfs_show_hw_pg_ver, NULL);
 
+static ssize_t wl1271_sysfs_show_chip_id(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct wl1271 *wl = dev_get_drvdata(dev);
+	ssize_t len;
+
+	len = PAGE_SIZE;
+
+	mutex_lock(&wl->mutex);
+	len = snprintf(buf, len, "0x%x\n", wl->chip.id);
+	mutex_unlock(&wl->mutex);
+
+	return len;
+}
+
+static DEVICE_ATTR(chip_id, S_IRUGO,
+		   wl1271_sysfs_show_chip_id, NULL);
+
 static ssize_t wl1271_sysfs_read_fwlog(struct file *filp, struct kobject *kobj,
 				       struct bin_attribute *bin_attr,
 				       char *buffer, loff_t pos, size_t count)
@@ -4803,8 +4822,17 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 		goto err_hw_pg_ver;
 	}
 
+	ret = device_create_file(&wl->plat_dev->dev, &dev_attr_chip_id);
+	if (ret < 0) {
+		wl1271_error("failed to create sysfs file chip_id");
+		goto err_fwlog_attr;
+	}
+
 	return hw;
 
+err_fwlog_attr:
+	device_remove_bin_file(&wl->plat_dev->dev, &fwlog_attr);
+
 err_hw_pg_ver:
 	device_remove_file(&wl->plat_dev->dev, &dev_attr_hw_pg_ver);
 
@@ -4849,6 +4877,8 @@ int wl1271_free_hw(struct wl1271 *wl)
 
 	device_remove_bin_file(&wl->plat_dev->dev, &fwlog_attr);
 
+	device_remove_file(&wl->plat_dev->dev, &dev_attr_chip_id);
+
 	device_remove_file(&wl->plat_dev->dev, &dev_attr_hw_pg_ver);
 
 	device_remove_file(&wl->plat_dev->dev, &dev_attr_bt_coex_state);
-- 
1.7.0.4

