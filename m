Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:63754 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbaHTVcG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Aug 2014 17:32:06 -0400
Received: by mail-wi0-f176.google.com with SMTP id bs8so7774791wib.3
        for <linux-wireless@vger.kernel.org>; Wed, 20 Aug 2014 14:32:04 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 6/6] staging: vt6655: Remove BBvCalculateParameter and its data members
Date: Wed, 20 Aug 2014 22:30:31 +0100
Message-Id: <1408570231-10320-6-git-send-email-tvboxspy@gmail.com> (sfid-20140820_233214_500107_885DB4FC)
In-Reply-To: <1408570231-10320-1-git-send-email-tvboxspy@gmail.com>
References: <1408570231-10320-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove data members bySignalField*, byServiceField*, wTransmitLength*
from structures in desc.h

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/baseband.c | 143 --------------------------------------
 drivers/staging/vt6655/baseband.h |  11 ---
 drivers/staging/vt6655/desc.h     |  42 -----------
 3 files changed, 196 deletions(-)

diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index 5842206..40710bb 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -1954,149 +1954,6 @@ void vnt_get_phy_field(struct vnt_private *priv, u32 frame_length,
 	}
 }
 
-void
-BBvCalculateParameter(
-	struct vnt_private *pDevice,
-	unsigned int cbFrameLength,
-	unsigned short wRate,
-	unsigned char byPacketType,
-	unsigned short *pwPhyLen,
-	unsigned char *pbyPhySrv,
-	unsigned char *pbyPhySgn
-)
-{
-	unsigned int cbBitCount;
-	unsigned int cbUsCount = 0;
-	unsigned int cbTmp;
-	bool bExtBit;
-	unsigned char byPreambleType = pDevice->byPreambleType;
-
-	cbBitCount = cbFrameLength * 8;
-	bExtBit = false;
-
-	switch (wRate) {
-	case RATE_1M:
-		cbUsCount = cbBitCount;
-		*pbyPhySgn = 0x00;
-		break;
-
-	case RATE_2M:
-		cbUsCount = cbBitCount / 2;
-		if (byPreambleType == 1)
-			*pbyPhySgn = 0x09;
-		else /* long preamble */
-			*pbyPhySgn = 0x01;
-		break;
-
-	case RATE_5M:
-		cbUsCount = (cbBitCount * 10) / 55;
-		cbTmp = (cbUsCount * 55) / 10;
-		if (cbTmp != cbBitCount)
-			cbUsCount++;
-		if (byPreambleType == 1)
-			*pbyPhySgn = 0x0a;
-		else /* long preamble */
-			*pbyPhySgn = 0x02;
-		break;
-
-	case RATE_11M:
-		cbUsCount = cbBitCount / 11;
-		cbTmp = cbUsCount * 11;
-		if (cbTmp != cbBitCount) {
-			cbUsCount++;
-			if ((cbBitCount - cbTmp) <= 3)
-				bExtBit = true;
-		}
-		if (byPreambleType == 1)
-			*pbyPhySgn = 0x0b;
-		else /* long preamble */
-			*pbyPhySgn = 0x03;
-		break;
-
-	case RATE_6M:
-		if (byPacketType == PK_TYPE_11A) { /*11a, 5GHZ */
-			*pbyPhySgn = 0x9B; /* 1001 1011 */
-		} else {/* 11g, 2.4GHZ */
-			*pbyPhySgn = 0x8B; /* 1000 1011 */
-		}
-		break;
-
-	case RATE_9M:
-		if (byPacketType == PK_TYPE_11A) {/* 11a, 5GHZ */
-			*pbyPhySgn = 0x9F; /* 1001 1111 */
-		} else {/* 11g, 2.4GHZ */
-			*pbyPhySgn = 0x8F; /* 1000 1111 */
-		}
-		break;
-
-	case RATE_12M:
-		if (byPacketType == PK_TYPE_11A) {/* 11a, 5GHZ */
-			*pbyPhySgn = 0x9A; /* 1001 1010 */
-		} else {/* 11g, 2.4GHZ */
-			*pbyPhySgn = 0x8A; /* 1000 1010 */
-		}
-		break;
-
-	case RATE_18M:
-		if (byPacketType == PK_TYPE_11A) {/* 11a, 5GHZ */
-			*pbyPhySgn = 0x9E; /* 1001 1110 */
-		} else {/* 11g, 2.4GHZ */
-			*pbyPhySgn = 0x8E; /* 1000 1110 */
-		}
-		break;
-
-	case RATE_24M:
-		if (byPacketType == PK_TYPE_11A) {/* 11a, 5GHZ */
-			*pbyPhySgn = 0x99; /* 1001 1001 */
-		} else {/* 11g, 2.4GHZ */
-			*pbyPhySgn = 0x89; /* 1000 1001 */
-		}
-		break;
-
-	case RATE_36M:
-		if (byPacketType == PK_TYPE_11A) {/* 11a, 5GHZ */
-			*pbyPhySgn = 0x9D; /* 1001 1101 */
-		} else {/* 11g, 2.4GHZ */
-			*pbyPhySgn = 0x8D; /* 1000 1101 */
-		}
-		break;
-
-	case RATE_48M:
-		if (byPacketType == PK_TYPE_11A) {/* 11a, 5GHZ */
-			*pbyPhySgn = 0x98; /* 1001 1000 */
-		} else {/* 11g, 2.4GHZ */
-			*pbyPhySgn = 0x88; /* 1000 1000 */
-		}
-		break;
-
-	case RATE_54M:
-		if (byPacketType == PK_TYPE_11A) {/* 11a, 5GHZ */
-			*pbyPhySgn = 0x9C; /* 1001 1100 */
-		} else {/* 11g, 2.4GHZ */
-			*pbyPhySgn = 0x8C; /* 1000 1100 */
-		}
-		break;
-
-	default:
-		if (byPacketType == PK_TYPE_11A) {/* 11a, 5GHZ */
-			*pbyPhySgn = 0x9C; /* 1001 1100 */
-		} else {/* 11g, 2.4GHZ */
-			*pbyPhySgn = 0x8C; /* 1000 1100 */
-		}
-		break;
-	}
-
-	if (byPacketType == PK_TYPE_11B) {
-		*pbyPhySrv = 0x00;
-		if (bExtBit)
-			*pbyPhySrv = *pbyPhySrv | 0x80;
-		*pwPhyLen = (unsigned short)cbUsCount;
-	} else {
-		*pbyPhySrv = 0x00;
-		*pwPhyLen = (unsigned short)cbFrameLength;
-	}
-}
-
 /*
  * Description: Read a byte from BASEBAND, by embedded programming
  *
diff --git a/drivers/staging/vt6655/baseband.h b/drivers/staging/vt6655/baseband.h
index 049e6b4..78620d3 100644
--- a/drivers/staging/vt6655/baseband.h
+++ b/drivers/staging/vt6655/baseband.h
@@ -76,17 +76,6 @@ BBuGetFrameTime(
 	unsigned short wRate
 );
 
-void
-BBvCalculateParameter(
-	struct vnt_private *pDevice,
-	unsigned int cbFrameLength,
-	unsigned short wRate,
-	unsigned char byPacketType,
-	unsigned short *pwPhyLen,
-	unsigned char *pbyPhySrv,
-	unsigned char *pbyPhySgn
-);
-
 void vnt_get_phy_field(struct vnt_private *, u32 frame_length,
 		       u16 tx_rate, u8 pkt_type, struct vnt_phy_field *);
 
diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 1842723..10bd564 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -393,12 +393,6 @@ union vnt_phy_field_swap {
 typedef struct tagSRTS_g {
 	struct vnt_phy_field b;
 	struct vnt_phy_field a;
-	unsigned char bySignalField_b;
-	unsigned char byServiceField_b;
-	unsigned short wTransmitLength_b;
-	unsigned char bySignalField_a;
-	unsigned char byServiceField_a;
-	unsigned short wTransmitLength_a;
 	unsigned short wDuration_ba;
 	unsigned short wDuration_aa;
 	unsigned short wDuration_bb;
@@ -411,12 +405,6 @@ typedef const SRTS_g *PCSRTS_g;
 typedef struct tagSRTS_g_FB {
 	struct vnt_phy_field b;
 	struct vnt_phy_field a;
-	unsigned char bySignalField_b;
-	unsigned char byServiceField_b;
-	unsigned short wTransmitLength_b;
-	unsigned char bySignalField_a;
-	unsigned char byServiceField_a;
-	unsigned short wTransmitLength_a;
 	unsigned short wDuration_ba;
 	unsigned short wDuration_aa;
 	unsigned short wDuration_bb;
@@ -432,9 +420,6 @@ typedef const SRTS_g_FB *PCSRTS_g_FB;
 
 typedef struct tagSRTS_ab {
 	struct vnt_phy_field ab;
-	unsigned char bySignalField;
-	unsigned char byServiceField;
-	unsigned short wTransmitLength;
 	unsigned short wDuration;
 	unsigned short wReserved;
 	SRTSData    Data;
@@ -444,9 +429,6 @@ typedef const SRTS_ab *PCSRTS_ab;
 
 typedef struct tagSRTS_a_FB {
 	struct vnt_phy_field a;
-	unsigned char bySignalField;
-	unsigned char byServiceField;
-	unsigned short wTransmitLength;
 	unsigned short wDuration;
 	unsigned short wReserved;
 	unsigned short wRTSDuration_f0;
@@ -469,9 +451,6 @@ SCTSData, *PSCTSData;
 
 typedef struct tagSCTS {
 	struct vnt_phy_field b;
-	unsigned char bySignalField_b;
-	unsigned char byServiceField_b;
-	unsigned short wTransmitLength_b;
 	unsigned short wDuration_ba;
 	unsigned short wReserved;
 	SCTSData    Data;
@@ -481,9 +460,6 @@ typedef const SCTS *PCSCTS;
 
 typedef struct tagSCTS_FB {
 	struct vnt_phy_field b;
-	unsigned char bySignalField_b;
-	unsigned char byServiceField_b;
-	unsigned short wTransmitLength_b;
 	unsigned short wDuration_ba;
 	unsigned short wReserved;
 	unsigned short wCTSDuration_ba_f0;
@@ -520,12 +496,6 @@ typedef const STxShortBufHead *PCSTxShortBufHead;
 typedef struct tagSTxDataHead_g {
 	struct vnt_phy_field b;
 	struct vnt_phy_field a;
-	unsigned char bySignalField_b;
-	unsigned char byServiceField_b;
-	unsigned short wTransmitLength_b;
-	unsigned char bySignalField_a;
-	unsigned char byServiceField_a;
-	unsigned short wTransmitLength_a;
 	unsigned short wDuration_b;
 	unsigned short wDuration_a;
 	unsigned short wTimeStampOff_b;
@@ -537,12 +507,6 @@ typedef const STxDataHead_g *PCSTxDataHead_g;
 typedef struct tagSTxDataHead_g_FB {
 	struct vnt_phy_field b;
 	struct vnt_phy_field a;
-	unsigned char bySignalField_b;
-	unsigned char byServiceField_b;
-	unsigned short wTransmitLength_b;
-	unsigned char bySignalField_a;
-	unsigned char byServiceField_a;
-	unsigned short wTransmitLength_a;
 	unsigned short wDuration_b;
 	unsigned short wDuration_a;
 	unsigned short wDuration_a_f0;
@@ -555,9 +519,6 @@ typedef const STxDataHead_g_FB *PCSTxDataHead_g_FB;
 
 typedef struct tagSTxDataHead_ab {
 	struct vnt_phy_field ab;
-	unsigned char bySignalField;
-	unsigned char byServiceField;
-	unsigned short wTransmitLength;
 	unsigned short wDuration;
 	unsigned short wTimeStampOff;
 } __attribute__ ((__packed__))
@@ -566,9 +527,6 @@ typedef const STxDataHead_ab *PCSTxDataHead_ab;
 
 typedef struct tagSTxDataHead_a_FB {
 	struct vnt_phy_field a;
-	unsigned char bySignalField;
-	unsigned char byServiceField;
-	unsigned short wTransmitLength;
 	unsigned short wDuration;
 	unsigned short wTimeStampOff;
 	unsigned short wDuration_f0;
-- 
1.9.1

