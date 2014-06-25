Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:40443 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317AbaFYUV4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:21:56 -0400
Received: by mail-we0-f174.google.com with SMTP id u57so2722944wes.33
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:21:54 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 30/34] staging: vt6656: dead code remove 80211hdr.h
Date: Wed, 25 Jun 2014 21:20:07 +0100
Message-Id: <1403727611-6825-31-git-send-email-tvboxspy@gmail.com> (sfid-20140625_223011_353075_306C86FF)
In-Reply-To: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
References: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove all variables that are dead with this header

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/80211hdr.h | 324 --------------------------------------
 drivers/staging/vt6656/device.h   |   3 -
 drivers/staging/vt6656/mac.c      |   1 -
 drivers/staging/vt6656/wcmd.c     |   2 -
 drivers/staging/vt6656/wcmd.h     |   2 -
 5 files changed, 332 deletions(-)
 delete mode 100644 drivers/staging/vt6656/80211hdr.h

diff --git a/drivers/staging/vt6656/80211hdr.h b/drivers/staging/vt6656/80211hdr.h
deleted file mode 100644
index 1e778ba..0000000
--- a/drivers/staging/vt6656/80211hdr.h
+++ /dev/null
@@ -1,324 +0,0 @@
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
- * File: 80211hdr.h
- *
- * Purpose: 802.11 MAC headers related pre-defines and macros.
- *
- * Author: Lyndon Chen
- *
- * Date: Apr 8, 2002
- */
-
-#ifndef __80211HDR_H__
-#define __80211HDR_H__
-
-/* bit type */
-#define BIT0	0x00000001
-#define BIT1	0x00000002
-#define BIT2	0x00000004
-#define BIT3	0x00000008
-#define BIT4	0x00000010
-#define BIT5	0x00000020
-#define BIT6	0x00000040
-#define BIT7	0x00000080
-#define BIT8	0x00000100
-#define BIT9	0x00000200
-#define BIT10	0x00000400
-#define BIT11	0x00000800
-#define BIT12	0x00001000
-#define BIT13	0x00002000
-#define BIT14	0x00004000
-#define BIT15	0x00008000
-#define BIT16	0x00010000
-#define BIT17	0x00020000
-#define BIT18	0x00040000
-#define BIT19	0x00080000
-#define BIT20	0x00100000
-#define BIT21	0x00200000
-#define BIT22	0x00400000
-#define BIT23	0x00800000
-#define BIT24	0x01000000
-#define BIT25	0x02000000
-#define BIT26	0x04000000
-#define BIT27	0x08000000
-#define BIT28	0x10000000
-#define BIT29	0x20000000
-#define BIT30	0x40000000
-#define BIT31	0x80000000
-
-/* 802.11 frame related, defined as 802.11 spec */
-#define WLAN_ADDR_LEN               6
-#define WLAN_CRC_LEN                4
-#define WLAN_CRC32_LEN              4
-#define WLAN_FCS_LEN                4
-#define WLAN_BSSID_LEN              6
-#define WLAN_BSS_TS_LEN             8
-#define WLAN_HDR_ADDR2_LEN          16
-#define WLAN_HDR_ADDR3_LEN          24
-#define WLAN_HDR_ADDR4_LEN          30
-#define WLAN_IEHDR_LEN              2
-#define WLAN_SSID_MAXLEN            32
-#define WLAN_RATES_MAXLEN           16
-#define WLAN_RATES_MAXLEN_11B       4
-#define WLAN_RSN_MAXLEN             32
-#define WLAN_DATA_MAXLEN            2312
-#define WLAN_A3FR_MAXLEN            (WLAN_HDR_ADDR3_LEN \
-				     + WLAN_DATA_MAXLEN \
-				     + WLAN_CRC_LEN)
-
-#define WLAN_BEACON_FR_MAXLEN       WLAN_A3FR_MAXLEN
-#define WLAN_ATIM_FR_MAXLEN         (WLAN_HDR_ADDR3_LEN + 0)
-#define WLAN_NULLDATA_FR_MAXLEN     (WLAN_HDR_ADDR3_LEN + 0)
-#define WLAN_DISASSOC_FR_MAXLEN     (WLAN_HDR_ADDR3_LEN + 2)
-#define WLAN_ASSOCREQ_FR_MAXLEN     WLAN_A3FR_MAXLEN
-#define WLAN_ASSOCRESP_FR_MAXLEN    WLAN_A3FR_MAXLEN
-#define WLAN_REASSOCREQ_FR_MAXLEN   WLAN_A3FR_MAXLEN
-#define WLAN_REASSOCRESP_FR_MAXLEN  WLAN_A3FR_MAXLEN
-#define WLAN_PROBEREQ_FR_MAXLEN     WLAN_A3FR_MAXLEN
-#define WLAN_PROBERESP_FR_MAXLEN    WLAN_A3FR_MAXLEN
-#define WLAN_AUTHEN_FR_MAXLEN       WLAN_A3FR_MAXLEN
-#define WLAN_DEAUTHEN_FR_MAXLEN     (WLAN_HDR_ADDR3_LEN + 2)
-
-#define WLAN_WEP_NKEYS              4
-#define WLAN_WEP40_KEYLEN           5
-#define WLAN_WEP104_KEYLEN          13
-#define WLAN_WEP232_KEYLEN          29
-#define WLAN_WEPMAX_KEYLEN          32
-#define WLAN_CHALLENGE_IE_MAXLEN    255
-#define WLAN_CHALLENGE_IE_LEN       130
-#define WLAN_CHALLENGE_LEN          128
-#define WLAN_WEP_IV_LEN             4
-#define WLAN_WEP_ICV_LEN            4
-#define WLAN_FRAGS_MAX              16
-
-/* Frame Type */
-#define WLAN_TYPE_MGR 0x00
-#define WLAN_TYPE_CTL  0x01
-#define WLAN_TYPE_DATA 0x02
-
-#define WLAN_FTYPE_MGMT 0x00
-#define WLAN_FTYPE_CTL  0x01
-#define WLAN_FTYPE_DATA 0x02
-
-/* Frame Subtypes */
-#define WLAN_FSTYPE_ASSOCREQ        0x00
-#define WLAN_FSTYPE_ASSOCRESP       0x01
-#define WLAN_FSTYPE_REASSOCREQ      0x02
-#define WLAN_FSTYPE_REASSOCRESP     0x03
-#define WLAN_FSTYPE_PROBEREQ        0x04
-#define WLAN_FSTYPE_PROBERESP       0x05
-#define WLAN_FSTYPE_BEACON          0x08
-#define WLAN_FSTYPE_ATIM            0x09
-#define WLAN_FSTYPE_DISASSOC        0x0a
-#define WLAN_FSTYPE_AUTHEN          0x0b
-#define WLAN_FSTYPE_DEAUTHEN        0x0c
-#define WLAN_FSTYPE_ACTION          0x0d
-
-/* Control */
-#define WLAN_FSTYPE_PSPOLL          0x0a
-#define WLAN_FSTYPE_RTS             0x0b
-#define WLAN_FSTYPE_CTS             0x0c
-#define WLAN_FSTYPE_ACK             0x0d
-#define WLAN_FSTYPE_CFEND           0x0e
-#define WLAN_FSTYPE_CFENDCFACK      0x0f
-
-/* Data */
-#define WLAN_FSTYPE_DATAONLY        0x00
-#define WLAN_FSTYPE_DATA_CFACK      0x01
-#define WLAN_FSTYPE_DATA_CFPOLL     0x02
-#define WLAN_FSTYPE_DATA_CFACK_CFPOLL   0x03
-#define WLAN_FSTYPE_NULL            0x04
-#define WLAN_FSTYPE_CFACK           0x05
-#define WLAN_FSTYPE_CFPOLL          0x06
-#define WLAN_FSTYPE_CFACK_CFPOLL    0x07
-
-#ifdef __BIG_ENDIAN
-
-/* GET & SET Frame Control bit */
-#define WLAN_GET_FC_PRVER(n)    (((u16)(n) >> 8) & (BIT0 | BIT1))
-#define WLAN_GET_FC_FTYPE(n)    ((((u16)(n) >> 8) & (BIT2 | BIT3)) >> 2)
-#define WLAN_GET_FC_FSTYPE(n)   ((((u16)(n) >> 8) \
-				  & (BIT4|BIT5|BIT6|BIT7)) >> 4)
-#define WLAN_GET_FC_TODS(n)     ((((u16)(n) << 8) & (BIT8)) >> 8)
-#define WLAN_GET_FC_FROMDS(n)   ((((u16)(n) << 8) & (BIT9)) >> 9)
-#define WLAN_GET_FC_MOREFRAG(n) ((((u16)(n) << 8) & (BIT10)) >> 10)
-#define WLAN_GET_FC_RETRY(n)    ((((u16)(n) << 8) & (BIT11)) >> 11)
-#define WLAN_GET_FC_PWRMGT(n)   ((((u16)(n) << 8) & (BIT12)) >> 12)
-#define WLAN_GET_FC_MOREDATA(n) ((((u16)(n) << 8) & (BIT13)) >> 13)
-#define WLAN_GET_FC_ISWEP(n)    ((((u16)(n) << 8) & (BIT14)) >> 14)
-#define WLAN_GET_FC_ORDER(n)    ((((u16)(n) << 8) & (BIT15)) >> 15)
-
-/* Sequence Field bit */
-#define WLAN_GET_SEQ_FRGNUM(n) (((u16)(n) >> 8) & (BIT0|BIT1|BIT2|BIT3))
-#define WLAN_GET_SEQ_SEQNUM(n) ((((u16)(n) >> 8) \
-				 & (~(BIT0|BIT1|BIT2|BIT3))) >> 4)
-
-/* Capability Field bit */
-#define WLAN_GET_CAP_INFO_ESS(n)           (((n) >> 8) & BIT0)
-#define WLAN_GET_CAP_INFO_IBSS(n)          ((((n) >> 8) & BIT1) >> 1)
-#define WLAN_GET_CAP_INFO_CFPOLLABLE(n)    ((((n) >> 8) & BIT2) >> 2)
-#define WLAN_GET_CAP_INFO_CFPOLLREQ(n)     ((((n) >> 8) & BIT3) >> 3)
-#define WLAN_GET_CAP_INFO_PRIVACY(n)       ((((n) >> 8) & BIT4) >> 4)
-#define WLAN_GET_CAP_INFO_SHORTPREAMBLE(n) ((((n) >> 8) & BIT5) >> 5)
-#define WLAN_GET_CAP_INFO_PBCC(n)          ((((n) >> 8) & BIT6) >> 6)
-#define WLAN_GET_CAP_INFO_AGILITY(n)       ((((n) >> 8) & BIT7) >> 7)
-#define WLAN_GET_CAP_INFO_SPECTRUMMNG(n)   ((((n))      & BIT8) >> 10)
-#define WLAN_GET_CAP_INFO_SHORTSLOTTIME(n) ((((n))      & BIT10) >> 10)
-#define WLAN_GET_CAP_INFO_DSSSOFDM(n)      ((((n))      & BIT13) >> 13)
-#define WLAN_GET_CAP_INFO_GRPACK(n)        ((((n))      & BIT14) >> 14)
-
-#else
-
-/* GET & SET Frame Control bit */
-#define WLAN_GET_FC_PRVER(n)    (((u16)(n)) & (BIT0 | BIT1))
-#define WLAN_GET_FC_FTYPE(n)    ((((u16)(n)) & (BIT2 | BIT3)) >> 2)
-#define WLAN_GET_FC_FSTYPE(n)   ((((u16)(n)) & (BIT4|BIT5|BIT6|BIT7)) >> 4)
-#define WLAN_GET_FC_TODS(n)     ((((u16)(n)) & (BIT8)) >> 8)
-#define WLAN_GET_FC_FROMDS(n)   ((((u16)(n)) & (BIT9)) >> 9)
-#define WLAN_GET_FC_MOREFRAG(n) ((((u16)(n)) & (BIT10)) >> 10)
-#define WLAN_GET_FC_RETRY(n)    ((((u16)(n)) & (BIT11)) >> 11)
-#define WLAN_GET_FC_PWRMGT(n)   ((((u16)(n)) & (BIT12)) >> 12)
-#define WLAN_GET_FC_MOREDATA(n) ((((u16)(n)) & (BIT13)) >> 13)
-#define WLAN_GET_FC_ISWEP(n)    ((((u16)(n)) & (BIT14)) >> 14)
-#define WLAN_GET_FC_ORDER(n)    ((((u16)(n)) & (BIT15)) >> 15)
-
-/* Sequence Field bit */
-#define WLAN_GET_SEQ_FRGNUM(n) (((u16)(n)) & (BIT0|BIT1|BIT2|BIT3))
-#define WLAN_GET_SEQ_SEQNUM(n) ((((u16)(n)) & (~(BIT0|BIT1|BIT2|BIT3))) >> 4)
-
-/* Capability Field bit */
-#define WLAN_GET_CAP_INFO_ESS(n)           ((n) & BIT0)
-#define WLAN_GET_CAP_INFO_IBSS(n)          (((n) & BIT1) >> 1)
-#define WLAN_GET_CAP_INFO_CFPOLLABLE(n)    (((n) & BIT2) >> 2)
-#define WLAN_GET_CAP_INFO_CFPOLLREQ(n)     (((n) & BIT3) >> 3)
-#define WLAN_GET_CAP_INFO_PRIVACY(n)       (((n) & BIT4) >> 4)
-#define WLAN_GET_CAP_INFO_SHORTPREAMBLE(n) (((n) & BIT5) >> 5)
-#define WLAN_GET_CAP_INFO_PBCC(n)          (((n) & BIT6) >> 6)
-#define WLAN_GET_CAP_INFO_AGILITY(n)       (((n) & BIT7) >> 7)
-#define WLAN_GET_CAP_INFO_SPECTRUMMNG(n)   (((n) & BIT8) >> 10)
-#define WLAN_GET_CAP_INFO_SHORTSLOTTIME(n) (((n) & BIT10) >> 10)
-#define WLAN_GET_CAP_INFO_DSSSOFDM(n)      (((n) & BIT13) >> 13)
-#define WLAN_GET_CAP_INFO_GRPACK(n)        (((n) & BIT14) >> 14)
-
-#endif /* #ifdef __BIG_ENDIAN */
-
-#define WLAN_SET_CAP_INFO_ESS(n)           (n)
-#define WLAN_SET_CAP_INFO_IBSS(n)          ((n) << 1)
-#define WLAN_SET_CAP_INFO_CFPOLLABLE(n)    ((n) << 2)
-#define WLAN_SET_CAP_INFO_CFPOLLREQ(n)     ((n) << 3)
-#define WLAN_SET_CAP_INFO_PRIVACY(n)       ((n) << 4)
-#define WLAN_SET_CAP_INFO_SHORTPREAMBLE(n) ((n) << 5)
-#define WLAN_SET_CAP_INFO_SPECTRUMMNG(n)   ((n) << 8)
-#define WLAN_SET_CAP_INFO_PBCC(n)          ((n) << 6)
-#define WLAN_SET_CAP_INFO_AGILITY(n)       ((n) << 7)
-#define WLAN_SET_CAP_INFO_SHORTSLOTTIME(n) ((n) << 10)
-#define WLAN_SET_CAP_INFO_DSSSOFDM(n)      ((n) << 13)
-#define WLAN_SET_CAP_INFO_GRPACK(n)        ((n) << 14)
-
-#define WLAN_SET_FC_PRVER(n)    ((u16)(n))
-#define WLAN_SET_FC_FTYPE(n)    (((u16)(n)) << 2)
-#define WLAN_SET_FC_FSTYPE(n)   (((u16)(n)) << 4)
-#define WLAN_SET_FC_TODS(n)     (((u16)(n)) << 8)
-#define WLAN_SET_FC_FROMDS(n)   (((u16)(n)) << 9)
-#define WLAN_SET_FC_MOREFRAG(n) (((u16)(n)) << 10)
-#define WLAN_SET_FC_RETRY(n)    (((u16)(n)) << 11)
-#define WLAN_SET_FC_PWRMGT(n)   (((u16)(n)) << 12)
-#define WLAN_SET_FC_MOREDATA(n) (((u16)(n)) << 13)
-#define WLAN_SET_FC_ISWEP(n)    (((u16)(n)) << 14)
-#define WLAN_SET_FC_ORDER(n)    (((u16)(n)) << 15)
-
-#define WLAN_SET_SEQ_FRGNUM(n) ((u16)(n))
-#define WLAN_SET_SEQ_SEQNUM(n) (((u16)(n)) << 4)
-
-/* ERP Field bit */
-
-#define WLAN_GET_ERP_NONERP_PRESENT(n)     ((n) & BIT0)
-#define WLAN_GET_ERP_USE_PROTECTION(n)     (((n) & BIT1) >> 1)
-#define WLAN_GET_ERP_BARKER_MODE(n)        (((n) & BIT2) >> 2)
-
-#define WLAN_SET_ERP_NONERP_PRESENT(n)     (n)
-#define WLAN_SET_ERP_USE_PROTECTION(n)     ((n) << 1)
-#define WLAN_SET_ERP_BARKER_MODE(n)        ((n) << 2)
-
-/* Support & Basic Rates field */
-#define WLAN_MGMT_IS_BASICRATE(b)    ((b) & BIT7)
-#define WLAN_MGMT_GET_RATE(b)        ((b) & ~BIT7)
-
-/* TIM field */
-#define WLAN_MGMT_IS_MULTICAST_TIM(b)   ((b) & BIT0)
-#define WLAN_MGMT_GET_TIM_OFFSET(b)     (((b) & ~BIT0) >> 1)
-
-/* 3-Addr & 4-Addr */
-#define WLAN_HDR_A3_DATA_PTR(p) (((u8 *)(p)) + WLAN_HDR_ADDR3_LEN)
-#define WLAN_HDR_A4_DATA_PTR(p) (((u8 *)(p)) + WLAN_HDR_ADDR4_LEN)
-
-/* IEEE ADDR */
-#define IEEE_ADDR_UNIVERSAL         0x02
-#define IEEE_ADDR_GROUP             0x01
-
-typedef struct {
-    u8            abyAddr[6];
-} IEEE_ADDR, *PIEEE_ADDR;
-
-/* 802.11 Header Format */
-
-typedef struct tagWLAN_80211HDR_A2 {
-
-    u16    wFrameCtl;
-    u16    wDurationID;
-    u8    abyAddr1[WLAN_ADDR_LEN];
-    u8    abyAddr2[WLAN_ADDR_LEN];
-
-} __attribute__ ((__packed__))
-WLAN_80211HDR_A2, *PWLAN_80211HDR_A2;
-
-typedef struct tagWLAN_80211HDR_A3 {
-
-    u16    wFrameCtl;
-    u16    wDurationID;
-    u8    abyAddr1[WLAN_ADDR_LEN];
-    u8    abyAddr2[WLAN_ADDR_LEN];
-    u8    abyAddr3[WLAN_ADDR_LEN];
-    u16    wSeqCtl;
-
-} __attribute__ ((__packed__))
-WLAN_80211HDR_A3, *PWLAN_80211HDR_A3;
-
-typedef struct tagWLAN_80211HDR_A4 {
-
-    u16    wFrameCtl;
-    u16    wDurationID;
-    u8    abyAddr1[WLAN_ADDR_LEN];
-    u8    abyAddr2[WLAN_ADDR_LEN];
-    u8    abyAddr3[WLAN_ADDR_LEN];
-    u16    wSeqCtl;
-    u8    abyAddr4[WLAN_ADDR_LEN];
-
-} __attribute__ ((__packed__))
-WLAN_80211HDR_A4, *PWLAN_80211HDR_A4;
-
-typedef union tagUWLAN_80211HDR {
-
-    WLAN_80211HDR_A2        sA2;
-    WLAN_80211HDR_A3        sA3;
-    WLAN_80211HDR_A4        sA4;
-
-} UWLAN_80211HDR, *PUWLAN_80211HDR;
-
-#endif /* __80211HDR_H__ */
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 2f9009b..d9fc32c 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -73,7 +73,6 @@
  * device specific
  */
 
-#include "80211hdr.h"
 #include "wcmd.h"
 #include "desc.h"
 #include "key.h"
@@ -603,11 +602,9 @@ struct vnt_private {
 	NDIS_802_11_WEP_STATUS eOldEncryptionStatus;
 	u32 dwIVCounter;
 
-	u8 abyPRNG[WLAN_WEPMAX_KEYLEN+3];
 	u8 byKeyIndex;
 
 	u32 uKeyLength;
-	u8 abyKey[WLAN_WEP232_KEYLEN];
 	unsigned long key_entry_inuse;
 
 	/* for AP mode */
diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 27fad2e..641d77b 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -32,7 +32,6 @@
 
 #include "desc.h"
 #include "mac.h"
-#include "80211hdr.h"
 #include "usbpipe.h"
 
 /*
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 7c81034..b62726f 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -41,7 +41,6 @@
 #include "device.h"
 #include "mac.h"
 #include "card.h"
-#include "80211hdr.h"
 #include "wcmd.h"
 #include "power.h"
 #include "baseband.h"
@@ -237,7 +236,6 @@ int bScheduleCommand(struct vnt_private *pDevice,
 		return false;
 	pDevice->eCmdQueue[pDevice->uCmdEnqueueIdx].eCmd = eCommand;
 	pDevice->eCmdQueue[pDevice->uCmdEnqueueIdx].bForceSCAN = true;
-	memset(pDevice->eCmdQueue[pDevice->uCmdEnqueueIdx].abyCmdDesireSSID, 0 , WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
 	if (pbyItem0 != NULL) {
 		switch (eCommand) {
 		case WLAN_CMD_RADIO:
diff --git a/drivers/staging/vt6656/wcmd.h b/drivers/staging/vt6656/wcmd.h
index 91351c6..1e5b739 100644
--- a/drivers/staging/vt6656/wcmd.h
+++ b/drivers/staging/vt6656/wcmd.h
@@ -29,7 +29,6 @@
 #ifndef __WCMD_H__
 #define __WCMD_H__
 
-#include "80211hdr.h"
 #include "device.h"
 
 #define AUTHENTICATE_TIMEOUT   1000 //ms
@@ -70,7 +69,6 @@ typedef enum tagCMD_STATUS {
 
 typedef struct tagCMD_ITEM {
     CMD_CODE eCmd;
-    u8     abyCmdDesireSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
     bool     bNeedRadioOFF;
     bool     bRadioCmd;
     bool     bForceSCAN;
-- 
1.9.1

