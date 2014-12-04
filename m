Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:48737 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933257AbaLDWNZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2014 17:13:25 -0500
Received: by mail-wi0-f171.google.com with SMTP id bs8so36204911wib.10
        for <linux-wireless@vger.kernel.org>; Thu, 04 Dec 2014 14:13:24 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/6] staging: vt6655: common variable size channel numbers to ieee80211_channel->hw_value
Date: Thu,  4 Dec 2014 22:12:43 +0000
Message-Id: <1417731167-3231-2-git-send-email-tvboxspy@gmail.com> (sfid-20141204_231336_773286_EF197092)
In-Reply-To: <1417731167-3231-1-git-send-email-tvboxspy@gmail.com>
References: <1417731167-3231-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hw_value is u16 so fix all to the same size.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/channel.c |  6 +++---
 drivers/staging/vt6655/device.h  |  2 +-
 drivers/staging/vt6655/rf.c      | 12 +++++++-----
 drivers/staging/vt6655/rf.h      |  8 ++++----
 4 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/vt6655/channel.c b/drivers/staging/vt6655/channel.c
index 6514869..1302f3c 100644
--- a/drivers/staging/vt6655/channel.c
+++ b/drivers/staging/vt6655/channel.c
@@ -189,11 +189,11 @@ bool set_channel(void *pDeviceHandler, struct ieee80211_channel *ch)
 
 	if (pDevice->byRFType == RF_AIROHA7230)
 		RFbAL7230SelectChannelPostProcess(pDevice, pDevice->byCurrentCh,
-						  (unsigned char)ch->hw_value);
+						  ch->hw_value);
 
-	pDevice->byCurrentCh = (unsigned char)ch->hw_value;
+	pDevice->byCurrentCh = ch->hw_value;
 	bResult &= RFbSelectChannel(pDevice, pDevice->byRFType,
-				    (unsigned char)ch->hw_value);
+				    ch->hw_value);
 
 	/* Init Synthesizer Table */
 	if (pDevice->bEnablePSMode)
diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 83efbfb..96d8e62 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -367,7 +367,7 @@ struct vnt_private {
 	bool bIsBeaconBufReadySet;
 	unsigned int	cbBeaconBufReadySetCnt;
 	bool bFixRate;
-	unsigned char byCurrentCh;
+	u16 byCurrentCh;
 
 	bool bAES;
 
diff --git a/drivers/staging/vt6655/rf.c b/drivers/staging/vt6655/rf.c
index 32ef993..27841aa 100644
--- a/drivers/staging/vt6655/rf.c
+++ b/drivers/staging/vt6655/rf.c
@@ -651,7 +651,8 @@ bool RFbInit(
  * Return Value: true if succeeded; false if failed.
  *
  */
-bool RFbSelectChannel(struct vnt_private *priv, unsigned char byRFType, unsigned char byChannel)
+bool RFbSelectChannel(struct vnt_private *priv, unsigned char byRFType,
+		      u16 byChannel)
 {
 	bool bResult = true;
 
@@ -687,7 +688,8 @@ bool RFbSelectChannel(struct vnt_private *priv, unsigned char byRFType, unsigned
  * Return Value: None.
  *
  */
-bool RFvWriteWakeProgSyn(struct vnt_private *priv, unsigned char byRFType, unsigned int uChannel)
+bool RFvWriteWakeProgSyn(struct vnt_private *priv, unsigned char byRFType,
+			 u16 uChannel)
 {
 	void __iomem *dwIoBase = priv->PortOffset;
 	int   ii;
@@ -767,7 +769,7 @@ bool RFvWriteWakeProgSyn(struct vnt_private *priv, unsigned char byRFType, unsig
 bool RFbSetPower(
 	struct vnt_private *priv,
 	unsigned int uRATE,
-	unsigned int uCH
+	u16 uCH
 )
 {
 	bool bResult = true;
@@ -937,8 +939,8 @@ RFvRSSITodBm(
 /* Post processing for the 11b/g and 11a.
  * for save time on changing Reg2,3,5,7,10,12,15 */
 bool RFbAL7230SelectChannelPostProcess(struct vnt_private *priv,
-				       unsigned char byOldChannel,
-				       unsigned char byNewChannel)
+				       u16 byOldChannel,
+				       u16 byNewChannel)
 {
 	bool bResult;
 
diff --git a/drivers/staging/vt6655/rf.h b/drivers/staging/vt6655/rf.h
index 8a6e2cf..2ea21e2 100644
--- a/drivers/staging/vt6655/rf.h
+++ b/drivers/staging/vt6655/rf.h
@@ -74,12 +74,12 @@
 /*---------------------  Export Functions  --------------------------*/
 
 bool IFRFbWriteEmbedded(struct vnt_private *, unsigned long dwData);
-bool RFbSelectChannel(struct vnt_private *, unsigned char byRFType, unsigned char byChannel);
+bool RFbSelectChannel(struct vnt_private *, unsigned char byRFType, u16);
 bool RFbInit(
 	struct vnt_private *
 );
-bool RFvWriteWakeProgSyn(struct vnt_private *, unsigned char byRFType, unsigned int uChannel);
-bool RFbSetPower(struct vnt_private *, unsigned int uRATE, unsigned int uCH);
+bool RFvWriteWakeProgSyn(struct vnt_private *, unsigned char byRFType, u16);
+bool RFbSetPower(struct vnt_private *, unsigned int uRATE, u16);
 bool RFbRawSetPower(
 	struct vnt_private *,
 	unsigned char byPwr,
@@ -94,7 +94,7 @@ RFvRSSITodBm(
 );
 
 //{{ RobertYu: 20050104
-bool RFbAL7230SelectChannelPostProcess(struct vnt_private *, unsigned char byOldChannel, unsigned char byNewChannel);
+bool RFbAL7230SelectChannelPostProcess(struct vnt_private *, u16, u16);
 //}} RobertYu
 
 #endif // __RF_H__
-- 
2.1.0

