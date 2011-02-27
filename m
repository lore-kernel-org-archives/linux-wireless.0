Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33169 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab1B0Wa6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Feb 2011 17:30:58 -0500
Received: by mail-ww0-f44.google.com with SMTP id 22so2383975wwb.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Feb 2011 14:30:57 -0800 (PST)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 1/7] wl12xx: Reorder data handling in irq_work
Date: Mon, 28 Feb 2011 00:30:39 +0200
Message-Id: <1298845845-12191-2-git-send-email-ido@wizery.com>
In-Reply-To: <1298845845-12191-1-git-send-email-ido@wizery.com>
References: <1298845845-12191-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The FW has a limited amount of memory for holding frames. In case it
runs out of memory reserved for RX frames, it'll have no other choice
but to drop packets received from the AP. Thus, it is important to
handle RX data interrupts as soon as possible, before handling anything else.

In addition, since there are enough TX descriptors to go around, it is
better to first send TX frames, and only then handle TX completions.

Fix this by changing the order of function calls in wl1271_irq_work.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 95aa19a..443f829 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -685,10 +685,7 @@ static void wl1271_irq_work(struct work_struct *work)
 		if (intr & WL1271_ACX_INTR_DATA) {
 			wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_DATA");
 
-			/* check for tx results */
-			if (wl->fw_status->common.tx_results_counter !=
-			    (wl->tx_results_count & 0xff))
-				wl1271_tx_complete(wl);
+			wl1271_rx(wl, &wl->fw_status->common);
 
 			/* Check if any tx blocks were freed */
 			if (!test_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags) &&
@@ -700,7 +697,10 @@ static void wl1271_irq_work(struct work_struct *work)
 				wl1271_tx_work_locked(wl);
 			}
 
-			wl1271_rx(wl, &wl->fw_status->common);
+			/* check for tx results */
+			if (wl->fw_status->common.tx_results_counter !=
+			    (wl->tx_results_count & 0xff))
+				wl1271_tx_complete(wl);
 		}
 
 		if (intr & WL1271_ACX_INTR_EVENT_A) {
-- 
1.7.1

