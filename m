Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:33167 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759524AbYAKTxR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 14:53:17 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1240923fga.17
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jan 2008 11:53:15 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Fix ieee80211 payload alignment
Date: Fri, 11 Jan 2008 20:53:07 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801112053.07962.IvDoorn@gmail.com> (sfid-20080111_195321_075286_9882EC76)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As Johannes Berg indicated, the NET_IP_ALIGN doesn't
need to be used for ieee80211 frames. This means we
can simplify the alignment calculation to just
use the result of the header size modulus 4 as frame
alignment.

Furthermore we shouldn't use NET_IP_ALIGN in rt2x00usb
because it could be 0 on some architectures and we absolutely
need to have 2 bytes reserved for possible aligning.

Signed-off-by: Ivo van Doorn<IvDoorn@gmail.com>
---

John, please push this patch upstream to 2.6.24 as well.
This patch fixes a bug introduced in:
	rt2x00: Put 802.11 data on 4 byte boundary

 drivers/net/wireless/rt2x00/rt2x00pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c |   11 +++++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 67e0779..ea15230 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -157,7 +157,7 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 		 * The data behind the ieee80211 header must be
 		 * aligned on a 4 byte boundary.
 		 */
-		align = NET_IP_ALIGN + (2 * (header_size % 4 == 0));
+		align = header_size % 4;
 
 		/*
 		 * Allocate the sk_buffer, initialize it and copy
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 5e60504..f29a5dd 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -271,13 +271,20 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	 * Allocate a new sk buffer to replace the current one.
 	 * If allocation fails, we should drop the current frame
 	 * so we can recycle the existing sk buffer for the new frame.
+	 * As alignment we use 2 and not NET_IP_ALIGN because we need
+	 * to be sure we have 2 bytes room in the head. (NET_IP_ALIGN
+	 * can be 0 on some hardware). We use these 2 bytes for frame
+	 * alignment later, we assume that the chance that
+	 * header_size % 4 == 2 is bigger then header_size % 2 == 0
+	 * and thus optimize alignment by reserving the 2 bytes in
+	 * advance.
 	 */
 	frame_size = entry->ring->data_size + entry->ring->desc_size;
-	skb = dev_alloc_skb(frame_size + NET_IP_ALIGN);
+	skb = dev_alloc_skb(frame_size + 2);
 	if (!skb)
 		goto skip_entry;
 
-	skb_reserve(skb, NET_IP_ALIGN);
+	skb_reserve(skb, 2);
 	skb_put(skb, frame_size);
 
 	/*
-- 
1.5.3.8

