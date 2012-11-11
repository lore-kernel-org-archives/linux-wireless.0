Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:46729 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab2KKPe7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2012 10:34:59 -0500
Received: by mail-ea0-f174.google.com with SMTP id c13so2071429eaa.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Nov 2012 07:34:57 -0800 (PST)
Message-ID: <1352648091.6460.12.camel@canaries32-MCP7A> (sfid-20121111_163502_751679_34195351)
Subject: [PATCH 06/14] staging: vt6656: 64 bit fixes: rxtx.h Replace DWORD
 with u32.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 11 Nov 2012 15:34:51 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Size of long issues.

 Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/staging/vt6656/rxtx.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index f99acf1..dd2198a 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -61,9 +61,9 @@ typedef struct tagSCTSDataF {
 // MICHDR data header
 //
 typedef struct tagSMICHDR {
-    DWORD   adwHDR0[4];
-    DWORD   adwHDR1[4];
-    DWORD   adwHDR2[4];
+	u32 adwHDR0[4];
+	u32 adwHDR1[4];
+	u32 adwHDR2[4];
 } SMICHDR, *PSMICHDR;
 

@@ -630,7 +630,7 @@ typedef struct tagSTX_BUFFER
     BYTE                            byPKTNO;
     WORD                            wTxByteCount;
 
-    DWORD                           adwTxKey[4];
+	u32 adwTxKey[4];
     WORD                            wFIFOCtl;
     WORD                            wTimeStamp;
     WORD                            wFragCtl;
-- 
1.8.0




