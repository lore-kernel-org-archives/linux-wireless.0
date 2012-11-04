Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56737 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab2KDR7P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Nov 2012 12:59:15 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so3458219wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 04 Nov 2012 09:59:14 -0800 (PST)
Message-ID: <1352051945.7322.2.camel@Route3278> (sfid-20121104_185938_351790_B5696051)
Subject: [PATCH] staging: vt6656: dead code
 byCntMeasure/TKIPCounterMeasuresInvoked
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 04 Nov 2012 17:59:05 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


remove TKIPCounterMeasuresInvoked and byCntMeasure

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h |    1 -
 drivers/staging/vt6656/mib.h    |    1 -
 drivers/staging/vt6656/rxtx.c   |    5 -----
 3 files changed, 7 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 8d9b9c1..f334e64 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -733,7 +733,6 @@ typedef struct __device_info {
     BYTE                    byKeyIndex;
 
     BOOL                    bAES;
-    BYTE                    byCntMeasure;
 
     unsigned int                    uKeyLength;
     BYTE                    abyKey[WLAN_WEP232_KEYLEN];
diff --git a/drivers/staging/vt6656/mib.h b/drivers/staging/vt6656/mib.h
index 82d69a9..85c28e9 100644
--- a/drivers/staging/vt6656/mib.h
+++ b/drivers/staging/vt6656/mib.h
@@ -68,7 +68,6 @@ typedef struct tagSDot11Counters {
     unsigned long long   TKIPLocalMICFailures;
     unsigned long long   TKIPRemoteMICFailures;
     unsigned long long   TKIPICVErrors;
-    unsigned long long   TKIPCounterMeasuresInvoked;
     unsigned long long   TKIPReplays;
     unsigned long long   CCMPFormatErrors;
     unsigned long long   CCMPReplays;
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index a54c0c1..3a4933e 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -3033,11 +3033,6 @@ int nsDMA_tx_packet(PSDevice pDevice, unsigned int uDMAIdx, struct sk_buff *skb)
                 }
             }
 
-            if (pDevice->byCntMeasure == 2) {
-                bNeedDeAuth = TRUE;
-                pDevice->s802_11Counter.TKIPCounterMeasuresInvoked++;
-            }
-
             if (pDevice->bEnableHostWEP) {
                 if ((uNodeIndex != 0) &&
                     (pMgmt->sNodeDBTable[uNodeIndex].dwKeyIndex & PAIRWISE_KEY)) {
-- 
1.7.10.4


