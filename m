Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:52973 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbXIPMIR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2007 08:08:17 -0400
Received: by an-out-0708.google.com with SMTP id d31so189208and
        for <linux-wireless@vger.kernel.org>; Sun, 16 Sep 2007 05:08:16 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 13/24] rt2x00: Reduce magic value writing to device
Date: Sun, 16 Sep 2007 14:18:55 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709161403.11332.IvDoorn@gmail.com>
In-Reply-To: <200709161403.11332.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200709161418.56854.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By looking closely to the legacy drivers, and most notably the comments,
comparison between similar chipsets (rt2500pci-rt2500usb rt61pci-rt73usb),
and straightout guessing we can now add quite a lot of register definitions
and split the magical value up into more logical values or at least make
them slightly less magical.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500pci.c |   39 +++++++++++---
 drivers/net/wireless/rt2x00/rt2500pci.h |   40 ++++++++++----
 drivers/net/wireless/rt2x00/rt2500usb.c |   56 ++++++++++++++++---
 drivers/net/wireless/rt2x00/rt2500usb.h |   39 ++++++++++++--
 drivers/net/wireless/rt2x00/rt61pci.c   |   88 +++++++++++++++++++++++++++---
 drivers/net/wireless/rt2x00/rt61pci.h   |   77 ++++++++++++++++++++++++++-
 drivers/net/wireless/rt2x00/rt73usb.c   |   60 +++++++++++++++++++--
 drivers/net/wireless/rt2x00/rt73usb.h   |   60 +++++++++++++++++++++-
 8 files changed, 408 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 444e530..fc28631 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -930,24 +930,45 @@ static int rt2500pci_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00pci_register_write(rt2x00dev, CNT3, 0);
 
 	rt2x00pci_register_read(rt2x00dev, TXCSR8, &reg);
-	rt2x00_set_field32(&reg, TXCSR8_CCK_SIGNAL, 0x8a);
-	rt2x00_set_field32(&reg, TXCSR8_CCK_SERVICE, 0x8b);
-	rt2x00_set_field32(&reg, TXCSR8_CCK_LENGTH_LOW, 0x8d);
-	rt2x00_set_field32(&reg, TXCSR8_CCK_LENGTH_HIGH, 0x8c);
+	rt2x00_set_field32(&reg, TXCSR8_BBP_ID0, 10);
+	rt2x00_set_field32(&reg, TXCSR8_BBP_ID0_VALID, 1);
+	rt2x00_set_field32(&reg, TXCSR8_BBP_ID1, 11);
+	rt2x00_set_field32(&reg, TXCSR8_BBP_ID1_VALID, 1);
+	rt2x00_set_field32(&reg, TXCSR8_BBP_ID2, 13);
+	rt2x00_set_field32(&reg, TXCSR8_BBP_ID2_VALID, 1);
+	rt2x00_set_field32(&reg, TXCSR8_BBP_ID3, 12);
+	rt2x00_set_field32(&reg, TXCSR8_BBP_ID3_VALID, 1);
 	rt2x00pci_register_write(rt2x00dev, TXCSR8, reg);
 
-	rt2x00pci_register_write(rt2x00dev, ARTCSR0, 0x7038140a);
-	rt2x00pci_register_write(rt2x00dev, ARTCSR1, 0x1d21252d);
-	rt2x00pci_register_write(rt2x00dev, ARTCSR2, 0x1919191d);
+	rt2x00pci_register_read(rt2x00dev, ARTCSR0, &reg);
+	rt2x00_set_field32(&reg, ARTCSR0_ACK_CTS_1MBS, 112);
+	rt2x00_set_field32(&reg, ARTCSR0_ACK_CTS_2MBS, 56);
+	rt2x00_set_field32(&reg, ARTCSR0_ACK_CTS_5_5MBS, 20);
+	rt2x00_set_field32(&reg, ARTCSR0_ACK_CTS_11MBS, 10);
+	rt2x00pci_register_write(rt2x00dev, ARTCSR0, reg);
+
+	rt2x00pci_register_read(rt2x00dev, ARTCSR1, &reg);
+	rt2x00_set_field32(&reg, ARTCSR1_ACK_CTS_6MBS, 45);
+	rt2x00_set_field32(&reg, ARTCSR1_ACK_CTS_9MBS, 37);
+	rt2x00_set_field32(&reg, ARTCSR1_ACK_CTS_12MBS, 33);
+	rt2x00_set_field32(&reg, ARTCSR1_ACK_CTS_18MBS, 29);
+	rt2x00pci_register_write(rt2x00dev, ARTCSR1, reg);
+
+	rt2x00pci_register_read(rt2x00dev, ARTCSR2, &reg);
+	rt2x00_set_field32(&reg, ARTCSR2_ACK_CTS_24MBS, 29);
+	rt2x00_set_field32(&reg, ARTCSR2_ACK_CTS_36MBS, 25);
+	rt2x00_set_field32(&reg, ARTCSR2_ACK_CTS_48MBS, 25);
+	rt2x00_set_field32(&reg, ARTCSR2_ACK_CTS_54MBS, 25);
+	rt2x00pci_register_write(rt2x00dev, ARTCSR2, reg);
 
 	rt2x00pci_register_read(rt2x00dev, RXCSR3, &reg);
-	rt2x00_set_field32(&reg, RXCSR3_BBP_ID0, 47); /* Signal */
+	rt2x00_set_field32(&reg, RXCSR3_BBP_ID0, 47); /* CCK Signal */
 	rt2x00_set_field32(&reg, RXCSR3_BBP_ID0_VALID, 1);
 	rt2x00_set_field32(&reg, RXCSR3_BBP_ID1, 51); /* Rssi */
 	rt2x00_set_field32(&reg, RXCSR3_BBP_ID1_VALID, 1);
 	rt2x00_set_field32(&reg, RXCSR3_BBP_ID2, 42); /* OFDM Rate */
 	rt2x00_set_field32(&reg, RXCSR3_BBP_ID2_VALID, 1);
-	rt2x00_set_field32(&reg, RXCSR3_BBP_ID3, 51); /* OFDM */
+	rt2x00_set_field32(&reg, RXCSR3_BBP_ID3, 51); /* RSSI */
 	rt2x00_set_field32(&reg, RXCSR3_BBP_ID3_VALID, 1);
 	rt2x00pci_register_write(rt2x00dev, RXCSR3, reg);
 
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.h b/drivers/net/wireless/rt2x00/rt2500pci.h
index 5db6cde..d92aa56 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/rt2x00/rt2500pci.h
@@ -440,16 +440,16 @@
 
 /*
  * TXCSR8: CCK Tx BBP register.
- * CCK_SIGNAL: BBP rate field address for CCK.
- * CCK_SERVICE: BBP service field address for CCK.
- * CCK_LENGTH_LOW: BBP length low byte address for CCK.
- * CCK_LENGTH_HIGH: BBP length high byte address for CCK.
  */
 #define TXCSR8				0x0098
-#define TXCSR8_CCK_SIGNAL		FIELD32(0x000000ff)
-#define TXCSR8_CCK_SERVICE		FIELD32(0x0000ff00)
-#define TXCSR8_CCK_LENGTH_LOW		FIELD32(0x00ff0000)
-#define TXCSR8_CCK_LENGTH_HIGH		FIELD32(0xff000000)
+#define TXCSR8_BBP_ID0			FIELD32(0x0000007f)
+#define TXCSR8_BBP_ID0_VALID		FIELD32(0x00000080)
+#define TXCSR8_BBP_ID1			FIELD32(0x00007f00)
+#define TXCSR8_BBP_ID1_VALID		FIELD32(0x00008000)
+#define TXCSR8_BBP_ID2			FIELD32(0x007f0000)
+#define TXCSR8_BBP_ID2_VALID		FIELD32(0x00800000)
+#define TXCSR8_BBP_ID3			FIELD32(0x7f000000)
+#define TXCSR8_BBP_ID3_VALID		FIELD32(0x80000000)
 
 /*
  * TXCSR9: OFDM TX BBP registers
@@ -864,14 +864,32 @@
 #define ARCSR5_LENGTH			FIELD32(0xffff0000)
 
 /*
- * ACK/CTS payload consumed time registers.
  * ARTCSR0: CCK ACK/CTS payload consumed time for 1/2/5.5/11 mbps.
- * ARTCSR1: OFDM ACK/CTS payload consumed time for 6/9/12/18 mbps.
- * ARTCSR2: OFDM ACK/CTS payload consumed time for 24/36/48/54 mbps.
  */
 #define ARTCSR0				0x014c
+#define ARTCSR0_ACK_CTS_11MBS		FIELD32(0x000000ff)
+#define ARTCSR0_ACK_CTS_5_5MBS		FIELD32(0x0000ff00)
+#define ARTCSR0_ACK_CTS_2MBS		FIELD32(0x00ff0000)
+#define ARTCSR0_ACK_CTS_1MBS		FIELD32(0xff000000)
+
+
+/*
+ * ARTCSR1: OFDM ACK/CTS payload consumed time for 6/9/12/18 mbps.
+ */
 #define ARTCSR1				0x0150
+#define ARTCSR1_ACK_CTS_6MBS		FIELD32(0x000000ff)
+#define ARTCSR1_ACK_CTS_9MBS		FIELD32(0x0000ff00)
+#define ARTCSR1_ACK_CTS_12MBS		FIELD32(0x00ff0000)
+#define ARTCSR1_ACK_CTS_18MBS		FIELD32(0xff000000)
+
+/*
+ * ARTCSR2: OFDM ACK/CTS payload consumed time for 24/36/48/54 mbps.
+ */
 #define ARTCSR2				0x0154
+#define ARTCSR2_ACK_CTS_24MBS		FIELD32(0x000000ff)
+#define ARTCSR2_ACK_CTS_36MBS		FIELD32(0x0000ff00)
+#define ARTCSR2_ACK_CTS_48MBS		FIELD32(0x00ff0000)
+#define ARTCSR2_ACK_CTS_54MBS		FIELD32(0xff000000)
 
 /*
  * SECCSR1_RT2509: WEP control register.
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 7e8cd47..2c2d8b7 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -796,20 +796,57 @@ static int rt2500usb_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2500usb_register_write(rt2x00dev, MAC_CSR13, 0x1111);
 	rt2500usb_register_write(rt2x00dev, MAC_CSR14, 0x1e11);
 
-	rt2500usb_register_write(rt2x00dev, MAC_CSR1, 0x0003);
-	rt2500usb_register_write(rt2x00dev, MAC_CSR1, 0x0000);
+	rt2500usb_register_read(rt2x00dev, MAC_CSR1, &reg);
+	rt2x00_set_field16(&reg, MAC_CSR1_SOFT_RESET, 1);
+	rt2x00_set_field16(&reg, MAC_CSR1_BBP_RESET, 1);
+	rt2x00_set_field16(&reg, MAC_CSR1_HOST_READY, 0);
+	rt2500usb_register_write(rt2x00dev, MAC_CSR1, reg);
+
+	rt2500usb_register_read(rt2x00dev, MAC_CSR1, &reg);
+	rt2x00_set_field16(&reg, MAC_CSR1_SOFT_RESET, 0);
+	rt2x00_set_field16(&reg, MAC_CSR1_BBP_RESET, 0);
+	rt2x00_set_field16(&reg, MAC_CSR1_HOST_READY, 0);
+	rt2500usb_register_write(rt2x00dev, MAC_CSR1, reg);
+
+	rt2500usb_register_read(rt2x00dev, TXRX_CSR5, &reg);
+	rt2x00_set_field16(&reg, TXRX_CSR5_BBP_ID0, 13);
+	rt2x00_set_field16(&reg, TXRX_CSR5_BBP_ID0_VALID, 1);
+	rt2x00_set_field16(&reg, TXRX_CSR5_BBP_ID1, 12);
+	rt2x00_set_field16(&reg, TXRX_CSR5_BBP_ID1_VALID, 1);
+	rt2500usb_register_write(rt2x00dev, TXRX_CSR5, reg);
+
+	rt2500usb_register_read(rt2x00dev, TXRX_CSR6, &reg);
+	rt2x00_set_field16(&reg, TXRX_CSR6_BBP_ID0, 10);
+	rt2x00_set_field16(&reg, TXRX_CSR6_BBP_ID0_VALID, 1);
+	rt2x00_set_field16(&reg, TXRX_CSR6_BBP_ID1, 11);
+	rt2x00_set_field16(&reg, TXRX_CSR6_BBP_ID1_VALID, 1);
+	rt2500usb_register_write(rt2x00dev, TXRX_CSR6, reg);
+
+	rt2500usb_register_read(rt2x00dev, TXRX_CSR7, &reg);
+	rt2x00_set_field16(&reg, TXRX_CSR7_BBP_ID0, 7);
+	rt2x00_set_field16(&reg, TXRX_CSR7_BBP_ID0_VALID, 1);
+	rt2x00_set_field16(&reg, TXRX_CSR7_BBP_ID1, 6);
+	rt2x00_set_field16(&reg, TXRX_CSR7_BBP_ID1_VALID, 1);
+	rt2500usb_register_write(rt2x00dev, TXRX_CSR7, reg);
+
+	rt2500usb_register_read(rt2x00dev, TXRX_CSR8, &reg);
+	rt2x00_set_field16(&reg, TXRX_CSR8_BBP_ID0, 5);
+	rt2x00_set_field16(&reg, TXRX_CSR8_BBP_ID0_VALID, 1);
+	rt2x00_set_field16(&reg, TXRX_CSR8_BBP_ID1, 0);
+	rt2x00_set_field16(&reg, TXRX_CSR8_BBP_ID1_VALID, 0);
+	rt2500usb_register_write(rt2x00dev, TXRX_CSR8, reg);
 
-	rt2500usb_register_write(rt2x00dev, TXRX_CSR5, 0x8c8d);
-	rt2500usb_register_write(rt2x00dev, TXRX_CSR6, 0x8b8a);
-	rt2500usb_register_write(rt2x00dev, TXRX_CSR7, 0x8687);
-	rt2500usb_register_write(rt2x00dev, TXRX_CSR8, 0x0085);
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR21, 0xe78f);
 	rt2500usb_register_write(rt2x00dev, MAC_CSR9, 0xff1d);
 
 	if (rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_AWAKE))
 		return -EBUSY;
 
-	rt2500usb_register_write(rt2x00dev, MAC_CSR1, 0x0004);
+	rt2500usb_register_read(rt2x00dev, MAC_CSR1, &reg);
+	rt2x00_set_field16(&reg, MAC_CSR1_SOFT_RESET, 0);
+	rt2x00_set_field16(&reg, MAC_CSR1_BBP_RESET, 0);
+	rt2x00_set_field16(&reg, MAC_CSR1_HOST_READY, 1);
+	rt2500usb_register_write(rt2x00dev, MAC_CSR1, reg);
 
 	if (rt2x00_get_rev(&rt2x00dev->chip) >= RT2570_VERSION_C) {
 		rt2500usb_register_read(rt2x00dev, PHY_CSR2, &reg);
@@ -835,11 +872,12 @@ static int rt2500usb_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR0, reg);
 
 	rt2500usb_register_read(rt2x00dev, MAC_CSR18, &reg);
-	rt2x00_set_field16(&reg, MAC_CSR18_DELAY_AFTER_BEACON, 0x5a);
+	rt2x00_set_field16(&reg, MAC_CSR18_DELAY_AFTER_BEACON, 90);
 	rt2500usb_register_write(rt2x00dev, MAC_CSR18, reg);
 
 	rt2500usb_register_read(rt2x00dev, PHY_CSR4, &reg);
-	rt2500usb_register_write(rt2x00dev, PHY_CSR4, reg | 0x0001);
+	rt2x00_set_field16(&reg, PHY_CSR4_LOW_RF_LE, 1);
+	rt2500usb_register_write(rt2x00dev, PHY_CSR4, reg);
 
 	rt2500usb_register_read(rt2x00dev, TXRX_CSR1, &reg);
 	rt2x00_set_field16(&reg, TXRX_CSR1_AUTO_SEQUENCE, 1);
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless/rt2x00/rt2500usb.h
index b5033da..b18d56e 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/rt2x00/rt2500usb.h
@@ -74,8 +74,14 @@
 
 /*
  * MAC_CSR1: System control.
+ * SOFT_RESET: Software reset, 1: reset, 0: normal.
+ * BBP_RESET: Hardware reset, 1: reset, 0, release.
+ * HOST_READY: Host ready after initialization.
  */
 #define MAC_CSR1			0x0402
+#define MAC_CSR1_SOFT_RESET		FIELD16(0x00000001)
+#define MAC_CSR1_BBP_RESET		FIELD16(0x00000002)
+#define MAC_CSR1_HOST_READY		FIELD16(0x00000004)
 
 /*
  * MAC_CSR2: STA MAC register 0.
@@ -260,16 +266,40 @@
 #define TXRX_CSR4			0x0448
 
 /*
- * TX BBP ID registers
  * TXRX_CSR5: CCK TX BBP ID0.
- * TXRX_CSR5: CCK TX BBP ID1.
- * TXRX_CSR5: OFDM TX BBP ID0.
- * TXRX_CSR5: OFDM TX BBP ID1.
  */
 #define TXRX_CSR5			0x044a
+#define TXRX_CSR5_BBP_ID0		FIELD16(0x007f)
+#define TXRX_CSR5_BBP_ID0_VALID		FIELD16(0x0080)
+#define TXRX_CSR5_BBP_ID1		FIELD16(0x7f00)
+#define TXRX_CSR5_BBP_ID1_VALID		FIELD16(0x8000)
+
+/*
+ * TXRX_CSR6: CCK TX BBP ID1.
+ */
 #define TXRX_CSR6			0x044c
+#define TXRX_CSR6_BBP_ID0		FIELD16(0x007f)
+#define TXRX_CSR6_BBP_ID0_VALID		FIELD16(0x0080)
+#define TXRX_CSR6_BBP_ID1		FIELD16(0x7f00)
+#define TXRX_CSR6_BBP_ID1_VALID		FIELD16(0x8000)
+
+/*
+ * TXRX_CSR7: OFDM TX BBP ID0.
+ */
 #define TXRX_CSR7			0x044e
+#define TXRX_CSR7_BBP_ID0		FIELD16(0x007f)
+#define TXRX_CSR7_BBP_ID0_VALID		FIELD16(0x0080)
+#define TXRX_CSR7_BBP_ID1		FIELD16(0x7f00)
+#define TXRX_CSR7_BBP_ID1_VALID		FIELD16(0x8000)
+
+/*
+ * TXRX_CSR5: OFDM TX BBP ID1.
+ */
 #define TXRX_CSR8			0x0450
+#define TXRX_CSR8_BBP_ID0		FIELD16(0x007f)
+#define TXRX_CSR8_BBP_ID0_VALID		FIELD16(0x0080)
+#define TXRX_CSR8_BBP_ID1		FIELD16(0x7f00)
+#define TXRX_CSR8_BBP_ID1_VALID		FIELD16(0x8000)
 
 /*
  * TXRX_CSR9: TX ACK time-out.
@@ -410,6 +440,7 @@
  * PHY_CSR4: Interface configuration.
  */
 #define PHY_CSR4			0x04c8
+#define PHY_CSR4_LOW_RF_LE		FIELD16(0x0001)
 
 /*
  * BBP pre-TX registers.
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 0c53b61..a2d852f 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1287,9 +1287,25 @@ static int rt61pci_init_rings(struct rt2x00_dev *rt2x00dev)
 			   rt2x00dev->rx->data_dma);
 	rt2x00pci_register_write(rt2x00dev, RX_BASE_CSR, reg);
 
-	rt2x00pci_register_write(rt2x00dev, TX_DMA_DST_CSR, 0x000000aa);
-	rt2x00pci_register_write(rt2x00dev, LOAD_TX_RING_CSR, 0x0000001f);
-	rt2x00pci_register_write(rt2x00dev, RX_CNTL_CSR, 0x00000002);
+	rt2x00pci_register_read(rt2x00dev, TX_DMA_DST_CSR, &reg);
+	rt2x00_set_field32(&reg, TX_DMA_DST_CSR_DEST_AC0, 2);
+	rt2x00_set_field32(&reg, TX_DMA_DST_CSR_DEST_AC1, 2);
+	rt2x00_set_field32(&reg, TX_DMA_DST_CSR_DEST_AC2, 2);
+	rt2x00_set_field32(&reg, TX_DMA_DST_CSR_DEST_AC3, 2);
+	rt2x00_set_field32(&reg, TX_DMA_DST_CSR_DEST_MGMT, 0);
+	rt2x00pci_register_write(rt2x00dev, TX_DMA_DST_CSR, reg);
+
+	rt2x00pci_register_read(rt2x00dev, LOAD_TX_RING_CSR, &reg);
+	rt2x00_set_field32(&reg, LOAD_TX_RING_CSR_LOAD_TXD_AC0, 1);
+	rt2x00_set_field32(&reg, LOAD_TX_RING_CSR_LOAD_TXD_AC1, 1);
+	rt2x00_set_field32(&reg, LOAD_TX_RING_CSR_LOAD_TXD_AC2, 1);
+	rt2x00_set_field32(&reg, LOAD_TX_RING_CSR_LOAD_TXD_AC3, 1);
+	rt2x00_set_field32(&reg, LOAD_TX_RING_CSR_LOAD_TXD_MGMT, 1);
+	rt2x00pci_register_write(rt2x00dev, LOAD_TX_RING_CSR, reg);
+
+	rt2x00pci_register_read(rt2x00dev, RX_CNTL_CSR, &reg);
+	rt2x00_set_field32(&reg, RX_CNTL_CSR_LOAD_RXD, 1);
+	rt2x00pci_register_write(rt2x00dev, RX_CNTL_CSR, reg);
 
 	return 0;
 }
@@ -1304,11 +1320,57 @@ static int rt61pci_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, TXRX_CSR0_TX_WITHOUT_WAITING, 0);
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR0, reg);
 
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR1, 0x9eb39eb3);
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR2, 0x8a8b8c8d);
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR3, 0x00858687);
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR7, 0x2e31353b);
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR8, 0x2a2a2a2c);
+	rt2x00pci_register_read(rt2x00dev, TXRX_CSR1, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR1_BBP_ID0, 47); /* CCK Signal */
+	rt2x00_set_field32(&reg, TXRX_CSR1_BBP_ID0_VALID, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR1_BBP_ID1, 30); /* Rssi */
+	rt2x00_set_field32(&reg, TXRX_CSR1_BBP_ID1_VALID, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR1_BBP_ID2, 42); /* OFDM Rate */
+	rt2x00_set_field32(&reg, TXRX_CSR1_BBP_ID2_VALID, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR1_BBP_ID3, 30); /* Rssi */
+	rt2x00_set_field32(&reg, TXRX_CSR1_BBP_ID3_VALID, 1);
+	rt2x00pci_register_write(rt2x00dev, TXRX_CSR1, reg);
+
+	/*
+	 * CCK TXD BBP registers
+	 */
+	rt2x00pci_register_read(rt2x00dev, TXRX_CSR2, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR2_BBP_ID0, 13);
+	rt2x00_set_field32(&reg, TXRX_CSR2_BBP_ID0_VALID, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR2_BBP_ID1, 12);
+	rt2x00_set_field32(&reg, TXRX_CSR2_BBP_ID1_VALID, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR2_BBP_ID2, 11);
+	rt2x00_set_field32(&reg, TXRX_CSR2_BBP_ID2_VALID, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR2_BBP_ID3, 10);
+	rt2x00_set_field32(&reg, TXRX_CSR2_BBP_ID3_VALID, 1);
+	rt2x00pci_register_write(rt2x00dev, TXRX_CSR2, reg);
+
+	/*
+	 * OFDM TXD BBP registers
+	 */
+	rt2x00pci_register_read(rt2x00dev, TXRX_CSR3, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR3_BBP_ID0, 7);
+	rt2x00_set_field32(&reg, TXRX_CSR3_BBP_ID0_VALID, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR3_BBP_ID1, 6);
+	rt2x00_set_field32(&reg, TXRX_CSR3_BBP_ID1_VALID, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR3_BBP_ID2, 5);
+	rt2x00_set_field32(&reg, TXRX_CSR3_BBP_ID2_VALID, 1);
+	rt2x00pci_register_write(rt2x00dev, TXRX_CSR3, reg);
+
+	rt2x00pci_register_read(rt2x00dev, TXRX_CSR7, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR7_ACK_CTS_6MBS, 59);
+	rt2x00_set_field32(&reg, TXRX_CSR7_ACK_CTS_9MBS, 53);
+	rt2x00_set_field32(&reg, TXRX_CSR7_ACK_CTS_12MBS, 49);
+	rt2x00_set_field32(&reg, TXRX_CSR7_ACK_CTS_18MBS, 46);
+	rt2x00pci_register_write(rt2x00dev, TXRX_CSR7, reg);
+
+	rt2x00pci_register_read(rt2x00dev, TXRX_CSR8, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR8_ACK_CTS_24MBS, 44);
+	rt2x00_set_field32(&reg, TXRX_CSR8_ACK_CTS_36MBS, 42);
+	rt2x00_set_field32(&reg, TXRX_CSR8_ACK_CTS_48MBS, 42);
+	rt2x00_set_field32(&reg, TXRX_CSR8_ACK_CTS_54MBS, 42);
+	rt2x00pci_register_write(rt2x00dev, TXRX_CSR8, reg);
+
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR15, 0x0000000f);
 
 	rt2x00pci_register_write(rt2x00dev, MAC_CSR6, 0x00000fff);
@@ -1324,6 +1386,10 @@ static int rt61pci_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	rt2x00pci_register_write(rt2x00dev, MAC_CSR13, 0x0000e000);
 
+	/*
+	 * Invalidate all Shared Keys (SEC_CSR0),
+	 * and clear the Shared key Cipher algorithms (SEC_CSR1 & SEC_CSR5)
+	 */
 	rt2x00pci_register_write(rt2x00dev, SEC_CSR0, 0x00000000);
 	rt2x00pci_register_write(rt2x00dev, SEC_CSR1, 0x00000000);
 	rt2x00pci_register_write(rt2x00dev, SEC_CSR5, 0x00000000);
@@ -1496,6 +1562,8 @@ static void rt61pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 
 static int rt61pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 {
+	u32 reg;
+
 	/*
 	 * Initialize all registers.
 	 */
@@ -1514,7 +1582,9 @@ static int rt61pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Enable RX.
 	 */
-	rt2x00pci_register_write(rt2x00dev, RX_CNTL_CSR, 0x00000001);
+	rt2x00pci_register_read(rt2x00dev, RX_CNTL_CSR, &reg);
+	rt2x00_set_field32(&reg, RX_CNTL_CSR_ENABLE_RX_DMA, 1);
+	rt2x00pci_register_write(rt2x00dev, RX_CNTL_CSR, reg);
 
 	/*
 	 * Enable LED
diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
index bd3e283..f24bff3 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -399,16 +399,40 @@ struct hw_pairwise_ta_entry {
  * TXRX_CSR1
  */
 #define TXRX_CSR1			0x3044
+#define TXRX_CSR1_BBP_ID0		FIELD32(0x0000007f)
+#define TXRX_CSR1_BBP_ID0_VALID		FIELD32(0x00000080)
+#define TXRX_CSR1_BBP_ID1		FIELD32(0x00007f00)
+#define TXRX_CSR1_BBP_ID1_VALID		FIELD32(0x00008000)
+#define TXRX_CSR1_BBP_ID2		FIELD32(0x007f0000)
+#define TXRX_CSR1_BBP_ID2_VALID		FIELD32(0x00800000)
+#define TXRX_CSR1_BBP_ID3		FIELD32(0x7f000000)
+#define TXRX_CSR1_BBP_ID3_VALID		FIELD32(0x80000000)
 
 /*
  * TXRX_CSR2
  */
 #define TXRX_CSR2			0x3048
+#define TXRX_CSR2_BBP_ID0		FIELD32(0x0000007f)
+#define TXRX_CSR2_BBP_ID0_VALID		FIELD32(0x00000080)
+#define TXRX_CSR2_BBP_ID1		FIELD32(0x00007f00)
+#define TXRX_CSR2_BBP_ID1_VALID		FIELD32(0x00008000)
+#define TXRX_CSR2_BBP_ID2		FIELD32(0x007f0000)
+#define TXRX_CSR2_BBP_ID2_VALID		FIELD32(0x00800000)
+#define TXRX_CSR2_BBP_ID3		FIELD32(0x7f000000)
+#define TXRX_CSR2_BBP_ID3_VALID		FIELD32(0x80000000)
 
 /*
  * TXRX_CSR3
  */
 #define TXRX_CSR3			0x304c
+#define TXRX_CSR3_BBP_ID0		FIELD32(0x0000007f)
+#define TXRX_CSR3_BBP_ID0_VALID		FIELD32(0x00000080)
+#define TXRX_CSR3_BBP_ID1		FIELD32(0x00007f00)
+#define TXRX_CSR3_BBP_ID1_VALID		FIELD32(0x00008000)
+#define TXRX_CSR3_BBP_ID2		FIELD32(0x007f0000)
+#define TXRX_CSR3_BBP_ID2_VALID		FIELD32(0x00800000)
+#define TXRX_CSR3_BBP_ID3		FIELD32(0x7f000000)
+#define TXRX_CSR3_BBP_ID3_VALID		FIELD32(0x80000000)
 
 /*
  * TXRX_CSR4: Auto-Responder/Tx-retry register.
@@ -435,11 +459,27 @@ struct hw_pairwise_ta_entry {
 #define TXRX_CSR5			0x3054
 
 /*
- * ACK/CTS payload consumed time registers.
+ * TXRX_CSR6: ACK/CTS payload consumed time
  */
 #define TXRX_CSR6			0x3058
+
+/*
+ * TXRX_CSR7: OFDM ACK/CTS payload consumed time for 6/9/12/18 mbps.
+ */
 #define TXRX_CSR7			0x305c
+#define TXRX_CSR7_ACK_CTS_6MBS		FIELD32(0x000000ff)
+#define TXRX_CSR7_ACK_CTS_9MBS		FIELD32(0x0000ff00)
+#define TXRX_CSR7_ACK_CTS_12MBS		FIELD32(0x00ff0000)
+#define TXRX_CSR7_ACK_CTS_18MBS		FIELD32(0xff000000)
+
+/*
+ * TXRX_CSR8: OFDM ACK/CTS payload consumed time for 24/36/48/54 mbps.
+ */
 #define TXRX_CSR8			0x3060
+#define TXRX_CSR8_ACK_CTS_24MBS		FIELD32(0x000000ff)
+#define TXRX_CSR8_ACK_CTS_36MBS		FIELD32(0x0000ff00)
+#define TXRX_CSR8_ACK_CTS_48MBS		FIELD32(0x00ff0000)
+#define TXRX_CSR8_ACK_CTS_54MBS		FIELD32(0xff000000)
 
 /*
  * TXRX_CSR9: Synchronization control register.
@@ -542,11 +582,13 @@ struct hw_pairwise_ta_entry {
  * PHY_CSR5: RX to TX signal switch timing control.
  */
 #define PHY_CSR5			0x3094
+#define PHY_CSR5_IQ_FLIP		FIELD32(0x00000004)
 
 /*
  * PHY_CSR6: TX to RX signal timing control.
  */
 #define PHY_CSR6			0x3098
+#define PHY_CSR6_IQ_FLIP		FIELD32(0x00000004)
 
 /*
  * PHY_CSR7: TX DAC switching timing control.
@@ -561,6 +603,22 @@ struct hw_pairwise_ta_entry {
  * SEC_CSR0: Shared key table control.
  */
 #define SEC_CSR0			0x30a0
+#define SEC_CSR0_BSS0_KEY0_VALID	FIELD32(0x00000001)
+#define SEC_CSR0_BSS0_KEY1_VALID	FIELD32(0x00000002)
+#define SEC_CSR0_BSS0_KEY2_VALID	FIELD32(0x00000004)
+#define SEC_CSR0_BSS0_KEY3_VALID	FIELD32(0x00000008)
+#define SEC_CSR0_BSS1_KEY0_VALID	FIELD32(0x00000010)
+#define SEC_CSR0_BSS1_KEY1_VALID	FIELD32(0x00000020)
+#define SEC_CSR0_BSS1_KEY2_VALID	FIELD32(0x00000040)
+#define SEC_CSR0_BSS1_KEY3_VALID	FIELD32(0x00000080)
+#define SEC_CSR0_BSS2_KEY0_VALID	FIELD32(0x00000100)
+#define SEC_CSR0_BSS2_KEY1_VALID	FIELD32(0x00000200)
+#define SEC_CSR0_BSS2_KEY2_VALID	FIELD32(0x00000400)
+#define SEC_CSR0_BSS2_KEY3_VALID	FIELD32(0x00000800)
+#define SEC_CSR0_BSS3_KEY0_VALID	FIELD32(0x00001000)
+#define SEC_CSR0_BSS3_KEY1_VALID	FIELD32(0x00002000)
+#define SEC_CSR0_BSS3_KEY2_VALID	FIELD32(0x00004000)
+#define SEC_CSR0_BSS3_KEY3_VALID	FIELD32(0x00008000)
 
 /*
  * SEC_CSR1: Shared key table security mode register.
@@ -774,9 +832,15 @@ struct hw_pairwise_ta_entry {
 #define CWMAX_CSR_CWMAX3		FIELD32(0x0000f000)
 
 /*
- * TX_DMA_DST_CSR
+ * TX_DMA_DST_CSR: TX DMA destination
+ * 0: TX ring0, 1: TX ring1, 2: TX ring2 3: invalid
  */
 #define TX_DMA_DST_CSR			0x342c
+#define TX_DMA_DST_CSR_DEST_AC0		FIELD32(0x00000003)
+#define TX_DMA_DST_CSR_DEST_AC1		FIELD32(0x0000000c)
+#define TX_DMA_DST_CSR_DEST_AC2		FIELD32(0x00000030)
+#define TX_DMA_DST_CSR_DEST_AC3		FIELD32(0x000000c0)
+#define TX_DMA_DST_CSR_DEST_MGMT	FIELD32(0x00000300)
 
 /*
  * TX_CNTL_CSR: KICK/Abort TX.
@@ -802,9 +866,14 @@ struct hw_pairwise_ta_entry {
 #define TX_CNTL_CSR_ABORT_TX_MGMT	FIELD32(0x00100000)
 
 /*
- * LOAD_TX_RING_CSR
+ * LOAD_TX_RING_CSR: Load RX de
  */
 #define LOAD_TX_RING_CSR		0x3434
+#define LOAD_TX_RING_CSR_LOAD_TXD_AC0	FIELD32(0x00000001)
+#define LOAD_TX_RING_CSR_LOAD_TXD_AC1	FIELD32(0x00000002)
+#define LOAD_TX_RING_CSR_LOAD_TXD_AC2	FIELD32(0x00000004)
+#define LOAD_TX_RING_CSR_LOAD_TXD_AC3	FIELD32(0x00000008)
+#define LOAD_TX_RING_CSR_LOAD_TXD_MGMT	FIELD32(0x00000010)
 
 /*
  * Several read-only registers, for debugging.
@@ -834,6 +903,8 @@ struct hw_pairwise_ta_entry {
  * RX_CNTL_CSR
  */
 #define RX_CNTL_CSR			0x3458
+#define RX_CNTL_CSR_ENABLE_RX_DMA	FIELD32(0x00000001)
+#define RX_CNTL_CSR_LOAD_RXD		FIELD32(0x00000002)
 
 /*
  * RXPTR_CSR: Read-only, for debugging.
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 4aef5af..561e29b 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1003,11 +1003,57 @@ static int rt73usb_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, TXRX_CSR0_TX_WITHOUT_WAITING, 0);
 	rt73usb_register_write(rt2x00dev, TXRX_CSR0, reg);
 
-	rt73usb_register_write(rt2x00dev, TXRX_CSR1, 0x9eaa9eaf);
-	rt73usb_register_write(rt2x00dev, TXRX_CSR2, 0x8a8b8c8d);
-	rt73usb_register_write(rt2x00dev, TXRX_CSR3, 0x00858687);
-	rt73usb_register_write(rt2x00dev, TXRX_CSR7, 0x2e31353b);
-	rt73usb_register_write(rt2x00dev, TXRX_CSR8, 0x2a2a2a2c);
+	rt73usb_register_read(rt2x00dev, TXRX_CSR1, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR1_BBP_ID0, 47); /* CCK Signal */
+	rt2x00_set_field32(&reg, TXRX_CSR1_BBP_ID0_VALID, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR1_BBP_ID1, 30); /* Rssi */
+	rt2x00_set_field32(&reg, TXRX_CSR1_BBP_ID1_VALID, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR1_BBP_ID2, 42); /* OFDM Rate */
+	rt2x00_set_field32(&reg, TXRX_CSR1_BBP_ID2_VALID, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR1_BBP_ID3, 30); /* Rssi */
+	rt2x00_set_field32(&reg, TXRX_CSR1_BBP_ID3_VALID, 1);
+	rt73usb_register_write(rt2x00dev, TXRX_CSR1, reg);
+
+	/*
+	 * CCK TXD BBP registers
+	 */
+	rt73usb_register_read(rt2x00dev, TXRX_CSR2, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR2_BBP_ID0, 13);
+	rt2x00_set_field32(&reg, TXRX_CSR2_BBP_ID0_VALID, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR2_BBP_ID1, 12);
+	rt2x00_set_field32(&reg, TXRX_CSR2_BBP_ID1_VALID, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR2_BBP_ID2, 11);
+	rt2x00_set_field32(&reg, TXRX_CSR2_BBP_ID2_VALID, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR2_BBP_ID3, 10);
+	rt2x00_set_field32(&reg, TXRX_CSR2_BBP_ID3_VALID, 1);
+	rt73usb_register_write(rt2x00dev, TXRX_CSR2, reg);
+
+	/*
+	 * OFDM TXD BBP registers
+	 */
+	rt73usb_register_read(rt2x00dev, TXRX_CSR3, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR3_BBP_ID0, 7);
+	rt2x00_set_field32(&reg, TXRX_CSR3_BBP_ID0_VALID, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR3_BBP_ID1, 6);
+	rt2x00_set_field32(&reg, TXRX_CSR3_BBP_ID1_VALID, 1);
+	rt2x00_set_field32(&reg, TXRX_CSR3_BBP_ID2, 5);
+	rt2x00_set_field32(&reg, TXRX_CSR3_BBP_ID2_VALID, 1);
+	rt73usb_register_write(rt2x00dev, TXRX_CSR3, reg);
+
+	rt73usb_register_read(rt2x00dev, TXRX_CSR7, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR7_ACK_CTS_6MBS, 59);
+	rt2x00_set_field32(&reg, TXRX_CSR7_ACK_CTS_9MBS, 53);
+	rt2x00_set_field32(&reg, TXRX_CSR7_ACK_CTS_12MBS, 49);
+	rt2x00_set_field32(&reg, TXRX_CSR7_ACK_CTS_18MBS, 46);
+	rt73usb_register_write(rt2x00dev, TXRX_CSR7, reg);
+
+	rt73usb_register_read(rt2x00dev, TXRX_CSR8, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR8_ACK_CTS_24MBS, 44);
+	rt2x00_set_field32(&reg, TXRX_CSR8_ACK_CTS_36MBS, 42);
+	rt2x00_set_field32(&reg, TXRX_CSR8_ACK_CTS_48MBS, 42);
+	rt2x00_set_field32(&reg, TXRX_CSR8_ACK_CTS_54MBS, 42);
+	rt73usb_register_write(rt2x00dev, TXRX_CSR8, reg);
+
 	rt73usb_register_write(rt2x00dev, TXRX_CSR15, 0x0000000f);
 
 	rt73usb_register_read(rt2x00dev, MAC_CSR6, &reg);
@@ -1021,6 +1067,10 @@ static int rt73usb_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	rt73usb_register_write(rt2x00dev, MAC_CSR13, 0x00007f00);
 
+	/*
+	 * Invalidate all Shared Keys (SEC_CSR0),
+	 * and clear the Shared key Cipher algorithms (SEC_CSR1 & SEC_CSR5)
+	 */
 	rt73usb_register_write(rt2x00dev, SEC_CSR0, 0x00000000);
 	rt73usb_register_write(rt2x00dev, SEC_CSR1, 0x00000000);
 	rt73usb_register_write(rt2x00dev, SEC_CSR5, 0x00000000);
diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/rt2x00/rt73usb.h
index 660a134..82f4e76 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -298,16 +298,40 @@ struct hw_pairwise_ta_entry {
  * TXRX_CSR1
  */
 #define TXRX_CSR1			0x3044
+#define TXRX_CSR1_BBP_ID0		FIELD32(0x0000007f)
+#define TXRX_CSR1_BBP_ID0_VALID		FIELD32(0x00000080)
+#define TXRX_CSR1_BBP_ID1		FIELD32(0x00007f00)
+#define TXRX_CSR1_BBP_ID1_VALID		FIELD32(0x00008000)
+#define TXRX_CSR1_BBP_ID2		FIELD32(0x007f0000)
+#define TXRX_CSR1_BBP_ID2_VALID		FIELD32(0x00800000)
+#define TXRX_CSR1_BBP_ID3		FIELD32(0x7f000000)
+#define TXRX_CSR1_BBP_ID3_VALID		FIELD32(0x80000000)
 
 /*
  * TXRX_CSR2
  */
 #define TXRX_CSR2			0x3048
+#define TXRX_CSR2_BBP_ID0		FIELD32(0x0000007f)
+#define TXRX_CSR2_BBP_ID0_VALID		FIELD32(0x00000080)
+#define TXRX_CSR2_BBP_ID1		FIELD32(0x00007f00)
+#define TXRX_CSR2_BBP_ID1_VALID		FIELD32(0x00008000)
+#define TXRX_CSR2_BBP_ID2		FIELD32(0x007f0000)
+#define TXRX_CSR2_BBP_ID2_VALID		FIELD32(0x00800000)
+#define TXRX_CSR2_BBP_ID3		FIELD32(0x7f000000)
+#define TXRX_CSR2_BBP_ID3_VALID		FIELD32(0x80000000)
 
 /*
  * TXRX_CSR3
  */
 #define TXRX_CSR3			0x304c
+#define TXRX_CSR3_BBP_ID0		FIELD32(0x0000007f)
+#define TXRX_CSR3_BBP_ID0_VALID		FIELD32(0x00000080)
+#define TXRX_CSR3_BBP_ID1		FIELD32(0x00007f00)
+#define TXRX_CSR3_BBP_ID1_VALID		FIELD32(0x00008000)
+#define TXRX_CSR3_BBP_ID2		FIELD32(0x007f0000)
+#define TXRX_CSR3_BBP_ID2_VALID		FIELD32(0x00800000)
+#define TXRX_CSR3_BBP_ID3		FIELD32(0x7f000000)
+#define TXRX_CSR3_BBP_ID3_VALID		FIELD32(0x80000000)
 
 /*
  * TXRX_CSR4: Auto-Responder/Tx-retry register.
@@ -334,11 +358,27 @@ struct hw_pairwise_ta_entry {
 #define TXRX_CSR5			0x3054
 
 /*
- * ACK/CTS payload consumed time registers.
+ * TXRX_CSR6: ACK/CTS payload consumed time
  */
 #define TXRX_CSR6			0x3058
+
+/*
+ * TXRX_CSR7: OFDM ACK/CTS payload consumed time for 6/9/12/18 mbps.
+ */
 #define TXRX_CSR7			0x305c
+#define TXRX_CSR7_ACK_CTS_6MBS		FIELD32(0x000000ff)
+#define TXRX_CSR7_ACK_CTS_9MBS		FIELD32(0x0000ff00)
+#define TXRX_CSR7_ACK_CTS_12MBS		FIELD32(0x00ff0000)
+#define TXRX_CSR7_ACK_CTS_18MBS		FIELD32(0xff000000)
+
+/*
+ * TXRX_CSR8: OFDM ACK/CTS payload consumed time for 24/36/48/54 mbps.
+ */
 #define TXRX_CSR8			0x3060
+#define TXRX_CSR8_ACK_CTS_24MBS		FIELD32(0x000000ff)
+#define TXRX_CSR8_ACK_CTS_36MBS		FIELD32(0x0000ff00)
+#define TXRX_CSR8_ACK_CTS_48MBS		FIELD32(0x00ff0000)
+#define TXRX_CSR8_ACK_CTS_54MBS		FIELD32(0xff000000)
 
 /*
  * TXRX_CSR9: Synchronization control register.
@@ -442,11 +482,13 @@ struct hw_pairwise_ta_entry {
  * PHY_CSR5: RX to TX signal switch timing control.
  */
 #define PHY_CSR5			0x3094
+#define PHY_CSR5_IQ_FLIP		FIELD32(0x00000004)
 
 /*
  * PHY_CSR6: TX to RX signal timing control.
  */
 #define PHY_CSR6			0x3098
+#define PHY_CSR6_IQ_FLIP		FIELD32(0x00000004)
 
 /*
  * PHY_CSR7: TX DAC switching timing control.
@@ -461,6 +503,22 @@ struct hw_pairwise_ta_entry {
  * SEC_CSR0: Shared key table control.
  */
 #define SEC_CSR0			0x30a0
+#define SEC_CSR0_BSS0_KEY0_VALID	FIELD32(0x00000001)
+#define SEC_CSR0_BSS0_KEY1_VALID	FIELD32(0x00000002)
+#define SEC_CSR0_BSS0_KEY2_VALID	FIELD32(0x00000004)
+#define SEC_CSR0_BSS0_KEY3_VALID	FIELD32(0x00000008)
+#define SEC_CSR0_BSS1_KEY0_VALID	FIELD32(0x00000010)
+#define SEC_CSR0_BSS1_KEY1_VALID	FIELD32(0x00000020)
+#define SEC_CSR0_BSS1_KEY2_VALID	FIELD32(0x00000040)
+#define SEC_CSR0_BSS1_KEY3_VALID	FIELD32(0x00000080)
+#define SEC_CSR0_BSS2_KEY0_VALID	FIELD32(0x00000100)
+#define SEC_CSR0_BSS2_KEY1_VALID	FIELD32(0x00000200)
+#define SEC_CSR0_BSS2_KEY2_VALID	FIELD32(0x00000400)
+#define SEC_CSR0_BSS2_KEY3_VALID	FIELD32(0x00000800)
+#define SEC_CSR0_BSS3_KEY0_VALID	FIELD32(0x00001000)
+#define SEC_CSR0_BSS3_KEY1_VALID	FIELD32(0x00002000)
+#define SEC_CSR0_BSS3_KEY2_VALID	FIELD32(0x00004000)
+#define SEC_CSR0_BSS3_KEY3_VALID	FIELD32(0x00008000)
 
 /*
  * SEC_CSR1: Shared key table security mode register.
-- 
1.5.3
