Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:57454 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab2KKQIF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2012 11:08:05 -0500
Received: by mail-ea0-f174.google.com with SMTP id c13so2077811eaa.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Nov 2012 08:08:03 -0800 (PST)
Message-ID: <1352650077.6460.33.camel@canaries32-MCP7A> (sfid-20121111_170809_662632_50828EC5)
Subject: [PATCH 14/14] staging: vt6656: 64bit fixes: vCommandTimerWait
 change calculation of timer.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 11 Nov 2012 16:07:57 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


The timer appears to run too fast/race on 64 bit systems.

Using msecs_to_jiffies seems to cause a deadlock on 64 bit.

A calculation of (MSecond * HZ) / 1000 appears to run satisfactory.

Change BSSIDInfoCount to u32.

After this patch the driver can be successfully connect on little endian 64/32 bit systems.


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/wcmd.c | 20 +++++++++++---------
 drivers/staging/vt6656/wpa2.h |  4 ++--
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 586fbe1..b854d7e 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -316,17 +316,19 @@ s_MgrMakeProbeRequest(
     return pTxPacket;
 }
 
-void vCommandTimerWait(void *hDeviceContext, unsigned int MSecond)
+void vCommandTimerWait(void *hDeviceContext, unsigned long MSecond)
 {
-    PSDevice        pDevice = (PSDevice)hDeviceContext;
+	PSDevice pDevice = (PSDevice)hDeviceContext;
 
-    init_timer(&pDevice->sTimerCommand);
-    pDevice->sTimerCommand.data = (unsigned long)pDevice;
-    pDevice->sTimerCommand.function = (TimerFunction)vRunCommand;
-    // RUN_AT :1 msec ~= (HZ/1024)
-    pDevice->sTimerCommand.expires = (unsigned int)RUN_AT((MSecond * HZ) >> 10);
-    add_timer(&pDevice->sTimerCommand);
-    return;
+	init_timer(&pDevice->sTimerCommand);
+
+	pDevice->sTimerCommand.data = (unsigned long)pDevice;
+	pDevice->sTimerCommand.function = (TimerFunction)vRunCommand;
+	pDevice->sTimerCommand.expires = RUN_AT((MSecond * HZ) / 1000);
+
+	add_timer(&pDevice->sTimerCommand);
+
+	return;
 }
 
 void vRunCommand(void *hDeviceContext)
diff --git a/drivers/staging/vt6656/wpa2.h b/drivers/staging/vt6656/wpa2.h
index 46c2959..c359252 100644
--- a/drivers/staging/vt6656/wpa2.h
+++ b/drivers/staging/vt6656/wpa2.h
@@ -45,8 +45,8 @@ typedef struct tagsPMKIDInfo {
 } PMKIDInfo, *PPMKIDInfo;
 
 typedef struct tagSPMKIDCache {
-    unsigned long       BSSIDInfoCount;
-    PMKIDInfo   BSSIDInfo[MAX_PMKID_CACHE];
+	u32 BSSIDInfoCount;
+	PMKIDInfo BSSIDInfo[MAX_PMKID_CACHE];
 } SPMKIDCache, *PSPMKIDCache;
 

-- 
1.8.0



