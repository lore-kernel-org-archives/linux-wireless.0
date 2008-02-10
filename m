Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:38996 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbYBJVxy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 16:53:54 -0500
Received: by fk-out-0910.google.com with SMTP id z23so4239380fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2008 13:53:53 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 11/14] rt2x00: Fix queue->qid initialization
Date: Sun, 10 Feb 2008 22:51:41 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802102246.04515.IvDoorn@gmail.com>
In-Reply-To: <200802102246.04515.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802102251.41440.IvDoorn@gmail.com> (sfid-20080210_215356_912616_890AA929)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As Adam Baker reported the queue->qid was not initialized
correctly. The QID_AC_BE was assigned to the RX ring.

This will move the queue initialization into a seperate function
and makes sure that all queues are initialized directly with the
correct qids.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |   33 +++++++++++++++-------------
 1 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 943afc9..9188323 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -228,6 +228,18 @@ void rt2x00queue_uninitialize(struct rt2x00_dev *rt2x00dev)
 	}
 }
 
+static void rt2x00queue_init(struct rt2x00_dev *rt2x00dev,
+			     struct data_queue *queue, enum data_queue_qid qid)
+{
+	spin_lock_init(&queue->lock);
+
+	queue->rt2x00dev = rt2x00dev;
+	queue->qid = qid;
+	queue->aifs = 2;
+	queue->cw_min = 5;
+	queue->cw_max = 10;
+}
+
 int rt2x00queue_allocate(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue;
@@ -265,24 +277,15 @@ int rt2x00queue_allocate(struct rt2x00_dev *rt2x00dev)
 	 * TX: cw_max: 2^10 = 1024.
 	 * BCN & Atim: qid = QID_MGMT
 	 */
-	qid = QID_AC_BE;
-	queue_for_each(rt2x00dev, queue) {
-		spin_lock_init(&queue->lock);
+	rt2x00queue_init(rt2x00dev, rt2x00dev->rx, QID_RX);
 
-		queue->rt2x00dev = rt2x00dev;
-		queue->qid = qid++;
-		queue->aifs = 2;
-		queue->cw_min = 5;
-		queue->cw_max = 10;
-	}
+	qid = QID_AC_BE;
+	tx_queue_for_each(rt2x00dev, queue)
+		rt2x00queue_init(rt2x00dev, queue, qid++);
 
-	/*
-	 * Fix non-TX data qid's
-	 */
-	rt2x00dev->rx->qid = QID_RX;
-	rt2x00dev->bcn[0].qid = QID_MGMT;
+	rt2x00queue_init(rt2x00dev, &rt2x00dev->bcn[0], QID_MGMT);
 	if (req_atim)
-		rt2x00dev->bcn[1].qid = QID_MGMT;
+		rt2x00queue_init(rt2x00dev, &rt2x00dev->bcn[1], QID_MGMT);
 
 	return 0;
 }
-- 
1.5.4

