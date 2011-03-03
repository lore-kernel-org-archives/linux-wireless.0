Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42982 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab1CCSsa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 13:48:30 -0500
Received: by mail-ww0-f44.google.com with SMTP id 22so1737707wwb.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 10:48:30 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 06/19] rt2x00: Generate sw sequence numbers only for devices that need it
Date: Thu, 3 Mar 2011 19:42:01 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201103031938.56423.IvDoorn@gmail.com> <201103031940.34167.IvDoorn@gmail.com> <201103031941.04133.IvDoorn@gmail.com>
In-Reply-To: <201103031941.04133.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103031942.02498.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Newer devices like rt2800* own a hardware sequence counter and thus
don't need to use a software sequence counter at all. Add a new driver
flag to shortcut the software sequence number generation on devices that
don't need it.

rt61pci, rt73usb and rt2800* seem to make use of a hw sequence counter
while rt2400pci and rt2500* need to do it in software.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |    1 +
 drivers/net/wireless/rt2x00/rt2500pci.c   |    1 +
 drivers/net/wireless/rt2x00/rt2500usb.c   |    1 +
 drivers/net/wireless/rt2x00/rt2x00.h      |    1 +
 drivers/net/wireless/rt2x00/rt2x00queue.c |   11 +++++++----
 5 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 2725f3c..d38acf4 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1641,6 +1641,7 @@ static int rt2400pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	 */
 	__set_bit(DRIVER_REQUIRE_ATIM_QUEUE, &rt2x00dev->flags);
 	__set_bit(DRIVER_REQUIRE_DMA, &rt2x00dev->flags);
+	__set_bit(DRIVER_REQUIRE_SW_SEQNO, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 3ef1fb4..b00e4d4 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1959,6 +1959,7 @@ static int rt2500pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	 */
 	__set_bit(DRIVER_REQUIRE_ATIM_QUEUE, &rt2x00dev->flags);
 	__set_bit(DRIVER_REQUIRE_DMA, &rt2x00dev->flags);
+	__set_bit(DRIVER_REQUIRE_SW_SEQNO, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 01f385d..b71df29 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1795,6 +1795,7 @@ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 		__set_bit(DRIVER_REQUIRE_COPY_IV, &rt2x00dev->flags);
 	}
 	__set_bit(DRIVER_SUPPORT_WATCHDOG, &rt2x00dev->flags);
+	__set_bit(DRIVER_REQUIRE_SW_SEQNO, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 391669b..be4d4cd 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -662,6 +662,7 @@ enum rt2x00_flags {
 	DRIVER_REQUIRE_L2PAD,
 	DRIVER_REQUIRE_TXSTATUS_FIFO,
 	DRIVER_REQUIRE_TASKLET_CONTEXT,
+	DRIVER_REQUIRE_SW_SEQNO,
 
 	/*
 	 * Driver features
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index b32ca31..eebb564 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -224,10 +224,14 @@ static void rt2x00queue_create_tx_descriptor_seq(struct queue_entry *entry,
 	if (!(tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ))
 		return;
 
+	__set_bit(ENTRY_TXD_GENERATE_SEQ, &txdesc->flags);
+
+	if (!test_bit(DRIVER_REQUIRE_SW_SEQNO, &entry->queue->rt2x00dev->flags))
+		return;
+
 	/*
-	 * Hardware should insert sequence counter.
-	 * FIXME: We insert a software sequence counter first for
-	 * hardware that doesn't support hardware sequence counting.
+	 * The hardware is not able to insert a sequence number. Assign a
+	 * software generated one here.
 	 *
 	 * This is wrong because beacons are not getting sequence
 	 * numbers assigned properly.
@@ -245,7 +249,6 @@ static void rt2x00queue_create_tx_descriptor_seq(struct queue_entry *entry,
 
 	spin_unlock_irqrestore(&intf->seqlock, irqflags);
 
-	__set_bit(ENTRY_TXD_GENERATE_SEQ, &txdesc->flags);
 }
 
 static void rt2x00queue_create_tx_descriptor_plcp(struct queue_entry *entry,
-- 
1.7.2.3

