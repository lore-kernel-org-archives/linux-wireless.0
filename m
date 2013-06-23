Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27083 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab3FWKAg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Jun 2013 06:00:36 -0400
Cc: Kirshenbaum Erez <erezk@wilocity.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/2] wil6210: add HW write-back option in TX descriptor
Date: Sun, 23 Jun 2013 12:59:35 +0300
Message-ID: <1371981575-14395-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130623_120041_500601_D73D464C)
In-Reply-To: <1371981575-14395-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1371981575-14395-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kirshenbaum Erez <erezk@wilocity.com>

Map BIT 9 in TX DMA DWARD 0 as HW write back option.
We must turn on this option in the last TX descriptor,
this is required for old HW compatability.
This option indicate to HW that WB is required for this descriptor.

Signed-off-by: Kirshenbaum Erez <erezk@wilocity.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 2 +-
 drivers/net/wireless/ath/wil6210/txrx.h | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 73d6c2d..d240b24 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -708,7 +708,7 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	}
 	/* for the last seg only */
 	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_CMD_EOP_POS);
-	d->dma.d0 |= BIT(9); /* BUG: undocumented bit */
+	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_CMD_MARK_WB_POS);
 	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_CMD_DMA_IT_POS);
 	*_d = *d;
 
diff --git a/drivers/net/wireless/ath/wil6210/txrx.h b/drivers/net/wireless/ath/wil6210/txrx.h
index 23c0781..859aea6 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.h
+++ b/drivers/net/wireless/ath/wil6210/txrx.h
@@ -201,6 +201,10 @@ struct vring_tx_mac {
 #define DMA_CFG_DESC_TX_0_CMD_EOP_LEN 1
 #define DMA_CFG_DESC_TX_0_CMD_EOP_MSK 0x100
 
+#define DMA_CFG_DESC_TX_0_CMD_MARK_WB_POS 9
+#define DMA_CFG_DESC_TX_0_CMD_MARK_WB_LEN 1
+#define DMA_CFG_DESC_TX_0_CMD_MARK_WB_MSK 0x200
+
 #define DMA_CFG_DESC_TX_0_CMD_DMA_IT_POS 10
 #define DMA_CFG_DESC_TX_0_CMD_DMA_IT_LEN 1
 #define DMA_CFG_DESC_TX_0_CMD_DMA_IT_MSK 0x400
-- 
1.8.1.2

