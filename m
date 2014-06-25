Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:40466 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087AbaFYUVp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:21:45 -0400
Received: by mail-wi0-f175.google.com with SMTP id r20so8695958wiv.14
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:21:44 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 24/34] staging: vt6656: dead codead remove bssdb.h header
Date: Wed, 25 Jun 2014 21:20:01 +0100
Message-Id: <1403727611-6825-25-git-send-email-tvboxspy@gmail.com> (sfid-20140625_223006_113739_ECBE3234)
In-Reply-To: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
References: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/bssdb.h    | 211 --------------------------------------
 drivers/staging/vt6656/dpc.c      |   1 -
 drivers/staging/vt6656/int.c      |   1 -
 drivers/staging/vt6656/main_usb.c |   1 -
 drivers/staging/vt6656/rxtx.c     |   1 -
 drivers/staging/vt6656/wmgr.h     |   7 --
 6 files changed, 222 deletions(-)
 delete mode 100644 drivers/staging/vt6656/bssdb.h

diff --git a/drivers/staging/vt6656/bssdb.h b/drivers/staging/vt6656/bssdb.h
deleted file mode 100644
index 6cfa8af..0000000
--- a/drivers/staging/vt6656/bssdb.h
+++ /dev/null
@@ -1,211 +0,0 @@
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
- * File: bssdb.h
- *
- * Purpose: Handles the Basic Service Set & Node Database functions
- *
- * Author: Lyndon Chen
- *
- * Date: July 16, 2002
- *
- */
-
-#ifndef __BSSDB_H__
-#define __BSSDB_H__
-
-#include <linux/skbuff.h>
-#include "80211hdr.h"
-#include "card.h"
-
-#define MAX_NODE_NUM             64
-#define MAX_BSS_NUM              42
-#define LOST_BEACON_COUNT        10   /* 10 sec, XP defined */
-#define MAX_PS_TX_BUF            32   // sta max power saving tx buf
-#define ADHOC_LOST_BEACON_COUNT  30   // 30 sec, beacon lost for adhoc only
-#define MAX_INACTIVE_COUNT       300  // 300 sec, inactive STA node refresh
-
-#define USE_PROTECT_PERIOD       10   // 10 sec, Use protect mode check period
-#define ERP_RECOVER_COUNT        30   // 30 sec, ERP support callback check
-#define BSS_CLEAR_COUNT           1
-
-#define RSSI_STAT_COUNT          10
-#define MAX_CHECK_RSSI_COUNT     8
-
-// STA dwflags
-#define WLAN_STA_AUTH            BIT0
-#define WLAN_STA_ASSOC           BIT1
-#define WLAN_STA_PS              BIT2
-#define WLAN_STA_TIM             BIT3
-// permanent; do not remove entry on expiration
-#define WLAN_STA_PERM            BIT4
-// If 802.1X is used, this flag is
-// controlling whether STA is authorized to
-// send and receive non-IEEE 802.1X frames
-#define WLAN_STA_AUTHORIZED      BIT5
-
-#define MAX_WPA_IE_LEN      64
-
-//
-// IEEE 802.11 Structures and definitions
-//
-
-typedef struct tagSERPObject {
-    bool    bERPExist;
-    u8    byERP;
-} ERPObject, *PERPObject;
-
-typedef struct tagSRSNCapObject {
-    bool    bRSNCapExist;
-    u16    wRSNCap;
-} SRSNCapObject, *PSRSNCapObject;
-
-// BSS info(AP)
-typedef struct tagKnownBSS {
-    // BSS info
-    bool            bActive;
-    u8            abyBSSID[WLAN_BSSID_LEN];
-    unsigned int            uChannel;
-    u8            abySuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1];
-    u8            abyExtSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1];
-    unsigned int            uRSSI;
-    u8            bySQ;
-    u16            wBeaconInterval;
-    u16            wCapInfo;
-    u8            abySSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
-    u8            byRxRate;
-
-//    u16            wATIMWindow;
-    u8            byRSSIStatCnt;
-    signed long            ldBmMAX;
-    signed long            ldBmAverage[RSSI_STAT_COUNT];
-    signed long            ldBmAverRange;
-    //For any BSSID selection improvment
-    bool            bSelected;
-
-    //++ WPA informations
-    bool            bWPAValid;
-    u8            byGKType;
-    u8            abyPKType[4];
-    u16            wPKCount;
-    u8            abyAuthType[4];
-    u16            wAuthCount;
-    u8            byDefaultK_as_PK;
-    u8            byReplayIdx;
-    //--
-
-    //++ WPA2 informations
-    bool            bWPA2Valid;
-    u8            byCSSGK;
-    u16            wCSSPKCount;
-    u8            abyCSSPK[4];
-    u16            wAKMSSAuthCount;
-    u8            abyAKMSSAuthType[4];
-
-    //++  wpactl
-    u8            byWPAIE[MAX_WPA_IE_LEN];
-    u8            byRSNIE[MAX_WPA_IE_LEN];
-    u16            wWPALen;
-    u16            wRSNLen;
-
-    // Clear count
-    unsigned int            uClearCount;
-//    u8            abyIEs[WLAN_BEACON_FR_MAXLEN];
-    unsigned int            uIELength;
-	u64 qwBSSTimestamp;
-	u64 qwLocalTSF;/* local TSF timer */
-
-    CARD_PHY_TYPE   eNetworkTypeInUse;
-
-    ERPObject       sERP;
-    SRSNCapObject   sRSNCapObj;
-    u8            abyIEs[1024];   // don't move this field !!
-
-} __attribute__ ((__packed__))
-KnownBSS , *PKnownBSS;
-
-typedef enum tagNODE_STATE {
-    NODE_FREE,
-    NODE_AGED,
-    NODE_KNOWN,
-    NODE_AUTH,
-    NODE_ASSOC
-} NODE_STATE, *PNODE_STATE;
-
-// STA node info
-typedef struct tagKnownNodeDB {
-    // STA info
-    bool            bActive;
-    u8            abyMACAddr[WLAN_ADDR_LEN];
-    u8            abyCurrSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN];
-    u8            abyCurrExtSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN];
-    u16            wTxDataRate;
-    bool            bShortPreamble;
-    bool            bERPExist;
-    bool            bShortSlotTime;
-    unsigned int            uInActiveCount;
-    u16            wMaxBasicRate;     //Get from byTopOFDMBasicRate or byTopCCKBasicRate which depends on packetTyp.
-    u16            wMaxSuppRate;      //Records the highest supported rate getting from SuppRates IE and ExtSuppRates IE in Beacon.
-    u16            wSuppRate;
-    u8            byTopOFDMBasicRate;//Records the highest basic rate in OFDM mode
-    u8            byTopCCKBasicRate; //Records the highest basic rate in CCK mode
-
-    // For AP mode
-    struct sk_buff_head sTxPSQueue;
-    u16            wCapInfo;
-    u16            wListenInterval;
-    u16            wAID;
-    NODE_STATE      eNodeState;
-    bool            bPSEnable;
-    bool            bRxPSPoll;
-    u8            byAuthSequence;
-    unsigned long           ulLastRxJiffer;
-    u8            bySuppRate;
-    u32           dwFlags;
-    u16            wEnQueueCnt;
-
-    bool            bOnFly;
-    unsigned long long       KeyRSC;
-    u8            byKeyIndex;
-    u32           dwKeyIndex;
-    u8            byCipherSuite;
-    u32           dwTSC47_16;
-    u16            wTSC15_0;
-    unsigned int            uWepKeyLength;
-    u8            abyWepKey[WLAN_WEPMAX_KEYLEN];
-    //
-    // Auto rate fallback vars
-    bool            bIsInFallback;
-    unsigned int            uAverageRSSI;
-    unsigned int            uRateRecoveryTimeout;
-    unsigned int            uRatePollTimeout;
-    unsigned int            uTxFailures;
-    unsigned int            uTxAttempts;
-
-    unsigned int            uTxRetry;
-    unsigned int            uFailureRatio;
-    unsigned int            uRetryRatio;
-    unsigned int            uTxOk[MAX_RATE+1];
-    unsigned int            uTxFail[MAX_RATE+1];
-    unsigned int            uTimeCount;
-
-} KnownNodeDB, *PKnownNodeDB;
-
-
-#endif /* __BSSDB_H__ */
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index f40d6b4..65a3a70 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -39,7 +39,6 @@
 #include "device.h"
 #include "rxtx.h"
 #include "card.h"
-#include "bssdb.h"
 #include "mac.h"
 #include "baseband.h"
 #include "rf.h"
diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index 5961f159..23d045c 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -35,7 +35,6 @@
 #include "int.h"
 #include "mac.h"
 #include "power.h"
-#include "bssdb.h"
 #include "usbpipe.h"
 
 static int msglevel = MSG_LEVEL_INFO; /* MSG_LEVEL_DEBUG */
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 26fac20..feecd51 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -55,7 +55,6 @@
 #include "power.h"
 #include "wcmd.h"
 #include "rxtx.h"
-#include "bssdb.h"
 #include "dpc.h"
 #include "rf.h"
 #include "firmware.h"
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 492d9c3..7c9f232 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -46,7 +46,6 @@
 #include "device.h"
 #include "rxtx.h"
 #include "card.h"
-#include "bssdb.h"
 #include "mac.h"
 #include "rf.h"
 #include "usbpipe.h"
diff --git a/drivers/staging/vt6656/wmgr.h b/drivers/staging/vt6656/wmgr.h
index f16dfe0..a140e160 100644
--- a/drivers/staging/vt6656/wmgr.h
+++ b/drivers/staging/vt6656/wmgr.h
@@ -36,7 +36,6 @@
 
 #include "80211hdr.h"
 #include "wcmd.h"
-#include "bssdb.h"
 #include "card.h"
 
 // Scan time
@@ -221,7 +220,6 @@ struct vnt_manager {
 	WMAC_BSS_STATE eCurrState; /* MAC current BSS state */
 	WMAC_BSS_STATE eLastState; /* MAC last BSS state */
 
-	PKnownBSS pCurrBSS;
 	u8 byCSSGK;
 	u8 byCSSPK;
 
@@ -257,7 +255,6 @@ struct vnt_manager {
 	u32 uIBSSChannel;
 	u8 abyIBSSSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1];
 	u8 byAPBBType;
-	u8 abyWPAIE[MAX_WPA_IE_LEN];
 	u16 wWPAIELen;
 
 	u32 uAssocCount;
@@ -295,7 +292,6 @@ struct vnt_manager {
 	u8 byPSPacketPool[sizeof(struct vnt_tx_mgmt)
 		+ WLAN_NULLDATA_FR_MAXLEN];
 	int bRxBeaconInTBTTWake;
-	u8 abyPSTxMap[MAX_NODE_NUM + 1];
 
 	/* management command related */
 	u32 uCmdBusy;
@@ -310,16 +306,13 @@ struct vnt_manager {
 	struct vnt_rx_mgmt sRxPacket;
 
 	/* link list of known bss's (scan results) */
-	KnownBSS sBSSList[MAX_BSS_NUM];
 	/* link list of same bss's */
-	KnownBSS pSameBSS[6];
 	int Cisco_cckm;
 	u8 Roam_dbm;
 
 	/* table list of known node */
 	/* sNodeDBList[0] is reserved for AP under Infra mode */
 	/* sNodeDBList[0] is reserved for Multicast under adhoc/AP mode */
-	KnownNodeDB sNodeDBTable[MAX_NODE_NUM + 1];
 
 	/* WPA2 PMKID Cache */
 	int bRoaming;
-- 
1.9.1

