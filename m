Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40505 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758632Ab2EJJQr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:16:47 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1111470wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:16:47 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 62/78] wlcore: add debugfs macro to help print fw statistics arrays
Date: Thu, 10 May 2012 12:14:07 +0300
Message-Id: <1336641263-5761-63-git-send-email-arik@wizery.com> (sfid-20120510_111817_665337_31F54C0F)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

Add a macro to make it easy to print arrays from the FW statistics
array in debugfs.  At the same time, increase the buffer size so
arrays fit more easily.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/debugfs.c |    1 -
 drivers/net/wireless/ti/wlcore/debugfs.h |   27 +++++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index 57c1eae..fc44262 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -39,7 +39,6 @@
 #define WL1271_DEBUGFS_STATS_LIFETIME 1000
 
 /* debugfs macros idea from mac80211 */
-#define DEBUGFS_FORMAT_BUFFER_SIZE 100
 int wl1271_format_buffer(char __user *userbuf, size_t count,
 			 loff_t *ppos, char *fmt, ...)
 {
diff --git a/drivers/net/wireless/ti/wlcore/debugfs.h b/drivers/net/wireless/ti/wlcore/debugfs.h
index e1a5bf1..f7381dd 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.h
+++ b/drivers/net/wireless/ti/wlcore/debugfs.h
@@ -34,6 +34,8 @@ void wl1271_debugfs_exit(struct wl1271 *wl);
 void wl1271_debugfs_reset(struct wl1271 *wl);
 void wl1271_debugfs_update_stats(struct wl1271 *wl);
 
+#define DEBUGFS_FORMAT_BUFFER_SIZE 256
+
 #define DEBUGFS_READONLY_FILE(name, fmt, value...)			\
 static ssize_t name## _read(struct file *file, char __user *userbuf,	\
 			    size_t count, loff_t *ppos)			\
@@ -86,6 +88,31 @@ static const struct file_operations sub## _ ##name## _ops = {		\
 	.llseek	= generic_file_llseek,					\
 };
 
+#define DEBUGFS_FWSTATS_FILE_ARRAY(sub, name, len, struct_type)		\
+static ssize_t sub## _ ##name## _read(struct file *file,		\
+				      char __user *userbuf,		\
+				      size_t count, loff_t *ppos)	\
+{									\
+	struct wl1271 *wl = file->private_data;				\
+	struct struct_type *stats = wl->stats.fw_stats;			\
+	char buf[DEBUGFS_FORMAT_BUFFER_SIZE] = "";			\
+	int res, i;							\
+									\
+	wl1271_debugfs_update_stats(wl);				\
+									\
+	for (i = 0; i < len; i++)					\
+		res = snprintf(buf, sizeof(buf), "%s[%d] = %d\n",	\
+			       buf, i, stats->sub.name[i]);		\
+									\
+	return wl1271_format_buffer(userbuf, count, ppos, "%s", buf);	\
+}									\
+									\
+static const struct file_operations sub## _ ##name## _ops = {		\
+	.read = sub## _ ##name## _read,					\
+	.open = simple_open,						\
+	.llseek	= generic_file_llseek,					\
+};
+
 #define DEBUGFS_FWSTATS_ADD(sub, name)					\
 	DEBUGFS_ADD(sub## _ ##name, stats)
 
-- 
1.7.9.5

