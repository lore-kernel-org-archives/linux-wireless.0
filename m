Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:2415 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754648Ab2HaRWU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2012 13:22:20 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: <users@rt2x00.serialmonkey.com>, Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH v2 3/6] rt2x00: Fix rfkill polling prior to interface start.
Date: Fri, 31 Aug 2012 19:22:11 +0200
Message-Id: <1346433734-3337-4-git-send-email-gwingerde@gmail.com> (sfid-20120831_192229_255282_30A47B7F)
In-Reply-To: <1346433734-3337-3-git-send-email-gwingerde@gmail.com>
References: <1346433734-3337-1-git-send-email-gwingerde@gmail.com>
 <1346433734-3337-2-git-send-email-gwingerde@gmail.com>
 <1346433734-3337-3-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need to program the rfkill switch GPIO pin direction to input at
device initialization time, not only when the interface is brought up.
Doing this only when the interface is brought up could lead to rfkill
detecting the switch is turned on erroneously and inability to create
the interface and bringing it up.

Reported-and-tested-by: Andreas Messer <andi@bastelmap.de>
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: <stable@vger.kernel.org>

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 8b9dbd7..64328af 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1611,6 +1611,7 @@ static int rt2400pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 static int rt2400pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
+	u32 reg;
 
 	/*
 	 * Allocate eeprom data.
@@ -1624,6 +1625,14 @@ static int rt2400pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 		return retval;
 
 	/*
+	 * Enable rfkill polling by setting GPIO direction of the
+	 * rfkill switch GPIO pin correctly.
+	 */
+	rt2x00pci_register_read(rt2x00dev, GPIOCSR, &reg);
+	rt2x00_set_field32(&reg, GPIOCSR_BIT8, 1);
+	rt2x00pci_register_write(rt2x00dev, GPIOCSR, reg);
+
+	/*
 	 * Initialize hw specifications.
 	 */
 	retval = rt2400pci_probe_hw_mode(rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h b/drivers/net/wireless/rt2x00/rt2400pci.h
index d3a4a68..7564ae9 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/rt2x00/rt2400pci.h
@@ -670,6 +670,7 @@
 #define GPIOCSR_BIT5			FIELD32(0x00000020)
 #define GPIOCSR_BIT6			FIELD32(0x00000040)
 #define GPIOCSR_BIT7			FIELD32(0x00000080)
+#define GPIOCSR_BIT8			FIELD32(0x00000100)
 
 /*
  * BBPPCSR: BBP Pin control register.
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index d2cf8a4..3de0406 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1929,6 +1929,7 @@ static int rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 static int rt2500pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
+	u32 reg;
 
 	/*
 	 * Allocate eeprom data.
@@ -1942,6 +1943,14 @@ static int rt2500pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 		return retval;
 
 	/*
+	 * Enable rfkill polling by setting GPIO direction of the
+	 * rfkill switch GPIO pin correctly.
+	 */
+	rt2x00pci_register_read(rt2x00dev, GPIOCSR, &reg);
+	rt2x00_set_field32(&reg, GPIOCSR_DIR0, 1);
+	rt2x00pci_register_write(rt2x00dev, GPIOCSR, reg);
+
+	/*
 	 * Initialize hw specifications.
 	 */
 	retval = rt2500pci_probe_hw_mode(rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index b3a1d73..89fee31 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1768,6 +1768,7 @@ static int rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
+	u16 reg;
 
 	/*
 	 * Allocate eeprom data.
@@ -1781,6 +1782,14 @@ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 		return retval;
 
 	/*
+	 * Enable rfkill polling by setting GPIO direction of the
+	 * rfkill switch GPIO pin correctly.
+	 */
+	rt2500usb_register_read(rt2x00dev, MAC_CSR19, &reg);
+	rt2x00_set_field16(&reg, MAC_CSR19_BIT8, 0);
+	rt2500usb_register_write(rt2x00dev, MAC_CSR19, reg);
+
+	/*
 	 * Initialize hw specifications.
 	 */
 	retval = rt2500usb_probe_hw_mode(rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless/rt2x00/rt2500usb.h
index 192531d..196bd51 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/rt2x00/rt2500usb.h
@@ -197,6 +197,7 @@
 #define MAC_CSR19_BIT5			FIELD16(0x0020)
 #define MAC_CSR19_BIT6			FIELD16(0x0040)
 #define MAC_CSR19_BIT7			FIELD16(0x0080)
+#define MAC_CSR19_BIT8			FIELD16(0x0100)
 
 /*
  * MAC_CSR20: LED control register.
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 98aa426..4765bbd 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -983,6 +983,7 @@ static int rt2800pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
+	u32 reg;
 
 	/*
 	 * Allocate eeprom data.
@@ -996,6 +997,14 @@ static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 		return retval;
 
 	/*
+	 * Enable rfkill polling by setting GPIO direction of the
+	 * rfkill switch GPIO pin correctly.
+	 */
+	rt2x00pci_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
+	rt2x00_set_field32(&reg, GPIO_CTRL_CFG_GPIOD_BIT2, 1);
+	rt2x00pci_register_write(rt2x00dev, GPIO_CTRL_CFG, reg);
+
+	/*
 	 * Initialize hw specifications.
 	 */
 	retval = rt2800_probe_hw_mode(rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 6681bfc..52a32b5 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -736,6 +736,7 @@ static int rt2800usb_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
+	u32 reg;
 
 	/*
 	 * Allocate eeprom data.
@@ -749,6 +750,14 @@ static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 		return retval;
 
 	/*
+	 * Enable rfkill polling by setting GPIO direction of the
+	 * rfkill switch GPIO pin correctly.
+	 */
+	rt2x00usb_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
+	rt2x00_set_field32(&reg, GPIO_CTRL_CFG_GPIOD_BIT2, 1);
+	rt2x00usb_register_write(rt2x00dev, GPIO_CTRL_CFG, reg);
+
+	/*
 	 * Initialize hw specifications.
 	 */
 	retval = rt2800_probe_hw_mode(rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 3f7bc5c..b8ec961 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2832,6 +2832,7 @@ static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 static int rt61pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
+	u32 reg;
 
 	/*
 	 * Disable power saving.
@@ -2850,6 +2851,14 @@ static int rt61pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 		return retval;
 
 	/*
+	 * Enable rfkill polling by setting GPIO direction of the
+	 * rfkill switch GPIO pin correctly.
+	 */
+	rt2x00pci_register_read(rt2x00dev, MAC_CSR13, &reg);
+	rt2x00_set_field32(&reg, MAC_CSR13_BIT13, 1);
+	rt2x00pci_register_write(rt2x00dev, MAC_CSR13, reg);
+
+	/*
 	 * Initialize hw specifications.
 	 */
 	retval = rt61pci_probe_hw_mode(rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
index e3cd6db..8f3da5a 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -372,6 +372,7 @@ struct hw_pairwise_ta_entry {
 #define MAC_CSR13_BIT10			FIELD32(0x00000400)
 #define MAC_CSR13_BIT11			FIELD32(0x00000800)
 #define MAC_CSR13_BIT12			FIELD32(0x00001000)
+#define MAC_CSR13_BIT13			FIELD32(0x00002000)
 
 /*
  * MAC_CSR14: LED control register.
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index ba6e434..248436c 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2177,6 +2177,7 @@ static int rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
+	u32 reg;
 
 	/*
 	 * Allocate eeprom data.
@@ -2190,6 +2191,14 @@ static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 		return retval;
 
 	/*
+	 * Enable rfkill polling by setting GPIO direction of the
+	 * rfkill switch GPIO pin correctly.
+	 */
+	rt2x00usb_register_read(rt2x00dev, MAC_CSR13, &reg);
+	rt2x00_set_field32(&reg, MAC_CSR13_BIT15, 0);
+	rt2x00usb_register_write(rt2x00dev, MAC_CSR13, reg);
+
+	/*
 	 * Initialize hw specifications.
 	 */
 	retval = rt73usb_probe_hw_mode(rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/rt2x00/rt73usb.h
index 9f6b470..df1cc11 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -282,6 +282,9 @@ struct hw_pairwise_ta_entry {
 #define MAC_CSR13_BIT10			FIELD32(0x00000400)
 #define MAC_CSR13_BIT11			FIELD32(0x00000800)
 #define MAC_CSR13_BIT12			FIELD32(0x00001000)
+#define MAC_CSR13_BIT13			FIELD32(0x00002000)
+#define MAC_CSR13_BIT14			FIELD32(0x00004000)
+#define MAC_CSR13_BIT15			FIELD32(0x00008000)
 
 /*
  * MAC_CSR14: LED control register.
-- 
1.7.11.1

