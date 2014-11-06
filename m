Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:56673 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaKFUCe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 15:02:34 -0500
Received: by mail-wg0-f47.google.com with SMTP id a1so2083161wgh.6
        for <linux-wireless@vger.kernel.org>; Thu, 06 Nov 2014 12:02:33 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/6] staging: vt6655: baseband replace __iomem where caller is priv dereferenced.
Date: Thu,  6 Nov 2014 20:02:01 +0000
Message-Id: <1415304125-5165-2-git-send-email-tvboxspy@gmail.com> (sfid-20141106_210250_377065_865F9EC5)
In-Reply-To: <1415304125-5165-1-git-send-email-tvboxspy@gmail.com>
References: <1415304125-5165-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with stucture vnt_private *priv

in functions
BBvSoftwareReset
BBvSetTxAntennaMode
BBvSetRxAntennaMode
BBvSetDeepSleep
BBvExitDeepSleep

__iomem *dwIoBase will be moved into BBbWriteEmbedded and BBbReadEmbedded
later.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/baseband.c    | 30 +++++++++++++++++++-----------
 drivers/staging/vt6655/baseband.h    | 10 +++++-----
 drivers/staging/vt6655/card.c        |  4 ++--
 drivers/staging/vt6655/channel.c     |  2 +-
 drivers/staging/vt6655/device_main.c |  6 +++---
 5 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index 32000d2..c6c811b 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -1719,22 +1719,22 @@ s_vChangeAntenna(
 	if (priv->dwRxAntennaSel == 0) {
 		priv->dwRxAntennaSel = 1;
 		if (priv->bTxRxAntInv == true)
-			BBvSetRxAntennaMode(priv->PortOffset, ANT_A);
+			BBvSetRxAntennaMode(priv, ANT_A);
 		else
-			BBvSetRxAntennaMode(priv->PortOffset, ANT_B);
+			BBvSetRxAntennaMode(priv, ANT_B);
 	} else {
 		priv->dwRxAntennaSel = 0;
 		if (priv->bTxRxAntInv == true)
-			BBvSetRxAntennaMode(priv->PortOffset, ANT_B);
+			BBvSetRxAntennaMode(priv, ANT_B);
 		else
-			BBvSetRxAntennaMode(priv->PortOffset, ANT_A);
+			BBvSetRxAntennaMode(priv, ANT_A);
 	}
 	if (priv->dwTxAntennaSel == 0) {
 		priv->dwTxAntennaSel = 1;
-		BBvSetTxAntennaMode(priv->PortOffset, ANT_B);
+		BBvSetTxAntennaMode(priv, ANT_B);
 	} else {
 		priv->dwTxAntennaSel = 0;
-		BBvSetTxAntennaMode(priv->PortOffset, ANT_A);
+		BBvSetTxAntennaMode(priv, ANT_A);
 	}
 }
 
@@ -2266,8 +2266,10 @@ void BBvSetVGAGainOffset(struct vnt_private *priv, unsigned char byData)
  *
  */
 void
-BBvSoftwareReset(void __iomem *dwIoBase)
+BBvSoftwareReset(struct vnt_private *priv)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
+
 	BBbWriteEmbedded(dwIoBase, 0x50, 0x40);
 	BBbWriteEmbedded(dwIoBase, 0x50, 0);
 	BBbWriteEmbedded(dwIoBase, 0x9C, 0x01);
@@ -2333,8 +2335,9 @@ BBvPowerSaveModeOFF(void __iomem *dwIoBase)
  */
 
 void
-BBvSetTxAntennaMode(void __iomem *dwIoBase, unsigned char byAntennaMode)
+BBvSetTxAntennaMode(struct vnt_private *priv, unsigned char byAntennaMode)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	unsigned char byBBTxConf;
 
 	BBbReadEmbedded(dwIoBase, 0x09, &byBBTxConf); /* CR09 */
@@ -2366,8 +2369,9 @@ BBvSetTxAntennaMode(void __iomem *dwIoBase, unsigned char byAntennaMode)
  */
 
 void
-BBvSetRxAntennaMode(void __iomem *dwIoBase, unsigned char byAntennaMode)
+BBvSetRxAntennaMode(struct vnt_private *priv, unsigned char byAntennaMode)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	unsigned char byBBRxConf;
 
 	BBbReadEmbedded(dwIoBase, 0x0A, &byBBRxConf); /* CR10 */
@@ -2396,15 +2400,19 @@ BBvSetRxAntennaMode(void __iomem *dwIoBase, unsigned char byAntennaMode)
  *
  */
 void
-BBvSetDeepSleep(void __iomem *dwIoBase, unsigned char byLocalID)
+BBvSetDeepSleep(struct vnt_private *priv, unsigned char byLocalID)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
+
 	BBbWriteEmbedded(dwIoBase, 0x0C, 0x17); /* CR12 */
 	BBbWriteEmbedded(dwIoBase, 0x0D, 0xB9); /* CR13 */
 }
 
 void
-BBvExitDeepSleep(void __iomem *dwIoBase, unsigned char byLocalID)
+BBvExitDeepSleep(struct vnt_private *priv, unsigned char byLocalID)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
+
 	BBbWriteEmbedded(dwIoBase, 0x0C, 0x00); /* CR12 */
 	BBbWriteEmbedded(dwIoBase, 0x0D, 0x01); /* CR13 */
 }
diff --git a/drivers/staging/vt6655/baseband.h b/drivers/staging/vt6655/baseband.h
index c41bc33..8594347 100644
--- a/drivers/staging/vt6655/baseband.h
+++ b/drivers/staging/vt6655/baseband.h
@@ -85,13 +85,13 @@ void BBvSetVGAGainOffset(struct vnt_private *, unsigned char byData);
 
 /* VT3253 Baseband */
 bool BBbVT3253Init(struct vnt_private *);
-void BBvSoftwareReset(void __iomem *dwIoBase);
+void BBvSoftwareReset(struct vnt_private *);
 void BBvPowerSaveModeON(void __iomem *dwIoBase);
 void BBvPowerSaveModeOFF(void __iomem *dwIoBase);
-void BBvSetTxAntennaMode(void __iomem *dwIoBase, unsigned char byAntennaMode);
-void BBvSetRxAntennaMode(void __iomem *dwIoBase, unsigned char byAntennaMode);
-void BBvSetDeepSleep(void __iomem *dwIoBase, unsigned char byLocalID);
-void BBvExitDeepSleep(void __iomem *dwIoBase, unsigned char byLocalID);
+void BBvSetTxAntennaMode(struct vnt_private *, unsigned char byAntennaMode);
+void BBvSetRxAntennaMode(struct vnt_private *, unsigned char byAntennaMode);
+void BBvSetDeepSleep(struct vnt_private *, unsigned char byLocalID);
+void BBvExitDeepSleep(struct vnt_private *, unsigned char byLocalID);
 
 /* timer for antenna diversity */
 
diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 60f051f..0121466 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -445,7 +445,7 @@ bool CARDbRadioPowerOff(struct vnt_private *pDevice)
 
 	MACvRegBitsOff(pDevice->PortOffset, MAC_REG_HOSTCR, HOSTCR_RXON);
 
-	BBvSetDeepSleep(pDevice->PortOffset, pDevice->byLocalID);
+	BBvSetDeepSleep(pDevice, pDevice->byLocalID);
 
 	pDevice->bRadioOff = true;
 	pr_debug("chester power off\n");
@@ -480,7 +480,7 @@ bool CARDbRadioPowerOn(struct vnt_private *pDevice)
 		pr_debug("chester pbRadioOff\n");
 		return true; }
 
-	BBvExitDeepSleep(pDevice->PortOffset, pDevice->byLocalID);
+	BBvExitDeepSleep(pDevice, pDevice->byLocalID);
 
 	MACvRegBitsOn(pDevice->PortOffset, MAC_REG_HOSTCR, HOSTCR_RXON);
 
diff --git a/drivers/staging/vt6655/channel.c b/drivers/staging/vt6655/channel.c
index 6bd5f16..cc1bc94 100644
--- a/drivers/staging/vt6655/channel.c
+++ b/drivers/staging/vt6655/channel.c
@@ -197,7 +197,7 @@ bool set_channel(void *pDeviceHandler, unsigned int uConnectionChannel)
 	if (pDevice->bEnablePSMode)
 		RFvWriteWakeProgSyn(pDevice->PortOffset, pDevice->byRFType, uConnectionChannel);
 
-	BBvSoftwareReset(pDevice->PortOffset);
+	BBvSoftwareReset(pDevice);
 
 	if (pDevice->byLocalID > REV_ID_VT3253_B1) {
 		/* set HW default power register */
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 5fc6022..397f13f 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -254,7 +254,7 @@ static void device_init_registers(struct vnt_private *pDevice)
 	unsigned char byOFDMPwrdBm = 0;
 
 	MACbShutdown(pDevice->PortOffset);
-	BBvSoftwareReset(pDevice->PortOffset);
+	BBvSoftwareReset(pDevice);
 
 	/* Do MACbSoftwareReset in MACvInitialize */
 	MACbSoftwareReset(pDevice->PortOffset);
@@ -446,8 +446,8 @@ static void device_init_registers(struct vnt_private *pDevice)
 		BBvSetVGAGainOffset(pDevice, pDevice->abyBBVGA[0]);
 	}
 
-	BBvSetRxAntennaMode(pDevice->PortOffset, pDevice->byRxAntennaMode);
-	BBvSetTxAntennaMode(pDevice->PortOffset, pDevice->byTxAntennaMode);
+	BBvSetRxAntennaMode(pDevice, pDevice->byRxAntennaMode);
+	BBvSetTxAntennaMode(pDevice, pDevice->byTxAntennaMode);
 
 	/* Set BB and packet type at the same time. */
 	/* Set Short Slot Time, xIFS, and RSPINF. */
-- 
2.1.0

