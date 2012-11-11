Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64855 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab2KKP2Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2012 10:28:16 -0500
Received: by mail-wi0-f178.google.com with SMTP id hr7so1749557wib.1
        for <linux-wireless@vger.kernel.org>; Sun, 11 Nov 2012 07:28:15 -0800 (PST)
Message-ID: <1352647688.6460.8.camel@canaries32-MCP7A> (sfid-20121111_162819_903941_425E946F)
Subject: [PATCH 04/14] staging: vt6656: 64 bit fixes: RXbBulkInProcessData
 Framesize
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 11 Nov 2012 15:28:08 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Size of long issues.

Framesize correction replace DWORD with u32.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/staging/vt6656/dpc.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index e1b0881..1ff6ea3 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -332,7 +332,7 @@ RXbBulkInProcessData (
     PBYTE           pbyFrame;
     BOOL            bDeFragRx = FALSE;
     unsigned int            cbHeaderOffset;
-    unsigned int            FrameSize;
+	u32 FrameSize;
     WORD            wEtherType = 0;
     signed int             iSANodeIndex = -1;
     signed int             iDANodeIndex = -1;
@@ -351,7 +351,7 @@ RXbBulkInProcessData (
     /* signed long ldBm = 0; */
     BOOL            bIsWEP = FALSE;
     BOOL            bExtIV = FALSE;
-    DWORD           dwWbkStatus;
+	u32 dwWbkStatus;
     PRCB            pRCBIndicate = pRCB;
     PBYTE           pbyDAddress;
     PWORD           pwPLCP_Length;
@@ -366,15 +366,15 @@ RXbBulkInProcessData (
 
     skb = pRCB->skb;
 
-    //[31:16]RcvByteCount ( not include 4-byte Status )
-    dwWbkStatus =  *( (PDWORD)(skb->data) );
-    FrameSize = (unsigned int)(dwWbkStatus >> 16);
-    FrameSize += 4;
+	/* [31:16]RcvByteCount ( not include 4-byte Status ) */
+	dwWbkStatus = *((u32 *)(skb->data));
+	FrameSize = dwWbkStatus >> 16;
+	FrameSize += 4;
 
-    if (BytesToIndicate != FrameSize) {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---------- WRONG Length 1 \n");
-        return FALSE;
-    }
+	if (BytesToIndicate != FrameSize) {
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"------- WRONG Length 1\n");
+		return FALSE;
+	}
 
     if ((BytesToIndicate > 2372) || (BytesToIndicate <= 40)) {
         // Frame Size error drop this packet.
-- 
1.8.0




