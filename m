Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14532 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611AbaFPQi3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 12:38:29 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 10/25] wil6210: debugfs interface to send raw WMI command
Date: Mon, 16 Jun 2014 19:37:08 +0300
Message-ID: <1402936643-31819-11-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140616_183834_912990_8E76EE5A)
In-Reply-To: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Debug aid

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 41 ++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 3c3abb6..8767f4c 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -513,6 +513,46 @@ static const struct file_operations fops_txmgmt = {
 	.open  = simple_open,
 };
 
+/* Write WMI command (w/o mbox header) to this file to send it
+ * WMI starts from wil6210_mbox_hdr_wmi header
+ */
+static ssize_t wil_write_file_wmi(struct file *file, const char __user *buf,
+				  size_t len, loff_t *ppos)
+{
+	struct wil6210_priv *wil = file->private_data;
+	struct wil6210_mbox_hdr_wmi *wmi;
+	void *cmd;
+	int cmdlen = len - sizeof(struct wil6210_mbox_hdr_wmi);
+	u16 cmdid;
+	int rc, rc1;
+
+	if (cmdlen <= 0)
+		return -EINVAL;
+
+	wmi = kmalloc(len, GFP_KERNEL);
+	if (!wmi)
+		return -ENOMEM;
+
+	rc = simple_write_to_buffer(wmi, len, ppos, buf, len);
+	if (rc < 0)
+		return rc;
+
+	cmd = &wmi[1];
+	cmdid = le16_to_cpu(wmi->id);
+
+	rc1 = wmi_send(wil, cmdid, cmd, cmdlen);
+	kfree(wmi);
+
+	wil_info(wil, "%s(0x%04x[%d]) -> %d\n", __func__, cmdid, cmdlen, rc1);
+
+	return rc;
+}
+
+static const struct file_operations fops_wmi = {
+	.write = wil_write_file_wmi,
+	.open  = simple_open,
+};
+
 static void wil_seq_hexdump(struct seq_file *s, void *p, int len,
 			    const char *prefix)
 {
@@ -838,6 +878,7 @@ int wil6210_debugfs_init(struct wil6210_priv *wil)
 	debugfs_create_file("reset", S_IWUSR, dbg, wil, &fops_reset);
 	debugfs_create_file("rxon", S_IWUSR, dbg, wil, &fops_rxon);
 	debugfs_create_file("tx_mgmt", S_IWUSR, dbg, wil, &fops_txmgmt);
+	debugfs_create_file("wmi_send", S_IWUSR, dbg, wil, &fops_wmi);
 	debugfs_create_file("temp", S_IRUGO, dbg, wil, &fops_temp);
 
 	wil->rgf_blob.data = (void * __force)wil->csr + 0;
-- 
1.9.1

