Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63387 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaKFUCg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 15:02:36 -0500
Received: by mail-wi0-f172.google.com with SMTP id bs8so2604714wib.5
        for <linux-wireless@vger.kernel.org>; Thu, 06 Nov 2014 12:02:34 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/6] staging: vt6655: baseband/rf s_bAL7230Init change  __iomem for baseband functions
Date: Thu,  6 Nov 2014 20:02:02 +0000
Message-Id: <1415304125-5165-3-git-send-email-tvboxspy@gmail.com> (sfid-20141106_210251_671784_0E82DCBF)
In-Reply-To: <1415304125-5165-1-git-send-email-tvboxspy@gmail.com>
References: <1415304125-5165-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace __iomem with vnt_private providing pointer for dwIoBase

Change BBvPowerSaveModeON and BBvPowerSaveModeOFF to vnt_private and
reference __iomem there, to be removed later.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/baseband.c | 6 ++++--
 drivers/staging/vt6655/baseband.h | 4 ++--
 drivers/staging/vt6655/rf.c       | 9 +++++----
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index c6c811b..9d5288c 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -2289,8 +2289,9 @@ BBvSoftwareReset(struct vnt_private *priv)
  *
  */
 void
-BBvPowerSaveModeON(void __iomem *dwIoBase)
+BBvPowerSaveModeON(struct vnt_private *priv)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	unsigned char byOrgData;
 
 	BBbReadEmbedded(dwIoBase, 0x0D, &byOrgData);
@@ -2311,8 +2312,9 @@ BBvPowerSaveModeON(void __iomem *dwIoBase)
  *
  */
 void
-BBvPowerSaveModeOFF(void __iomem *dwIoBase)
+BBvPowerSaveModeOFF(struct vnt_private *priv)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	unsigned char byOrgData;
 
 	BBbReadEmbedded(dwIoBase, 0x0D, &byOrgData);
diff --git a/drivers/staging/vt6655/baseband.h b/drivers/staging/vt6655/baseband.h
index 8594347..26f9cdc 100644
--- a/drivers/staging/vt6655/baseband.h
+++ b/drivers/staging/vt6655/baseband.h
@@ -86,8 +86,8 @@ void BBvSetVGAGainOffset(struct vnt_private *, unsigned char byData);
 /* VT3253 Baseband */
 bool BBbVT3253Init(struct vnt_private *);
 void BBvSoftwareReset(struct vnt_private *);
-void BBvPowerSaveModeON(void __iomem *dwIoBase);
-void BBvPowerSaveModeOFF(void __iomem *dwIoBase);
+void BBvPowerSaveModeON(struct vnt_private *);
+void BBvPowerSaveModeOFF(struct vnt_private *);
 void BBvSetTxAntennaMode(struct vnt_private *, unsigned char byAntennaMode);
 void BBvSetRxAntennaMode(struct vnt_private *, unsigned char byAntennaMode);
 void BBvSetDeepSleep(struct vnt_private *, unsigned char byLocalID);
diff --git a/drivers/staging/vt6655/rf.c b/drivers/staging/vt6655/rf.c
index e505af9..2b1e7a0 100644
--- a/drivers/staging/vt6655/rf.c
+++ b/drivers/staging/vt6655/rf.c
@@ -424,8 +424,9 @@ static const unsigned long dwAL7230ChannelTable2[CB_MAX_CHANNEL] = {
  * Return Value: true if succeeded; false if failed.
  *
  */
-static bool s_bAL7230Init(void __iomem *dwIoBase)
+static bool s_bAL7230Init(struct vnt_private *priv)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	int     ii;
 	bool bResult;
 
@@ -436,7 +437,7 @@ static bool s_bAL7230Init(void __iomem *dwIoBase)
 
 	MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, (SOFTPWRCTL_SWPECTI  |
 							 SOFTPWRCTL_TXPEINV));
-	BBvPowerSaveModeOFF(dwIoBase); //RobertYu:20050106, have DC value for Calibration
+	BBvPowerSaveModeOFF(priv); /* RobertYu:20050106, have DC value for Calibration */
 
 	for (ii = 0; ii < CB_AL7230_INIT_SEQ; ii++)
 		bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTable[ii]);
@@ -457,7 +458,7 @@ static bool s_bAL7230Init(void __iomem *dwIoBase)
 							 SOFTPWRCTL_SWPECTI  |
 							 SOFTPWRCTL_TXPEINV));
 
-	BBvPowerSaveModeON(dwIoBase); // RobertYu:20050106
+	BBvPowerSaveModeON(priv); /* RobertYu:20050106 */
 
 	// PE1: TX_ON, PE2: RX_ON, PE3: PLLON
 	//3-wire control for power saving mode
@@ -759,7 +760,7 @@ bool RFbInit(
 		break;
 	case RF_AIROHA7230:
 		pDevice->byMaxPwrLevel = AL7230_PWR_IDX_LEN;
-		bResult = s_bAL7230Init(pDevice->PortOffset);
+		bResult = s_bAL7230Init(pDevice);
 		break;
 	case RF_NOTHING:
 		bResult = true;
-- 
2.1.0

