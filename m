Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34012 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932774AbdA0ORK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 09:17:10 -0500
Date: Fri, 27 Jan 2017 15:14:16 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, vishalthanki@gmail.com, nbd@nbd.name
Subject: [PATCH v2] rt2x00: avoid introducing a USB dependency in the
 rt2x00lib module
Message-ID: <20170127141416.GA6491@redhat.com> (sfid-20170127_151819_257821_4D360722)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As reported by Felix:

Though protected by an ifdef, introducing an usb symbol dependency in
the rt2x00lib module is a major inconvenience for distributions that
package kernel modules split into individual packages.

Get rid of this unnecessary dependency by calling the usb related
function from a more suitable place.

Reported-by: Felix Fietkau <nbd@nbd.name>
Fixes: 8b4c0009313f ("rt2x00usb: Use usb anchor to manage URB")
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c |   23 ++++++++---------------
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c |    5 +++++
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index e464bdc..c0a66af 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -1417,21 +1417,6 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	cancel_work_sync(&rt2x00dev->intf_work);
 	cancel_delayed_work_sync(&rt2x00dev->autowakeup_work);
 	cancel_work_sync(&rt2x00dev->sleep_work);
-#ifdef CONFIG_RT2X00_LIB_USB
-	if (rt2x00_is_usb(rt2x00dev)) {
-		usb_kill_anchored_urbs(rt2x00dev->anchor);
-		hrtimer_cancel(&rt2x00dev->txstatus_timer);
-		cancel_work_sync(&rt2x00dev->rxdone_work);
-		cancel_work_sync(&rt2x00dev->txdone_work);
-	}
-#endif
-	if (rt2x00dev->workqueue)
-		destroy_workqueue(rt2x00dev->workqueue);
-
-	/*
-	 * Free the tx status fifo.
-	 */
-	kfifo_free(&rt2x00dev->txstatus_fifo);
 
 	/*
 	 * Kill the tx status tasklet.
@@ -1447,6 +1432,14 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	 */
 	rt2x00lib_uninitialize(rt2x00dev);
 
+	if (rt2x00dev->workqueue)
+		destroy_workqueue(rt2x00dev->workqueue);
+
+	/*
+	 * Free the tx status fifo.
+	 */
+	kfifo_free(&rt2x00dev->txstatus_fifo);
+
 	/*
 	 * Free extra components
 	 */
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
index 838ca58..5a2bf9f 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -744,6 +744,11 @@ void rt2x00usb_uninitialize(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue;
 
+	usb_kill_anchored_urbs(rt2x00dev->anchor);
+	hrtimer_cancel(&rt2x00dev->txstatus_timer);
+	cancel_work_sync(&rt2x00dev->rxdone_work);
+	cancel_work_sync(&rt2x00dev->txdone_work);
+
 	queue_for_each(rt2x00dev, queue)
 		rt2x00usb_free_entries(queue);
 }
-- 
1.7.1
