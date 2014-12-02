Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:13129 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaLBJrV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 04:47:21 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Joe Perches <joe@perches.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH v2 03/10] wil6210: add handling of RX HTRSH interrupt
Date: Tue, 2 Dec 2014 11:46:31 +0200
Message-ID: <1417513598-18304-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141202_104731_038156_D2948B53)
In-Reply-To: <1417513598-18304-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1417440803-26883-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1417513598-18304-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RX_HTRSH interrupt indicates Rx ring threshold of not-filled buffers
reached. Rx ring is about to overflow. It is handled in exactly
the same manner as RX_DONE interrupt - fetching accumulated
packets from RX. In addition there's a rate limited error message.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 30 +++++++++++++++++++++++++---
 drivers/net/wireless/ath/wil6210/wil6210.h   |  1 +
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 90f416f..4bcbd62 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -36,7 +36,8 @@
  */
 
 #define WIL6210_IRQ_DISABLE	(0xFFFFFFFFUL)
-#define WIL6210_IMC_RX		BIT_DMA_EP_RX_ICR_RX_DONE
+#define WIL6210_IMC_RX		(BIT_DMA_EP_RX_ICR_RX_DONE | \
+				 BIT_DMA_EP_RX_ICR_RX_HTRSH)
 #define WIL6210_IMC_TX		(BIT_DMA_EP_TX_ICR_TX_DONE | \
 				BIT_DMA_EP_TX_ICR_TX_DONE_N(0))
 #define WIL6210_IMC_MISC	(ISR_MISC_FW_READY | \
@@ -171,6 +172,7 @@ static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
 	u32 isr = wil_ioread32_and_clear(wil->csr +
 					 HOSTADDR(RGF_DMA_EP_RX_ICR) +
 					 offsetof(struct RGF_ICR, ICR));
+	bool need_unmask = true;
 
 	trace_wil6210_irq_rx(isr);
 	wil_dbg_irq(wil, "ISR RX 0x%08x\n", isr);
@@ -182,12 +184,24 @@ static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
 
 	wil6210_mask_irq_rx(wil);
 
-	if (isr & BIT_DMA_EP_RX_ICR_RX_DONE) {
+	/* RX_DONE and RX_HTRSH interrupts are the same if interrupt
+	 * moderation is not used. Interrupt moderation may cause RX
+	 * buffer overflow while RX_DONE is delayed. The required
+	 * action is always the same - should empty the accumulated
+	 * packets from the RX ring.
+	 */
+	if (isr & (BIT_DMA_EP_RX_ICR_RX_DONE | BIT_DMA_EP_RX_ICR_RX_HTRSH)) {
 		wil_dbg_irq(wil, "RX done\n");
-		isr &= ~BIT_DMA_EP_RX_ICR_RX_DONE;
+
+		if (isr & BIT_DMA_EP_RX_ICR_RX_HTRSH)
+			wil_err_ratelimited(wil, "Received \"Rx buffer is in risk "
+				"of overflow\" interrupt\n");
+
+		isr &= ~(BIT_DMA_EP_RX_ICR_RX_DONE | BIT_DMA_EP_RX_ICR_RX_HTRSH);
 		if (test_bit(wil_status_reset_done, &wil->status)) {
 			if (test_bit(wil_status_napi_en, &wil->status)) {
 				wil_dbg_txrx(wil, "NAPI(Rx) schedule\n");
+				need_unmask = false;
 				napi_schedule(&wil->napi_rx);
 			} else {
 				wil_err(wil, "Got Rx interrupt while "
@@ -204,6 +218,10 @@ static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
 	/* Rx IRQ will be enabled when NAPI processing finished */
 
 	atomic_inc(&wil->isr_count_rx);
+
+	if (unlikely(need_unmask))
+		wil6210_unmask_irq_rx(wil);
+
 	return IRQ_HANDLED;
 }
 
@@ -213,6 +231,7 @@ static irqreturn_t wil6210_irq_tx(int irq, void *cookie)
 	u32 isr = wil_ioread32_and_clear(wil->csr +
 					 HOSTADDR(RGF_DMA_EP_TX_ICR) +
 					 offsetof(struct RGF_ICR, ICR));
+	bool need_unmask = true;
 
 	trace_wil6210_irq_tx(isr);
 	wil_dbg_irq(wil, "ISR TX 0x%08x\n", isr);
@@ -231,6 +250,7 @@ static irqreturn_t wil6210_irq_tx(int irq, void *cookie)
 		isr &= ~(BIT(25) - 1UL);
 		if (test_bit(wil_status_reset_done, &wil->status)) {
 			wil_dbg_txrx(wil, "NAPI(Tx) schedule\n");
+			need_unmask = false;
 			napi_schedule(&wil->napi_tx);
 		} else {
 			wil_err(wil, "Got Tx interrupt while in reset\n");
@@ -243,6 +263,10 @@ static irqreturn_t wil6210_irq_tx(int irq, void *cookie)
 	/* Tx IRQ will be enabled when NAPI processing finished */
 
 	atomic_inc(&wil->isr_count_tx);
+
+	if (unlikely(need_unmask))
+		wil6210_unmask_irq_tx(wil);
+
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 450b688..f2f89e0 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -126,6 +126,7 @@ struct RGF_ICR {
 	#define BIT_DMA_EP_TX_ICR_TX_DONE_N(n)	BIT(n+1) /* n = [0..23] */
 #define RGF_DMA_EP_RX_ICR		(0x881bd0) /* struct RGF_ICR */
 	#define BIT_DMA_EP_RX_ICR_RX_DONE	BIT(0)
+	#define BIT_DMA_EP_RX_ICR_RX_HTRSH	BIT(1)
 #define RGF_DMA_EP_MISC_ICR		(0x881bec) /* struct RGF_ICR */
 	#define BIT_DMA_EP_MISC_ICR_RX_HTRSH	BIT(0)
 	#define BIT_DMA_EP_MISC_ICR_TX_NO_ACT	BIT(1)
-- 
2.1.0

