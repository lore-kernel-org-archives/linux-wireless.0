Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:29747 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbbJYN7j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 09:59:39 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 3/4] wil6210: fix device ready detection
Date: Sun, 25 Oct 2015 15:59:23 +0200
Message-Id: <1445781564-24455-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20151025_145943_011739_2BE00FF4)
In-Reply-To: <1445781564-24455-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1445781564-24455-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adjust driver behavior during FW boot. Proper sequence of
events after reset and FW download, is as following:

- FW prepares mailbox structure and reports IRQ "FW_READY"
- driver caches mailbox registers, marks mailbox readiness
- FW sends WMI_FW_READY event, ignore it
- FW sends WMI_READY event with some data
- driver stores relevant data marks FW is operational

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/interrupt.c |  6 +++---
 drivers/net/wireless/ath/wil6210/wil6210.h   |  4 ++--
 drivers/net/wireless/ath/wil6210/wmi.c       | 10 ++--------
 3 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 06fc46f..50c136e 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -236,7 +236,7 @@ static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
 
 		isr &= ~(BIT_DMA_EP_RX_ICR_RX_DONE |
 			 BIT_DMA_EP_RX_ICR_RX_HTRSH);
-		if (likely(test_bit(wil_status_reset_done, wil->status))) {
+		if (likely(test_bit(wil_status_fwready, wil->status))) {
 			if (likely(test_bit(wil_status_napi_en, wil->status))) {
 				wil_dbg_txrx(wil, "NAPI(Rx) schedule\n");
 				need_unmask = false;
@@ -286,7 +286,7 @@ static irqreturn_t wil6210_irq_tx(int irq, void *cookie)
 		isr &= ~BIT_DMA_EP_TX_ICR_TX_DONE;
 		/* clear also all VRING interrupts */
 		isr &= ~(BIT(25) - 1UL);
-		if (likely(test_bit(wil_status_reset_done, wil->status))) {
+		if (likely(test_bit(wil_status_fwready, wil->status))) {
 			wil_dbg_txrx(wil, "NAPI(Tx) schedule\n");
 			need_unmask = false;
 			napi_schedule(&wil->napi_tx);
@@ -364,7 +364,7 @@ static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
 	if (isr & ISR_MISC_FW_READY) {
 		wil_dbg_irq(wil, "IRQ: FW ready\n");
 		wil_cache_mbox_regs(wil);
-		set_bit(wil_status_reset_done, wil->status);
+		set_bit(wil_status_mbox_ready, wil->status);
 		/**
 		 * Actual FW ready indicated by the
 		 * WMI_FW_READY_EVENTID
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index f619bf2..ade5f3b8 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -402,11 +402,11 @@ struct vring_tx_data {
 };
 
 enum { /* for wil6210_priv.status */
-	wil_status_fwready = 0,
+	wil_status_fwready = 0, /* FW operational */
 	wil_status_fwconnecting,
 	wil_status_fwconnected,
 	wil_status_dontscan,
-	wil_status_reset_done,
+	wil_status_mbox_ready, /* MBOX structures ready */
 	wil_status_irqen, /* FIXME: interrupts enabled - for debug */
 	wil_status_napi_en, /* NAPI enabled protected by wil->mutex */
 	wil_status_resetting, /* reset in progress */
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 361f3d8..6ed26ba 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -293,12 +293,6 @@ static void wmi_evt_ready(struct wil6210_priv *wil, int id, void *d, int len)
 	/* ignore MAC address, we already have it from the boot loader */
 	snprintf(wdev->wiphy->fw_version, sizeof(wdev->wiphy->fw_version),
 		 "%d", wil->fw_version);
-}
-
-static void wmi_evt_fw_ready(struct wil6210_priv *wil, int id, void *d,
-			     int len)
-{
-	wil_dbg_wmi(wil, "WMI: got FW ready event\n");
 
 	wil_set_recovery_state(wil, fw_recovery_idle);
 	set_bit(wil_status_fwready, wil->status);
@@ -699,7 +693,7 @@ static const struct {
 			void *data, int data_len);
 } wmi_evt_handlers[] = {
 	{WMI_READY_EVENTID,		wmi_evt_ready},
-	{WMI_FW_READY_EVENTID,		wmi_evt_fw_ready},
+	{WMI_FW_READY_EVENTID,			wmi_evt_ignore},
 	{WMI_RX_MGMT_PACKET_EVENTID,	wmi_evt_rx_mgmt},
 	{WMI_TX_MGMT_PACKET_EVENTID,		wmi_evt_tx_mgmt},
 	{WMI_SCAN_COMPLETE_EVENTID,	wmi_evt_scan_complete},
@@ -730,7 +724,7 @@ void wmi_recv_cmd(struct wil6210_priv *wil)
 	ulong flags;
 	unsigned n;
 
-	if (!test_bit(wil_status_reset_done, wil->status)) {
+	if (!test_bit(wil_status_mbox_ready, wil->status)) {
 		wil_err(wil, "Reset in progress. Cannot handle WMI event\n");
 		return;
 	}
-- 
2.1.4

