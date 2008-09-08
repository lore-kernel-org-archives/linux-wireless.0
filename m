Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:60248 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbYIHPbz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 11:31:55 -0400
Received: by ug-out-1314.google.com with SMTP id s2so315232uge.37
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2008 08:31:53 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Revert "rt2x00: Fix the beacon length bug"
Date: Mon, 8 Sep 2008 17:31:49 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net,
	Iwo Mergler <iwo@call-direct.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200809081731.49941.IvDoorn@gmail.com> (sfid-20080908_173159_595013_4ACDC631)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts:
	b93ce437eba7e0232683326f30d9d1167a872fad
	rt2x00: Fix the beacon length bug

The workaround is no longer required since it has been
correctly fixed in rt2x00usb now.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |   12 ------------
 drivers/net/wireless/rt2x00/rt73usb.c   |   12 ------------
 2 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 0e008b6..1cfda45 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1133,7 +1133,6 @@ static void rt2500usb_write_beacon(struct queue_entry *entry)
 	int pipe = usb_sndbulkpipe(usb_dev, 1);
 	int length;
 	u16 reg;
-	u32 word, len;
 
 	/*
 	 * Add the descriptor in front of the skb.
@@ -1143,17 +1142,6 @@ static void rt2500usb_write_beacon(struct queue_entry *entry)
 	skbdesc->desc = entry->skb->data;
 
 	/*
-	 * Adjust the beacon databyte count. The current number is
-	 * calculated before this function gets called, but falsely
-	 * assumes that the descriptor was already present in the SKB.
-	 */
-	rt2x00_desc_read(skbdesc->desc, 0, &word);
-	len  = rt2x00_get_field32(word, TXD_W0_DATABYTE_COUNT);
-	len += skbdesc->desc_len;
-	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, len);
-	rt2x00_desc_write(skbdesc->desc, 0, word);
-
-	/*
 	 * Disable beaconing while we are reloading the beacon data,
 	 * otherwise we might be sending out invalid data.
 	 */
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index e698ae0..d9ef34c 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1572,7 +1572,6 @@ static void rt73usb_write_beacon(struct queue_entry *entry)
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	unsigned int beacon_base;
 	u32 reg;
-	u32 word, len;
 
 	/*
 	 * Add the descriptor in front of the skb.
@@ -1582,17 +1581,6 @@ static void rt73usb_write_beacon(struct queue_entry *entry)
 	skbdesc->desc = entry->skb->data;
 
 	/*
-	 * Adjust the beacon databyte count. The current number is
-	 * calculated before this function gets called, but falsely
-	 * assumes that the descriptor was already present in the SKB.
-	 */
-	rt2x00_desc_read(skbdesc->desc, 0, &word);
-	len  = rt2x00_get_field32(word, TXD_W0_DATABYTE_COUNT);
-	len += skbdesc->desc_len;
-	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, len);
-	rt2x00_desc_write(skbdesc->desc, 0, word);
-
-	/*
 	 * Disable beaconing while we are reloading the beacon data,
 	 * otherwise we might be sending out invalid data.
 	 */
-- 
1.5.6.1

