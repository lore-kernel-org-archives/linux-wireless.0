Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.186]:45936 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbYBCO4q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 09:56:46 -0500
Received: by fk-out-0910.google.com with SMTP id z23so1587903fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2008 06:56:44 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 12/19] rt2x00: Initialize QID from queue->qid
Date: Sun, 3 Feb 2008 15:52:21 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802031541.52167.IvDoorn@gmail.com>
In-Reply-To: <200802031541.52167.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802031552.21239.IvDoorn@gmail.com> (sfid-20080203_145654_937053_5F7918A3)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The QID_MGMT is assigned to the beacon and atim queue
during initialization. This means we don't need a seperate
check in write_tx_desc()..

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 644a09a..21d8514 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -621,22 +621,12 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 
 	memset(&txdesc, 0, sizeof(txdesc));
 
+	txdesc.queue = skbdesc->entry->queue->qid;
 	txdesc.cw_min = skbdesc->entry->queue->cw_min;
 	txdesc.cw_max = skbdesc->entry->queue->cw_max;
 	txdesc.aifs = skbdesc->entry->queue->aifs;
 
 	/*
-	 * Identify queue
-	 */
-	if (control->queue < rt2x00dev->hw->queues)
-		txdesc.queue = control->queue;
-	else if (control->queue == IEEE80211_TX_QUEUE_BEACON ||
-		 control->queue == IEEE80211_TX_QUEUE_AFTER_BEACON)
-		txdesc.queue = QID_MGMT;
-	else
-		txdesc.queue = QID_OTHER;
-
-	/*
 	 * Read required fields from ieee80211 header.
 	 */
 	frame_control = le16_to_cpu(hdr->frame_control);
-- 
1.5.3.8

