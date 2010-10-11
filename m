Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62576 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab0JKNki (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 09:40:38 -0400
Received: by mail-ew0-f46.google.com with SMTP id 20so574157ewy.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Oct 2010 06:40:38 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 6/7] rt2x00: Don't perform watchdog checks on empty queue
Date: Mon, 11 Oct 2010 15:39:04 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201010111537.26584.IvDoorn@gmail.com> <201010111538.27633.IvDoorn@gmail.com> <201010111538.46136.IvDoorn@gmail.com>
In-Reply-To: <201010111538.46136.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010111539.05518.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The currently used watchdog functions cannot be applied
to empty queues.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2x00usb.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 769c534..89d77f5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -363,10 +363,12 @@ void rt2x00usb_watchdog(struct rt2x00_dev *rt2x00dev)
 	struct data_queue *queue;
 
 	tx_queue_for_each(rt2x00dev, queue) {
-		if (rt2x00queue_dma_timeout(queue))
-			rt2x00usb_watchdog_tx_dma(queue);
-		if (rt2x00queue_timeout(queue))
-			rt2x00usb_watchdog_tx_status(queue);
+		if (!rt2x00queue_empty(queue)) {
+			if (rt2x00queue_dma_timeout(queue))
+				rt2x00usb_watchdog_tx_dma(queue);
+			if (rt2x00queue_timeout(queue))
+				rt2x00usb_watchdog_tx_status(queue);
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_watchdog);
-- 
1.7.2.3

