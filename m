Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:21021 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbaKXQmN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 11:42:13 -0500
Subject: [PATCH v2 2/2] ath10k: add memory dump debugfs interface
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Mon, 24 Nov 2014 18:42:08 +0200
Message-ID: <20141124164208.29422.76134.stgit@potku.adurom.net> (sfid-20141124_174216_590967_A877215A)
In-Reply-To: <20141124164037.29422.14033.stgit@potku.adurom.net>
References: <20141124164037.29422.14033.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yanbo Li <yanbol@qti.qualcomm.com>

Add mem_val debugfs file for dumping the firmware (target) memory and also for
writing to the memory. The firmware memory is accessed through one file which
uses position of the file as the firmware memory address. For example, with dd
use skip parameter for the address.

Beucase target memory width is 32 bits it's strongly recommended to use
blocksize divisable with 4 when using this interface. For example, when using
dd use bs=4 to set the block size to 4 and remember to divide both count and
skip values with four.

To read 4 kB chunk from address 0x400000:

dd if=mem_value bs=4 count=1024 skip=1048576 | xxd -g1

To write value 0x01020304 to address 0x400400:

echo 0x01020304 | xxd -r | dd of=mem_value bs=4 seek=1048832

To read 4 KB chunk of memory and then write back after edit:

dd if=mem_value of=tmp.bin bs=4 count=1024 skip=1048576
emacs tmp.bin
dd if=tmp.bin of=mem_value bs=4 count=1024 seek=1048576

Signed-off-by: Yanbo Li <yanbol@qti.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c |   86 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hif.h   |   11 ++++
 drivers/net/wireless/ath/ath10k/pci.c   |    1 
 3 files changed, 98 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index b500cd619c05..3988220e3e66 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1024,6 +1024,89 @@ static const struct file_operations fops_reg_value = {
 	.llseek = default_llseek,
 };
 
+static ssize_t ath10k_mem_value_read(struct file *file,
+				     char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	u8 *buf;
+	int ret;
+
+	if (*ppos < 0)
+		return -EINVAL;
+
+	if (!count)
+		return 0;
+
+	buf = vmalloc(count);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = ath10k_hif_diag_read(ar, *ppos, buf, count);
+	if (ret) {
+		ath10k_warn(ar, "failed to read address 0x%08x via diagnose window from debugfs: %d\n",
+			    (u32)(*ppos), ret);
+		goto read_err;
+	}
+
+	ret = copy_to_user(user_buf, buf, count);
+	if (ret == count)
+		return -EFAULT;
+
+	count -= ret;
+	*ppos += count;
+	ret = count;
+
+read_err:
+	vfree(buf);
+	return ret;
+}
+
+static ssize_t ath10k_mem_value_write(struct file *file,
+				      const char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	u8 *buf;
+	int ret;
+
+	if (*ppos < 0)
+		return -EINVAL;
+
+	if (!count)
+		return 0;
+
+	buf = vmalloc(count);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = copy_from_user(buf, user_buf, count);
+	if (ret)
+		goto err_free_copy;
+
+	ret = ath10k_hif_diag_write(ar, *ppos, buf, count);
+	if (ret) {
+		ath10k_warn(ar, "failed to write address 0x%08x via diagnose window from debugfs: %d\n",
+			    (u32)(*ppos), ret);
+		goto err_free_copy;
+	}
+
+	*ppos += count;
+	ret = count;
+
+err_free_copy:
+	vfree(buf);
+	return ret;
+}
+
+static const struct file_operations fops_mem_value = {
+	.read = ath10k_mem_value_read,
+	.write = ath10k_mem_value_write,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static int ath10k_debug_htt_stats_req(struct ath10k *ar)
 {
 	u64 cookie;
@@ -1731,6 +1814,9 @@ int ath10k_debug_register(struct ath10k *ar)
 	debugfs_create_file("reg_value", S_IRUSR | S_IWUSR,
 			    ar->debug.debugfs_phy, ar, &fops_reg_value);
 
+	debugfs_create_file("mem_value", S_IRUSR | S_IWUSR,
+			    ar->debug.debugfs_phy, ar, &fops_mem_value);
+
 	debugfs_create_file("chip_id", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_chip_id);
 
diff --git a/drivers/net/wireless/ath/ath10k/hif.h b/drivers/net/wireless/ath/ath10k/hif.h
index bad071906540..6ac552304546 100644
--- a/drivers/net/wireless/ath/ath10k/hif.h
+++ b/drivers/net/wireless/ath/ath10k/hif.h
@@ -48,6 +48,8 @@ struct ath10k_hif_ops {
 	int (*diag_read)(struct ath10k *ar, u32 address, void *buf,
 			 size_t buf_len);
 
+	int (*diag_write)(struct ath10k *ar, u32 address, const void *data,
+			  int nbytes);
 	/*
 	 * API to handle HIF-specific BMI message exchanges, this API is
 	 * synchronous and only allowed to be called from a context that
@@ -113,6 +115,15 @@ static inline int ath10k_hif_diag_read(struct ath10k *ar, u32 address, void *buf
 	return ar->hif.ops->diag_read(ar, address, buf, buf_len);
 }
 
+static inline int ath10k_hif_diag_write(struct ath10k *ar, u32 address,
+					const void *data, int nbytes)
+{
+	if (!ar->hif.ops->diag_write)
+		return -EOPNOTSUPP;
+
+	return ar->hif.ops->diag_write(ar, address, data, nbytes);
+}
+
 static inline int ath10k_hif_exchange_bmi_msg(struct ath10k *ar,
 					      void *request, u32 request_len,
 					      void *response, u32 *response_len)
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 328ab6c5d053..0816098af578 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1988,6 +1988,7 @@ static int ath10k_pci_hif_resume(struct ath10k *ar)
 static const struct ath10k_hif_ops ath10k_pci_hif_ops = {
 	.tx_sg			= ath10k_pci_hif_tx_sg,
 	.diag_read		= ath10k_pci_hif_diag_read,
+	.diag_write		= ath10k_pci_diag_write_mem,
 	.exchange_bmi_msg	= ath10k_pci_hif_exchange_bmi_msg,
 	.start			= ath10k_pci_hif_start,
 	.stop			= ath10k_pci_hif_stop,

