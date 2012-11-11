Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:34819 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab2KKPXI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2012 10:23:08 -0500
Received: by mail-ea0-f174.google.com with SMTP id c13so2069059eaa.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Nov 2012 07:23:06 -0800 (PST)
Message-ID: <1352647380.6460.4.camel@canaries32-MCP7A> (sfid-20121111_162311_582850_A18E88AB)
Subject: [PATCH 02/14] staging: vt6656: 64bit fixes: dpc.c incorrect
 addressing of void structure.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 11 Nov 2012 15:23:00 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Fixes the deadlock on 64 bit.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/staging/vt6656/dpc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 5ad7abb..e1b0881 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -1217,7 +1217,7 @@ static BOOL s_bHandleRxEncryption (
     if (byDecMode == KEY_CTL_WEP) {
         // handle WEP
         if ((pDevice->byLocalID <= REV_ID_VT3253_A1) ||
-            (((PSKeyTable)(pKey->pvKeyTable))->bSoftWEP == TRUE)) {
+		(((PSKeyTable)(&pKey->pvKeyTable))->bSoftWEP == TRUE)) {
             // Software WEP
             // 1. 3253A
             // 2. WEP 256
@@ -1324,9 +1324,9 @@ static BOOL s_bHostWepRxEncryption (
 
     if (byDecMode == KEY_CTL_WEP) {
         // handle WEP
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"byDecMode == KEY_CTL_WEP \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"byDecMode == KEY_CTL_WEP\n");
         if ((pDevice->byLocalID <= REV_ID_VT3253_A1) ||
-            (((PSKeyTable)(pKey->pvKeyTable))->bSoftWEP == TRUE) ||
+		(((PSKeyTable)(&pKey->pvKeyTable))->bSoftWEP == TRUE) ||
             (bOnFly == FALSE)) {
             // Software WEP
             // 1. 3253A
-- 
1.8.0





