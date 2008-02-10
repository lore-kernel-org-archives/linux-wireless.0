Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.186]:28570 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbYBJVxw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 16:53:52 -0500
Received: by mu-out-0910.google.com with SMTP id i10so5147467mue.5
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2008 13:53:51 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 10/14] rt2x00: Fix skbdesc->data_len initialization
Date: Sun, 10 Feb 2008 22:51:21 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802102246.04515.IvDoorn@gmail.com>
In-Reply-To: <200802102246.04515.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802102251.21346.IvDoorn@gmail.com> (sfid-20080210_215354_902810_5FCB7A46)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

skbdesc->data_len was not initialized correctly
in rt2x00pci, rt2x00usb, rt2500usb and rt73usb.

The value was set to queue->data_size which
means that the incorrect frame size was pased
to the upper layers.

Correctly base the value on either the skb->len,
or the rx frame size passed to the driver by the
device.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |    2 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00usb.c |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c   |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 1ae9e3c..ad8b6a0 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1145,7 +1145,7 @@ static void rt2500usb_fill_rxdone(struct queue_entry *entry,
 	 * Set descriptor pointer.
 	 */
 	skbdesc->data = entry->skb->data;
-	skbdesc->data_len = entry->queue->data_size;
+	skbdesc->data_len = rxdesc->size;
 	skbdesc->desc = entry->skb->data + rxdesc->size;
 	skbdesc->desc_len = entry->queue->desc_size;
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index b8c6a8c..8f88ca2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -63,7 +63,7 @@ int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	skbdesc = get_skb_frame_desc(skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
 	skbdesc->data = skb->data;
-	skbdesc->data_len = queue->data_size;
+	skbdesc->data_len = skb->len;
 	skbdesc->desc = priv_tx->desc;
 	skbdesc->desc_len = queue->desc_size;
 	skbdesc->entry = entry;
@@ -131,7 +131,7 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 		skbdesc = get_skb_frame_desc(entry->skb);
 		memset(skbdesc, 0, sizeof(*skbdesc));
 		skbdesc->data = entry->skb->data;
-		skbdesc->data_len = queue->data_size;
+		skbdesc->data_len = entry->skb->len;
 		skbdesc->desc = priv_rx->desc;
 		skbdesc->desc_len = queue->desc_size;
 		skbdesc->entry = entry;
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 4219057..450043b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -254,7 +254,7 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	skbdesc = get_skb_frame_desc(skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
 	skbdesc->data = skb->data + queue->desc_size;
-	skbdesc->data_len = queue->data_size;
+	skbdesc->data_len = skb->len - queue->desc_size;
 	skbdesc->desc = skb->data;
 	skbdesc->desc_len = queue->desc_size;
 	skbdesc->entry = entry;
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 1802898..af1bb91 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1395,7 +1395,7 @@ static void rt73usb_fill_rxdone(struct queue_entry *entry,
 	 * Set descriptor and data pointer.
 	 */
 	skbdesc->data = entry->skb->data + entry->queue->desc_size;
-	skbdesc->data_len = entry->queue->data_size;
+	skbdesc->data_len = rxdesc->size;
 	skbdesc->desc = entry->skb->data;
 	skbdesc->desc_len = entry->queue->desc_size;
 
-- 
1.5.4

