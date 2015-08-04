Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60183 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933558AbbHDMbX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 08:31:23 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t74CTi2s025129
	for <linux-wireless@vger.kernel.org>; Tue, 4 Aug 2015 05:31:23 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0a-0016f401.pphosted.com with ESMTP id 1w2kk1hmuj-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2015 05:31:22 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Zhaoyang Liu <liuzy@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v2 2/3] mwifiex: add firmware dump support for SD8997
Date: Tue, 4 Aug 2015 05:30:30 -0700
Message-ID: <1438691431-3462-2-git-send-email-akarwar@marvell.com> (sfid-20150804_143138_897604_CCCBDF71)
In-Reply-To: <1438691431-3462-1-git-send-email-akarwar@marvell.com>
References: <1438691431-3462-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhaoyang Liu <liuzy@marvell.com>

This patch adds firmware dump feature for SD8997 chipset.
The difference here is only one memory type is needed
to save all firmware information. Device dump information
will be uploaded to usersapace file.

Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 147 +++++++++++++++++++++++++++++++++---
 drivers/net/wireless/mwifiex/sdio.h |  11 ++-
 2 files changed, 148 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 9904a77..7cef27e9 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -51,6 +51,10 @@ static unsigned long iface_work_flags;
 
 static struct semaphore add_remove_card_sem;
 
+static struct memory_type_mapping generic_mem_type_map[] = {
+	{"DUMP", NULL, 0, 0xDD},
+};
+
 static struct memory_type_mapping mem_type_mapping_tbl[] = {
 	{"ITCM", NULL, 0, 0xF0},
 	{"DTCM", NULL, 0, 0xF1},
@@ -108,6 +112,7 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 		card->mp_tx_agg_buf_size = data->mp_tx_agg_buf_size;
 		card->mp_rx_agg_buf_size = data->mp_rx_agg_buf_size;
 		card->can_dump_fw = data->can_dump_fw;
+		card->fw_dump_enh = data->fw_dump_enh;
 		card->can_auto_tdls = data->can_auto_tdls;
 		card->can_ext_scan = data->can_ext_scan;
 	}
@@ -1969,8 +1974,13 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 	adapter->dev = &func->dev;
 
 	strcpy(adapter->fw_name, card->firmware);
-	adapter->mem_type_mapping_tbl = mem_type_mapping_tbl;
-	adapter->num_mem_types = ARRAY_SIZE(mem_type_mapping_tbl);
+	if (card->fw_dump_enh) {
+		adapter->mem_type_mapping_tbl = generic_mem_type_map;
+		adapter->num_mem_types = 1;
+	} else {
+		adapter->mem_type_mapping_tbl = mem_type_mapping_tbl;
+		adapter->num_mem_types = ARRAY_SIZE(mem_type_mapping_tbl);
+	}
 
 	return 0;
 }
@@ -2163,8 +2173,8 @@ rdwr_status mwifiex_sdio_rdwr_firmware(struct mwifiex_adapter *adapter,
 	int ret, tries;
 	u8 ctrl_data = 0;
 
-	sdio_writeb(card->func, FW_DUMP_HOST_READY, card->reg->fw_dump_ctrl,
-		    &ret);
+	sdio_writeb(card->func, card->reg->fw_dump_host_ready,
+		    card->reg->fw_dump_ctrl, &ret);
 	if (ret) {
 		mwifiex_dbg(adapter, ERROR, "SDIO Write ERR\n");
 		return RDWR_STATUS_FAILURE;
@@ -2180,10 +2190,10 @@ rdwr_status mwifiex_sdio_rdwr_firmware(struct mwifiex_adapter *adapter,
 			break;
 		if (doneflag && ctrl_data == doneflag)
 			return RDWR_STATUS_DONE;
-		if (ctrl_data != FW_DUMP_HOST_READY) {
+		if (ctrl_data != card->reg->fw_dump_host_ready) {
 			mwifiex_dbg(adapter, WARN,
-				    "The ctrl reg was changed, re-try again!\n");
-			sdio_writeb(card->func, FW_DUMP_HOST_READY,
+				    "The ctrl reg was changed, re-try again\n");
+			sdio_writeb(card->func, card->reg->fw_dump_host_ready,
 				    card->reg->fw_dump_ctrl, &ret);
 			if (ret) {
 				mwifiex_dbg(adapter, ERROR, "SDIO write err\n");
@@ -2192,7 +2202,7 @@ rdwr_status mwifiex_sdio_rdwr_firmware(struct mwifiex_adapter *adapter,
 		}
 		usleep_range(100, 200);
 	}
-	if (ctrl_data == FW_DUMP_HOST_READY) {
+	if (ctrl_data == card->reg->fw_dump_host_ready) {
 		mwifiex_dbg(adapter, ERROR,
 			    "Fail to pull ctrl_data\n");
 		return RDWR_STATUS_FAILURE;
@@ -2325,10 +2335,129 @@ done:
 	sdio_release_host(card->func);
 }
 
+static void mwifiex_sdio_generic_fw_dump(struct mwifiex_adapter *adapter)
+{
+	struct sdio_mmc_card *card = adapter->card;
+	struct memory_type_mapping *entry = &generic_mem_type_map[0];
+	unsigned int reg, reg_start, reg_end;
+	u8 start_flag = 0, done_flag = 0;
+	u8 *dbg_ptr, *end_ptr;
+	enum rdwr_status stat;
+	int ret = -1, tries;
+
+	if (!card->fw_dump_enh)
+		return;
+
+	if (entry->mem_ptr) {
+		vfree(entry->mem_ptr);
+		entry->mem_ptr = NULL;
+	}
+	entry->mem_size = 0;
+
+	mwifiex_pm_wakeup_card(adapter);
+	sdio_claim_host(card->func);
+
+	mwifiex_dbg(adapter, MSG, "== mwifiex firmware dump start ==\n");
+
+	stat = mwifiex_sdio_rdwr_firmware(adapter, done_flag);
+	if (stat == RDWR_STATUS_FAILURE)
+		goto done;
+
+	reg_start = card->reg->fw_dump_start;
+	reg_end = card->reg->fw_dump_end;
+	for (reg = reg_start; reg <= reg_end; reg++) {
+		for (tries = 0; tries < MAX_POLL_TRIES; tries++) {
+			start_flag = sdio_readb(card->func, reg, &ret);
+			if (ret) {
+				mwifiex_dbg(adapter, ERROR,
+					    "SDIO read err\n");
+				goto done;
+			}
+			if (start_flag == 0)
+				break;
+			if (tries == MAX_POLL_TRIES) {
+				mwifiex_dbg(adapter, ERROR,
+					    "FW not ready to dump\n");
+				ret = -1;
+				goto done;
+			}
+		}
+		usleep_range(100, 200);
+	}
+
+	entry->mem_ptr = vmalloc(0xf0000 + 1);
+	if (!entry->mem_ptr) {
+		ret = -1;
+		goto done;
+	}
+	dbg_ptr = entry->mem_ptr;
+	entry->mem_size = 0xf0000;
+	end_ptr = dbg_ptr + entry->mem_size;
+
+	done_flag = entry->done_flag;
+	mwifiex_dbg(adapter, DUMP,
+		    "Start %s output, please wait...\n", entry->mem_name);
+
+	while (true) {
+		stat = mwifiex_sdio_rdwr_firmware(adapter, done_flag);
+		if (stat == RDWR_STATUS_FAILURE)
+			goto done;
+		for (reg = reg_start; reg <= reg_end; reg++) {
+			*dbg_ptr = sdio_readb(card->func, reg, &ret);
+			if (ret) {
+				mwifiex_dbg(adapter, ERROR,
+					    "SDIO read err\n");
+				goto done;
+			}
+			dbg_ptr++;
+			if (dbg_ptr >= end_ptr) {
+				u8 *tmp_ptr;
+
+				tmp_ptr = vmalloc(entry->mem_size + 0x4000 + 1);
+				if (!tmp_ptr)
+					goto done;
+
+				memcpy(tmp_ptr, entry->mem_ptr,
+				       entry->mem_size);
+				vfree(entry->mem_ptr);
+				entry->mem_ptr = tmp_ptr;
+				tmp_ptr = NULL;
+				dbg_ptr = entry->mem_ptr + entry->mem_size;
+				entry->mem_size += 0x4000;
+				end_ptr = entry->mem_ptr + entry->mem_size;
+			}
+		}
+		if (stat == RDWR_STATUS_DONE) {
+			entry->mem_size = dbg_ptr - entry->mem_ptr;
+			mwifiex_dbg(adapter, DUMP, "dump %s done size=0x%x\n",
+				    entry->mem_name, entry->mem_size);
+			ret = 0;
+			break;
+		}
+	}
+	mwifiex_dbg(adapter, MSG, "== mwifiex firmware dump end ==\n");
+
+done:
+	if (ret) {
+		mwifiex_dbg(adapter, ERROR, "firmware dump failed\n");
+		if (entry->mem_ptr) {
+			vfree(entry->mem_ptr);
+			entry->mem_ptr = NULL;
+		}
+		entry->mem_size = 0;
+	}
+	sdio_release_host(card->func);
+}
+
 static void mwifiex_sdio_device_dump_work(struct mwifiex_adapter *adapter)
 {
+	struct sdio_mmc_card *card = adapter->card;
+
 	mwifiex_drv_info_dump(adapter);
-	mwifiex_sdio_fw_dump(adapter);
+	if (card->fw_dump_enh)
+		mwifiex_sdio_generic_fw_dump(adapter);
+	else
+		mwifiex_sdio_fw_dump(adapter);
 	mwifiex_upload_device_dump(adapter);
 }
 
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index cd149196..b9fbc5c 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -223,6 +223,7 @@ struct mwifiex_sdio_card_reg {
 	u8 cmd_cfg_1;
 	u8 cmd_cfg_2;
 	u8 cmd_cfg_3;
+	u8 fw_dump_host_ready;
 	u8 fw_dump_ctrl;
 	u8 fw_dump_start;
 	u8 fw_dump_end;
@@ -258,6 +259,7 @@ struct sdio_mmc_card {
 	bool supports_sdio_new_mode;
 	bool has_control_mask;
 	bool can_dump_fw;
+	bool fw_dump_enh;
 	bool can_auto_tdls;
 	bool can_ext_scan;
 
@@ -279,6 +281,7 @@ struct mwifiex_sdio_device {
 	bool supports_sdio_new_mode;
 	bool has_control_mask;
 	bool can_dump_fw;
+	bool fw_dump_enh;
 	bool can_auto_tdls;
 	bool can_ext_scan;
 };
@@ -354,6 +357,7 @@ static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8897 = {
 	.cmd_cfg_1 = 0xb9,
 	.cmd_cfg_2 = 0xba,
 	.cmd_cfg_3 = 0xbb,
+	.fw_dump_host_ready = 0xee,
 	.fw_dump_ctrl = 0xe2,
 	.fw_dump_start = 0xe3,
 	.fw_dump_end = 0xea,
@@ -404,6 +408,10 @@ static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8997 = {
 	.cmd_cfg_1 = 0xc5,
 	.cmd_cfg_2 = 0xc6,
 	.cmd_cfg_3 = 0xc7,
+	.fw_dump_host_ready = 0xcc,
+	.fw_dump_ctrl = 0xf0,
+	.fw_dump_start = 0xf1,
+	.fw_dump_end = 0xf8,
 	.func1_dump_reg_start = 0x10,
 	.func1_dump_reg_end = 0x17,
 	.func1_scratch_reg = 0xe8,
@@ -532,7 +540,8 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8997 = {
 	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
 	.supports_sdio_new_mode = true,
 	.has_control_mask = false,
-	.can_dump_fw = false,
+	.can_dump_fw = true,
+	.fw_dump_enh = true,
 	.can_auto_tdls = false,
 	.can_ext_scan = true,
 };
-- 
1.8.1.4

