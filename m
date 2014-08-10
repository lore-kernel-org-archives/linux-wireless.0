Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:59221 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaHJOrz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2014 10:47:55 -0400
Received: by mail-wi0-f173.google.com with SMTP id f8so3096780wiw.6
        for <linux-wireless@vger.kernel.org>; Sun, 10 Aug 2014 07:47:54 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/9] staging: vt6655: baseband replace PSDevice
Date: Sun, 10 Aug 2014 15:46:56 +0100
Message-Id: <1407682023-2865-2-git-send-email-tvboxspy@gmail.com> (sfid-20140810_164803_917189_22ACB42D)
In-Reply-To: <1407682023-2865-1-git-send-email-tvboxspy@gmail.com>
References: <1407682023-2865-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Coverting all functions to struct vnt_private.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/baseband.c | 30 +++++++++++++++---------------
 drivers/staging/vt6655/baseband.h | 17 +++++++++--------
 2 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index f212b88..3d76ed5 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -1711,18 +1711,18 @@ static const unsigned short awcFrameTime[MAX_RATE] =
 
 static
 unsigned long
-s_ulGetRatio(PSDevice pDevice);
+s_ulGetRatio(struct vnt_private *pDevice);
 
 static
 void
 s_vChangeAntenna(
-	PSDevice pDevice
+	struct vnt_private *pDevice
 );
 
 static
 void
 s_vChangeAntenna(
-	PSDevice pDevice
+	struct vnt_private *pDevice
 )
 {
 	if (pDevice->dwRxAntennaSel == 0) {
@@ -1827,7 +1827,7 @@ BBuGetFrameTime(
  */
 void
 BBvCalculateParameter(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	unsigned int cbFrameLength,
 	unsigned short wRate,
 	unsigned char byPacketType,
@@ -2115,7 +2115,7 @@ bool BBbIsRegBitsOff(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned ch
  *
  */
 
-bool BBbVT3253Init(PSDevice pDevice)
+bool BBbVT3253Init(struct vnt_private *pDevice)
 {
 	bool bResult = true;
 	int        ii;
@@ -2310,7 +2310,7 @@ void BBvReadAllRegs(void __iomem *dwIoBase, unsigned char *pbyBBRegs)
  *
  */
 
-void BBvLoopbackOn(PSDevice pDevice)
+void BBvLoopbackOn(struct vnt_private *pDevice)
 {
 	unsigned char byData;
 	void __iomem *dwIoBase = pDevice->PortOffset;
@@ -2363,7 +2363,7 @@ void BBvLoopbackOn(PSDevice pDevice)
  * Return Value: none
  *
  */
-void BBvLoopbackOff(PSDevice pDevice)
+void BBvLoopbackOff(struct vnt_private *pDevice)
 {
 	unsigned char byData;
 	void __iomem *dwIoBase = pDevice->PortOffset;
@@ -2398,7 +2398,7 @@ void BBvLoopbackOff(PSDevice pDevice)
  *
  */
 void
-BBvSetShortSlotTime(PSDevice pDevice)
+BBvSetShortSlotTime(struct vnt_private *pDevice)
 {
 	unsigned char byBBRxConf = 0;
 	unsigned char byBBVGA = 0;
@@ -2418,7 +2418,7 @@ BBvSetShortSlotTime(PSDevice pDevice)
 	BBbWriteEmbedded(pDevice->PortOffset, 0x0A, byBBRxConf); /* CR10 */
 }
 
-void BBvSetVGAGainOffset(PSDevice pDevice, unsigned char byData)
+void BBvSetVGAGainOffset(struct vnt_private *pDevice, unsigned char byData)
 {
 	unsigned char byBBRxConf = 0;
 
@@ -2594,7 +2594,7 @@ BBvExitDeepSleep(void __iomem *dwIoBase, unsigned char byLocalID)
 
 static
 unsigned long
-s_ulGetRatio(PSDevice pDevice)
+s_ulGetRatio(struct vnt_private *pDevice)
 {
 	unsigned long ulRatio = 0;
 	unsigned long ulMaxPacket;
@@ -2689,7 +2689,7 @@ s_ulGetRatio(PSDevice pDevice)
 }
 
 void
-BBvClearAntDivSQ3Value(PSDevice pDevice)
+BBvClearAntDivSQ3Value(struct vnt_private *pDevice)
 {
 	unsigned int ii;
 
@@ -2713,8 +2713,8 @@ BBvClearAntDivSQ3Value(PSDevice pDevice)
  *
  */
 
-void
-BBvAntennaDiversity(PSDevice pDevice, unsigned char byRxRate, unsigned char bySQ3)
+void BBvAntennaDiversity(struct vnt_private *pDevice,
+			 unsigned char byRxRate, unsigned char bySQ3)
 {
 	if ((byRxRate >= MAX_RATE) || (pDevice->wAntDiversityMaxRate >= MAX_RATE))
 		return;
@@ -2798,7 +2798,7 @@ TimerSQ3CallBack(
 	void *hDeviceContext
 )
 {
-	PSDevice        pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "TimerSQ3CallBack...");
 	spin_lock_irq(&pDevice->lock);
@@ -2840,7 +2840,7 @@ TimerState1CallBack(
 	void *hDeviceContext
 )
 {
-	PSDevice        pDevice = (PSDevice)hDeviceContext;
+	struct vnt_private *pDevice = hDeviceContext;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "TimerState1CallBack...");
 
diff --git a/drivers/staging/vt6655/baseband.h b/drivers/staging/vt6655/baseband.h
index fcf1f93..6b43885 100644
--- a/drivers/staging/vt6655/baseband.h
+++ b/drivers/staging/vt6655/baseband.h
@@ -78,7 +78,7 @@ BBuGetFrameTime(
 
 void
 BBvCalculateParameter(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	unsigned int cbFrameLength,
 	unsigned short wRate,
 	unsigned char byPacketType,
@@ -91,15 +91,15 @@ bool BBbReadEmbedded(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned ch
 bool BBbWriteEmbedded(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned char byData);
 
 void BBvReadAllRegs(void __iomem *dwIoBase, unsigned char *pbyBBRegs);
-void BBvLoopbackOn(PSDevice pDevice);
-void BBvLoopbackOff(PSDevice pDevice);
-void BBvSetShortSlotTime(PSDevice pDevice);
+void BBvLoopbackOn(struct vnt_private *pDevice);
+void BBvLoopbackOff(struct vnt_private *pDevice);
+void BBvSetShortSlotTime(struct vnt_private *pDevice);
 bool BBbIsRegBitsOn(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned char byTestBits);
 bool BBbIsRegBitsOff(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned char byTestBits);
-void BBvSetVGAGainOffset(PSDevice pDevice, unsigned char byData);
+void BBvSetVGAGainOffset(struct vnt_private *pDevice, unsigned char byData);
 
 // VT3253 Baseband
-bool BBbVT3253Init(PSDevice pDevice);
+bool BBbVT3253Init(struct vnt_private *pDevice);
 void BBvSoftwareReset(void __iomem *dwIoBase);
 void BBvPowerSaveModeON(void __iomem *dwIoBase);
 void BBvPowerSaveModeOFF(void __iomem *dwIoBase);
@@ -120,8 +120,9 @@ TimerState1CallBack(
 	void *hDeviceContext
 );
 
-void BBvAntennaDiversity(PSDevice pDevice, unsigned char byRxRate, unsigned char bySQ3);
+void BBvAntennaDiversity(struct vnt_private *pDevice,
+			 unsigned char byRxRate, unsigned char bySQ3);
 void
-BBvClearAntDivSQ3Value(PSDevice pDevice);
+BBvClearAntDivSQ3Value(struct vnt_private *pDevice);
 
 #endif // __BASEBAND_H__
-- 
1.9.1

