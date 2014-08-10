Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:38025 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaHJLWq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2014 07:22:46 -0400
Received: by mail-we0-f175.google.com with SMTP id t60so7461396wes.34
        for <linux-wireless@vger.kernel.org>; Sun, 10 Aug 2014 04:22:44 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/7] staging: vt6655: BSSvSecondTxData remove #if 1 else directive
Date: Sun, 10 Aug 2014 12:21:57 +0100
Message-Id: <1407669722-2682-2-git-send-email-tvboxspy@gmail.com> (sfid-20140810_132250_444441_269F12CA)
In-Reply-To: <1407669722-2682-1-git-send-email-tvboxspy@gmail.com>
References: <1407669722-2682-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a code alignment error after this directive realign
code

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/wcmd.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/vt6655/wcmd.c b/drivers/staging/vt6655/wcmd.c
index 16ed097..b7e68a0 100644
--- a/drivers/staging/vt6655/wcmd.c
+++ b/drivers/staging/vt6655/wcmd.c
@@ -1001,19 +1001,17 @@ BSSvSecondTxData(
 	}
 
 	spin_lock_irq(&pDevice->lock);
-#if 1
-	if ((pDevice->bLinkPass && (pMgmt->eAuthenMode < WMAC_AUTH_WPA)) ||  //open && sharekey linking
-	    pDevice->fWPA_Authened) {   //wpa linking
-#else
-		if (pDevice->bLinkPass == true) {
-#endif
-			pDevice->fTxDataInSleep = true;
-			PSbSendNullPacket(pDevice);      //send null packet
-			pDevice->fTxDataInSleep = false;
-		}
-		spin_unlock_irq(&pDevice->lock);
 
-		pDevice->sTimerTxData.expires = RUN_AT(10*HZ);      //10s callback
-		add_timer(&pDevice->sTimerTxData);
-		return;
+	/* open && sharekey linking */
+	if ((pDevice->bLinkPass && (pMgmt->eAuthenMode < WMAC_AUTH_WPA)) ||
+	    pDevice->fWPA_Authened) {   /* wpa linking */
+		pDevice->fTxDataInSleep = true;
+		PSbSendNullPacket(pDevice);	/* send null packet */
+		pDevice->fTxDataInSleep = false;
 	}
+
+	spin_unlock_irq(&pDevice->lock);
+
+	pDevice->sTimerTxData.expires = RUN_AT(10*HZ); /* 10s callback */
+	add_timer(&pDevice->sTimerTxData);
+}
-- 
1.9.1

