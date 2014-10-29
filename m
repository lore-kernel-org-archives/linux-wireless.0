Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:52730 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108AbaJ2R6F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:58:05 -0400
Received: by mail-wg0-f46.google.com with SMTP id x13so2496283wgg.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:58:04 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 35/48] staging: vt6655: dead code remove bssdb.h header
Date: Wed, 29 Oct 2014 17:55:53 +0000
Message-Id: <1414605366-9335-36-git-send-email-tvboxspy@gmail.com> (sfid-20141029_185901_616141_01585BF4)
In-Reply-To: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
References: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/bssdb.h       | 210 -----------------------------------
 drivers/staging/vt6655/device_main.c |   1 -
 drivers/staging/vt6655/rxtx.c        |   1 -
 drivers/staging/vt6655/wmgr.h        |   1 -
 4 files changed, 213 deletions(-)
 delete mode 100644 drivers/staging/vt6655/bssdb.h

diff --git a/drivers/staging/vt6655/bssdb.h b/drivers/staging/vt6655/bssdb.h
deleted file mode 100644
index 511b7f9..0000000
--- a/drivers/staging/vt6655/bssdb.h
+++ /dev/null
@@ -1,210 +0,0 @@
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
-#include "80211mgr.h"
-#include "card.h"
-
-#define MAX_NODE_NUM             64
-#define MAX_BSS_NUM              42
-#define LOST_BEACON_COUNT        10   /* 10 sec, XP defined */
-#define MAX_PS_TX_BUF            32   /* sta max power saving tx buf */
-#define ADHOC_LOST_BEACON_COUNT  30   /* 30 sec, beacon lost for adhoc only */
-#define MAX_INACTIVE_COUNT       300  /* 300 sec, inactive STA node refresh */
-
-#define USE_PROTECT_PERIOD       10   /*10 sec, Use protect mode check period*/
-#define ERP_RECOVER_COUNT        30   /* 30 sec, ERP support callback check */
-#define BSS_CLEAR_COUNT           1
-
-#define RSSI_STAT_COUNT          10
-#define MAX_CHECK_RSSI_COUNT     8
-
-/* STA dwflags */
-#define WLAN_STA_AUTH            BIT0
-#define WLAN_STA_ASSOC           BIT1
-#define WLAN_STA_PS              BIT2
-#define WLAN_STA_TIM             BIT3
-/* permanent; do not remove entry on expiration */
-#define WLAN_STA_PERM            BIT4
-/*
- * If 802.1X is used, this flag is controlling whether STA is authorized
- * to send and receive non-IEEE 802.1X frames
- */
-#define WLAN_STA_AUTHORIZED      BIT5
-
-#define MAX_RATE            12
-
-#define MAX_WPA_IE_LEN      64
-
-/* IEEE 802.11 Structures and definitions */
-
-typedef enum _NDIS_802_11_NETWORK_TYPE {
-	Ndis802_11FH,
-	Ndis802_11DS,
-	Ndis802_11OFDM5,
-	Ndis802_11OFDM24,
-	Ndis802_11NetworkTypeMax    /* defined as an upper bound */
-} NDIS_802_11_NETWORK_TYPE, *PNDIS_802_11_NETWORK_TYPE;
-
-typedef struct tagSERPObject {
-	bool bERPExist;
-	unsigned char byERP;
-} ERPObject, *PERPObject;
-
-typedef struct tagSRSNCapObject {
-	bool bRSNCapExist;
-	unsigned short wRSNCap;
-} SRSNCapObject, *PSRSNCapObject;
-
-/* BSS info(AP) */
-#pragma pack(1)
-typedef struct tagKnownBSS {
-	bool bActive;
-	unsigned char abyBSSID[WLAN_BSSID_LEN];
-	unsigned int	uChannel;
-	unsigned char abySuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1];
-	unsigned char abyExtSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN + 1];
-	unsigned int	uRSSI;
-	unsigned char bySQ;
-	unsigned short wBeaconInterval;
-	unsigned short wCapInfo;
-	unsigned char abySSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
-	unsigned char byRxRate;
-
-	unsigned char byRSSIStatCnt;
-	long            ldBmMAX;
-	long            ldBmAverage[RSSI_STAT_COUNT];
-	long            ldBmAverRange;
-	bool bSelected;
-
-	bool bWPAValid;
-	unsigned char byGKType;
-	unsigned char abyPKType[4];
-	unsigned short wPKCount;
-	unsigned char abyAuthType[4];
-	unsigned short wAuthCount;
-	unsigned char byDefaultK_as_PK;
-	unsigned char byReplayIdx;
-
-	bool bWPA2Valid;
-	unsigned char byCSSGK;
-	unsigned short wCSSPKCount;
-	unsigned char abyCSSPK[4];
-	unsigned short wAKMSSAuthCount;
-	unsigned char abyAKMSSAuthType[4];
-
-	unsigned char byWPAIE[MAX_WPA_IE_LEN];
-	unsigned char byRSNIE[MAX_WPA_IE_LEN];
-	unsigned short wWPALen;
-	unsigned short wRSNLen;
-
-	unsigned int	uClearCount;
-	unsigned int	uIELength;
-	u64 qwBSSTimestamp;
-	u64 qwLocalTSF;
-
-	CARD_PHY_TYPE   eNetworkTypeInUse;
-
-	ERPObject       sERP;
-	SRSNCapObject   sRSNCapObj;
-	unsigned char abyIEs[1024];
-} __attribute__ ((__packed__))
-KnownBSS , *PKnownBSS;
-
-#pragma pack()
-
-typedef enum tagNODE_STATE {
-	NODE_FREE,
-	NODE_AGED,
-	NODE_KNOWN,
-	NODE_AUTH,
-	NODE_ASSOC
-} NODE_STATE, *PNODE_STATE;
-
-/* STA node info */
-typedef struct tagKnownNodeDB {
-	bool bActive;
-	unsigned char abyMACAddr[WLAN_ADDR_LEN];
-	unsigned char abyCurrSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN];
-	unsigned char abyCurrExtSuppRates[WLAN_IEHDR_LEN + WLAN_RATES_MAXLEN];
-	unsigned short wTxDataRate;
-	bool bShortPreamble;
-	bool bERPExist;
-	bool bShortSlotTime;
-	unsigned int	uInActiveCount;
-	unsigned short wMaxBasicRate;     /* Get from byTopOFDMBasicRate or byTopCCKBasicRate which depends on packetTyp. */
-	unsigned short wMaxSuppRate;      /* Records the highest supported rate getting from SuppRates IE and ExtSuppRates IE in Beacon. */
-	unsigned short wSuppRate;
-	unsigned char byTopOFDMBasicRate; /* Records the highest basic rate in OFDM mode */
-	unsigned char byTopCCKBasicRate;  /* Records the highest basic rate in CCK mode */
-
-	/* For AP mode */
-	struct sk_buff_head sTxPSQueue;
-	unsigned short wCapInfo;
-	unsigned short wListenInterval;
-	unsigned short wAID;
-	NODE_STATE      eNodeState;
-	bool bPSEnable;
-	bool bRxPSPoll;
-	unsigned char byAuthSequence;
-	unsigned long ulLastRxJiffer;
-	unsigned char bySuppRate;
-	unsigned long dwFlags;
-	unsigned short wEnQueueCnt;
-
-	bool bOnFly;
-	unsigned long long       KeyRSC;
-	unsigned char byKeyIndex;
-	unsigned long dwKeyIndex;
-	unsigned char byCipherSuite;
-	unsigned long dwTSC47_16;
-	unsigned short wTSC15_0;
-	unsigned int	uWepKeyLength;
-	unsigned char abyWepKey[WLAN_WEPMAX_KEYLEN];
-	/* Auto rate fallback vars */
-	bool bIsInFallback;
-	unsigned int	uAverageRSSI;
-	unsigned int	uRateRecoveryTimeout;
-	unsigned int	uRatePollTimeout;
-	unsigned int	uTxFailures;
-	unsigned int	uTxAttempts;
-
-	unsigned int	uTxRetry;
-	unsigned int	uFailureRatio;
-	unsigned int	uRetryRatio;
-	unsigned int	uTxOk[MAX_RATE+1];
-	unsigned int	uTxFail[MAX_RATE+1];
-	unsigned int	uTimeCount;
-} KnownNodeDB, *PKnownNodeDB;
-
-#endif /*__BSSDB_H__ */
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 80bbe1d..dfaec04 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -63,7 +63,6 @@
 #include "power.h"
 #include "iocmd.h"
 #include "rxtx.h"
-#include "bssdb.h"
 #include "dpc.h"
 #include "rf.h"
 #include "iowpa.h"
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 00ae6de..246a250 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -52,7 +52,6 @@
 #include "rxtx.h"
 #include "tether.h"
 #include "card.h"
-#include "bssdb.h"
 #include "mac.h"
 #include "baseband.h"
 #include "rf.h"
diff --git a/drivers/staging/vt6655/wmgr.h b/drivers/staging/vt6655/wmgr.h
index 0e6a6f0..9e983f6 100644
--- a/drivers/staging/vt6655/wmgr.h
+++ b/drivers/staging/vt6655/wmgr.h
@@ -37,7 +37,6 @@
 #include "ttype.h"
 #include "80211mgr.h"
 #include "80211hdr.h"
-#include "bssdb.h"
 #include "card.h"
 
 /*---------------------  Export Definitions -------------------------*/
-- 
2.1.0

