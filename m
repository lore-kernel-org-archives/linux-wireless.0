Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:17967 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbYGUQuL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 12:50:11 -0400
Received: by nf-out-0910.google.com with SMTP id d3so503150nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2008 09:50:09 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Clear queue entry flags during initialization
Date: Mon, 21 Jul 2008 19:06:02 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807211906.02409.IvDoorn@gmail.com> (sfid-20080721_185034_764507_D7B65D0C)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the queues are being initialized the entry flags fields must be
reset to 0. When this does not happen some entries might still be
marked as "occupied" after an ifdown & ifup cycle which would trigger
errors when the entry is being accessed:

	phy0 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 0.
	Please file bug report to http://rt2x00.serialmonkey.com.

This also fixes the mac80211 warning:

	------------[ cut here ]------------
	WARNING: at net/mac80211/tx.c:1238 ieee80211_master_start_xmit+0x30a/0x350 [mac80211]()

which was triggered by the queue error.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
John, please queue for 2.6.27, this one is quite important to reenable
the queues after an ifdown & ifup cycle.

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 7b581a3..3b27f6a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -492,9 +492,12 @@ void rt2x00queue_init_rx(struct rt2x00_dev *rt2x00dev)
 	if (!rt2x00dev->ops->lib->init_rxentry)
 		return;
 
-	for (i = 0; i < queue->limit; i++)
+	for (i = 0; i < queue->limit; i++) {
+		queue->entries[i].flags = 0;
+
 		rt2x00dev->ops->lib->init_rxentry(rt2x00dev,
 						  &queue->entries[i]);
+	}
 }
 
 void rt2x00queue_init_tx(struct rt2x00_dev *rt2x00dev)
@@ -508,9 +511,12 @@ void rt2x00queue_init_tx(struct rt2x00_dev *rt2x00dev)
 		if (!rt2x00dev->ops->lib->init_txentry)
 			continue;
 
-		for (i = 0; i < queue->limit; i++)
+		for (i = 0; i < queue->limit; i++) {
+			queue->entries[i].flags = 0;
+
 			rt2x00dev->ops->lib->init_txentry(rt2x00dev,
 							  &queue->entries[i]);
+		}
 	}
 }
 
