Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21839 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754002AbbCLLxA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 07:53:00 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t2CBoLVX014929
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 04:53:00 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1t20qjf1mr-11
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 04:53:00 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <liuzy@marvell.com>,
	<crlo@marvell.com>, <pchen@marvell.com>, <szli@marvell.com>,
	<nishants@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 2/9] mwifiex: rename alloc_rx_buf to alloc_dma_aligned_buf
Date: Thu, 12 Mar 2015 22:51:53 +0530
Message-ID: <1426180920-10567-3-git-send-email-patila@marvell.com> (sfid-20150312_125304_119415_0835D09C)
In-Reply-To: <1426180920-10567-1-git-send-email-patila@marvell.com>
References: <1426180920-10567-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename this function to reflect its purpose correctly.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/main.h | 2 +-
 drivers/net/wireless/mwifiex/pcie.c | 8 ++++----
 drivers/net/wireless/mwifiex/sdio.c | 7 ++++---
 drivers/net/wireless/mwifiex/util.c | 4 ++--
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 04ef618..d609d16 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1423,7 +1423,7 @@ u8 mwifiex_adjust_data_rate(struct mwifiex_private *priv,
 			    u8 rx_rate, u8 ht_info);
 
 void mwifiex_dump_drv_info(struct mwifiex_adapter *adapter);
-void *mwifiex_alloc_rx_buf(int rx_len, gfp_t flags);
+void *mwifiex_alloc_dma_align_buf(int rx_len, gfp_t flags);
 
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 4b463c3..fc59c1d 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -498,8 +498,8 @@ static int mwifiex_init_rxq_ring(struct mwifiex_adapter *adapter)
 
 	for (i = 0; i < MWIFIEX_MAX_TXRX_BD; i++) {
 		/* Allocate skb here so that firmware can DMA data from it */
-		skb = mwifiex_alloc_rx_buf(MWIFIEX_RX_DATA_BUF_SIZE,
-					   GFP_KERNEL | GFP_DMA);
+		skb = mwifiex_alloc_dma_align_buf(MWIFIEX_RX_DATA_BUF_SIZE,
+						  GFP_KERNEL | GFP_DMA);
 		if (!skb) {
 			dev_err(adapter->dev,
 				"Unable to allocate skb for RX ring.\n");
@@ -1298,8 +1298,8 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 			}
 		}
 
-		skb_tmp = mwifiex_alloc_rx_buf(MWIFIEX_RX_DATA_BUF_SIZE,
-					       GFP_KERNEL | GFP_DMA);
+		skb_tmp = mwifiex_alloc_dma_align_buf(MWIFIEX_RX_DATA_BUF_SIZE,
+						      GFP_KERNEL | GFP_DMA);
 		if (!skb_tmp) {
 			dev_err(adapter->dev,
 				"Unable to allocate skb.\n");
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 9ef010b..509204f 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1362,7 +1362,7 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 			return -1;
 		rx_len = (u16) (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE);
 
-		skb = mwifiex_alloc_rx_buf(rx_len, GFP_KERNEL | GFP_DMA);
+		skb = mwifiex_alloc_dma_align_buf(rx_len, GFP_KERNEL | GFP_DMA);
 		if (!skb)
 			return -1;
 
@@ -1459,8 +1459,9 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 			}
 			rx_len = (u16) (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE);
 
-			skb = mwifiex_alloc_rx_buf(rx_len,
-						   GFP_KERNEL | GFP_DMA);
+			skb = mwifiex_alloc_dma_align_buf(rx_len,
+							  GFP_KERNEL |
+							  GFP_DMA);
 
 			if (!skb) {
 				dev_err(adapter->dev, "%s: failed to alloc skb",
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 2148a57..b8a4587 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -632,7 +632,7 @@ void mwifiex_hist_data_reset(struct mwifiex_private *priv)
 		atomic_set(&phist_data->sig_str[ix], 0);
 }
 
-void *mwifiex_alloc_rx_buf(int rx_len, gfp_t flags)
+void *mwifiex_alloc_dma_align_buf(int rx_len, gfp_t flags)
 {
 	struct sk_buff *skb;
 	int buf_len, pad;
@@ -653,4 +653,4 @@ void *mwifiex_alloc_rx_buf(int rx_len, gfp_t flags)
 
 	return skb;
 }
-EXPORT_SYMBOL_GPL(mwifiex_alloc_rx_buf);
+EXPORT_SYMBOL_GPL(mwifiex_alloc_dma_align_buf);
-- 
1.8.1.4

