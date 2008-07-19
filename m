Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:14299 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbYGSODW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 10:03:22 -0400
Received: by nf-out-0910.google.com with SMTP id d3so250599nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2008 07:03:22 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 5/5] rt2x00: Fix the beacon length bug
Date: Sat, 19 Jul 2008 16:17:40 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	Iwo Mergler <iwo@call-direct.com.au>
References: <200807191615.22752.IvDoorn@gmail.com> <200807191616.54313.IvDoorn@gmail.com> <200807191617.16820.IvDoorn@gmail.com>
In-Reply-To: <200807191617.16820.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807191617.40902.IvDoorn@gmail.com> (sfid-20080719_160325_804630_0F251E02)
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
 drivers/net/wireless/rt2x00/rt73usb.c   |   12 ++++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

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
index 26265c7..0a689cd 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
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

