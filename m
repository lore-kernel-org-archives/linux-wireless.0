Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27539 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824AbcDELYS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 07:24:18 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 3/7] wil6210: change RX_HTRSH interrupt print level to debug
Date: Tue,  5 Apr 2016 14:24:03 +0300
Message-Id: <1459855447-17413-4-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160405_132424_097127_046B937C)
In-Reply-To: <1459855447-17413-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1459855447-17413-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using interrupt moderation RX_HTRSH interrupt can occur
frequently during high throughput and should not be considered
as error.
Such print-outs can degrade the performance hence should be printed
in debug print level.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index fe66b2b..6897754 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -228,11 +228,8 @@ static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
 	 */
 	if (likely(isr & (BIT_DMA_EP_RX_ICR_RX_DONE |
 			  BIT_DMA_EP_RX_ICR_RX_HTRSH))) {
-		wil_dbg_irq(wil, "RX done\n");
-
-		if (unlikely(isr & BIT_DMA_EP_RX_ICR_RX_HTRSH))
-			wil_err_ratelimited(wil,
-					    "Received \"Rx buffer is in risk of overflow\" interrupt\n");
+		wil_dbg_irq(wil, "RX done / RX_HTRSH received, ISR (0x%x)\n",
+			    isr);
 
 		isr &= ~(BIT_DMA_EP_RX_ICR_RX_DONE |
 			 BIT_DMA_EP_RX_ICR_RX_HTRSH);
-- 
1.8.5.2

