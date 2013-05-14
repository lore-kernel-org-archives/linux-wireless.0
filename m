Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:48035 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758585Ab3ENXev (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 May 2013 19:34:51 -0400
Received: by mail-we0-f175.google.com with SMTP id p57so1072394wes.20
        for <linux-wireless@vger.kernel.org>; Tue, 14 May 2013 16:34:50 -0700 (PDT)
Message-ID: <1368574484.5342.5.camel@canaries64> (sfid-20130515_013454_963988_E9EE6427)
Subject: [PATCH] staging: vt6656: [bug] Fix missing spin lock in
 iwctl_siwpower.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Andres More <more.andres@gmail.com>, linux-wireless@vger.kernel.org
Date: Wed, 15 May 2013 00:34:44 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes occasional dead lock on power up / down.

Only relevant to kernels 3.8 and later when command was
transferred to the iw_handler.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: stable@vger.kernel.org # 3.8+
---
 drivers/staging/vt6656/iwctl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index c335808..855eb58 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -1334,6 +1334,7 @@ int iwctl_siwpower(struct net_device *dev, struct iw_request_info *info,
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	struct iw_param *wrq = &wrqu->power;
 	int rc = 0;
+	unsigned long flags;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER\n");
 
@@ -1345,9 +1346,12 @@ int iwctl_siwpower(struct net_device *dev, struct iw_request_info *info,
 		return rc;
 	}
 
+	spin_lock_irqsave(&pDevice->lock, flags);
+
 	if (wrq->disabled) {
 		pDevice->ePSMode = WMAC_POWER_CAM;
 		PSvDisablePowerSaving(pDevice);
+		spin_unlock_irqrestore(&pDevice->lock, flags);
 		return rc;
 	}
 	if ((wrq->flags & IW_POWER_TYPE) == IW_POWER_TIMEOUT) {
@@ -1358,6 +1362,9 @@ int iwctl_siwpower(struct net_device *dev, struct iw_request_info *info,
 		pDevice->ePSMode = WMAC_POWER_FAST;
 		PSvEnablePowerSaving((void *)pDevice, pMgmt->wListenInterval);
 	}
+
+	spin_unlock_irqrestore(&pDevice->lock, flags);
+
 	switch (wrq->flags & IW_POWER_MODE) {
 	case IW_POWER_UNICAST_R:
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER: IW_POWER_UNICAST_R \n");
-- 
1.8.1.2




