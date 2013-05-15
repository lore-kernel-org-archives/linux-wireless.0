Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34461 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758615Ab3EOAob (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 May 2013 20:44:31 -0400
Received: by mail-wi0-f178.google.com with SMTP id ey16so1091874wid.17
        for <linux-wireless@vger.kernel.org>; Tue, 14 May 2013 17:44:29 -0700 (PDT)
Message-ID: <1368578665.7523.6.camel@canaries64> (sfid-20130515_024434_645881_06151854)
Subject: [PATCH v2] staging: vt6656: [bug] Fix missing spin lock in
 iwctl_siwpower.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Andres More <more.andres@gmail.com>, linux-wireless@vger.kernel.org
Date: Wed, 15 May 2013 01:44:25 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes occasional dead lock on power up / down.

spin_lock_irq is used because of unlocking with spin_unlock_irq
elsewhere in the driver.

Only relevant to kernels 3.8 and later when command was
transferred to the iw_handler.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: stable@vger.kernel.org # 3.8+
---
 drivers/staging/vt6656/iwctl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index c335808..d0cf7d8 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -1345,9 +1345,12 @@ int iwctl_siwpower(struct net_device *dev, struct iw_request_info *info,
 		return rc;
 	}
 
+	spin_lock_irq(&pDevice->lock);
+
 	if (wrq->disabled) {
 		pDevice->ePSMode = WMAC_POWER_CAM;
 		PSvDisablePowerSaving(pDevice);
+		spin_unlock_irq(&pDevice->lock);
 		return rc;
 	}
 	if ((wrq->flags & IW_POWER_TYPE) == IW_POWER_TIMEOUT) {
@@ -1358,6 +1361,9 @@ int iwctl_siwpower(struct net_device *dev, struct iw_request_info *info,
 		pDevice->ePSMode = WMAC_POWER_FAST;
 		PSvEnablePowerSaving((void *)pDevice, pMgmt->wListenInterval);
 	}
+
+	spin_unlock_irq(&pDevice->lock);
+
 	switch (wrq->flags & IW_POWER_MODE) {
 	case IW_POWER_UNICAST_R:
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWPOWER: IW_POWER_UNICAST_R \n");
-- 
1.8.1.2



