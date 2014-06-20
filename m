Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:63729 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933794AbaFTEjX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2014 00:39:23 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Xinming Hu <huxm@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/7] mwifiex: add firmware dump feature for PCIe
Date: Thu, 19 Jun 2014 21:38:52 -0700
Message-ID: <1403239138-3113-1-git-send-email-bzhao@marvell.com> (sfid-20140620_063927_645128_C308D75B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Firmware dump feature is added for PCIe based chipsets which can
be used with the help of ethtool commands.

1) Trigger firmware dump operation:
ethtool --set-dump mlan0 0xff

When the operation is completed, udev event will be sent to
trigger external application.

2) Following udev rule can be used to get the data from ethtool:
DRIVER=="mwifiex_pcie", ACTION=="change", RUN+="/sbin/mwifiex_pcie_fw_dump.sh"

mwifiex_pcie_fw_dump.sh: #!/bin/bash
ethtool --set-dump mlan0 0
ethtool --get-dump mlan0
ethtool --get-dump mlan0 data /tmp/ITCM.log

ethtool --set-dump mlan0 1
ethtool --get-dump mlan0
ethtool --get-dump mlan0 data /tmp/DTCM.log

ethtool --set-dump mlan0 2
ethtool --get-dump mlan0
ethtool --get-dump mlan0 data /tmp/SQRAM.log

ethtool --set-dump mlan0 3
ethtool --get-dump mlan0
ethtool --get-dump mlan0 data /tmp/IRAM.log

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c  |   3 +
 drivers/net/wireless/mwifiex/ethtool.c |  83 ++++++++++++++
 drivers/net/wireless/mwifiex/init.c    |  13 ++-
 drivers/net/wireless/mwifiex/main.c    |   2 +
 drivers/net/wireless/mwifiex/main.h    |  29 +++++
 drivers/net/wireless/mwifiex/pcie.c    | 193 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/pcie.h    |  10 ++
 7 files changed, 332 insertions(+), 1 deletion(-)

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
diff --git a/drivers/net/wireless/mwifiex/ethtool.c b/drivers/net/wireless/mwifiex/ethtool.c
index bfb3990..528bdfa 100644
--- a/drivers/net/wireless/mwifiex/ethtool.c
+++ b/drivers/net/wireless/mwifiex/ethtool.c
@@ -64,7 +64,90 @@ static int mwifiex_ethtool_set_wol(struct net_device *dev,
 	return 0;
 }
 
+static int
+mwifiex_get_dump_flag(struct net_device *dev, struct ethtool_dump *dump)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct memory_type_mapping *entry;
+
+	if (!adapter->if_ops.fw_dump)
+		return -ENOTSUPP;
+
+	dump->flag = adapter->curr_mem_idx;
+	dump->version = 1;
+	if (adapter->curr_mem_idx != MWIFIEX_FW_DUMP_IDX) {
+		entry = &adapter->mem_type_mapping_tbl[adapter->curr_mem_idx];
+		dump->len = entry->mem_size;
+	} else {
+		dump->len = 0;
+	}
+
+	return 0;
+}
+
+static int
+mwifiex_get_dump_data(struct net_device *dev, struct ethtool_dump *dump,
+		      void *buffer)
+{
+	u8 *p = buffer;
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct memory_type_mapping *entry;
+
+	if (!adapter->if_ops.fw_dump)
+		return -ENOTSUPP;
+
+	if (adapter->curr_mem_idx == MWIFIEX_FW_DUMP_IDX) {
+		dev_err(adapter->dev, "firmware dump in progress!!\n");
+		return -EBUSY;
+	}
+
+	entry = &adapter->mem_type_mapping_tbl[adapter->curr_mem_idx];
+
+	if (!entry->mem_ptr)
+		return -EFAULT;
+
+	memcpy(p, entry->mem_ptr, entry->mem_size);
+
+	entry->mem_size = 0;
+	vfree(entry->mem_ptr);
+	entry->mem_ptr = NULL;
+
+	return 0;
+}
+
+static int mwifiex_set_dump(struct net_device *dev, struct ethtool_dump *val)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	struct mwifiex_adapter *adapter = priv->adapter;
+
+	if (!adapter->if_ops.fw_dump)
+		return -ENOTSUPP;
+
+	if (adapter->curr_mem_idx == MWIFIEX_FW_DUMP_IDX) {
+		dev_err(adapter->dev, "firmware dump in progress!!\n");
+		return -EBUSY;
+	}
+
+	if (val->flag == MWIFIEX_FW_DUMP_IDX) {
+		adapter->curr_mem_idx = val->flag;
+		adapter->if_ops.fw_dump(adapter);
+		return 0;
+	}
+
+	if (val->flag < 0 || val->flag >= adapter->num_mem_types)
+		return -EINVAL;
+
+	adapter->curr_mem_idx = val->flag;
+
+	return 0;
+}
+
 const struct ethtool_ops mwifiex_ethtool_ops = {
 	.get_wol = mwifiex_ethtool_get_wol,
 	.set_wol = mwifiex_ethtool_set_wol,
+	.get_dump_flag = mwifiex_get_dump_flag,
+	.get_dump_data = mwifiex_get_dump_data,
+	.set_dump = mwifiex_set_dump,
 };
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 4ecd0b2..2b68cf3 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -382,6 +382,8 @@ static void mwifiex_free_lock_list(struct mwifiex_adapter *adapter)
 static void
 mwifiex_adapter_cleanup(struct mwifiex_adapter *adapter)
 {
+	int idx;
+
 	if (!adapter) {
 		pr_err("%s: adapter is NULL\n", __func__);
 		return;
@@ -396,7 +398,16 @@ mwifiex_adapter_cleanup(struct mwifiex_adapter *adapter)
 	dev_dbg(adapter->dev, "info: free cmd buffer\n");
 	mwifiex_free_cmd_buffer(adapter);
 
-	dev_dbg(adapter->dev, "info: free scan table\n");
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
 
 	if (adapter->sleep_cfm)
 		dev_kfree_skb_any(adapter->sleep_cfm);
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
index 1398afa..24791e2 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -30,6 +30,7 @@
 #include <linux/etherdevice.h>
 #include <net/sock.h>
 #include <net/lib80211.h>
+#include <linux/vmalloc.h>
 #include <linux/firmware.h>
 #include <linux/ctype.h>
 #include <linux/of.h>
@@ -410,6 +411,28 @@ struct mwifiex_roc_cfg {
 	struct ieee80211_channel chan;
 };
 
+#define MWIFIEX_FW_DUMP_IDX		0xff
+#define FW_DUMP_MAX_NAME_LEN		8
+#define FW_DUMP_HOST_READY		0xEE
+#define FW_DUMP_DONE			0xFF
+
+struct memory_type_mapping {
+	u8 mem_name[FW_DUMP_MAX_NAME_LEN];
+	u8 *mem_ptr;
+	u32 mem_size;
+	u8 done_flag;
+};
+
+enum rdwr_status {
+	RDWR_STATUS_SUCCESS = 0,
+	RDWR_STATUS_FAILURE = 1,
+	RDWR_STATUS_DONE = 2
+};
+
+enum mwifiex_iface_work_flags {
+	MWIFIEX_IFACE_WORK_FW_DUMP,
+};
+
 struct mwifiex_adapter;
 struct mwifiex_private;
 
@@ -674,6 +697,7 @@ struct mwifiex_if_ops {
 	void (*card_reset) (struct mwifiex_adapter *);
 	void (*fw_dump)(struct mwifiex_adapter *);
 	int (*clean_pcie_ring) (struct mwifiex_adapter *adapter);
+	void (*iface_work)(struct work_struct *work);
 };
 
 struct mwifiex_adapter {
@@ -809,6 +833,11 @@ struct mwifiex_adapter {
 	bool ext_scan;
 	u8 fw_api_ver;
 	u8 fw_key_api_major_ver, fw_key_api_minor_ver;
+	struct work_struct iface_work;
+	unsigned long iface_work_flags;
+	struct memory_type_mapping *mem_type_mapping_tbl;
+	u8 num_mem_types;
+	u8 curr_mem_idx;
 };
 
 int mwifiex_init_lock_list(struct mwifiex_adapter *adapter);
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 2cc9b6f..bf948fb 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -37,6 +37,13 @@ static struct mwifiex_if_ops pcie_ops;
 
 static struct semaphore add_remove_card_sem;
 
+static struct memory_type_mapping mem_type_mapping_tbl[] = {
+	{"ITCM", NULL, 0, 0xF0},
+	{"DTCM", NULL, 0, 0xF1},
+	{"SQRAM", NULL, 0, 0xF2},
+	{"IRAM", NULL, 0, 0xF3},
+};
+
 static int
 mwifiex_map_pci_memory(struct mwifiex_adapter *adapter, struct sk_buff *skb,
 		       size_t size, int flags)
@@ -192,6 +199,7 @@ static int mwifiex_pcie_probe(struct pci_dev *pdev,
 		card->pcie.reg = data->reg;
 		card->pcie.blksz_fw_dl = data->blksz_fw_dl;
 		card->pcie.tx_buf_size = data->tx_buf_size;
+		card->pcie.supports_fw_dump = data->supports_fw_dump;
 	}
 
 	if (mwifiex_add_card(card, &add_remove_card_sem, &pcie_ops,
@@ -221,6 +229,8 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 	if (!adapter || !adapter->priv_num)
 		return;
 
+	cancel_work_sync(&adapter->iface_work);
+
 	if (user_rmmod) {
 #ifdef CONFIG_PM_SLEEP
 		if (adapter->is_suspended)
@@ -307,6 +317,17 @@ static int mwifiex_read_reg(struct mwifiex_adapter *adapter, int reg, u32 *data)
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
@@ -2173,6 +2194,174 @@ static int mwifiex_pcie_host_to_card(struct mwifiex_adapter *adapter, u8 type,
 	return 0;
 }
 
+/* This function read/write firmware */
+static enum rdwr_status
+mwifiex_pcie_rdwr_firmware(struct mwifiex_adapter *adapter, u8 doneflag)
+{
+	int ret, tries;
+	u8 ctrl_data;
+	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
+
+	ret = mwifiex_write_reg(adapter, reg->fw_dump_ctrl, FW_DUMP_HOST_READY);
+	if (ret) {
+		dev_err(adapter->dev, "PCIE write err\n");
+		return RDWR_STATUS_FAILURE;
+	}
+
+	for (tries = 0; tries < MAX_POLL_TRIES; tries++) {
+		mwifiex_read_reg_byte(adapter, reg->fw_dump_ctrl, &ctrl_data);
+		if (ctrl_data == FW_DUMP_DONE)
+			return RDWR_STATUS_SUCCESS;
+		if (doneflag && ctrl_data == doneflag)
+			return RDWR_STATUS_DONE;
+		if (ctrl_data != FW_DUMP_HOST_READY) {
+			dev_info(adapter->dev,
+				 "The ctrl reg was changed, re-try again!\n");
+			mwifiex_write_reg(adapter, reg->fw_dump_ctrl,
+					  FW_DUMP_HOST_READY);
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
+static void mwifiex_pcie_fw_dump_work(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *creg = card->pcie.reg;
+	unsigned int reg, reg_start, reg_end;
+	struct timeval t;
+	u8 *dbg_ptr, *end_ptr, dump_num, idx, i, read_reg, doneflag = 0;
+	enum rdwr_status stat;
+	u32 memory_size;
+	static char *env[] = { "DRIVER=mwifiex_pcie", "EVENT=fw_dump", NULL };
+
+	if (!card->pcie.supports_fw_dump)
+		return;
+
+	for (idx = 0; idx < ARRAY_SIZE(mem_type_mapping_tbl); idx++) {
+		struct memory_type_mapping *entry = &mem_type_mapping_tbl[idx];
+
+		if (entry->mem_ptr) {
+			vfree(entry->mem_ptr);
+			entry->mem_ptr = NULL;
+		}
+		entry->mem_size = 0;
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
+	reg = creg->fw_dump_start;
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
+		reg = creg->fw_dump_start;
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
+		entry->mem_size = memory_size;
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
+			reg_start = creg->fw_dump_start;
+			reg_end = creg->fw_dump_end;
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
+			dev_info(adapter->dev, "%s done: size=0x%tx\n",
+				 entry->mem_name, dbg_ptr - entry->mem_ptr);
+			break;
+		} while (true);
+	}
+	do_gettimeofday(&t);
+	dev_info(adapter->dev, "== mwifiex firmware dump end: %u.%06u ==\n",
+		 (u32)t.tv_sec, (u32)t.tv_usec);
+
+	kobject_uevent_env(&adapter->wiphy->dev.kobj, KOBJ_CHANGE, env);
+
+done:
+	adapter->curr_mem_idx = 0;
+}
+
+static void mwifiex_pcie_work(struct work_struct *work)
+{
+	struct mwifiex_adapter *adapter =
+			container_of(work, struct mwifiex_adapter, iface_work);
+
+	if (test_and_clear_bit(MWIFIEX_IFACE_WORK_FW_DUMP,
+			       &adapter->iface_work_flags))
+		mwifiex_pcie_fw_dump_work(adapter);
+}
+
+/* This function dumps FW information */
+static void mwifiex_pcie_fw_dump(struct mwifiex_adapter *adapter)
+{
+	if (test_bit(MWIFIEX_IFACE_WORK_FW_DUMP, &adapter->iface_work_flags))
+		return;
+
+	set_bit(MWIFIEX_IFACE_WORK_FW_DUMP, &adapter->iface_work_flags);
+
+	schedule_work(&adapter->iface_work);
+}
+
 /*
  * This function initializes the PCI-E host memory space, WCB rings, etc.
  *
@@ -2342,6 +2531,8 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 
 	adapter->dev = &pdev->dev;
 	adapter->tx_buf_size = card->pcie.tx_buf_size;
+	adapter->mem_type_mapping_tbl = mem_type_mapping_tbl;
+	adapter->num_mem_types = ARRAY_SIZE(mem_type_mapping_tbl);
 	strcpy(adapter->fw_name, card->pcie.firmware);
 
 	return 0;
@@ -2394,6 +2585,8 @@ static struct mwifiex_if_ops pcie_ops = {
 	.cleanup_mpa_buf =		NULL,
 	.init_fw_port =			mwifiex_pcie_init_fw_port,
 	.clean_pcie_ring =		mwifiex_clean_pcie_ring_buf,
+	.fw_dump =			mwifiex_pcie_fw_dump,
+	.iface_work =			mwifiex_pcie_work,
 };
 
 /*
diff --git a/drivers/net/wireless/mwifiex/pcie.h b/drivers/net/wireless/mwifiex/pcie.h
index e8ec561..ee073f5 100644
--- a/drivers/net/wireless/mwifiex/pcie.h
+++ b/drivers/net/wireless/mwifiex/pcie.h
@@ -129,6 +129,9 @@ struct mwifiex_pcie_card_reg {
 	u32 ring_tx_start_ptr;
 	u8 pfu_enabled;
 	u8 sleep_cookie;
+	u16 fw_dump_ctrl;
+	u16 fw_dump_start;
+	u16 fw_dump_end;
 };
 
 static const struct mwifiex_pcie_card_reg mwifiex_reg_8766 = {
@@ -191,6 +194,9 @@ static const struct mwifiex_pcie_card_reg mwifiex_reg_8897 = {
 	.ring_tx_start_ptr = MWIFIEX_BD_FLAG_TX_START_PTR,
 	.pfu_enabled = 1,
 	.sleep_cookie = 0,
+	.fw_dump_ctrl = 0xcf4,
+	.fw_dump_start = 0xcf8,
+	.fw_dump_end = 0xcff
 };
 
 struct mwifiex_pcie_device {
@@ -198,6 +204,7 @@ struct mwifiex_pcie_device {
 	const struct mwifiex_pcie_card_reg *reg;
 	u16 blksz_fw_dl;
 	u16 tx_buf_size;
+	bool supports_fw_dump;
 };
 
 static const struct mwifiex_pcie_device mwifiex_pcie8766 = {
@@ -205,6 +212,7 @@ static const struct mwifiex_pcie_device mwifiex_pcie8766 = {
 	.reg            = &mwifiex_reg_8766,
 	.blksz_fw_dl = MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD,
 	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
+	.supports_fw_dump = false,
 };
 
 static const struct mwifiex_pcie_device mwifiex_pcie8897 = {
@@ -212,6 +220,7 @@ static const struct mwifiex_pcie_device mwifiex_pcie8897 = {
 	.reg            = &mwifiex_reg_8897,
 	.blksz_fw_dl = MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD,
 	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
+	.supports_fw_dump = true,
 };
 
 struct mwifiex_evt_buf_desc {
@@ -322,4 +331,5 @@ mwifiex_pcie_txbd_not_full(struct pcie_service_card *card)
 
 	return 0;
 }
+
 #endif /* _MWIFIEX_PCIE_H */
-- 
1.8.2.3

