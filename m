Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:65119 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751173AbaDQSrs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2014 14:47:48 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/5] mwifiex: add firmware dump feature for PCIe
Date: Thu, 17 Apr 2014 11:47:00 -0700
Message-ID: <1397760423-11455-2-git-send-email-bzhao@marvell.com> (sfid-20140417_204807_402751_AF7ECC70)
In-Reply-To: <1397760423-11455-1-git-send-email-bzhao@marvell.com>
References: <1397760423-11455-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Firmware dump feature is added for PCIe based chipsets.
Separate file will be created at /var/log/fw_dump_*
for each memory segment.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c |   3 +
 drivers/net/wireless/mwifiex/main.c   |   2 +
 drivers/net/wireless/mwifiex/main.h   |   2 +
 drivers/net/wireless/mwifiex/pcie.c   | 227 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/pcie.h   |  27 ++++
 5 files changed, 261 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 8dee6c8..421322f 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -960,6 +960,9 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_INITIALIZING)
 		mwifiex_init_fw_complete(adapter);
 
+	if (adapter->if_ops.fw_dump)
+		adapter->if_ops.fw_dump(adapter);
+
 	if (adapter->if_ops.card_reset)
 		adapter->if_ops.card_reset(adapter);
 }
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index cbabc12..6bc645a 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -881,6 +881,8 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 		goto err_kmalloc;
 
 	INIT_WORK(&adapter->main_work, mwifiex_main_work_queue);
+	if (adapter->if_ops.iface_work)
+		INIT_WORK(&adapter->iface_work, adapter->if_ops.iface_work);
 
 	/* Register the device. Fill up the private data structure with relevant
 	   information from the card. */
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 3418119..d70457b 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -674,6 +674,7 @@ struct mwifiex_if_ops {
 	void (*card_reset) (struct mwifiex_adapter *);
 	void (*fw_dump)(struct mwifiex_adapter *);
 	int (*clean_pcie_ring) (struct mwifiex_adapter *adapter);
+	void (*iface_work)(struct work_struct *work);
 };
 
 struct mwifiex_adapter {
@@ -809,6 +810,7 @@ struct mwifiex_adapter {
 	bool ext_scan;
 	u8 fw_api_ver;
 	u8 fw_key_api_major_ver, fw_key_api_minor_ver;
+	struct work_struct iface_work;
 };
 
 int mwifiex_init_lock_list(struct mwifiex_adapter *adapter);
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index c2cfeec..51989b3 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -37,6 +37,9 @@ static struct mwifiex_if_ops pcie_ops;
 
 static struct semaphore add_remove_card_sem;
 
+/* enum mwifiex_pcie_work_flags bitmap */
+static unsigned long pcie_work_flags;
+
 static int
 mwifiex_map_pci_memory(struct mwifiex_adapter *adapter, struct sk_buff *skb,
 		       size_t size, int flags)
@@ -221,6 +224,8 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 	if (!adapter || !adapter->priv_num)
 		return;
 
+	cancel_work_sync(&adapter->iface_work);
+
 	if (user_rmmod) {
 #ifdef CONFIG_PM_SLEEP
 		if (adapter->is_suspended)
@@ -307,6 +312,17 @@ static int mwifiex_read_reg(struct mwifiex_adapter *adapter, int reg, u32 *data)
 	return 0;
 }
 
+/* This function reads u8 data from PCIE card register. */
+static int mwifiex_read_reg_byte(struct mwifiex_adapter *adapter,
+				 int reg, u8 *data)
+{
+	struct pcie_service_card *card = adapter->card;
+
+	*data = ioread8(card->pci_mmap1 + reg);
+
+	return 0;
+}
+
 /*
  * This function adds delay loop to ensure FW is awake before proceeding.
  */
@@ -2172,6 +2188,215 @@ static int mwifiex_pcie_host_to_card(struct mwifiex_adapter *adapter, u8 type,
 	return 0;
 }
 
+/* This function read/write firmware */
+static enum rdwr_status
+mwifiex_pcie_rdwr_firmware(struct mwifiex_adapter *adapter, u8 doneflag)
+{
+	int ret, tries;
+	u8 ctrl_data;
+
+	ret = mwifiex_write_reg(adapter, DEBUG_DUMP_CTRL_REG, DEBUG_HOST_READY);
+	if (ret) {
+		dev_err(adapter->dev, "PCIE write err\n");
+		return RDWR_STATUS_FAILURE;
+	}
+
+	for (tries = 0; tries < MAX_POLL_TRIES; tries++) {
+		mwifiex_read_reg_byte(adapter, DEBUG_DUMP_CTRL_REG, &ctrl_data);
+		if (ctrl_data == DEBUG_FW_DONE)
+			return RDWR_STATUS_SUCCESS;
+		if (doneflag && ctrl_data == doneflag)
+			return RDWR_STATUS_DONE;
+		if (ctrl_data != DEBUG_HOST_READY) {
+			dev_info(adapter->dev,
+				 "The ctrl reg was changed, re-try again!\n");
+			mwifiex_write_reg(adapter, DEBUG_DUMP_CTRL_REG,
+					  DEBUG_HOST_READY);
+			if (ret) {
+				dev_err(adapter->dev, "PCIE write err\n");
+				return RDWR_STATUS_FAILURE;
+			}
+		}
+		usleep_range(100, 200);
+	}
+
+	dev_err(adapter->dev, "Fail to pull ctrl_data\n");
+	return RDWR_STATUS_FAILURE;
+}
+
+/* This function dump firmware memory to file */
+static void mwifiex_pcie_fw_dump_work(struct work_struct *work)
+{
+	struct mwifiex_adapter *adapter =
+			container_of(work, struct mwifiex_adapter, iface_work);
+	unsigned int reg, reg_start, reg_end;
+	u8 *dbg_ptr;
+	struct timeval t;
+	u8 dump_num = 0, idx, i, read_reg, doneflag = 0;
+	enum rdwr_status stat;
+	u32 memory_size;
+	u8 filename[MAX_FULL_NAME_LEN];
+	mm_segment_t fs;
+	loff_t pos;
+	u8 *end_ptr;
+	u8 *name_prefix = "/var/log/fw_dump_";
+	struct memory_type_mapping mem_type_mapping_tbl[] = {
+		{"ITCM", NULL, NULL, 0xF0},
+		{"DTCM", NULL, NULL, 0xF1},
+		{"SQRAM", NULL, NULL, 0xF2},
+		{"IRAM", NULL, NULL, 0xF3},
+	};
+
+	if (!adapter) {
+		dev_err(adapter->dev, "Could not dump firmwware info\n");
+		return;
+	}
+
+	do_gettimeofday(&t);
+	dev_info(adapter->dev, "== mwifiex firmware dump start: %u.%06u ==\n",
+		 (u32)t.tv_sec, (u32)t.tv_usec);
+
+	/* Read the number of the memories which will dump */
+	stat = mwifiex_pcie_rdwr_firmware(adapter, doneflag);
+	if (stat == RDWR_STATUS_FAILURE)
+		goto done;
+
+	reg = DEBUG_DUMP_START_REG;
+	mwifiex_read_reg_byte(adapter, reg, &dump_num);
+
+	/* Read the length of every memory which will dump */
+	for (idx = 0; idx < dump_num; idx++) {
+		struct memory_type_mapping *entry = &mem_type_mapping_tbl[idx];
+
+		stat = mwifiex_pcie_rdwr_firmware(adapter, doneflag);
+		if (stat == RDWR_STATUS_FAILURE)
+			goto done;
+
+		memory_size = 0;
+		reg = DEBUG_DUMP_START_REG;
+		for (i = 0; i < 4; i++) {
+			mwifiex_read_reg_byte(adapter, reg, &read_reg);
+			memory_size |= (read_reg << (i * 8));
+			reg++;
+		}
+
+		if (memory_size == 0) {
+			dev_info(adapter->dev, "Firmware dump Finished!\n");
+			break;
+		}
+
+		dev_info(adapter->dev,
+			 "%s_SIZE=0x%x\n", entry->mem_name, memory_size);
+		entry->mem_ptr = vmalloc(memory_size + 1);
+		if (!entry->mem_ptr) {
+			dev_err(adapter->dev,
+				"Vmalloc %s failed\n", entry->mem_name);
+			goto done;
+		}
+		dbg_ptr = entry->mem_ptr;
+		end_ptr = dbg_ptr + memory_size;
+
+		doneflag = entry->done_flag;
+		do_gettimeofday(&t);
+		dev_info(adapter->dev, "Start %s output %u.%06u, please wait...\n",
+			 entry->mem_name, (u32)t.tv_sec, (u32)t.tv_usec);
+
+		do {
+			stat = mwifiex_pcie_rdwr_firmware(adapter, doneflag);
+			if (RDWR_STATUS_FAILURE == stat)
+				goto done;
+
+			reg_start = DEBUG_DUMP_START_REG;
+			reg_end = DEBUG_DUMP_END_REG;
+			for (reg = reg_start; reg <= reg_end; reg++) {
+				mwifiex_read_reg_byte(adapter, reg, dbg_ptr);
+				if (dbg_ptr < end_ptr)
+					dbg_ptr++;
+				else
+					dev_err(adapter->dev,
+						"Allocated buf not enough\n");
+			}
+
+			if (stat != RDWR_STATUS_DONE)
+				continue;
+
+			dev_info(adapter->dev, "%s done: size=0x%lx\n",
+				 entry->mem_name, dbg_ptr - entry->mem_ptr);
+			memset(filename, 0, sizeof(filename));
+			memcpy(filename, name_prefix, strlen(name_prefix));
+			strcat(filename, entry->mem_name);
+			do_gettimeofday(&t);
+			entry->file_mem = filp_open(filename, O_CREAT | O_RDWR,
+						    0644);
+			if (IS_ERR(entry->file_mem)) {
+				dev_info(adapter->dev,
+					 "Create %s file failed at %s, opening another dir /tmp\n",
+					 entry->mem_name, filename);
+				memset(filename, 0, sizeof(filename));
+				sprintf(filename, "%s%s", "/tmp/fw_dump_",
+					entry->mem_name);
+				entry->file_mem =
+					filp_open(filename,
+						  O_CREAT | O_RDWR, 0644);
+			}
+			if (!IS_ERR(entry->file_mem)) {
+				dev_info(adapter->dev,
+					 "Start to save the output : %u.%06u, please wait...\n",
+					 (u32)t.tv_sec, (u32)t.tv_usec);
+				fs = get_fs();
+				set_fs(KERNEL_DS);
+				pos = 0;
+				vfs_write(entry->file_mem,
+					  (char __user *)entry->mem_ptr,
+					  memory_size, &pos);
+				filp_close(entry->file_mem, NULL);
+				set_fs(fs);
+				dev_info(adapter->dev,
+					 "The output %s have been saved to file successfully!\n",
+					 entry->mem_name);
+			} else {
+				dev_err(adapter->dev,
+					"Failed to create file %s\n", filename);
+			}
+			vfree(entry->mem_ptr);
+			entry->mem_ptr = NULL;
+			break;
+		} while (true);
+	}
+	do_gettimeofday(&t);
+	dev_info(adapter->dev, "== mwifiex firmware dump end: %u.%06u ==\n",
+		 (u32)t.tv_sec, (u32)t.tv_usec);
+
+done:
+	for (idx = 0; idx < ARRAY_SIZE(mem_type_mapping_tbl); idx++) {
+		struct memory_type_mapping *entry = &mem_type_mapping_tbl[idx];
+
+		if (entry->mem_ptr) {
+			vfree(entry->mem_ptr);
+			entry->mem_ptr = NULL;
+		}
+	}
+
+	return;
+}
+
+static void mwifiex_pcie_work(struct work_struct *work)
+{
+	if (test_and_clear_bit(MWIFIEX_PCIE_WORK_FW_DUMP, &pcie_work_flags))
+		mwifiex_pcie_fw_dump_work(work);
+}
+
+/* This function dumps FW information */
+static void mwifiex_pcie_fw_dump(struct mwifiex_adapter *adapter)
+{
+	if (test_bit(MWIFIEX_PCIE_WORK_FW_DUMP, &pcie_work_flags))
+		return;
+
+	set_bit(MWIFIEX_PCIE_WORK_FW_DUMP, &pcie_work_flags);
+
+	schedule_work(&adapter->iface_work);
+}
+
 /*
  * This function initializes the PCI-E host memory space, WCB rings, etc.
  *
@@ -2393,6 +2618,8 @@ static struct mwifiex_if_ops pcie_ops = {
 	.cleanup_mpa_buf =		NULL,
 	.init_fw_port =			mwifiex_pcie_init_fw_port,
 	.clean_pcie_ring =		mwifiex_clean_pcie_ring_buf,
+	.fw_dump =			mwifiex_pcie_fw_dump,
+	.iface_work =			mwifiex_pcie_work,
 };
 
 /*
diff --git a/drivers/net/wireless/mwifiex/pcie.h b/drivers/net/wireless/mwifiex/pcie.h
index e8ec561..3abba32 100644
--- a/drivers/net/wireless/mwifiex/pcie.h
+++ b/drivers/net/wireless/mwifiex/pcie.h
@@ -100,6 +100,28 @@
 #define MWIFIEX_DEF_SLEEP_COOKIE			0xBEEFBEEF
 #define MWIFIEX_MAX_DELAY_COUNT				5
 
+#define DEBUG_DUMP_CTRL_REG				0xCF4
+#define DEBUG_DUMP_START_REG				0xCF8
+#define DEBUG_DUMP_END_REG				0xCFF
+#define DEBUG_HOST_READY				0xEE
+#define DEBUG_FW_DONE					0xFF
+
+#define MAX_NAME_LEN					8
+#define MAX_FULL_NAME_LEN				32
+
+struct memory_type_mapping {
+	u8 mem_name[MAX_NAME_LEN];
+	u8 *mem_ptr;
+	struct file *file_mem;
+	u8 done_flag;
+};
+
+enum rdwr_status {
+	RDWR_STATUS_SUCCESS = 0,
+	RDWR_STATUS_FAILURE = 1,
+	RDWR_STATUS_DONE = 2
+};
+
 struct mwifiex_pcie_card_reg {
 	u16 cmd_addr_lo;
 	u16 cmd_addr_hi;
@@ -322,4 +344,9 @@ mwifiex_pcie_txbd_not_full(struct pcie_service_card *card)
 
 	return 0;
 }
+
+enum mwifiex_pcie_work_flags {
+	MWIFIEX_PCIE_WORK_FW_DUMP,
+};
+
 #endif /* _MWIFIEX_PCIE_H */
-- 
1.8.2.3

