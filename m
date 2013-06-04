Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:38360 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908Ab3FDLlH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 07:41:07 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 04/13] rt2x00: rt2x00queue: setup queue->threshold from queue->limit
Date: Tue,  4 Jun 2013 13:40:41 +0200
Message-Id: <1370346050-7047-5-git-send-email-juhosg@openwrt.org> (sfid-20130604_135936_404743_44A86F84)
In-Reply-To: <1370346050-7047-1-git-send-email-juhosg@openwrt.org>
References: <1370346050-7047-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the queue->limit value instead of the
qdesc->entry_num to compute the threshold.
The two source values are the same and the
data queue descriptor structure will be
removed by a later patch.

Also separate the computation from the rest
of the init code to make further changes
easier.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index c12d1c8..3ae2264 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -1323,11 +1323,12 @@ static void rt2x00queue_init(struct rt2x00_dev *rt2x00dev,
 	BUG_ON(!qdesc);
 
 	queue->limit = qdesc->entry_num;
-	queue->threshold = DIV_ROUND_UP(qdesc->entry_num, 10);
 	queue->data_size = qdesc->data_size;
 	queue->desc_size = qdesc->desc_size;
 	queue->winfo_size = qdesc->winfo_size;
 	queue->priv_size = qdesc->priv_size;
+
+	queue->threshold = DIV_ROUND_UP(queue->limit, 10);
 }
 
 int rt2x00queue_allocate(struct rt2x00_dev *rt2x00dev)
-- 
1.7.10

