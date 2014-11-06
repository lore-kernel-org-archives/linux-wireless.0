Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:37008 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaKFUCc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 15:02:32 -0500
Received: by mail-wg0-f51.google.com with SMTP id l18so2019407wgh.24
        for <linux-wireless@vger.kernel.org>; Thu, 06 Nov 2014 12:02:30 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/6] staging: vt6655: baseband.h remove pDevice from struct vnt_private pointer
Date: Thu,  6 Nov 2014 20:02:00 +0000
Message-Id: <1415304125-5165-1-git-send-email-tvboxspy@gmail.com> (sfid-20141106_210258_810341_ECFE645D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/baseband.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6655/baseband.h b/drivers/staging/vt6655/baseband.h
index 6ce856c..c41bc33 100644
--- a/drivers/staging/vt6655/baseband.h
+++ b/drivers/staging/vt6655/baseband.h
@@ -80,11 +80,11 @@ void vnt_get_phy_field(struct vnt_private *, u32 frame_length,
 bool BBbReadEmbedded(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned char *pbyData);
 bool BBbWriteEmbedded(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned char byData);
 
-void BBvSetShortSlotTime(struct vnt_private *pDevice);
-void BBvSetVGAGainOffset(struct vnt_private *pDevice, unsigned char byData);
+void BBvSetShortSlotTime(struct vnt_private *);
+void BBvSetVGAGainOffset(struct vnt_private *, unsigned char byData);
 
 /* VT3253 Baseband */
-bool BBbVT3253Init(struct vnt_private *pDevice);
+bool BBbVT3253Init(struct vnt_private *);
 void BBvSoftwareReset(void __iomem *dwIoBase);
 void BBvPowerSaveModeON(void __iomem *dwIoBase);
 void BBvPowerSaveModeOFF(void __iomem *dwIoBase);
@@ -105,9 +105,9 @@ TimerState1CallBack(
 	unsigned long
 );
 
-void BBvAntennaDiversity(struct vnt_private *pDevice,
+void BBvAntennaDiversity(struct vnt_private *,
 			 unsigned char byRxRate, unsigned char bySQ3);
 void
-BBvClearAntDivSQ3Value(struct vnt_private *pDevice);
+BBvClearAntDivSQ3Value(struct vnt_private *);
 
 #endif /* __BASEBAND_H__ */
-- 
2.1.0

