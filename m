Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:2407 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754910AbbEZNf0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 09:35:26 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t4QDYpH9003451
	for <linux-wireless@vger.kernel.org>; Tue, 26 May 2015 06:35:25 -0700
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0b-0016f401.pphosted.com with ESMTP id 1umqg00bpw-3
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 26 May 2015 06:35:24 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>, Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 5/6] mwifiex: use generic name 'device dump'
Date: Tue, 26 May 2015 06:34:31 -0700
Message-ID: <1432647272-5734-6-git-send-email-akarwar@marvell.com> (sfid-20150526_153538_730660_141E53A3)
In-Reply-To: <1432647272-5734-1-git-send-email-akarwar@marvell.com>
References: <1432647272-5734-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently we are dumping driver information also inside
firmware dump API. We will call it as device dump and
dump driver and firmware data separately.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/README    |  6 +++---
 drivers/net/wireless/mwifiex/cmdevt.c  |  4 ++--
 drivers/net/wireless/mwifiex/debugfs.c | 20 ++++++++++----------
 drivers/net/wireless/mwifiex/ethtool.c | 12 ++++++------
 drivers/net/wireless/mwifiex/main.c    |  4 ++--
 drivers/net/wireless/mwifiex/main.h    |  6 +++---
 drivers/net/wireless/mwifiex/pcie.c    | 22 +++++++++++++---------
 drivers/net/wireless/mwifiex/sdio.c    | 22 +++++++++++++---------
 8 files changed, 52 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/README b/drivers/net/wireless/mwifiex/README
index 31928ca..2f0f9b5 100644
--- a/drivers/net/wireless/mwifiex/README
+++ b/drivers/net/wireless/mwifiex/README
@@ -230,9 +230,9 @@ getlog
 
 	cat getlog
 
-fw_dump
-	This command is used to dump firmware memory into files.
-	Separate file will be created for each memory segment.
+device_dump
+	This command is used to dump driver information and firmware memory
+	segments.
 	Usage:
 
 	cat fw_dump
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index ac89a1d..a1de83f 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -993,8 +993,8 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_INITIALIZING)
 		mwifiex_init_fw_complete(adapter);
 
-	if (adapter->if_ops.fw_dump)
-		adapter->if_ops.fw_dump(adapter);
+	if (adapter->if_ops.device_dump)
+		adapter->if_ops.device_dump(adapter);
 
 	if (adapter->if_ops.card_reset)
 		adapter->if_ops.card_reset(adapter);
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 8895906..5a0636d4 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -152,24 +152,24 @@ free_and_exit:
 }
 
 /*
- * Proc firmware dump read handler.
+ * Proc device dump read handler.
  *
- * This function is called when the 'fw_dump' file is opened for
+ * This function is called when the 'device_dump' file is opened for
  * reading.
- * This function dumps firmware memory in different files
- * (ex. DTCM, ITCM, SQRAM etc.) based on the the segments for
+ * This function dumps driver information and firmware memory segments
+ * (ex. DTCM, ITCM, SQRAM etc.) for
  * debugging.
  */
 static ssize_t
-mwifiex_fw_dump_read(struct file *file, char __user *ubuf,
-		     size_t count, loff_t *ppos)
+mwifiex_device_dump_read(struct file *file, char __user *ubuf,
+			 size_t count, loff_t *ppos)
 {
 	struct mwifiex_private *priv = file->private_data;
 
-	if (!priv->adapter->if_ops.fw_dump)
+	if (!priv->adapter->if_ops.device_dump)
 		return -EIO;
 
-	priv->adapter->if_ops.fw_dump(priv->adapter);
+	priv->adapter->if_ops.device_dump(priv->adapter);
 
 	return 0;
 }
@@ -885,7 +885,7 @@ static const struct file_operations mwifiex_dfs_##name##_fops = {       \
 MWIFIEX_DFS_FILE_READ_OPS(info);
 MWIFIEX_DFS_FILE_READ_OPS(debug);
 MWIFIEX_DFS_FILE_READ_OPS(getlog);
-MWIFIEX_DFS_FILE_READ_OPS(fw_dump);
+MWIFIEX_DFS_FILE_READ_OPS(device_dump);
 MWIFIEX_DFS_FILE_OPS(regrdwr);
 MWIFIEX_DFS_FILE_OPS(rdeeprom);
 MWIFIEX_DFS_FILE_OPS(memrw);
@@ -913,7 +913,7 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 	MWIFIEX_DFS_ADD_FILE(getlog);
 	MWIFIEX_DFS_ADD_FILE(regrdwr);
 	MWIFIEX_DFS_ADD_FILE(rdeeprom);
-	MWIFIEX_DFS_ADD_FILE(fw_dump);
+	MWIFIEX_DFS_ADD_FILE(device_dump);
 	MWIFIEX_DFS_ADD_FILE(memrw);
 	MWIFIEX_DFS_ADD_FILE(hscfg);
 	MWIFIEX_DFS_ADD_FILE(histogram);
diff --git a/drivers/net/wireless/mwifiex/ethtool.c b/drivers/net/wireless/mwifiex/ethtool.c
index a6b3b41..c78bf0a 100644
--- a/drivers/net/wireless/mwifiex/ethtool.c
+++ b/drivers/net/wireless/mwifiex/ethtool.c
@@ -71,7 +71,7 @@ mwifiex_get_dump_flag(struct net_device *dev, struct ethtool_dump *dump)
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct memory_type_mapping *entry;
 
-	if (!adapter->if_ops.fw_dump)
+	if (!adapter->if_ops.device_dump)
 		return -ENOTSUPP;
 
 	dump->flag = adapter->curr_mem_idx;
@@ -97,7 +97,7 @@ mwifiex_get_dump_data(struct net_device *dev, struct ethtool_dump *dump,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct memory_type_mapping *entry;
 
-	if (!adapter->if_ops.fw_dump)
+	if (!adapter->if_ops.device_dump)
 		return -ENOTSUPP;
 
 	if (adapter->curr_mem_idx == MWIFIEX_DRV_INFO_IDX) {
@@ -109,7 +109,7 @@ mwifiex_get_dump_data(struct net_device *dev, struct ethtool_dump *dump,
 
 	if (adapter->curr_mem_idx == MWIFIEX_FW_DUMP_IDX) {
 		mwifiex_dbg(adapter, ERROR,
-			    "firmware dump in progress!!\n");
+			    "device dump in progress!!\n");
 		return -EBUSY;
 	}
 
@@ -132,7 +132,7 @@ static int mwifiex_set_dump(struct net_device *dev, struct ethtool_dump *val)
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	struct mwifiex_adapter *adapter = priv->adapter;
 
-	if (!adapter->if_ops.fw_dump)
+	if (!adapter->if_ops.device_dump)
 		return -ENOTSUPP;
 
 	if (val->flag == MWIFIEX_DRV_INFO_IDX) {
@@ -142,13 +142,13 @@ static int mwifiex_set_dump(struct net_device *dev, struct ethtool_dump *val)
 
 	if (adapter->curr_mem_idx == MWIFIEX_FW_DUMP_IDX) {
 		mwifiex_dbg(adapter, ERROR,
-			    "firmware dump in progress!!\n");
+			    "device dump in progress!!\n");
 		return -EBUSY;
 	}
 
 	if (val->flag == MWIFIEX_FW_DUMP_IDX) {
 		adapter->curr_mem_idx = val->flag;
-		adapter->if_ops.fw_dump(adapter);
+		adapter->if_ops.device_dump(adapter);
 		return 0;
 	}
 
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 3e7774f..b7fbc2c 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -873,7 +873,7 @@ mwifiex_tx_timeout(struct net_device *dev)
 	}
 }
 
-void mwifiex_dump_drv_info(struct mwifiex_adapter *adapter)
+void mwifiex_drv_info_dump(struct mwifiex_adapter *adapter)
 {
 	void *p;
 	char drv_version[64];
@@ -980,7 +980,7 @@ void mwifiex_dump_drv_info(struct mwifiex_adapter *adapter)
 	adapter->drv_info_size = p - adapter->drv_info_dump;
 	mwifiex_dbg(adapter, MSG, "===mwifiex driverinfo dump end===\n");
 }
-EXPORT_SYMBOL_GPL(mwifiex_dump_drv_info);
+EXPORT_SYMBOL_GPL(mwifiex_drv_info_dump);
 
 /*
  * CFG802.11 network device handler for statistics retrieval.
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 2f55161..01111fe 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -499,7 +499,7 @@ enum rdwr_status {
 };
 
 enum mwifiex_iface_work_flags {
-	MWIFIEX_IFACE_WORK_FW_DUMP,
+	MWIFIEX_IFACE_WORK_DEVICE_DUMP,
 	MWIFIEX_IFACE_WORK_CARD_RESET,
 };
 
@@ -789,8 +789,8 @@ struct mwifiex_if_ops {
 	int (*init_fw_port) (struct mwifiex_adapter *);
 	int (*dnld_fw) (struct mwifiex_adapter *, struct mwifiex_fw_image *);
 	void (*card_reset) (struct mwifiex_adapter *);
-	void (*fw_dump)(struct mwifiex_adapter *);
 	int (*reg_dump)(struct mwifiex_adapter *, char *);
+	void (*device_dump)(struct mwifiex_adapter *);
 	int (*clean_pcie_ring) (struct mwifiex_adapter *adapter);
 	void (*iface_work)(struct work_struct *work);
 	void (*submit_rem_rx_urbs)(struct mwifiex_adapter *adapter);
@@ -1484,7 +1484,7 @@ void mwifiex_hist_data_add(struct mwifiex_private *priv,
 u8 mwifiex_adjust_data_rate(struct mwifiex_private *priv,
 			    u8 rx_rate, u8 ht_info);
 
-void mwifiex_dump_drv_info(struct mwifiex_adapter *adapter);
+void mwifiex_drv_info_dump(struct mwifiex_adapter *adapter);
 void *mwifiex_alloc_dma_align_buf(int rx_len, gfp_t flags);
 void mwifiex_queue_main_work(struct mwifiex_adapter *adapter);
 
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 86ed396..3a99368 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -2305,7 +2305,7 @@ mwifiex_pcie_rdwr_firmware(struct mwifiex_adapter *adapter, u8 doneflag)
 }
 
 /* This function dump firmware memory to file */
-static void mwifiex_pcie_fw_dump_work(struct mwifiex_adapter *adapter)
+static void mwifiex_pcie_fw_dump(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *creg = card->pcie.reg;
@@ -2316,8 +2316,6 @@ static void mwifiex_pcie_fw_dump_work(struct mwifiex_adapter *adapter)
 	int ret;
 	static char *env[] = { "DRIVER=mwifiex_pcie", "EVENT=fw_dump", NULL };
 
-	mwifiex_dump_drv_info(adapter);
-
 	if (!card->pcie.can_dump_fw)
 		return;
 
@@ -2419,24 +2417,30 @@ done:
 	adapter->curr_mem_idx = 0;
 }
 
+static void mwifiex_pcie_device_dump_work(struct mwifiex_adapter *adapter)
+{
+	mwifiex_drv_info_dump(adapter);
+	mwifiex_pcie_fw_dump(adapter);
+}
+
 static unsigned long iface_work_flags;
 static struct mwifiex_adapter *save_adapter;
 static void mwifiex_pcie_work(struct work_struct *work)
 {
-	if (test_and_clear_bit(MWIFIEX_IFACE_WORK_FW_DUMP,
+	if (test_and_clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP,
 			       &iface_work_flags))
-		mwifiex_pcie_fw_dump_work(save_adapter);
+		mwifiex_pcie_device_dump_work(save_adapter);
 }
 
 static DECLARE_WORK(pcie_work, mwifiex_pcie_work);
 /* This function dumps FW information */
-static void mwifiex_pcie_fw_dump(struct mwifiex_adapter *adapter)
+static void mwifiex_pcie_device_dump(struct mwifiex_adapter *adapter)
 {
 	save_adapter = adapter;
-	if (test_bit(MWIFIEX_IFACE_WORK_FW_DUMP, &iface_work_flags))
+	if (test_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &iface_work_flags))
 		return;
 
-	set_bit(MWIFIEX_IFACE_WORK_FW_DUMP, &iface_work_flags);
+	set_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &iface_work_flags);
 
 	schedule_work(&pcie_work);
 }
@@ -2673,7 +2677,7 @@ static struct mwifiex_if_ops pcie_ops = {
 	.cleanup_mpa_buf =		NULL,
 	.init_fw_port =			mwifiex_pcie_init_fw_port,
 	.clean_pcie_ring =		mwifiex_clean_pcie_ring_buf,
-	.fw_dump =			mwifiex_pcie_fw_dump,
+	.device_dump =			mwifiex_pcie_device_dump,
 };
 
 /*
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 467ee9a..1f32c02 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -2177,7 +2177,7 @@ rdwr_status mwifiex_sdio_rdwr_firmware(struct mwifiex_adapter *adapter,
 }
 
 /* This function dump firmware memory to file */
-static void mwifiex_sdio_fw_dump_work(struct mwifiex_adapter *adapter)
+static void mwifiex_sdio_fw_dump(struct mwifiex_adapter *adapter)
 {
 	struct sdio_mmc_card *card = adapter->card;
 	int ret = 0;
@@ -2187,8 +2187,6 @@ static void mwifiex_sdio_fw_dump_work(struct mwifiex_adapter *adapter)
 	u32 memory_size;
 	static char *env[] = { "DRIVER=mwifiex_sdio", "EVENT=fw_dump", NULL };
 
-	mwifiex_dump_drv_info(adapter);
-
 	if (!card->can_dump_fw)
 		return;
 
@@ -2306,11 +2304,17 @@ done:
 	adapter->curr_mem_idx = 0;
 }
 
+static void mwifiex_sdio_device_dump_work(struct mwifiex_adapter *adapter)
+{
+	mwifiex_drv_info_dump(adapter);
+	mwifiex_sdio_fw_dump(adapter);
+}
+
 static void mwifiex_sdio_work(struct work_struct *work)
 {
-	if (test_and_clear_bit(MWIFIEX_IFACE_WORK_FW_DUMP,
+	if (test_and_clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP,
 			       &iface_work_flags))
-		mwifiex_sdio_fw_dump_work(save_adapter);
+		mwifiex_sdio_device_dump_work(save_adapter);
 	if (test_and_clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET,
 			       &iface_work_flags))
 		mwifiex_sdio_card_reset_work(save_adapter);
@@ -2330,13 +2334,13 @@ static void mwifiex_sdio_card_reset(struct mwifiex_adapter *adapter)
 }
 
 /* This function dumps FW information */
-static void mwifiex_sdio_fw_dump(struct mwifiex_adapter *adapter)
+static void mwifiex_sdio_device_dump(struct mwifiex_adapter *adapter)
 {
 	save_adapter = adapter;
-	if (test_bit(MWIFIEX_IFACE_WORK_FW_DUMP, &iface_work_flags))
+	if (test_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &iface_work_flags))
 		return;
 
-	set_bit(MWIFIEX_IFACE_WORK_FW_DUMP, &iface_work_flags);
+	set_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &iface_work_flags);
 	schedule_work(&sdio_work);
 }
 
@@ -2453,8 +2457,8 @@ static struct mwifiex_if_ops sdio_ops = {
 	.cmdrsp_complete = mwifiex_sdio_cmdrsp_complete,
 	.event_complete = mwifiex_sdio_event_complete,
 	.card_reset = mwifiex_sdio_card_reset,
-	.fw_dump = mwifiex_sdio_fw_dump,
 	.reg_dump = mwifiex_sdio_reg_dump,
+	.device_dump = mwifiex_sdio_device_dump,
 	.deaggr_pkt = mwifiex_deaggr_sdio_pkt,
 };
 
-- 
1.8.1.4

