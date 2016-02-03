Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:23873 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932673AbcBCGKV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 01:10:21 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u1369QdB011926
	for <linux-wireless@vger.kernel.org>; Tue, 2 Feb 2016 22:10:21 -0800
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0a-0016f401.pphosted.com with ESMTP id 20svyv7n1s-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 02 Feb 2016 22:10:20 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 8/8] mwifiex: firmware dump support for w8997 chipset
Date: Tue, 2 Feb 2016 22:05:09 -0800
Message-ID: <1454479509-27129-9-git-send-email-akarwar@marvell.com> (sfid-20160203_071059_414625_E33FED71)
In-Reply-To: <1454479509-27129-1-git-send-email-akarwar@marvell.com>
References: <1454479509-27129-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

Current firmware dump solution support w8897 chipset, this
patch extend the exist framework with support for w8997
chipset.

Trigger firmware dump using,
cat /sys/kernel/debug/mwifiex/mlan0/device_dump,
data can be obtain by
cat /sys/class/devcoredump/devcd*/data > data.txt after that.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/decl.h |  1 +
 drivers/net/wireless/marvell/mwifiex/pcie.c | 30 +++++++++++++++++++----------
 drivers/net/wireless/marvell/mwifiex/pcie.h | 13 ++++++++++++-
 3 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/decl.h b/drivers/net/wireless/marvell/mwifiex/decl.h
index a184f9f..bec300b 100644
--- a/drivers/net/wireless/marvell/mwifiex/decl.h
+++ b/drivers/net/wireless/marvell/mwifiex/decl.h
@@ -274,6 +274,7 @@ struct mwifiex_11h_intf_state {
 } __packed;
 
 #define MWIFIEX_FW_DUMP_IDX		0xff
+#define MWIFIEX_FW_DUMP_MAX_MEMSIZE     0x160000
 #define MWIFIEX_DRV_INFO_IDX		20
 #define FW_DUMP_MAX_NAME_LEN		8
 #define FW_DUMP_HOST_READY      0xEE
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 14fe316..cc07214 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2402,7 +2402,7 @@ static void mwifiex_pcie_fw_dump(struct mwifiex_adapter *adapter)
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *creg = card->pcie.reg;
 	unsigned int reg, reg_start, reg_end;
-	u8 *dbg_ptr, *end_ptr, *tmp_ptr, dump_num;
+	u8 *dbg_ptr, *end_ptr, *tmp_ptr, fw_dump_num, dump_num;
 	u8 idx, i, read_reg, doneflag = 0;
 	enum rdwr_status stat;
 	u32 memory_size;
@@ -2430,22 +2430,32 @@ static void mwifiex_pcie_fw_dump(struct mwifiex_adapter *adapter)
 		return;
 
 	reg = creg->fw_dump_start;
-	mwifiex_read_reg_byte(adapter, reg, &dump_num);
+	mwifiex_read_reg_byte(adapter, reg, &fw_dump_num);
+
+	/* W8997 chipset firmware dump will be restore in single region*/
+	if (fw_dump_num == 0)
+		dump_num = 1;
+	else
+		dump_num = fw_dump_num;
 
 	/* Read the length of every memory which will dump */
 	for (idx = 0; idx < dump_num; idx++) {
 		struct memory_type_mapping *entry =
 				&adapter->mem_type_mapping_tbl[idx];
-		stat = mwifiex_pcie_rdwr_firmware(adapter, doneflag);
-		if (stat == RDWR_STATUS_FAILURE)
-			return;
-
 		memory_size = 0;
-		reg = creg->fw_dump_start;
-		for (i = 0; i < 4; i++) {
-			mwifiex_read_reg_byte(adapter, reg, &read_reg);
-			memory_size |= (read_reg << (i * 8));
+		if (fw_dump_num != 0) {
+			stat = mwifiex_pcie_rdwr_firmware(adapter, doneflag);
+			if (stat == RDWR_STATUS_FAILURE)
+				return;
+
+			reg = creg->fw_dump_start;
+			for (i = 0; i < 4; i++) {
+				mwifiex_read_reg_byte(adapter, reg, &read_reg);
+				memory_size |= (read_reg << (i * 8));
 			reg++;
+			}
+		} else {
+			memory_size = MWIFIEX_FW_DUMP_MAX_MEMSIZE;
 		}
 
 		if (memory_size == 0) {
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h b/drivers/net/wireless/marvell/mwifiex/pcie.h
index 8bc4390..29e58ce 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.h
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
@@ -239,6 +239,11 @@ static const struct mwifiex_pcie_card_reg mwifiex_reg_8997 = {
 	.ring_tx_start_ptr = MWIFIEX_BD_FLAG_TX_START_PTR,
 	.pfu_enabled = 1,
 	.sleep_cookie = 0,
+	.fw_dump_ctrl = 0xcf4,
+	.fw_dump_start = 0xcf8,
+	.fw_dump_end = 0xcff,
+	.fw_dump_host_ready = 0xcc,
+	.fw_dump_read_done = 0xdd,
 	.msix_support = 1,
 };
 
@@ -253,6 +258,10 @@ static struct memory_type_mapping mem_type_mapping_tbl_w8897[] = {
 	{"MAC", NULL, 0, 0xF7},
 };
 
+static struct memory_type_mapping mem_type_mapping_tbl_w8997[] = {
+	{"DUMP", NULL, 0, 0xDD},
+};
+
 struct mwifiex_pcie_device {
 	const char *firmware;
 	const struct mwifiex_pcie_card_reg *reg;
@@ -289,7 +298,9 @@ static const struct mwifiex_pcie_device mwifiex_pcie8997 = {
 	.reg            = &mwifiex_reg_8997,
 	.blksz_fw_dl = MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD,
 	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
-	.can_dump_fw = false,
+	.can_dump_fw = true,
+	.mem_type_mapping_tbl = mem_type_mapping_tbl_w8997,
+	.num_mem_types = ARRAY_SIZE(mem_type_mapping_tbl_w8997),
 	.can_ext_scan = true,
 };
 
-- 
1.8.1.4

