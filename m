Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:42514 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620Ab0LMLkU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 06:40:20 -0500
Received: by eyg5 with SMTP id 5so4064829eyg.2
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 03:40:19 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 07/17] rt2x00: trivial: add missing \n on warnings
Date: Mon, 13 Dec 2010 12:34:00 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201012131231.28313.IvDoorn@gmail.com> <201012131233.13651.IvDoorn@gmail.com> <201012131233.37326.IvDoorn@gmail.com>
In-Reply-To: <201012131233.37326.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012131234.01095.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Stezenbach <js@sig21.net>

Signed-off-by: Johannes Stezenbach <js@sig21.net>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    6 +++---
 drivers/net/wireless/rt2x00/rt2800usb.c |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00mac.c |    2 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c |    4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index bea8352..2b68009 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -686,7 +686,7 @@ static void rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
 			 * this tx status.
 			 */
 			WARNING(rt2x00dev, "Got TX status report with "
-					   "unexpected pid %u, dropping", qid);
+					   "unexpected pid %u, dropping\n", qid);
 			break;
 		}
 
@@ -697,7 +697,7 @@ static void rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
 			 * processing here and drop the tx status
 			 */
 			WARNING(rt2x00dev, "Got TX status for an unavailable "
-					   "queue %u, dropping", qid);
+					   "queue %u, dropping\n", qid);
 			break;
 		}
 
@@ -707,7 +707,7 @@ static void rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
 			 * and drop the tx status.
 			 */
 			WARNING(rt2x00dev, "Got TX status for an empty "
-					   "queue %u, dropping", qid);
+					   "queue %u, dropping\n", qid);
 			break;
 		}
 
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index a150fcc..1dfa59d 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -253,7 +253,7 @@ static void rt2800usb_watchdog(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_read(rt2x00dev, TXRXQ_PCNT, &reg);
 	if (rt2x00_get_field32(reg, TXRXQ_PCNT_TX0Q)) {
 		WARNING(rt2x00dev, "TX HW queue 0 timed out,"
-			" invoke forced kick");
+			" invoke forced kick\n");
 
 		rt2800_register_write(rt2x00dev, PBF_CFG, 0xf40012);
 
@@ -269,7 +269,7 @@ static void rt2800usb_watchdog(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_read(rt2x00dev, TXRXQ_PCNT, &reg);
 	if (rt2x00_get_field32(reg, TXRXQ_PCNT_TX1Q)) {
 		WARNING(rt2x00dev, "TX HW queue 1 timed out,"
-			" invoke forced kick");
+			" invoke forced kick\n");
 
 		rt2800_register_write(rt2x00dev, PBF_CFG, 0xf4000a);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 829bf4b..7ad4b27 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -745,7 +745,7 @@ void rt2x00mac_flush(struct ieee80211_hw *hw, bool drop)
 		}
 
 		if (!rt2x00queue_empty(queue))
-			WARNING(rt2x00dev, "Failed to flush queue %d", queue->qid);
+			WARNING(rt2x00dev, "Failed to flush queue %d\n", queue->qid);
 	}
 
 	ieee80211_wake_queues(hw);
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 3a6c83e..608200e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -300,7 +300,7 @@ static void rt2x00usb_watchdog_tx_dma(struct data_queue *queue)
 	unsigned short threshold = queue->threshold;
 
 	WARNING(queue->rt2x00dev, "TX queue %d DMA timed out,"
-		" invoke forced forced reset", queue->qid);
+		" invoke forced forced reset\n", queue->qid);
 
 	/*
 	 * Temporarily disable the TX queue, this will force mac80211
@@ -335,7 +335,7 @@ static void rt2x00usb_watchdog_tx_dma(struct data_queue *queue)
 static void rt2x00usb_watchdog_tx_status(struct data_queue *queue)
 {
 	WARNING(queue->rt2x00dev, "TX queue %d status timed out,"
-		" invoke forced tx handler", queue->qid);
+		" invoke forced tx handler\n", queue->qid);
 
 	ieee80211_queue_work(queue->rt2x00dev->hw, &queue->rt2x00dev->txdone_work);
 }
-- 
1.7.2.3

