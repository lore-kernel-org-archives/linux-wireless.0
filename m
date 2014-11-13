Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:4766 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932468AbaKMKzs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 05:55:48 -0500
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <yangyang@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 6/6] mwifiex: enable auto TDLS support for SD8887
Date: Thu, 13 Nov 2014 21:54:18 +0530
Message-ID: <1415895858-4007-7-git-send-email-patila@marvell.com> (sfid-20141113_115551_343966_C03BA1F7)
In-Reply-To: <1415895858-4007-1-git-send-email-patila@marvell.com>
References: <1415895858-4007-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Auto TDLS support is enabled per device. As of now add this
feature only for SD8887.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c | 1 -
 drivers/net/wireless/mwifiex/sdio.c | 2 ++
 drivers/net/wireless/mwifiex/sdio.h | 7 +++++++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index ee51242..cc15ab8 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -249,7 +249,6 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	adapter->hw_dev_mcs_support = 0;
 	adapter->sec_chan_offset = 0;
 	adapter->adhoc_11n_enabled = false;
-	adapter->auto_tdls = false;
 
 	mwifiex_wmm_init(adapter);
 
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index b25766b..933dae1 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -106,6 +106,7 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 		card->mp_tx_agg_buf_size = data->mp_tx_agg_buf_size;
 		card->mp_rx_agg_buf_size = data->mp_rx_agg_buf_size;
 		card->supports_fw_dump = data->supports_fw_dump;
+		card->auto_tdls = data->auto_tdls;
 	}
 
 	sdio_claim_host(func);
@@ -1880,6 +1881,7 @@ static int mwifiex_init_sdio(struct mwifiex_adapter *adapter)
 		return -1;
 	}
 
+	adapter->auto_tdls = card->auto_tdls;
 	return ret;
 }
 
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index 20cd9ad..54c0715 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -246,6 +246,7 @@ struct sdio_mmc_card {
 	u8 curr_wr_port;
 
 	u8 *mp_regs;
+	u8 auto_tdls;
 
 	struct mwifiex_sdio_mpa_tx mpa_tx;
 	struct mwifiex_sdio_mpa_rx mpa_rx;
@@ -262,6 +263,7 @@ struct mwifiex_sdio_device {
 	u16 tx_buf_size;
 	u32 mp_tx_agg_buf_size;
 	u32 mp_rx_agg_buf_size;
+	u8 auto_tdls;
 };
 
 static const struct mwifiex_sdio_card_reg mwifiex_reg_sd87xx = {
@@ -387,6 +389,7 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8786 = {
 	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
 	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
 	.supports_fw_dump = false,
+	.auto_tdls = false,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8787 = {
@@ -400,6 +403,7 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8787 = {
 	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
 	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
 	.supports_fw_dump = false,
+	.auto_tdls = false,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8797 = {
@@ -413,6 +417,7 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8797 = {
 	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
 	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
 	.supports_fw_dump = false,
+	.auto_tdls = false,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8897 = {
@@ -426,6 +431,7 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8897 = {
 	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_32K,
 	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_32K,
 	.supports_fw_dump = true,
+	.auto_tdls = false,
 };
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8887 = {
@@ -439,6 +445,7 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8887 = {
 	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_32K,
 	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_32K,
 	.supports_fw_dump = false,
+	.auto_tdls = true,
 };
 
 /*
-- 
1.8.1.4

