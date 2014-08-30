Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:52133 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbaH3V07 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Aug 2014 17:26:59 -0400
Received: by mail-wg0-f42.google.com with SMTP id b13so3594780wgh.13
        for <linux-wireless@vger.kernel.org>; Sat, 30 Aug 2014 14:26:58 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 21/23] stgaing: vt6655: remove unused variable wCTSDuration
Date: Sat, 30 Aug 2014 22:25:47 +0100
Message-Id: <1409433949-5468-21-git-send-email-tvboxspy@gmail.com> (sfid-20140830_234533_145086_6BEB89AD)
In-Reply-To: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
References: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wCTSDuration is always set to 0.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h      | 1 -
 drivers/staging/vt6655/device_main.c | 1 -
 drivers/staging/vt6655/rxtx.c        | 7 +------
 3 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 8ac7901..15303d9 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -476,7 +476,6 @@ struct vnt_private {
 	unsigned short wMaxTransmitMSDULifetime;
 	unsigned char abyBSSID[ETH_ALEN];
 	unsigned char abyDesireBSSID[ETH_ALEN];
-	unsigned short wCTSDuration;       // update while speed change
 	unsigned short wACKDuration;       // update while speed change
 	unsigned short wRTSTransmitLen;    // update while speed change
 	unsigned char byRTSServiceField;  // update while speed change
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 34a70b0..0473702 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -387,7 +387,6 @@ device_set_options(struct vnt_private *pDevice)
 	pDevice->byAutoFBCtrl = AUTO_FB_0;
 	pDevice->bUpdateBBVGA = true;
 	pDevice->byFOETuning = 0;
-	pDevice->wCTSDuration = 0;
 	pDevice->byPreambleType = 0;
 
 	pr_debug(" uChannel= %d\n", (int)pDevice->uChannel);
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 6b22f09..3c8c499 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -1051,22 +1051,17 @@ s_vFillCTSHead(
 
 			buf->duration_ba = (u16)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA, cbFrameLength,
 								     byPktType, wCurrentRate, bNeedAck, byFBOption);
-			buf->duration_ba += pDevice->wCTSDuration;
-
 			buf->duration_ba = cpu_to_le16(buf->duration_ba);
 			/* Get CTSDuration_ba_f0 */
 			buf->cts_duration_ba_f0 = (u16)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA_F0, cbFrameLength,
 									    byPktType, wCurrentRate,
 									    bNeedAck, byFBOption);
 
-			buf->cts_duration_ba_f0 += pDevice->wCTSDuration;
-
 			buf->cts_duration_ba_f0 = cpu_to_le16(buf->cts_duration_ba_f0);
 			//Get CTSDuration_ba_f1
 			buf->cts_duration_ba_f1 = (u16)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA_F1, cbFrameLength,
 									    byPktType, wCurrentRate,
 									    bNeedAck, byFBOption);
-			buf->cts_duration_ba_f1 += pDevice->wCTSDuration;
 
 			buf->cts_duration_ba_f1 = cpu_to_le16(buf->cts_duration_ba_f1);
 			/* Get CTS Frame body */
@@ -1091,7 +1086,7 @@ s_vFillCTSHead(
 				cpu_to_le16((u16)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA, cbFrameLength,
 								      byPktType, wCurrentRate, bNeedAck,
 								      byFBOption));
-			buf->duration_ba += pDevice->wCTSDuration;
+
 			buf->duration_ba = cpu_to_le16(buf->duration_ba);
 
 			/* Get CTS Frame body */
-- 
1.9.1

