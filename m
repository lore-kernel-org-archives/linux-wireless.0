Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:48615 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755747Ab2FWGmO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2012 02:42:14 -0400
Received: by lboj14 with SMTP id j14so6133339lbo.21
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2012 23:42:10 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com, ido@wizery.com,
	Arkady Miasnikov <a-miasnikov@ti.com>
Subject: [PATCH 12/18] wlcore: access the firmware memory via debugfs
Date: Sat, 23 Jun 2012 09:41:23 +0300
Message-Id: <1340433689-24320-13-git-send-email-coelho@ti.com> (sfid-20120623_084222_856022_CDC77A7C)
In-Reply-To: <1340433689-24320-1-git-send-email-coelho@ti.com>
References: <1340433689-24320-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arkady Miasnikov <a-miasnikov@ti.com>

Applications running in the user space needs access to the
memory of the chip. Examples of such access
- read/write global variables
- access to firmware log
- dump memory after firmware panic event

Arbitrary 4-bytes aligned location can be accessed by
read/write file wlcore/mem

[Check return value of wlcore_raw_read/write and wlcore_set_partition
calls as required by the recent IO changes. -- Luca]

Signed-off-by: Arkady Miasnikov <a-miasnikov@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/debugfs.c |  192 ++++++++++++++++++++++++++++++
 1 file changed, 192 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index 1768f37..80dbc53 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -38,6 +38,8 @@
 /* ms */
 #define WL1271_DEBUGFS_STATS_LIFETIME 1000
 
+#define WLCORE_MAX_BLOCK_SIZE ((size_t)(4*PAGE_SIZE))
+
 /* debugfs macros idea from mac80211 */
 int wl1271_format_buffer(char __user *userbuf, size_t count,
 			 loff_t *ppos, char *fmt, ...)
@@ -1025,6 +1027,195 @@ static const struct file_operations sleep_auth_ops = {
 	.llseek = default_llseek,
 };
 
+static ssize_t dev_mem_read(struct file *file,
+	     char __user *user_buf, size_t count,
+	     loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+	struct wlcore_partition_set part, old_part;
+	size_t bytes = count;
+	int ret;
+	char *buf;
+
+	/* only requests of dword-aligned size and offset are supported */
+	if (bytes % 4)
+		return -EINVAL;
+
+	if (*ppos % 4)
+		return -EINVAL;
+
+	/* function should return in reasonable time */
+	bytes = min(bytes, WLCORE_MAX_BLOCK_SIZE);
+
+	if (bytes == 0)
+		return -EINVAL;
+
+	memset(&part, 0, sizeof(part));
+	part.mem.start = file->f_pos;
+	part.mem.size = bytes;
+
+	buf = kmalloc(bytes, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	mutex_lock(&wl->mutex);
+
+	if (wl->state == WL1271_STATE_OFF) {
+		ret = -EFAULT;
+		goto skip_read;
+	}
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto skip_read;
+
+	/* store current partition and switch partition */
+	memcpy(&old_part, &wl->curr_part, sizeof(old_part));
+	ret = wlcore_set_partition(wl, &part);
+	if (ret < 0)
+		goto part_err;
+
+	ret = wlcore_raw_read(wl, 0, buf, bytes, false);
+	if (ret < 0)
+		goto read_err;
+
+read_err:
+	/* recover partition */
+	ret = wlcore_set_partition(wl, &old_part);
+	if (ret < 0)
+		goto part_err;
+
+part_err:
+	wl1271_ps_elp_sleep(wl);
+
+skip_read:
+	mutex_unlock(&wl->mutex);
+
+	if (ret == 0) {
+		ret = copy_to_user(user_buf, buf, bytes);
+		if (ret < bytes) {
+			bytes -= ret;
+			*ppos += bytes;
+			ret = 0;
+		} else {
+			ret = -EFAULT;
+		}
+	}
+
+	kfree(buf);
+
+	return ((ret == 0) ? bytes : ret);
+}
+
+static ssize_t dev_mem_write(struct file *file, const char __user *user_buf,
+		size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+	struct wlcore_partition_set part, old_part;
+	size_t bytes = count;
+	int ret;
+	char *buf;
+
+	/* only requests of dword-aligned size and offset are supported */
+	if (bytes % 4)
+		return -EINVAL;
+
+	if (*ppos % 4)
+		return -EINVAL;
+
+	/* function should return in reasonable time */
+	bytes = min(bytes, WLCORE_MAX_BLOCK_SIZE);
+
+	if (bytes == 0)
+		return -EINVAL;
+
+	memset(&part, 0, sizeof(part));
+	part.mem.start = file->f_pos;
+	part.mem.size = bytes;
+
+	buf = kmalloc(bytes, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = copy_from_user(buf, user_buf, bytes);
+	if (ret) {
+		ret = -EFAULT;
+		goto err_out;
+	}
+
+	mutex_lock(&wl->mutex);
+
+	if (wl->state == WL1271_STATE_OFF) {
+		ret = -EFAULT;
+		goto skip_write;
+	}
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto skip_write;
+
+	/* store current partition and switch partition */
+	memcpy(&old_part, &wl->curr_part, sizeof(old_part));
+	ret = wlcore_set_partition(wl, &part);
+	if (ret < 0)
+		goto part_err;
+
+	ret = wlcore_raw_write(wl, 0, buf, bytes, false);
+	if (ret < 0)
+		goto write_err;
+
+write_err:
+	/* recover partition */
+	ret = wlcore_set_partition(wl, &old_part);
+	if (ret < 0)
+		goto part_err;
+
+part_err:
+	wl1271_ps_elp_sleep(wl);
+
+skip_write:
+	mutex_unlock(&wl->mutex);
+
+	if (ret == 0)
+		*ppos += bytes;
+
+err_out:
+	kfree(buf);
+
+	return ((ret == 0) ? bytes : ret);
+}
+
+static loff_t dev_mem_seek(struct file *file, loff_t offset, int orig)
+{
+	loff_t ret;
+
+	/* only requests of dword-aligned size and offset are supported */
+	if (offset % 4)
+		return -EINVAL;
+
+	switch (orig) {
+	case SEEK_SET:
+		file->f_pos = offset;
+		ret = file->f_pos;
+		break;
+	case SEEK_CUR:
+		file->f_pos += offset;
+		ret = file->f_pos;
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static const struct file_operations dev_mem_ops = {
+	.open = simple_open,
+	.read = dev_mem_read,
+	.write = dev_mem_write,
+	.llseek = dev_mem_seek,
+};
+
 static int wl1271_debugfs_add_files(struct wl1271 *wl,
 				    struct dentry *rootdir)
 {
@@ -1059,6 +1250,7 @@ static int wl1271_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_ADD_PREFIX(rx_streaming, interval, streaming);
 	DEBUGFS_ADD_PREFIX(rx_streaming, always, streaming);
 
+	DEBUGFS_ADD_PREFIX(dev, mem, rootdir);
 
 	return 0;
 
-- 
1.7.10

