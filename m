Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:30682 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaKVLtN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2014 06:49:13 -0500
From: Yanbo Li <yanbol@qti.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <dreamfly281@gmail.com>, <michal.kazior@tieto.com>,
	<ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath10k: Add the target register access and memory dump debugfs interface
Date: Sat, 22 Nov 2014 19:48:42 +0800
Message-ID: <1416656922-6645-1-git-send-email-yanbol@qti.qualcomm.com> (sfid-20141122_124938_712500_DBD23DBA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The debugfs interface reg_addr&reg_val used to read and write the target
register.
The interface mmem_val used to dump the targer memory and also can be
used to assign value to target memory

The basic usage explain as below:

Register read/write:
reg_addr       (the register address)                    (read&write)
reg_value      (the register value,  output is ASCII)    (read&write)

Read operation:
1. Write the reg address to reg_addr
   IE:  echo 0x100000 > reg_addr
2. Read the value from reg_value
   IE:  cat reg_value
Write operation:
1. Write the reg address to reg_addr IE:  echo 0x100000 > reg_addr
2. Write the value to the reg_value  IE:  echo  0x2400 > reg_value

Target memory dump:
mem_value (the target memory, access with the length and start address
							(read&write)
Read operation:

1: Read 4K(bs*count)) from address 0x400000(bs*skip)
dd if=mem_value bs=4 count=1024 skip=1048576 | xxd -g1

2: Read 0x50000(bs*count) from address 0x400000(bs*skip)
dd if=mem_value bs=4 count=81920 skip=1048576 | xxd -g1

Write operation:

1: Write the 0x01020304 to address 0x400400(bs*seek)
echo 0x01020304 | xxd -r | dd of=mem_value bs=4 seek=1048832

2: Read the memory and then write back after edit
dd if=mem_value bs=4 count=1024 skip=1048576 > tmp.bin
edit the tmp.bin
dd if=tmp.bin of=mem_value bs=4 count=4 seek=1048576

It suggests assign the 4 align number to bs, IE, 4, 8, 16 ....
Cause the target memory width is 32bit

Signed-off-by: Yanbo Li <yanbol@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |    2 +
 drivers/net/wireless/ath/ath10k/debug.c |  189 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hif.h   |   37 ++++++
 drivers/net/wireless/ath/ath10k/pci.c   |    3 +
 4 files changed, 231 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 8f86bd3..5cb4fe9 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -321,6 +321,8 @@ struct ath10k_debug {
 	u32 fw_dbglog_mask;
 	u32 pktlog_filter;
 
+	u32 reg_addr;
+
 	u8 htt_max_amsdu;
 	u8 htt_max_ampdu;
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index a8f5a72..302ad55 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -22,6 +22,7 @@
 #include <linux/vmalloc.h>
 
 #include "core.h"
+#include "hif.h"
 #include "debug.h"
 #include "hif.h"
 
@@ -929,6 +930,185 @@ static const struct file_operations fops_fw_crash_dump = {
 	.llseek = default_llseek,
 };
 
+static ssize_t ath10k_reg_addr_read(struct file *file,
+				    char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	u8 buf[32];
+	unsigned int len = 0;
+	u32 reg_addr;
+
+	spin_lock_bh(&ar->data_lock);
+	reg_addr = ar->debug.reg_addr;
+	spin_unlock_bh(&ar->data_lock);
+
+	len += scnprintf(buf + len, sizeof(buf) - len, "0x%x\n", reg_addr);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t ath10k_reg_addr_write(struct file *file,
+				     const char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	u32 reg_addr;
+	int ret;
+
+	ret = kstrtou32_from_user(user_buf, count, 0, &reg_addr);
+	if (ret)
+		return ret;
+
+	if (!IS_ALIGNED(reg_addr, 4))
+		return -EFAULT;
+
+	spin_lock_bh(&ar->data_lock);
+	ar->debug.reg_addr = reg_addr;
+	spin_unlock_bh(&ar->data_lock);
+
+	return count;
+}
+
+static const struct file_operations fops_reg_addr = {
+	.read = ath10k_reg_addr_read,
+	.write = ath10k_reg_addr_write,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+static ssize_t ath10k_reg_value_read(struct file *file,
+				     char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	u8 buf[48];
+	unsigned int len;
+	u32 reg_addr, reg_val;
+
+	spin_lock_bh(&ar->data_lock);
+	reg_addr = ar->debug.reg_addr;
+	spin_unlock_bh(&ar->data_lock);
+
+	reg_val = ath10k_hif_read32(ar, reg_addr);
+	len = scnprintf(buf, sizeof(buf), "0x%08x:0x%08x\n", reg_addr, reg_val);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t ath10k_reg_value_write(struct file *file,
+				      const char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	u32 reg_addr, reg_val;
+	int ret;
+
+	spin_lock_bh(&ar->data_lock);
+	reg_addr = ar->debug.reg_addr;
+	spin_unlock_bh(&ar->data_lock);
+
+	ret = kstrtou32_from_user(user_buf, count, 0, &reg_val);
+	if (ret)
+		return ret;
+
+	ath10k_hif_write32(ar, reg_addr, reg_val);
+
+	return count;
+}
+
+static const struct file_operations fops_reg_value = {
+	.read = ath10k_reg_value_read,
+	.write = ath10k_reg_value_write,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
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
@@ -1630,6 +1810,15 @@ int ath10k_debug_register(struct ath10k *ar)
 	debugfs_create_file("fw_crash_dump", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_fw_crash_dump);
 
+	debugfs_create_file("reg_addr", S_IRUSR | S_IWUSR,
+			    ar->debug.debugfs_phy, ar, &fops_reg_addr);
+
+	debugfs_create_file("reg_value", S_IRUSR | S_IWUSR,
+			    ar->debug.debugfs_phy, ar, &fops_reg_value);
+
+	debugfs_create_file("mem_value", S_IRUSR | S_IWUSR,
+			    ar->debug.debugfs_phy, ar, &fops_mem_value);
+
 	debugfs_create_file("chip_id", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_chip_id);
 
diff --git a/drivers/net/wireless/ath/ath10k/hif.h b/drivers/net/wireless/ath/ath10k/hif.h
index 30301f5..6ac5523 100644
--- a/drivers/net/wireless/ath/ath10k/hif.h
+++ b/drivers/net/wireless/ath/ath10k/hif.h
@@ -20,6 +20,7 @@
 
 #include <linux/kernel.h>
 #include "core.h"
+#include "debug.h"
 
 struct ath10k_hif_sg_item {
 	u16 transfer_id;
@@ -47,6 +48,8 @@ struct ath10k_hif_ops {
 	int (*diag_read)(struct ath10k *ar, u32 address, void *buf,
 			 size_t buf_len);
 
+	int (*diag_write)(struct ath10k *ar, u32 address, const void *data,
+			  int nbytes);
 	/*
 	 * API to handle HIF-specific BMI message exchanges, this API is
 	 * synchronous and only allowed to be called from a context that
@@ -84,6 +87,10 @@ struct ath10k_hif_ops {
 
 	u16 (*get_free_queue_number)(struct ath10k *ar, u8 pipe_id);
 
+	u32 (*read32)(struct ath10k *ar, u32 address);
+
+	void (*write32)(struct ath10k *ar, u32 address, u32 value);
+
 	/* Power up the device and enter BMI transfer mode for FW download */
 	int (*power_up)(struct ath10k *ar);
 
@@ -108,6 +115,15 @@ static inline int ath10k_hif_diag_read(struct ath10k *ar, u32 address, void *buf
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
@@ -187,4 +203,25 @@ static inline int ath10k_hif_resume(struct ath10k *ar)
 	return ar->hif.ops->resume(ar);
 }
 
+static inline u32 ath10k_hif_read32(struct ath10k *ar, u32 address)
+{
+	if (!ar->hif.ops->read32) {
+		ath10k_warn(ar, "hif read32 not supported\n");
+		return 0xdeaddead;
+	}
+
+	return ar->hif.ops->read32(ar, address);
+}
+
+static inline void ath10k_hif_write32(struct ath10k *ar,
+				      u32 address, u32 data)
+{
+	if (!ar->hif.ops->write32) {
+		ath10k_warn(ar, "hif write32 not supported\n");
+		return;
+	}
+
+	ar->hif.ops->write32(ar, address, data);
+}
+
 #endif /* _HIF_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 3a6b8a5..0816098 100644
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
@@ -1998,6 +1999,8 @@ static const struct ath10k_hif_ops ath10k_pci_hif_ops = {
 	.get_free_queue_number	= ath10k_pci_hif_get_free_queue_number,
 	.power_up		= ath10k_pci_hif_power_up,
 	.power_down		= ath10k_pci_hif_power_down,
+	.read32			= ath10k_pci_read32,
+	.write32		= ath10k_pci_write32,
 #ifdef CONFIG_PM
 	.suspend		= ath10k_pci_hif_suspend,
 	.resume			= ath10k_pci_hif_resume,
-- 
1.7.9.5

