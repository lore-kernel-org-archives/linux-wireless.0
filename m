Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f45.google.com ([209.85.215.45]:47560 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab0LMLkh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 06:40:37 -0500
Received: by mail-ew0-f45.google.com with SMTP id 10so3803451ewy.4
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 03:40:36 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 16/17] rt2x00: Pad beacon to multiple of 32 bits.
Date: Mon, 13 Dec 2010 12:39:12 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201012131231.28313.IvDoorn@gmail.com> <201012131236.39071.IvDoorn@gmail.com> <201012131238.50510.IvDoorn@gmail.com>
In-Reply-To: <201012131238.50510.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012131239.13818.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wolfgang Kufner <wolfgang.kufner@gmail.com>

Pad beacon to a multiple of 32 bits in preparation for the change
from memcpy_toio() to __iowrite32_copy() in register_multiwrite().

Signed-off-by: Wolfgang Kufner <wolfgang.kufner@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    9 ++++++---
 drivers/net/wireless/rt2x00/rt61pci.c   |    8 ++++++--
 drivers/net/wireless/rt2x00/rt73usb.c   |    9 ++++++---
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index b7de1a5..54917a2 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -772,6 +772,7 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	unsigned int beacon_base;
+	unsigned int padding_len;
 	u32 reg;
 
 	/*
@@ -806,11 +807,13 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry->skb);
 
 	/*
-	 * Write entire beacon with TXWI to register.
+	 * Write entire beacon with TXWI and padding to register.
 	 */
+	padding_len = roundup(entry->skb->len, 4) - entry->skb->len;
+	skb_pad(entry->skb, padding_len);
 	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
-	rt2800_register_multiwrite(rt2x00dev, beacon_base,
-				   entry->skb->data, entry->skb->len);
+	rt2800_register_multiwrite(rt2x00dev, beacon_base, entry->skb->data,
+				   entry->skb->len + padding_len);
 
 	/*
 	 * Enable beaconing again.
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 9405b10..8de44dd 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1961,6 +1961,7 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
 	unsigned int beacon_base;
+	unsigned int padding_len;
 	u32 reg;
 
 	/*
@@ -1982,13 +1983,16 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
 	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry->skb);
 
 	/*
-	 * Write entire beacon with descriptor to register.
+	 * Write entire beacon with descriptor and padding to register.
 	 */
+	padding_len = roundup(entry->skb->len, 4) - entry->skb->len;
+	skb_pad(entry->skb, padding_len);
 	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
 	rt2x00pci_register_multiwrite(rt2x00dev, beacon_base,
 				      entry_priv->desc, TXINFO_SIZE);
 	rt2x00pci_register_multiwrite(rt2x00dev, beacon_base + TXINFO_SIZE,
-				      entry->skb->data, entry->skb->len);
+				      entry->skb->data,
+				      entry->skb->len + padding_len);
 
 	/*
 	 * Enable beaconing again.
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 0b3959b..0b4e859 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1546,6 +1546,7 @@ static void rt73usb_write_beacon(struct queue_entry *entry,
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	unsigned int beacon_base;
+	unsigned int padding_len;
 	u32 reg;
 
 	/*
@@ -1573,11 +1574,13 @@ static void rt73usb_write_beacon(struct queue_entry *entry,
 	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry->skb);
 
 	/*
-	 * Write entire beacon with descriptor to register.
+	 * Write entire beacon with descriptor and padding to register.
 	 */
+	padding_len = roundup(entry->skb->len, 4) - entry->skb->len;
+	skb_pad(entry->skb, padding_len);
 	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
-	rt2x00usb_register_multiwrite(rt2x00dev, beacon_base,
-				      entry->skb->data, entry->skb->len);
+	rt2x00usb_register_multiwrite(rt2x00dev, beacon_base, entry->skb->data,
+				      entry->skb->len + padding_len);
 
 	/*
 	 * Enable beaconing again.
-- 
1.7.2.3

