Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45325 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab2KKPlc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2012 10:41:32 -0500
Received: by mail-wi0-f170.google.com with SMTP id hm9so1685576wib.1
        for <linux-wireless@vger.kernel.org>; Sun, 11 Nov 2012 07:41:30 -0800 (PST)
Message-ID: <1352648485.6460.16.camel@canaries32-MCP7A> (sfid-20121111_164135_042778_76257D34)
Subject: [PATCH 08/14] staging: vt6656: 64 bit fixes : correct all type sizes
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 11 Nov 2012 15:41:25 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


After this patch all BYTE/WORD/DWORD types can be replaced with the appropriate u sizes.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/ttype.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/ttype.h b/drivers/staging/vt6656/ttype.h
index 0f70562c..dfbf747 100644
--- a/drivers/staging/vt6656/ttype.h
+++ b/drivers/staging/vt6656/ttype.h
@@ -44,9 +44,9 @@ typedef int             BOOL;
 
 /****** Simple typedefs  ***************************************************/
 
-typedef unsigned char   BYTE;           //  8-bit
-typedef unsigned short  WORD;           // 16-bit
-typedef unsigned long   DWORD;          // 32-bit
+typedef u8 BYTE;
+typedef u16 WORD;
+typedef u32 DWORD;
 
 // QWORD is for those situation that we want
 // an 8-byte-aligned 8 byte long structure
@@ -62,8 +62,8 @@ typedef UQuadWord       QWORD;          // 64-bit
 
 /****** Common pointer types ***********************************************/
 
-typedef unsigned long   ULONG_PTR;      // 32-bit
-typedef unsigned long   DWORD_PTR;      // 32-bit
+typedef u32 ULONG_PTR;
+typedef u32 DWORD_PTR;
 
 // boolean pointer
 
-- 
1.8.0




