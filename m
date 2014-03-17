Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38567 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933482AbaCQNfG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 09:35:06 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 14/21] wil6210: Fix kernel oops in reset flow
Date: Mon, 17 Mar 2014 15:34:18 +0200
Message-ID: <1395063265-6522-15-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140317_143546_752094_1BD47578)
In-Reply-To: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wil_reset() removes vring's
At the same time NAPI may be active performing Rx/Tx completion.
If this happens, Rx/Tx polling functions going to access already removed vrings

Make sure NAPI is idle and won't be started prior to vring removal.
For this, track NAPI enabled state

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 15 ++++++++++++---
 drivers/net/wireless/ath/wil6210/main.c      |  9 ++++++++-
 drivers/net/wireless/ath/wil6210/wil6210.h   |  1 +
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 52c40e1..201cf06 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -195,8 +195,12 @@ static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
 	if (isr & BIT_DMA_EP_RX_ICR_RX_DONE) {
 		wil_dbg_irq(wil, "RX done\n");
 		isr &= ~BIT_DMA_EP_RX_ICR_RX_DONE;
-		wil_dbg_txrx(wil, "NAPI schedule\n");
-		napi_schedule(&wil->napi_rx);
+		if (test_bit(wil_status_reset_done, &wil->status)) {
+			wil_dbg_txrx(wil, "NAPI(Rx) schedule\n");
+			napi_schedule(&wil->napi_rx);
+		} else {
+			wil_err(wil, "Got Rx interrupt while in reset\n");
+		}
 	}
 
 	if (isr)
@@ -226,10 +230,15 @@ static irqreturn_t wil6210_irq_tx(int irq, void *cookie)
 
 	if (isr & BIT_DMA_EP_TX_ICR_TX_DONE) {
 		wil_dbg_irq(wil, "TX done\n");
-		napi_schedule(&wil->napi_tx);
 		isr &= ~BIT_DMA_EP_TX_ICR_TX_DONE;
 		/* clear also all VRING interrupts */
 		isr &= ~(BIT(25) - 1UL);
+		if (test_bit(wil_status_reset_done, &wil->status)) {
+			wil_dbg_txrx(wil, "NAPI(Tx) schedule\n");
+			napi_schedule(&wil->napi_tx);
+		} else {
+			wil_err(wil, "Got Tx interrupt while in reset\n");
+		}
 	}
 
 	if (isr)
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index de952ab..0831d4c 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -329,11 +329,16 @@ int wil_reset(struct wil6210_priv *wil)
 {
 	int rc;
 
+	wil->status = 0; /* prevent NAPI from being scheduled */
+	if (test_bit(wil_status_napi_en, &wil->status)) {
+		napi_synchronize(&wil->napi_rx);
+		napi_synchronize(&wil->napi_tx);
+	}
+
 	cancel_work_sync(&wil->disconnect_worker);
 	wil6210_disconnect(wil, NULL);
 
 	wil6210_disable_irq(wil);
-	wil->status = 0;
 
 	wmi_event_flush(wil);
 
@@ -426,6 +431,7 @@ static int __wil_up(struct wil6210_priv *wil)
 
 	napi_enable(&wil->napi_rx);
 	napi_enable(&wil->napi_tx);
+	set_bit(wil_status_napi_en, &wil->status);
 
 	return 0;
 }
@@ -443,6 +449,7 @@ int wil_up(struct wil6210_priv *wil)
 
 static int __wil_down(struct wil6210_priv *wil)
 {
+	clear_bit(wil_status_napi_en, &wil->status);
 	napi_disable(&wil->napi_rx);
 	napi_disable(&wil->napi_tx);
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index f7d8f0e..89cbdc3 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -249,6 +249,7 @@ enum { /* for wil6210_priv.status */
 	wil_status_dontscan,
 	wil_status_reset_done,
 	wil_status_irqen, /* FIXME: interrupts enabled - for debug */
+	wil_status_napi_en, /* NAPI enabled protected by wil->mutex */
 };
 
 struct pci_dev;
-- 
1.8.3.2

