Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:6417 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445AbbBKMNE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2015 07:13:04 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t1BC94lk012035
	for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2015 04:13:03 -0800
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0a-0016f401.pphosted.com with ESMTP id 1set0u7k6r-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2015 04:13:03 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	<szli@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 3/4] mwifiex: change datatype to bool for device capability flags
Date: Wed, 11 Feb 2015 23:12:26 +0530
Message-ID: <1423676547-5213-3-git-send-email-patila@marvell.com> (sfid-20150211_131314_217410_82524071)
In-Reply-To: <1423676547-5213-1-git-send-email-patila@marvell.com>
References: <1423676547-5213-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes datatypes for device capability flags to bool.
Patch also aggregates these variables at single place.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c |  4 +--
 drivers/net/wireless/mwifiex/pcie.h |  6 ++--
 drivers/net/wireless/mwifiex/sdio.c |  8 ++---
 drivers/net/wireless/mwifiex/sdio.h | 60 ++++++++++++++++++-------------------
 4 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index a5828da..0640bd6 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -203,7 +203,7 @@ static int mwifiex_pcie_probe(struct pci_dev *pdev,
 		card->pcie.reg = data->reg;
 		card->pcie.blksz_fw_dl = data->blksz_fw_dl;
 		card->pcie.tx_buf_size = data->tx_buf_size;
-		card->pcie.supports_fw_dump = data->supports_fw_dump;
+		card->pcie.can_dump_fw = data->can_dump_fw;
 		card->pcie.can_ext_scan = data->can_ext_scan;
 	}
 
@@ -2271,7 +2271,7 @@ static void mwifiex_pcie_fw_dump_work(struct mwifiex_adapter *adapter)
 	int ret;
 	static char *env[] = { "DRIVER=mwifiex_pcie", "EVENT=fw_dump", NULL };
 
-	if (!card->pcie.supports_fw_dump)
+	if (!card->pcie.can_dump_fw)
 		return;
 
 	for (idx = 0; idx < ARRAY_SIZE(mem_type_mapping_tbl); idx++) {
diff --git a/drivers/net/wireless/mwifiex/pcie.h b/drivers/net/wireless/mwifiex/pcie.h
index 666d40e..0e7ee8b 100644
--- a/drivers/net/wireless/mwifiex/pcie.h
+++ b/drivers/net/wireless/mwifiex/pcie.h
@@ -205,7 +205,7 @@ struct mwifiex_pcie_device {
 	const struct mwifiex_pcie_card_reg *reg;
 	u16 blksz_fw_dl;
 	u16 tx_buf_size;
-	bool supports_fw_dump;
+	bool can_dump_fw;
 	bool can_ext_scan;
 };
 
@@ -214,7 +214,7 @@ static const struct mwifiex_pcie_device mwifiex_pcie8766 = {
 	.reg            = &mwifiex_reg_8766,
 	.blksz_fw_dl = MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD,
 	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
-	.supports_fw_dump = false,
+	.can_dump_fw = false,
 	.can_ext_scan = true,
 };
 
@@ -223,7 +223,7 @@ static const struct mwifiex_pcie_device mwifiex_pcie8897 = {
 	.reg            = &mwifiex_reg_8897,
 	.blksz_fw_dl = MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD,
 	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
-	.supports_fw_dump = true,
+	.can_dump_fw = true,
 	.can_ext_scan = true,
 };
 
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 91e36cd..78a9e86 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -105,8 +105,8 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 		card->tx_buf_size = data->tx_buf_size;
 		card->mp_tx_agg_buf_size = data->mp_tx_agg_buf_size;
 		card->mp_rx_agg_buf_size = data->mp_rx_agg_buf_size;
-		card->supports_fw_dump = data->supports_fw_dump;
-		card->auto_tdls = data->auto_tdls;
+		card->can_dump_fw = data->can_dump_fw;
+		card->can_auto_tdls = data->can_auto_tdls;
 		card->can_ext_scan = data->can_ext_scan;
 	}
 
@@ -1887,7 +1887,7 @@ static int mwifiex_init_sdio(struct mwifiex_adapter *adapter)
 		return -1;
 	}
 
-	adapter->auto_tdls = card->auto_tdls;
+	adapter->auto_tdls = card->can_auto_tdls;
 	adapter->ext_scan = card->can_ext_scan;
 	return ret;
 }
@@ -2032,7 +2032,7 @@ static void mwifiex_sdio_fw_dump_work(struct work_struct *work)
 
 	mwifiex_dump_drv_info(adapter);
 
-	if (!card->supports_fw_dump)
+	if (!card->can_dump_fw)
 		return;
 
 	for (idx = 0; idx < ARRAY_SIZE(mem_type_mapping_tbl); idx++) {
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index 957cca2..3fe9fb4 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -238,9 +238,6 @@ struct sdio_mmc_card {
 	const struct mwifiex_sdio_card_reg *reg;
 	u8 max_ports;
 	u8 mp_agg_pkt_limit;
-	bool supports_sdio_new_mode;
-	bool has_control_mask;
-	bool supports_fw_dump;
 	u16 tx_buf_size;
 	u32 mp_tx_agg_buf_size;
 	u32 mp_rx_agg_buf_size;
@@ -255,7 +252,10 @@ struct sdio_mmc_card {
 	u8 curr_wr_port;
 
 	u8 *mp_regs;
-	u8 auto_tdls;
+	bool supports_sdio_new_mode;
+	bool has_control_mask;
+	bool can_dump_fw;
+	bool can_auto_tdls;
 	bool can_ext_scan;
 
 	struct mwifiex_sdio_mpa_tx mpa_tx;
@@ -267,13 +267,13 @@ struct mwifiex_sdio_device {
 	const struct mwifiex_sdio_card_reg *reg;
 	u8 max_ports;
 	u8 mp_agg_pkt_limit;
-	bool supports_sdio_new_mode;
-	bool has_control_mask;
-	bool supports_fw_dump;
 	u16 tx_buf_size;
 	u32 mp_tx_agg_buf_size;
 	u32 mp_rx_agg_buf_size;
-	u8 auto_tdls;
+	bool supports_sdio_new_mode;
+	bool has_control_mask;
+	bool can_dump_fw;
+	bool can_auto_tdls;
 	bool can_ext_scan;
 };
 
@@ -412,13 +412,13 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8786 = {
 	.reg = &mwifiex_reg_sd87xx,
 	.max_ports = 16,
 	.mp_agg_pkt_limit = 8,
-	.supports_sdio_new_mode = false,
-	.has_control_mask = true,
 	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
 	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
 	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
-	.supports_fw_dump = false,
-	.auto_tdls = false,
+	.supports_sdio_new_mode = false,
+	.has_control_mask = true,
+	.can_dump_fw = false,
+	.can_auto_tdls = false,
 	.can_ext_scan = false,
 };
 
@@ -427,13 +427,13 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8787 = {
 	.reg = &mwifiex_reg_sd87xx,
 	.max_ports = 16,
 	.mp_agg_pkt_limit = 8,
-	.supports_sdio_new_mode = false,
-	.has_control_mask = true,
 	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
 	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
 	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
-	.supports_fw_dump = false,
-	.auto_tdls = false,
+	.supports_sdio_new_mode = false,
+	.has_control_mask = true,
+	.can_dump_fw = false,
+	.can_auto_tdls = false,
 	.can_ext_scan = true,
 };
 
@@ -442,13 +442,13 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8797 = {
 	.reg = &mwifiex_reg_sd87xx,
 	.max_ports = 16,
 	.mp_agg_pkt_limit = 8,
-	.supports_sdio_new_mode = false,
-	.has_control_mask = true,
 	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
 	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
 	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
-	.supports_fw_dump = false,
-	.auto_tdls = false,
+	.supports_sdio_new_mode = false,
+	.has_control_mask = true,
+	.can_dump_fw = false,
+	.can_auto_tdls = false,
 	.can_ext_scan = true,
 };
 
@@ -457,13 +457,13 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8897 = {
 	.reg = &mwifiex_reg_sd8897,
 	.max_ports = 32,
 	.mp_agg_pkt_limit = 16,
-	.supports_sdio_new_mode = true,
-	.has_control_mask = false,
 	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
 	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_32K,
 	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_32K,
-	.supports_fw_dump = true,
-	.auto_tdls = false,
+	.supports_sdio_new_mode = true,
+	.has_control_mask = false,
+	.can_dump_fw = true,
+	.can_auto_tdls = false,
 	.can_ext_scan = true,
 };
 
@@ -472,13 +472,13 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8887 = {
 	.reg = &mwifiex_reg_sd8887,
 	.max_ports = 32,
 	.mp_agg_pkt_limit = 16,
-	.supports_sdio_new_mode = true,
-	.has_control_mask = false,
 	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
 	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_32K,
 	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_32K,
-	.supports_fw_dump = false,
-	.auto_tdls = true,
+	.supports_sdio_new_mode = true,
+	.has_control_mask = false,
+	.can_dump_fw = false,
+	.can_auto_tdls = true,
 	.can_ext_scan = true,
 };
 
@@ -492,8 +492,8 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8801 = {
 	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
 	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
 	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
-	.supports_fw_dump = false,
-	.auto_tdls = false,
+	.can_dump_fw = false,
+	.can_auto_tdls = false,
 	.can_ext_scan = true,
 };
 
-- 
1.8.1.4

