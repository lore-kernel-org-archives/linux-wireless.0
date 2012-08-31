Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:4682 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754649Ab2HaRWU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2012 13:22:20 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: <users@rt2x00.serialmonkey.com>, Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH v2 4/6] rt2x00: Align GPIO register definitions with the datasheets.
Date: Fri, 31 Aug 2012 19:22:12 +0200
Message-Id: <1346433734-3337-5-git-send-email-gwingerde@gmail.com> (sfid-20120831_192233_220990_87C9DD44)
In-Reply-To: <1346433734-3337-4-git-send-email-gwingerde@gmail.com>
References: <1346433734-3337-1-git-send-email-gwingerde@gmail.com>
 <1346433734-3337-2-git-send-email-gwingerde@gmail.com>
 <1346433734-3337-3-git-send-email-gwingerde@gmail.com>
 <1346433734-3337-4-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ensure that all active GPIO pins are included in the GPIO register
definitions, nothing more and nothing less.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h b/drivers/net/wireless/rt2x00/rt2400pci.h
index 7564ae9..9d78a53 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/rt2x00/rt2400pci.h
@@ -671,6 +671,13 @@
 #define GPIOCSR_BIT6			FIELD32(0x00000040)
 #define GPIOCSR_BIT7			FIELD32(0x00000080)
 #define GPIOCSR_BIT8			FIELD32(0x00000100)
+#define GPIOCSR_BIT9			FIELD32(0x00000200)
+#define GPIOCSR_BIT10			FIELD32(0x00000400)
+#define GPIOCSR_BIT11			FIELD32(0x00000800)
+#define GPIOCSR_BIT12			FIELD32(0x00001000)
+#define GPIOCSR_BIT13			FIELD32(0x00002000)
+#define GPIOCSR_BIT14			FIELD32(0x00004000)
+#define GPIOCSR_BIT15			FIELD32(0x00008000)
 
 /*
  * BBPPCSR: BBP Pin control register.
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless/rt2x00/rt2500usb.h
index 196bd51..9652300 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/rt2x00/rt2500usb.h
@@ -198,6 +198,13 @@
 #define MAC_CSR19_BIT6			FIELD16(0x0040)
 #define MAC_CSR19_BIT7			FIELD16(0x0080)
 #define MAC_CSR19_BIT8			FIELD16(0x0100)
+#define MAC_CSR19_BIT9			FIELD16(0x0200)
+#define MAC_CSR19_BIT10			FIELD16(0x0400)
+#define MAC_CSR19_BIT11			FIELD16(0x0800)
+#define MAC_CSR19_BIT12			FIELD16(0x1000)
+#define MAC_CSR19_BIT13			FIELD16(0x2000)
+#define MAC_CSR19_BIT14			FIELD16(0x4000)
+#define MAC_CSR19_BIT15			FIELD16(0x8000)
 
 /*
  * MAC_CSR20: LED control register.
diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index e252e9b..a838e17 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -459,6 +459,12 @@
 #define GPIO_CTRL_CFG_GPIOD_BIT5	FIELD32(0x00002000)
 #define GPIO_CTRL_CFG_GPIOD_BIT6	FIELD32(0x00004000)
 #define GPIO_CTRL_CFG_GPIOD_BIT7	FIELD32(0x00008000)
+#define GPIO_CTRL_CFG_BIT8		FIELD32(0x00010000)
+#define GPIO_CTRL_CFG_BIT9		FIELD32(0x00020000)
+#define GPIO_CTRL_CFG_BIT10		FIELD32(0x00040000)
+#define GPIO_CTRL_CFG_GPIOD_BIT8	FIELD32(0x01000000)
+#define GPIO_CTRL_CFG_GPIOD_BIT9	FIELD32(0x02000000)
+#define GPIO_CTRL_CFG_GPIOD_BIT10	FIELD32(0x04000000)
 
 /*
  * MCU_CMD_CFG
diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
index 8f3da5a..9ee0c33 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -365,8 +365,6 @@ struct hw_pairwise_ta_entry {
 #define MAC_CSR13_BIT3			FIELD32(0x00000008)
 #define MAC_CSR13_BIT4			FIELD32(0x00000010)
 #define MAC_CSR13_BIT5			FIELD32(0x00000020)
-#define MAC_CSR13_BIT6			FIELD32(0x00000040)
-#define MAC_CSR13_BIT7			FIELD32(0x00000080)
 #define MAC_CSR13_BIT8			FIELD32(0x00000100)
 #define MAC_CSR13_BIT9			FIELD32(0x00000200)
 #define MAC_CSR13_BIT10			FIELD32(0x00000400)
-- 
1.7.11.1

