Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:22582 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbXHSSbH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:31:07 -0400
Received: by ug-out-1314.google.com with SMTP id j3so446922ugf
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:31:06 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 17/30] rt2x00: Fix register initialization ordering
Date: Sun, 19 Aug 2007 20:27:38 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192027.38268.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 34548ad3e92237fb9ce91be9d09a5877f782c321 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 18 Aug 2007 13:08:29 +0200
Subject: [PATCH 17/30] rt2x00: Fix register initialization ordering

Change the order in which the registers are being initialized
to reflect the same order in which the legacy drivers
initialize the registers. This should prevent problems
caused by incorrect register initialization. Especially
the SLEEP/AWAKE state registers are very sensitive to this.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2400pci.c |   44 +++++++++----------
 drivers/net/wireless/rt2500pci.c |   89 ++++++++++++++++++--------------------
 drivers/net/wireless/rt2500usb.c |   17 ++++---
 drivers/net/wireless/rt61pci.c   |   42 ++++++++---------
 drivers/net/wireless/rt73usb.c   |   18 ++++----
 5 files changed, 101 insertions(+), 109 deletions(-)

diff --git a/drivers/net/wireless/rt2400pci.c b/drivers/net/wireless/rt2400pci.c
index 7bd975d..b673d61 100644
--- a/drivers/net/wireless/rt2400pci.c
+++ b/drivers/net/wireless/rt2400pci.c
@@ -796,11 +796,6 @@ static int rt2400pci_init_registers(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
 
-	if (rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_AWAKE))
-		return -EBUSY;
-
-	rt2x00pci_register_write(rt2x00dev, PWRCSR0, 0x3f3b3100);
-
 	rt2x00pci_register_write(rt2x00dev, PSCSR0, 0x00020002);
 	rt2x00pci_register_write(rt2x00dev, PSCSR1, 0x00000002);
 	rt2x00pci_register_write(rt2x00dev, PSCSR2, 0x00023f20);
@@ -819,31 +814,34 @@ static int rt2400pci_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	rt2x00pci_register_write(rt2x00dev, CNT3, 0x3f080000);
 
-	rt2x00pci_register_write(rt2x00dev, MACCSR0, 0x00217223);
-	rt2x00pci_register_write(rt2x00dev, MACCSR1, 0x00235518);
-
-	rt2x00pci_register_read(rt2x00dev, MACCSR2, &reg);
-	rt2x00_set_field32(&reg, MACCSR2_DELAY, 64);
-	rt2x00pci_register_write(rt2x00dev, MACCSR2, reg);
+	rt2x00pci_register_read(rt2x00dev, ARCSR0, &reg);
+	rt2x00_set_field32(&reg, ARCSR0_AR_BBP_DATA0, 133);
+	rt2x00_set_field32(&reg, ARCSR0_AR_BBP_ID0, 134);
+	rt2x00_set_field32(&reg, ARCSR0_AR_BBP_DATA1, 136);
+	rt2x00_set_field32(&reg, ARCSR0_AR_BBP_ID1, 135);
+	rt2x00pci_register_write(rt2x00dev, ARCSR0, reg);
 
 	rt2x00pci_register_read(rt2x00dev, RXCSR3, &reg);
-	/*
-	 * Tx power.
-	 */
-	rt2x00_set_field32(&reg, RXCSR3_BBP_ID0, 3);
+	rt2x00_set_field32(&reg, RXCSR3_BBP_ID0, 3); /* Tx power.*/
 	rt2x00_set_field32(&reg, RXCSR3_BBP_ID0_VALID, 1);
-	/*
-	 * Signal.
-	 */
-	rt2x00_set_field32(&reg, RXCSR3_BBP_ID1, 32);
+	rt2x00_set_field32(&reg, RXCSR3_BBP_ID1, 32); /* Signal */
 	rt2x00_set_field32(&reg, RXCSR3_BBP_ID1_VALID, 1);
-	/*
-	 * Rssi.
-	 */
-	rt2x00_set_field32(&reg, RXCSR3_BBP_ID2, 36);
+	rt2x00_set_field32(&reg, RXCSR3_BBP_ID2, 36); /* Rssi */
 	rt2x00_set_field32(&reg, RXCSR3_BBP_ID2_VALID, 1);
 	rt2x00pci_register_write(rt2x00dev, RXCSR3, reg);
 
+	rt2x00pci_register_write(rt2x00dev, PWRCSR0, 0x3f3b3100);
+
+	if (rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_AWAKE))
+		return -EBUSY;
+
+	rt2x00pci_register_write(rt2x00dev, MACCSR0, 0x00217223);
+	rt2x00pci_register_write(rt2x00dev, MACCSR1, 0x00235518);
+
+	rt2x00pci_register_read(rt2x00dev, MACCSR2, &reg);
+	rt2x00_set_field32(&reg, MACCSR2_DELAY, 64);
+	rt2x00pci_register_write(rt2x00dev, MACCSR2, reg);
+
 	rt2x00pci_register_read(rt2x00dev, RALINKCSR, &reg);
 	rt2x00_set_field32(&reg, RALINKCSR_AR_BBP_DATA0, 17);
 	rt2x00_set_field32(&reg, RALINKCSR_AR_BBP_ID0, 154);
diff --git a/drivers/net/wireless/rt2500pci.c b/drivers/net/wireless/rt2500pci.c
index d6b88f6..bfd6426 100644
--- a/drivers/net/wireless/rt2500pci.c
+++ b/drivers/net/wireless/rt2500pci.c
@@ -894,21 +894,6 @@ static int rt2500pci_init_registers(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
 
-	if (rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_AWAKE))
-		return -EBUSY;
-
-	rt2x00pci_register_write(rt2x00dev, PWRCSR0, 0x3f3b3100);
-
-	rt2x00pci_register_read(rt2x00dev, PCICSR, &reg);
-	rt2x00_set_field32(&reg, PCICSR_BIG_ENDIAN, 0);
-	rt2x00_set_field32(&reg, PCICSR_RX_TRESHOLD, 0);
-	rt2x00_set_field32(&reg, PCICSR_TX_TRESHOLD, 3);
-	rt2x00_set_field32(&reg, PCICSR_BURST_LENTH, 1);
-	rt2x00_set_field32(&reg, PCICSR_ENABLE_CLK, 1);
-	rt2x00_set_field32(&reg, PCICSR_READ_MULTIPLE, 1);
-	rt2x00_set_field32(&reg, PCICSR_WRITE_INVALID, 1);
-	rt2x00pci_register_write(rt2x00dev, PCICSR, reg);
-
 	rt2x00pci_register_write(rt2x00dev, PSCSR0, 0x00020002);
 	rt2x00pci_register_write(rt2x00dev, PSCSR1, 0x00000002);
 	rt2x00pci_register_write(rt2x00dev, PSCSR2, 0x00020002);
@@ -925,18 +910,6 @@ static int rt2500pci_init_registers(struct rt2x00_dev *rt2x00dev)
 			   rt2x00dev->rx->data_size / 128);
 	rt2x00pci_register_write(rt2x00dev, CSR9, reg);
 
-	rt2x00pci_register_write(rt2x00dev, CNT3, 0);
-
-	rt2x00pci_register_write(rt2x00dev, GPIOCSR, 0x0000ff00);
-	rt2x00pci_register_write(rt2x00dev, TESTCSR, 0x000000f0);
-
-	rt2x00pci_register_write(rt2x00dev, MACCSR0, 0x00213223);
-	rt2x00pci_register_write(rt2x00dev, MACCSR1, 0x00235518);
-
-	rt2x00pci_register_read(rt2x00dev, MACCSR2, &reg);
-	rt2x00_set_field32(&reg, MACCSR2_DELAY, 64);
-	rt2x00pci_register_write(rt2x00dev, MACCSR2, reg);
-
 	/*
 	 * Always use CWmin and CWmax set in descriptor.
 	 */
@@ -944,29 +917,55 @@ static int rt2500pci_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, CSR11_CW_SELECT, 0);
 	rt2x00pci_register_write(rt2x00dev, CSR11, reg);
 
+	rt2x00pci_register_write(rt2x00dev, CNT3, 0);
+
+	rt2x00pci_register_read(rt2x00dev, TXCSR8, &reg);
+	rt2x00_set_field32(&reg, TXCSR8_CCK_SIGNAL, 0x8a);
+	rt2x00_set_field32(&reg, TXCSR8_CCK_SERVICE, 0x8b);
+	rt2x00_set_field32(&reg, TXCSR8_CCK_LENGTH_LOW, 0x8d);
+	rt2x00_set_field32(&reg, TXCSR8_CCK_LENGTH_HIGH, 0x8c);
+	rt2x00pci_register_write(rt2x00dev, TXCSR8, reg);
+
+	rt2x00pci_register_write(rt2x00dev, ARTCSR0, 0x7038140a);
+	rt2x00pci_register_write(rt2x00dev, ARTCSR1, 0x1d21252d);
+	rt2x00pci_register_write(rt2x00dev, ARTCSR2, 0x1919191d);
+
 	rt2x00pci_register_read(rt2x00dev, RXCSR3, &reg);
-	/*
-	 * Signal.
-	 */
-	rt2x00_set_field32(&reg, RXCSR3_BBP_ID0, 47);
+	rt2x00_set_field32(&reg, RXCSR3_BBP_ID0, 47); /* Signal */
 	rt2x00_set_field32(&reg, RXCSR3_BBP_ID0_VALID, 1);
-	/*
-	 * Rssi.
-	 */
-	rt2x00_set_field32(&reg, RXCSR3_BBP_ID1, 51);
+	rt2x00_set_field32(&reg, RXCSR3_BBP_ID1, 51); /* Rssi */
 	rt2x00_set_field32(&reg, RXCSR3_BBP_ID1_VALID, 1);
-	/*
-	 * OFDM Rate.
-	 */
-	rt2x00_set_field32(&reg, RXCSR3_BBP_ID2, 42);
+	rt2x00_set_field32(&reg, RXCSR3_BBP_ID2, 42); /* OFDM Rate */
 	rt2x00_set_field32(&reg, RXCSR3_BBP_ID2_VALID, 1);
-	/*
-	 * OFDM.
-	 */
-	rt2x00_set_field32(&reg, RXCSR3_BBP_ID3, 51);
+	rt2x00_set_field32(&reg, RXCSR3_BBP_ID3, 51); /* OFDM */
 	rt2x00_set_field32(&reg, RXCSR3_BBP_ID3_VALID, 1);
 	rt2x00pci_register_write(rt2x00dev, RXCSR3, reg);
 
+	rt2x00pci_register_read(rt2x00dev, PCICSR, &reg);
+	rt2x00_set_field32(&reg, PCICSR_BIG_ENDIAN, 0);
+	rt2x00_set_field32(&reg, PCICSR_RX_TRESHOLD, 0);
+	rt2x00_set_field32(&reg, PCICSR_TX_TRESHOLD, 3);
+	rt2x00_set_field32(&reg, PCICSR_BURST_LENTH, 1);
+	rt2x00_set_field32(&reg, PCICSR_ENABLE_CLK, 1);
+	rt2x00_set_field32(&reg, PCICSR_READ_MULTIPLE, 1);
+	rt2x00_set_field32(&reg, PCICSR_WRITE_INVALID, 1);
+	rt2x00pci_register_write(rt2x00dev, PCICSR, reg);
+
+	rt2x00pci_register_write(rt2x00dev, PWRCSR0, 0x3f3b3100);
+
+	rt2x00pci_register_write(rt2x00dev, GPIOCSR, 0x0000ff00);
+	rt2x00pci_register_write(rt2x00dev, TESTCSR, 0x000000f0);
+
+	if (rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_AWAKE))
+		return -EBUSY;
+
+	rt2x00pci_register_write(rt2x00dev, MACCSR0, 0x00213223);
+	rt2x00pci_register_write(rt2x00dev, MACCSR1, 0x00235518);
+
+	rt2x00pci_register_read(rt2x00dev, MACCSR2, &reg);
+	rt2x00_set_field32(&reg, MACCSR2_DELAY, 64);
+	rt2x00pci_register_write(rt2x00dev, MACCSR2, reg);
+
 	rt2x00pci_register_read(rt2x00dev, RALINKCSR, &reg);
 	rt2x00_set_field32(&reg, RALINKCSR_AR_BBP_DATA0, 17);
 	rt2x00_set_field32(&reg, RALINKCSR_AR_BBP_ID0, 26);
@@ -980,10 +979,6 @@ static int rt2500pci_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	rt2x00pci_register_write(rt2x00dev, TXACKCSR0, 0x00000020);
 
-	rt2x00pci_register_write(rt2x00dev, ARTCSR0, 0x7038140a);
-	rt2x00pci_register_write(rt2x00dev, ARTCSR1, 0x1d21252d);
-	rt2x00pci_register_write(rt2x00dev, ARTCSR2, 0x1919191d);
-
 	rt2x00pci_register_read(rt2x00dev, CSR1, &reg);
 	rt2x00_set_field32(&reg, CSR1_SOFT_RESET, 1);
 	rt2x00_set_field32(&reg, CSR1_BBP_RESET, 0);
diff --git a/drivers/net/wireless/rt2500usb.c b/drivers/net/wireless/rt2500usb.c
index 5e3cdf5..f29dbe9 100644
--- a/drivers/net/wireless/rt2500usb.c
+++ b/drivers/net/wireless/rt2500usb.c
@@ -788,6 +788,7 @@ static int rt2500usb_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	rt2500usb_register_write(rt2x00dev, MAC_CSR1, 0x0003);
 	rt2500usb_register_write(rt2x00dev, MAC_CSR1, 0x0000);
+
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR5, 0x8c8d);
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR6, 0x8b8a);
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR7, 0x8687);
@@ -813,27 +814,27 @@ static int rt2500usb_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2500usb_register_write(rt2x00dev, MAC_CSR15, 0x01ee);
 	rt2500usb_register_write(rt2x00dev, MAC_CSR16, 0x0000);
 
-	rt2500usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
-	rt2x00_set_field16(&reg, TXRX_CSR0_IV_OFFSET, IEEE80211_HEADER);
-	rt2x00_set_field16(&reg, TXRX_CSR0_KEY_ID, 0xff);
-	rt2500usb_register_write(rt2x00dev, TXRX_CSR0, reg);
-
 	rt2500usb_register_read(rt2x00dev, MAC_CSR8, &reg);
 	rt2x00_set_field16(&reg, MAC_CSR8_MAX_FRAME_UNIT,
 			   rt2x00dev->rx->data_size);
 	rt2500usb_register_write(rt2x00dev, MAC_CSR8, reg);
 
+	rt2500usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
+	rt2x00_set_field16(&reg, TXRX_CSR0_IV_OFFSET, IEEE80211_HEADER);
+	rt2x00_set_field16(&reg, TXRX_CSR0_KEY_ID, 0xff);
+	rt2500usb_register_write(rt2x00dev, TXRX_CSR0, reg);
+
 	rt2500usb_register_read(rt2x00dev, MAC_CSR18, &reg);
 	rt2x00_set_field16(&reg, MAC_CSR18_DELAY_AFTER_BEACON, 0x5a);
 	rt2500usb_register_write(rt2x00dev, MAC_CSR18, reg);
 
+	rt2500usb_register_read(rt2x00dev, PHY_CSR4, &reg);
+	rt2500usb_register_write(rt2x00dev, PHY_CSR4, reg | 0x0001);
+
 	rt2500usb_register_read(rt2x00dev, TXRX_CSR1, &reg);
 	rt2x00_set_field16(&reg, TXRX_CSR1_AUTO_SEQUENCE, 1);
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR1, reg);
 
-	rt2500usb_register_read(rt2x00dev, PHY_CSR4, &reg);
-	rt2500usb_register_write(rt2x00dev, PHY_CSR4, reg | 0x0001);
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/rt61pci.c b/drivers/net/wireless/rt61pci.c
index 1a4957b..47a915d 100644
--- a/drivers/net/wireless/rt61pci.c
+++ b/drivers/net/wireless/rt61pci.c
@@ -1147,11 +1147,6 @@ static int rt61pci_init_registers(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
 
-	if (rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_AWAKE))
-		return -EBUSY;
-
-	rt2x00pci_register_write(rt2x00dev, MAC_CSR10, 0x00000718);
-
 	rt2x00pci_register_read(rt2x00dev, TXRX_CSR0, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR0_AUTO_TX_SEQ, 1);
 	rt2x00_set_field32(&reg, TXRX_CSR0_DISABLE_RX, 0);
@@ -1161,34 +1156,27 @@ static int rt61pci_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR1, 0x9eb39eb3);
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR2, 0x8a8b8c8d);
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR3, 0x00858687);
-
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR7, 0x2e31353b);
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR8, 0x2a2a2a2c);
-
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR15, 0x0000000f);
 
 	rt2x00pci_register_write(rt2x00dev, MAC_CSR6, 0x00000fff);
 
+	rt2x00pci_register_read(rt2x00dev, MAC_CSR9, &reg);
+	rt2x00_set_field32(&reg, MAC_CSR9_CW_SELECT, 0);
+	rt2x00pci_register_write(rt2x00dev, MAC_CSR9, reg);
+
+	rt2x00pci_register_write(rt2x00dev, MAC_CSR10, 0x0000071c);
+
+	if (rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_AWAKE))
+		return -EBUSY;
+
 	rt2x00pci_register_write(rt2x00dev, MAC_CSR13, 0x0000e000);
 
 	rt2x00pci_register_write(rt2x00dev, SEC_CSR0, 0x00000000);
 	rt2x00pci_register_write(rt2x00dev, SEC_CSR1, 0x00000000);
 	rt2x00pci_register_write(rt2x00dev, SEC_CSR5, 0x00000000);
 
-	rt2x00pci_register_read(rt2x00dev, AC_TXOP_CSR0, &reg);
-	rt2x00_set_field32(&reg, AC_TXOP_CSR0_AC0_TX_OP, 0);
-	rt2x00_set_field32(&reg, AC_TXOP_CSR0_AC1_TX_OP, 0);
-	rt2x00pci_register_write(rt2x00dev, AC_TXOP_CSR0, reg);
-
-	rt2x00pci_register_read(rt2x00dev, AC_TXOP_CSR1, &reg);
-	rt2x00_set_field32(&reg, AC_TXOP_CSR1_AC2_TX_OP, 192);
-	rt2x00_set_field32(&reg, AC_TXOP_CSR1_AC3_TX_OP, 48);
-	rt2x00pci_register_write(rt2x00dev, AC_TXOP_CSR1, reg);
-
-	rt2x00pci_register_read(rt2x00dev, MAC_CSR9, &reg);
-	rt2x00_set_field32(&reg, MAC_CSR9_CW_SELECT, 0);
-	rt2x00pci_register_write(rt2x00dev, MAC_CSR9, reg);
-
 	rt2x00pci_register_write(rt2x00dev, PHY_CSR1, 0x000023b0);
 	rt2x00pci_register_write(rt2x00dev, PHY_CSR5, 0x060a100c);
 	rt2x00pci_register_write(rt2x00dev, PHY_CSR6, 0x00080606);
@@ -1200,6 +1188,16 @@ static int rt61pci_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	rt2x00pci_register_write(rt2x00dev, M2H_CMD_DONE_CSR, 0xffffffff);
 
+	rt2x00pci_register_read(rt2x00dev, AC_TXOP_CSR0, &reg);
+	rt2x00_set_field32(&reg, AC_TXOP_CSR0_AC0_TX_OP, 0);
+	rt2x00_set_field32(&reg, AC_TXOP_CSR0_AC1_TX_OP, 0);
+	rt2x00pci_register_write(rt2x00dev, AC_TXOP_CSR0, reg);
+
+	rt2x00pci_register_read(rt2x00dev, AC_TXOP_CSR1, &reg);
+	rt2x00_set_field32(&reg, AC_TXOP_CSR1_AC2_TX_OP, 192);
+	rt2x00_set_field32(&reg, AC_TXOP_CSR1_AC3_TX_OP, 48);
+	rt2x00pci_register_write(rt2x00dev, AC_TXOP_CSR1, reg);
+
 	/*
 	 * We must clear the error counters.
 	 * These registers are cleared on read,
@@ -1212,7 +1210,7 @@ static int rt61pci_init_registers(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Reset MAC and BBP registers.
 	 */
-	reg = 0;
+	rt2x00pci_register_read(rt2x00dev, MAC_CSR1, &reg);
 	rt2x00_set_field32(&reg, MAC_CSR1_SOFT_RESET, 1);
 	rt2x00_set_field32(&reg, MAC_CSR1_BBP_RESET, 1);
 	rt2x00pci_register_write(rt2x00dev, MAC_CSR1, reg);
diff --git a/drivers/net/wireless/rt73usb.c b/drivers/net/wireless/rt73usb.c
index 85dfc58..7b1d8e1 100644
--- a/drivers/net/wireless/rt73usb.c
+++ b/drivers/net/wireless/rt73usb.c
@@ -952,11 +952,6 @@ static int rt73usb_init_registers(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
 
-	if (rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_AWAKE))
-		return -EBUSY;
-
-	rt73usb_register_write(rt2x00dev, MAC_CSR10, 0x00000718);
-
 	rt73usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR0_AUTO_TX_SEQ, 1);
 	rt2x00_set_field32(&reg, TXRX_CSR0_DISABLE_RX, 0);
@@ -966,13 +961,18 @@ static int rt73usb_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt73usb_register_write(rt2x00dev, TXRX_CSR1, 0x9eaa9eaf);
 	rt73usb_register_write(rt2x00dev, TXRX_CSR2, 0x8a8b8c8d);
 	rt73usb_register_write(rt2x00dev, TXRX_CSR3, 0x00858687);
-
 	rt73usb_register_write(rt2x00dev, TXRX_CSR7, 0x2e31353b);
 	rt73usb_register_write(rt2x00dev, TXRX_CSR8, 0x2a2a2a2c);
-
 	rt73usb_register_write(rt2x00dev, TXRX_CSR15, 0x0000000f);
 
-	rt73usb_register_write(rt2x00dev, MAC_CSR6, 0x00000fff);
+	rt73usb_register_read(rt2x00dev, MAC_CSR6, &reg);
+	rt2x00_set_field32(&reg, MAC_CSR6_MAX_FRAME_UNIT, 0xfff);
+	rt73usb_register_write(rt2x00dev, MAC_CSR6, reg);
+
+	rt73usb_register_write(rt2x00dev, MAC_CSR10, 0x00000718);
+
+	if (rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_AWAKE))
+		return -EBUSY;
 
 	rt73usb_register_write(rt2x00dev, MAC_CSR13, 0x00007f00);
 
@@ -1016,7 +1016,7 @@ static int rt73usb_init_registers(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Reset MAC and BBP registers.
 	 */
-	reg = 0;
+	rt73usb_register_read(rt2x00dev, MAC_CSR1, &reg);
 	rt2x00_set_field32(&reg, MAC_CSR1_SOFT_RESET, 1);
 	rt2x00_set_field32(&reg, MAC_CSR1_BBP_RESET, 1);
 	rt73usb_register_write(rt2x00dev, MAC_CSR1, reg);
-- 
1.5.3.rc5

