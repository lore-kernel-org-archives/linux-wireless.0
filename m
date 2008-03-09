Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:53844 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbYCIVuu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 17:50:50 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1676623fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2008 14:50:49 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH 06/24] rt2x00: Don't use unitialized rxdesc->size
Date: Sun, 9 Mar 2008 22:41:22 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200803092237.43451.IvDoorn@gmail.com>
In-Reply-To: <200803092237.43451.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803092241.22995.IvDoorn@gmail.com> (sfid-20080309_215056_966411_481F706A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mattias Nissler <mattias.nissler@gmx.de>

rxdesc->size is unitialized before the desriptor has been read.
Move the truncation of the sk buffer to the moment all variables
have been initialized.

Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |   11 +++++++----
 drivers/net/wireless/rt2x00/rt73usb.c   |   11 +++++++----
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 86cd9a5..559131f 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1123,13 +1123,10 @@ static void rt2500usb_fill_rxdone(struct queue_entry *entry,
 
 	/*
 	 * Copy descriptor to the available headroom inside the skbuffer.
-	 * Remove the original copy by trimming the skbuffer.
 	 */
 	skb_push(entry->skb, offset);
 	memcpy(entry->skb->data, rxd, entry->queue->desc_size);
 	rxd = (__le32 *)entry->skb->data;
-	skb_pull(entry->skb, offset);
-	skb_trim(entry->skb, rxdesc->size);
 
 	/*
 	 * The descriptor is now aligned to 4 bytes and thus it is
@@ -1155,11 +1152,17 @@ static void rt2500usb_fill_rxdone(struct queue_entry *entry,
 	rxdesc->my_bss = !!rt2x00_get_field32(word0, RXD_W0_MY_BSS);
 
 	/*
+	 * Adjust the skb memory window to the frame boundaries.
+	 */
+	skb_pull(entry->skb, offset);
+	skb_trim(entry->skb, rxdesc->size);
+
+	/*
 	 * Set descriptor and data pointer.
 	 */
 	skbdesc->data = entry->skb->data;
 	skbdesc->data_len = rxdesc->size;
-	skbdesc->desc = entry->skb->data - offset;
+	skbdesc->desc = rxd;
 	skbdesc->desc_len = entry->queue->desc_size;
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 77bdef8..9b4feb3 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1376,13 +1376,10 @@ static void rt73usb_fill_rxdone(struct queue_entry *entry,
 
 	/*
 	 * Copy descriptor to the available headroom inside the skbuffer.
-	 * Remove the original copy by pulling the skbuffer.
 	 */
 	skb_push(entry->skb, offset);
 	memcpy(entry->skb->data, rxd, entry->queue->desc_size);
 	rxd = (__le32 *)entry->skb->data;
-	skb_pull(entry->skb, offset + entry->queue->desc_size);
-	skb_trim(entry->skb, rxdesc->size);
 
 	/*
 	 * The descriptor is now aligned to 4 bytes and thus it is
@@ -1405,11 +1402,17 @@ static void rt73usb_fill_rxdone(struct queue_entry *entry,
 	rxdesc->my_bss = !!rt2x00_get_field32(word0, RXD_W0_MY_BSS);
 
 	/*
+	 * Adjust the skb memory window to the frame boundaries.
+	 */
+	skb_pull(entry->skb, offset + entry->queue->desc_size);
+	skb_trim(entry->skb, rxdesc->size);
+
+	/*
 	 * Set descriptor and data pointer.
 	 */
 	skbdesc->data = entry->skb->data;
 	skbdesc->data_len = rxdesc->size;
-	skbdesc->desc = entry->skb->data - offset;
+	skbdesc->desc = rxd;
 	skbdesc->desc_len = entry->queue->desc_size;
 }
 
-- 
1.5.4.3

