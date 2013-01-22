Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:44284 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab3AVUNm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2013 15:13:42 -0500
Received: by mail-bk0-f41.google.com with SMTP id jg9so3994999bkc.14
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2013 12:13:40 -0800 (PST)
Message-ID: <1358885614.5062.22.camel@canaries64> (sfid-20130122_211344_703546_6E991635)
Subject: [PATCH] staging: vt6656: Revert: 64bit fixes: dpc.c incorrect
 addressing of void structure.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Date: Tue, 22 Jan 2013 20:13:34 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


The patch was totally wrong and is reverted.

The problem was ultimately fixed by upstream commit.
1ee4c55fc9620451b2a825d793042a7e0775391b
staging: vt6656: Fix inconsistent structure packing

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: stable@vger.kernel.org # 3.8

---
 drivers/staging/vt6656/dpc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 6c98172..208be2c 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -1116,7 +1116,7 @@ static int s_bHandleRxEncryption(struct vnt_private *pDevice, u8 *pbyFrame,
     if (byDecMode == KEY_CTL_WEP) {
         // handle WEP
         if ((pDevice->byLocalID <= REV_ID_VT3253_A1) ||
-		(((PSKeyTable)(&pKey->pvKeyTable))->bSoftWEP == TRUE)) {
+		(((PSKeyTable)(pKey->pvKeyTable))->bSoftWEP == TRUE)) {
             // Software WEP
             // 1. 3253A
             // 2. WEP 256
@@ -1213,7 +1213,7 @@ static int s_bHostWepRxEncryption(struct vnt_private *pDevice, u8 *pbyFrame,
         // handle WEP
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"byDecMode == KEY_CTL_WEP\n");
         if ((pDevice->byLocalID <= REV_ID_VT3253_A1) ||
-		(((PSKeyTable)(&pKey->pvKeyTable))->bSoftWEP == TRUE) ||
+		(((PSKeyTable)(pKey->pvKeyTable))->bSoftWEP == TRUE) ||
             (bOnFly == FALSE)) {
             // Software WEP
             // 1. 3253A
-- 
1.8.0



