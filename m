Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:34039 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbYAJVC4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 16:02:56 -0500
Received: by fg-out-1718.google.com with SMTP id e21so831797fga.17
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jan 2008 13:02:51 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
Subject: [PATCH] rt2x00: Data and desc pointer initialization
Date: Thu, 10 Jan 2008 22:02:44 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801102202.44999.IvDoorn@gmail.com> (sfid-20080110_210301_131785_6B1E5195)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2500usb and rt73usb data and desc pointer initialization
was incorrect because it was using uninitialized variables
to determine the length.

In addition rt2500usb used skb_pull and removed the ieee80211
from each received frame instead of using skb_trim to remove
the device descriptor from the frame.

Finally this also fixes the descriptor override when 4 byte
aligning occured. We still need a completely valid descriptor
when using the TX/RX dumping capabilities in debugfs.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---

John, this patch fixes a bug introduced in rt2x00 2.0.14.
After this patch, my rt2500usb send out it's first (and unfortunately only)
ping in months. So the rt2500usb status is finally improving. :)

 drivers/net/wireless/rt2x00/rt2500usb.c |    9 +++------
 drivers/net/wireless/rt2x00/rt2x00usb.c |   25 +++++++++++++++----------
 drivers/net/wireless/rt2x00/rt73usb.c   |   11 ++++-------
 3 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 3084e24..691a098 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1142,15 +1142,12 @@ static void rt2500usb_fill_rxdone(struct data_entry *entry,
 	desc->my_bss = !!rt2x00_get_field32(word0, RXD_W0_MY_BSS);
 
 	/*
-	 * Trim the skb to clear the descriptor area.
-	 */
-	skb_pull(entry->skb, entry->ring->desc_size);
-
-	/*
 	 * Set descriptor and data pointer.
 	 */
-	skbdesc->desc = entry->skb->data + skbdesc->data_len;
+	skbdesc->desc = entry->skb->data + desc->size;
+	skbdesc->desc_len = entry->ring->desc_size;
 	skbdesc->data = entry->skb->data;
+	skbdesc->data_len = desc->size;
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 7a62776..5e60504 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -257,6 +257,13 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	if (urb->actual_length < entry->ring->desc_size || urb->status)
 		goto skip_entry;
 
+	/*
+	 * Fill in skb descriptor
+	 */
+	skbdesc = get_skb_desc(entry->skb);
+	skbdesc->ring = ring;
+	skbdesc->entry = entry;
+
 	memset(&desc, 0, sizeof(desc));
 	rt2x00dev->ops->lib->fill_rxdone(entry, &desc);
 
@@ -276,9 +283,6 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	/*
 	 * The data behind the ieee80211 header must be
 	 * aligned on a 4 byte boundary.
-	 * After that trim the entire buffer down to only
-	 * contain the valid frame data excluding the device
-	 * descriptor.
 	 */
 	hdr = (struct ieee80211_hdr *)entry->skb->data;
 	header_size =
@@ -288,16 +292,17 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 		skb_push(entry->skb, 2);
 		memmove(entry->skb->data, entry->skb->data + 2, skb->len - 2);
 	}
-	skb_trim(entry->skb, desc.size);
 
 	/*
-	 * Fill in skb descriptor
+	 * Trim the entire buffer down to only contain the valid frame data
+	 * excluding the device descriptor. The position of the descriptor
+	 * varies. This means that we should check where the descriptor is
+	 * and decide if we need to pull the data pointer to exclude the
+	 * device descriptor.
 	 */
-	skbdesc = get_skb_desc(entry->skb);
-	skbdesc->desc_len = entry->ring->desc_size;
-	skbdesc->data_len = entry->skb->len;
-	skbdesc->ring = ring;
-	skbdesc->entry = entry;
+	if (skbdesc->data > skbdesc->desc)
+		skb_pull(entry->skb, skbdesc->desc_len);
+	skb_trim(entry->skb, desc.size);
 
 	/*
 	 * Send the frame to rt2x00lib for further processing.
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index fe1506a..7eafe08 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1380,15 +1380,12 @@ static void rt73usb_fill_rxdone(struct data_entry *entry,
 	desc->my_bss = !!rt2x00_get_field32(word0, RXD_W0_MY_BSS);
 
 	/*
-	 * Pull the skb to clear the descriptor area.
-	 */
-	skb_pull(entry->skb, entry->ring->desc_size);
-
-	/*
 	 * Set descriptor and data pointer.
 	 */
-	skbdesc->desc = entry->skb->data - skbdesc->desc_len;
-	skbdesc->data = entry->skb->data;
+	skbdesc->desc = entry->skb->data;
+	skbdesc->desc_len = entry->ring->desc_size;
+	skbdesc->data = entry->skb->data + entry->ring->desc_size;
+	skbdesc->data_len = desc->size;
 }
 
 /*
-- 
1.5.3.7

