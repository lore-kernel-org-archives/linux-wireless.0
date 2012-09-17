Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53472 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab2IQDn2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2012 23:43:28 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20566.39974.594967.73473@gargle.gargle.HOWL> (sfid-20120917_054332_188467_F51522FF)
Date: Mon, 17 Sep 2012 09:12:30 +0530
To: <rodrigue@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <backports@vger.kernel.org>
Subject: [PATCH 1/3] compat-drivers: Add pending stable patches
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 .../0001-rt2x00-Identify-ASUS-USB-N53-device.patch |  40 +++
 ...word-size-of-rt2500usb-MAC_CSR19-register.patch |  59 +++++
 ...x-rfkill-polling-prior-to-interface-start.patch | 272 +++++++++++++++++++++
 ...usb-Added-rx-packet-length-validity-check.patch |  61 +++++
 ...8192ce-Log-message-that-B_CUT-device-may-.patch |  82 +++++++
 ...006-brcmfmac-fix-big-endian-bug-in-i-scan.patch |  35 +++
 ...ac-Fix-big-endian-host-configuration-data.patch |  93 +++++++
 7 files changed, 642 insertions(+)
 create mode 100644 pending-stable/0001-rt2x00-Identify-ASUS-USB-N53-device.patch
 create mode 100644 pending-stable/0002-rt2x00-Fix-word-size-of-rt2500usb-MAC_CSR19-register.patch
 create mode 100644 pending-stable/0003-rt2x00-Fix-rfkill-polling-prior-to-interface-start.patch
 create mode 100644 pending-stable/0004-rt2800usb-Added-rx-packet-length-validity-check.patch
 create mode 100644 pending-stable/0005-rtlwifi-rtl8192ce-Log-message-that-B_CUT-device-may-.patch
 create mode 100644 pending-stable/0006-brcmfmac-fix-big-endian-bug-in-i-scan.patch
 create mode 100644 pending-stable/0007-brcmfmac-Fix-big-endian-host-configuration-data.patch

diff --git a/pending-stable/0001-rt2x00-Identify-ASUS-USB-N53-device.patch b/pending-stable/0001-rt2x00-Identify-ASUS-USB-N53-device.patch
new file mode 100644
index 0000000..d2c1640
--- /dev/null
+++ b/pending-stable/0001-rt2x00-Identify-ASUS-USB-N53-device.patch
@@ -0,0 +1,40 @@
+From 177ef8360fabdc49ff08d2598c06e7f7a36b53e3 Mon Sep 17 00:00:00 2001
+From: Gertjan van Wingerde <gwingerde@gmail.com>
+Date: Fri, 31 Aug 2012 19:22:09 +0200
+Subject: [PATCH 1/7] rt2x00: Identify ASUS USB-N53 device.
+
+This is an RT3572 based device.
+
+Signed-off-by: Maximilian Engelhardt <maxi@daemonizer.de>
+Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
+Cc: <stable@vger.kernel.org>
+Acked-by: Ivo Van Doorn <ivdoorn@gmail.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/rt2x00/rt2800usb.c | 3 ++-
+ 1 file changed, 2 insertions(+), 1 deletion(-)
+
+diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
+index 6cf3365..6681bfc 100644
+--- a/drivers/net/wireless/rt2x00/rt2800usb.c
++++ b/drivers/net/wireless/rt2x00/rt2800usb.c
+@@ -1157,6 +1157,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
+ 	{ USB_DEVICE(0x1690, 0x0744) },
+ 	{ USB_DEVICE(0x1690, 0x0761) },
+ 	{ USB_DEVICE(0x1690, 0x0764) },
++	/* ASUS */
++	{ USB_DEVICE(0x0b05, 0x179d) },
+ 	/* Cisco */
+ 	{ USB_DEVICE(0x167b, 0x4001) },
+ 	/* EnGenius */
+@@ -1222,7 +1224,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
+ 	{ USB_DEVICE(0x0b05, 0x1760) },
+ 	{ USB_DEVICE(0x0b05, 0x1761) },
+ 	{ USB_DEVICE(0x0b05, 0x1790) },
+-	{ USB_DEVICE(0x0b05, 0x179d) },
+ 	/* AzureWave */
+ 	{ USB_DEVICE(0x13d3, 0x3262) },
+ 	{ USB_DEVICE(0x13d3, 0x3284) },
+-- 
+1.7.12
+
diff --git a/pending-stable/0002-rt2x00-Fix-word-size-of-rt2500usb-MAC_CSR19-register.patch b/pending-stable/0002-rt2x00-Fix-word-size-of-rt2500usb-MAC_CSR19-register.patch
new file mode 100644
index 0000000..7e3254e
--- /dev/null
+++ b/pending-stable/0002-rt2x00-Fix-word-size-of-rt2500usb-MAC_CSR19-register.patch
@@ -0,0 +1,59 @@
+From 6ced58a5dbb94dbfbea1b33ca3c56d1e929cd548 Mon Sep 17 00:00:00 2001
+From: Gertjan van Wingerde <gwingerde@gmail.com>
+Date: Fri, 31 Aug 2012 19:22:10 +0200
+Subject: [PATCH 2/7] rt2x00: Fix word size of rt2500usb MAC_CSR19 register.
+
+The register is 16 bits wide, not 32.
+
+Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
+Cc: <stable@vger.kernel.org>
+Acked-by: Ivo Van Doorn <ivdoorn@gmail.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/rt2x00/rt2500usb.c |  2 +-
+ drivers/net/wireless/rt2x00/rt2500usb.h | 16 ++++++++--------
+ 2 files changed, 9 insertions(+), 9 deletions(-)
+
+diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
+index 3aae36b..b3a1d73 100644
+--- a/drivers/net/wireless/rt2x00/rt2500usb.c
++++ b/drivers/net/wireless/rt2x00/rt2500usb.c
+@@ -283,7 +283,7 @@ static int rt2500usb_rfkill_poll(struct rt2x00_dev *rt2x00dev)
+ 	u16 reg;
+ 
+ 	rt2500usb_register_read(rt2x00dev, MAC_CSR19, &reg);
+-	return rt2x00_get_field32(reg, MAC_CSR19_BIT7);
++	return rt2x00_get_field16(reg, MAC_CSR19_BIT7);
+ }
+ 
+ #ifdef CONFIG_RT2X00_LIB_LEDS
+diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless/rt2x00/rt2500usb.h
+index b493306..192531d 100644
+--- a/drivers/net/wireless/rt2x00/rt2500usb.h
++++ b/drivers/net/wireless/rt2x00/rt2500usb.h
+@@ -189,14 +189,14 @@
+  * MAC_CSR19: GPIO control register.
+  */
+ #define MAC_CSR19			0x0426
+-#define MAC_CSR19_BIT0			FIELD32(0x0001)
+-#define MAC_CSR19_BIT1			FIELD32(0x0002)
+-#define MAC_CSR19_BIT2			FIELD32(0x0004)
+-#define MAC_CSR19_BIT3			FIELD32(0x0008)
+-#define MAC_CSR19_BIT4			FIELD32(0x0010)
+-#define MAC_CSR19_BIT5			FIELD32(0x0020)
+-#define MAC_CSR19_BIT6			FIELD32(0x0040)
+-#define MAC_CSR19_BIT7			FIELD32(0x0080)
++#define MAC_CSR19_BIT0			FIELD16(0x0001)
++#define MAC_CSR19_BIT1			FIELD16(0x0002)
++#define MAC_CSR19_BIT2			FIELD16(0x0004)
++#define MAC_CSR19_BIT3			FIELD16(0x0008)
++#define MAC_CSR19_BIT4			FIELD16(0x0010)
++#define MAC_CSR19_BIT5			FIELD16(0x0020)
++#define MAC_CSR19_BIT6			FIELD16(0x0040)
++#define MAC_CSR19_BIT7			FIELD16(0x0080)
+ 
+ /*
+  * MAC_CSR20: LED control register.
+-- 
+1.7.12
+
diff --git a/pending-stable/0003-rt2x00-Fix-rfkill-polling-prior-to-interface-start.patch b/pending-stable/0003-rt2x00-Fix-rfkill-polling-prior-to-interface-start.patch
new file mode 100644
index 0000000..744818e
--- /dev/null
+++ b/pending-stable/0003-rt2x00-Fix-rfkill-polling-prior-to-interface-start.patch
@@ -0,0 +1,272 @@
+From a396e10019eaf3809b0219c966865aaafec12630 Mon Sep 17 00:00:00 2001
+From: Gertjan van Wingerde <gwingerde@gmail.com>
+Date: Fri, 31 Aug 2012 19:22:11 +0200
+Subject: [PATCH 3/7] rt2x00: Fix rfkill polling prior to interface start.
+
+We need to program the rfkill switch GPIO pin direction to input at
+device initialization time, not only when the interface is brought up.
+Doing this only when the interface is brought up could lead to rfkill
+detecting the switch is turned on erroneously and inability to create
+the interface and bringing it up.
+
+Reported-and-tested-by: Andreas Messer <andi@bastelmap.de>
+Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
+Cc: <stable@vger.kernel.org>
+Acked-by: Ivo Van Doorn <ivdoorn@gmail.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/rt2x00/rt2400pci.c | 9 +++++++++
+ drivers/net/wireless/rt2x00/rt2400pci.h | 1 +
+ drivers/net/wireless/rt2x00/rt2500pci.c | 9 +++++++++
+ drivers/net/wireless/rt2x00/rt2500usb.c | 9 +++++++++
+ drivers/net/wireless/rt2x00/rt2500usb.h | 1 +
+ drivers/net/wireless/rt2x00/rt2800pci.c | 9 +++++++++
+ drivers/net/wireless/rt2x00/rt2800usb.c | 9 +++++++++
+ drivers/net/wireless/rt2x00/rt61pci.c   | 9 +++++++++
+ drivers/net/wireless/rt2x00/rt61pci.h   | 1 +
+ drivers/net/wireless/rt2x00/rt73usb.c   | 9 +++++++++
+ drivers/net/wireless/rt2x00/rt73usb.h   | 3 +++
+ 11 files changed, 69 insertions(+)
+
+diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
+index 8b9dbd7..64328af 100644
+--- a/drivers/net/wireless/rt2x00/rt2400pci.c
++++ b/drivers/net/wireless/rt2x00/rt2400pci.c
+@@ -1611,6 +1611,7 @@ static int rt2400pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
+ static int rt2400pci_probe_hw(struct rt2x00_dev *rt2x00dev)
+ {
+ 	int retval;
++	u32 reg;
+ 
+ 	/*
+ 	 * Allocate eeprom data.
+@@ -1624,6 +1625,14 @@ static int rt2400pci_probe_hw(struct rt2x00_dev *rt2x00dev)
+ 		return retval;
+ 
+ 	/*
++	 * Enable rfkill polling by setting GPIO direction of the
++	 * rfkill switch GPIO pin correctly.
++	 */
++	rt2x00pci_register_read(rt2x00dev, GPIOCSR, &reg);
++	rt2x00_set_field32(&reg, GPIOCSR_BIT8, 1);
++	rt2x00pci_register_write(rt2x00dev, GPIOCSR, reg);
++
++	/*
+ 	 * Initialize hw specifications.
+ 	 */
+ 	retval = rt2400pci_probe_hw_mode(rt2x00dev);
+diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h b/drivers/net/wireless/rt2x00/rt2400pci.h
+index d3a4a68..7564ae9 100644
+--- a/drivers/net/wireless/rt2x00/rt2400pci.h
++++ b/drivers/net/wireless/rt2x00/rt2400pci.h
+@@ -670,6 +670,7 @@
+ #define GPIOCSR_BIT5			FIELD32(0x00000020)
+ #define GPIOCSR_BIT6			FIELD32(0x00000040)
+ #define GPIOCSR_BIT7			FIELD32(0x00000080)
++#define GPIOCSR_BIT8			FIELD32(0x00000100)
+ 
+ /*
+  * BBPPCSR: BBP Pin control register.
+diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
+index d2cf8a4..3de0406 100644
+--- a/drivers/net/wireless/rt2x00/rt2500pci.c
++++ b/drivers/net/wireless/rt2x00/rt2500pci.c
+@@ -1929,6 +1929,7 @@ static int rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
+ static int rt2500pci_probe_hw(struct rt2x00_dev *rt2x00dev)
+ {
+ 	int retval;
++	u32 reg;
+ 
+ 	/*
+ 	 * Allocate eeprom data.
+@@ -1942,6 +1943,14 @@ static int rt2500pci_probe_hw(struct rt2x00_dev *rt2x00dev)
+ 		return retval;
+ 
+ 	/*
++	 * Enable rfkill polling by setting GPIO direction of the
++	 * rfkill switch GPIO pin correctly.
++	 */
++	rt2x00pci_register_read(rt2x00dev, GPIOCSR, &reg);
++	rt2x00_set_field32(&reg, GPIOCSR_DIR0, 1);
++	rt2x00pci_register_write(rt2x00dev, GPIOCSR, reg);
++
++	/*
+ 	 * Initialize hw specifications.
+ 	 */
+ 	retval = rt2500pci_probe_hw_mode(rt2x00dev);
+diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
+index b3a1d73..89fee31 100644
+--- a/drivers/net/wireless/rt2x00/rt2500usb.c
++++ b/drivers/net/wireless/rt2x00/rt2500usb.c
+@@ -1768,6 +1768,7 @@ static int rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
+ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
+ {
+ 	int retval;
++	u16 reg;
+ 
+ 	/*
+ 	 * Allocate eeprom data.
+@@ -1781,6 +1782,14 @@ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
+ 		return retval;
+ 
+ 	/*
++	 * Enable rfkill polling by setting GPIO direction of the
++	 * rfkill switch GPIO pin correctly.
++	 */
++	rt2500usb_register_read(rt2x00dev, MAC_CSR19, &reg);
++	rt2x00_set_field16(&reg, MAC_CSR19_BIT8, 0);
++	rt2500usb_register_write(rt2x00dev, MAC_CSR19, reg);
++
++	/*
+ 	 * Initialize hw specifications.
+ 	 */
+ 	retval = rt2500usb_probe_hw_mode(rt2x00dev);
+diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless/rt2x00/rt2500usb.h
+index 192531d..196bd51 100644
+--- a/drivers/net/wireless/rt2x00/rt2500usb.h
++++ b/drivers/net/wireless/rt2x00/rt2500usb.h
+@@ -197,6 +197,7 @@
+ #define MAC_CSR19_BIT5			FIELD16(0x0020)
+ #define MAC_CSR19_BIT6			FIELD16(0x0040)
+ #define MAC_CSR19_BIT7			FIELD16(0x0080)
++#define MAC_CSR19_BIT8			FIELD16(0x0100)
+ 
+ /*
+  * MAC_CSR20: LED control register.
+diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
+index 98aa426..4765bbd 100644
+--- a/drivers/net/wireless/rt2x00/rt2800pci.c
++++ b/drivers/net/wireless/rt2x00/rt2800pci.c
+@@ -983,6 +983,7 @@ static int rt2800pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
+ static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x00dev)
+ {
+ 	int retval;
++	u32 reg;
+ 
+ 	/*
+ 	 * Allocate eeprom data.
+@@ -996,6 +997,14 @@ static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x00dev)
+ 		return retval;
+ 
+ 	/*
++	 * Enable rfkill polling by setting GPIO direction of the
++	 * rfkill switch GPIO pin correctly.
++	 */
++	rt2x00pci_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
++	rt2x00_set_field32(&reg, GPIO_CTRL_CFG_GPIOD_BIT2, 1);
++	rt2x00pci_register_write(rt2x00dev, GPIO_CTRL_CFG, reg);
++
++	/*
+ 	 * Initialize hw specifications.
+ 	 */
+ 	retval = rt2800_probe_hw_mode(rt2x00dev);
+diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
+index 6681bfc..52a32b5 100644
+--- a/drivers/net/wireless/rt2x00/rt2800usb.c
++++ b/drivers/net/wireless/rt2x00/rt2800usb.c
+@@ -736,6 +736,7 @@ static int rt2800usb_validate_eeprom(struct rt2x00_dev *rt2x00dev)
+ static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
+ {
+ 	int retval;
++	u32 reg;
+ 
+ 	/*
+ 	 * Allocate eeprom data.
+@@ -749,6 +750,14 @@ static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
+ 		return retval;
+ 
+ 	/*
++	 * Enable rfkill polling by setting GPIO direction of the
++	 * rfkill switch GPIO pin correctly.
++	 */
++	rt2x00usb_register_read(rt2x00dev, GPIO_CTRL_CFG, &reg);
++	rt2x00_set_field32(&reg, GPIO_CTRL_CFG_GPIOD_BIT2, 1);
++	rt2x00usb_register_write(rt2x00dev, GPIO_CTRL_CFG, reg);
++
++	/*
+ 	 * Initialize hw specifications.
+ 	 */
+ 	retval = rt2800_probe_hw_mode(rt2x00dev);
+diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
+index 3f7bc5c..b8ec961 100644
+--- a/drivers/net/wireless/rt2x00/rt61pci.c
++++ b/drivers/net/wireless/rt2x00/rt61pci.c
+@@ -2832,6 +2832,7 @@ static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
+ static int rt61pci_probe_hw(struct rt2x00_dev *rt2x00dev)
+ {
+ 	int retval;
++	u32 reg;
+ 
+ 	/*
+ 	 * Disable power saving.
+@@ -2850,6 +2851,14 @@ static int rt61pci_probe_hw(struct rt2x00_dev *rt2x00dev)
+ 		return retval;
+ 
+ 	/*
++	 * Enable rfkill polling by setting GPIO direction of the
++	 * rfkill switch GPIO pin correctly.
++	 */
++	rt2x00pci_register_read(rt2x00dev, MAC_CSR13, &reg);
++	rt2x00_set_field32(&reg, MAC_CSR13_BIT13, 1);
++	rt2x00pci_register_write(rt2x00dev, MAC_CSR13, reg);
++
++	/*
+ 	 * Initialize hw specifications.
+ 	 */
+ 	retval = rt61pci_probe_hw_mode(rt2x00dev);
+diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
+index e3cd6db..8f3da5a 100644
+--- a/drivers/net/wireless/rt2x00/rt61pci.h
++++ b/drivers/net/wireless/rt2x00/rt61pci.h
+@@ -372,6 +372,7 @@ struct hw_pairwise_ta_entry {
+ #define MAC_CSR13_BIT10			FIELD32(0x00000400)
+ #define MAC_CSR13_BIT11			FIELD32(0x00000800)
+ #define MAC_CSR13_BIT12			FIELD32(0x00001000)
++#define MAC_CSR13_BIT13			FIELD32(0x00002000)
+ 
+ /*
+  * MAC_CSR14: LED control register.
+diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
+index ba6e434..248436c 100644
+--- a/drivers/net/wireless/rt2x00/rt73usb.c
++++ b/drivers/net/wireless/rt2x00/rt73usb.c
+@@ -2177,6 +2177,7 @@ static int rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
+ static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
+ {
+ 	int retval;
++	u32 reg;
+ 
+ 	/*
+ 	 * Allocate eeprom data.
+@@ -2190,6 +2191,14 @@ static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
+ 		return retval;
+ 
+ 	/*
++	 * Enable rfkill polling by setting GPIO direction of the
++	 * rfkill switch GPIO pin correctly.
++	 */
++	rt2x00usb_register_read(rt2x00dev, MAC_CSR13, &reg);
++	rt2x00_set_field32(&reg, MAC_CSR13_BIT15, 0);
++	rt2x00usb_register_write(rt2x00dev, MAC_CSR13, reg);
++
++	/*
+ 	 * Initialize hw specifications.
+ 	 */
+ 	retval = rt73usb_probe_hw_mode(rt2x00dev);
+diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/rt2x00/rt73usb.h
+index 9f6b470..df1cc11 100644
+--- a/drivers/net/wireless/rt2x00/rt73usb.h
++++ b/drivers/net/wireless/rt2x00/rt73usb.h
+@@ -282,6 +282,9 @@ struct hw_pairwise_ta_entry {
+ #define MAC_CSR13_BIT10			FIELD32(0x00000400)
+ #define MAC_CSR13_BIT11			FIELD32(0x00000800)
+ #define MAC_CSR13_BIT12			FIELD32(0x00001000)
++#define MAC_CSR13_BIT13			FIELD32(0x00002000)
++#define MAC_CSR13_BIT14			FIELD32(0x00004000)
++#define MAC_CSR13_BIT15			FIELD32(0x00008000)
+ 
+ /*
+  * MAC_CSR14: LED control register.
+-- 
+1.7.12
+
diff --git a/pending-stable/0004-rt2800usb-Added-rx-packet-length-validity-check.patch b/pending-stable/0004-rt2800usb-Added-rx-packet-length-validity-check.patch
new file mode 100644
index 0000000..8bc99e2
--- /dev/null
+++ b/pending-stable/0004-rt2800usb-Added-rx-packet-length-validity-check.patch
@@ -0,0 +1,61 @@
+From efd5d6b03bd9c9e0df646c56fb5f4f3e25e5c1ac Mon Sep 17 00:00:00 2001
+From: Sergei Poselenov <sposelenov@emcraft.com>
+Date: Sun, 2 Sep 2012 13:14:32 +0400
+Subject: [PATCH 4/7] rt2800usb: Added rx packet length validity check
+
+On our system (ARM Cortex-M3 SOC running linux-2.6.33)
+frequent crashes were observed in the rt2800usb module
+because of the invalid length of the received packet (3392,
+46920...). This patch adds the sanity check on the packet
+legth. Also, changed WARNING to ERROR in rt2x00lib_rxdone()
+so that the bad packet condition would be noticed.
+
+The fix was tested on the latest compat-wireless-3.5.1-1-snpc.
+
+Cc: stable@vger.kernel.org
+Signed-off-by: Sergei Poselenov <sposelenov@emcraft.com>
+Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/rt2x00/rt2800usb.c | 10 +++++++++-
+ drivers/net/wireless/rt2x00/rt2x00dev.c |  2 +-
+ 2 files changed, 10 insertions(+), 2 deletions(-)
+
+diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
+index 52a32b5..6b4226b 100644
+--- a/drivers/net/wireless/rt2x00/rt2800usb.c
++++ b/drivers/net/wireless/rt2x00/rt2800usb.c
+@@ -667,8 +667,16 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
+ 	skb_pull(entry->skb, RXINFO_DESC_SIZE);
+ 
+ 	/*
+-	 * FIXME: we need to check for rx_pkt_len validity
++	 * Check for rx_pkt_len validity. Return if invalid, leaving
++	 * rxdesc->size zeroed out by the upper level.
+ 	 */
++	if (unlikely(rx_pkt_len == 0 ||
++			rx_pkt_len > entry->queue->data_size)) {
++		ERROR(entry->queue->rt2x00dev,
++			"Bad frame size %d, forcing to 0\n", rx_pkt_len);
++		return;
++	}
++
+ 	rxd = (__le32 *)(entry->skb->data + rx_pkt_len);
+ 
+ 	/*
+diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
+index a6b88bd..3f07e36 100644
+--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
++++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
+@@ -629,7 +629,7 @@ void rt2x00lib_rxdone(struct queue_entry *entry, gfp_t gfp)
+ 	 */
+ 	if (unlikely(rxdesc.size == 0 ||
+ 		     rxdesc.size > entry->queue->data_size)) {
+-		WARNING(rt2x00dev, "Wrong frame size %d max %d.\n",
++		ERROR(rt2x00dev, "Wrong frame size %d max %d.\n",
+ 			rxdesc.size, entry->queue->data_size);
+ 		dev_kfree_skb(entry->skb);
+ 		goto renew_skb;
+-- 
+1.7.12
+
diff --git a/pending-stable/0005-rtlwifi-rtl8192ce-Log-message-that-B_CUT-device-may-.patch b/pending-stable/0005-rtlwifi-rtl8192ce-Log-message-that-B_CUT-device-may-.patch
new file mode 100644
index 0000000..88fd53b
--- /dev/null
+++ b/pending-stable/0005-rtlwifi-rtl8192ce-Log-message-that-B_CUT-device-may-.patch
@@ -0,0 +1,82 @@
+From 022e1d0680c7b4366017393417b8758be5abcee8 Mon Sep 17 00:00:00 2001
+From: Larry Finger <Larry.Finger@lwfinger.net>
+Date: Tue, 11 Sep 2012 11:11:13 -0500
+Subject: [PATCH 5/7] rtlwifi: rtl8192ce: Log message that B_CUT device may
+ not work
+
+There are a number of problems that occur for the latest version
+of the Realtek RTL8188CE device with the in-kernel driver. These
+include selection of the wrong firmware, and system lockup. A full
+fix is known, but is too invasive for inclusion in stable. This patch
+fixes the problem with loading the wrong firmware, and logs a message
+that the device may not work for kernels 3.6 and older.
+
+Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
+Cc: Stable <stable@vger.kernel.org>
+Cc: Anisse Astier <anisse@astier.eu>
+Cc: Li Chaoming <chaoming_li@realsil.com.cn>
+Tested-by: Anisse Astier <anisse@astier.eu>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/rtlwifi/rtl8192ce/def.h |  1 +
+ drivers/net/wireless/rtlwifi/rtl8192ce/hw.c  | 12 ++++++++++--
+ drivers/net/wireless/rtlwifi/rtl8192ce/sw.c  |  6 ++++--
+ 3 files changed, 15 insertions(+), 4 deletions(-)
+
+diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/def.h b/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
+index 04c3aef..2925094 100644
+--- a/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
++++ b/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
+@@ -117,6 +117,7 @@
+ 
+ #define CHIP_VER_B			BIT(4)
+ #define CHIP_92C_BITMASK		BIT(0)
++#define CHIP_UNKNOWN			BIT(7)
+ #define CHIP_92C_1T2R			0x03
+ #define CHIP_92C			0x01
+ #define CHIP_88C			0x00
+diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+index bd0da7e..dd4bb09 100644
+--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
++++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+@@ -994,8 +994,16 @@ static enum version_8192c _rtl92ce_read_chip_version(struct ieee80211_hw *hw)
+ 		version = (value32 & TYPE_ID) ? VERSION_A_CHIP_92C :
+ 			   VERSION_A_CHIP_88C;
+ 	} else {
+-		version = (value32 & TYPE_ID) ? VERSION_B_CHIP_92C :
+-			   VERSION_B_CHIP_88C;
++		version = (enum version_8192c) (CHIP_VER_B |
++				((value32 & TYPE_ID) ? CHIP_92C_BITMASK : 0) |
++				((value32 & VENDOR_ID) ? CHIP_VENDOR_UMC : 0));
++		if ((!IS_CHIP_VENDOR_UMC(version)) && (value32 &
++		     CHIP_VER_RTL_MASK)) {
++			version = (enum version_8192c)(version |
++				   ((((value32 & CHIP_VER_RTL_MASK) == BIT(12))
++				   ? CHIP_VENDOR_UMC_B_CUT : CHIP_UNKNOWN) |
++				   CHIP_VENDOR_UMC));
++		}
+ 	}
+ 
+ 	switch (version) {
+diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+index 3aa927f..7d8f964 100644
+--- a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
++++ b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+@@ -162,10 +162,12 @@ int rtl92c_init_sw_vars(struct ieee80211_hw *hw)
+ 
+ 	/* request fw */
+ 	if (IS_VENDOR_UMC_A_CUT(rtlhal->version) &&
+-	    !IS_92C_SERIAL(rtlhal->version))
++	    !IS_92C_SERIAL(rtlhal->version)) {
+ 		rtlpriv->cfg->fw_name = "rtlwifi/rtl8192cfwU.bin";
+-	else if (IS_81xxC_VENDOR_UMC_B_CUT(rtlhal->version))
++	} else if (IS_81xxC_VENDOR_UMC_B_CUT(rtlhal->version)) {
+ 		rtlpriv->cfg->fw_name = "rtlwifi/rtl8192cfwU_B.bin";
++		pr_info("****** This B_CUT device may not work with kernels 3.6 and earlier\n");
++	}
+ 
+ 	rtlpriv->max_fw_size = 0x4000;
+ 	pr_info("Using firmware %s\n", rtlpriv->cfg->fw_name);
+-- 
+1.7.12
+
diff --git a/pending-stable/0006-brcmfmac-fix-big-endian-bug-in-i-scan.patch b/pending-stable/0006-brcmfmac-fix-big-endian-bug-in-i-scan.patch
new file mode 100644
index 0000000..45b025e
--- /dev/null
+++ b/pending-stable/0006-brcmfmac-fix-big-endian-bug-in-i-scan.patch
@@ -0,0 +1,35 @@
+From ed205b361956c96e0d8c09a8c9135a6a79cd9541 Mon Sep 17 00:00:00 2001
+From: Hante Meuleman <meuleman@broadcom.com>
+Date: Tue, 11 Sep 2012 21:16:47 +0200
+Subject: [PATCH 6/7] brcmfmac: fix big endian bug in i-scan.
+
+ssid len is 32 bit and needs endian conversion for big endian systems.
+
+Cc: stable <stable@vger.kernel.org>
+Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
+Signed-off-by: Arend van Spriel <arend@broadcom.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 6 ++++--
+ 1 file changed, 4 insertions(+), 2 deletions(-)
+
+diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+index c36e923..50b5553 100644
+--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
++++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+@@ -500,8 +500,10 @@ static void wl_iscan_prep(struct brcmf_scan_params_le *params_le,
+ 	params_le->active_time = cpu_to_le32(-1);
+ 	params_le->passive_time = cpu_to_le32(-1);
+ 	params_le->home_time = cpu_to_le32(-1);
+-	if (ssid && ssid->SSID_len)
+-		memcpy(&params_le->ssid_le, ssid, sizeof(struct brcmf_ssid));
++	if (ssid && ssid->SSID_len) {
++		params_le->ssid_le.SSID_len = cpu_to_le32(ssid->SSID_len);
++		memcpy(&params_le->ssid_le.SSID, ssid->SSID, ssid->SSID_len);
++	}
+ }
+ 
+ static s32
+-- 
+1.7.12
+
diff --git a/pending-stable/0007-brcmfmac-Fix-big-endian-host-configuration-data.patch b/pending-stable/0007-brcmfmac-Fix-big-endian-host-configuration-data.patch
new file mode 100644
index 0000000..2b38d9b
--- /dev/null
+++ b/pending-stable/0007-brcmfmac-Fix-big-endian-host-configuration-data.patch
@@ -0,0 +1,93 @@
+From e020a83d0942a5aceac35986500c9834efc8707d Mon Sep 17 00:00:00 2001
+From: Hante Meuleman <meuleman@broadcom.com>
+Date: Tue, 11 Sep 2012 21:16:48 +0200
+Subject: [PATCH 7/7] brcmfmac: Fix big endian host configuration data.
+
+Fixes big endian host configuration parameters.
+
+Cc: stable <stable@vger.kernel.org>
+Reviewed-by: Arend Van Spriel <arend@broadcom.com>
+Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
+Signed-off-by: Arend van Spriel <arend@broadcom.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ .../net/wireless/brcm80211/brcmfmac/dhd_common.c   | 26 +++++++++++++---------
+ 1 file changed, 16 insertions(+), 10 deletions(-)
+
+diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+index 2621dd3..6f70953 100644
+--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
++++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+@@ -764,8 +764,11 @@ static void brcmf_c_arp_offload_set(struct brcmf_pub *drvr, int arp_mode)
+ {
+ 	char iovbuf[32];
+ 	int retcode;
++	__le32 arp_mode_le;
+ 
+-	brcmf_c_mkiovar("arp_ol", (char *)&arp_mode, 4, iovbuf, sizeof(iovbuf));
++	arp_mode_le = cpu_to_le32(arp_mode);
++	brcmf_c_mkiovar("arp_ol", (char *)&arp_mode_le, 4, iovbuf,
++			sizeof(iovbuf));
+ 	retcode = brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR,
+ 				   iovbuf, sizeof(iovbuf));
+ 	retcode = retcode >= 0 ? 0 : retcode;
+@@ -781,8 +784,11 @@ static void brcmf_c_arp_offload_enable(struct brcmf_pub *drvr, int arp_enable)
+ {
+ 	char iovbuf[32];
+ 	int retcode;
++	__le32 arp_enable_le;
+ 
+-	brcmf_c_mkiovar("arpoe", (char *)&arp_enable, 4,
++	arp_enable_le = cpu_to_le32(arp_enable);
++
++	brcmf_c_mkiovar("arpoe", (char *)&arp_enable_le, 4,
+ 			iovbuf, sizeof(iovbuf));
+ 	retcode = brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR,
+ 				   iovbuf, sizeof(iovbuf));
+@@ -800,10 +806,10 @@ int brcmf_c_preinit_dcmds(struct brcmf_pub *drvr)
+ 	char iovbuf[BRCMF_EVENTING_MASK_LEN + 12];	/*  Room for
+ 				 "event_msgs" + '\0' + bitvec  */
+ 	char buf[128], *ptr;
+-	u32 roaming = 1;
+-	uint bcn_timeout = 3;
+-	int scan_assoc_time = 40;
+-	int scan_unassoc_time = 40;
++	__le32 roaming_le = cpu_to_le32(1);
++	__le32 bcn_timeout_le = cpu_to_le32(3);
++	__le32 scan_assoc_time_le = cpu_to_le32(40);
++	__le32 scan_unassoc_time_le = cpu_to_le32(40);
+ 	int i;
+ 	struct brcmf_bus_dcmd *cmdlst;
+ 	struct list_head *cur, *q;
+@@ -829,14 +835,14 @@ int brcmf_c_preinit_dcmds(struct brcmf_pub *drvr)
+ 
+ 	/* Setup timeout if Beacons are lost and roam is off to report
+ 		 link down */
+-	brcmf_c_mkiovar("bcn_timeout", (char *)&bcn_timeout, 4, iovbuf,
++	brcmf_c_mkiovar("bcn_timeout", (char *)&bcn_timeout_le, 4, iovbuf,
+ 		    sizeof(iovbuf));
+ 	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
+ 				  sizeof(iovbuf));
+ 
+ 	/* Enable/Disable build-in roaming to allowed ext supplicant to take
+ 		 of romaing */
+-	brcmf_c_mkiovar("roam_off", (char *)&roaming, 4,
++	brcmf_c_mkiovar("roam_off", (char *)&roaming_le, 4,
+ 		      iovbuf, sizeof(iovbuf));
+ 	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
+ 				  sizeof(iovbuf));
+@@ -848,9 +854,9 @@ int brcmf_c_preinit_dcmds(struct brcmf_pub *drvr)
+ 				  sizeof(iovbuf));
+ 
+ 	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_SCAN_CHANNEL_TIME,
+-			 (char *)&scan_assoc_time, sizeof(scan_assoc_time));
++		 (char *)&scan_assoc_time_le, sizeof(scan_assoc_time_le));
+ 	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_SCAN_UNASSOC_TIME,
+-			 (char *)&scan_unassoc_time, sizeof(scan_unassoc_time));
++		 (char *)&scan_unassoc_time_le, sizeof(scan_unassoc_time_le));
+ 
+ 	/* Set and enable ARP offload feature */
+ 	brcmf_c_arp_offload_set(drvr, BRCMF_ARPOL_MODE);
+-- 
+1.7.12
+
-- 
1.7.12

