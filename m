Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:40856 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932122Ab2FGUka (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 16:40:30 -0400
Received: by lagu2 with SMTP id u2so809676lag.40
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 13:39:42 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Eyal Shapira <eyal@wizery.com>
Subject: [PATCH 1/9] wlcore: add support macros to easily add conf debugfs entries
Date: Thu,  7 Jun 2012 23:39:20 +0300
Message-Id: <1339101568-25346-2-git-send-email-coelho@ti.com> (sfid-20120607_224039_199656_CEE464D8)
In-Reply-To: <1339101568-25346-1-git-send-email-coelho@ti.com>
References: <1339101568-25346-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

The current debugfs code contains too much code duplication
of bolierplate code. Add some macro magic to avoid this and
enable adding new debugfs entries by using just a few lines.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/debugfs.c |   75 ++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index fcd6063..50300ff 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -102,6 +102,81 @@ static const struct file_operations tx_queue_len_ops = {
 	.llseek = default_llseek,
 };
 
+static void chip_op_handler(struct wl1271 *wl, unsigned long value,
+			    void *arg)
+{
+	int ret;
+	int (*chip_op) (struct wl1271 *wl);
+
+	if (!arg) {
+		wl1271_warning("debugfs chip_op_handler with no callback");
+		return;
+	}
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		return;
+
+	chip_op = arg;
+	chip_op(wl);
+
+	wl1271_ps_elp_sleep(wl);
+}
+
+
+static inline void no_write_handler(struct wl1271 *wl,
+				    unsigned long value,
+				    unsigned long param)
+{
+}
+
+#define WL12XX_CONF_DEBUGFS(param, conf_sub_struct,			\
+			    min_val, max_val, write_handler_locked,	\
+			    write_handler_arg)				\
+	static ssize_t param##_read(struct file *file,			\
+				      char __user *user_buf,		\
+				      size_t count, loff_t *ppos)	\
+	{								\
+	struct wl1271 *wl = file->private_data;				\
+	return wl1271_format_buffer(user_buf, count,			\
+				    ppos, "%d\n",			\
+				    wl->conf.conf_sub_struct.param);	\
+	}								\
+									\
+	static ssize_t param##_write(struct file *file,			\
+				     const char __user *user_buf,	\
+				     size_t count, loff_t *ppos)	\
+	{								\
+	struct wl1271 *wl = file->private_data;				\
+	unsigned long value;						\
+	int ret;							\
+									\
+	ret = kstrtoul_from_user(user_buf, count, 10, &value);		\
+	if (ret < 0) {							\
+		wl1271_warning("illegal value for " #param);		\
+		return -EINVAL;						\
+	}								\
+									\
+	if (value < min_val || value > max_val) {			\
+		wl1271_warning(#param " is not in valid range");	\
+		return -ERANGE;						\
+	}								\
+									\
+	mutex_lock(&wl->mutex);						\
+	wl->conf.conf_sub_struct.param = value;				\
+									\
+	write_handler_locked(wl, value, write_handler_arg);		\
+									\
+	mutex_unlock(&wl->mutex);					\
+	return count;							\
+	}								\
+									\
+	static const struct file_operations param##_ops = {		\
+		.read = param##_read,					\
+		.write = param##_write,					\
+		.open = simple_open,					\
+		.llseek = default_llseek,				\
+	};
 static ssize_t gpio_power_read(struct file *file, char __user *user_buf,
 			  size_t count, loff_t *ppos)
 {
-- 
1.7.10

