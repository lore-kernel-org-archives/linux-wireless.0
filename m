Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:57218 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbaFDR03 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 13:26:29 -0400
Received: by mail-wi0-f169.google.com with SMTP id hi2so8225466wib.4
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2014 10:26:28 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/15] staging: vt6656: rename PSvEnablePowerSaving to vnt_enable_power_saving
Date: Wed,  4 Jun 2014 18:25:24 +0100
Message-Id: <1401902735-3882-4-git-send-email-tvboxspy@gmail.com> (sfid-20140604_192632_929362_17F6DB91)
In-Reply-To: <1401902735-3882-1-git-send-email-tvboxspy@gmail.com>
References: <1401902735-3882-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/iwctl.c | 4 ++--
 drivers/staging/vt6656/power.c | 4 ++--
 drivers/staging/vt6656/power.h | 2 +-
 drivers/staging/vt6656/wcmd.c  | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index b45af4a..73b7794 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -1328,11 +1328,11 @@ int iwctl_siwpower(struct net_device *dev, struct iw_request_info *info,
 	}
 	if ((wrq->flags & IW_POWER_TYPE) == IW_POWER_TIMEOUT) {
 		pDevice->ePSMode = WMAC_POWER_FAST;
-		PSvEnablePowerSaving((void *)pDevice, pMgmt->wListenInterval);
+		vnt_enable_power_saving(pDevice, pMgmt->wListenInterval);
 
 	} else if ((wrq->flags & IW_POWER_TYPE) == IW_POWER_PERIOD) {
 		pDevice->ePSMode = WMAC_POWER_FAST;
-		PSvEnablePowerSaving((void *)pDevice, pMgmt->wListenInterval);
+		vnt_enable_power_saving(pDevice, pMgmt->wListenInterval);
 	}
 
 	switch (wrq->flags & IW_POWER_MODE) {
diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
index 7f60372..ae136b2 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -26,7 +26,7 @@
  * Date: July 17, 2002
  *
  * Functions:
- *      PSvEnablePowerSaving - Enable Power Saving Mode
+ *      vnt_enable_power_saving - Enable Power Saving Mode
  *      PSvDiasblePowerSaving - Disable Power Saving Mode
  *      PSbConsiderPowerDown - Decide if we can Power Down
  *      PSvSendPSPOLL - Send PS-POLL packet
@@ -58,7 +58,7 @@ static int msglevel = MSG_LEVEL_INFO;
  *
  */
 
-void PSvEnablePowerSaving(struct vnt_private *priv, u16 listen_interval)
+void vnt_enable_power_saving(struct vnt_private *priv, u16 listen_interval)
 {
 	struct vnt_manager *mgmt = &priv->vnt_mgmt;
 	u16 aid = mgmt->wCurrAID | BIT14 | BIT15;
diff --git a/drivers/staging/vt6656/power.h b/drivers/staging/vt6656/power.h
index 7783582..0642f18 100644
--- a/drivers/staging/vt6656/power.h
+++ b/drivers/staging/vt6656/power.h
@@ -39,7 +39,7 @@
 int PSbConsiderPowerDown(struct vnt_private *, int bCheckRxDMA,
 	int bCheckCountToWakeUp);
 void PSvDisablePowerSaving(struct vnt_private *);
-void PSvEnablePowerSaving(struct vnt_private *, u16 wListenInterval);
+void vnt_enable_power_saving(struct vnt_private *, u16);
 void PSvSendPSPOLL(struct vnt_private *);
 int PSbSendNullPacket(struct vnt_private *);
 int PSbIsNextTBTTWakeUp(struct vnt_private *);
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index ae773a6..55c5563 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -593,7 +593,7 @@ void vRunCommand(struct work_struct *work)
 		if (pMgmt->eCurrState == WMAC_STATE_ASSOC) {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"eCurrState == WMAC_STATE_ASSOC\n");
 			if (pDevice->ePSMode != WMAC_POWER_CAM) {
-				PSvEnablePowerSaving((void *) pDevice,
+				vnt_enable_power_saving(pDevice,
 						pMgmt->wListenInterval);
 			}
 /*
-- 
1.9.1

