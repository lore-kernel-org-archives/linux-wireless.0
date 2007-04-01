Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:56722 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933068AbXDAOCg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Apr 2007 10:02:36 -0400
Received: by ug-out-1314.google.com with SMTP id 44so1294449uga
        for <linux-wireless@vger.kernel.org>; Sun, 01 Apr 2007 07:02:33 -0700 (PDT)
To: "John Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Use correct length in descriptor
Date: Sun, 1 Apr 2007 16:01:52 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200704011601.53481.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes an important issue where the incorrect length is being
passed to the descriptor initializor. This incorrect initialization will
cause frames to be send out incorrectly.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index 187076d..537d0c5 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -1555,8 +1555,7 @@ static int rt2500usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 
 	skb_push(skb, rt2x00dev->hw->extra_tx_headroom);
 	txd = (struct data_desc*)skb->data;
-	rt2500usb_write_tx_desc(rt2x00dev, txd, ieee80211hdr,
-		skb->len, control);
+	rt2500usb_write_tx_desc(rt2x00dev, txd, ieee80211hdr, length, control);
 	memcpy(&entry->tx_status.control, control, sizeof(*control));
 	entry->skb = skb;
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index 9c9fbce..7b3b878 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -1714,7 +1714,7 @@ static int rt73usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 
 	skb_push(skb, rt2x00dev->hw->extra_tx_headroom);
 	txd = (struct data_desc*)skb->data;
-	rt73usb_write_tx_desc(rt2x00dev, txd, ieee80211hdr, skb->len, control);
+	rt73usb_write_tx_desc(rt2x00dev, txd, ieee80211hdr, length, control);
 	memcpy(&entry->tx_status.control, control, sizeof(*control));
 	entry->skb = skb;
 
