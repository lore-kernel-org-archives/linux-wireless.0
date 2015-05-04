Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32320 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbbEDWMA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 18:12:00 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v3 2/7] wil6210: update Rx descriptor fields
Date: Tue,  5 May 2015 01:11:51 +0300
Message-Id: <1430777516-439-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150505_001228_992542_E899F828)
In-Reply-To: <1430777516-439-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1430777516-439-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rx descriptor fields accordingly to the updated
hardware documentation

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c |  2 +-
 drivers/net/wireless/ath/wil6210/txrx.h | 24 ++++++++++++++++--------
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index e8bd512..1fd34e5 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -236,7 +236,7 @@ static int wil_vring_alloc_skb(struct wil6210_priv *wil, struct vring *vring,
 		return -ENOMEM;
 	}
 
-	d->dma.d0 = BIT(9) | RX_DMA_D0_CMD_DMA_IT;
+	d->dma.d0 = RX_DMA_D0_CMD_DMA_RT | RX_DMA_D0_CMD_DMA_IT;
 	wil_desc_addr_set(&d->dma.addr, pa);
 	/* ip_length don't care */
 	/* b11 don't care */
diff --git a/drivers/net/wireless/ath/wil6210/txrx.h b/drivers/net/wireless/ath/wil6210/txrx.h
index d90c8aa..0c46384 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.h
+++ b/drivers/net/wireless/ath/wil6210/txrx.h
@@ -384,19 +384,27 @@ struct vring_rx_mac {
  *  [word 7] length
  */
 
-#define RX_DMA_D0_CMD_DMA_IT     BIT(10)
-
-/* Error field, offload bits */
-#define RX_DMA_ERROR_L3_ERR   BIT(4)
-#define RX_DMA_ERROR_L4_ERR   BIT(5)
+#define RX_DMA_D0_CMD_DMA_EOP	BIT(8)
+#define RX_DMA_D0_CMD_DMA_RT	BIT(9)  /* always 1 */
+#define RX_DMA_D0_CMD_DMA_IT	BIT(10) /* interrupt */
+
+/* Error field */
+#define RX_DMA_ERROR_FCS	BIT(0)
+#define RX_DMA_ERROR_MIC	BIT(1)
+#define RX_DMA_ERROR_KEY	BIT(2) /* Key missing */
+#define RX_DMA_ERROR_REPLAY	BIT(3)
+#define RX_DMA_ERROR_L3_ERR	BIT(4)
+#define RX_DMA_ERROR_L4_ERR	BIT(5)
 
 /* Status field */
-#define RX_DMA_STATUS_DU         BIT(0)
-#define RX_DMA_STATUS_ERROR      BIT(2)
-
+#define RX_DMA_STATUS_DU	BIT(0)
+#define RX_DMA_STATUS_EOP	BIT(1)
+#define RX_DMA_STATUS_ERROR	BIT(2)
+#define RX_DMA_STATUS_MI	BIT(3) /* MAC Interrupt is asserted */
 #define RX_DMA_STATUS_L3I	BIT(4)
 #define RX_DMA_STATUS_L4I	BIT(5)
 #define RX_DMA_STATUS_PHY_INFO	BIT(6)
+#define RX_DMA_STATUS_FFM	BIT(7) /* EtherType Flex Filter Match */
 
 struct vring_rx_dma {
 	u32 d0;
-- 
2.1.0

