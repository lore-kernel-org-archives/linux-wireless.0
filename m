Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:43484 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaEYUiX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 May 2014 16:38:23 -0400
Received: by mail-wg0-f50.google.com with SMTP id x12so7039214wgg.21
        for <linux-wireless@vger.kernel.org>; Sun, 25 May 2014 13:38:22 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/8] staging: vt6656: baseband.c replace DBG_PRT debug messages
Date: Sun, 25 May 2014 21:36:25 +0100
Message-Id: <1401050189-3249-4-git-send-email-tvboxspy@gmail.com> (sfid-20140525_223828_639709_41BF38D3)
In-Reply-To: <1401050189-3249-1-git-send-email-tvboxspy@gmail.com>
References: <1401050189-3249-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with dev_dbg

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 3a06bf4..c2b0897 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -43,9 +43,6 @@
 #include "control.h"
 #include "datarate.h"
 
-static int          msglevel                =MSG_LEVEL_INFO;
-//static int          msglevel                =MSG_LEVEL_DEBUG;
-
 static u8 abyVT3184_AGC[] = {
     0x00,   //0
     0x00,   //1
@@ -910,20 +907,20 @@ int BBbVT3184Init(struct vnt_private *priv)
 			(priv->abyEEPROM[EEP_OFS_ZONETYPE] != 0x00)) {
 			priv->abyEEPROM[EEP_OFS_ZONETYPE] = 0;
 			priv->abyEEPROM[EEP_OFS_MAXCHANNEL] = 0x0B;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-						"Init Zone Type :USA\n");
+
+			dev_dbg(&priv->usb->dev, "Init Zone Type :USA\n");
 		} else if ((priv->config_file.ZoneType == 1) &&
 			(priv->abyEEPROM[EEP_OFS_ZONETYPE] != 0x01)) {
 			priv->abyEEPROM[EEP_OFS_ZONETYPE] = 0x01;
 			priv->abyEEPROM[EEP_OFS_MAXCHANNEL] = 0x0D;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-						"Init Zone Type :Japan\n");
+
+			dev_dbg(&priv->usb->dev, "Init Zone Type :Japan\n");
 		} else if ((priv->config_file.ZoneType == 2) &&
 			(priv->abyEEPROM[EEP_OFS_ZONETYPE] != 0x02)) {
 			priv->abyEEPROM[EEP_OFS_ZONETYPE] = 0x02;
 			priv->abyEEPROM[EEP_OFS_MAXCHANNEL] = 0x0D;
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-						"Init Zone Type :Europe\n");
+
+			dev_dbg(&priv->usb->dev, "Init Zone Type :Europe\n");
 		} else {
 			if (priv->config_file.ZoneType !=
 					priv->abyEEPROM[EEP_OFS_ZONETYPE])
@@ -943,10 +940,9 @@ int BBbVT3184Init(struct vnt_private *priv)
 
 	priv->byRFType = priv->abyEEPROM[EEP_OFS_RFTYPE];
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Zone Type %x\n",
-							priv->byZoneType);
+	dev_dbg(&priv->usb->dev, "Zone Type %x\n", priv->byZoneType);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"RF Type %d\n", priv->byRFType);
+	dev_dbg(&priv->usb->dev, "RF Type %d\n", priv->byRFType);
 
 	if ((priv->byRFType == RF_AL2230) ||
 				(priv->byRFType == RF_AL2230S)) {
-- 
1.9.1

