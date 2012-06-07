Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:57715 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756787Ab2FGUjw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 16:39:52 -0400
Received: by lahg1 with SMTP id g1so1633395lah.16
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 13:39:49 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH 8/9] wlcore/wl18xx: export conf struct in a debugfs file
Date: Thu,  7 Jun 2012 23:39:27 +0300
Message-Id: <1339101568-25346-9-git-send-email-coelho@ti.com> (sfid-20120607_224004_296788_43553B0E)
In-Reply-To: <1339101568-25346-1-git-send-email-coelho@ti.com>
References: <1339101568-25346-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add conf file header structure, magic and version values and export
the entire conf struct in debugfs.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl18xx/conf.h    |    6 ++++
 drivers/net/wireless/ti/wl18xx/debugfs.c |   44 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/conf.h    |   22 +++++++++++++++
 3 files changed, 72 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/conf.h b/drivers/net/wireless/ti/wl18xx/conf.h
index b75a6d3..130546a 100644
--- a/drivers/net/wireless/ti/wl18xx/conf.h
+++ b/drivers/net/wireless/ti/wl18xx/conf.h
@@ -22,6 +22,12 @@
 #ifndef __WL18XX_CONF_H__
 #define __WL18XX_CONF_H__
 
+#define WL18XX_CONF_MAGIC	0x10e100ca
+#define WL18XX_CONF_VERSION	(WLCORE_CONF_VERSION | 0x0001)
+#define WL18XX_CONF_MASK	0x0000ffff
+#define WL18XX_CONF_SIZE	(WLCORE_CONF_SIZE + \
+				 sizeof(struct wl18xx_priv_conf))
+
 struct wl18xx_conf_phy {
 	u8 phy_standalone;
 	u8 rdl;
diff --git a/drivers/net/wireless/ti/wl18xx/debugfs.c b/drivers/net/wireless/ti/wl18xx/debugfs.c
index 468651c..96b1496 100644
--- a/drivers/net/wireless/ti/wl18xx/debugfs.c
+++ b/drivers/net/wireless/ti/wl18xx/debugfs.c
@@ -158,6 +158,48 @@ WL18XX_DEBUGFS_FWSTATS_FILE(mem, tx_free_mem_blks, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(mem, fwlog_free_mem_blks, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(mem, fw_gen_free_mem_blks, "%u");
 
+static ssize_t conf_read(struct file *file, char __user *user_buf,
+			 size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+	struct wl18xx_priv *priv = wl->priv;
+	struct wlcore_conf_header header;
+	char *buf, *pos;
+	size_t len;
+	int ret;
+
+	len = WL18XX_CONF_SIZE;
+	buf = kmalloc(len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	header.magic	= cpu_to_le32(WL18XX_CONF_MAGIC);
+	header.version	= cpu_to_le32(WL18XX_CONF_VERSION);
+	header.checksum	= 0;
+
+	mutex_lock(&wl->mutex);
+
+	pos = buf;
+	memcpy(pos, &header, sizeof(header));
+	pos += sizeof(header);
+	memcpy(pos, &wl->conf, sizeof(wl->conf));
+	pos += sizeof(wl->conf);
+	memcpy(pos, &priv->conf, sizeof(priv->conf));
+
+	mutex_unlock(&wl->mutex);
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+
+	kfree(buf);
+	return ret;
+}
+
+static const struct file_operations conf_ops = {
+	.read = conf_read,
+	.open = simple_open,
+	.llseek = default_llseek,
+};
+
 static ssize_t clear_fw_stats_write(struct file *file,
 			      const char __user *user_buf,
 			      size_t count, loff_t *ppos)
@@ -327,6 +369,8 @@ int wl18xx_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_FWSTATS_ADD(mem, fwlog_free_mem_blks);
 	DEBUGFS_FWSTATS_ADD(mem, fw_gen_free_mem_blks);
 
+	DEBUGFS_ADD(conf, moddir);
+
 	return 0;
 
 err:
diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index 27d919f..03c6358 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -1271,6 +1271,22 @@ struct conf_hangover_settings {
 	u8 window_size;
 } __packed;
 
+/*
+ * The conf version consists of 4 bytes.  The two MSB are the wlcore
+ * version, the two LSB are the lower driver's private conf
+ * version.
+ */
+#define WLCORE_CONF_VERSION	(0x0001 << 16)
+#define WLCORE_CONF_MASK	0xffff0000
+#define WLCORE_CONF_SIZE	(sizeof(struct wlcore_conf_header) +	\
+				 sizeof(struct wlcore_conf))
+
+struct wlcore_conf_header {
+	__le32 magic;
+	__le32 version;
+	__le32 checksum;
+} __packed;
+
 struct wlcore_conf {
 	struct conf_sg_settings sg;
 	struct conf_rx_settings rx;
@@ -1290,4 +1306,10 @@ struct wlcore_conf {
 	struct conf_hangover_settings hangover;
 } __packed;
 
+struct wlcore_conf_file {
+	struct wlcore_conf_header header;
+	struct wlcore_conf core;
+	u8 priv[0];
+} __packed;
+
 #endif
-- 
1.7.10

