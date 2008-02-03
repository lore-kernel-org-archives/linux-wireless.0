Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.226]:4578 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbYBCO5B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 09:57:01 -0500
Received: by wx-out-0506.google.com with SMTP id h31so2272846wxd.4
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2008 06:56:55 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 18/19] rt2x00: Fix queue index handling
Date: Sun, 3 Feb 2008 15:55:21 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802031541.52167.IvDoorn@gmail.com>
In-Reply-To: <200802031541.52167.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802031555.21297.IvDoorn@gmail.com> (sfid-20080203_145706_127363_65BB212A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When Q_INDEX is increased, the queue->length should be increased,
only when Q_INDEX_DONE is increased should queue_length be descreased.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 52bb57d..fde64ea 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -84,8 +84,12 @@ void rt2x00queue_index_inc(struct data_queue *queue, enum queue_index index)
 	if (queue->index[index] >= queue->limit)
 		queue->index[index] = 0;
 
-	queue->length--;
-	queue->count += (index == Q_INDEX_DONE);
+	if (index == Q_INDEX) {
+		queue->length++;
+	} else if (index == Q_INDEX_DONE) {
+		queue->length--;
+		queue->count ++;
+	}
 
 	spin_unlock(&queue->lock);
 }
-- 
1.5.3.8

