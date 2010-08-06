Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50196 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761821Ab0HFStz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 14:49:55 -0400
Received: by mail-ey0-f174.google.com with SMTP id 25so2902634eya.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Aug 2010 11:49:55 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/7] rt2x00: Add helper function for reporting tx status
Date: Fri, 6 Aug 2010 20:46:53 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <201008062045.05288.IvDoorn@gmail.com> <201008062045.39547.IvDoorn@gmail.com> <201008062046.19946.IvDoorn@gmail.com>
In-Reply-To: <201008062046.19946.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008062046.54483.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At some points, some drivers can't report the full TX status
information. This can happen for the UNKNOWN state, or the
FAILURE state (in case the URB failed).
Add a wrapper function to simplify reporting the
empty TX information.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |    1 +
 drivers/net/wireless/rt2x00/rt2x00dev.c |   12 ++++++++++++
 drivers/net/wireless/rt2x00/rt2x00usb.c |   10 ++--------
 drivers/net/wireless/rt2x00/rt61pci.c   |    6 +-----
 4 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 5276c19..edfc2b7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1078,6 +1078,7 @@ void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev);
 void rt2x00lib_pretbtt(struct rt2x00_dev *rt2x00dev);
 void rt2x00lib_txdone(struct queue_entry *entry,
 		      struct txdone_entry_desc *txdesc);
+void rt2x00lib_txdone_noinfo(struct queue_entry *entry, u32 status);
 void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
 		      struct queue_entry *entry);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 94621bd..6499cc4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -408,6 +408,18 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_txdone);
 
+void rt2x00lib_txdone_noinfo(struct queue_entry *entry, u32 status)
+{
+	struct txdone_entry_desc txdesc;
+
+	txdesc.flags = 0;
+	__set_bit(status, &txdesc.flags);
+	txdesc.retry = 0;
+
+	rt2x00lib_txdone(entry, &txdesc);
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_txdone_noinfo);
+
 static int rt2x00lib_rxdone_read_signal(struct rt2x00_dev *rt2x00dev,
 					struct rxdone_entry_desc *rxdesc)
 {
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 3f13101..f76014f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -170,8 +170,6 @@ EXPORT_SYMBOL_GPL(rt2x00usb_regbusy_read);
  */
 static void rt2x00usb_work_txdone_entry(struct queue_entry *entry)
 {
-	struct txdone_entry_desc txdesc;
-
 	/*
 	 * If the transfer to hardware succeeded, it does not mean the
 	 * frame was send out correctly. It only means the frame
@@ -180,14 +178,10 @@ static void rt2x00usb_work_txdone_entry(struct queue_entry *entry)
 	 * (Only indirectly by looking at the failed TX counters
 	 * in the register).
 	 */
-	txdesc.flags = 0;
 	if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags))
-		__set_bit(TXDONE_FAILURE, &txdesc.flags);
+		rt2x00lib_txdone_noinfo(entry, TXDONE_FAILURE);
 	else
-		__set_bit(TXDONE_UNKNOWN, &txdesc.flags);
-	txdesc.retry = 0;
-
-	rt2x00lib_txdone(entry, &txdesc);
+		rt2x00lib_txdone_noinfo(entry, TXDONE_UNKNOWN);
 }
 
 static void rt2x00usb_work_txdone(struct work_struct *work)
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index e539c6c..dc6f3eb 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2107,11 +2107,7 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 				"TX status report missed for entry %d\n",
 				entry_done->entry_idx);
 
-			txdesc.flags = 0;
-			__set_bit(TXDONE_UNKNOWN, &txdesc.flags);
-			txdesc.retry = 0;
-
-			rt2x00lib_txdone(entry_done, &txdesc);
+			rt2x00lib_txdone_noinfo(entry, TXDONE_UNKNOWN);
 			entry_done = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
 		}
 
-- 
1.7.2

