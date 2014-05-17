Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:35415 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757036AbaEQIxO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 04:53:14 -0400
Received: by mail-wg0-f51.google.com with SMTP id x13so5788062wgg.34
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2014 01:53:12 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 16/22] staging: vt6656: Remove dead variable bCCK.
Date: Sat, 17 May 2014 09:50:33 +0100
Message-Id: <1400316639-4430-16-git-send-email-tvboxspy@gmail.com> (sfid-20140517_112148_741322_90423106)
In-Reply-To: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
References: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bCCK is always true remove all false conditions and
local variable.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 6 ------
 drivers/staging/vt6656/device.h   | 1 -
 drivers/staging/vt6656/main_usb.c | 2 --
 drivers/staging/vt6656/wmgr.c     | 1 -
 4 files changed, 10 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index b4489d6..a70b278 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -737,7 +737,6 @@ void BBvCalculateParameter(struct vnt_private *pDevice, u32 cbFrameLength,
 	u32 cbTmp;
 	int bExtBit;
 	u8 byPreambleType = pDevice->byPreambleType;
-	int bCCK = pDevice->bCCK;
 
     cbBitCount = cbFrameLength * 8;
     bExtBit = false;
@@ -757,8 +756,6 @@ void BBvCalculateParameter(struct vnt_private *pDevice, u32 cbFrameLength,
         break;
 
     case RATE_5M :
-        if (bCCK == false)
-            cbBitCount ++;
         cbUsCount = (cbBitCount * 10) / 55;
         cbTmp = (cbUsCount * 55) / 10;
         if (cbTmp != cbBitCount)
@@ -770,9 +767,6 @@ void BBvCalculateParameter(struct vnt_private *pDevice, u32 cbFrameLength,
         break;
 
     case RATE_11M :
-
-        if (bCCK == false)
-            cbBitCount ++;
         cbUsCount = cbBitCount / 11;
         cbTmp = cbUsCount * 11;
         if (cbTmp != cbBitCount) {
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 7e7ac80..8248824 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -581,7 +581,6 @@ struct vnt_private {
 
 	u32 dwMaxReceiveLifetime;  /* dot11MaxReceiveLifetime */
 
-	int bCCK;
 	int bEncryptionEnable;
 	int bShortSlotTime;
 	int bProtectMode;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 3832bcb..ea0c9e7 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -368,8 +368,6 @@ static int device_init_registers(struct vnt_private *pDevice)
 
 	/* do MACbSoftwareReset in MACvInitialize */
 
-	/* force CCK */
-	pDevice->bCCK = true;
 	pDevice->bProtectMode = false;
 	/* only used in 11g type, sync with ERP IE */
 	pDevice->bNonERPPresent = false;
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 64edc16..d08f290 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -2571,7 +2571,6 @@ static void s_vMgrSynchBSS(struct vnt_private *pDevice, u32 uBSSMode,
     }
 
     // Init the BSS informations
-    pDevice->bCCK = true;
     pDevice->bProtectMode = false;
     MACvDisableProtectMD(pDevice);
     pDevice->bBarkerPreambleMd = false;
-- 
1.9.1

