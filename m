Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:64390 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754387AbbEKNsy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 09:48:54 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t4BDmoWZ004693
	for <linux-wireless@vger.kernel.org>; Mon, 11 May 2015 06:48:51 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0a-0016f401.pphosted.com with ESMTP id 1u9729wwwd-2
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 11 May 2015 06:48:50 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <liuzy@marvell.com>,
	<crlo@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 2/4] mwifiex: add prints debug ctrl support
Date: Tue, 12 May 2015 00:48:18 +0530
Message-ID: <1431371900-7260-2-git-send-email-patila@marvell.com> (sfid-20150511_154904_549802_4F680760)
In-Reply-To: <1431371900-7260-1-git-send-email-patila@marvell.com>
References: <1431371900-7260-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhaoyang Liu <liuzy@marvell.com>

This patch adds support for debugging print control in mwifiex driver.

The debug level can be controlled via either by modules load parameter
debug_mask or by writing to debug_mask in debugfs file.

Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/debugfs.c | 63 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/ioctl.h   |  1 +
 drivers/net/wireless/mwifiex/main.c    |  5 +++
 drivers/net/wireless/mwifiex/main.h    | 40 +++++++++++++++++++++
 drivers/net/wireless/mwifiex/util.c    |  3 ++
 5 files changed, 112 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 414ee2d..f3e19e9 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -535,6 +535,67 @@ done:
 	return ret;
 }
 
+/* Proc debug_mask file read handler.
+ * This function is called when the 'debug_mask' file is opened for reading
+ * This function can be used read driver debugging mask value.
+ */
+static ssize_t
+mwifiex_debug_mask_read(struct file *file, char __user *ubuf,
+			size_t count, loff_t *ppos)
+{
+	struct mwifiex_private *priv =
+		(struct mwifiex_private *)file->private_data;
+	unsigned long page = get_zeroed_page(GFP_KERNEL);
+	char *buf = (char *)page;
+	size_t ret = 0;
+	int pos = 0;
+
+	if (!buf)
+		return -ENOMEM;
+
+	pos += snprintf(buf, PAGE_SIZE, "debug mask=0x%08x\n",
+			priv->adapter->debug_mask);
+	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
+
+	free_page(page);
+	return ret;
+}
+
+/* Proc debug_mask file read handler.
+ * This function is called when the 'debug_mask' file is opened for reading
+ * This function can be used read driver debugging mask value.
+ */
+static ssize_t
+mwifiex_debug_mask_write(struct file *file, const char __user *ubuf,
+			 size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long debug_mask;
+	struct mwifiex_private *priv = (void *)file->private_data;
+	unsigned long addr = get_zeroed_page(GFP_KERNEL);
+	char *buf = (void *)addr;
+	size_t buf_size = min(count, (size_t)(PAGE_SIZE - 1));
+
+	if (!buf)
+		return -ENOMEM;
+
+	if (copy_from_user(buf, ubuf, buf_size)) {
+		ret = -EFAULT;
+		goto done;
+	}
+
+	if (kstrtoul(buf, 0, &debug_mask)) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	priv->adapter->debug_mask = debug_mask;
+	ret = count;
+done:
+	free_page(addr);
+	return ret;
+}
+
 /* Proc memrw file write handler.
  * This function is called when the 'memrw' file is opened for writing
  * This function can be used to write to a memory location.
@@ -829,6 +890,7 @@ MWIFIEX_DFS_FILE_OPS(rdeeprom);
 MWIFIEX_DFS_FILE_OPS(memrw);
 MWIFIEX_DFS_FILE_OPS(hscfg);
 MWIFIEX_DFS_FILE_OPS(histogram);
+MWIFIEX_DFS_FILE_OPS(debug_mask);
 
 /*
  * This function creates the debug FS directory structure and the files.
@@ -854,6 +916,7 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 	MWIFIEX_DFS_ADD_FILE(memrw);
 	MWIFIEX_DFS_ADD_FILE(hscfg);
 	MWIFIEX_DFS_ADD_FILE(histogram);
+	MWIFIEX_DFS_ADD_FILE(debug_mask);
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 224c993..6f11a25 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -189,6 +189,7 @@ struct tdls_peer_info {
 };
 
 struct mwifiex_debug_info {
+	unsigned int debug_mask;
 	u32 int_counter;
 	u32 packets_out[MAX_NUM_TID];
 	u32 tx_buf_size;
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 213aa98..eca4378 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -24,6 +24,10 @@
 
 #define VERSION	"1.0"
 
+static unsigned int debug_mask = MWIFIEX_DEFAULT_DEBUG_MASK;
+module_param(debug_mask, uint, 0);
+MODULE_PARM_DESC(debug_mask, "bitmap for debug flags");
+
 const char driver_version[] = "mwifiex " VERSION " (%s) ";
 static char *cal_data_cfg;
 module_param(cal_data_cfg, charp, 0);
@@ -63,6 +67,7 @@ static int mwifiex_register(void *card, struct mwifiex_if_ops *if_ops,
 
 	/* Save interface specific operations in adapter */
 	memmove(&adapter->if_ops, if_ops, sizeof(struct mwifiex_if_ops));
+	adapter->debug_mask = debug_mask;
 
 	/* card specific initialization has been deferred until now .. */
 	if (adapter->if_ops.init_if)
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index b387d5a..6cbbc50 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -147,6 +147,45 @@ enum {
 /* Address alignment */
 #define MWIFIEX_ALIGN_ADDR(p, a) (((long)(p) + (a) - 1) & ~((a) - 1))
 
+/**
+ *enum mwifiex_debug_level  -  marvell wifi debug level
+ */
+enum MWIFIEX_DEBUG_LEVEL {
+	MWIFIEX_DBG_MSG		= 0x00000001,
+	MWIFIEX_DBG_FATAL	= 0x00000002,
+	MWIFIEX_DBG_ERROR	= 0x00000004,
+	MWIFIEX_DBG_DATA	= 0x00000008,
+	MWIFIEX_DBG_CMD		= 0x00000010,
+	MWIFIEX_DBG_EVENT	= 0x00000020,
+	MWIFIEX_DBG_INTR	= 0x00000040,
+	MWIFIEX_DBG_IOCTL	= 0x00000080,
+
+	MWIFIEX_DBG_MPA_D	= 0x00008000,
+	MWIFIEX_DBG_DAT_D	= 0x00010000,
+	MWIFIEX_DBG_CMD_D	= 0x00020000,
+	MWIFIEX_DBG_EVT_D	= 0x00040000,
+	MWIFIEX_DBG_FW_D	= 0x00080000,
+	MWIFIEX_DBG_IF_D	= 0x00100000,
+
+	MWIFIEX_DBG_ENTRY	= 0x10000000,
+	MWIFIEX_DBG_WARN	= 0x20000000,
+	MWIFIEX_DBG_INFO	= 0x40000000,
+	MWIFIEX_DBG_DUMP	= 0x80000000,
+
+	MWIFIEX_DBG_ANY		= 0xffffffff
+};
+
+#define MWIFIEX_DEFAULT_DEBUG_MASK	(MWIFIEX_DBG_MSG | \
+					MWIFIEX_DBG_FATAL | \
+					MWIFIEX_DBG_ERROR)
+
+#define mwifiex_dbg(adapter, dbg_mask, fmt, args...)		\
+do {								\
+	if ((adapter)->debug_mask & MWIFIEX_DBG_##dbg_mask)	\
+		if ((adapter)->dev)				\
+			dev_info((adapter)->dev, fmt, ## args);	\
+} while (0)
+
 struct mwifiex_dbg {
 	u32 num_cmd_host_to_card_failure;
 	u32 num_cmd_sleep_cfm_host_to_card_failure;
@@ -751,6 +790,7 @@ struct mwifiex_if_ops {
 
 struct mwifiex_adapter {
 	u8 iface_type;
+	unsigned int debug_mask;
 	struct mwifiex_iface_comb iface_limit;
 	struct mwifiex_iface_comb curr_iface_comb;
 	struct mwifiex_private *priv[MWIFIEX_MAX_BSS_NUM];
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 9482d95..22d93af 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -26,6 +26,8 @@
 #include "11n.h"
 
 static struct mwifiex_debug_data items[] = {
+	{"debug_mask", item_size(debug_mask),
+	 item_addr(debug_mask), 1},
 	{"int_counter", item_size(int_counter),
 	 item_addr(int_counter), 1},
 	{"wmm_ac_vo", item_size(packets_out[WMM_AC_VO]),
@@ -178,6 +180,7 @@ int mwifiex_get_debug_info(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 
 	if (info) {
+		info->debug_mask = adapter->debug_mask;
 		memcpy(info->packets_out,
 		       priv->wmm.packets_out,
 		       sizeof(priv->wmm.packets_out));
-- 
1.8.1.4

