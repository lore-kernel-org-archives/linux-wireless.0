Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:34467 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbbDFUVH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Apr 2015 16:21:07 -0400
Received: by widjs5 with SMTP id js5so525543wid.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Apr 2015 13:21:06 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH] staging: vt6655: device_intr check for vif on while loop
Date: Mon,  6 Apr 2015 21:19:48 +0100
Message-Id: <1428351588-3785-1-git-send-email-tvboxspy@gmail.com> (sfid-20150406_222114_175852_AACD0E8F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

vif should never be or go null while in loop.

Fixes race condition where interrupts are late and when
interface is not present.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 4bb4f8e..5b3de43 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1090,7 +1090,7 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 	 * update ISR counter
 	 */
 	STAvUpdate802_11Counter(&pDevice->s802_11Counter, &pDevice->scStatistic, dwMIBCounter);
-	while (pDevice->dwIsr != 0) {
+	while (pDevice->dwIsr && pDevice->vif) {
 		STAvUpdateIsrStatCounter(&pDevice->scStatistic, pDevice->dwIsr);
 		MACvWriteISR(pDevice->PortOffset, pDevice->dwIsr);
 
@@ -1102,8 +1102,7 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 		}
 
 		if (pDevice->dwIsr & ISR_TBTT) {
-			if (pDevice->vif &&
-			    pDevice->op_mode != NL80211_IFTYPE_ADHOC)
+			if (pDevice->op_mode != NL80211_IFTYPE_ADHOC)
 				vnt_check_bb_vga(pDevice);
 
 			pDevice->bBeaconSent = false;
@@ -1143,19 +1142,15 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 			max_count += device_tx_srv(pDevice, TYPE_AC0DMA);
 
 		if (pDevice->dwIsr & ISR_SOFTTIMER1) {
-			if (pDevice->vif) {
-				if (pDevice->vif->bss_conf.enable_beacon)
-					vnt_beacon_make(pDevice, pDevice->vif);
-			}
+			if (pDevice->vif->bss_conf.enable_beacon)
+				vnt_beacon_make(pDevice, pDevice->vif);
 		}
 
 		/* If both buffers available wake the queue */
-		if (pDevice->vif) {
-			if (AVAIL_TD(pDevice, TYPE_TXDMA0) &&
-			    AVAIL_TD(pDevice, TYPE_AC0DMA) &&
-			    ieee80211_queue_stopped(pDevice->hw, 0))
-				ieee80211_wake_queues(pDevice->hw);
-		}
+		if (AVAIL_TD(pDevice, TYPE_TXDMA0) &&
+		    AVAIL_TD(pDevice, TYPE_AC0DMA) &&
+		    ieee80211_queue_stopped(pDevice->hw, 0))
+			ieee80211_wake_queues(pDevice->hw);
 
 		MACvReadISR(pDevice->PortOffset, &pDevice->dwIsr);
 
-- 
2.1.0

