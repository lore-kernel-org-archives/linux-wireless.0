Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:48852 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932150AbbLBNT4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2015 08:19:56 -0500
Received: from dflxv15.itg.ti.com ([128.247.5.124])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id tB2DJtVU011967
	for <linux-wireless@vger.kernel.org>; Wed, 2 Dec 2015 07:19:55 -0600
Received: from DLEE70.ent.ti.com (dlemailx.itg.ti.com [157.170.170.113])
	by dflxv15.itg.ti.com (8.14.3/8.13.8) with ESMTP id tB2DJt7Q001005
	for <linux-wireless@vger.kernel.org>; Wed, 2 Dec 2015 07:19:55 -0600
From: Guy Mishol <guym@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: Shahar Patury <shaharp@ti.com>
Subject: [PATCH V2] wlcore/wl18xx: fw logger over sdio
Date: Wed, 2 Dec 2015 15:05:43 +0200
Message-ID: <1449061543-25089-1-git-send-email-guym@ti.com> (sfid-20151202_141959_178240_DF10C258)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shahar Patury <shaharp@ti.com>

enable the FW Logger to work over the SDIO interface instead of only
over UART.
in new design we will use fw internal memory instead of packet ram
that was used in older (and wl12xx) design.
this change will reduce the impact on tp and stability.
adding new event to notify fw logger is ready to be read.
adding dynamic configuration to debugfs.

Signed-off-by: Shahar Patury <shaharp@ti.com>
---
V2: Resubmitted again due to conflicts resolved

 drivers/net/wireless/ti/wl18xx/event.c   |    2 +
 drivers/net/wireless/ti/wl18xx/main.c    |    3 +-
 drivers/net/wireless/ti/wlcore/debugfs.c |   60 ++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/event.c b/drivers/net/wireless/ti/wl18xx/event.c
index 09c7e09..719907a 100644
--- a/drivers/net/wireless/ti/wl18xx/event.c
+++ b/drivers/net/wireless/ti/wl18xx/event.c
@@ -205,6 +205,8 @@ int wl18xx_process_mailbox_events(struct wl1271 *wl)
 						 mbox->sc_ssid,
 						 mbox->sc_pwd_len,
 						 mbox->sc_pwd);
+	if (vector & FW_LOGGER_INDICATION)
+		wlcore_event_fw_logger(wl);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 50cce42..87d87de 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1029,7 +1029,8 @@ static int wl18xx_boot(struct wl1271 *wl)
 		DFS_CHANNELS_CONFIG_COMPLETE_EVENT |
 		SMART_CONFIG_SYNC_EVENT_ID |
 		SMART_CONFIG_DECODE_EVENT_ID |
-		TIME_SYNC_EVENT_ID;
+		TIME_SYNC_EVENT_ID |
+		FW_LOGGER_INDICATION;
 
 	wl->ap_event_mask = MAX_TX_FAILURE_EVENT_ID;
 
diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index eb43f94..8367f9e 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -1234,6 +1234,65 @@ static const struct file_operations dev_mem_ops = {
 	.llseek = dev_mem_seek,
 };
 
+static ssize_t fw_logger_read(struct file *file, char __user *user_buf,
+			      size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+
+	return wl1271_format_buffer(user_buf, count,
+					ppos, "%d\n",
+					wl->conf.fwlog.output);
+}
+
+static ssize_t fw_logger_write(struct file *file,
+			       const char __user *user_buf,
+			       size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+	unsigned long value;
+	int ret;
+
+	ret = kstrtoul_from_user(user_buf, count, 0, &value);
+	if (ret < 0) {
+		wl1271_warning("illegal value in fw_logger");
+		return -EINVAL;
+	}
+
+	if ((value > 2) || (value == 0)) {
+		wl1271_warning("fw_logger value must be 1-UART 2-SDIO");
+		return -ERANGE;
+	}
+
+	if (wl->conf.fwlog.output == 0) {
+		wl1271_warning("iligal opperation - fw logger disabled by default, please change mode via wlconf");
+		return -EINVAL;
+	}
+
+	mutex_lock(&wl->mutex);
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0) {
+		count = ret;
+		goto out;
+	}
+
+	wl->conf.fwlog.output = value;
+
+	ret = wl12xx_cmd_config_fwlog(wl);
+
+	wl1271_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+	return count;
+}
+
+static const struct file_operations fw_logger_ops = {
+	.open = simple_open,
+	.read = fw_logger_read,
+	.write = fw_logger_write,
+	.llseek = default_llseek,
+};
+
 static int wl1271_debugfs_add_files(struct wl1271 *wl,
 				    struct dentry *rootdir)
 {
@@ -1260,6 +1319,7 @@ static int wl1271_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_ADD(irq_timeout, rootdir);
 	DEBUGFS_ADD(fw_stats_raw, rootdir);
 	DEBUGFS_ADD(sleep_auth, rootdir);
+	DEBUGFS_ADD(fw_logger, rootdir);
 
 	streaming = debugfs_create_dir("rx_streaming", rootdir);
 	if (!streaming || IS_ERR(streaming))
-- 
1.7.0.4

