Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:43493 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbbASSYz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 13:24:55 -0500
Received: by mail-wi0-f180.google.com with SMTP id bs8so18151648wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2015 10:24:53 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/6] staging: vt6655: set_channel replace parameter with ieee80211_channel
Date: Mon, 19 Jan 2015 18:24:10 +0000
Message-Id: <1421691855-2927-1-git-send-email-tvboxspy@gmail.com> (sfid-20150119_192458_502381_3D2E3BDF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

replacing uConnectionChannel for hw_value as set in vnt_init_bands.

This allows other signaling of ieee80211_channel to move deeper into
driver.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/channel.c     | 12 ++++++------
 drivers/staging/vt6655/channel.h     |  2 +-
 drivers/staging/vt6655/device_main.c |  2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6655/channel.c b/drivers/staging/vt6655/channel.c
index d593f5f..3fc09f4 100644
--- a/drivers/staging/vt6655/channel.c
+++ b/drivers/staging/vt6655/channel.c
@@ -174,12 +174,12 @@ void vnt_init_bands(struct vnt_private *priv)
  * Return Value: true if succeeded; false if failed.
  *
  */
-bool set_channel(void *pDeviceHandler, unsigned int uConnectionChannel)
+bool set_channel(void *pDeviceHandler, struct ieee80211_channel *ch)
 {
 	struct vnt_private *pDevice = pDeviceHandler;
 	bool bResult = true;
 
-	if (pDevice->byCurrentCh == uConnectionChannel)
+	if (pDevice->byCurrentCh == ch->hw_value)
 		return bResult;
 
 	/* Set VGA to max sensitivity */
@@ -197,15 +197,15 @@ bool set_channel(void *pDeviceHandler, unsigned int uConnectionChannel)
 
 	if (pDevice->byRFType == RF_AIROHA7230)
 		RFbAL7230SelectChannelPostProcess(pDevice, pDevice->byCurrentCh,
-						  (unsigned char)uConnectionChannel);
+						  (unsigned char)ch->hw_value);
 
-	pDevice->byCurrentCh = (unsigned char)uConnectionChannel;
+	pDevice->byCurrentCh = (unsigned char)ch->hw_value;
 	bResult &= RFbSelectChannel(pDevice, pDevice->byRFType,
-				    (unsigned char)uConnectionChannel);
+				    (unsigned char)ch->hw_value);
 
 	/* Init Synthesizer Table */
 	if (pDevice->bEnablePSMode)
-		RFvWriteWakeProgSyn(pDevice, pDevice->byRFType, uConnectionChannel);
+		RFvWriteWakeProgSyn(pDevice, pDevice->byRFType, ch->hw_value);
 
 	BBvSoftwareReset(pDevice);
 
diff --git a/drivers/staging/vt6655/channel.h b/drivers/staging/vt6655/channel.h
index 4f4264e..e2be6fc 100644
--- a/drivers/staging/vt6655/channel.h
+++ b/drivers/staging/vt6655/channel.h
@@ -27,6 +27,6 @@
 
 void vnt_init_bands(struct vnt_private *);
 
-bool set_channel(void *pDeviceHandler, unsigned int uConnectionChannel);
+bool set_channel(void *pDeviceHandler, struct ieee80211_channel *);
 
 #endif /* _CHANNEL_H_ */
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index c755ec2..b010184 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1420,7 +1420,7 @@ static int vnt_config(struct ieee80211_hw *hw, u32 changed)
 
 	if ((changed & IEEE80211_CONF_CHANGE_CHANNEL) ||
 	    (conf->flags & IEEE80211_CONF_OFFCHANNEL)) {
-		set_channel(priv, conf->chandef.chan->hw_value);
+		set_channel(priv, conf->chandef.chan);
 
 		if (conf->chandef.chan->band == IEEE80211_BAND_5GHZ)
 			bb_type = BB_TYPE_11A;
-- 
2.1.0

