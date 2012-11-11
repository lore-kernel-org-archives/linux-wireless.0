Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:55684 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab2KKPU7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2012 10:20:59 -0500
Received: by mail-ea0-f174.google.com with SMTP id c13so2068635eaa.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Nov 2012 07:20:58 -0800 (PST)
Message-ID: <1352647252.6460.2.camel@canaries32-MCP7A> (sfid-20121111_162103_511173_A4AB5B5E)
Subject: [PATCH 01/14] staging: vt6656: 64 bit- Correctly address void
 structure.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 11 Nov 2012 15:20:52 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Fixes 64 bit deadlock on successful association.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/staging/vt6656/rxtx.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index ca05c4f..d121285 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1452,12 +1452,10 @@ s_bPacketToWirelessUsb(
 

     pvRrvTime = pMICHDR = pvRTS = pvCTS = pvTxDataHd = NULL;
-    if ((bNeedEncryption) && (pTransmitKey != NULL))  {
-        if (((PSKeyTable) (pTransmitKey->pvKeyTable))->bSoftWEP == TRUE) {
-            // WEP 256
-            bSoftWEP = TRUE;
-        }
-    }
+	if (bNeedEncryption && pTransmitKey->pvKeyTable) {
+		if (((PSKeyTable)&pTransmitKey->pvKeyTable)->bSoftWEP == TRUE)
+			bSoftWEP = TRUE; /* WEP 256 */
+	}
 
     pTxBufHead = (PTX_BUFFER) usbPacketBuf;
     memset(pTxBufHead, 0, sizeof(TX_BUFFER));
-- 
1.8.0






