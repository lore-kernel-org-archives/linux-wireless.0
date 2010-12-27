Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38767 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab0L0OII (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Dec 2010 09:08:08 -0500
Received: by wyb28 with SMTP id 28so8482816wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Dec 2010 06:08:06 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 01/10] rt2x00: simplify txstatus_fifo handling
Date: Mon, 27 Dec 2010 15:04:29 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201012271504.30848.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Stezenbach <js@sig21.net>

Signed-off-by: Johannes Stezenbach <js@sig21.net>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   18 ++----------------
 drivers/net/wireless/rt2x00/rt2x00.h    |    2 +-
 2 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index baa1468..aa97971 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -688,14 +688,7 @@ static void rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
 	u32 status;
 	u8 qid;
 
-	while (!kfifo_is_empty(&rt2x00dev->txstatus_fifo)) {
-		/* Now remove the tx status from the FIFO */
-		if (kfifo_out(&rt2x00dev->txstatus_fifo, &status,
-			      sizeof(status)) != sizeof(status)) {
-			WARN_ON(1);
-			break;
-		}
-
+	while (kfifo_get(&rt2x00dev->txstatus_fifo, &status)) {
 		qid = rt2x00_get_field32(status, TX_STA_FIFO_PID_QUEUE);
 		if (qid >= QID_RX) {
 			/*
@@ -803,14 +796,7 @@ static void rt2800pci_txstatus_interrupt(struct rt2x00_dev *rt2x00dev)
 		if (!rt2x00_get_field32(status, TX_STA_FIFO_VALID))
 			break;
 
-		if (kfifo_is_full(&rt2x00dev->txstatus_fifo)) {
-			WARNING(rt2x00dev, "TX status FIFO overrun,"
-				" drop tx status report.\n");
-			break;
-		}
-
-		if (kfifo_in(&rt2x00dev->txstatus_fifo, &status,
-			     sizeof(status)) != sizeof(status)) {
+		if (!kfifo_put(&rt2x00dev->txstatus_fifo, &status)) {
 			WARNING(rt2x00dev, "TX status FIFO overrun,"
 				"drop tx status report.\n");
 			break;
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index c254d5a..af1d3ef 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -908,7 +908,7 @@ struct rt2x00_dev {
 	/*
 	 * FIFO for storing tx status reports between isr and tasklet.
 	 */
-	struct kfifo txstatus_fifo;
+	DECLARE_KFIFO_PTR(txstatus_fifo, u32);
 
 	/*
 	 * Tasklet for processing tx status reports (rt2800pci).
-- 
1.7.2.3

