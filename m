Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39060 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab1IGSLj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 14:11:39 -0400
Received: by ewy4 with SMTP id 4so274569ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Sep 2011 11:11:37 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/5] rt2x00: Minor optimizazion in txdone path
Date: Wed, 7 Sep 2011 20:10:02 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201109072010.04023.IvDoorn@gmail.com> (sfid-20110907_201142_497662_D428FA3A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

We can save an indirect function call + some instructions for fetching
the actual function pointer by passing the driver specific txwi pointer
directly from rt2800pci/rt2800usb to rt2800lib instead of using the
rt2800_drv_get_txwi callback.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---

 drivers/net/wireless/rt2x00/rt2800lib.c |    4 +---
 drivers/net/wireless/rt2x00/rt2800lib.h |    2 +-
 drivers/net/wireless/rt2x00/rt2800pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2800usb.c |    3 ++-
 4 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 775e996..ba626a9 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -601,7 +601,7 @@ void rt2800_process_rxwi(struct queue_entry *entry,
 }
 EXPORT_SYMBOL_GPL(rt2800_process_rxwi);
 
-void rt2800_txdone_entry(struct queue_entry *entry, u32 status)
+void rt2800_txdone_entry(struct queue_entry *entry, u32 status, __le32 *txwi)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
@@ -609,13 +609,11 @@ void rt2800_txdone_entry(struct queue_entry *entry, u32 status)
 	u32 word;
 	u16 mcs, real_mcs;
 	int aggr, ampdu;
-	__le32 *txwi;
 
 	/*
 	 * Obtain the status about this packet.
 	 */
 	txdesc.flags = 0;
-	txwi = rt2800_drv_get_txwi(entry);
 	rt2x00_desc_read(txwi, 0, &word);
 
 	mcs = rt2x00_get_field32(word, TXWI_W0_MCS);
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index b851847..7a2511f 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -152,7 +152,7 @@ void rt2800_write_tx_data(struct queue_entry *entry,
 			  struct txentry_desc *txdesc);
 void rt2800_process_rxwi(struct queue_entry *entry, struct rxdone_entry_desc *txdesc);
 
-void rt2800_txdone_entry(struct queue_entry *entry, u32 status);
+void rt2800_txdone_entry(struct queue_entry *entry, u32 status, __le32* txwi);
 
 void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc);
 void rt2800_clear_beacon(struct queue_entry *entry);
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 4fd6649..2633628 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -760,7 +760,7 @@ static bool rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
 		}
 
 		entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
-		rt2800_txdone_entry(entry, status);
+		rt2800_txdone_entry(entry, status, rt2800pci_get_txwi(entry));
 
 		if (--max_tx_done == 0)
 			break;
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 42f511b..0015526 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -542,7 +542,8 @@ static void rt2800usb_txdone(struct rt2x00_dev *rt2x00dev)
 		}
 
 		if (entry)
-			rt2800_txdone_entry(entry, reg);
+			rt2800_txdone_entry(entry, reg,
+				            rt2800usb_get_txwi(entry));
 	}
 }
 
-- 
1.7.3.4
