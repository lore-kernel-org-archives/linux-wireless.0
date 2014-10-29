Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:55757 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809AbaJ2RqG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:46:06 -0400
Received: by mail-wg0-f43.google.com with SMTP id n12so2484113wgh.16
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:46:05 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 30/34] staging: vt6655: baseband.c timers replace spin lock
Date: Wed, 29 Oct 2014 17:44:05 +0000
Message-Id: <1414604649-9105-31-git-send-email-tvboxspy@gmail.com> (sfid-20141029_184621_559624_E60385DE)
In-Reply-To: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
References: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use spin_lock_irqsave and spin_unlock_irqrestore

in functions TimerSQ3CallBack and TimerState1CallBack

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/baseband.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index 8adeea4..c7ad927 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -2786,9 +2786,11 @@ TimerSQ3CallBack(
 )
 {
 	struct vnt_private *pDevice = hDeviceContext;
+	unsigned long flags;
 
 	pr_debug("TimerSQ3CallBack...\n");
-	spin_lock_irq(&pDevice->lock);
+
+	spin_lock_irqsave(&pDevice->lock, flags);
 
 	pr_debug("3.[%08x][%08x], %d\n",
 		 (int)pDevice->ulRatio_State0, (int)pDevice->ulRatio_State1,
@@ -2803,7 +2805,7 @@ TimerSQ3CallBack(
 	add_timer(&pDevice->TimerSQ3Tmax3);
 	add_timer(&pDevice->TimerSQ3Tmax2);
 
-	spin_unlock_irq(&pDevice->lock);
+	spin_unlock_irqrestore(&pDevice->lock, flags);
 }
 
 /*+
@@ -2830,10 +2832,12 @@ TimerState1CallBack(
 )
 {
 	struct vnt_private *pDevice = hDeviceContext;
+	unsigned long flags;
 
 	pr_debug("TimerState1CallBack...\n");
 
-	spin_lock_irq(&pDevice->lock);
+	spin_lock_irqsave(&pDevice->lock, flags);
+
 	if (pDevice->uDiversityCnt < pDevice->ulDiversityMValue/100) {
 		s_vChangeAntenna(pDevice);
 		pDevice->TimerSQ3Tmax3.expires =  RUN_AT(pDevice->byTMax3 * HZ);
@@ -2864,5 +2868,6 @@ TimerState1CallBack(
 	}
 	pDevice->byAntennaState = 0;
 	BBvClearAntDivSQ3Value(pDevice);
-	spin_unlock_irq(&pDevice->lock);
+
+	spin_unlock_irqrestore(&pDevice->lock, flags);
 }
-- 
2.1.0

