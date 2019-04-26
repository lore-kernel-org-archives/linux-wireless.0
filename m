Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DF7DC43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 15:50:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45BC4205ED
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 15:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbfDZPt6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 11:49:58 -0400
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:21644 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726597AbfDZPt5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 11:49:57 -0400
X-IronPort-AV: E=Sophos;i="5.60,398,1549926000"; 
   d="scan'208";a="2367516"
Received: from ironmsg01-ams.qualcomm.com ([10.251.56.2])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 26 Apr 2019 17:43:41 +0200
X-IronPort-AV: E=McAfee;i="5900,7806,9238"; a="7889764"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg01-ams.qualcomm.com with ESMTP; 26 Apr 2019 17:43:40 +0200
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH 1/9] wil6210: fix spurious interrupts in 3-msi
Date:   Fri, 26 Apr 2019 18:43:29 +0300
Message-Id: <1556293417-27097-2-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1556293417-27097-1-git-send-email-merez@codeaurora.org>
References: <1556293417-27097-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Interrupt is set in ICM (ICR & ~IMV) rising trigger.
As the driver masks the IRQ after clearing it, there can
be a race where an additional spurious interrupt is triggered
when the driver unmask the IRQ.
This can happen in case HW triggers an interrupt after the clear
and before the mask.

To prevent the second spurious interrupt the driver needs to mask the
IRQ before reading and clearing it.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 65 +++++++++++++++++-----------
 1 file changed, 40 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 3f5bd17..d161dc9 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -296,21 +296,24 @@ void wil_configure_interrupt_moderation(struct wil6210_priv *wil)
 static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
 {
 	struct wil6210_priv *wil = cookie;
-	u32 isr = wil_ioread32_and_clear(wil->csr +
-					 HOSTADDR(RGF_DMA_EP_RX_ICR) +
-					 offsetof(struct RGF_ICR, ICR));
+	u32 isr;
 	bool need_unmask = true;
 
+	wil6210_mask_irq_rx(wil);
+
+	isr = wil_ioread32_and_clear(wil->csr +
+				     HOSTADDR(RGF_DMA_EP_RX_ICR) +
+				     offsetof(struct RGF_ICR, ICR));
+
 	trace_wil6210_irq_rx(isr);
 	wil_dbg_irq(wil, "ISR RX 0x%08x\n", isr);
 
 	if (unlikely(!isr)) {
 		wil_err_ratelimited(wil, "spurious IRQ: RX\n");
+		wil6210_unmask_irq_rx(wil);
 		return IRQ_NONE;
 	}
 
-	wil6210_mask_irq_rx(wil);
-
 	/* RX_DONE and RX_HTRSH interrupts are the same if interrupt
 	 * moderation is not used. Interrupt moderation may cause RX
 	 * buffer overflow while RX_DONE is delayed. The required
@@ -355,21 +358,24 @@ static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
 static irqreturn_t wil6210_irq_rx_edma(int irq, void *cookie)
 {
 	struct wil6210_priv *wil = cookie;
-	u32 isr = wil_ioread32_and_clear(wil->csr +
-					 HOSTADDR(RGF_INT_GEN_RX_ICR) +
-					 offsetof(struct RGF_ICR, ICR));
+	u32 isr;
 	bool need_unmask = true;
 
+	wil6210_mask_irq_rx_edma(wil);
+
+	isr = wil_ioread32_and_clear(wil->csr +
+				     HOSTADDR(RGF_INT_GEN_RX_ICR) +
+				     offsetof(struct RGF_ICR, ICR));
+
 	trace_wil6210_irq_rx(isr);
 	wil_dbg_irq(wil, "ISR RX 0x%08x\n", isr);
 
 	if (unlikely(!isr)) {
 		wil_err(wil, "spurious IRQ: RX\n");
+		wil6210_unmask_irq_rx_edma(wil);
 		return IRQ_NONE;
 	}
 
-	wil6210_mask_irq_rx_edma(wil);
-
 	if (likely(isr & BIT_RX_STATUS_IRQ)) {
 		wil_dbg_irq(wil, "RX status ring\n");
 		isr &= ~BIT_RX_STATUS_IRQ;
@@ -403,21 +409,24 @@ static irqreturn_t wil6210_irq_rx_edma(int irq, void *cookie)
 static irqreturn_t wil6210_irq_tx_edma(int irq, void *cookie)
 {
 	struct wil6210_priv *wil = cookie;
-	u32 isr = wil_ioread32_and_clear(wil->csr +
-					 HOSTADDR(RGF_INT_GEN_TX_ICR) +
-					 offsetof(struct RGF_ICR, ICR));
+	u32 isr;
 	bool need_unmask = true;
 
+	wil6210_mask_irq_tx_edma(wil);
+
+	isr = wil_ioread32_and_clear(wil->csr +
+				     HOSTADDR(RGF_INT_GEN_TX_ICR) +
+				     offsetof(struct RGF_ICR, ICR));
+
 	trace_wil6210_irq_tx(isr);
 	wil_dbg_irq(wil, "ISR TX 0x%08x\n", isr);
 
 	if (unlikely(!isr)) {
 		wil_err(wil, "spurious IRQ: TX\n");
+		wil6210_unmask_irq_tx_edma(wil);
 		return IRQ_NONE;
 	}
 
-	wil6210_mask_irq_tx_edma(wil);
-
 	if (likely(isr & BIT_TX_STATUS_IRQ)) {
 		wil_dbg_irq(wil, "TX status ring\n");
 		isr &= ~BIT_TX_STATUS_IRQ;
@@ -446,21 +455,24 @@ static irqreturn_t wil6210_irq_tx_edma(int irq, void *cookie)
 static irqreturn_t wil6210_irq_tx(int irq, void *cookie)
 {
 	struct wil6210_priv *wil = cookie;
-	u32 isr = wil_ioread32_and_clear(wil->csr +
-					 HOSTADDR(RGF_DMA_EP_TX_ICR) +
-					 offsetof(struct RGF_ICR, ICR));
+	u32 isr;
 	bool need_unmask = true;
 
+	wil6210_mask_irq_tx(wil);
+
+	isr = wil_ioread32_and_clear(wil->csr +
+				     HOSTADDR(RGF_DMA_EP_TX_ICR) +
+				     offsetof(struct RGF_ICR, ICR));
+
 	trace_wil6210_irq_tx(isr);
 	wil_dbg_irq(wil, "ISR TX 0x%08x\n", isr);
 
 	if (unlikely(!isr)) {
 		wil_err_ratelimited(wil, "spurious IRQ: TX\n");
+		wil6210_unmask_irq_tx(wil);
 		return IRQ_NONE;
 	}
 
-	wil6210_mask_irq_tx(wil);
-
 	if (likely(isr & BIT_DMA_EP_TX_ICR_TX_DONE)) {
 		wil_dbg_irq(wil, "TX done\n");
 		isr &= ~BIT_DMA_EP_TX_ICR_TX_DONE;
@@ -532,20 +544,23 @@ static bool wil_validate_mbox_regs(struct wil6210_priv *wil)
 static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
 {
 	struct wil6210_priv *wil = cookie;
-	u32 isr = wil_ioread32_and_clear(wil->csr +
-					 HOSTADDR(RGF_DMA_EP_MISC_ICR) +
-					 offsetof(struct RGF_ICR, ICR));
+	u32 isr;
+
+	wil6210_mask_irq_misc(wil, false);
+
+	isr = wil_ioread32_and_clear(wil->csr +
+				     HOSTADDR(RGF_DMA_EP_MISC_ICR) +
+				     offsetof(struct RGF_ICR, ICR));
 
 	trace_wil6210_irq_misc(isr);
 	wil_dbg_irq(wil, "ISR MISC 0x%08x\n", isr);
 
 	if (!isr) {
 		wil_err(wil, "spurious IRQ: MISC\n");
+		wil6210_unmask_irq_misc(wil, false);
 		return IRQ_NONE;
 	}
 
-	wil6210_mask_irq_misc(wil, false);
-
 	if (isr & ISR_MISC_FW_ERROR) {
 		u32 fw_assert_code = wil_r(wil, wil->rgf_fw_assert_code_addr);
 		u32 ucode_assert_code =
-- 
1.9.1

