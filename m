Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:45970 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaJADpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 23:45:10 -0400
Received: by mail-ie0-f173.google.com with SMTP id tp5so259147ieb.4
        for <linux-wireless@vger.kernel.org>; Tue, 30 Sep 2014 20:45:09 -0700 (PDT)
From: Mark Asselstine <asselsm@gmail.com>
To: helmut.schaa@googlemail.com, sgruszka@redhat.com
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: [PATCH] rt2x00: rt2x00queue: avoid using more headroom then driver requested
Date: Tue, 30 Sep 2014 23:45:57 -0400
Message-Id: <1412135157-13520-1-git-send-email-asselsm@gmail.com> (sfid-20141001_054524_238940_CDF0DEEC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

'struct ieee80211_hw' contains 'extra_tx_headroom' which it defines as
"headroom to reserve in each transmit skb for use by the driver". This
value is properly setup during rt2x00lib_probe_hw() to account for all
the rt2x00lib's purposes, including DMA alignment and L2 pad if
needed. As such under all circumstances the proper amount of headroom
is allocated to a skb such that under any usage we would not ever use
more headroom then is allotted.

However rt2x00queue_write_tx_frame() uses up the headroom (via calls
to skb_push) allotted for L2 padding (with a potential call to
rt2x00queue_insert_l2pad()) and uses up the headroom allotted to DMA
alignment (with a potential call to rt2x00queue_align_frame()) and
then proceeds to use up 'extra_tx_headroom' (in a call to
rt2x00queue_write_tx_data())

So the driver has requested just 'extra_tx_headroom' worth of headroom
and we have used up 'extra_tx_headroom' + DMA + L2PAD worth. As such
it is possible to hit a 'skb_under_panic', where we have used up all
the available headroom.

Since extra_tx_headroom was calculated as a function of winfo_size,
desc_size, RT2X00_L2PAD_SIZE and RT2X00_ALIGN_SIZE we can simply
remove the part for alignment and padding and we will know how much is
left to use up (for txdesc) and only use that much. Keeping the
driver's use of headroom to what it requested via extra_tx_headroom.

Signed-off-by: Mark Asselstine <asselsm@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 8e68f87..2a48bf5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -522,6 +522,7 @@ static int rt2x00queue_write_tx_data(struct queue_entry *entry,
 				     struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	unsigned int avail_extra_tx_headroom = rt2x00dev->extra_tx_headroom;
 
 	/*
 	 * This should not happen, we already checked the entry
@@ -538,10 +539,18 @@ static int rt2x00queue_write_tx_data(struct queue_entry *entry,
 	}
 
 	/*
-	 * Add the requested extra tx headroom in front of the skb.
+	 * Add room for data at the front of the buffer for txdesc. The space
+	 * needed for this was accounted for in extra_tx_headroom, we just
+	 * need to remove the amount allocated for padding and alignment
+	 * to get what is left for txdesc.
 	 */
-	skb_push(entry->skb, rt2x00dev->extra_tx_headroom);
-	memset(entry->skb->data, 0, rt2x00dev->extra_tx_headroom);
+	if (test_bit(REQUIRE_L2PAD, &rt2x00dev->cap_flags))
+		avail_extra_tx_headroom -= RT2X00_L2PAD_SIZE;
+	else if (test_bit(REQUIRE_DMA, &rt2x00dev->cap_flags))
+		avail_extra_tx_headroom -= RT2X00_ALIGN_SIZE;
+
+	skb_push(entry->skb, avail_extra_tx_headroom);
+	memset(entry->skb->data, 0, avail_extra_tx_headroom);
 
 	/*
 	 * Call the driver's write_tx_data function, if it exists.
-- 
1.9.1

