Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:17927 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753524AbdLNQxa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 11:53:30 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Dedy Lansky <qca_dlansky@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH v2 8/9] wil6210: remove leftover "FIXME"s
Date: Thu, 14 Dec 2017 18:53:12 +0200
Message-Id: <1513270393-919-9-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20171214_175336_505812_2044A81E)
In-Reply-To: <1513270393-919-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1513270393-919-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dedy Lansky <qca_dlansky@qca.qualcomm.com>

"FIXME: IRQ mask debug" and "FIXME: interrupts enabled - for debug"
can be removed because wil6210_debug_irq_mask() is now considered
production feature.

"FIXME FW can transmit only ucast frames to peer" and "FIXME real
ring_id instead of hard coded 0" can be removed because FW/HW already
support multicast transmission.

Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 2 +-
 drivers/net/wireless/ath/wil6210/wil6210.h   | 2 +-
 drivers/net/wireless/ath/wil6210/wmi.c       | 2 --
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 5cf3417..dcf87a7 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -565,7 +565,7 @@ static irqreturn_t wil6210_hardirq(int irq, void *cookie)
 	if (unlikely((pseudo_cause == 0) || ((pseudo_cause & 0xff) == 0xff)))
 		return IRQ_NONE;
 
-	/* FIXME: IRQ mask debug */
+	/* IRQ mask debug */
 	if (unlikely(wil6210_debug_irq_mask(wil, pseudo_cause)))
 		return IRQ_NONE;
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index ca5abbd..703e09e 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -439,7 +439,7 @@ enum { /* for wil6210_priv.status */
 	wil_status_fwconnected,
 	wil_status_dontscan,
 	wil_status_mbox_ready, /* MBOX structures ready */
-	wil_status_irqen, /* FIXME: interrupts enabled - for debug */
+	wil_status_irqen, /* interrupts enabled - for debug */
 	wil_status_napi_en, /* NAPI enabled protected by wil->mutex */
 	wil_status_resetting, /* reset in progress */
 	wil_status_suspending, /* suspend in progress */
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index d06090d..9b9882c 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -813,8 +813,6 @@ static void wmi_evt_connect(struct wil6210_priv *wil, int id, void *d, int len)
 		}
 	}
 
-	/* FIXME FW can transmit only ucast frames to peer */
-	/* FIXME real ring_id instead of hard coded 0 */
 	ether_addr_copy(wil->sta[evt->cid].addr, evt->bssid);
 	wil->sta[evt->cid].status = wil_sta_conn_pending;
 
-- 
1.9.1
