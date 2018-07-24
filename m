Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:32652 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388364AbeGXIuK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 04:50:10 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH v2 19/19] wil6210: fix eDMA RX chaining
Date: Tue, 24 Jul 2018 10:44:40 +0300
Message-Id: <1532418280-5849-20-git-send-email-merez@codeaurora.org> (sfid-20180724_100227_079273_910ABA9C)
In-Reply-To: <1532418280-5849-1-git-send-email-merez@codeaurora.org>
References: <1532418280-5849-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HW requires Rx buffers to be 4 bytes aligned. Modify the driver to
meet this requirement.
Enable OFU rdy valid bug fix, to prevent hang in oful34_rx while
there is back-pressure from host during RX.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/main.c      |  7 +++++++
 drivers/net/wireless/ath/wil6210/txrx_edma.c | 13 ++++++-------
 drivers/net/wireless/ath/wil6210/wil6210.h   |  2 ++
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 1d4ce8e..7debed6 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1614,6 +1614,13 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 
 		wil->txrx_ops.configure_interrupt_moderation(wil);
 
+		/* Enable OFU rdy valid bug fix, to prevent hang in oful34_rx
+		 * while there is back-pressure from Host during RX
+		 */
+		if (wil->hw_version >= HW_VER_TALYN_MB)
+			wil_s(wil, RGF_DMA_MISC_CTL,
+			      BIT_OFUL34_RDY_VALID_BUG_FIX_EN);
+
 		rc = wil_restore_vifs(wil);
 		if (rc) {
 			wil_err(wil, "failed to restore vifs, rc %d\n", rc);
diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index 9ef2b66..bca61cb 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -27,6 +27,8 @@
 #include "trace.h"
 
 #define WIL_EDMA_MAX_DATA_OFFSET (2)
+/* RX buffer size must be aligned to 4 bytes */
+#define WIL_EDMA_RX_BUF_LEN_DEFAULT (2048)
 
 static void wil_tx_desc_unmap_edma(struct device *dev,
 				   union wil_tx_desc *desc,
@@ -158,8 +160,7 @@ static int wil_ring_alloc_skb_edma(struct wil6210_priv *wil,
 				   struct wil_ring *ring, u32 i)
 {
 	struct device *dev = wil_to_dev(wil);
-	unsigned int sz = wil->rx_buf_len + ETH_HLEN +
-		WIL_EDMA_MAX_DATA_OFFSET;
+	unsigned int sz = ALIGN(wil->rx_buf_len, 4);
 	dma_addr_t pa;
 	u16 buff_id;
 	struct list_head *active = &wil->rx_buff_mgmt.active;
@@ -600,7 +601,7 @@ static bool wil_is_rx_idle_edma(struct wil6210_priv *wil)
 static void wil_rx_buf_len_init_edma(struct wil6210_priv *wil)
 {
 	wil->rx_buf_len = rx_large_buf ?
-		WIL_MAX_ETH_MTU : TXRX_BUF_LEN_DEFAULT - WIL_MAX_MPDU_OVERHEAD;
+		WIL_MAX_ETH_MTU : WIL_EDMA_RX_BUF_LEN_DEFAULT;
 }
 
 static int wil_rx_init_edma(struct wil6210_priv *wil, u16 desc_ring_size)
@@ -633,8 +634,7 @@ static int wil_rx_init_edma(struct wil6210_priv *wil, u16 desc_ring_size)
 
 	wil_rx_buf_len_init_edma(wil);
 
-	max_rx_pl_per_desc = wil->rx_buf_len + ETH_HLEN +
-		WIL_EDMA_MAX_DATA_OFFSET;
+	max_rx_pl_per_desc = ALIGN(wil->rx_buf_len, 4);
 
 	/* Use debugfs dbg_num_rx_srings if set, reserve one sring for TX */
 	if (wil->num_rx_status_rings > WIL6210_MAX_STATUS_RINGS - 1)
@@ -869,8 +869,7 @@ static struct sk_buff *wil_sring_reap_rx_edma(struct wil6210_priv *wil,
 	struct sk_buff *skb;
 	dma_addr_t pa;
 	struct wil_ring_rx_data *rxdata = &sring->rx_data;
-	unsigned int sz = wil->rx_buf_len + ETH_HLEN +
-		WIL_EDMA_MAX_DATA_OFFSET;
+	unsigned int sz = ALIGN(wil->rx_buf_len, 4);
 	struct wil_net_stats *stats = NULL;
 	u16 dmalen;
 	int cid;
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 9fc51f7..17c294b 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -302,6 +302,8 @@ struct RGF_ICR {
 	#define BIT_DMA_ITR_RX_IDL_CNT_CTL_FOREVER		BIT(2)
 	#define BIT_DMA_ITR_RX_IDL_CNT_CTL_CLR			BIT(3)
 	#define BIT_DMA_ITR_RX_IDL_CNT_CTL_REACHED_TRESH	BIT(4)
+#define RGF_DMA_MISC_CTL				(0x881d6c)
+	#define BIT_OFUL34_RDY_VALID_BUG_FIX_EN			BIT(7)
 
 #define RGF_DMA_PSEUDO_CAUSE		(0x881c68)
 #define RGF_DMA_PSEUDO_CAUSE_MASK_SW	(0x881c6c)
-- 
1.9.1
