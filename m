Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59008 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab0KDTny (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 15:43:54 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so1320245eye.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 12:43:54 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 08/13] rt2x00: Remove failsave from rt2x00usb_watchdog_tx_dma
Date: Thu, 4 Nov 2010 20:39:48 +0100
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
References: <201011042037.00178.IvDoorn@gmail.com> <201011042038.57061.IvDoorn@gmail.com> <201011042039.24768.IvDoorn@gmail.com>
In-Reply-To: <201011042039.24768.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011042039.49521.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <IvDoorn@gmail.com>

When the TX status handler failed to clear the queue
in rt2x00usb_watchdog_tx_dma() we shouldn't use a failsave
to use the rt2x00usb txdone handler.

If a driver has overriden the txdone handler it must make
sure the txdone handler is capable of cleaning up the queue itself.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00usb.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 88995d5..6dd9619 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -323,21 +323,6 @@ static void rt2x00usb_watchdog_tx_dma(struct data_queue *queue)
 	rt2x00dev->txdone_work.func(&rt2x00dev->txdone_work);
 
 	/*
-	 * Security measure: if the driver did override the
-	 * txdone_work function, and the hardware did arrive
-	 * in a state which causes it to malfunction, it is
-	 * possible that the driver couldn't handle the txdone
-	 * event correctly. So after giving the driver the
-	 * chance to cleanup, we now force a cleanup of any
-	 * leftovers.
-	 */
-	if (!rt2x00queue_empty(queue)) {
-		WARNING(queue->rt2x00dev, "TX queue %d DMA timed out,"
-			" status handling failed, invoke hard reset", queue->qid);
-		rt2x00usb_work_txdone(&rt2x00dev->txdone_work);
-	}
-
-	/*
 	 * The queue has been reset, and mac80211 is allowed to use the
 	 * queue again.
 	 */
-- 
1.7.2.3

