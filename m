Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:43917 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaCFWpz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 17:45:55 -0500
Received: by mail-we0-f175.google.com with SMTP id q58so3957216wes.6
        for <linux-wireless@vger.kernel.org>; Thu, 06 Mar 2014 14:45:54 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/5] staging: vt6655: 64 bit Correct alignment of tx/rx structures.
Date: Thu,  6 Mar 2014 22:44:21 +0000
Message-Id: <1394145865-3748-1-git-send-email-tvboxspy@gmail.com> (sfid-20140306_234559_805157_4F88BD62)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Aligment of pointers on 64 bit is incorrect.

Align to 64 bit using aligned 8 bytes and remove structure packing.

This allows the device to run on both 32 and 64 bit

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 32d808e..f8e4148 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -276,9 +276,8 @@ typedef struct tagSRxDesc {
 	volatile SRDES1 m_rd1RD1;
 	volatile u32    buff_addr;
 	volatile u32    next_desc;
-	struct tagSRxDesc   *next;//4 bytes
-	volatile PDEVICE_RD_INFO    pRDInfo;//4 bytes
-	volatile u32    Reserved[2];//8 bytes
+	struct tagSRxDesc *next __aligned(8);
+	volatile PDEVICE_RD_INFO pRDInfo __aligned(8);
 } __attribute__ ((__packed__))
 SRxDesc, *PSRxDesc;
 typedef const SRxDesc *PCSRxDesc;
@@ -361,9 +360,8 @@ typedef struct tagSTxDesc {
 	volatile    STDES1  m_td1TD1;
 	volatile    u32    buff_addr;
 	volatile    u32    next_desc;
-	struct tagSTxDesc *next; //4 bytes
-	volatile    PDEVICE_TD_INFO pTDInfo;//4 bytes
-	volatile    u32    Reserved[2];//8 bytes
+	struct tagSTxDesc *next __aligned(8);
+	volatile    PDEVICE_TD_INFO pTDInfo __aligned(8);
 } __attribute__ ((__packed__))
 STxDesc, *PSTxDesc;
 typedef const STxDesc *PCSTxDesc;
@@ -375,9 +373,8 @@ typedef struct tagSTxSyncDesc {
 	volatile    u32 next_desc; // pointer to next logical descriptor
 	volatile    unsigned short m_wFIFOCtl;
 	volatile    unsigned short m_wTimeStamp;
-	struct tagSTxSyncDesc *next; //4 bytes
-	volatile    PDEVICE_TD_INFO pTDInfo;//4 bytes
-	volatile    u32 m_dwReserved2;
+	struct tagSTxSyncDesc *next __aligned(8);
+	volatile    PDEVICE_TD_INFO pTDInfo __aligned(8);
 } __attribute__ ((__packed__))
 STxSyncDesc, *PSTxSyncDesc;
 typedef const STxSyncDesc *PCSTxSyncDesc;
-- 
1.9.0

