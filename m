Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:57042 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296AbaEQIxK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 04:53:10 -0400
Received: by mail-wg0-f48.google.com with SMTP id b13so5952122wgh.19
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2014 01:53:09 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 14/22] staging: vt6656: Remove unused variable byRevId.
Date: Sat, 17 May 2014 09:50:31 +0100
Message-Id: <1400316639-4430-14-git-send-email-tvboxspy@gmail.com> (sfid-20140517_105317_464498_3E212FE6)
In-Reply-To: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
References: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 2 --
 drivers/staging/vt6656/main_usb.c | 7 +------
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 59d3828..aefbe93 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -409,8 +409,6 @@ struct vnt_private {
 
 	u32 rx_bytes;
 
-	u8 byRevId;
-
 	u32 flags;
 	unsigned long Flags;
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 1b58cca..68ae97c 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -387,7 +387,7 @@ static int device_init_registers(struct vnt_private *pDevice)
 
 	pDevice->byTopOFDMBasicRate = RATE_24M;
 	pDevice->byTopCCKBasicRate = RATE_1M;
-	pDevice->byRevId = 0;
+
 	/* target to IF pin while programming to RF chip */
 	pDevice->byCurPwr = 0xFF;
 
@@ -508,11 +508,6 @@ static int device_init_registers(struct vnt_private *pDevice)
 	/* get RFType */
 	pDevice->byRFType = init_rsp->rf_type;
 
-	if ((pDevice->byRFType & RF_EMU) != 0) {
-		/* force change RevID for VT3253 emu */
-		pDevice->byRevId = 0x80;
-	}
-
 	/* load vt3266 calibration parameters in EEPROM */
 	if (pDevice->byRFType == RF_VT3226D0) {
 		if ((pDevice->abyEEPROM[EEP_OFS_MAJOR_VER] == 0x1) &&
-- 
1.9.1

