Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41176 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab1C1LhN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 07:37:13 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so2745055wya.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2011 04:37:13 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 13/13] rt2x00: Add an error message when trying to send on a full queue
Date: Mon, 28 Mar 2011 13:35:51 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201103281329.45470.IvDoorn@gmail.com> <201103281334.52023.IvDoorn@gmail.com> <201103281335.23166.IvDoorn@gmail.com>
In-Reply-To: <201103281335.23166.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103281335.53224.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

We already tell mac80211 to stop the queue when we hit a certain
threshold. Hence, it shouldn't happen at all that a frame gets queued
for tx on a full queue. Add an error message for this case.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 5d89259..9fc4a1e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -482,8 +482,11 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 	struct skb_frame_desc *skbdesc;
 	u8 rate_idx, rate_flags;
 
-	if (unlikely(rt2x00queue_full(queue)))
+	if (unlikely(rt2x00queue_full(queue))) {
+		ERROR(queue->rt2x00dev,
+		      "Dropping frame due to full tx queue %d.\n", queue->qid);
 		return -ENOBUFS;
+	}
 
 	if (unlikely(test_and_set_bit(ENTRY_OWNER_DEVICE_DATA,
 				      &entry->flags))) {
-- 
1.7.2.3

