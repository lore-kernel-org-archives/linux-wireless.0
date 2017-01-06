Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47540 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033938AbdAFNKE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jan 2017 08:10:04 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Mathias Kresin <dev@kresin.me>
Subject: [PATCH 2/9] rt2800: increase TX timeout
Date: Fri,  6 Jan 2017 14:05:11 +0100
Message-Id: <1483707918-31480-3-git-send-email-sgruszka@redhat.com> (sfid-20170106_141121_216239_0D5C2300)
In-Reply-To: <1483707918-31480-1-git-send-email-sgruszka@redhat.com>
References: <1483707918-31480-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When medium is busy or frames have to be resend, it takes time to send
the frames and get TX status from hardware. For some really bad medium
conditions it can take seconds. Patch change TX status timeout to give
HW more time to provide it, however 500ms is not enough for bad
conditions. In the future this timeout should be removed and replaced
with proper watchdog mechanism.

Increase flush timeout accordingly as well.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c  | 2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00mmio.c | 2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
index 8ec22c0..400f074 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
@@ -123,7 +123,7 @@ static inline bool rt2800usb_entry_txstatus_timeout(struct queue_entry *entry)
 	if (!test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
 		return false;
 
-	tout = time_after(jiffies, entry->last_action + msecs_to_jiffies(100));
+	tout = time_after(jiffies, entry->last_action + msecs_to_jiffies(500));
 	if (unlikely(tout))
 		rt2x00_dbg(entry->queue->rt2x00dev,
 			   "TX status timeout for entry %d in queue %d\n",
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00mmio.c b/drivers/net/wireless/ralink/rt2x00/rt2x00mmio.c
index f0178fd..da38d25 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00mmio.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00mmio.c
@@ -101,7 +101,7 @@ void rt2x00mmio_flush_queue(struct data_queue *queue, bool drop)
 	unsigned int i;
 
 	for (i = 0; !rt2x00queue_empty(queue) && i < 10; i++)
-		msleep(10);
+		msleep(50);
 }
 EXPORT_SYMBOL_GPL(rt2x00mmio_flush_queue);
 
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
index 6005e14..838ca58 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -517,7 +517,7 @@ void rt2x00usb_flush_queue(struct data_queue *queue, bool drop)
 		 * Wait for a little while to give the driver
 		 * the oppurtunity to recover itself.
 		 */
-		msleep(10);
+		msleep(50);
 	}
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_flush_queue);
-- 
2.7.4
