Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:57386 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaJYTF2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:05:28 -0400
Received: by mail-wi0-f171.google.com with SMTP id em10so3489191wid.10
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:05:27 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 30/31] staging: vt6655: baseband.c timers replace spin lock
Date: Sat, 25 Oct 2014 09:20:40 +0100
Message-Id: <1414225241-5480-31-git-send-email-tvboxspy@gmail.com> (sfid-20141025_210532_300200_159FBD9E)
In-Reply-To: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
References: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
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
1.9.1

