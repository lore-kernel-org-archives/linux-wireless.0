Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:60527 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591AbZLKNlz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 08:41:55 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 13/31] wl1271: add gpio_power file in debugfs to power the chip on and off
Date: Fri, 11 Dec 2009 15:40:52 +0200
Message-Id: <1260538870-32297-14-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
References: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some debugging tools require the chip to be powered on before they can work.
With these tools, we shouldn't upload the firmware nor boot the firmware
ourselves, so this debufs file is provided.  It always contains the gpio
power setting (0 = off, 1 = on).  To change the power setting, just write 0
or 1 to the file.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h         |    3 +
 drivers/net/wireless/wl12xx/wl1271_debugfs.c |   55 ++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_main.c    |    3 +
 3 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 94359b1..3bec6f3 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -276,6 +276,7 @@ struct wl1271_debugfs {
 
 	struct dentry *retry_count;
 	struct dentry *excessive_retries;
+	struct dentry *gpio_power;
 };
 
 #define NUM_TX_QUEUES              4
@@ -442,6 +443,8 @@ struct wl1271 {
 	struct conf_drv_settings conf;
 
 	struct list_head list;
+
+	bool gpio_power;
 };
 
 int wl1271_plt_start(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_debugfs.c b/drivers/net/wireless/wl12xx/wl1271_debugfs.c
index c1805e5..4eaf40c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_debugfs.c
+++ b/drivers/net/wireless/wl12xx/wl1271_debugfs.c
@@ -237,6 +237,57 @@ static const struct file_operations tx_queue_len_ops = {
 	.open = wl1271_open_file_generic,
 };
 
+static ssize_t gpio_power_read(struct file *file, char __user *user_buf,
+			  size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+	int res;
+	char buf[10];
+
+	res = scnprintf(buf, sizeof(buf), "%d\n", wl->gpio_power);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, res);
+}
+
+static ssize_t gpio_power_write(struct file *file,
+			   const char __user *user_buf,
+			   size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+	char buf[10];
+	size_t len;
+	unsigned long value;
+	int ret;
+
+	mutex_lock(&wl->mutex);
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len)) {
+		ret = -EFAULT;
+		goto out;
+	}
+	buf[len] = '\0';
+
+	ret = strict_strtoul(buf, 0, &value);
+	if (ret < 0) {
+		wl1271_warning("illegal value in gpio_power");
+		goto out;
+	}
+
+	wl->set_power(!!value);
+	wl->gpio_power = !!value;
+
+out:
+	mutex_unlock(&wl->mutex);
+	return count;
+}
+
+static const struct file_operations gpio_power_ops = {
+	.read = gpio_power_read,
+	.write = gpio_power_write,
+	.open = wl1271_open_file_generic
+};
+
 static void wl1271_debugfs_delete_files(struct wl1271 *wl)
 {
 	DEBUGFS_FWSTATS_DEL(tx, internal_desc_overflow);
@@ -333,6 +384,8 @@ static void wl1271_debugfs_delete_files(struct wl1271 *wl)
 	DEBUGFS_DEL(tx_queue_len);
 	DEBUGFS_DEL(retry_count);
 	DEBUGFS_DEL(excessive_retries);
+
+	DEBUGFS_DEL(gpio_power);
 }
 
 static int wl1271_debugfs_add_files(struct wl1271 *wl)
@@ -434,6 +487,8 @@ static int wl1271_debugfs_add_files(struct wl1271 *wl)
 	DEBUGFS_ADD(retry_count, wl->debugfs.rootdir);
 	DEBUGFS_ADD(excessive_retries, wl->debugfs.rootdir);
 
+	DEBUGFS_ADD(gpio_power, wl->debugfs.rootdir);
+
 out:
 	if (ret < 0)
 		wl1271_debugfs_delete_files(wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 147aab2..b33bdcc 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -399,11 +399,13 @@ static void wl1271_disable_interrupts(struct wl1271 *wl)
 static void wl1271_power_off(struct wl1271 *wl)
 {
 	wl->set_power(false);
+	wl->gpio_power = false;
 }
 
 static void wl1271_power_on(struct wl1271 *wl)
 {
 	wl->set_power(true);
+	wl->gpio_power = true;
 }
 
 static void wl1271_fw_status(struct wl1271 *wl,
@@ -1923,6 +1925,7 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	wl->band = IEEE80211_BAND_2GHZ;
 	wl->vif = NULL;
 	wl->joined = false;
+	wl->gpio_power = false;
 
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
 		wl->tx_frames[i] = NULL;
-- 
1.6.3.3

