Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:50384 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbaHTVb5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Aug 2014 17:31:57 -0400
Received: by mail-wi0-f170.google.com with SMTP id f8so7261595wiw.3
        for <linux-wireless@vger.kernel.org>; Wed, 20 Aug 2014 14:31:56 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/6] staging: vt6655: device.h dead code remove bCCK
Date: Wed, 20 Aug 2014 22:30:26 +0100
Message-Id: <1408570231-10320-1-git-send-email-tvboxspy@gmail.com> (sfid-20140820_233201_102666_CD146C36)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bCCK is always set to true, the only place it is used is in
BBvCalculateParameter which nots the value to false.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/baseband.c    | 6 ------
 drivers/staging/vt6655/device.h      | 1 -
 drivers/staging/vt6655/device_main.c | 2 --
 drivers/staging/vt6655/wmgr.c        | 1 -
 4 files changed, 10 deletions(-)

diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index c1025ff..7dd866e 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -1837,7 +1837,6 @@ BBvCalculateParameter(
 	unsigned int cbTmp;
 	bool bExtBit;
 	unsigned char byPreambleType = pDevice->byPreambleType;
-	bool bCCK = pDevice->bCCK;
 
 	cbBitCount = cbFrameLength * 8;
 	bExtBit = false;
@@ -1857,8 +1856,6 @@ BBvCalculateParameter(
 		break;
 
 	case RATE_5M:
-		if (!bCCK)
-			cbBitCount++;
 		cbUsCount = (cbBitCount * 10) / 55;
 		cbTmp = (cbUsCount * 55) / 10;
 		if (cbTmp != cbBitCount)
@@ -1870,9 +1867,6 @@ BBvCalculateParameter(
 		break;
 
 	case RATE_11M:
-
-		if (!bCCK)
-			cbBitCount++;
 		cbUsCount = cbBitCount / 11;
 		cbTmp = cbUsCount * 11;
 		if (cbTmp != cbBitCount) {
diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 1abad5d..2434a37 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -488,7 +488,6 @@ struct vnt_private {
 
 	unsigned long dwMaxReceiveLifetime;       // dot11MaxReceiveLifetime
 
-	bool bCCK;
 	bool bEncryptionEnable;
 	bool bLongHeader;
 	bool bShortSlotTime;
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 3a2fd29..1a94d4f 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -469,8 +469,6 @@ static void device_init_registers(struct vnt_private *pDevice)
 	/* Do MACbSoftwareReset in MACvInitialize */
 	MACbSoftwareReset(pDevice->PortOffset);
 
-	/* force CCK */
-	pDevice->bCCK = true;
 	pDevice->bAES = false;
 
 	/* Only used in 11g type, sync with ERP IE */
diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index c3de107..ba273c7 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -2663,7 +2663,6 @@ s_vMgrSynchBSS(
 	}
 
 	// Init the BSS informations
-	pDevice->bCCK = true;
 	pDevice->bProtectMode = false;
 	MACvDisableProtectMD(pDevice->PortOffset);
 	pDevice->bBarkerPreambleMd = false;
-- 
1.9.1

