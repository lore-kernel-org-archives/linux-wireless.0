Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:41752 "EHLO
        alexa-out-lv-01.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751192AbdH1TSy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Aug 2017 15:18:54 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH 1/7] wil6210: ratelimit errors in TX/RX interrupts
Date: Mon, 28 Aug 2017 22:18:41 +0300
Message-Id: <1503947927-18877-2-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170828_211858_661762_725F710A)
In-Reply-To: <1503947927-18877-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1503947927-18877-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

Sometimes there is a firmware crash but the hardware
is not fully stopped and continue to send TX/RX interrupts.
This can cause an overload of messages which can bring the
host down. Add ratelimit to these error messages to fix this.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index cad8a95..59def4f 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -244,7 +244,7 @@ static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
 	wil_dbg_irq(wil, "ISR RX 0x%08x\n", isr);
 
 	if (unlikely(!isr)) {
-		wil_err(wil, "spurious IRQ: RX\n");
+		wil_err_ratelimited(wil, "spurious IRQ: RX\n");
 		return IRQ_NONE;
 	}
 
@@ -269,11 +269,12 @@ static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
 				need_unmask = false;
 				napi_schedule(&wil->napi_rx);
 			} else {
-				wil_err(wil,
+				wil_err_ratelimited(
+					wil,
 					"Got Rx interrupt while stopping interface\n");
 			}
 		} else {
-			wil_err(wil, "Got Rx interrupt while in reset\n");
+			wil_err_ratelimited(wil, "Got Rx interrupt while in reset\n");
 		}
 	}
 
@@ -302,7 +303,7 @@ static irqreturn_t wil6210_irq_tx(int irq, void *cookie)
 	wil_dbg_irq(wil, "ISR TX 0x%08x\n", isr);
 
 	if (unlikely(!isr)) {
-		wil_err(wil, "spurious IRQ: TX\n");
+		wil_err_ratelimited(wil, "spurious IRQ: TX\n");
 		return IRQ_NONE;
 	}
 
@@ -318,12 +319,13 @@ static irqreturn_t wil6210_irq_tx(int irq, void *cookie)
 			need_unmask = false;
 			napi_schedule(&wil->napi_tx);
 		} else {
-			wil_err(wil, "Got Tx interrupt while in reset\n");
+			wil_err_ratelimited(wil, "Got Tx interrupt while in reset\n");
 		}
 	}
 
 	if (unlikely(isr))
-		wil_err(wil, "un-handled TX ISR bits 0x%08x\n", isr);
+		wil_err_ratelimited(wil, "un-handled TX ISR bits 0x%08x\n",
+				    isr);
 
 	/* Tx IRQ will be enabled when NAPI processing finished */
 
-- 
1.9.1
