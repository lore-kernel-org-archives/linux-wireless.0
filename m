Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:54711 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240AbaESTe1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 15:34:27 -0400
Received: by mail-we0-f170.google.com with SMTP id u57so6088350wes.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 12:34:26 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/20] staging: vt6656: BBvCalculateParameter remove camel case
Date: Mon, 19 May 2014 20:33:02 +0100
Message-Id: <1400527992-3061-10-git-send-email-tvboxspy@gmail.com> (sfid-20140519_213432_559349_BC9C75D9)
In-Reply-To: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
References: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Camel case changes
pDevice, cbFrameLength, wRate, byPacketType, cbBitCount, cbUsCount
cbTmp, bExtBit, byPreambleType

->

priv, frame_length, tx_rate, pkt_type, bit_count, count,
tmp,  ext_bit, preamble_type

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 82 +++++++++++++++++++--------------------
 drivers/staging/vt6656/baseband.h |  4 +-
 2 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 9f435c5..0bdc814 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -710,9 +710,9 @@ unsigned int BBuGetFrameTime(u8 preamble_type, u8 pkt_type,
  *
  * Parameters:
  *  In:
- *      pDevice         - Device Structure
- *      cbFrameLength   - Tx Frame Length
- *      wRate           - Tx Rate
+ *      priv         - Device Structure
+ *      frame_length   - Tx Frame Length
+ *      tx_rate           - Tx Rate
  *  Out:
  *	struct vnt_phy_field *phy
  * 			- pointer to Phy Length field
@@ -722,135 +722,135 @@ unsigned int BBuGetFrameTime(u8 preamble_type, u8 pkt_type,
  * Return Value: none
  *
  */
-void BBvCalculateParameter(struct vnt_private *pDevice, u32 cbFrameLength,
-	u16 wRate, u8 byPacketType, struct vnt_phy_field *phy)
+void BBvCalculateParameter(struct vnt_private *priv, u32 frame_length,
+	u16 tx_rate, u8 pkt_type, struct vnt_phy_field *phy)
 {
-	u32 cbBitCount;
-	u32 cbUsCount = 0;
-	u32 cbTmp;
-	int bExtBit;
-	u8 byPreambleType = pDevice->byPreambleType;
+	u32 bit_count;
+	u32 count = 0;
+	u32 tmp;
+	int ext_bit;
+	u8 preamble_type = priv->byPreambleType;
 
-	cbBitCount = cbFrameLength * 8;
-	bExtBit = false;
+	bit_count = frame_length * 8;
+	ext_bit = false;
 
-	switch (wRate) {
+	switch (tx_rate) {
 	case RATE_1M:
-		cbUsCount = cbBitCount;
+		count = bit_count;
 
 		phy->signal = 0x00;
 
 		break;
 	case RATE_2M:
-		cbUsCount = cbBitCount / 2;
+		count = bit_count / 2;
 
-		if (byPreambleType == 1)
+		if (preamble_type == 1)
 			phy->signal = 0x09;
 		else
 			phy->signal = 0x01;
 
 		break;
 	case RATE_5M:
-		cbUsCount = (cbBitCount * 10) / 55;
-		cbTmp = (cbUsCount * 55) / 10;
+		count = (bit_count * 10) / 55;
+		tmp = (count * 55) / 10;
 
-		if (cbTmp != cbBitCount)
-			cbUsCount++;
+		if (tmp != bit_count)
+			count++;
 
-		if (byPreambleType == 1)
+		if (preamble_type == 1)
 			phy->signal = 0x0a;
 		else
 			phy->signal = 0x02;
 
 		break;
 	case RATE_11M:
-		cbUsCount = cbBitCount / 11;
-		cbTmp = cbUsCount * 11;
+		count = bit_count / 11;
+		tmp = count * 11;
 
-		if (cbTmp != cbBitCount) {
-			cbUsCount++;
+		if (tmp != bit_count) {
+			count++;
 
-			if ((cbBitCount - cbTmp) <= 3)
-				bExtBit = true;
+			if ((bit_count - tmp) <= 3)
+				ext_bit = true;
 		}
 
-		if (byPreambleType == 1)
+		if (preamble_type == 1)
 			phy->signal = 0x0b;
 		else
 			phy->signal = 0x03;
 
 		break;
 	case RATE_6M:
-		if (byPacketType == PK_TYPE_11A)
+		if (pkt_type == PK_TYPE_11A)
 			phy->signal = 0x9b;
 		else
 			phy->signal = 0x8b;
 
 		break;
 	case RATE_9M:
-		if (byPacketType == PK_TYPE_11A)
+		if (pkt_type == PK_TYPE_11A)
 			phy->signal = 0x9f;
 		else
 			phy->signal = 0x8f;
 
 		break;
 	case RATE_12M:
-		if (byPacketType == PK_TYPE_11A)
+		if (pkt_type == PK_TYPE_11A)
 			phy->signal = 0x9a;
 		else
 			phy->signal = 0x8a;
 
 		break;
 	case RATE_18M:
-		if (byPacketType == PK_TYPE_11A)
+		if (pkt_type == PK_TYPE_11A)
 			phy->signal = 0x9e;
 		else
 			phy->signal = 0x8e;
 
 		break;
 	case RATE_24M:
-		if (byPacketType == PK_TYPE_11A)
+		if (pkt_type == PK_TYPE_11A)
 			phy->signal = 0x99;
 		else
 			phy->signal = 0x89;
 
 		break;
 	case RATE_36M:
-		if (byPacketType == PK_TYPE_11A)
+		if (pkt_type == PK_TYPE_11A)
 			phy->signal = 0x9d;
 		else
 			phy->signal = 0x8d;
 
 		break;
 	case RATE_48M:
-		if (byPacketType == PK_TYPE_11A)
+		if (pkt_type == PK_TYPE_11A)
 			phy->signal = 0x98;
 		else
 			phy->signal = 0x88;
 
 		break;
 	case RATE_54M:
-		if (byPacketType == PK_TYPE_11A)
+		if (pkt_type == PK_TYPE_11A)
 			phy->signal = 0x9c;
 		else
 			phy->signal = 0x8c;
 		break;
 	default:
-		if (byPacketType == PK_TYPE_11A)
+		if (pkt_type == PK_TYPE_11A)
 			phy->signal = 0x9c;
 		else
 			phy->signal = 0x8c;
 		break;
 	}
 
-	if (byPacketType == PK_TYPE_11B) {
+	if (pkt_type == PK_TYPE_11B) {
 		phy->service = 0x00;
-		if (bExtBit)
+		if (ext_bit)
 			phy->service |= 0x80;
-		phy->len = cpu_to_le16((u16)cbUsCount);
+		phy->len = cpu_to_le16((u16)count);
 	} else {
 		phy->service = 0x00;
-		phy->len = cpu_to_le16((u16)cbFrameLength);
+		phy->len = cpu_to_le16((u16)frame_length);
 	}
 }
 
diff --git a/drivers/staging/vt6656/baseband.h b/drivers/staging/vt6656/baseband.h
index da5520c..005b94c 100644
--- a/drivers/staging/vt6656/baseband.h
+++ b/drivers/staging/vt6656/baseband.h
@@ -91,8 +91,8 @@ struct vnt_phy_field {
 unsigned int BBuGetFrameTime(u8 preamble_type, u8 pkt_type,
 	unsigned int frame_length, u16 tx_rate);
 
-void BBvCalculateParameter(struct vnt_private *, u32 cbFrameLength,
-	u16 wRate, u8 byPacketType, struct vnt_phy_field *);
+void BBvCalculateParameter(struct vnt_private *, u32 frame_length,
+	u16 tx_rate, u8 pkt_type, struct vnt_phy_field *);
 
 /* timer for antenna diversity */
 
-- 
1.9.1

