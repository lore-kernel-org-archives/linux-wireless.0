Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:38540 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbaJYTYp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:24:45 -0400
Received: by mail-wg0-f43.google.com with SMTP id n12so3131998wgh.14
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:24:44 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 44/48] staging: vt6655: remove typedef void *TimerFunction
Date: Sat, 25 Oct 2014 09:40:22 +0100
Message-Id: <1414226426-5811-45-git-send-email-tvboxspy@gmail.com> (sfid-20141025_212454_288016_C46A2C52)
In-Reply-To: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
References: <1414226426-5811-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Covert functions TimerSQ3CallBack and TimerState1CallBack to
the correct type for struct timer_list.function to remove
the cast altogether.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/baseband.c    | 8 ++++----
 drivers/staging/vt6655/baseband.h    | 4 ++--
 drivers/staging/vt6655/device_main.c | 6 +++---
 drivers/staging/vt6655/wmgr.h        | 1 -
 4 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index ed78505..b04dfd9 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -2781,10 +2781,10 @@ void BBvAntennaDiversity(struct vnt_private *pDevice,
 
 void
 TimerSQ3CallBack(
-	void *hDeviceContext
+	unsigned long data
 )
 {
-	struct vnt_private *pDevice = hDeviceContext;
+	struct vnt_private *pDevice = (struct vnt_private *)data;
 	unsigned long flags;
 
 	pr_debug("TimerSQ3CallBack...\n");
@@ -2827,10 +2827,10 @@ TimerSQ3CallBack(
 
 void
 TimerState1CallBack(
-	void *hDeviceContext
+	unsigned long data
 )
 {
-	struct vnt_private *pDevice = hDeviceContext;
+	struct vnt_private *pDevice = (struct vnt_private *)data;
 	unsigned long flags;
 
 	pr_debug("TimerState1CallBack...\n");
diff --git a/drivers/staging/vt6655/baseband.h b/drivers/staging/vt6655/baseband.h
index 2d7a3e2..772ea0d 100644
--- a/drivers/staging/vt6655/baseband.h
+++ b/drivers/staging/vt6655/baseband.h
@@ -103,12 +103,12 @@ void BBvExitDeepSleep(void __iomem *dwIoBase, unsigned char byLocalID);
 
 void
 TimerSQ3CallBack(
-	void *hDeviceContext
+	unsigned long
 );
 
 void
 TimerState1CallBack(
-	void *hDeviceContext
+	unsigned long
 );
 
 void BBvAntennaDiversity(struct vnt_private *pDevice,
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 9755856..b469872 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -625,17 +625,17 @@ static void device_init_diversity_timer(struct vnt_private *pDevice)
 {
 	init_timer(&pDevice->TimerSQ3Tmax1);
 	pDevice->TimerSQ3Tmax1.data = (unsigned long) pDevice;
-	pDevice->TimerSQ3Tmax1.function = (TimerFunction)TimerSQ3CallBack;
+	pDevice->TimerSQ3Tmax1.function = TimerSQ3CallBack;
 	pDevice->TimerSQ3Tmax1.expires = RUN_AT(HZ);
 
 	init_timer(&pDevice->TimerSQ3Tmax2);
 	pDevice->TimerSQ3Tmax2.data = (unsigned long) pDevice;
-	pDevice->TimerSQ3Tmax2.function = (TimerFunction)TimerSQ3CallBack;
+	pDevice->TimerSQ3Tmax2.function = TimerSQ3CallBack;
 	pDevice->TimerSQ3Tmax2.expires = RUN_AT(HZ);
 
 	init_timer(&pDevice->TimerSQ3Tmax3);
 	pDevice->TimerSQ3Tmax3.data = (unsigned long) pDevice;
-	pDevice->TimerSQ3Tmax3.function = (TimerFunction)TimerState1CallBack;
+	pDevice->TimerSQ3Tmax3.function = TimerState1CallBack;
 	pDevice->TimerSQ3Tmax3.expires = RUN_AT(HZ);
 }
 
diff --git a/drivers/staging/vt6655/wmgr.h b/drivers/staging/vt6655/wmgr.h
index 8f9748b..74f1f16 100644
--- a/drivers/staging/vt6655/wmgr.h
+++ b/drivers/staging/vt6655/wmgr.h
@@ -72,6 +72,5 @@
 
 /*---------------------  Export Types  ------------------------------*/
 #define timer_expire(timer, next_tick)   mod_timer(&timer, RUN_AT(next_tick))
-typedef void (*TimerFunction)(unsigned long);
 
 #endif // __WMGR_H__
-- 
1.9.1

