Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43423 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab1D3PSq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 11:18:46 -0400
Received: by ewy4 with SMTP id 4so1390988ewy.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Apr 2011 08:18:45 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/6] rt2x00: Reduce tx status reading timeout
Date: Sat, 30 Apr 2011 17:13:46 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201104301713.47545.IvDoorn@gmail.com> (sfid-20110430_171848_808402_5C568668)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When no TX status was available, the default timeout
of 20ms is a bit high. The frame is highly likely already
send out, so the TX status should be available within
only a few milliseconds.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 0d4e8fa..e4f82d2 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -134,7 +134,7 @@ static void rt2800usb_tx_sta_fifo_read_completed(struct rt2x00_dev *rt2x00dev,
 	} else if (!kfifo_is_empty(&rt2x00dev->txstatus_fifo)) {
 		queue_work(rt2x00dev->workqueue, &rt2x00dev->txdone_work);
 	} else if (rt2800usb_txstatus_pending(rt2x00dev)) {
-		mod_timer(&rt2x00dev->txstatus_timer, jiffies + msecs_to_jiffies(20));
+		mod_timer(&rt2x00dev->txstatus_timer, jiffies + msecs_to_jiffies(2));
 	}
 }
 
@@ -493,7 +493,7 @@ static void rt2800usb_work_txdone(struct work_struct *work)
 	 * also delayed -> use a timer to retrieve it.
 	 */
 	if (rt2800usb_txstatus_pending(rt2x00dev))
-		mod_timer(&rt2x00dev->txstatus_timer, jiffies + msecs_to_jiffies(20));
+		mod_timer(&rt2x00dev->txstatus_timer, jiffies + msecs_to_jiffies(2));
 }
 
 /*
-- 
1.7.2.3

