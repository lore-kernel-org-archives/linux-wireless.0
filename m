Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:51086 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679AbaJ2R6H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:58:07 -0400
Received: by mail-wg0-f47.google.com with SMTP id a1so2477873wgh.34
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:58:06 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 36/48] staging: vt6655: dead code remove tether.h
Date: Wed, 29 Oct 2014 17:55:54 +0000
Message-Id: <1414605366-9335-37-git-send-email-tvboxspy@gmail.com> (sfid-20141029_185916_227647_588CE8F4)
In-Reply-To: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
References: <1414605366-9335-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/baseband.c    |   1 -
 drivers/staging/vt6655/baseband.h    |   1 -
 drivers/staging/vt6655/desc.h        |   1 -
 drivers/staging/vt6655/device.h      |   3 -
 drivers/staging/vt6655/device_main.c |   1 -
 drivers/staging/vt6655/key.h         |   1 -
 drivers/staging/vt6655/mac.c         |   1 -
 drivers/staging/vt6655/mib.h         |   1 -
 drivers/staging/vt6655/rxtx.c        |   1 -
 drivers/staging/vt6655/srom.c        |   1 -
 drivers/staging/vt6655/tether.h      | 188 -----------------------------------
 11 files changed, 200 deletions(-)
 delete mode 100644 drivers/staging/vt6655/tether.h

diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index c7ad927..ed78505 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -50,7 +50,6 @@
  */
 
 #include "tmacro.h"
-#include "tether.h"
 #include "mac.h"
 #include "baseband.h"
 #include "srom.h"
diff --git a/drivers/staging/vt6655/baseband.h b/drivers/staging/vt6655/baseband.h
index 31f2255..2d7a3e2 100644
--- a/drivers/staging/vt6655/baseband.h
+++ b/drivers/staging/vt6655/baseband.h
@@ -31,7 +31,6 @@
 #define __BASEBAND_H__
 
 #include "ttype.h"
-#include "tether.h"
 #include "device.h"
 
 /*
diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index b59405b..32dd1ca 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -35,7 +35,6 @@
 #include <linux/mm.h>
 #include "linux/ieee80211.h"
 #include "ttype.h"
-#include "tether.h"
 
 #define B_OWNED_BY_CHIP     1
 #define B_OWNED_BY_HOST     0
diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index f73239f..4d9d60b 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -69,7 +69,6 @@
 #include "device_cfg.h"
 #include "ttype.h"
 #include "80211hdr.h"
-#include "tether.h"
 #include "wmgr.h"
 #include "mib.h"
 #include "srom.h"
@@ -633,8 +632,6 @@ struct vnt_private {
 	unsigned long uNumSQ3[MAX_RATE];
 	unsigned short wAntDiversityMaxRate;
 
-	SEthernetHeader         sTxEthHeader;
-	SEthernetHeader         sRxEthHeader;
 	unsigned char abyBroadcastAddr[ETH_ALEN];
 	unsigned char abySNAP_RFC1042[ETH_ALEN];
 	unsigned char abySNAP_Bridgetunnel[ETH_ALEN];
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index dfaec04..2327369 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -58,7 +58,6 @@
 #include "channel.h"
 #include "baseband.h"
 #include "mac.h"
-#include "tether.h"
 #include "wmgr.h"
 #include "power.h"
 #include "iocmd.h"
diff --git a/drivers/staging/vt6655/key.h b/drivers/staging/vt6655/key.h
index 56d1b05..53b4606 100644
--- a/drivers/staging/vt6655/key.h
+++ b/drivers/staging/vt6655/key.h
@@ -33,7 +33,6 @@
 #include <net/mac80211.h>
 
 #include "ttype.h"
-#include "tether.h"
 #include "80211mgr.h"
 
 /*---------------------  Export Definitions -------------------------*/
diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index a347f39..955dbfe 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -69,7 +69,6 @@
  */
 
 #include "tmacro.h"
-#include "tether.h"
 #include "mac.h"
 
 unsigned short TxRate_iwconfig;//2008-5-8 <add> by chester
diff --git a/drivers/staging/vt6655/mib.h b/drivers/staging/vt6655/mib.h
index fdb40f2..a2e6106 100644
--- a/drivers/staging/vt6655/mib.h
+++ b/drivers/staging/vt6655/mib.h
@@ -30,7 +30,6 @@
 #define __MIB_H__
 
 #include "ttype.h"
-#include "tether.h"
 #include "desc.h"
 
 //
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 246a250..f4da7e7 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -50,7 +50,6 @@
 
 #include "device.h"
 #include "rxtx.h"
-#include "tether.h"
 #include "card.h"
 #include "mac.h"
 #include "baseband.h"
diff --git a/drivers/staging/vt6655/srom.c b/drivers/staging/vt6655/srom.c
index 5396e58..1ac60fb 100644
--- a/drivers/staging/vt6655/srom.c
+++ b/drivers/staging/vt6655/srom.c
@@ -44,7 +44,6 @@
 
 #include "upc.h"
 #include "tmacro.h"
-#include "tether.h"
 #include "mac.h"
 #include "srom.h"
 
diff --git a/drivers/staging/vt6655/tether.h b/drivers/staging/vt6655/tether.h
deleted file mode 100644
index 850554c..0000000
--- a/drivers/staging/vt6655/tether.h
+++ /dev/null
@@ -1,188 +0,0 @@
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
- * File: tether.h
- *
- * Purpose:
- *
- * Author: Tevin Chen
- *
- * Date: Jan. 28, 1997
- *
- */
-
-#ifndef __TETHER_H__
-#define __TETHER_H__
-
-#include <linux/etherdevice.h>
-#include "ttype.h"
-
-/*---------------------  Export Definitions -------------------------*/
-//
-// constants
-//
-#define U_ETHER_ADDR_STR_LEN (ETH_ALEN * 2 + 1)
-// Ethernet address string length
-
-#define MAX_LOOKAHEAD_SIZE  ETH_FRAME_LEN
-
-#define U_MULTI_ADDR_LEN    8           // multicast address length
-
-#ifdef __BIG_ENDIAN
-
-#define TYPE_PKT_IP         0x0800      //
-#define TYPE_PKT_ARP        0x0806      //
-#define TYPE_PKT_RARP       0x8035      //
-#define TYPE_PKT_IPX	    0x8137	    //
-#define TYPE_PKT_802_1x     0x888e
-#define TYPE_PKT_PreAuth    0x88C7
-
-#define TYPE_PKT_PING_M_REQ 0x8011      // master reguest
-#define TYPE_PKT_PING_S_GNT 0x8022      // slave grant
-#define TYPE_PKT_PING_M     0x8077      // pingpong master packet
-#define TYPE_PKT_PING_S     0x8088      // pingpong slave packet
-#define TYPE_PKT_WOL_M_REQ  0x8033      // WOL waker request
-#define TYPE_PKT_WOL_S_GNT  0x8044      // WOL sleeper grant
-#define TYPE_MGMT_PROBE_RSP 0x5000
-#define TYPE_PKT_VNT_DIAG   0x8011      // Diag Pkt
-#define TYPE_PKT_VNT_PER    0x8888      // Diag PER Pkt
-//
-// wFrameCtl field in the S802_11Header
-//
-// NOTE....
-//   in network byte order, high byte is going first
-#define FC_TODS             0x0001
-#define FC_FROMDS           0x0002
-#define FC_MOREFRAG         0x0004
-#define FC_RETRY            0x0008
-#define FC_POWERMGT         0x0010
-#define FC_MOREDATA         0x0020
-#define FC_WEP              0x0040
-#define TYPE_802_11_ATIM    0x9000
-
-#define TYPE_802_11_DATA    0x0800
-#define TYPE_802_11_CTL     0x0400
-#define TYPE_802_11_MGMT    0x0000
-#define TYPE_802_11_MASK    0x0C00
-#define TYPE_SUBTYPE_MASK   0xFC00
-#define TYPE_802_11_NODATA  0x4000
-#define TYPE_DATE_NULL      0x4800
-
-#define TYPE_CTL_PSPOLL     0xa400
-#define TYPE_CTL_RTS        0xb400
-#define TYPE_CTL_CTS        0xc400
-#define TYPE_CTL_ACK        0xd400
-
-#else //if LITTLE_ENDIAN
-//
-// wType field in the SEthernetHeader
-//
-// NOTE....
-//   in network byte order, high byte is going first
-#define TYPE_PKT_IP         0x0008      //
-#define TYPE_PKT_ARP        0x0608      //
-#define TYPE_PKT_RARP       0x3580      //
-#define TYPE_PKT_IPX	    0x3781	    //
-
-#define TYPE_PKT_802_1x     0x8e88
-#define TYPE_PKT_PreAuth    0xC788
-
-#define TYPE_PKT_PING_M_REQ 0x1180      // master reguest
-#define TYPE_PKT_PING_S_GNT 0x2280      // slave grant
-#define TYPE_PKT_PING_M     0x7780      // pingpong master packet
-#define TYPE_PKT_PING_S     0x8880      // pingpong slave packet
-#define TYPE_PKT_WOL_M_REQ  0x3380      // WOL waker request
-#define TYPE_PKT_WOL_S_GNT  0x4480      // WOL sleeper grant
-#define TYPE_MGMT_PROBE_RSP 0x0050
-#define TYPE_PKT_VNT_DIAG   0x1180      // Diag Pkt
-#define TYPE_PKT_VNT_PER    0x8888      // Diag PER Pkt
-//
-// wFrameCtl field in the S802_11Header
-//
-// NOTE....
-//   in network byte order, high byte is going first
-#define FC_TODS             0x0100
-#define FC_FROMDS           0x0200
-#define FC_MOREFRAG         0x0400
-#define FC_RETRY            0x0800
-#define FC_POWERMGT         0x1000
-#define FC_MOREDATA         0x2000
-#define FC_WEP              0x4000
-#define TYPE_802_11_ATIM    0x0090
-
-#define TYPE_802_11_DATA    0x0008
-#define TYPE_802_11_CTL     0x0004
-#define TYPE_802_11_MGMT    0x0000
-#define TYPE_802_11_MASK    0x000C
-#define TYPE_SUBTYPE_MASK   0x00FC
-#define TYPE_802_11_NODATA  0x0040
-#define TYPE_DATE_NULL      0x0048
-
-#define TYPE_CTL_PSPOLL     0x00a4
-#define TYPE_CTL_RTS        0x00b4
-#define TYPE_CTL_CTS        0x00c4
-#define TYPE_CTL_ACK        0x00d4
-
-#endif //#ifdef __BIG_ENDIAN
-
-#define WEP_IV_MASK         0x00FFFFFF
-
-/*---------------------  Export Types  ------------------------------*/
-//
-// Ethernet packet
-//
-typedef struct tagSEthernetHeader {
-	unsigned char abyDstAddr[ETH_ALEN];
-	unsigned char abySrcAddr[ETH_ALEN];
-	unsigned short wType;
-} __attribute__ ((__packed__))
-SEthernetHeader, *PSEthernetHeader;
-
-//
-// 802_3 packet
-//
-typedef struct tagS802_3Header {
-	unsigned char abyDstAddr[ETH_ALEN];
-	unsigned char abySrcAddr[ETH_ALEN];
-	unsigned short wLen;
-} __attribute__ ((__packed__))
-S802_3Header, *PS802_3Header;
-
-//
-// 802_11 packet
-//
-typedef struct tagS802_11Header {
-	unsigned short wFrameCtl;
-	unsigned short wDurationID;
-	unsigned char abyAddr1[ETH_ALEN];
-	unsigned char abyAddr2[ETH_ALEN];
-	unsigned char abyAddr3[ETH_ALEN];
-	unsigned short wSeqCtl;
-	unsigned char abyAddr4[ETH_ALEN];
-} __attribute__ ((__packed__))
-S802_11Header, *PS802_11Header;
-
-/*---------------------  Export Macros ------------------------------*/
-
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
-#endif // __TETHER_H__
-- 
2.1.0

