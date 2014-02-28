Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:28625 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751067AbaB1DfY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 22:35:24 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/9] mwifiex: change transmit buffer size for 8897
Date: Thu, 27 Feb 2014 19:35:13 -0800
Message-ID: <1393558513-854-2-git-send-email-bzhao@marvell.com> (sfid-20140228_043529_089646_F355DA54)
In-Reply-To: <1393558513-854-1-git-send-email-bzhao@marvell.com>
References: <1393558513-854-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Currently default Tx buffer size configured to firmware is 2K
for all chipsets. This patch changes it to 4K for SD/PCIe/USB
8897 chipsets as per firmware requirements.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c | 1 -
 drivers/net/wireless/mwifiex/pcie.c | 2 ++
 drivers/net/wireless/mwifiex/pcie.h | 3 +++
 drivers/net/wireless/mwifiex/sdio.c | 2 ++
 drivers/net/wireless/mwifiex/sdio.h | 6 ++++++
 drivers/net/wireless/mwifiex/usb.c  | 2 ++
 6 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 7594928..4ecd0b2 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -234,7 +234,6 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 
 	adapter->pm_wakeup_fw_try = false;
 
-	adapter->tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K;
 	adapter->curr_tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K;
 
 	adapter->is_hs_configured = false;
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 31d8a9d..f56595c 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -190,6 +190,7 @@ static int mwifiex_pcie_probe(struct pci_dev *pdev,
 		card->pcie.firmware = data->firmware;
 		card->pcie.reg = data->reg;
 		card->pcie.blksz_fw_dl = data->blksz_fw_dl;
+		card->pcie.tx_buf_size = data->tx_buf_size;
 	}
 
 	if (mwifiex_add_card(card, &add_remove_card_sem, &pcie_ops,
@@ -2320,6 +2321,7 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 	}
 
 	adapter->dev = &pdev->dev;
+	adapter->tx_buf_size = card->pcie.tx_buf_size;
 	strcpy(adapter->fw_name, card->pcie.firmware);
 
 	return 0;
diff --git a/drivers/net/wireless/mwifiex/pcie.h b/drivers/net/wireless/mwifiex/pcie.h
index d322ab8..193af75 100644
--- a/drivers/net/wireless/mwifiex/pcie.h
+++ b/drivers/net/wireless/mwifiex/pcie.h
@@ -195,18 +195,21 @@ struct mwifiex_pcie_device {
 	const char *firmware;
 	const struct mwifiex_pcie_card_reg *reg;
 	u16 blksz_fw_dl;
+	u16 tx_buf_size;
 };
 
 static const struct mwifiex_pcie_device mwifiex_pcie8766 = {
 	.firmware       = PCIE8766_DEFAULT_FW_NAME,
 	.reg            = &mwifiex_reg_8766,
 	.blksz_fw_dl = MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
 };
 
 static const struct mwifiex_pcie_device mwifiex_pcie8897 = {
 	.firmware       = PCIE8897_DEFAULT_FW_NAME,
 	.reg            = &mwifiex_reg_8897,
 	.blksz_fw_dl = MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
 };
 
 struct mwifiex_evt_buf_desc {
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index b44a315..d5661a6 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -84,6 +84,7 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 		card->mp_agg_pkt_limit = data->mp_agg_pkt_limit;
 		card->supports_sdio_new_mode = data->supports_sdio_new_mode;
 		card->has_control_mask = data->has_control_mask;
+		card->tx_buf_size = data->tx_buf_size;
 	}
 
 	sdio_claim_host(func);
@@ -1760,6 +1761,7 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 
 	/* save adapter pointer in card */
 	card->adapter = adapter;
+	adapter->tx_buf_size = card->tx_buf_size;
 
 	sdio_claim_host(func);
 
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index 532ae0a..c71201b 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -233,6 +233,7 @@ struct sdio_mmc_card {
 	u8 mp_agg_pkt_limit;
 	bool supports_sdio_new_mode;
 	bool has_control_mask;
+	u16 tx_buf_size;
 
 	u32 mp_rd_bitmap;
 	u32 mp_wr_bitmap;
@@ -256,6 +257,7 @@ struct mwifiex_sdio_device {
 	u8 mp_agg_pkt_limit;
 	bool supports_sdio_new_mode;
 	bool has_control_mask;
+	u16 tx_buf_size;
 };
 
 static const struct mwifiex_sdio_card_reg mwifiex_reg_sd87xx = {
@@ -312,6 +314,7 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8786 = {
 	.mp_agg_pkt_limit = 8,
 	.supports_sdio_new_mode = false,
 	.has_control_mask = true,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8787 = {
@@ -321,6 +324,7 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8787 = {
 	.mp_agg_pkt_limit = 8,
 	.supports_sdio_new_mode = false,
 	.has_control_mask = true,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8797 = {
@@ -330,6 +334,7 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8797 = {
 	.mp_agg_pkt_limit = 8,
 	.supports_sdio_new_mode = false,
 	.has_control_mask = true,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8897 = {
@@ -339,6 +344,7 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8897 = {
 	.mp_agg_pkt_limit = 16,
 	.supports_sdio_new_mode = true,
 	.has_control_mask = false,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K,
 };
 
 /*
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index 2087488..f47a793 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -766,11 +766,13 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 	switch (le16_to_cpu(card->udev->descriptor.idProduct)) {
 	case USB8897_PID_1:
 	case USB8897_PID_2:
+		adapter->tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K;
 		strcpy(adapter->fw_name, USB8897_DEFAULT_FW_NAME);
 		break;
 	case USB8797_PID_1:
 	case USB8797_PID_2:
 	default:
+		adapter->tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K;
 		strcpy(adapter->fw_name, USB8797_DEFAULT_FW_NAME);
 		break;
 	}
-- 
1.8.2.3

