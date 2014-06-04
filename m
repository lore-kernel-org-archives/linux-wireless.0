Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:33564 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbaFDR02 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 13:26:28 -0400
Received: by mail-wg0-f48.google.com with SMTP id k14so8878992wgh.7
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2014 10:26:26 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/15] staging: vt6656: PSbIsNextTBTTWakeUp remove camel case
Date: Wed,  4 Jun 2014 18:25:23 +0100
Message-Id: <1401902735-3882-3-git-send-email-tvboxspy@gmail.com> (sfid-20140604_192632_283867_384A0EC8)
In-Reply-To: <1401902735-3882-1-git-send-email-tvboxspy@gmail.com>
References: <1401902735-3882-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
pDevice -> priv
pMgmt -> mgmt
bWakeup -> wake_up

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/power.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
index b7c2720..7f60372 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -312,27 +312,27 @@ int PSbSendNullPacket(struct vnt_private *pDevice)
  *
  */
 
-int PSbIsNextTBTTWakeUp(struct vnt_private *pDevice)
+int PSbIsNextTBTTWakeUp(struct vnt_private *priv)
 {
-	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
-	int bWakeUp = false;
+	struct vnt_manager *mgmt = &priv->vnt_mgmt;
+	int wake_up = false;
 
-	if (pMgmt->wListenInterval >= 2) {
-		if (pMgmt->wCountToWakeUp == 0)
-			pMgmt->wCountToWakeUp = pMgmt->wListenInterval;
+	if (mgmt->wListenInterval >= 2) {
+		if (mgmt->wCountToWakeUp == 0)
+			mgmt->wCountToWakeUp = mgmt->wListenInterval;
 
-		pMgmt->wCountToWakeUp--;
+		mgmt->wCountToWakeUp--;
 
-		if (pMgmt->wCountToWakeUp == 1) {
+		if (mgmt->wCountToWakeUp == 1) {
 			/* Turn on wake up to listen next beacon */
-			vnt_mac_reg_bits_on(pDevice, MAC_REG_PSCTL, PSCTL_LNBCN);
-			pDevice->bPSRxBeacon = false;
-			bWakeUp = true;
-		} else if (!pDevice->bPSRxBeacon) {
+			vnt_mac_reg_bits_on(priv, MAC_REG_PSCTL, PSCTL_LNBCN);
+			priv->bPSRxBeacon = false;
+			wake_up = true;
+		} else if (!priv->bPSRxBeacon) {
 			/* Listen until RxBeacon */
-			vnt_mac_reg_bits_on(pDevice, MAC_REG_PSCTL, PSCTL_LNBCN);
+			vnt_mac_reg_bits_on(priv, MAC_REG_PSCTL, PSCTL_LNBCN);
 		}
 	}
-	return bWakeUp;
+	return wake_up;
 }
 
-- 
1.9.1

