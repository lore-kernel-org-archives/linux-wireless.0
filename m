Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:18176 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756750AbXJFMEO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2007 08:04:14 -0400
Received: by ug-out-1314.google.com with SMTP id z38so605539ugc
        for <linux-wireless@vger.kernel.org>; Sat, 06 Oct 2007 05:04:13 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 12/16] rt2x00: Small optimizations
Date: Sat, 6 Oct 2007 14:16:30 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200710061410.31765.IvDoorn@gmail.com>
In-Reply-To: <200710061410.31765.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710061416.30696.IvDoorn@gmail.com> (sfid-20071006_131653_459670_1C9A72C7)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make some small optimizations by removing
some simple if-statements.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |    6 ++----
 drivers/net/wireless/rt2x00/rt61pci.c   |    6 ++----
 drivers/net/wireless/rt2x00/rt73usb.c   |   19 +++++++++----------
 3 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index c4aa466..480527f 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -326,10 +326,8 @@ static void rt2500usb_config_rate(struct rt2x00_dev *rt2x00dev, const int rate)
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR1, reg);
 
 	rt2500usb_register_read(rt2x00dev, TXRX_CSR10, &reg);
-	if (preamble == SHORT_PREAMBLE)
-		rt2x00_set_field16(&reg, TXRX_CSR10_AUTORESPOND_PREAMBLE, 1);
-	else
-		rt2x00_set_field16(&reg, TXRX_CSR10_AUTORESPOND_PREAMBLE, 0);
+	rt2x00_set_field16(&reg, TXRX_CSR10_AUTORESPOND_PREAMBLE,
+			   (preamble == SHORT_PREAMBLE));
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR10, reg);
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index b9051a1..e250f0a 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -357,10 +357,8 @@ static void rt61pci_config_rate(struct rt2x00_dev *rt2x00dev, const int rate)
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR0, reg);
 
 	rt2x00pci_register_read(rt2x00dev, TXRX_CSR4, &reg);
-	if (preamble == SHORT_PREAMBLE)
-		rt2x00_set_field32(&reg, TXRX_CSR4_AUTORESPOND_PREAMBLE, 1);
-	else
-		rt2x00_set_field32(&reg, TXRX_CSR4_AUTORESPOND_PREAMBLE, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR4_AUTORESPOND_PREAMBLE,
+			   (preamble == SHORT_PREAMBLE));
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR4, reg);
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 7cfdf65..d3c57a4 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -195,12 +195,13 @@ rf_write:
 	reg = 0;
 	rt2x00_set_field32(&reg, PHY_CSR4_VALUE, value);
 
-	if (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
-	    rt2x00_rf(&rt2x00dev->chip, RF2527))
-		rt2x00_set_field32(&reg, PHY_CSR4_NUMBER_OF_BITS, 21);
-	else
-		rt2x00_set_field32(&reg, PHY_CSR4_NUMBER_OF_BITS, 20);
-
+	/*
+	 * RF5225 and RF2527 contain 21 bits per RF register value,
+	 * all others contain 20 bits.
+	 */
+	rt2x00_set_field32(&reg, PHY_CSR4_NUMBER_OF_BITS,
+			   20 + !!(rt2x00_rf(&rt2x00dev->chip, RF5225) ||
+				   rt2x00_rf(&rt2x00dev->chip, RF2527)));
 	rt2x00_set_field32(&reg, PHY_CSR4_IF_SELECT, 0);
 	rt2x00_set_field32(&reg, PHY_CSR4_BUSY, 1);
 
@@ -331,10 +332,8 @@ static void rt73usb_config_rate(struct rt2x00_dev *rt2x00dev, const int rate)
 	rt73usb_register_write(rt2x00dev, TXRX_CSR0, reg);
 
 	rt73usb_register_read(rt2x00dev, TXRX_CSR4, &reg);
-	if (preamble == SHORT_PREAMBLE)
-		rt2x00_set_field32(&reg, TXRX_CSR4_AUTORESPOND_PREAMBLE, 1);
-	else
-		rt2x00_set_field32(&reg, TXRX_CSR4_AUTORESPOND_PREAMBLE, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR4_AUTORESPOND_PREAMBLE,
+			   (preamble == SHORT_PREAMBLE));
 	rt73usb_register_write(rt2x00dev, TXRX_CSR4, reg);
 }
 
-- 
1.5.3.4

