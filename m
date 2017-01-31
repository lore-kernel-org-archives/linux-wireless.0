Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53874 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751082AbdAaLtA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 06:49:00 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Vishal Thanki <vishalthanki@gmail.com>
Subject: [PATCH v3] rt2x00: avoid introducing a USB dependency in the
Date: Tue, 31 Jan 2017 12:44:10 +0100
Message-Id: <1485863050-24895-1-git-send-email-sgruszka@redhat.com> (sfid-20170131_124903_430945_43EDAC23)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As reported by Felix:

Though protected by an ifdef, introducing an usb symbol dependency in
the rt2x00lib module is a major inconvenience for distributions that
package kernel modules split into individual packages.

Get rid of this unnecessary dependency by calling the usb related
function from a more suitable place.

Cc: Vishal Thanki <vishalthanki@gmail.com>
Reported-by: Felix Fietkau <nbd@nbd.name>
Fixes: 8b4c0009313f ("rt2x00usb: Use usb anchor to manage URB")
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v1 -> v2 do not break shutdown sequence
v2 -> v3 update patch to current kernel version

 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c | 23 ++++++++---------------
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c |  5 +++++
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index 8fcbc8d..4b08007 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -1436,21 +1436,6 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	cancel_work_sync(&rt2x00dev->intf_work);
 	cancel_delayed_work_sync(&rt2x00dev->autowakeup_work);
 	cancel_work_sync(&rt2x00dev->sleep_work);
-#if IS_ENABLED(CONFIG_RT2X00_LIB_USB)
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
@@ -1466,6 +1451,14 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
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
1.8.3.1
