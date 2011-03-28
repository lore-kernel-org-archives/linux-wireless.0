Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58041 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1C1Lgu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 07:36:50 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so3686803wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2011 04:36:50 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 03/13] rt2x00: Calculate tx status fifo size instead of hardcoding it
Date: Mon, 28 Mar 2011 13:30:36 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201103281329.45470.IvDoorn@gmail.com> <201103281330.10560.IvDoorn@gmail.com>
In-Reply-To: <201103281330.10560.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103281330.36856.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Instead of hardcoding the tx status fifo size as 512 calculate it based
on the number of tx queues and the number of entries per queue. Also
round the size up to a power of 2 as kfifo would otherwise round it
down.

On rt2800pci this will increase the kfifo size from 512 bytes to 1024
bytes which is then able to hold the tx status for all entries in all
tx queues.

Furthermore, if the number of tx queues or tx entries changes in the
future (use of the MGMT queue for example) the kfifo size doesn't need
to be updated.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 9de9dbe..d63b582 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -27,6 +27,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/log2.h>
 
 #include "rt2x00.h"
 #include "rt2x00lib.h"
@@ -811,13 +812,18 @@ static int rt2x00lib_probe_hw(struct rt2x00_dev *rt2x00dev)
 	 */
 	if (test_bit(DRIVER_REQUIRE_TXSTATUS_FIFO, &rt2x00dev->flags)) {
 		/*
-		 * Allocate txstatus fifo and tasklet, we use a size of 512
-		 * for the kfifo which is big enough to store 512/4=128 tx
-		 * status reports. In the worst case (tx status for all tx
-		 * queues gets reported before we've got a chance to handle
-		 * them) 24*4=384 tx status reports need to be cached.
+		 * Allocate the txstatus fifo. In the worst case the tx
+		 * status fifo has to hold the tx status of all entries
+		 * in all tx queues. Hence, calculate the kfifo size as
+		 * tx_queues * entry_num and round up to the nearest
+		 * power of 2.
 		 */
-		status = kfifo_alloc(&rt2x00dev->txstatus_fifo, 512,
+		int kfifo_size =
+			roundup_pow_of_two(rt2x00dev->ops->tx_queues *
+					   rt2x00dev->ops->tx->entry_num *
+					   sizeof(u32));
+
+		status = kfifo_alloc(&rt2x00dev->txstatus_fifo, kfifo_size,
 				     GFP_KERNEL);
 		if (status)
 			return status;
-- 
1.7.2.3

