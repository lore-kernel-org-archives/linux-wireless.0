Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35605 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab1CCSsT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 13:48:19 -0500
Received: by wyg36 with SMTP id 36so1356532wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 10:48:17 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 02/19] rt2x00: Make use of unlikely during tx status processing
Date: Thu, 3 Mar 2011 19:39:27 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201103031938.56423.IvDoorn@gmail.com>
In-Reply-To: <201103031938.56423.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103031939.28091.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

These conditions are unlikely to happen, tell the compiler.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index a768deb..9dbb598 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -726,7 +726,7 @@ static void rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
 
 	while (kfifo_get(&rt2x00dev->txstatus_fifo, &status)) {
 		qid = rt2x00_get_field32(status, TX_STA_FIFO_PID_QUEUE);
-		if (qid >= QID_RX) {
+		if (unlikely(qid >= QID_RX)) {
 			/*
 			 * Unknown queue, this shouldn't happen. Just drop
 			 * this tx status.
@@ -747,7 +747,7 @@ static void rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
 			break;
 		}
 
-		if (rt2x00queue_empty(queue)) {
+		if (unlikely(rt2x00queue_empty(queue))) {
 			/*
 			 * The queue is empty. Stop processing here
 			 * and drop the tx status.
-- 
1.7.2.3

