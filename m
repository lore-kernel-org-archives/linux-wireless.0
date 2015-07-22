Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33609 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbbGVSSA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 14:18:00 -0400
Received: by wicmv11 with SMTP id mv11so92409154wic.0
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2015 11:17:59 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 15/15] staging: vt6655: desc.h remove dead strctures
Date: Wed, 22 Jul 2015 19:16:47 +0100
Message-Id: <1437589007-5479-15-git-send-email-tvboxspy@gmail.com> (sfid-20150722_203715_944010_EF8D9443)
In-Reply-To: <1437589007-5479-1-git-send-email-tvboxspy@gmail.com>
References: <1437589007-5479-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove these unsed structures.
typedef struct tagSTxSyncDesc
typedef struct tagSRrvTime_atim
typedef struct tagSTxBufHead
typedef struct tagSBEACONCtl
typedef struct tagSSecretKey
typedef struct tagSKeyEntry

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h | 59 -------------------------------------------
 1 file changed, 59 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 2374fa5..c916214 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -273,27 +273,6 @@ typedef struct tagSTxDesc {
 STxDesc, *PSTxDesc;
 typedef const STxDesc *PCSTxDesc;
 
-typedef struct tagSTxSyncDesc {
-	volatile    STDES0  m_td0TD0;
-	volatile    STDES1  m_td1TD1;
-	volatile    u32 buff_addr; /* pointer to logical buffer */
-	volatile    u32 next_desc; /* pointer to next logical descriptor */
-	volatile    unsigned short m_wFIFOCtl;
-	volatile    unsigned short m_wTimeStamp;
-	struct tagSTxSyncDesc *next __aligned(8);
-	volatile    PDEVICE_TD_INFO pTDInfo __aligned(8);
-} __attribute__ ((__packed__))
-STxSyncDesc, *PSTxSyncDesc;
-typedef const STxSyncDesc *PCSTxSyncDesc;
-
-/* RsvTime buffer header */
-typedef struct tagSRrvTime_atim {
-	unsigned short wCTSTxRrvTime_ba;
-	unsigned short wTxRrvTime_a;
-} __attribute__ ((__packed__))
-SRrvTime_atim, *PSRrvTime_atim;
-typedef const SRrvTime_atim *PCSRrvTime_atim;
-
 /* Length, Service, and Signal fields of Phy for Tx */
 struct vnt_phy_field {
 	u8 signal;
@@ -307,42 +286,4 @@ union vnt_phy_field_swap {
 	u32 field_write;
 };
 
-/* Tx FIFO header */
-typedef struct tagSTxBufHead {
-	u32 adwTxKey[4];
-	unsigned short wFIFOCtl;
-	unsigned short wTimeStamp;
-	unsigned short wFragCtl;
-	unsigned char byTxPower;
-	unsigned char wReserved;
-} __attribute__ ((__packed__))
-STxBufHead, *PSTxBufHead;
-typedef const STxBufHead *PCSTxBufHead;
-
-typedef struct tagSBEACONCtl {
-	u32 BufReady:1;
-	u32 TSF:15;
-	u32 BufLen:11;
-	u32 Reserved:5;
-} __attribute__ ((__packed__))
-SBEACONCtl;
-
-typedef struct tagSSecretKey {
-	u32 dwLowDword;
-	unsigned char byHighByte;
-} __attribute__ ((__packed__))
-SSecretKey;
-
-typedef struct tagSKeyEntry {
-	unsigned char abyAddrHi[2];
-	unsigned short wKCTL;
-	unsigned char abyAddrLo[4];
-	u32 dwKey0[4];
-	u32 dwKey1[4];
-	u32 dwKey2[4];
-	u32 dwKey3[4];
-	u32 dwKey4[4];
-} __attribute__ ((__packed__))
-SKeyEntry;
-
 #endif /* __DESC_H__ */
-- 
2.1.4

