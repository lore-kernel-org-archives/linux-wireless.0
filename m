Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.186]:28570 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbYBJVxe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 16:53:34 -0500
Received: by mu-out-0910.google.com with SMTP id i10so5147467mue.5
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2008 13:53:32 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 04/14] rt2x00: correct address calc for queue private data
Date: Sun, 10 Feb 2008 22:48:19 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802102246.04515.IvDoorn@gmail.com>
In-Reply-To: <200802102246.04515.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802102248.19392.IvDoorn@gmail.com> (sfid-20080210_215336_893196_E10D9CFA)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Adam Baker <linux@baker-net.org.uk>

When calculating the offset to add to the queue entry base to get the
individual entry's private data area the base address must be treated
as a char * not a struct queue_entry so we can do byte oriented
pointer arithmetic with it.

Signed-off-by: Adam Baker <linux@baker-net.org.uk>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index fde64ea..943afc9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -160,7 +160,8 @@ static int rt2x00queue_alloc_entries(struct data_queue *queue,
 		return -ENOMEM;
 
 #define QUEUE_ENTRY_PRIV_OFFSET(__base, __index, __limit, __esize, __psize) \
-	( (__base) + ((__limit) * (__esize)) + ((__index) * (__psize)) )
+	( ((char *)(__base)) + ((__limit) * (__esize)) + \
+	    ((__index) * (__psize)) )
 
 	for (i = 0; i < queue->limit; i++) {
 		entries[i].flags = 0;
-- 
1.5.4

