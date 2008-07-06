Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.178]:22588 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566AbYGFPCi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2008 11:02:38 -0400
Received: by ik-out-1112.google.com with SMTP id c28so858398ika.5
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2008 08:02:36 -0700 (PDT)
To: linville@tuxdriver.com
Subject: rt2x00: Fix register comments
Date: Sun, 6 Jul 2008 17:09:48 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807061709.48731.IvDoorn@gmail.com> (sfid-20080706_170259_190037_0248F8E4)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix some register documentation in the register header files.
This allows better parsing by userspace scripts which in turn
helps debugging.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.h b/drivers/net/wireless/rt2x00/rt2500pci.h
index cb648c3..42f3769 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/rt2x00/rt2500pci.h
@@ -751,7 +751,7 @@
 #define LEDCSR_LED_DEFAULT		FIELD32(0x00100000)
 
 /*
- * AES control register.
+ * SECCSR3: AES control register.
  */
 #define SECCSR3				0x00fc
 
@@ -895,7 +895,7 @@
 #define ARTCSR2_ACK_CTS_54MBS		FIELD32(0xff000000)
 
 /*
- * SECCSR1_RT2509: WEP control register.
+ * SECCSR1: WEP control register.
  * KICK_ENCRYPT: Kick encryption engine, self-clear.
  * ONE_SHOT: 0: ring mode, 1: One shot only mode.
  * DESC_ADDRESS: Descriptor physical address of frame.
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless/rt2x00/rt2500usb.h
index c8697b9..fe5a23e 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/rt2x00/rt2500usb.h
@@ -209,7 +209,7 @@
 #define MAC_CSR21_OFF_PERIOD		FIELD16(0xff00)
 
 /*
- * Collision window control register.
+ * MAC_CSR22: Collision window control register.
  */
 #define MAC_CSR22			0x042c
 
@@ -296,7 +296,7 @@
 #define TXRX_CSR7_BBP_ID1_VALID		FIELD16(0x8000)
 
 /*
- * TXRX_CSR5: OFDM TX BBP ID1.
+ * TXRX_CSR8: OFDM TX BBP ID1.
  */
 #define TXRX_CSR8			0x0450
 #define TXRX_CSR8_BBP_ID0		FIELD16(0x007f)
@@ -370,7 +370,14 @@
  */
 
 /*
- * SEC_CSR0-SEC_CSR7: Shared key 0, word 0-7
+ * SEC_CSR0: Shared key 0, word 0
+ * SEC_CSR1: Shared key 0, word 1
+ * SEC_CSR2: Shared key 0, word 2
+ * SEC_CSR3: Shared key 0, word 3
+ * SEC_CSR4: Shared key 0, word 4
+ * SEC_CSR5: Shared key 0, word 5
+ * SEC_CSR6: Shared key 0, word 6
+ * SEC_CSR7: Shared key 0, word 7
  */
 #define SEC_CSR0			0x0480
 #define SEC_CSR1			0x0482
@@ -382,7 +389,14 @@
 #define SEC_CSR7			0x048e
 
 /*
- * SEC_CSR8-SEC_CSR15: Shared key 1, word 0-7
+ * SEC_CSR8: Shared key 1, word 0
+ * SEC_CSR9: Shared key 1, word 1
+ * SEC_CSR10: Shared key 1, word 2
+ * SEC_CSR11: Shared key 1, word 3
+ * SEC_CSR12: Shared key 1, word 4
+ * SEC_CSR13: Shared key 1, word 5
+ * SEC_CSR14: Shared key 1, word 6
+ * SEC_CSR15: Shared key 1, word 7
  */
 #define SEC_CSR8			0x0490
 #define SEC_CSR9			0x0492
@@ -394,7 +408,14 @@
 #define SEC_CSR15			0x049e
 
 /*
- * SEC_CSR16-SEC_CSR23: Shared key 2, word 0-7
+ * SEC_CSR16: Shared key 2, word 0
+ * SEC_CSR17: Shared key 2, word 1
+ * SEC_CSR18: Shared key 2, word 2
+ * SEC_CSR19: Shared key 2, word 3
+ * SEC_CSR20: Shared key 2, word 4
+ * SEC_CSR21: Shared key 2, word 5
+ * SEC_CSR22: Shared key 2, word 6
+ * SEC_CSR23: Shared key 2, word 7
  */
 #define SEC_CSR16			0x04a0
 #define SEC_CSR17			0x04a2
@@ -406,7 +427,14 @@
 #define SEC_CSR23			0x04ae
 
 /*
- * SEC_CSR24-SEC_CSR31: Shared key 3, word 0-7
+ * SEC_CSR24: Shared key 3, word 0
+ * SEC_CSR25: Shared key 3, word 1
+ * SEC_CSR26: Shared key 3, word 2
+ * SEC_CSR27: Shared key 3, word 3
+ * SEC_CSR28: Shared key 3, word 4
+ * SEC_CSR29: Shared key 3, word 5
+ * SEC_CSR30: Shared key 3, word 6
+ * SEC_CSR31: Shared key 3, word 7
  */
 #define SEC_CSR24			0x04b0
 #define SEC_CSR25			0x04b2
