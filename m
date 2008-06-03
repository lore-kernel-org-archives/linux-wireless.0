Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:2074 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYFCSZ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 14:25:57 -0400
Received: by nf-out-0910.google.com with SMTP id d3so644244nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jun 2008 11:25:55 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/11] rt2x00: Fix queue initialization
Date: Tue, 3 Jun 2008 20:29:05 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200806032024.52931.IvDoorn@gmail.com> <200806032028.21795.IvDoorn@gmail.com> <200806032028.39575.IvDoorn@gmail.com>
In-Reply-To: <200806032028.39575.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806032029.05394.IvDoorn@gmail.com> (sfid-20080603_202600_969820_1CC022A6)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

qid should be initialized to QID_BEACON and QID_ATIM
for the beacon and atim quue. This makes checking for
a particular queue much saner, and it shouldn't harm,
because the only places where the value is send to
the hardware, we are allowed to send any value we
want since it is only used as argument in the
TX done register.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index e69ef4b..6f3aa0f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -439,7 +439,8 @@ int rt2x00queue_allocate(struct rt2x00_dev *rt2x00dev)
 	 * TX: qid = QID_AC_BE + index
 	 * TX: cw_min: 2^5 = 32.
 	 * TX: cw_max: 2^10 = 1024.
-	 * BCN & Atim: qid = QID_MGMT
+	 * BCN: qid = QID_BEACON
+	 * ATIM: qid = QID_ATIM
 	 */
 	rt2x00queue_init(rt2x00dev, rt2x00dev->rx, QID_RX);
 
@@ -447,9 +448,9 @@ int rt2x00queue_allocate(struct rt2x00_dev *rt2x00dev)
 	tx_queue_for_each(rt2x00dev, queue)
 		rt2x00queue_init(rt2x00dev, queue, qid++);
 
-	rt2x00queue_init(rt2x00dev, &rt2x00dev->bcn[0], QID_MGMT);
+	rt2x00queue_init(rt2x00dev, &rt2x00dev->bcn[0], QID_BEACON);
 	if (req_atim)
-		rt2x00queue_init(rt2x00dev, &rt2x00dev->bcn[1], QID_MGMT);
+		rt2x00queue_init(rt2x00dev, &rt2x00dev->bcn[1], QID_ATIM);
 
 	return 0;
 }
-- 
1.5.5.3

