Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:1892 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbYFPRoy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 13:44:54 -0400
Received: by wa-out-1112.google.com with SMTP id j37so4408775waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jun 2008 10:44:54 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 8/9] rt2x00: Increase queue size
Date: Mon, 16 Jun 2008 19:57:40 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200806161954.04241.IvDoorn@gmail.com> <200806161956.54342.IvDoorn@gmail.com> <200806161957.11757.IvDoorn@gmail.com>
In-Reply-To: <200806161957.11757.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806161957.40959.IvDoorn@gmail.com> (sfid-20080616_194505_784514_C53C428D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without the preallocated DMA we can now safely increase
the queue size withotu negative impact on the memory
requirements of rt2x00.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.h |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 14ce8d4..5dd9cca 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -42,15 +42,18 @@
 /**
  * DOC: Number of entries per queue
  *
- * After research it was concluded that 12 entries in a RX and TX
- * queue would be sufficient. Although this is almost one third of
- * the amount the legacy driver allocated, the queues aren't getting
- * filled to the maximum even when working with the maximum rate.
+ * Under normal load without fragmentation 12 entries are sufficient
+ * without the queue being filled up to the maximum. When using fragmentation
+ * and the queue threshold code we need to add some additional margins to
+ * make sure the queue will never (or only under extreme load) fill up
+ * completely.
+ * Since we don't use preallocated DMA having a large number of queue entries
+ * will have only minimal impact on the memory requirements for the queue.
  */
-#define RX_ENTRIES	12
-#define TX_ENTRIES	12
+#define RX_ENTRIES	24
+#define TX_ENTRIES	24
 #define BEACON_ENTRIES	1
-#define ATIM_ENTRIES	1
+#define ATIM_ENTRIES	8
 
 /**
  * enum data_queue_qid: Queue identification
-- 
1.5.5.4

