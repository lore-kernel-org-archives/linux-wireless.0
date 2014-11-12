Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:34304 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbaKLVL4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 16:11:56 -0500
Received: by mail-wi0-f171.google.com with SMTP id r20so6269155wiv.16
        for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2014 13:11:55 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/8] staging: vt6655: rf remove __iomem *dwIoBase from functions
Date: Wed, 12 Nov 2014 21:11:10 +0000
Message-Id: <1415826675-8446-3-git-send-email-tvboxspy@gmail.com> (sfid-20141112_221159_813289_0FBBDAE9)
In-Reply-To: <1415826675-8446-1-git-send-email-tvboxspy@gmail.com>
References: <1415826675-8446-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

replacing with vnt_private and removing dereferencing from callers

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/channel.c |  8 +++++---
 drivers/staging/vt6655/rf.c      | 25 ++++++++++++++++---------
 drivers/staging/vt6655/rf.h      |  6 +++---
 3 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/vt6655/channel.c b/drivers/staging/vt6655/channel.c
index cc1bc94..c8f739d 100644
--- a/drivers/staging/vt6655/channel.c
+++ b/drivers/staging/vt6655/channel.c
@@ -188,14 +188,16 @@ bool set_channel(void *pDeviceHandler, unsigned int uConnectionChannel)
 	/* TX_PE will reserve 3 us for MAX2829 A mode only, it is for better TX throughput */
 
 	if (pDevice->byRFType == RF_AIROHA7230)
-		RFbAL7230SelectChannelPostProcess(pDevice->PortOffset, pDevice->byCurrentCh, (unsigned char)uConnectionChannel);
+		RFbAL7230SelectChannelPostProcess(pDevice, pDevice->byCurrentCh,
+						  (unsigned char)uConnectionChannel);
 
 	pDevice->byCurrentCh = (unsigned char)uConnectionChannel;
-	bResult &= RFbSelectChannel(pDevice->PortOffset, pDevice->byRFType, (unsigned char)uConnectionChannel);
+	bResult &= RFbSelectChannel(pDevice, pDevice->byRFType,
+				    (unsigned char)uConnectionChannel);
 
 	/* Init Synthesizer Table */
 	if (pDevice->bEnablePSMode)
-		RFvWriteWakeProgSyn(pDevice->PortOffset, pDevice->byRFType, uConnectionChannel);
+		RFvWriteWakeProgSyn(pDevice, pDevice->byRFType, uConnectionChannel);
 
 	BBvSoftwareReset(pDevice);
 
diff --git a/drivers/staging/vt6655/rf.c b/drivers/staging/vt6655/rf.c
index 2b1e7a0..da2c5e6 100644
--- a/drivers/staging/vt6655/rf.c
+++ b/drivers/staging/vt6655/rf.c
@@ -468,8 +468,9 @@ static bool s_bAL7230Init(struct vnt_private *priv)
 }
 
 // Need to Pull PLLON low when writing channel registers through 3-wire interface
-static bool s_bAL7230SelectChannel(void __iomem *dwIoBase, unsigned char byChannel)
+static bool s_bAL7230SelectChannel(struct vnt_private *priv, unsigned char byChannel)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	bool bResult;
 
 	bResult = true;
@@ -627,8 +628,9 @@ bool IFRFbWriteEmbedded(void __iomem *dwIoBase, unsigned long dwData)
  * Return Value: true if succeeded; false if failed.
  *
  */
-static bool RFbAL2230Init(void __iomem *dwIoBase)
+static bool RFbAL2230Init(struct vnt_private *priv)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	int     ii;
 	bool bResult;
 
@@ -674,8 +676,9 @@ static bool RFbAL2230Init(void __iomem *dwIoBase)
 	return bResult;
 }
 
-static bool RFbAL2230SelectChannel(void __iomem *dwIoBase, unsigned char byChannel)
+static bool RFbAL2230SelectChannel(struct vnt_private *priv, unsigned char byChannel)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	bool bResult;
 
 	bResult = true;
@@ -756,7 +759,7 @@ bool RFbInit(
 	case RF_AIROHA:
 	case RF_AL2230S:
 		pDevice->byMaxPwrLevel = AL2230_PWR_IDX_LEN;
-		bResult = RFbAL2230Init(pDevice->PortOffset);
+		bResult = RFbAL2230Init(pDevice);
 		break;
 	case RF_AIROHA7230:
 		pDevice->byMaxPwrLevel = AL7230_PWR_IDX_LEN;
@@ -785,18 +788,18 @@ bool RFbInit(
  * Return Value: true if succeeded; false if failed.
  *
  */
-bool RFbSelectChannel(void __iomem *dwIoBase, unsigned char byRFType, unsigned char byChannel)
+bool RFbSelectChannel(struct vnt_private *priv, unsigned char byRFType, unsigned char byChannel)
 {
 	bool bResult = true;
 
 	switch (byRFType) {
 	case RF_AIROHA:
 	case RF_AL2230S:
-		bResult = RFbAL2230SelectChannel(dwIoBase, byChannel);
+		bResult = RFbAL2230SelectChannel(priv, byChannel);
 		break;
 		//{{ RobertYu: 20050104
 	case RF_AIROHA7230:
-		bResult = s_bAL7230SelectChannel(dwIoBase, byChannel);
+		bResult = s_bAL7230SelectChannel(priv, byChannel);
 		break;
 		//}} RobertYu
 	case RF_NOTHING:
@@ -821,8 +824,9 @@ bool RFbSelectChannel(void __iomem *dwIoBase, unsigned char byRFType, unsigned c
  * Return Value: None.
  *
  */
-bool RFvWriteWakeProgSyn(void __iomem *dwIoBase, unsigned char byRFType, unsigned int uChannel)
+bool RFvWriteWakeProgSyn(struct vnt_private *priv, unsigned char byRFType, unsigned int uChannel)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	int   ii;
 	unsigned char byInitCount = 0;
 	unsigned char bySleepCount = 0;
@@ -1071,8 +1075,11 @@ RFvRSSITodBm(
 
 // Post processing for the 11b/g and 11a.
 // for save time on changing Reg2,3,5,7,10,12,15
-bool RFbAL7230SelectChannelPostProcess(void __iomem *dwIoBase, unsigned char byOldChannel, unsigned char byNewChannel)
+bool RFbAL7230SelectChannelPostProcess(struct vnt_private *priv,
+				       unsigned char byOldChannel,
+				       unsigned char byNewChannel)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	bool bResult;
 
 	bResult = true;
diff --git a/drivers/staging/vt6655/rf.h b/drivers/staging/vt6655/rf.h
index e8a7372..98c2326 100644
--- a/drivers/staging/vt6655/rf.h
+++ b/drivers/staging/vt6655/rf.h
@@ -74,11 +74,11 @@
 /*---------------------  Export Functions  --------------------------*/
 
 bool IFRFbWriteEmbedded(void __iomem *dwIoBase, unsigned long dwData);
-bool RFbSelectChannel(void __iomem *dwIoBase, unsigned char byRFType, unsigned char byChannel);
+bool RFbSelectChannel(struct vnt_private *, unsigned char byRFType, unsigned char byChannel);
 bool RFbInit(
 	struct vnt_private *
 );
-bool RFvWriteWakeProgSyn(void __iomem *dwIoBase, unsigned char byRFType, unsigned int uChannel);
+bool RFvWriteWakeProgSyn(struct vnt_private *, unsigned char byRFType, unsigned int uChannel);
 bool RFbSetPower(struct vnt_private *, unsigned int uRATE, unsigned int uCH);
 bool RFbRawSetPower(
 	struct vnt_private *,
@@ -94,7 +94,7 @@ RFvRSSITodBm(
 );
 
 //{{ RobertYu: 20050104
-bool RFbAL7230SelectChannelPostProcess(void __iomem *dwIoBase, unsigned char byOldChannel, unsigned char byNewChannel);
+bool RFbAL7230SelectChannelPostProcess(struct vnt_private *, unsigned char byOldChannel, unsigned char byNewChannel);
 //}} RobertYu
 
 #endif // __RF_H__
-- 
2.1.0

