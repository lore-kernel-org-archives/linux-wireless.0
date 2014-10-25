Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:41795 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaJYTRh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:17:37 -0400
Received: by mail-wi0-f175.google.com with SMTP id h11so1511294wiw.8
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:17:36 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 34/48] staging: vt6655: dead remove wcmd.h and typedefs
Date: Sat, 25 Oct 2014 09:40:12 +0100
Message-Id: <1414226426-5811-35-git-send-email-tvboxspy@gmail.com> (sfid-20141025_211744_543941_8F461A99)
In-Reply-To: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
References: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CMD_STATE
CMD_CODE
CMD_ITEM

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h      |  5 --
 drivers/staging/vt6655/device_main.c |  1 -
 drivers/staging/vt6655/power.c       |  1 -
 drivers/staging/vt6655/rxtx.h        |  1 -
 drivers/staging/vt6655/wcmd.h        | 91 ------------------------------------
 drivers/staging/vt6655/wmgr.h        |  1 -
 6 files changed, 100 deletions(-)
 delete mode 100644 drivers/staging/vt6655/wcmd.h

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 9db279b..8790622 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -75,7 +75,6 @@
 #include "80211hdr.h"
 #include "tether.h"
 #include "wmgr.h"
-#include "wcmd.h"
 #include "mib.h"
 #include "srom.h"
 #include "desc.h"
@@ -500,9 +499,6 @@ struct vnt_private {
 	unsigned char byCurrentCh;
 	unsigned int	uScanTime;
 
-	CMD_STATE               eCommandState;
-
-	CMD_CODE                eCommand;
 	bool bBeaconTx;
 
 	bool bStopBeacon;
@@ -512,7 +508,6 @@ struct vnt_private {
 
 	// 802.11 counter
 
-	CMD_ITEM                eCmdQueue[CMD_Q_SIZE];
 	unsigned int	uCmdDequeueIdx;
 	unsigned int	uCmdEnqueueIdx;
 	unsigned int	cbFreeCmdQueue;
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 6a13e51..f502441 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -61,7 +61,6 @@
 #include "tether.h"
 #include "wmgr.h"
 #include "power.h"
-#include "wcmd.h"
 #include "iocmd.h"
 #include "rxtx.h"
 #include "bssdb.h"
diff --git a/drivers/staging/vt6655/power.c b/drivers/staging/vt6655/power.c
index 040484e..6f83650 100644
--- a/drivers/staging/vt6655/power.c
+++ b/drivers/staging/vt6655/power.c
@@ -42,7 +42,6 @@
 #include "device.h"
 #include "wmgr.h"
 #include "power.h"
-#include "wcmd.h"
 #include "card.h"
 
 /*---------------------  Static Definitions -------------------------*/
diff --git a/drivers/staging/vt6655/rxtx.h b/drivers/staging/vt6655/rxtx.h
index 7b0566c..50d77a0 100644
--- a/drivers/staging/vt6655/rxtx.h
+++ b/drivers/staging/vt6655/rxtx.h
@@ -31,7 +31,6 @@
 
 #include "ttype.h"
 #include "device.h"
-#include "wcmd.h"
 
 /*---------------------  Export Definitions -------------------------*/
 
diff --git a/drivers/staging/vt6655/wcmd.h b/drivers/staging/vt6655/wcmd.h
deleted file mode 100644
index ae7ddea..0000000
--- a/drivers/staging/vt6655/wcmd.h
+++ /dev/null
@@ -1,91 +0,0 @@
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
- * File: wcmd.h
- *
- * Purpose: Handles the management command interface functions
- *
- * Author: Lyndon Chen
- *
- * Date: May 8, 2002
- *
- */
-
-#ifndef __WCMD_H__
-#define __WCMD_H__
-
-#include "ttype.h"
-#include "80211hdr.h"
-#include "80211mgr.h"
-
-#define AUTHENTICATE_TIMEOUT   1000
-#define ASSOCIATE_TIMEOUT      1000
-
-typedef enum tagCMD_CODE {
-	WLAN_CMD_BSSID_SCAN,
-	WLAN_CMD_SSID,
-	WLAN_CMD_DISASSOCIATE,
-	WLAN_CMD_DEAUTH,
-	WLAN_CMD_RX_PSPOLL,
-	WLAN_CMD_RADIO,
-	WLAN_CMD_CHANGE_BBSENSITIVITY,
-	WLAN_CMD_SETPOWER,
-	WLAN_CMD_TBTT_WAKEUP,
-	WLAN_CMD_BECON_SEND,
-	WLAN_CMD_CHANGE_ANTENNA,
-	WLAN_CMD_REMOVE_ALLKEY,
-	WLAN_CMD_MAC_DISPOWERSAVING,
-	WLAN_CMD_11H_CHSW,
-	WLAN_CMD_RUN_AP
-} CMD_CODE, *PCMD_CODE;
-
-#define CMD_Q_SIZE              32
-
-typedef enum tagCMD_STATUS {
-	CMD_STATUS_SUCCESS = 0,
-	CMD_STATUS_FAILURE,
-	CMD_STATUS_RESOURCES,
-	CMD_STATUS_TIMEOUT,
-	CMD_STATUS_PENDING
-} CMD_STATUS, *PCMD_STATUS;
-
-typedef struct tagCMD_ITEM {
-	CMD_CODE eCmd;
-	unsigned char abyCmdDesireSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
-	bool bNeedRadioOFF;
-	unsigned short wDeAuthenReason;
-	bool bRadioCmd;
-	bool bForceSCAN;
-} CMD_ITEM, *PCMD_ITEM;
-
-typedef enum tagCMD_STATE {
-	WLAN_CMD_SCAN_START,
-	WLAN_CMD_SCAN_END,
-	WLAN_CMD_DISASSOCIATE_START,
-	WLAN_CMD_SSID_START,
-	WLAN_AUTHENTICATE_WAIT,
-	WLAN_ASSOCIATE_WAIT,
-	WLAN_DISASSOCIATE_WAIT,
-	WLAN_CMD_TX_PSPACKET_START,
-	WLAN_CMD_AP_MODE_START,
-	WLAN_CMD_RADIO_START,
-	WLAN_CMD_CHECK_BBSENSITIVITY_CHANGE,
-	WLAN_CMD_IDLE
-} CMD_STATE, *PCMD_STATE;
-
-#endif //__WCMD_H__
diff --git a/drivers/staging/vt6655/wmgr.h b/drivers/staging/vt6655/wmgr.h
index cc8662e..0e6a6f0 100644
--- a/drivers/staging/vt6655/wmgr.h
+++ b/drivers/staging/vt6655/wmgr.h
@@ -37,7 +37,6 @@
 #include "ttype.h"
 #include "80211mgr.h"
 #include "80211hdr.h"
-#include "wcmd.h"
 #include "bssdb.h"
 #include "card.h"
 
-- 
1.9.1

