Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38242 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab2KKPZj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2012 10:25:39 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so3639173wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 11 Nov 2012 07:25:37 -0800 (PST)
Message-ID: <1352647531.6460.6.camel@canaries32-MCP7A> (sfid-20121111_162542_655706_B7F7A36A)
Subject: [PATCH 03/14] staging: vt6656: 64bit fixes: desh.h fix size.
 replace DWORD with u32.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 11 Nov 2012 15:25:31 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Fixes size of long issues replace DWORD with u32.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/staging/vt6656/desc.h | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/vt6656/desc.h b/drivers/staging/vt6656/desc.h
index b68b2ec..5007e98 100644
--- a/drivers/staging/vt6656/desc.h
+++ b/drivers/staging/vt6656/desc.h
@@ -298,7 +298,7 @@ typedef const SCTS_FB *PCSCTS_FB;
 // Tx FIFO header
 //
 typedef struct tagSTxBufHead {
-    DWORD   adwTxKey[4];
+	u32 adwTxKey[4];
     WORD    wFIFOCtl;
     WORD    wTimeStamp;
     WORD    wFragCtl;
@@ -376,24 +376,24 @@ typedef const STxDataHead_a_FB *PCSTxDataHead_a_FB;
 // MICHDR data header
 //
 typedef struct tagSMICHDRHead {
-    DWORD   adwHDR0[4];
-    DWORD   adwHDR1[4];
-    DWORD   adwHDR2[4];
+	u32 adwHDR0[4];
+	u32 adwHDR1[4];
+	u32 adwHDR2[4];
 } __attribute__ ((__packed__))
 SMICHDRHead, *PSMICHDRHead;
 
 typedef const SMICHDRHead *PCSMICHDRHead;
 
 typedef struct tagSBEACONCtl {
-    DWORD   BufReady : 1;
-    DWORD   TSF : 15;
-    DWORD   BufLen : 11;
-    DWORD   Reserved : 5;
+	u32 BufReady:1;
+	u32 TSF:15;
+	u32 BufLen:11;
+	u32 Reserved:5;
 } __attribute__ ((__packed__))
 SBEACONCtl;
 
 typedef struct tagSSecretKey {
-    DWORD   dwLowDword;
+	u32 dwLowDword;
     BYTE    byHighByte;
 } __attribute__ ((__packed__))
 SSecretKey;
@@ -402,11 +402,11 @@ typedef struct tagSKeyEntry {
     BYTE  abyAddrHi[2];
     WORD  wKCTL;
     BYTE  abyAddrLo[4];
-    DWORD dwKey0[4];
-    DWORD dwKey1[4];
-    DWORD dwKey2[4];
-    DWORD dwKey3[4];
-    DWORD dwKey4[4];
+	u32 dwKey0[4];
+	u32 dwKey1[4];
+	u32 dwKey2[4];
+	u32 dwKey3[4];
+	u32 dwKey4[4];
 } __attribute__ ((__packed__))
 SKeyEntry;
 
-- 
1.8.0





