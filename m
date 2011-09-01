Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49206 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956Ab1IAKJQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 06:09:16 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V3] ath6kl: ath6kl: Add debugfs interface to dump diagnostic registers
Date: Thu, 1 Sep 2011 15:39:12 +0530
Message-ID: <1314871752-13740-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110901_120918_891907_71A3FEA1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To dump a particular register, echo reg_addr > <debugfs_root>/ieee80211/phyX/ath6kl/reg_addr,
to dump the entire register set, echo 0 > <debugfs_root>/ieee80211/phyX/ath6kl/reg_addr, and
register values will be available at <debugfs_root>/ieee80211/phyX/ath6kl/reg_dump.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h  |    1 +
 drivers/net/wireless/ath/ath6kl/debug.c |  193 +++++++++++++++++++++++++++++++
 2 files changed, 194 insertions(+), 0 deletions(-)

V2 -- Fix endian related sparse warnings
   -- Address Kalle's comments
V3 -- Fix permission for reg_addr

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 6f83e92..c0035ff 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -475,6 +475,7 @@ struct ath6kl {
 		spinlock_t fwlog_lock;
 		void *fwlog_tmp;
 		u32 fwlog_mask;
+		unsigned int dbgfs_diag_reg;
 	} debug;
 #endif /* CONFIG_ATH6KL_DEBUG */
 
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 87de44d..0cd318b 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -54,6 +54,27 @@ int ath6kl_printk(const char *level, const char *fmt, ...)
 }
 
 #ifdef CONFIG_ATH6KL_DEBUG
+
+#define REG_OUTPUT_LEN_PER_LINE	25
+#define REGTYPE_STR_LEN		100
+
+struct ath6kl_diag_reg_info {
+	u32 reg_start;
+	u32 reg_end;
+	const char *reg_info;
+};
+
+static const struct ath6kl_diag_reg_info diag_reg[] = {
+	{ 0x20000, 0x200fc, "General DMA and Rx registers" },
+	{ 0x28000, 0x28900, "MAC PCU register & keycache" },
+	{ 0x20800, 0x20a40, "QCU" },
+	{ 0x21000, 0x212f0, "DCU" },
+	{ 0x4000,  0x42e4, "RTC" },
+	{ 0x540000, 0x540000 + (256 * 1024), "RAM" },
+	{ 0x29800, 0x2B210, "Base Band" },
+	{ 0x1C000, 0x1C748, "Analog" },
+};
+
 void ath6kl_dump_registers(struct ath6kl_device *dev,
 			   struct ath6kl_irq_proc_registers *irq_proc_reg,
 			   struct ath6kl_irq_enable_reg *irq_enable_reg)
@@ -528,6 +549,172 @@ static const struct file_operations fops_credit_dist_stats = {
 	.llseek = default_llseek,
 };
 
+static unsigned long ath6kl_get_num_reg(void)
+{
+	int i;
+	unsigned long n_reg = 0;
+
+	for (i = 0; i < ARRAY_SIZE(diag_reg); i++)
+		n_reg = n_reg +
+		     (diag_reg[i].reg_end - diag_reg[i].reg_start) / 4 + 1;
+
+	return n_reg;
+}
+
+static bool ath6kl_dbg_is_diag_reg_valid(u32 reg_addr)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(diag_reg); i++) {
+		if (reg_addr >= diag_reg[i].reg_start &&
+		    reg_addr <= diag_reg[i].reg_end)
+			return true;
+	}
+
+	ath6kl_warn("Given address is not in the valid chip address range\n");
+	return false;
+}
+
+static ssize_t ath6kl_rd_reg_read(struct file *file, char __user *user_buf,
+				  size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	u8 buf[50];
+	unsigned int len = 0;
+
+	if (ar->debug.dbgfs_diag_reg)
+		len += scnprintf(buf + len, sizeof(buf) - len, "0x%x\n",
+				ar->debug.dbgfs_diag_reg);
+	else
+		len += scnprintf(buf + len, sizeof(buf) - len,
+				 "All diag registers\n");
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t ath6kl_wr_reg_read(struct file *file,
+				  const char __user *user_buf,
+				  size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	u8 buf[50];
+	unsigned int len;
+	unsigned long reg_addr;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+
+	if (strict_strtoul(buf, 0, &reg_addr))
+		return -EINVAL;
+
+	if ((reg_addr % 4) != 0)
+		return -EINVAL;
+
+	if (reg_addr && !ath6kl_dbg_is_diag_reg_valid(reg_addr))
+		return -EINVAL;
+
+	ar->debug.dbgfs_diag_reg = reg_addr;
+
+	return count;
+}
+
+static const struct file_operations fops_diag_reg_read = {
+	.read = ath6kl_rd_reg_read,
+	.write = ath6kl_wr_reg_read,
+	.open = ath6kl_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+static int ath6kl_regdump_open(struct inode *inode, struct file *file)
+{
+	struct ath6kl *ar = inode->i_private;
+	u8 *buf;
+	unsigned long int reg_len;
+	unsigned int len = 0, n_reg;
+	u32 addr;
+	__le32 reg_val;
+	int i, status;
+
+	/* Dump all the registers if no register is specified */
+	if (!ar->debug.dbgfs_diag_reg)
+		n_reg = ath6kl_get_num_reg();
+	else
+		n_reg = 1;
+
+	reg_len = n_reg * REG_OUTPUT_LEN_PER_LINE;
+	if (n_reg > 1)
+		reg_len += REGTYPE_STR_LEN;
+
+	buf = vmalloc(reg_len);
+	if (!buf)
+		return -ENOMEM;
+
+	if (n_reg == 1) {
+		addr = ar->debug.dbgfs_diag_reg;
+
+		status = ath6kl_diag_read32(ar,
+				TARG_VTOP(ar->target_type, addr),
+				(u32 *)&reg_val);
+		if (status)
+			goto fail_reg_read;
+
+		len += scnprintf(buf + len, reg_len - len,
+				 "0x%06x 0x%08x\n", addr, le32_to_cpu(reg_val));
+		goto done;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(diag_reg); i++) {
+		len += scnprintf(buf + len, reg_len - len,
+				"%s\n", diag_reg[i].reg_info);
+		for (addr = diag_reg[i].reg_start;
+		     addr <= diag_reg[i].reg_end; addr += 4) {
+			status = ath6kl_diag_read32(ar,
+					TARG_VTOP(ar->target_type, addr),
+					(u32 *)&reg_val);
+			if (status)
+				goto fail_reg_read;
+
+			len += scnprintf(buf + len, reg_len - len,
+					"0x%06x 0x%08x\n",
+					addr, le32_to_cpu(reg_val));
+		}
+	}
+
+done:
+	file->private_data = buf;
+	return 0;
+
+fail_reg_read:
+	ath6kl_warn("Unable to read memory:%u\n", addr);
+	vfree(buf);
+	return -EIO;
+}
+
+static ssize_t ath6kl_regdump_read(struct file *file, char __user *user_buf,
+				  size_t count, loff_t *ppos)
+{
+	u8 *buf = file->private_data;
+	return simple_read_from_buffer(user_buf, count, ppos, buf, strlen(buf));
+}
+
+static int ath6kl_regdump_release(struct inode *inode, struct file *file)
+{
+	vfree(file->private_data);
+	return 0;
+}
+
+static const struct file_operations fops_reg_dump = {
+	.open = ath6kl_regdump_open,
+	.read = ath6kl_regdump_read,
+	.release = ath6kl_regdump_release,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 int ath6kl_debug_init(struct ath6kl *ar)
 {
 	ar->debug.fwlog_buf.buf = vmalloc(ATH6KL_FWLOG_SIZE);
@@ -568,6 +755,12 @@ int ath6kl_debug_init(struct ath6kl *ar)
 	debugfs_create_file("fwlog_mask", S_IRUSR | S_IWUSR, ar->debugfs_phy,
 			    ar, &fops_fwlog_mask);
 
+	debugfs_create_file("reg_addr", S_IRUSR | S_IWUSR, ar->debugfs_phy, ar,
+			    &fops_diag_reg_read);
+
+	debugfs_create_file("reg_dump", S_IRUSR, ar->debugfs_phy, ar,
+			    &fops_reg_dump);
+
 	return 0;
 }
 
-- 
1.7.0.4

