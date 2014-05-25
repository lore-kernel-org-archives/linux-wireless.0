Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:56800 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaEYUiZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 May 2014 16:38:25 -0400
Received: by mail-wg0-f49.google.com with SMTP id m15so7130919wgh.20
        for <linux-wireless@vger.kernel.org>; Sun, 25 May 2014 13:38:24 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/8] staging: vt6656: BBbVT3184Init fix word lenght
Date: Sun, 25 May 2014 21:36:26 +0100
Message-Id: <1401050189-3249-5-git-send-email-tvboxspy@gmail.com> (sfid-20140525_223829_581062_43966F79)
In-Reply-To: <1401050189-3249-1-git-send-email-tvboxspy@gmail.com>
References: <1401050189-3249-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct to length

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index c2b0897..309a3cb 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -886,10 +886,10 @@ void BBvSetAntennaMode(struct vnt_private *priv, u8 antenna_mode)
 int BBbVT3184Init(struct vnt_private *priv)
 {
 	int status;
-	u16 lenght;
+	u16 length;
 	u8 *addr;
 	u8 *agc;
-	u16 lenght_agc;
+	u16 length_agc;
 	u8 array[256];
 	u8 data;
 
@@ -947,10 +947,10 @@ int BBbVT3184Init(struct vnt_private *priv)
 	if ((priv->byRFType == RF_AL2230) ||
 				(priv->byRFType == RF_AL2230S)) {
 		priv->byBBRxConf = abyVT3184_AL2230[10];
-		lenght = sizeof(abyVT3184_AL2230);
+		length = sizeof(abyVT3184_AL2230);
 		addr = abyVT3184_AL2230;
 		agc = abyVT3184_AGC;
-		lenght_agc = sizeof(abyVT3184_AGC);
+		length_agc = sizeof(abyVT3184_AGC);
 
 		priv->abyBBVGA[0] = 0x1C;
 		priv->abyBBVGA[1] = 0x10;
@@ -962,10 +962,10 @@ int BBbVT3184Init(struct vnt_private *priv)
 		priv->ldBmThreshold[3] = 0;
 	} else if (priv->byRFType == RF_AIROHA7230) {
 		priv->byBBRxConf = abyVT3184_AL2230[10];
-		lenght = sizeof(abyVT3184_AL2230);
+		length = sizeof(abyVT3184_AL2230);
 		addr = abyVT3184_AL2230;
 		agc = abyVT3184_AGC;
-		lenght_agc = sizeof(abyVT3184_AGC);
+		length_agc = sizeof(abyVT3184_AGC);
 
 		addr[0xd7] = 0x06;
 
@@ -980,10 +980,10 @@ int BBbVT3184Init(struct vnt_private *priv)
 	} else if ((priv->byRFType == RF_VT3226) ||
 			(priv->byRFType == RF_VT3226D0)) {
 		priv->byBBRxConf = abyVT3184_VT3226D0[10];
-		lenght = sizeof(abyVT3184_VT3226D0);
+		length = sizeof(abyVT3184_VT3226D0);
 		addr = abyVT3184_VT3226D0;
 		agc = abyVT3184_AGC;
-		lenght_agc = sizeof(abyVT3184_AGC);
+		length_agc = sizeof(abyVT3184_AGC);
 
 		priv->abyBBVGA[0] = 0x20;
 		priv->abyBBVGA[1] = 0x10;
@@ -997,10 +997,10 @@ int BBbVT3184Init(struct vnt_private *priv)
 		MACvRegBitsOn(priv, MAC_REG_SOFTPWRCTL2, SOFTPWRCTL_RFLEOPT);
 	} else if ((priv->byRFType == RF_VT3342A0)) {
 		priv->byBBRxConf = abyVT3184_VT3226D0[10];
-		lenght = sizeof(abyVT3184_VT3226D0);
+		length = sizeof(abyVT3184_VT3226D0);
 		addr = abyVT3184_VT3226D0;
 		agc = abyVT3184_AGC;
-		lenght_agc = sizeof(abyVT3184_AGC);
+		length_agc = sizeof(abyVT3184_AGC);
 
 		priv->abyBBVGA[0] = 0x20;
 		priv->abyBBVGA[1] = 0x10;
@@ -1016,15 +1016,15 @@ int BBbVT3184Init(struct vnt_private *priv)
 		return true;
 	}
 
-	memcpy(array, addr, lenght);
+	memcpy(array, addr, length);
 
 	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE, 0,
-		MESSAGE_REQUEST_BBREG, lenght, array);
+		MESSAGE_REQUEST_BBREG, length, array);
 
-	memcpy(array, agc, lenght_agc);
+	memcpy(array, agc, length_agc);
 
 	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE, 0,
-		MESSAGE_REQUEST_BBAGC, lenght_agc, array);
+		MESSAGE_REQUEST_BBAGC, length_agc, array);
 
 	if ((priv->byRFType == RF_VT3226) ||
 		(priv->byRFType == RF_VT3342A0)) {
-- 
1.9.1

