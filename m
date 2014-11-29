Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:49459 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaK2ACh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 19:02:37 -0500
Received: by mail-wg0-f53.google.com with SMTP id l18so9876069wgh.40
        for <linux-wireless@vger.kernel.org>; Fri, 28 Nov 2014 16:02:36 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/6] staging: vt6655: remove duplicate MACvSetPacketFilter
Date: Sat, 29 Nov 2014 00:01:58 +0000
Message-Id: <1417219323-3988-1-git-send-email-tvboxspy@gmail.com> (sfid-20141129_010241_070488_A68B4573)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Packet filtering is already done in vnt_configure.

A call to MACvSetPacketFilter is not necessary in MACvInitialize as
this will be done by vnt_configure when interface is up.

Also remove macros associated with this function.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/mac.c | 66 --------------------------------------------
 drivers/staging/vt6655/mac.h | 13 ---------
 2 files changed, 79 deletions(-)

diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index af96606..8f0d652 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -33,7 +33,6 @@
  *      MACvGetShortRetryLimit - Get 802.11 Short Retry limit
  *      MACvSetLongRetryLimit - Set 802.11 Long Retry limit
  *      MACvSetLoopbackMode - Set MAC Loopback Mode
- *      MACvSetPacketFilter - Set MAC Address Filter
  *      MACvSaveContext - Save Context of MAC Registers
  *      MACvRestoreContext - Restore Context of MAC Registers
  *      MACbSoftwareReset - Software Reset MAC
@@ -215,66 +214,6 @@ void MACvSetLoopbackMode(void __iomem *dwIoBase, unsigned char byLoopbackMode)
 
 /*
  * Description:
- *      Set MAC Address filter
- *
- * Parameters:
- *  In:
- *      dwIoBase        - Base Address for MAC
- *      wFilterType     - Filter Type
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void MACvSetPacketFilter(void __iomem *dwIoBase, unsigned short wFilterType)
-{
-	unsigned char byOldRCR;
-	unsigned char byNewRCR = 0;
-
-	// if only in DIRECTED mode, multicast-address will set to zero,
-	// but if other mode exist (e.g. PROMISCUOUS), multicast-address
-	// will be open
-	if (wFilterType & PKT_TYPE_DIRECTED) {
-		// set multicast address to accept none
-		MACvSelectPage1(dwIoBase);
-		VNSvOutPortD(dwIoBase + MAC_REG_MAR0, 0L);
-		VNSvOutPortD(dwIoBase + MAC_REG_MAR0 + sizeof(unsigned long), 0L);
-		MACvSelectPage0(dwIoBase);
-	}
-
-	if (wFilterType & (PKT_TYPE_PROMISCUOUS | PKT_TYPE_ALL_MULTICAST)) {
-		// set multicast address to accept all
-		MACvSelectPage1(dwIoBase);
-		VNSvOutPortD(dwIoBase + MAC_REG_MAR0, 0xFFFFFFFFL);
-		VNSvOutPortD(dwIoBase + MAC_REG_MAR0 + sizeof(unsigned long), 0xFFFFFFFFL);
-		MACvSelectPage0(dwIoBase);
-	}
-
-	if (wFilterType & PKT_TYPE_PROMISCUOUS) {
-		byNewRCR |= (RCR_RXALLTYPE | RCR_UNICAST | RCR_MULTICAST | RCR_BROADCAST);
-
-		byNewRCR &= ~RCR_BSSID;
-	}
-
-	if (wFilterType & (PKT_TYPE_ALL_MULTICAST | PKT_TYPE_MULTICAST))
-		byNewRCR |= RCR_MULTICAST;
-
-	if (wFilterType & PKT_TYPE_BROADCAST)
-		byNewRCR |= RCR_BROADCAST;
-
-	if (wFilterType & PKT_TYPE_ERROR_CRC)
-		byNewRCR |= RCR_ERRCRC;
-
-	VNSvInPortB(dwIoBase + MAC_REG_RCR,  &byOldRCR);
-	if (byNewRCR != byOldRCR) {
-		// Modify the Receive Command Register
-		VNSvOutPortB(dwIoBase + MAC_REG_RCR, byNewRCR);
-	}
-}
-
-/*
- * Description:
  *      Save MAC registers to context buffer
  *
  * Parameters:
@@ -629,11 +568,6 @@ void MACvInitialize(void __iomem *dwIoBase)
 	VNSvOutPortB(dwIoBase + MAC_REG_TFTCTL, TFTCTL_TSFCNTRST);
 	// enable TSF counter
 	VNSvOutPortB(dwIoBase + MAC_REG_TFTCTL, TFTCTL_TSFCNTREN);
-
-	// set packet filter
-	// receive directed and broadcast address
-
-	MACvSetPacketFilter(dwIoBase, PKT_TYPE_DIRECTED | PKT_TYPE_BROADCAST);
 }
 
 /*
diff --git a/drivers/staging/vt6655/mac.h b/drivers/staging/vt6655/mac.h
index 7d39a7f..e1e7e10 100644
--- a/drivers/staging/vt6655/mac.h
+++ b/drivers/staging/vt6655/mac.h
@@ -574,17 +574,6 @@
 #define MAC_LB_INTERNAL     0x01        //
 #define MAC_LB_NONE         0x00        //
 
-// Ethernet address filter type
-#define PKT_TYPE_NONE           0x00    // turn off receiver
-#define PKT_TYPE_ALL_MULTICAST  0x80
-#define PKT_TYPE_PROMISCUOUS    0x40
-#define PKT_TYPE_DIRECTED       0x20    // obsolete, directed address is always accepted
-#define PKT_TYPE_BROADCAST      0x10
-#define PKT_TYPE_MULTICAST      0x08
-#define PKT_TYPE_ERROR_WPA      0x04
-#define PKT_TYPE_ERROR_CRC      0x02
-#define PKT_TYPE_BSSID          0x01
-
 #define Default_BI              0x200
 
 // MiscFIFO Offset
@@ -976,8 +965,6 @@ void MACvGetLongRetryLimit(void __iomem *dwIoBase, unsigned char *pbyRetryLimit)
 
 void MACvSetLoopbackMode(void __iomem *dwIoBase, unsigned char byLoopbackMode);
 
-void MACvSetPacketFilter(void __iomem *dwIoBase, unsigned short wFilterType);
-
 void MACvSaveContext(void __iomem *dwIoBase, unsigned char *pbyCxtBuf);
 void MACvRestoreContext(void __iomem *dwIoBase, unsigned char *pbyCxtBuf);
 
-- 
2.1.0

