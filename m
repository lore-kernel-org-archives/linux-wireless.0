Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:50208 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbaFDR0b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 13:26:31 -0400
Received: by mail-wg0-f43.google.com with SMTP id l18so8649320wgh.26
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2014 10:26:30 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/15] staging: vt6656: rename PSvDisablePowerSaving to vnt_disable_power_saving
Date: Wed,  4 Jun 2014 18:25:25 +0100
Message-Id: <1401902735-3882-5-git-send-email-tvboxspy@gmail.com> (sfid-20140604_192635_276735_81089728)
In-Reply-To: <1401902735-3882-1-git-send-email-tvboxspy@gmail.com>
References: <1401902735-3882-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/iwctl.c | 2 +-
 drivers/staging/vt6656/power.c | 2 +-
 drivers/staging/vt6656/power.h | 2 +-
 drivers/staging/vt6656/wcmd.c  | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 73b7794..3e144ed 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -1323,7 +1323,7 @@ int iwctl_siwpower(struct net_device *dev, struct iw_request_info *info,
 
 	if (wrq->disabled) {
 		pDevice->ePSMode = WMAC_POWER_CAM;
-		PSvDisablePowerSaving(pDevice);
+		vnt_disable_power_saving(pDevice);
 		return rc;
 	}
 	if ((wrq->flags & IW_POWER_TYPE) == IW_POWER_TIMEOUT) {
diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
index ae136b2..e5462ed 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -125,7 +125,7 @@ void vnt_enable_power_saving(struct vnt_private *priv, u16 listen_interval)
  *
  */
 
-void PSvDisablePowerSaving(struct vnt_private *priv)
+void vnt_disable_power_saving(struct vnt_private *priv)
 {
 
 	/* disable power saving hw function */
diff --git a/drivers/staging/vt6656/power.h b/drivers/staging/vt6656/power.h
index 0642f18..ef669b7 100644
--- a/drivers/staging/vt6656/power.h
+++ b/drivers/staging/vt6656/power.h
@@ -38,7 +38,7 @@
 
 int PSbConsiderPowerDown(struct vnt_private *, int bCheckRxDMA,
 	int bCheckCountToWakeUp);
-void PSvDisablePowerSaving(struct vnt_private *);
+void vnt_disable_power_saving(struct vnt_private *);
 void vnt_enable_power_saving(struct vnt_private *, u16);
 void PSvSendPSPOLL(struct vnt_private *);
 int PSbSendNullPacket(struct vnt_private *);
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 55c5563..b2d7865 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -480,7 +480,7 @@ void vRunCommand(struct work_struct *work)
 		// set initial state
 		pMgmt->eCurrState = WMAC_STATE_IDLE;
 		pMgmt->eCurrMode = WMAC_MODE_STANDBY;
-		PSvDisablePowerSaving((void *) pDevice);
+		vnt_disable_power_saving(pDevice);
 		BSSvClearNodeDBTable(pDevice, 0);
 		vMgrJoinBSSBegin((void *) pDevice, &Status);
 		// if Infra mode
-- 
1.9.1

