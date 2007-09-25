Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:30041 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbXIYSoe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 14:44:34 -0400
Received: by nf-out-0910.google.com with SMTP id g13so1757580nfb
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2007 11:44:33 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/12] rt2x00: Correct error in calculating rssi for link tuner
Date: Tue, 25 Sep 2007 20:53:20 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709252052.34803.IvDoorn@gmail.com>
In-Reply-To: <200709252052.34803.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200709252053.20668.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The call to rt2x00lib_precalculate_link_signal resets link.rx_success which is needed
when calculating the average rssi for the link tuner. Change the call order so the link
tuner runs first as it doesn't need the result of the precalculate.

Signed-off-by: Adam Baker <linux@baker-net.org.uk>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index cd82eef..5780d6a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -240,8 +240,6 @@ static void rt2x00lib_link_tuner(struct work_struct *work)
 	rt2x00dev->low_level_stats.dot11FCSErrorCount +=
 	    rt2x00dev->link.rx_failed;
 
-	rt2x00lib_precalculate_link_signal(&rt2x00dev->link);
-
 	/*
 	 * Only perform the link tuning when Link tuning
 	 * has been enabled (This could have been disabled from the EEPROM).
@@ -250,6 +248,12 @@ static void rt2x00lib_link_tuner(struct work_struct *work)
 		rt2x00dev->ops->lib->link_tuner(rt2x00dev);
 
 	/*
+	 * Precalculate a portion of the link signal which is
+	 * in based on the tx/rx success/failure counters.
+	 */
+	rt2x00lib_precalculate_link_signal(&rt2x00dev->link);
+
+	/*
 	 * Increase tuner counter, and reschedule the next link tuner run.
 	 */
 	rt2x00dev->link.count++;
-- 
1.5.3.2

