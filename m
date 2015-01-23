Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:63628 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751125AbbAWGJr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 01:09:47 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0N65JpD029165
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2015 22:09:47 -0800
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1s2a34vtcf-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2015 22:09:47 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yogeshp@marvell.com>,
	<nishants@marvell.com>, <frankh@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH v2 3/3] mwifiex: selectively choose ext_scan support
Date: Fri, 23 Jan 2015 17:09:19 +0530
Message-ID: <1422013159-3093-3-git-send-email-patila@marvell.com> (sfid-20150123_070950_654651_8FD03279)
In-Reply-To: <1422013159-3093-1-git-send-email-patila@marvell.com>
References: <1422013159-3093-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some devices do not support extended scan.
This patch adds support to enble ext_scan selectively.
For SD/PCIe interfaces, deefine ext_scan_support as part of
card structure and use it to initialize ext_scan in adapter
during registering device. For USB interfaces, we initialize
ext_scan during register_dev handler.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c | 2 +-
 drivers/net/wireless/mwifiex/pcie.c | 2 ++
 drivers/net/wireless/mwifiex/pcie.h | 3 +++
 drivers/net/wireless/mwifiex/sdio.c | 2 ++
 drivers/net/wireless/mwifiex/sdio.h | 8 ++++++++
 drivers/net/wireless/mwifiex/usb.c  | 3 +++
 6 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index b115e0f..8004d14 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -294,7 +294,7 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	memset(&adapter->arp_filter, 0, sizeof(adapter->arp_filter));
 	adapter->arp_filter_size = 0;
 	adapter->max_mgmt_ie_index = MAX_MGMT_IE_INDEX;
-	adapter->ext_scan = true;
+	adapter->ext_scan = false;
 	adapter->key_api_major_ver = 0;
 	adapter->key_api_minor_ver = 0;
 
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index a460b0e..a5828da 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -204,6 +204,7 @@ static int mwifiex_pcie_probe(struct pci_dev *pdev,
 		card->pcie.blksz_fw_dl = data->blksz_fw_dl;
 		card->pcie.tx_buf_size = data->tx_buf_size;
 		card->pcie.supports_fw_dump = data->supports_fw_dump;
+		card->pcie.can_ext_scan = data->can_ext_scan;
 	}
 
 	if (mwifiex_add_card(card, &add_remove_card_sem, &pcie_ops,
@@ -2563,6 +2564,7 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 	adapter->mem_type_mapping_tbl = mem_type_mapping_tbl;
 	adapter->num_mem_types = ARRAY_SIZE(mem_type_mapping_tbl);
 	strcpy(adapter->fw_name, card->pcie.firmware);
+	adapter->ext_scan = card->pcie.can_ext_scan;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mwifiex/pcie.h b/drivers/net/wireless/mwifiex/pcie.h
index 200e8b0..666d40e 100644
--- a/drivers/net/wireless/mwifiex/pcie.h
+++ b/drivers/net/wireless/mwifiex/pcie.h
@@ -206,6 +206,7 @@ struct mwifiex_pcie_device {
 	u16 blksz_fw_dl;
 	u16 tx_buf_size;
 	bool supports_fw_dump;
+	bool can_ext_scan;
 };
 
 static const struct mwifiex_pcie_device mwifiex_pcie8766 = {
@@ -214,6 +215,7 @@ static const struct mwifiex_pcie_device mwifiex_pcie8766 = {
 	.blksz_fw_dl = MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD,
 	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
 	.supports_fw_dump = false,
+	.can_ext_scan = true,
 };
 
 static const struct mwifiex_pcie_device mwifiex_pcie8897 = {
@@ -222,6 +224,7 @@ static const struct mwifiex_pcie_device mwifiex_pcie8897 = {
 	.blksz_fw_dl = MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD,
 	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
 	.supports_fw_dump = true,
+	.can_ext_scan = true,
 };
 
 struct mwifiex_evt_buf_desc {
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index cee107f..91e36cd 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -107,6 +107,7 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 		card->mp_rx_agg_buf_size = data->mp_rx_agg_buf_size;
 		card->supports_fw_dump = data->supports_fw_dump;
 		card->auto_tdls = data->auto_tdls;
+		card->can_ext_scan = data->can_ext_scan;
 	}
 
 	sdio_claim_host(func);
@@ -1887,6 +1888,7 @@ static int mwifiex_init_sdio(struct mwifiex_adapter *adapter)
 	}
 
 	adapter->auto_tdls = card->auto_tdls;
+	adapter->ext_scan = card->can_ext_scan;
 	return ret;
 }
 
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index a4bb0db..957cca2 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -256,6 +256,7 @@ struct sdio_mmc_card {
 
 	u8 *mp_regs;
 	u8 auto_tdls;
+	bool can_ext_scan;
 
 	struct mwifiex_sdio_mpa_tx mpa_tx;
 	struct mwifiex_sdio_mpa_rx mpa_rx;
@@ -273,6 +274,7 @@ struct mwifiex_sdio_device {
 	u32 mp_tx_agg_buf_size;
 	u32 mp_rx_agg_buf_size;
 	u8 auto_tdls;
+	bool can_ext_scan;
 };
 
 static const struct mwifiex_sdio_card_reg mwifiex_reg_sd87xx = {
@@ -417,6 +419,7 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8786 = {
 	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
 	.supports_fw_dump = false,
 	.auto_tdls = false,
+	.can_ext_scan = false,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8787 = {
@@ -431,6 +434,7 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8787 = {
 	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
 	.supports_fw_dump = false,
 	.auto_tdls = false,
+	.can_ext_scan = true,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8797 = {
@@ -445,6 +449,7 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8797 = {
 	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
 	.supports_fw_dump = false,
 	.auto_tdls = false,
+	.can_ext_scan = true,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8897 = {
@@ -459,6 +464,7 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8897 = {
 	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_32K,
 	.supports_fw_dump = true,
 	.auto_tdls = false,
+	.can_ext_scan = true,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8887 = {
@@ -473,6 +479,7 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8887 = {
 	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_32K,
 	.supports_fw_dump = false,
 	.auto_tdls = true,
+	.can_ext_scan = true,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8801 = {
@@ -487,6 +494,7 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8801 = {
 	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
 	.supports_fw_dump = false,
 	.auto_tdls = false,
+	.can_ext_scan = true,
 };
 
 /*
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index 50517b7..2238730 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -799,16 +799,19 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 	case USB8897_PID_2:
 		adapter->tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K;
 		strcpy(adapter->fw_name, USB8897_DEFAULT_FW_NAME);
+		adapter->ext_scan = true;
 		break;
 	case USB8766_PID_1:
 	case USB8766_PID_2:
 		adapter->tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K;
 		strcpy(adapter->fw_name, USB8766_DEFAULT_FW_NAME);
+		adapter->ext_scan = true;
 		break;
 	case USB8801_PID_1:
 	case USB8801_PID_2:
 		adapter->tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K;
 		strcpy(adapter->fw_name, USB8801_DEFAULT_FW_NAME);
+		adapter->ext_scan = false;
 		break;
 	case USB8797_PID_1:
 	case USB8797_PID_2:
-- 
1.8.1.4

