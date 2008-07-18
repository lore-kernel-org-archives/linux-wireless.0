Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:7770 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565AbYGRSlX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 14:41:23 -0400
Received: by nf-out-0910.google.com with SMTP id d3so160308nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jul 2008 11:41:23 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 5/6] rt2x00: Fix the beacon length bug
Date: Fri, 18 Jul 2008 20:45:04 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200807182043.08990.IvDoorn@gmail.com> <200807182044.23079.IvDoorn@gmail.com> <200807182044.45140.IvDoorn@gmail.com>
In-Reply-To: <200807182044.45140.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807182045.04530.IvDoorn@gmail.com> (sfid-20080718_204126_030096_22D0E0FF)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Iwo Mergler <iwo@call-direct.com.au>

When setting up a beacon template, the length of the beacon is
calculated with the assumption that the SKB already contains
the Tx descriptor. In the case of beacons it doesn't.

This patch undoes the damage by adding the Tx descriptor length
to the beacon length. This is safe, because the shortest possible
beacon is longer than the Tx header.

Signed-off-by: Iwo Mergler <Iwo@call-direct.com.au>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |   12 ++++++++++++
 drivers/net/wireless/rt2x00/rt73usb.c   |   14 +++++++++++++-
 2 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 3558cb2..5ca9799 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1121,6 +1121,7 @@ static void rt2500usb_write_beacon(struct queue_entry *entry)
 	int pipe = usb_sndbulkpipe(usb_dev, 1);
 	int length;
 	u16 reg;
+	u32 word, len;
 
 	/*
 	 * Add the descriptor in front of the skb.
@@ -1130,6 +1131,17 @@ static void rt2500usb_write_beacon(struct queue_entry *entry)
 	skbdesc->desc = entry->skb->data;
 
 	/*
+	 * Adjust the beacon databyte count. The current number is
+	 * calculated before this function gets called, but falsely
+	 * assumes that the descriptor was already present in the SKB.
+	 */
+	rt2x00_desc_read(skbdesc->desc, 0, &word);
+	len  = rt2x00_get_field32(word, TXD_W0_DATABYTE_COUNT);
+	len += skbdesc->desc_len;
+	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, len);
+	rt2x00_desc_write(skbdesc->desc, 0, word);
+
+	/*
 	 * Disable beaconing while we are reloading the beacon data,
 	 * otherwise we might be sending out invalid data.
 	 */
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index cb73a93..ab7abc3 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1322,7 +1322,7 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 }
 
 /*
- * TX data initialization
+ * Send beacon template to hardware
  */
 static void rt73usb_write_beacon(struct queue_entry *entry)
 {
@@ -1330,6 +1330,7 @@ static void rt73usb_write_beacon(struct queue_entry *entry)
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	unsigned int beacon_base;
 	u32 reg;
+	u32 word, len;
 
 	/*
 	 * Add the descriptor in front of the skb.
@@ -1339,6 +1340,17 @@ static void rt73usb_write_beacon(struct queue_entry *entry)
 	skbdesc->desc = entry->skb->data;
 
 	/*
+	 * Adjust the beacon databyte count. The current number is
+	 * calculated before this function gets called, but falsely
+	 * assumes that the descriptor was already present in the SKB.
+	 */
+	rt2x00_desc_read(skbdesc->desc, 0, &word);
+	len  = rt2x00_get_field32(word, TXD_W0_DATABYTE_COUNT);
+	len += skbdesc->desc_len;
+	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, len);
+	rt2x00_desc_write(skbdesc->desc, 0, word);
+
+	/*
 	 * Disable beaconing while we are reloading the beacon data,
 	 * otherwise we might be sending out invalid data.
 	 */
-- 
1.5.6.1

