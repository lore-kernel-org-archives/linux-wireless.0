Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57848 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S938751AbcJXOWj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 10:22:39 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <dmitry.torokhov@gmail.com>, <briannorris@google.com>,
        Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 4/5] mwifiex: firmware dump code rearrangement in pcie.c
Date: Mon, 24 Oct 2016 19:51:31 +0530
Message-ID: <1477318892-22877-4-git-send-email-akarwar@marvell.com> (sfid-20161024_162242_976914_4ACDC767)
In-Reply-To: <1477318892-22877-1-git-send-email-akarwar@marvell.com>
References: <1477318892-22877-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

The next patch will refer to pcie_work in mwifiex_pcie_remove function.
This patch puts pcie_work related functions ahead to mwifiex_pcie_remove
to avoid static forward declaration.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 590 ++++++++++++++--------------
 1 file changed, 294 insertions(+), 296 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 9147e6a..986bf07 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -65,6 +65,42 @@ static void mwifiex_unmap_pci_memory(struct mwifiex_adapter *adapter,
 }
 
 /*
+ * This function writes data into PCIE card register.
+ */
+static int mwifiex_write_reg(struct mwifiex_adapter *adapter, int reg, u32 data)
+{
+	struct pcie_service_card *card = adapter->card;
+
+	iowrite32(data, card->pci_mmap1 + reg);
+
+	return 0;
+}
+
+/*  This function reads data from PCIE card register.
+ */
+static int mwifiex_read_reg(struct mwifiex_adapter *adapter, int reg, u32 *data)
+{
+	struct pcie_service_card *card = adapter->card;
+
+	*data = ioread32(card->pci_mmap1 + reg);
+	if (*data == 0xffffffff)
+		return 0xffffffff;
+
+	return 0;
+}
+
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
+/*
  * This function reads sleep cookie and checks if FW is ready
  */
 static bool mwifiex_pcie_ok_to_access_hw(struct mwifiex_adapter *adapter)
@@ -88,6 +124,249 @@ static bool mwifiex_pcie_ok_to_access_hw(struct mwifiex_adapter *adapter)
 	return false;
 }
 
+/* Function to dump PCIE scratch registers in case of FW crash
+ */
+static int
+mwifiex_pcie_reg_dump(struct mwifiex_adapter *adapter, char *drv_buf)
+{
+	char *p = drv_buf;
+	char buf[256], *ptr;
+	int i;
+	u32 value;
+	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
+	int pcie_scratch_reg[] = {PCIE_SCRATCH_12_REG,
+				  PCIE_SCRATCH_13_REG,
+				  PCIE_SCRATCH_14_REG};
+
+	if (!p)
+		return 0;
+
+	mwifiex_dbg(adapter, MSG, "PCIE register dump start\n");
+
+	if (mwifiex_read_reg(adapter, reg->fw_status, &value)) {
+		mwifiex_dbg(adapter, ERROR, "failed to read firmware status");
+		return 0;
+	}
+
+	ptr = buf;
+	mwifiex_dbg(adapter, MSG, "pcie scratch register:");
+	for (i = 0; i < ARRAY_SIZE(pcie_scratch_reg); i++) {
+		mwifiex_read_reg(adapter, pcie_scratch_reg[i], &value);
+		ptr += sprintf(ptr, "reg:0x%x, value=0x%x\n",
+			       pcie_scratch_reg[i], value);
+	}
+
+	mwifiex_dbg(adapter, MSG, "%s\n", buf);
+	p += sprintf(p, "%s\n", buf);
+
+	mwifiex_dbg(adapter, MSG, "PCIE register dump end\n");
+
+	return p - drv_buf;
+}
+
+/* This function read/write firmware */
+static enum rdwr_status
+mwifiex_pcie_rdwr_firmware(struct mwifiex_adapter *adapter, u8 doneflag)
+{
+	int ret, tries;
+	u8 ctrl_data;
+	u32 fw_status;
+	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
+
+	if (mwifiex_read_reg(adapter, reg->fw_status, &fw_status))
+		return RDWR_STATUS_FAILURE;
+
+	ret = mwifiex_write_reg(adapter, reg->fw_dump_ctrl,
+				reg->fw_dump_host_ready);
+	if (ret) {
+		mwifiex_dbg(adapter, ERROR,
+			    "PCIE write err\n");
+		return RDWR_STATUS_FAILURE;
+	}
+
+	for (tries = 0; tries < MAX_POLL_TRIES; tries++) {
+		mwifiex_read_reg_byte(adapter, reg->fw_dump_ctrl, &ctrl_data);
+		if (ctrl_data == FW_DUMP_DONE)
+			return RDWR_STATUS_SUCCESS;
+		if (doneflag && ctrl_data == doneflag)
+			return RDWR_STATUS_DONE;
+		if (ctrl_data != reg->fw_dump_host_ready) {
+			mwifiex_dbg(adapter, WARN,
+				    "The ctrl reg was changed, re-try again!\n");
+			ret = mwifiex_write_reg(adapter, reg->fw_dump_ctrl,
+						reg->fw_dump_host_ready);
+			if (ret) {
+				mwifiex_dbg(adapter, ERROR,
+					    "PCIE write err\n");
+				return RDWR_STATUS_FAILURE;
+			}
+		}
+		usleep_range(100, 200);
+	}
+
+	mwifiex_dbg(adapter, ERROR, "Fail to pull ctrl_data\n");
+	return RDWR_STATUS_FAILURE;
+}
+
+/* This function dump firmware memory to file */
+static void mwifiex_pcie_fw_dump(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *creg = card->pcie.reg;
+	unsigned int reg, reg_start, reg_end;
+	u8 *dbg_ptr, *end_ptr, *tmp_ptr, fw_dump_num, dump_num;
+	u8 idx, i, read_reg, doneflag = 0;
+	enum rdwr_status stat;
+	u32 memory_size;
+	int ret;
+
+	if (!card->pcie.can_dump_fw)
+		return;
+
+	for (idx = 0; idx < adapter->num_mem_types; idx++) {
+		struct memory_type_mapping *entry =
+				&adapter->mem_type_mapping_tbl[idx];
+
+		if (entry->mem_ptr) {
+			vfree(entry->mem_ptr);
+			entry->mem_ptr = NULL;
+		}
+		entry->mem_size = 0;
+	}
+
+	mwifiex_dbg(adapter, MSG, "== mwifiex firmware dump start ==\n");
+
+	/* Read the number of the memories which will dump */
+	stat = mwifiex_pcie_rdwr_firmware(adapter, doneflag);
+	if (stat == RDWR_STATUS_FAILURE)
+		return;
+
+	reg = creg->fw_dump_start;
+	mwifiex_read_reg_byte(adapter, reg, &fw_dump_num);
+
+	/* W8997 chipset firmware dump will be restore in single region*/
+	if (fw_dump_num == 0)
+		dump_num = 1;
+	else
+		dump_num = fw_dump_num;
+
+	/* Read the length of every memory which will dump */
+	for (idx = 0; idx < dump_num; idx++) {
+		struct memory_type_mapping *entry =
+				&adapter->mem_type_mapping_tbl[idx];
+		memory_size = 0;
+		if (fw_dump_num != 0) {
+			stat = mwifiex_pcie_rdwr_firmware(adapter, doneflag);
+			if (stat == RDWR_STATUS_FAILURE)
+				return;
+
+			reg = creg->fw_dump_start;
+			for (i = 0; i < 4; i++) {
+				mwifiex_read_reg_byte(adapter, reg, &read_reg);
+				memory_size |= (read_reg << (i * 8));
+				reg++;
+			}
+		} else {
+			memory_size = MWIFIEX_FW_DUMP_MAX_MEMSIZE;
+		}
+
+		if (memory_size == 0) {
+			mwifiex_dbg(adapter, MSG, "Firmware dump Finished!\n");
+			ret = mwifiex_write_reg(adapter, creg->fw_dump_ctrl,
+						creg->fw_dump_read_done);
+			if (ret) {
+				mwifiex_dbg(adapter, ERROR, "PCIE write err\n");
+				return;
+			}
+			break;
+		}
+
+		mwifiex_dbg(adapter, DUMP,
+			    "%s_SIZE=0x%x\n", entry->mem_name, memory_size);
+		entry->mem_ptr = vmalloc(memory_size + 1);
+		entry->mem_size = memory_size;
+		if (!entry->mem_ptr)
+			return;
+
+		dbg_ptr = entry->mem_ptr;
+		end_ptr = dbg_ptr + memory_size;
+
+		doneflag = entry->done_flag;
+		mwifiex_dbg(adapter, DUMP, "Start %s output, please wait...\n",
+			    entry->mem_name);
+
+		do {
+			stat = mwifiex_pcie_rdwr_firmware(adapter, doneflag);
+			if (stat == RDWR_STATUS_FAILURE)
+				return;
+
+			reg_start = creg->fw_dump_start;
+			reg_end = creg->fw_dump_end;
+			for (reg = reg_start; reg <= reg_end; reg++) {
+				mwifiex_read_reg_byte(adapter, reg, dbg_ptr);
+				if (dbg_ptr < end_ptr) {
+					dbg_ptr++;
+					continue;
+				}
+				mwifiex_dbg(adapter, ERROR,
+					    "pre-allocated buf not enough\n");
+				tmp_ptr =
+					vzalloc(memory_size + MWIFIEX_SIZE_4K);
+				if (!tmp_ptr)
+					return;
+				memcpy(tmp_ptr, entry->mem_ptr, memory_size);
+				vfree(entry->mem_ptr);
+				entry->mem_ptr = tmp_ptr;
+				tmp_ptr = NULL;
+				dbg_ptr = entry->mem_ptr + memory_size;
+				memory_size += MWIFIEX_SIZE_4K;
+				end_ptr = entry->mem_ptr + memory_size;
+			}
+
+			if (stat != RDWR_STATUS_DONE)
+				continue;
+
+			mwifiex_dbg(adapter, DUMP,
+				    "%s done: size=0x%tx\n",
+				    entry->mem_name, dbg_ptr - entry->mem_ptr);
+			break;
+		} while (true);
+	}
+	mwifiex_dbg(adapter, MSG, "== mwifiex firmware dump end ==\n");
+}
+
+static void mwifiex_pcie_device_dump_work(struct mwifiex_adapter *adapter)
+{
+	mwifiex_drv_info_dump(adapter);
+	mwifiex_pcie_fw_dump(adapter);
+	mwifiex_upload_device_dump(adapter);
+}
+
+static unsigned long iface_work_flags;
+static struct mwifiex_adapter *save_adapter;
+static void mwifiex_pcie_work(struct work_struct *work)
+{
+	if (test_and_clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP,
+			       &iface_work_flags))
+		mwifiex_pcie_device_dump_work(save_adapter);
+}
+
+static DECLARE_WORK(pcie_work, mwifiex_pcie_work);
+
+/* This function dumps FW information */
+static void mwifiex_pcie_device_dump(struct mwifiex_adapter *adapter)
+{
+	save_adapter = adapter;
+	if (test_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &iface_work_flags))
+		return;
+
+	set_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &iface_work_flags);
+
+	schedule_work(&pcie_work);
+}
+
 #ifdef CONFIG_PM_SLEEP
 /*
  * Kernel needs to suspend all functions separately. Therefore all
@@ -353,58 +632,21 @@ static SIMPLE_DEV_PM_OPS(mwifiex_pcie_pm_ops, mwifiex_pcie_suspend,
 				mwifiex_pcie_resume);
 #endif
 
-/* PCI Device Driver */
-static struct pci_driver __refdata mwifiex_pcie = {
-	.name     = "mwifiex_pcie",
-	.id_table = mwifiex_ids,
-	.probe    = mwifiex_pcie_probe,
-	.remove   = mwifiex_pcie_remove,
-#ifdef CONFIG_PM_SLEEP
-	.driver   = {
-		.pm = &mwifiex_pcie_pm_ops,
-	},
-#endif
-	.shutdown = mwifiex_pcie_shutdown,
-	.err_handler = mwifiex_pcie_err_handler,
-};
-
-/*
- * This function writes data into PCIE card register.
- */
-static int mwifiex_write_reg(struct mwifiex_adapter *adapter, int reg, u32 data)
-{
-	struct pcie_service_card *card = adapter->card;
-
-	iowrite32(data, card->pci_mmap1 + reg);
-
-	return 0;
-}
-
-/*
- * This function reads data from PCIE card register.
- */
-static int mwifiex_read_reg(struct mwifiex_adapter *adapter, int reg, u32 *data)
-{
-	struct pcie_service_card *card = adapter->card;
-
-	*data = ioread32(card->pci_mmap1 + reg);
-	if (*data == 0xffffffff)
-		return 0xffffffff;
-
-	return 0;
-}
-
-/* This function reads u8 data from PCIE card register. */
-static int mwifiex_read_reg_byte(struct mwifiex_adapter *adapter,
-				 int reg, u8 *data)
-{
-	struct pcie_service_card *card = adapter->card;
-
-	*data = ioread8(card->pci_mmap1 + reg);
-
-	return 0;
-}
-
+/* PCI Device Driver */
+static struct pci_driver __refdata mwifiex_pcie = {
+	.name     = "mwifiex_pcie",
+	.id_table = mwifiex_ids,
+	.probe    = mwifiex_pcie_probe,
+	.remove   = mwifiex_pcie_remove,
+#ifdef CONFIG_PM_SLEEP
+	.driver   = {
+		.pm = &mwifiex_pcie_pm_ops,
+	},
+#endif
+	.shutdown = mwifiex_pcie_shutdown,
+	.err_handler = mwifiex_pcie_err_handler,
+};
+
 /*
  * This function adds delay loop to ensure FW is awake before proceeding.
  */
@@ -2482,250 +2724,6 @@ static int mwifiex_pcie_host_to_card(struct mwifiex_adapter *adapter, u8 type,
 	return 0;
 }
 
-/* Function to dump PCIE scratch registers in case of FW crash
- */
-static int
-mwifiex_pcie_reg_dump(struct mwifiex_adapter *adapter, char *drv_buf)
-{
-	char *p = drv_buf;
-	char buf[256], *ptr;
-	int i;
-	u32 value;
-	struct pcie_service_card *card = adapter->card;
-	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
-	int pcie_scratch_reg[] = {PCIE_SCRATCH_12_REG,
-				  PCIE_SCRATCH_13_REG,
-				  PCIE_SCRATCH_14_REG};
-
-	if (!p)
-		return 0;
-
-	mwifiex_dbg(adapter, MSG, "PCIE register dump start\n");
-
-	if (mwifiex_read_reg(adapter, reg->fw_status, &value)) {
-		mwifiex_dbg(adapter, ERROR, "failed to read firmware status");
-		return 0;
-	}
-
-	ptr = buf;
-	mwifiex_dbg(adapter, MSG, "pcie scratch register:");
-	for (i = 0; i < ARRAY_SIZE(pcie_scratch_reg); i++) {
-		mwifiex_read_reg(adapter, pcie_scratch_reg[i], &value);
-		ptr += sprintf(ptr, "reg:0x%x, value=0x%x\n",
-			       pcie_scratch_reg[i], value);
-	}
-
-	mwifiex_dbg(adapter, MSG, "%s\n", buf);
-	p += sprintf(p, "%s\n", buf);
-
-	mwifiex_dbg(adapter, MSG, "PCIE register dump end\n");
-
-	return p - drv_buf;
-}
-
-/* This function read/write firmware */
-static enum rdwr_status
-mwifiex_pcie_rdwr_firmware(struct mwifiex_adapter *adapter, u8 doneflag)
-{
-	int ret, tries;
-	u8 ctrl_data;
-	u32 fw_status;
-	struct pcie_service_card *card = adapter->card;
-	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
-
-	if (mwifiex_read_reg(adapter, reg->fw_status, &fw_status))
-		return RDWR_STATUS_FAILURE;
-
-	ret = mwifiex_write_reg(adapter, reg->fw_dump_ctrl,
-				reg->fw_dump_host_ready);
-	if (ret) {
-		mwifiex_dbg(adapter, ERROR,
-			    "PCIE write err\n");
-		return RDWR_STATUS_FAILURE;
-	}
-
-	for (tries = 0; tries < MAX_POLL_TRIES; tries++) {
-		mwifiex_read_reg_byte(adapter, reg->fw_dump_ctrl, &ctrl_data);
-		if (ctrl_data == FW_DUMP_DONE)
-			return RDWR_STATUS_SUCCESS;
-		if (doneflag && ctrl_data == doneflag)
-			return RDWR_STATUS_DONE;
-		if (ctrl_data != reg->fw_dump_host_ready) {
-			mwifiex_dbg(adapter, WARN,
-				    "The ctrl reg was changed, re-try again!\n");
-			ret = mwifiex_write_reg(adapter, reg->fw_dump_ctrl,
-						reg->fw_dump_host_ready);
-			if (ret) {
-				mwifiex_dbg(adapter, ERROR,
-					    "PCIE write err\n");
-				return RDWR_STATUS_FAILURE;
-			}
-		}
-		usleep_range(100, 200);
-	}
-
-	mwifiex_dbg(adapter, ERROR, "Fail to pull ctrl_data\n");
-	return RDWR_STATUS_FAILURE;
-}
-
-/* This function dump firmware memory to file */
-static void mwifiex_pcie_fw_dump(struct mwifiex_adapter *adapter)
-{
-	struct pcie_service_card *card = adapter->card;
-	const struct mwifiex_pcie_card_reg *creg = card->pcie.reg;
-	unsigned int reg, reg_start, reg_end;
-	u8 *dbg_ptr, *end_ptr, *tmp_ptr, fw_dump_num, dump_num;
-	u8 idx, i, read_reg, doneflag = 0;
-	enum rdwr_status stat;
-	u32 memory_size;
-	int ret;
-
-	if (!card->pcie.can_dump_fw)
-		return;
-
-	for (idx = 0; idx < adapter->num_mem_types; idx++) {
-		struct memory_type_mapping *entry =
-				&adapter->mem_type_mapping_tbl[idx];
-
-		if (entry->mem_ptr) {
-			vfree(entry->mem_ptr);
-			entry->mem_ptr = NULL;
-		}
-		entry->mem_size = 0;
-	}
-
-	mwifiex_dbg(adapter, MSG, "== mwifiex firmware dump start ==\n");
-
-	/* Read the number of the memories which will dump */
-	stat = mwifiex_pcie_rdwr_firmware(adapter, doneflag);
-	if (stat == RDWR_STATUS_FAILURE)
-		return;
-
-	reg = creg->fw_dump_start;
-	mwifiex_read_reg_byte(adapter, reg, &fw_dump_num);
-
-	/* W8997 chipset firmware dump will be restore in single region*/
-	if (fw_dump_num == 0)
-		dump_num = 1;
-	else
-		dump_num = fw_dump_num;
-
-	/* Read the length of every memory which will dump */
-	for (idx = 0; idx < dump_num; idx++) {
-		struct memory_type_mapping *entry =
-				&adapter->mem_type_mapping_tbl[idx];
-		memory_size = 0;
-		if (fw_dump_num != 0) {
-			stat = mwifiex_pcie_rdwr_firmware(adapter, doneflag);
-			if (stat == RDWR_STATUS_FAILURE)
-				return;
-
-			reg = creg->fw_dump_start;
-			for (i = 0; i < 4; i++) {
-				mwifiex_read_reg_byte(adapter, reg, &read_reg);
-				memory_size |= (read_reg << (i * 8));
-				reg++;
-			}
-		} else {
-			memory_size = MWIFIEX_FW_DUMP_MAX_MEMSIZE;
-		}
-
-		if (memory_size == 0) {
-			mwifiex_dbg(adapter, MSG, "Firmware dump Finished!\n");
-			ret = mwifiex_write_reg(adapter, creg->fw_dump_ctrl,
-						creg->fw_dump_read_done);
-			if (ret) {
-				mwifiex_dbg(adapter, ERROR, "PCIE write err\n");
-				return;
-			}
-			break;
-		}
-
-		mwifiex_dbg(adapter, DUMP,
-			    "%s_SIZE=0x%x\n", entry->mem_name, memory_size);
-		entry->mem_ptr = vmalloc(memory_size + 1);
-		entry->mem_size = memory_size;
-		if (!entry->mem_ptr) {
-			mwifiex_dbg(adapter, ERROR,
-				    "Vmalloc %s failed\n", entry->mem_name);
-			return;
-		}
-		dbg_ptr = entry->mem_ptr;
-		end_ptr = dbg_ptr + memory_size;
-
-		doneflag = entry->done_flag;
-		mwifiex_dbg(adapter, DUMP, "Start %s output, please wait...\n",
-			    entry->mem_name);
-
-		do {
-			stat = mwifiex_pcie_rdwr_firmware(adapter, doneflag);
-			if (RDWR_STATUS_FAILURE == stat)
-				return;
-
-			reg_start = creg->fw_dump_start;
-			reg_end = creg->fw_dump_end;
-			for (reg = reg_start; reg <= reg_end; reg++) {
-				mwifiex_read_reg_byte(adapter, reg, dbg_ptr);
-				if (dbg_ptr < end_ptr) {
-					dbg_ptr++;
-					continue;
-				}
-				mwifiex_dbg(adapter, ERROR,
-					    "pre-allocated buf not enough\n");
-				tmp_ptr =
-					vzalloc(memory_size + MWIFIEX_SIZE_4K);
-				if (!tmp_ptr)
-					return;
-				memcpy(tmp_ptr, entry->mem_ptr, memory_size);
-				vfree(entry->mem_ptr);
-				entry->mem_ptr = tmp_ptr;
-				tmp_ptr = NULL;
-				dbg_ptr = entry->mem_ptr + memory_size;
-				memory_size += MWIFIEX_SIZE_4K;
-				end_ptr = entry->mem_ptr + memory_size;
-			}
-
-			if (stat != RDWR_STATUS_DONE)
-				continue;
-
-			mwifiex_dbg(adapter, DUMP,
-				    "%s done: size=0x%tx\n",
-				    entry->mem_name, dbg_ptr - entry->mem_ptr);
-			break;
-		} while (true);
-	}
-	mwifiex_dbg(adapter, MSG, "== mwifiex firmware dump end ==\n");
-}
-
-static void mwifiex_pcie_device_dump_work(struct mwifiex_adapter *adapter)
-{
-	mwifiex_drv_info_dump(adapter);
-	mwifiex_pcie_fw_dump(adapter);
-	mwifiex_upload_device_dump(adapter);
-}
-
-static unsigned long iface_work_flags;
-static struct mwifiex_adapter *save_adapter;
-static void mwifiex_pcie_work(struct work_struct *work)
-{
-	if (test_and_clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP,
-			       &iface_work_flags))
-		mwifiex_pcie_device_dump_work(save_adapter);
-}
-
-static DECLARE_WORK(pcie_work, mwifiex_pcie_work);
-/* This function dumps FW information */
-static void mwifiex_pcie_device_dump(struct mwifiex_adapter *adapter)
-{
-	save_adapter = adapter;
-	if (test_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &iface_work_flags))
-		return;
-
-	set_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &iface_work_flags);
-
-	schedule_work(&pcie_work);
-}
-
 /*
  * This function initializes the PCI-E host memory space, WCB rings, etc.
  *
-- 
1.9.1
