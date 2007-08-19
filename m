Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:22855 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbXHSSbT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:31:19 -0400
Received: by ug-out-1314.google.com with SMTP id j3so446949ugf
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:31:18 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 18/30] rt2x00: memset descriptor before use
Date: Sun, 19 Aug 2007 20:27:54 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192027.54448.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 1273bba4e38352cfe5b15c1c7cad742e41f00a96 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 18 Aug 2007 13:08:49 +0200
Subject: [PATCH 18/30] rt2x00: memset descriptor before use

For rt2x00usb, when skb_push() is called the descriptor is added
in front of the frame. The contents however is random data.
This should be correctly cleared to prevent garbage to be send to
the device...

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00usb.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00usb.c b/drivers/net/wireless/rt2x00usb.c
index d832d5f..c763606 100644
--- a/drivers/net/wireless/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00usb.c
@@ -268,7 +268,6 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	    interface_to_usbdev(rt2x00dev_usb(rt2x00dev));
 	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr *)skb->data;
 	struct data_entry *entry = rt2x00_get_data_entry(ring);
-	struct data_desc *txd;
 	u32 length = skb->len;
 
 	if (rt2x00_ring_full(ring)) {
@@ -285,9 +284,14 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 		return -EINVAL;
 	}
 
+	/*
+	 * Add the descriptor in front of the skb.
+	 */
 	skb_push(skb, rt2x00dev->hw->extra_tx_headroom);
-	txd = (struct data_desc *)skb->data;
-	rt2x00lib_write_tx_desc(rt2x00dev, entry, txd, ieee80211hdr,
+	memset(skb->data, 0x00, rt2x00dev->hw->extra_tx_headroom);
+
+	rt2x00lib_write_tx_desc(rt2x00dev, entry,
+				(struct data_desc *)skb->data, ieee80211hdr,
 				length, control);
 	memcpy(&entry->tx_status.control, control, sizeof(*control));
 	entry->skb = skb;
-- 
1.5.3.rc5

