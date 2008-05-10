Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:21084 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbYEJMKX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 08:10:23 -0400
Received: by nf-out-0910.google.com with SMTP id d3so883147nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2008 05:10:22 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 13/16] rt2x00: Remove redundant flags/dev_flags initializations
Date: Sat, 10 May 2008 13:46:08 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200805101337.14536.IvDoorn@gmail.com>
In-Reply-To: <200805101337.14536.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200805101346.08465.IvDoorn@gmail.com> (sfid-20080510_141037_047891_AF7370C1)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

the rxdesc structure is properly memsetted before passed to
the driver. This means we don't have to reinitialize the flags
and dev_flags fields in the drivers again.
This will prevent problems when the rxdone handler is adding
flags in a earlier status and will make the code look nicer
when we are adding more read attributes in the rxdone handler
in the driver.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    3 +--
 drivers/net/wireless/rt2x00/rt2500pci.c |    2 --
 drivers/net/wireless/rt2x00/rt2500usb.c |    2 --
 drivers/net/wireless/rt2x00/rt61pci.c   |    2 --
 drivers/net/wireless/rt2x00/rt73usb.c   |    2 --
 5 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 63ef3e0..8c9f961 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1087,7 +1087,6 @@ static void rt2400pci_fill_rxdone(struct queue_entry *entry,
 	rt2x00_desc_read(priv_rx->desc, 2, &word2);
 	rt2x00_desc_read(priv_rx->desc, 3, &word3);
 
-	rxdesc->flags = 0;
 	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR))
 		rxdesc->flags |= RX_FLAG_FAILED_FCS_CRC;
 	if (rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR))
@@ -1103,7 +1102,7 @@ static void rt2400pci_fill_rxdone(struct queue_entry *entry,
 	    entry->queue->rt2x00dev->rssi_offset;
 	rxdesc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
 
-	rxdesc->dev_flags = RXDONE_SIGNAL_PLCP;
+	rxdesc->dev_flags |= RXDONE_SIGNAL_PLCP;
 	if (rt2x00_get_field32(word0, RXD_W0_MY_BSS))
 		rxdesc->dev_flags |= RXDONE_MY_BSS;
 }
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 24057bc..ed8797a 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1242,7 +1242,6 @@ static void rt2500pci_fill_rxdone(struct queue_entry *entry,
 	rt2x00_desc_read(priv_rx->desc, 0, &word0);
 	rt2x00_desc_read(priv_rx->desc, 2, &word2);
 
-	rxdesc->flags = 0;
 	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR))
 		rxdesc->flags |= RX_FLAG_FAILED_FCS_CRC;
 	if (rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR))
@@ -1259,7 +1258,6 @@ static void rt2500pci_fill_rxdone(struct queue_entry *entry,
 	    entry->queue->rt2x00dev->rssi_offset;
 	rxdesc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
 
-	rxdesc->dev_flags = 0;
 	if (rt2x00_get_field32(word0, RXD_W0_OFDM))
 		rxdesc->dev_flags |= RXDONE_SIGNAL_PLCP;
 	if (rt2x00_get_field32(word0, RXD_W0_MY_BSS))
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 266a89d..c3673ff 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1149,7 +1149,6 @@ static void rt2500usb_fill_rxdone(struct queue_entry *entry,
 	rt2x00_desc_read(rxd, 0, &word0);
 	rt2x00_desc_read(rxd, 1, &word1);
 
-	rxdesc->flags = 0;
 	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR))
 		rxdesc->flags |= RX_FLAG_FAILED_FCS_CRC;
 	if (rt2x00_get_field32(word0, RXD_W0_PHYSICAL_ERROR))
@@ -1166,7 +1165,6 @@ static void rt2500usb_fill_rxdone(struct queue_entry *entry,
 	    entry->queue->rt2x00dev->rssi_offset;
 	rxdesc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
 
-	rxdesc->dev_flags = 0;
 	if (rt2x00_get_field32(word0, RXD_W0_OFDM))
 		rxdesc->dev_flags |= RXDONE_SIGNAL_PLCP;
 	if (rt2x00_get_field32(word0, RXD_W0_MY_BSS))
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 807bc52..fe5f79d 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1668,7 +1668,6 @@ static void rt61pci_fill_rxdone(struct queue_entry *entry,
 	rt2x00_desc_read(priv_rx->desc, 0, &word0);
 	rt2x00_desc_read(priv_rx->desc, 1, &word1);
 
-	rxdesc->flags = 0;
 	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR))
 		rxdesc->flags |= RX_FLAG_FAILED_FCS_CRC;
 
@@ -1682,7 +1681,6 @@ static void rt61pci_fill_rxdone(struct queue_entry *entry,
 	rxdesc->rssi = rt61pci_agc_to_rssi(entry->queue->rt2x00dev, word1);
 	rxdesc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
 
-	rxdesc->dev_flags = 0;
 	if (rt2x00_get_field32(word0, RXD_W0_OFDM))
 		rxdesc->dev_flags |= RXDONE_SIGNAL_PLCP;
 	if (rt2x00_get_field32(word0, RXD_W0_MY_BSS))
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 2949af3..b65a1be 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1423,7 +1423,6 @@ static void rt73usb_fill_rxdone(struct queue_entry *entry,
 	rt2x00_desc_read(rxd, 0, &word0);
 	rt2x00_desc_read(rxd, 1, &word1);
 
-	rxdesc->flags = 0;
 	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR))
 		rxdesc->flags |= RX_FLAG_FAILED_FCS_CRC;
 
@@ -1437,7 +1436,6 @@ static void rt73usb_fill_rxdone(struct queue_entry *entry,
 	rxdesc->rssi = rt73usb_agc_to_rssi(entry->queue->rt2x00dev, word1);
 	rxdesc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
 
-	rxdesc->dev_flags = 0;
 	if (rt2x00_get_field32(word0, RXD_W0_OFDM))
 		rxdesc->dev_flags |= RXDONE_SIGNAL_PLCP;
 	if (rt2x00_get_field32(word0, RXD_W0_MY_BSS))
-- 
1.5.5.1

