Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757572Ab2CSIkI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 04:40:08 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Jakub Kicinski <moorray@wp.pl>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] rt2x00: rt2800usb: schedule txdone work on timeout
Date: Mon, 19 Mar 2012 09:39:45 +0100
Message-Id: <1332146385-10330-1-git-send-email-sgruszka@redhat.com> (sfid-20120319_094012_650981_EFE9496A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is fix for my current commit
ed61e2b02027935520d1be884fac0b2ffce8379a
"rt2x00: rt2800usb: rework txdone code"

We should schedule txdone work on timeout, otherwise if newer get
tx status from hardware, we will never report tx status to mac80211
and eventually never wakeup tx queue.

Reported-by: Jakub Kicinski <moorray@wp.pl>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index cd490ab..f97f846 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -163,7 +163,13 @@ static bool rt2800usb_tx_sta_fifo_read_completed(struct rt2x00_dev *rt2x00dev,
 
 		/* Reschedule urb to read TX status again instantly */
 		return true;
-	} else if (rt2800usb_txstatus_pending(rt2x00dev)) {
+	}
+
+	/* Check if there is any entry that timedout waiting on TX status */
+	if (rt2800usb_txstatus_timeout(rt2x00dev))
+		queue_work(rt2x00dev->workqueue, &rt2x00dev->txdone_work);
+
+	if (rt2800usb_txstatus_pending(rt2x00dev)) {
 		/* Read register after 250 us */
 		hrtimer_start(&rt2x00dev->txstatus_timer, ktime_set(0, 250000),
 			      HRTIMER_MODE_REL);
-- 
1.7.1

