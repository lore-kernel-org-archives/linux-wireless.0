Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.89]:56666 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754696AbZIANNE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 09:13:04 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 9/9] iwmc3200wifi: Add a last_fw_err debugfs entry
Date: Tue,  1 Sep 2009 15:14:06 +0200
Message-Id: <2b1cdd978fe7af31dc4dba8a8f81b8c2ab05dd9f.1251809163.git.sameo@linux.intel.com>
In-Reply-To: <c49af0d7f3b96643dbb7a2da52ede622f66220b5.1251809163.git.sameo@linux.intel.com>
References: <cover.1251809163.git.sameo@linux.intel.com>
 <51aebb943245be1aef404d6274fe60feabd47c94.1251809163.git.sameo@linux.intel.com>
 <b08ebbaa73e4796a6be51889860bc1bd67867a90.1251809163.git.sameo@linux.intel.com>
 <3a950a601bd437ab1c971dc495fc0a2c3c886631.1251809163.git.sameo@linux.intel.com>
 <8736a234164502177f2073aa9d2f042eed39f67b.1251809163.git.sameo@linux.intel.com>
 <cf887cbfdcddc6c3874e08978b8926f82862d345.1251809163.git.sameo@linux.intel.com>
 <0b1215c4ea3f375a932030fe94fd97e47df4b4eb.1251809163.git.sameo@linux.intel.com>
 <e8d5aebbcfa2f5d4430bbee3850bd11e34808088.1251809163.git.sameo@linux.intel.com>
 <c49af0d7f3b96643dbb7a2da52ede622f66220b5.1251809163.git.sameo@linux.intel.com>
In-Reply-To: <cover.1251809163.git.sameo@linux.intel.com>
References: <cover.1251809163.git.sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to check what was the last fw error we got accross resets, we add
this debugfs entry. It displays the complete ASSERT information.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/net/wireless/iwmc3200wifi/debug.h   |    2 +
 drivers/net/wireless/iwmc3200wifi/debugfs.c |  105 ++++++++++++++++++++++++++-
 drivers/net/wireless/iwmc3200wifi/iwm.h     |    2 +
 drivers/net/wireless/iwmc3200wifi/main.c    |    6 ++
 drivers/net/wireless/iwmc3200wifi/rx.c      |    2 +
 5 files changed, 113 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/debug.h b/drivers/net/wireless/iwmc3200wifi/debug.h
index 8fbb42d..e35c9b6 100644
--- a/drivers/net/wireless/iwmc3200wifi/debug.h
+++ b/drivers/net/wireless/iwmc3200wifi/debug.h
@@ -108,6 +108,8 @@ struct iwm_debugfs {
 	struct dentry *txq_dentry;
 	struct dentry *tx_credit_dentry;
 	struct dentry *rx_ticket_dentry;
+
+	struct dentry *fw_err_dentry;
 };
 
 #ifdef CONFIG_IWM_DEBUG
diff --git a/drivers/net/wireless/iwmc3200wifi/debugfs.c b/drivers/net/wireless/iwmc3200wifi/debugfs.c
index 0fa7b91..1465379 100644
--- a/drivers/net/wireless/iwmc3200wifi/debugfs.c
+++ b/drivers/net/wireless/iwmc3200wifi/debugfs.c
@@ -98,7 +98,7 @@ DEFINE_SIMPLE_ATTRIBUTE(fops_iwm_dbg_modules,
 			iwm_debugfs_u32_read, iwm_debugfs_dbg_modules_write,
 			"%llu\n");
 
-static int iwm_txrx_open(struct inode *inode, struct file *filp)
+static int iwm_generic_open(struct inode *inode, struct file *filp)
 {
 	filp->private_data = inode->i_private;
 	return 0;
@@ -289,25 +289,111 @@ static ssize_t iwm_debugfs_rx_ticket_read(struct file *filp,
 	return ret;
 }
 
+static ssize_t iwm_debugfs_fw_err_read(struct file *filp,
+				       char __user *buffer,
+				       size_t count, loff_t *ppos)
+{
+
+	struct iwm_priv *iwm = filp->private_data;
+	char buf[512];
+	int buf_len = 512;
+	size_t len = 0;
+
+	if (*ppos != 0)
+		return 0;
+	if (count < sizeof(buf))
+		return -ENOSPC;
+
+	if (!iwm->last_fw_err)
+		return -ENOMEM;
+
+	if (iwm->last_fw_err->line_num == 0)
+		goto out;
+
+	len += snprintf(buf + len, buf_len - len, "%cMAC FW ERROR:\n",
+	     (le32_to_cpu(iwm->last_fw_err->category) == UMAC_SYS_ERR_CAT_LMAC)
+			? 'L' : 'U');
+	len += snprintf(buf + len, buf_len - len,
+			"\tCategory:    %d\n",
+			le32_to_cpu(iwm->last_fw_err->category));
+
+	len += snprintf(buf + len, buf_len - len,
+			"\tStatus:      0x%x\n",
+			le32_to_cpu(iwm->last_fw_err->status));
+
+	len += snprintf(buf + len, buf_len - len,
+			"\tPC:          0x%x\n",
+			le32_to_cpu(iwm->last_fw_err->pc));
+
+	len += snprintf(buf + len, buf_len - len,
+			"\tblink1:      %d\n",
+			le32_to_cpu(iwm->last_fw_err->blink1));
+
+	len += snprintf(buf + len, buf_len - len,
+			"\tblink2:      %d\n",
+			le32_to_cpu(iwm->last_fw_err->blink2));
+
+	len += snprintf(buf + len, buf_len - len,
+			"\tilink1:      %d\n",
+			le32_to_cpu(iwm->last_fw_err->ilink1));
+
+	len += snprintf(buf + len, buf_len - len,
+			"\tilink2:      %d\n",
+			le32_to_cpu(iwm->last_fw_err->ilink2));
+
+	len += snprintf(buf + len, buf_len - len,
+			"\tData1:       0x%x\n",
+			le32_to_cpu(iwm->last_fw_err->data1));
+
+	len += snprintf(buf + len, buf_len - len,
+			"\tData2:       0x%x\n",
+			le32_to_cpu(iwm->last_fw_err->data2));
+
+	len += snprintf(buf + len, buf_len - len,
+			"\tLine number: %d\n",
+			le32_to_cpu(iwm->last_fw_err->line_num));
+
+	len += snprintf(buf + len, buf_len - len,
+			"\tUMAC status: 0x%x\n",
+			le32_to_cpu(iwm->last_fw_err->umac_status));
+
+	len += snprintf(buf + len, buf_len - len,
+			"\tLMAC status: 0x%x\n",
+			le32_to_cpu(iwm->last_fw_err->lmac_status));
+
+	len += snprintf(buf + len, buf_len - len,
+			"\tSDIO status: 0x%x\n",
+			le32_to_cpu(iwm->last_fw_err->sdio_status));
+
+out:
+
+	return simple_read_from_buffer(buffer, len, ppos, buf, buf_len);
+}
 
 static const struct file_operations iwm_debugfs_txq_fops = {
 	.owner =	THIS_MODULE,
-	.open =		iwm_txrx_open,
+	.open =		iwm_generic_open,
 	.read =		iwm_debugfs_txq_read,
 };
 
 static const struct file_operations iwm_debugfs_tx_credit_fops = {
 	.owner =	THIS_MODULE,
-	.open =		iwm_txrx_open,
+	.open =		iwm_generic_open,
 	.read =		iwm_debugfs_tx_credit_read,
 };
 
 static const struct file_operations iwm_debugfs_rx_ticket_fops = {
 	.owner =	THIS_MODULE,
-	.open =		iwm_txrx_open,
+	.open =		iwm_generic_open,
 	.read =		iwm_debugfs_rx_ticket_read,
 };
 
+static const struct file_operations iwm_debugfs_fw_err_fops = {
+	.owner =	THIS_MODULE,
+	.open =		iwm_generic_open,
+	.read =		iwm_debugfs_fw_err_read,
+};
+
 int iwm_debugfs_init(struct iwm_priv *iwm)
 {
 	int i, result;
@@ -423,6 +509,16 @@ int iwm_debugfs_init(struct iwm_priv *iwm)
 		goto error;
 	}
 
+	iwm->dbg.fw_err_dentry = debugfs_create_file("last_fw_err", 0200,
+						     iwm->dbg.dbgdir, iwm,
+						     &iwm_debugfs_fw_err_fops);
+	result = PTR_ERR(iwm->dbg.fw_err_dentry);
+	if (IS_ERR(iwm->dbg.fw_err_dentry) && (result != -ENODEV)) {
+		IWM_ERR(iwm, "Couldn't create last FW err: %d\n", result);
+		goto error;
+	}
+
+
 	return 0;
 
  error:
@@ -441,6 +537,7 @@ void iwm_debugfs_exit(struct iwm_priv *iwm)
 	debugfs_remove(iwm->dbg.txq_dentry);
 	debugfs_remove(iwm->dbg.tx_credit_dentry);
 	debugfs_remove(iwm->dbg.rx_ticket_dentry);
+	debugfs_remove(iwm->dbg.fw_err_dentry);
 	if (iwm->bus_ops->debugfs_exit)
 		iwm->bus_ops->debugfs_exit(iwm);
 
diff --git a/drivers/net/wireless/iwmc3200wifi/iwm.h b/drivers/net/wireless/iwmc3200wifi/iwm.h
index f5c2d6f..1b02a4e 100644
--- a/drivers/net/wireless/iwmc3200wifi/iwm.h
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
@@ -289,6 +289,8 @@ struct iwm_priv {
 	u8 *resp_ie;
 	int resp_ie_len;
 
+	struct iwm_fw_error_hdr *last_fw_err;
+
 	char private[0] __attribute__((__aligned__(NETDEV_ALIGN)));
 };
 
diff --git a/drivers/net/wireless/iwmc3200wifi/main.c b/drivers/net/wireless/iwmc3200wifi/main.c
index 6a5b76a..d668e47 100644
--- a/drivers/net/wireless/iwmc3200wifi/main.c
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -260,6 +260,11 @@ int iwm_priv_init(struct iwm_priv *iwm)
 	iwm->watchdog.data = (unsigned long)iwm;
 	mutex_init(&iwm->mutex);
 
+	iwm->last_fw_err = kzalloc(sizeof(struct iwm_fw_error_hdr),
+				   GFP_KERNEL);
+	if (iwm->last_fw_err == NULL)
+		return -ENOMEM;
+
 	return 0;
 }
 
@@ -271,6 +276,7 @@ void iwm_priv_deinit(struct iwm_priv *iwm)
 		destroy_workqueue(iwm->txq[i].wq);
 
 	destroy_workqueue(iwm->rx_wq);
+	kfree(iwm->last_fw_err);
 }
 
 /*
diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 14950b1..40dbcbc 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -102,6 +102,8 @@ static int iwm_ntf_error(struct iwm_priv *iwm, u8 *buf,
 	error = (struct iwm_umac_notif_error *)buf;
 	fw_err = &error->err;
 
+	memcpy(iwm->last_fw_err, fw_err, sizeof(struct iwm_fw_error_hdr));
+
 	IWM_ERR(iwm, "%cMAC FW ERROR:\n",
 	 (le32_to_cpu(fw_err->category) == UMAC_SYS_ERR_CAT_LMAC) ? 'L' : 'U');
 	IWM_ERR(iwm, "\tCategory:    %d\n", le32_to_cpu(fw_err->category));
-- 
1.6.3.3

