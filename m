Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48044 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaJTQj4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 12:39:56 -0400
From: Yanbo Li <yanbol@qti.qualcomm.com>
To: <kvalo@qca.qualcomm.com>, <ath10k-devel@qca.qualcomm.com>,
	<senthilb@qti.qualcomm.com>, <dreamfly281@gmail.com>,
	<linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
CC: Yanbo Li <yanbol@qti.qualcomm.com>
Subject: [PATCH v3] Add the target register read/write and memory dump debugfs interface
Date: Tue, 21 Oct 2014 00:38:05 +0800
Message-ID: <1413823085-3187-1-git-send-email-yanbol@qti.qualcomm.com> (sfid-20141020_184000_594151_BAAAD3AD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The debugfs interface reg_addr&reg_val used to read and write the target
register.
The interface mem_addr&mem_val used to dump the targer memory and also
can be used to assign value to target memory

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
mem_addr (the memory address the length also can used as the second
paramenter address length)				(read&write)
mem_value (the content of the memory with the length, output is binary)
							(read&write)
Read operation:
1. Write the address and length to mem_addr
   IE:  echo 0x400000 1024 > mem_addr
2. Read the value from mem value, the output is binary format
   IE:  hexdump mem_value
Write operation:
1. Write the start mem address to mem_addr
   IE:  echo 0x400000 > mem_addr
2. Dump the binary value to the mem_value
   IE:  echo  0x2400 > mem_value or echo 0x2400 0x3400 ... > mem_addr
   (the value number should be separated with spacebar)

Signed-off-by: Yanbo Li <yanbol@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |    6 +
 drivers/net/wireless/ath/ath10k/debug.c |  292 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hif.h   |   35 ++++
 drivers/net/wireless/ath/ath10k/pci.c   |    3 +
 4 files changed, 336 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index fe531ea..ab97f7a 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -304,6 +304,12 @@ struct ath10k_debug {
 
 	u32 fw_dbglog_mask;
 
+	u32 reg_addr;
+
+	u32 mem_addr;
+	unsigned int mem_len;
+	u32 mem_value;
+
 	u8 htt_max_amsdu;
 	u8 htt_max_ampdu;
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index c192114..85122db 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -22,6 +22,7 @@
 #include <linux/vmalloc.h>
 
 #include "core.h"
+#include "hif.h"
 #include "debug.h"
 
 /* ms */
@@ -825,6 +826,285 @@ static const struct file_operations fops_fw_crash_dump = {
 	.llseek = default_llseek,
 };
 
+static ssize_t ath10k_reg_addr_read(struct file *file,
+				    char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	u8 buf[32];
+	unsigned int len = 0;
+
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "0x%x\n", ar->debug.reg_addr);
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
+	ar->debug.reg_addr = reg_addr;
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
+	reg_addr = ar->debug.reg_addr;
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
+	reg_addr = ar->debug.reg_addr;
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
+static ssize_t ath10k_mem_addr_read(struct file *file,
+				    char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	u8 buf[48];
+	unsigned int len;
+	u32 mem_addr;
+	unsigned int mem_len;
+
+	mutex_lock(&ar->conf_mutex);
+
+	mem_addr = ar->debug.mem_addr;
+	mem_len = ar->debug.mem_len;
+
+	mutex_unlock(&ar->conf_mutex);
+
+	len = scnprintf(buf, sizeof(buf), "0x%08x %d\n", mem_addr, mem_len);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t ath10k_mem_addr_write(struct file *file,
+				     const char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	char buf[48];
+	char *sptr, *token;
+	unsigned int len;
+	u32 mem_addr;
+	unsigned int mem_len;
+	int ret;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	sptr = buf;
+
+	token = strsep(&sptr, " ");
+
+	if (sptr) {
+		ret = kstrtou32(sptr, 0, &mem_len);
+		if (ret)
+			return ret;
+	} else {
+		mem_len = sizeof(mem_addr);
+	}
+
+	ret = kstrtou32(token, 0, &mem_addr);
+	if (ret)
+		return ret;
+
+	if (!IS_ALIGNED(mem_addr, 4))
+		return -EFAULT;
+
+	if (!mem_len || !IS_ALIGNED(mem_len, 4))
+		return -EINVAL;
+
+	mutex_lock(&ar->conf_mutex);
+
+	ar->debug.mem_addr = mem_addr;
+	ar->debug.mem_len = mem_len;
+
+	mutex_unlock(&ar->conf_mutex);
+
+	return count;
+}
+
+static const struct file_operations fops_mem_addr = {
+	.read = ath10k_mem_addr_read,
+	.write = ath10k_mem_addr_write,
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
+	u32 mem_addr;
+	unsigned int mem_len;
+
+	mutex_lock(&ar->conf_mutex);
+
+	mem_addr = ar->debug.mem_addr;
+	mem_len = ar->debug.mem_len;
+
+	mutex_unlock(&ar->conf_mutex);
+
+	if (!mem_len)
+		return -EINVAL;
+
+	buf = vmalloc(mem_len);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = ath10k_hif_diag_read(ar, mem_addr, buf, mem_len);
+	if (ret) {
+		ath10k_warn(ar, "failed to read address 0x%08x via diagnose window from debugfs: %d\n",
+			    mem_addr, ret);
+		goto read_err;
+	}
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, mem_len);
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
+	__le32 *value;
+	char *sptr, *token;
+	int i, ret;
+	u32 mem_addr;
+	u32 mem_val;
+
+	mem_addr =  ar->debug.mem_addr;
+
+	/* extent the buf to +1 with null termination */
+	buf = vmalloc(count + 1);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = copy_from_user(buf, user_buf, count);
+	if (ret)
+		goto err_free_copy;
+
+	buf[count] = '\0';
+	sptr = buf;
+
+	/* Allocate engough memory space to store the
+	 * unknow number input from userspace
+	 */
+	value = vmalloc(count * sizeof(*value));
+	if (!value) {
+		ret = -ENOMEM;
+		goto err_free_copy;
+	}
+
+	i = 0;
+	while (sptr) {
+		if (!sptr)
+			break;
+
+		token = strsep(&sptr, " ");
+
+		ret = kstrtou32(token, 0, &mem_val);
+		if (ret)
+			goto err_free_value;
+
+		value[i] = mem_val;
+		i++;
+	}
+
+	ret = ath10k_hif_diag_write(ar, mem_addr, (const void *)value,
+				    i * sizeof(mem_val));
+	if (ret) {
+		ath10k_warn(ar, "failed to write address 0x%08x via diagnose window from debugfs: %d\n",
+			    mem_addr, ret);
+		goto err_free_value;
+	}
+
+	ret = count;
+
+err_free_value:
+	vfree(value);
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
@@ -1200,6 +1480,18 @@ int ath10k_debug_register(struct ath10k *ar)
 	debugfs_create_file("fw_crash_dump", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_fw_crash_dump);
 
+	debugfs_create_file("reg_addr", S_IRUSR | S_IWUSR,
+			    ar->debug.debugfs_phy, ar, &fops_reg_addr);
+
+	debugfs_create_file("reg_value", S_IRUSR | S_IWUSR,
+			    ar->debug.debugfs_phy, ar, &fops_reg_value);
+
+	debugfs_create_file("mem_addr", S_IRUSR | S_IWUSR,
+			    ar->debug.debugfs_phy, ar, &fops_mem_addr);
+
+	debugfs_create_file("mem_value", S_IRUSR | S_IWUSR,
+			    ar->debug.debugfs_phy, ar, &fops_mem_value);
+
 	debugfs_create_file("chip_id", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_chip_id);
 
diff --git a/drivers/net/wireless/ath/ath10k/hif.h b/drivers/net/wireless/ath/ath10k/hif.h
index 2ac7bea..df64a24 100644
--- a/drivers/net/wireless/ath/ath10k/hif.h
+++ b/drivers/net/wireless/ath/ath10k/hif.h
@@ -20,6 +20,7 @@
 
 #include <linux/kernel.h>
 #include "core.h"
+#include "debug.h"
 
 struct ath10k_hif_sg_item {
 	u16 transfer_id;
@@ -80,6 +81,10 @@ struct ath10k_hif_ops {
 
 	u16 (*get_free_queue_number)(struct ath10k *ar, u8 pipe_id);
 
+	u32 (*read32)(struct ath10k *ar, u32 address);
+	void (*write32)(struct ath10k *ar, u32 address, u32 value);
+	int (*diag_write)(struct ath10k *ar, u32 address, const void *data,
+			  int nbytes);
 	/* Power up the device and enter BMI transfer mode for FW download */
 	int (*power_up)(struct ath10k *ar);
 
@@ -178,4 +183,34 @@ static inline int ath10k_hif_resume(struct ath10k *ar)
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
+static inline int ath10k_hif_diag_write(struct ath10k *ar, u32 address,
+					const void *data, int nbytes)
+{
+	if (!ar->hif.ops->diag_write)
+		return -EOPNOTSUPP;
+
+	return ar->hif.ops->diag_write(ar, address, data, nbytes);
+}
+
 #endif /* _HIF_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index baeb98e..bc30266 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1930,6 +1930,9 @@ static const struct ath10k_hif_ops ath10k_pci_hif_ops = {
 	.get_free_queue_number	= ath10k_pci_hif_get_free_queue_number,
 	.power_up		= ath10k_pci_hif_power_up,
 	.power_down		= ath10k_pci_hif_power_down,
+	.read32			= ath10k_pci_read32,
+	.write32		= ath10k_pci_write32,
+	.diag_write		= ath10k_pci_diag_write_mem,
 #ifdef CONFIG_PM
 	.suspend		= ath10k_pci_hif_suspend,
 	.resume			= ath10k_pci_hif_resume,
-- 
1.7.9.5

