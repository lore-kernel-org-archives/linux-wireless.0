Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62576 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482Ab0JKNk2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 09:40:28 -0400
Received: by mail-ew0-f46.google.com with SMTP id 20so574157ewy.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Oct 2010 06:40:27 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/7] rt2x00: Move watchdog work to kernel work_queue
Date: Mon, 11 Oct 2010 15:37:47 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201010111537.26584.IvDoorn@gmail.com>
In-Reply-To: <201010111537.26584.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010111537.48587.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The watchdog function must run on a work_queue
which is independent of any other work inside rt2x00.

The main reasons, being that a broken work on the mac80211
work_queue can otherwise prevent the watchdog to run (while
in fact the watchdog could fix the issue). And on the other
hand because the watchdog relies on the completion of the
completion handlers for RX/TX which for the USB case, occur
on the mac80211 workqueue.

This fixes some "Queue %d failed to flush" errors, which were
caused by the watchdog function waiting on the completion
handler which was scheduled to run right after the watchdog.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h     |    5 +++++
 drivers/net/wireless/rt2x00/rt2x00link.c |    6 ++----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 2322c84..94fe589 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -338,6 +338,11 @@ struct link {
 
 	/*
 	 * Work structure for scheduling periodic watchdog monitoring.
+	 * This work must be scheduled on the kernel workqueue, while
+	 * all other work structures must be queued on the mac80211
+	 * workqueue. This guarantees that the watchdog can schedule
+	 * other work structures and wait for their completion in order
+	 * to bring the device/driver back into the desired state.
 	 */
 	struct delayed_work watchdog_work;
 };
diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index 46836f8..b971d87 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -417,8 +417,7 @@ void rt2x00link_start_watchdog(struct rt2x00_dev *rt2x00dev)
 	    !test_bit(DRIVER_SUPPORT_WATCHDOG, &rt2x00dev->flags))
 		return;
 
-	ieee80211_queue_delayed_work(rt2x00dev->hw,
-				     &link->watchdog_work, WATCHDOG_INTERVAL);
+	schedule_delayed_work(&link->watchdog_work, WATCHDOG_INTERVAL);
 }
 
 void rt2x00link_stop_watchdog(struct rt2x00_dev *rt2x00dev)
@@ -442,8 +441,7 @@ static void rt2x00link_watchdog(struct work_struct *work)
 	rt2x00dev->ops->lib->watchdog(rt2x00dev);
 
 	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
-		ieee80211_queue_delayed_work(rt2x00dev->hw,
-					     &link->watchdog_work, WATCHDOG_INTERVAL);
+		schedule_delayed_work(&link->watchdog_work, WATCHDOG_INTERVAL);
 }
 
 void rt2x00link_register(struct rt2x00_dev *rt2x00dev)
-- 
1.7.2.3

