Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:48568 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbaJYUEc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 16:04:32 -0400
Received: by mail-wg0-f42.google.com with SMTP id k14so1182740wgh.1
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 13:04:31 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 31/48] staging: vt6655: dead code remove vntwifi.h
Date: Sat, 25 Oct 2014 09:40:09 +0100
Message-Id: <1414226426-5811-32-git-send-email-tvboxspy@gmail.com> (sfid-20141025_220435_374188_FE23BE74)
In-Reply-To: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
References: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h      |  1 -
 drivers/staging/vt6655/device_main.c |  2 -
 drivers/staging/vt6655/vntwifi.h     | 90 ------------------------------------
 drivers/staging/vt6655/wmgr.h        |  5 --
 4 files changed, 98 deletions(-)
 delete mode 100644 drivers/staging/vt6655/vntwifi.h

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index e97a0d2..9e5fde8 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -511,7 +511,6 @@ struct vnt_private {
 	bool bEnablePSMode;
 	unsigned short wListenInterval;
 	bool bPWBitOn;
-	WMAC_POWER_MODE         ePSMode;
 
 	// GPIO Radio Control
 	unsigned char byRadioCtl;
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 27d8ce1..6a13e51 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -344,7 +344,6 @@ device_set_options(struct vnt_private *pDevice)
 	pDevice->wMaxTransmitMSDULifetime = DEFAULT_MSDU_LIFETIME;
 	pDevice->byShortPreamble = (pDevice->sOpts.flags & DEVICE_FLAGS_PREAMBLE_TYPE) ? 1 : 0;
 	pDevice->byOpMode = (pDevice->sOpts.flags & DEVICE_FLAGS_OP_MODE) ? 1 : 0;
-	pDevice->ePSMode = (pDevice->sOpts.flags & DEVICE_FLAGS_PS_MODE) ? 1 : 0;
 	pDevice->b11hEnable = (pDevice->sOpts.flags & DEVICE_FLAGS_80211h_MODE) ? 1 : 0;
 	pDevice->bDiversityRegCtlON = (pDevice->sOpts.flags & DEVICE_FLAGS_DiversityANT) ? 1 : 0;
 	pDevice->uConnectionRate = pDevice->sOpts.data_rate;
@@ -359,7 +358,6 @@ device_set_options(struct vnt_private *pDevice)
 
 	pr_debug(" uChannel= %d\n", (int)pDevice->uChannel);
 	pr_debug(" byOpMode= %d\n", (int)pDevice->byOpMode);
-	pr_debug(" ePSMode= %d\n", (int)pDevice->ePSMode);
 	pr_debug(" wRTSThreshold= %d\n", (int)pDevice->wRTSThreshold);
 	pr_debug(" byShortRetryLimit= %d\n", (int)pDevice->byShortRetryLimit);
 	pr_debug(" byLongRetryLimit= %d\n", (int)pDevice->byLongRetryLimit);
diff --git a/drivers/staging/vt6655/vntwifi.h b/drivers/staging/vt6655/vntwifi.h
deleted file mode 100644
index 2ba7713..0000000
--- a/drivers/staging/vt6655/vntwifi.h
+++ /dev/null
@@ -1,90 +0,0 @@
-/*
- * Copyright (c) 1996, 2003 VIA Networking Technologies, Inc.
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
- *
- *
- * File: vntwifi.h
- *
- * Purpose: export VNT Host WiFi library function
- *
- * Author: Yiching Chen
- *
- * Date: Jan 7, 2004
- *
- */
-
-#ifndef __VNTWIFI_H__
-#define __VNTWIFI_H__
-
-#include "ttype.h"
-#include "80211mgr.h"
-#include "card.h"
-
-/*---------------------  Export Definitions -------------------------*/
-
-// key CipherSuite
-#define KEY_CTL_WEP         0x00
-#define KEY_CTL_NONE        0x01
-#define KEY_CTL_TKIP        0x02
-#define KEY_CTL_CCMP        0x03
-#define KEY_CTL_INVALID     0xFF
-
-#define CHANNEL_MAX_24G         14
-
-#define MAX_BSS_NUM             42
-
-// Pre-configured Authenticaiton Mode (from XP)
-typedef enum tagWMAC_AUTHENTICATION_MODE {
-	WMAC_AUTH_OPEN,
-	WMAC_AUTH_SHAREKEY,
-	WMAC_AUTH_AUTO,
-	WMAC_AUTH_WPA,
-	WMAC_AUTH_WPAPSK,
-	WMAC_AUTH_WPANONE,
-	WMAC_AUTH_WPA2,
-	WMAC_AUTH_WPA2PSK,
-	WMAC_AUTH_MAX       // Not a real mode, defined as upper bound
-} WMAC_AUTHENTICATION_MODE, *PWMAC_AUTHENTICATION_MODE;
-
-typedef enum tagWMAC_ENCRYPTION_MODE {
-	WMAC_ENCRYPTION_WEPEnabled,
-	WMAC_ENCRYPTION_WEPDisabled,
-	WMAC_ENCRYPTION_WEPKeyAbsent,
-	WMAC_ENCRYPTION_WEPNotSupported,
-	WMAC_ENCRYPTION_TKIPEnabled,
-	WMAC_ENCRYPTION_TKIPKeyAbsent,
-	WMAC_ENCRYPTION_AESEnabled,
-	WMAC_ENCRYPTION_AESKeyAbsent
-} WMAC_ENCRYPTION_MODE, *PWMAC_ENCRYPTION_MODE;
-
-// Pre-configured Mode (from XP)
-
-typedef enum tagWMAC_CONFIG_MODE {
-	WMAC_CONFIG_ESS_STA = 0,
-	WMAC_CONFIG_IBSS_STA,
-	WMAC_CONFIG_AUTO,
-	WMAC_CONFIG_AP
-} WMAC_CONFIG_MODE, *PWMAC_CONFIG_MODE;
-
-typedef enum tagWMAC_POWER_MODE {
-	WMAC_POWER_CAM,
-	WMAC_POWER_FAST,
-	WMAC_POWER_MAX
-} WMAC_POWER_MODE, *PWMAC_POWER_MODE;
-
-
-#endif //__VNTWIFI_H__
diff --git a/drivers/staging/vt6655/wmgr.h b/drivers/staging/vt6655/wmgr.h
index 7df62bb..ecbb8d4 100644
--- a/drivers/staging/vt6655/wmgr.h
+++ b/drivers/staging/vt6655/wmgr.h
@@ -39,7 +39,6 @@
 #include "80211hdr.h"
 #include "wcmd.h"
 #include "bssdb.h"
-#include "vntwifi.h"
 #include "card.h"
 
 /*---------------------  Export Definitions -------------------------*/
@@ -189,7 +188,6 @@ typedef struct tagSMgmtObject {
 	unsigned char abyMACAddr[WLAN_ADDR_LEN];
 
 	// Configuration Mode
-	WMAC_CONFIG_MODE        eConfigMode; // MAC pre-configed mode
 	CARD_PHY_TYPE           eCurrentPHYMode;
 	CARD_PHY_TYPE           eConfigPHYMode;
 
@@ -245,8 +243,6 @@ typedef struct tagSMgmtObject {
 	unsigned char abyScanBSSID[WLAN_BSSID_LEN];
 
 	// Privacy
-	WMAC_AUTHENTICATION_MODE eAuthenMode;
-	WMAC_ENCRYPTION_MODE    eEncryptionMode;
 	bool bShareKeyAlgorithm;
 	unsigned char abyChallenge[WLAN_CHALLENGE_LEN];
 	bool bPrivacyInvoked;
@@ -258,7 +254,6 @@ typedef struct tagSMgmtObject {
 	unsigned char byDTIMPeriod;
 
 	// Power saving state vars
-	WMAC_POWER_MODE         ePSMode;
 	unsigned short wListenInterval;
 	unsigned short wCountToWakeUp;
 	bool bInTIMWake;
-- 
1.9.1

