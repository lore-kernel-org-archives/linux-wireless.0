Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35910 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439Ab0JILgb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Oct 2010 07:36:31 -0400
Received: by mail-ew0-f46.google.com with SMTP id 20so23937ewy.19
        for <linux-wireless@vger.kernel.org>; Sat, 09 Oct 2010 04:36:31 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 04/06] rt2x00: Use unlikely for error case in rt2x00queue_write_tx_frame
Date: Sat, 9 Oct 2010 13:34:43 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201010091333.17274.IvDoorn@gmail.com> <201010091333.45001.IvDoorn@gmail.com> <201010091334.12741.IvDoorn@gmail.com>
In-Reply-To: <201010091334.12741.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010091334.44618.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

This is an error condition that is not supposed to happen. Hence, it is
safe to add unlikely to this check.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 4436ff7..83630f1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -489,7 +489,8 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 	if (unlikely(rt2x00queue_full(queue)))
 		return -ENOBUFS;
 
-	if (test_and_set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags)) {
+	if (unlikely(test_and_set_bit(ENTRY_OWNER_DEVICE_DATA,
+				      &entry->flags))) {
 		ERROR(queue->rt2x00dev,
 		      "Arrived at non-free entry in the non-full queue %d.\n"
 		      "Please file bug report to %s.\n",
-- 
1.7.2.3

