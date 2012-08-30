Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:1728 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752628Ab2H3VEi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 17:04:38 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: <users@rt2x00.serialmonkey.com>, Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 13/17] rt2x00: Align rt73usb MAC_CSR13 definition with datasheet.
Date: Thu, 30 Aug 2012 23:04:24 +0200
Message-Id: <1346360670-6498-7-git-send-email-gwingerde@gmail.com> (sfid-20120830_230456_330814_E8B1A99D)
In-Reply-To: <1346360670-6498-6-git-send-email-gwingerde@gmail.com>
References: <1346355248-5331-10-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-1-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-2-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-3-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-4-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-5-git-send-email-gwingerde@gmail.com>
 <1346360670-6498-6-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename MAC_CSR13_BIT<x> to MAC_CSR13_VAL<x> and MAC_CSR13_DIR<x> to
represent the actual meaning better.
Clean up list to only mention the active GPIO pins, not just all bits.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: <stable@vger.kernel.org>

diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index ba6e434..d5b6fb8 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -189,7 +189,7 @@ static int rt73usb_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 	u32 reg;
 
 	rt2x00usb_register_read(rt2x00dev, MAC_CSR13, &reg);
-	return rt2x00_get_field32(reg, MAC_CSR13_BIT7);
+	return rt2x00_get_field32(reg, MAC_CSR13_VAL7);
 }
 
 #ifdef CONFIG_RT2X00_LIB_LEDS
diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/rt2x00/rt73usb.h
index 9f6b470..7577e0b 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -267,21 +267,26 @@ struct hw_pairwise_ta_entry {
 
 /*
  * MAC_CSR13: GPIO.
+ *	MAC_CSR13_VALx: GPIO value
+ *	MAC_CSR13_DIRx: GPIO direction: 0 = input; 1 = output
  */
 #define MAC_CSR13			0x3034
-#define MAC_CSR13_BIT0			FIELD32(0x00000001)
-#define MAC_CSR13_BIT1			FIELD32(0x00000002)
-#define MAC_CSR13_BIT2			FIELD32(0x00000004)
-#define MAC_CSR13_BIT3			FIELD32(0x00000008)
-#define MAC_CSR13_BIT4			FIELD32(0x00000010)
-#define MAC_CSR13_BIT5			FIELD32(0x00000020)
-#define MAC_CSR13_BIT6			FIELD32(0x00000040)
-#define MAC_CSR13_BIT7			FIELD32(0x00000080)
-#define MAC_CSR13_BIT8			FIELD32(0x00000100)
-#define MAC_CSR13_BIT9			FIELD32(0x00000200)
-#define MAC_CSR13_BIT10			FIELD32(0x00000400)
-#define MAC_CSR13_BIT11			FIELD32(0x00000800)
-#define MAC_CSR13_BIT12			FIELD32(0x00001000)
+#define MAC_CSR13_VAL0			FIELD32(0x00000001)
+#define MAC_CSR13_VAL1			FIELD32(0x00000002)
+#define MAC_CSR13_VAL2			FIELD32(0x00000004)
+#define MAC_CSR13_VAL3			FIELD32(0x00000008)
+#define MAC_CSR13_VAL4			FIELD32(0x00000010)
+#define MAC_CSR13_VAL5			FIELD32(0x00000020)
+#define MAC_CSR13_VAL6			FIELD32(0x00000040)
+#define MAC_CSR13_VAL7			FIELD32(0x00000080)
+#define MAC_CSR13_DIR0			FIELD32(0x00000100)
+#define MAC_CSR13_DIR1			FIELD32(0x00000200)
+#define MAC_CSR13_DIR2			FIELD32(0x00000400)
+#define MAC_CSR13_DIR3			FIELD32(0x00000800)
+#define MAC_CSR13_DIR4			FIELD32(0x00001000)
+#define MAC_CSR13_DIR5			FIELD32(0x00002000)
+#define MAC_CSR13_DIR6			FIELD32(0x00004000)
+#define MAC_CSR13_DIR7			FIELD32(0x00008000)
 
 /*
  * MAC_CSR14: LED control register.
-- 
1.7.11.1

