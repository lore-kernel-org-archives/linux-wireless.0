Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:63275 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046AbYH2TIE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 15:08:04 -0400
Received: by ey-out-2122.google.com with SMTP id 6so320138eyi.37
        for <linux-wireless@vger.kernel.org>; Fri, 29 Aug 2008 12:08:03 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 5/7] rt2x00: Add Signal type flag
Date: Fri, 29 Aug 2008 21:07:16 +0200
Cc: "rt2400-devel" <rt2400-devel@lists.sourceforge.net>,
	linux-wireless@vger.kernel.org
References: <200808292103.53179.IvDoorn@gmail.com> <200808292105.21378.IvDoorn@gmail.com> <200808292105.45380.IvDoorn@gmail.com>
In-Reply-To: <200808292105.45380.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200808292107.16961.IvDoorn@gmail.com> (sfid-20080829_210809_031935_3A5B31DB)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of using the PLCP flag to indicate if the
signal value is plcp or the bitrate we should add
a new flag to mark the bitrate type explicitely.
This is usefull when new types are added later for
rt2800.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500pci.c   |    2 ++
 drivers/net/wireless/rt2x00/rt2500usb.c   |    2 ++
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.h |    7 ++++---
 drivers/net/wireless/rt2x00/rt61pci.c     |    2 ++
 drivers/net/wireless/rt2x00/rt73usb.c     |    2 ++
 6 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 5cc706a..2a96a01 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1316,6 +1316,8 @@ static void rt2500pci_fill_rxdone(struct queue_entry *entry,
 
 	if (rt2x00_get_field32(word0, RXD_W0_OFDM))
 		rxdesc->dev_flags |= RXDONE_SIGNAL_PLCP;
+	else
+		rxdesc->dev_flags |= RXDONE_SIGNAL_BITRATE;
 	if (rt2x00_get_field32(word0, RXD_W0_MY_BSS))
 		rxdesc->dev_flags |= RXDONE_MY_BSS;
 }
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index c6be4dd..c5f49e3 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1280,6 +1280,8 @@ static void rt2500usb_fill_rxdone(struct queue_entry *entry,
 
 	if (rt2x00_get_field32(word0, RXD_W0_OFDM))
 		rxdesc->dev_flags |= RXDONE_SIGNAL_PLCP;
+	else
+		rxdesc->dev_flags |= RXDONE_SIGNAL_BITRATE;
 	if (rt2x00_get_field32(word0, RXD_W0_MY_BSS))
 		rxdesc->dev_flags |= RXDONE_MY_BSS;
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 5278ae2..369b0b2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -653,7 +653,7 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
 
 		if (((rxdesc.dev_flags & RXDONE_SIGNAL_PLCP) &&
 		     (rate->plcp == rxdesc.signal)) ||
-		    (!(rxdesc.dev_flags & RXDONE_SIGNAL_PLCP) &&
+		    ((rxdesc.dev_flags & RXDONE_SIGNAL_BITRATE) &&
 		      (rate->bitrate == rxdesc.signal))) {
 			idx = i;
 			break;
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 654fa0c..9dbf04f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -140,13 +140,14 @@ static inline struct skb_frame_desc* get_skb_frame_desc(struct sk_buff *skb)
 /**
  * enum rxdone_entry_desc_flags: Flags for &struct rxdone_entry_desc
  *
- * @RXDONE_SIGNAL_PLCP: Does the signal field contain the plcp value,
- *	or does it contain the bitrate itself.
+ * @RXDONE_SIGNAL_PLCP: Signal field contains the plcp value.
+ * @RXDONE_SIGNAL_BITRATE: Signal field contains the bitrate value.
  * @RXDONE_MY_BSS: Does this frame originate from device's BSS.
  */
 enum rxdone_entry_desc_flags {
 	RXDONE_SIGNAL_PLCP = 1 << 0,
-	RXDONE_MY_BSS = 1 << 1,
+	RXDONE_SIGNAL_BITRATE = 1 << 1,
+	RXDONE_MY_BSS = 1 << 2,
 };
 
 /**
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 5253710..d740f56 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1991,6 +1991,8 @@ static void rt61pci_fill_rxdone(struct queue_entry *entry,
 
 	if (rt2x00_get_field32(word0, RXD_W0_OFDM))
 		rxdesc->dev_flags |= RXDONE_SIGNAL_PLCP;
+	else
+		rxdesc->dev_flags |= RXDONE_SIGNAL_BITRATE;
 	if (rt2x00_get_field32(word0, RXD_W0_MY_BSS))
 		rxdesc->dev_flags |= RXDONE_MY_BSS;
 }
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 636b4e0..cf236ec 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1766,6 +1766,8 @@ static void rt73usb_fill_rxdone(struct queue_entry *entry,
 
 	if (rt2x00_get_field32(word0, RXD_W0_OFDM))
 		rxdesc->dev_flags |= RXDONE_SIGNAL_PLCP;
+	else
+		rxdesc->dev_flags |= RXDONE_SIGNAL_BITRATE;
 	if (rt2x00_get_field32(word0, RXD_W0_MY_BSS))
 		rxdesc->dev_flags |= RXDONE_MY_BSS;
 
-- 
1.5.6.1

