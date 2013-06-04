Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:38345 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab3FDLlF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 07:41:05 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 02/13] rt2x00: rt2x00queue: remove qdesc parameter of rt2x00queue_alloc_entries
Date: Tue,  4 Jun 2013 13:40:39 +0200
Message-Id: <1370346050-7047-3-git-send-email-juhosg@openwrt.org> (sfid-20130604_134109_030685_31783492)
In-Reply-To: <1370346050-7047-1-git-send-email-juhosg@openwrt.org>
References: <1370346050-7047-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The qdesc parameter is not used anymore, so remove that.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 7f938a5..c12d1c8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -1161,8 +1161,7 @@ void rt2x00queue_init_queues(struct rt2x00_dev *rt2x00dev)
 	}
 }
 
-static int rt2x00queue_alloc_entries(struct data_queue *queue,
-				     const struct data_queue_desc *qdesc)
+static int rt2x00queue_alloc_entries(struct data_queue *queue)
 {
 	struct queue_entry *entries;
 	unsigned int entry_size;
@@ -1231,23 +1230,22 @@ int rt2x00queue_initialize(struct rt2x00_dev *rt2x00dev)
 	struct data_queue *queue;
 	int status;
 
-	status = rt2x00queue_alloc_entries(rt2x00dev->rx, rt2x00dev->ops->rx);
+	status = rt2x00queue_alloc_entries(rt2x00dev->rx);
 	if (status)
 		goto exit;
 
 	tx_queue_for_each(rt2x00dev, queue) {
-		status = rt2x00queue_alloc_entries(queue, rt2x00dev->ops->tx);
+		status = rt2x00queue_alloc_entries(queue);
 		if (status)
 			goto exit;
 	}
 
-	status = rt2x00queue_alloc_entries(rt2x00dev->bcn, rt2x00dev->ops->bcn);
+	status = rt2x00queue_alloc_entries(rt2x00dev->bcn);
 	if (status)
 		goto exit;
 
 	if (test_bit(REQUIRE_ATIM_QUEUE, &rt2x00dev->cap_flags)) {
-		status = rt2x00queue_alloc_entries(rt2x00dev->atim,
-						   rt2x00dev->ops->atim);
+		status = rt2x00queue_alloc_entries(rt2x00dev->atim);
 		if (status)
 			goto exit;
 	}
-- 
1.7.10

