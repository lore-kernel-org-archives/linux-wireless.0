Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:58094 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbYLBVuh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 16:50:37 -0500
Received: by ey-out-2122.google.com with SMTP id 6so1379623eyi.37
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 13:50:35 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Add RXDONE_CRYPTO_IV/ICV flags
Date: Tue, 2 Dec 2008 22:50:33 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812022250.33357.IvDoorn@gmail.com> (sfid-20081202_225052_212272_519A0FBC)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers should notify rt2x00lib when they provide
the IV/ICV data. This adds some flexibility to drivers
which can't provide all information.
	* rt2500usb provides ICV inside the frame
	* rt2800pci doesn't provide IV/ICV
	* rt2800usb doesn't provide IV/ICV

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
John, this is on top of the merge request from earlier today.
---
 drivers/net/wireless/rt2x00/rt2500usb.c   |    2 ++
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    3 ++-
 drivers/net/wireless/rt2x00/rt2x00queue.h |    4 ++++
 drivers/net/wireless/rt2x00/rt61pci.c     |    3 +++
 drivers/net/wireless/rt2x00/rt73usb.c     |    3 +++
 5 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 5f65b7e..d8c48fd 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1330,6 +1330,8 @@ static void rt2500usb_fill_rxdone(struct queue_entry *entry,
 	if (rxdesc->cipher != CIPHER_NONE) {
 		_rt2x00_desc_read(rxd, 2, &rxdesc->iv[0]);
 		_rt2x00_desc_read(rxd, 3, &rxdesc->iv[1]);
+		rxdesc->dev_flags |= RXDONE_CRYPTO_IV;
+
 		/* ICV is located at the end of frame */
 
 		/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 7fc1d76..6d92542 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -636,7 +636,8 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
 	 * provided seperately (through hardware descriptor)
 	 * in which case we should reinsert the data into the frame.
 	 */
-	if ((rxdesc.flags & RX_FLAG_IV_STRIPPED)) {
+	if ((rxdesc.dev_flags & RXDONE_CRYPTO_IV) &&
+	    (rxdesc.flags & RX_FLAG_IV_STRIPPED)) {
 		rt2x00crypto_rx_insert_iv(entry->skb, align,
 					  header_length, &rxdesc);
 	} else if (align) {
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 7889f91..2829371 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -146,11 +146,15 @@ static inline struct skb_frame_desc* get_skb_frame_desc(struct sk_buff *skb)
  * @RXDONE_SIGNAL_PLCP: Signal field contains the plcp value.
  * @RXDONE_SIGNAL_BITRATE: Signal field contains the bitrate value.
  * @RXDONE_MY_BSS: Does this frame originate from device's BSS.
+ * @RXDONE_CRYPTO_IV: Driver provided IV/EIV data.
+ * @RXDONE_CRYPTO_ICV: Driver provided ICV data.
  */
 enum rxdone_entry_desc_flags {
 	RXDONE_SIGNAL_PLCP = 1 << 0,
 	RXDONE_SIGNAL_BITRATE = 1 << 1,
 	RXDONE_MY_BSS = 1 << 2,
+	RXDONE_CRYPTO_IV = 1 << 3,
+	RXDONE_CRYPTO_ICV = 1 << 4,
 };
 
 /**
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index ce0fde4..3b9015a 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1951,7 +1951,10 @@ static void rt61pci_fill_rxdone(struct queue_entry *entry,
 	if (rxdesc->cipher != CIPHER_NONE) {
 		_rt2x00_desc_read(entry_priv->desc, 2, &rxdesc->iv[0]);
 		_rt2x00_desc_read(entry_priv->desc, 3, &rxdesc->iv[1]);
+		rxdesc->dev_flags |= RXDONE_CRYPTO_IV;
+
 		_rt2x00_desc_read(entry_priv->desc, 4, &rxdesc->icv);
+		rxdesc->dev_flags |= RXDONE_CRYPTO_ICV;
 
 		/*
 		 * Hardware has stripped IV/EIV data from 802.11 frame during
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 79475a8..563be0b 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1620,7 +1620,10 @@ static void rt73usb_fill_rxdone(struct queue_entry *entry,
 	if (rxdesc->cipher != CIPHER_NONE) {
 		_rt2x00_desc_read(rxd, 2, &rxdesc->iv[0]);
 		_rt2x00_desc_read(rxd, 3, &rxdesc->iv[1]);
+		rxdesc->dev_flags |= RXDONE_CRYPTO_IV;
+
 		_rt2x00_desc_read(rxd, 4, &rxdesc->icv);
+		rxdesc->dev_flags |= RXDONE_CRYPTO_ICV;
 
 		/*
 		 * Hardware has stripped IV/EIV data from 802.11 frame during
-- 
1.5.6.1

