Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:51760 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933794AbaFTEjZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2014 00:39:25 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Xinming Hu <huxm@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/7] mwifiex: add firmware dump feature for SDIO
Date: Thu, 19 Jun 2014 21:38:55 -0700
Message-ID: <1403239138-3113-4-git-send-email-bzhao@marvell.com> (sfid-20140620_063929_436902_F5ED1000)
In-Reply-To: <1403239138-3113-1-git-send-email-bzhao@marvell.com>
References: <1403239138-3113-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Firmware dump feature is added for SDIO based chipsets
which can be used with the help of ethtool commands.

1) Trigger firmware dump operation:
ethtool --set-dump mlan0 0xff

When the operation is completed, udev event will be sent to
trigger external application.

2) Following udev rule can be used to get the data from ethtool:
DRIVER=="mwifiex_sdio", ACTION=="change", RUN+="/sbin/mwifiex_sdio_fw_dump.sh"

mwifiex_sdio_fw_dump.sh: #!/bin/bash
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
ethtool --get-dump mlan0 data /tmp/APU.log

ethtool --set-dump mlan0 4
ethtool --get-dump mlan0
ethtool --get-dump mlan0 data /tmp/CIU.log

ethtool --set-dump mlan0 5
ethtool --get-dump mlan0
ethtool --get-dump mlan0 data /tmp/ICU.log

ethtool --set-dump mlan0 6
ethtool --get-dump mlan0
ethtool --get-dump mlan0 data /tmp/MAC.log

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 209 ++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/sdio.h |  12 +++
 2 files changed, 221 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index b34270d..95a1d1f 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -50,6 +50,24 @@ static struct mwifiex_if_ops sdio_ops;
 
 static struct semaphore add_remove_card_sem;
 
+static struct memory_type_mapping mem_type_mapping_tbl[] = {
+	{"ITCM", NULL, 0, 0xF0},
+	{"DTCM", NULL, 0, 0xF1},
+	{"SQRAM", NULL, 0, 0xF2},
+	{"APU", NULL, 0, 0xF3},
+	{"CIU", NULL, 0, 0xF4},
+	{"ICU", NULL, 0, 0xF5},
+	{"MAC", NULL, 0, 0xF6},
+	{"EXT7", NULL, 0, 0xF7},
+	{"EXT8", NULL, 0, 0xF8},
+	{"EXT9", NULL, 0, 0xF9},
+	{"EXT10", NULL, 0, 0xFA},
+	{"EXT11", NULL, 0, 0xFB},
+	{"EXT12", NULL, 0, 0xFC},
+	{"EXT13", NULL, 0, 0xFD},
+	{"EXTLAST", NULL, 0, 0xFE},
+};
+
 /*
  * SDIO probe.
  *
@@ -87,6 +105,7 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 		card->tx_buf_size = data->tx_buf_size;
 		card->mp_tx_agg_buf_size = data->mp_tx_agg_buf_size;
 		card->mp_rx_agg_buf_size = data->mp_rx_agg_buf_size;
+		card->supports_fw_dump = data->supports_fw_dump;
 	}
 
 	sdio_claim_host(func);
@@ -1779,6 +1798,8 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 	adapter->dev = &func->dev;
 
 	strcpy(adapter->fw_name, card->firmware);
+	adapter->mem_type_mapping_tbl = mem_type_mapping_tbl;
+	adapter->num_mem_types = ARRAY_SIZE(mem_type_mapping_tbl);
 
 	return 0;
 }
@@ -1936,6 +1957,180 @@ static void mwifiex_sdio_card_reset_work(struct mwifiex_adapter *adapter)
 	mmc_add_host(target);
 }
 
+/* This function read/write firmware */
+static enum
+rdwr_status mwifiex_sdio_rdwr_firmware(struct mwifiex_adapter *adapter,
+				       u8 doneflag)
+{
+	struct sdio_mmc_card *card = adapter->card;
+	int ret, tries;
+	u8 ctrl_data = 0;
+
+	sdio_writeb(card->func, FW_DUMP_HOST_READY, card->reg->fw_dump_ctrl,
+		    &ret);
+	if (ret) {
+		dev_err(adapter->dev, "SDIO Write ERR\n");
+		return RDWR_STATUS_FAILURE;
+	}
+	for (tries = 0; tries < MAX_POLL_TRIES; tries++) {
+		ctrl_data = sdio_readb(card->func, card->reg->fw_dump_ctrl,
+				       &ret);
+		if (ret) {
+			dev_err(adapter->dev, "SDIO read err\n");
+			return RDWR_STATUS_FAILURE;
+		}
+		if (ctrl_data == FW_DUMP_DONE)
+			break;
+		if (doneflag && ctrl_data == doneflag)
+			return RDWR_STATUS_DONE;
+		if (ctrl_data != FW_DUMP_HOST_READY) {
+			dev_info(adapter->dev,
+				 "The ctrl reg was changed, re-try again!\n");
+			sdio_writeb(card->func, FW_DUMP_HOST_READY,
+				    card->reg->fw_dump_ctrl, &ret);
+			if (ret) {
+				dev_err(adapter->dev, "SDIO write err\n");
+				return RDWR_STATUS_FAILURE;
+			}
+		}
+		usleep_range(100, 200);
+	}
+	if (ctrl_data == FW_DUMP_HOST_READY) {
+		dev_err(adapter->dev, "Fail to pull ctrl_data\n");
+		return RDWR_STATUS_FAILURE;
+	}
+
+	return RDWR_STATUS_SUCCESS;
+}
+
+/* This function dump firmware memory to file */
+static void mwifiex_sdio_fw_dump_work(struct work_struct *work)
+{
+	struct mwifiex_adapter *adapter =
+			container_of(work, struct mwifiex_adapter, iface_work);
+	struct sdio_mmc_card *card = adapter->card;
+	int ret = 0;
+	unsigned int reg, reg_start, reg_end;
+	u8 *dbg_ptr, *end_ptr, dump_num, idx, i, read_reg, doneflag = 0;
+	struct timeval t;
+	enum rdwr_status stat;
+	u32 memory_size;
+	static char *env[] = { "DRIVER=mwifiex_sdio", "EVENT=fw_dump", NULL };
+
+	if (!card->supports_fw_dump)
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
+	mwifiex_pm_wakeup_card(adapter);
+	sdio_claim_host(card->func);
+
+	do_gettimeofday(&t);
+	dev_info(adapter->dev, "== mwifiex firmware dump start: %u.%06u ==\n",
+		 (u32)t.tv_sec, (u32)t.tv_usec);
+
+	stat = mwifiex_sdio_rdwr_firmware(adapter, doneflag);
+	if (stat == RDWR_STATUS_FAILURE)
+		goto done;
+
+	reg = card->reg->fw_dump_start;
+	/* Read the number of the memories which will dump */
+	dump_num = sdio_readb(card->func, reg, &ret);
+	if (ret) {
+		dev_err(adapter->dev, "SDIO read memory length err\n");
+		goto done;
+	}
+
+	/* Read the length of every memory which will dump */
+	for (idx = 0; idx < dump_num; idx++) {
+		struct memory_type_mapping *entry = &mem_type_mapping_tbl[idx];
+
+		stat = mwifiex_sdio_rdwr_firmware(adapter, doneflag);
+		if (stat == RDWR_STATUS_FAILURE)
+			goto done;
+
+		memory_size = 0;
+		reg = card->reg->fw_dump_start;
+		for (i = 0; i < 4; i++) {
+			read_reg = sdio_readb(card->func, reg, &ret);
+			if (ret) {
+				dev_err(adapter->dev, "SDIO read err\n");
+				goto done;
+			}
+			memory_size |= (read_reg << i*8);
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
+			dev_err(adapter->dev, "Vmalloc %s failed\n",
+				entry->mem_name);
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
+			stat = mwifiex_sdio_rdwr_firmware(adapter, doneflag);
+			if (stat == RDWR_STATUS_FAILURE)
+				goto done;
+
+			reg_start = card->reg->fw_dump_start;
+			reg_end = card->reg->fw_dump_end;
+			for (reg = reg_start; reg <= reg_end; reg++) {
+				*dbg_ptr = sdio_readb(card->func, reg, &ret);
+				if (ret) {
+					dev_err(adapter->dev,
+						"SDIO read err\n");
+					goto done;
+				}
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
+		} while (1);
+	}
+	do_gettimeofday(&t);
+	dev_info(adapter->dev, "== mwifiex firmware dump end: %u.%06u ==\n",
+		 (u32)t.tv_sec, (u32)t.tv_usec);
+
+	kobject_uevent_env(&adapter->wiphy->dev.kobj, KOBJ_CHANGE, env);
+
+done:
+	sdio_release_host(card->func);
+	adapter->curr_mem_idx = 0;
+}
+
 static void mwifiex_sdio_work(struct work_struct *work)
 {
 	struct mwifiex_adapter *adapter =
@@ -1944,6 +2139,9 @@ static void mwifiex_sdio_work(struct work_struct *work)
 	if (test_and_clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET,
 			       &adapter->iface_work_flags))
 		mwifiex_sdio_card_reset_work(adapter);
+	if (test_and_clear_bit(MWIFIEX_IFACE_WORK_FW_DUMP,
+			       &adapter->iface_work_flags))
+		mwifiex_sdio_fw_dump_work(work);
 }
 
 /* This function resets the card */
@@ -1957,6 +2155,16 @@ static void mwifiex_sdio_card_reset(struct mwifiex_adapter *adapter)
 	schedule_work(&adapter->iface_work);
 }
 
+/* This function dumps FW information */
+static void mwifiex_sdio_fw_dump(struct mwifiex_adapter *adapter)
+{
+	if (test_bit(MWIFIEX_IFACE_WORK_FW_DUMP, &adapter->iface_work_flags))
+		return;
+
+	set_bit(MWIFIEX_IFACE_WORK_FW_DUMP, &adapter->iface_work_flags);
+	schedule_work(&adapter->iface_work);
+}
+
 static struct mwifiex_if_ops sdio_ops = {
 	.init_if = mwifiex_init_sdio,
 	.cleanup_if = mwifiex_cleanup_sdio,
@@ -1978,6 +2186,7 @@ static struct mwifiex_if_ops sdio_ops = {
 	.event_complete = mwifiex_sdio_event_complete,
 	.card_reset = mwifiex_sdio_card_reset,
 	.iface_work = mwifiex_sdio_work,
+	.fw_dump = mwifiex_sdio_fw_dump,
 };
 
 /*
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index 6eea30b..e563309 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -219,6 +219,9 @@ struct mwifiex_sdio_card_reg {
 	u8 rd_len_p0_l;
 	u8 rd_len_p0_u;
 	u8 card_misc_cfg_reg;
+	u8 fw_dump_ctrl;
+	u8 fw_dump_start;
+	u8 fw_dump_end;
 };
 
 struct sdio_mmc_card {
@@ -231,6 +234,7 @@ struct sdio_mmc_card {
 	u8 mp_agg_pkt_limit;
 	bool supports_sdio_new_mode;
 	bool has_control_mask;
+	bool supports_fw_dump;
 	u16 tx_buf_size;
 	u32 mp_tx_agg_buf_size;
 	u32 mp_rx_agg_buf_size;
@@ -257,6 +261,7 @@ struct mwifiex_sdio_device {
 	u8 mp_agg_pkt_limit;
 	bool supports_sdio_new_mode;
 	bool has_control_mask;
+	bool supports_fw_dump;
 	u16 tx_buf_size;
 	u32 mp_tx_agg_buf_size;
 	u32 mp_rx_agg_buf_size;
@@ -307,6 +312,9 @@ static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8897 = {
 	.rd_len_p0_l = 0x0c,
 	.rd_len_p0_u = 0x0d,
 	.card_misc_cfg_reg = 0xcc,
+	.fw_dump_ctrl = 0xe2,
+	.fw_dump_start = 0xe3,
+	.fw_dump_end = 0xea,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8786 = {
@@ -319,6 +327,7 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8786 = {
 	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
 	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
 	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
+	.supports_fw_dump = false,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8787 = {
@@ -331,6 +340,7 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8787 = {
 	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
 	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
 	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
+	.supports_fw_dump = false,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8797 = {
@@ -343,6 +353,7 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8797 = {
 	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
 	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
 	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
+	.supports_fw_dump = false,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8897 = {
@@ -355,6 +366,7 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8897 = {
 	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
 	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_32K,
 	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_32K,
+	.supports_fw_dump = true,
 };
 
 /*
-- 
1.8.2.3

