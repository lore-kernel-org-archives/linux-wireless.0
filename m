Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37381 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaHJLWv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2014 07:22:51 -0400
Received: by mail-wi0-f179.google.com with SMTP id f8so2935339wiw.0
        for <linux-wireless@vger.kernel.org>; Sun, 10 Aug 2014 04:22:50 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/7] staging: vt6655: CARDbSetBeaconPeriod call CARDbGetCurrentTSF to get TBTT
Date: Sun, 10 Aug 2014 12:22:00 +0100
Message-Id: <1407669722-2682-5-git-send-email-tvboxspy@gmail.com> (sfid-20140810_132254_749221_E54ECE09)
In-Reply-To: <1407669722-2682-1-git-send-email-tvboxspy@gmail.com>
References: <1407669722-2682-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is already a function to get next TBTT.

Replace code with CARDqGetNextTBTT.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index a5da3d2..931fca8 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -606,29 +606,11 @@ bool CARDbUpdateTSF(void *pDeviceHandler, unsigned char byRxRate, u64 qwBSSTimes
 bool CARDbSetBeaconPeriod(void *pDeviceHandler, unsigned short wBeaconInterval)
 {
 	PSDevice    pDevice = (PSDevice) pDeviceHandler;
-	unsigned int uBeaconInterval = 0;
-	unsigned int uLowNextTBTT = 0;
-	unsigned int uHighRemain = 0;
-	unsigned int uLowRemain = 0;
 	u64 qwNextTBTT = 0;
 
 	CARDbGetCurrentTSF(pDevice->PortOffset, &qwNextTBTT); //Get Local TSF counter
-	uBeaconInterval = wBeaconInterval * 1024;
-	// Next TBTT = ((local_current_TSF / beacon_interval) + 1) * beacon_interval
-	uLowNextTBTT = ((qwNextTBTT & 0xffffffffULL) >> 10) << 10;
-	uLowRemain = (uLowNextTBTT) % uBeaconInterval;
-	// high dword (mod) bcn
-	uHighRemain = (((0xffffffff % uBeaconInterval) + 1) * (u32)(qwNextTBTT >> 32))
-		% uBeaconInterval;
-	uLowRemain = (uHighRemain + uLowRemain) % uBeaconInterval;
-	uLowRemain = uBeaconInterval - uLowRemain;
-
-	// check if carry when add one beacon interval
-	if ((~uLowNextTBTT) < uLowRemain)
-		qwNextTBTT = ((qwNextTBTT >> 32) + 1) << 32;
-
-	qwNextTBTT = (qwNextTBTT & 0xffffffff00000000ULL) |
-			(u64)(uLowNextTBTT + uLowRemain);
+
+	qwNextTBTT = CARDqGetNextTBTT(qwNextTBTT, wBeaconInterval);
 
 	// set HW beacon interval
 	VNSvOutPortW(pDevice->PortOffset + MAC_REG_BI, wBeaconInterval);
-- 
1.9.1

