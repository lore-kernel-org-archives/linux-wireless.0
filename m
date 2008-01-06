Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:30801 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133AbYAFWms (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jan 2008 17:42:48 -0500
Received: by ug-out-1314.google.com with SMTP id z38so3071365ugc.16
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jan 2008 14:42:47 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 06/12] rt2x00: Put 802.11 data on 4 byte boundary
Date: Sun, 6 Jan 2008 23:40:27 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200801062337.35904.IvDoorn@gmail.com>
In-Reply-To: <200801062337.35904.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801062340.27509.IvDoorn@gmail.com> (sfid-20080106_224252_417933_91E2D3B0)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check the size of the ieee80211 header during rxdone
and make sure the data behind the ieee80211 header
is placed on a 4 byte boundary.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00pci.c |   20 ++++++++++++++++----
 drivers/net/wireless/rt2x00/rt2x00usb.c |   17 +++++++++++++++--
 2 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 70cb81c..dbc23c4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -129,7 +129,10 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 	struct data_entry *entry;
 	struct sk_buff *skb;
 	struct skb_desc *skbdesc;
+	struct ieee80211_hdr *hdr;
 	struct rxdata_entry_desc desc;
+	int header_size;
+	int align;
 	__le32 *rxd;
 	u32 word;
 
@@ -144,17 +147,26 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 		memset(&desc, 0, sizeof(desc));
 		rt2x00dev->ops->lib->fill_rxdone(entry, &desc);
 
+		hdr = (struct ieee80211_hdr *)entry->data_addr;
+		header_size =
+		    ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control));
+
+		/*
+		 * The data behind the ieee80211 header must be
+		 * aligned on a 4 byte boundary.
+		 */
+		align = NET_IP_ALIGN + (2 * (header_size % 4 == 0));
+
 		/*
 		 * Allocate the sk_buffer, initialize it and copy
 		 * all data into it.
 		 */
-		skb = dev_alloc_skb(desc.size + NET_IP_ALIGN);
+		skb = dev_alloc_skb(desc.size + align);
 		if (!skb)
 			return;
 
-		skb_reserve(skb, NET_IP_ALIGN);
-		skb_put(skb, desc.size);
-		memcpy(skb->data, entry->data_addr, desc.size);
+		skb_reserve(skb, align);
+		memcpy(skb_put(skb, desc.size), entry->data_addr, desc.size);
 
 		/*
 		 * Fill in skb descriptor
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 7aba357..8a6218f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -240,7 +240,9 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	struct rt2x00_dev *rt2x00dev = ring->rt2x00dev;
 	struct sk_buff *skb;
 	struct skb_desc *skbdesc;
+	struct ieee80211_hdr *hdr;
 	struct rxdata_entry_desc desc;
+	int header_size;
 	int frame_size;
 
 	if (!test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags) ||
@@ -272,9 +274,20 @@ static void rt2x00usb_interrupt_rxdone(struct urb *urb)
 	skb_put(skb, frame_size);
 
 	/*
-	 * Trim the skb_buffer to only contain the valid
-	 * frame data (so ignore the device's descriptor).
+	 * The data behind the ieee80211 header must be
+	 * aligned on a 4 byte boundary.
+	 * After that trim the entire buffer down to only
+	 * contain the valid frame data excluding the device
+	 * descriptor.
 	 */
+	hdr = (struct ieee80211_hdr *)entry->skb->data;
+	header_size =
+	    ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control));
+
+	if (header_size % 4 == 0) {
+		skb_push(entry->skb, 2);
+		memmove(entry->skb->data, entry->skb->data + 2, skb->len - 2);
+	}
 	skb_trim(entry->skb, desc.size);
 
 	/*
-- 
1.5.3.7

