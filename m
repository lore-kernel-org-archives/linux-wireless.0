Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:54041 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaFDR0Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 13:26:24 -0400
Received: by mail-we0-f175.google.com with SMTP id p10so8981698wes.34
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2014 10:26:23 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 01/15] staging: vt6656: PSvEnablePowerSaving remove camel case
Date: Wed,  4 Jun 2014 18:25:21 +0100
Message-Id: <1401902735-3882-1-git-send-email-tvboxspy@gmail.com> (sfid-20140604_192629_049437_6D990272)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
pDevice -> priv
wListenInterval -> listen_interval
pMgmt -> mgmt
wAID -> aid

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/power.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
index 8cc2596..718443f 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -58,60 +58,60 @@ static int msglevel = MSG_LEVEL_INFO;
  *
  */
 
-void PSvEnablePowerSaving(struct vnt_private *pDevice, u16 wListenInterval)
+void PSvEnablePowerSaving(struct vnt_private *priv, u16 listen_interval)
 {
-	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
-	u16 wAID = pMgmt->wCurrAID | BIT14 | BIT15;
+	struct vnt_manager *mgmt = &priv->vnt_mgmt;
+	u16 aid = mgmt->wCurrAID | BIT14 | BIT15;
 
 	/* set period of power up before TBTT */
-	vnt_mac_write_word(pDevice, MAC_REG_PWBT, C_PWBT);
+	vnt_mac_write_word(priv, MAC_REG_PWBT, C_PWBT);
 
-	if (pDevice->op_mode != NL80211_IFTYPE_ADHOC) {
+	if (priv->op_mode != NL80211_IFTYPE_ADHOC) {
 		/* set AID */
-		vnt_mac_write_word(pDevice, MAC_REG_AIDATIM, wAID);
+		vnt_mac_write_word(priv, MAC_REG_AIDATIM, aid);
 	}
 
 	/* Warren:06-18-2004,the sequence must follow
 	 * PSEN->AUTOSLEEP->GO2DOZE
 	 */
 	/* enable power saving hw function */
-	vnt_mac_reg_bits_on(pDevice, MAC_REG_PSCTL, PSCTL_PSEN);
+	vnt_mac_reg_bits_on(priv, MAC_REG_PSCTL, PSCTL_PSEN);
 
 	/* Set AutoSleep */
-	vnt_mac_reg_bits_on(pDevice, MAC_REG_PSCFG, PSCFG_AUTOSLEEP);
+	vnt_mac_reg_bits_on(priv, MAC_REG_PSCFG, PSCFG_AUTOSLEEP);
 
 	/* Warren:MUST turn on this once before turn on AUTOSLEEP ,or the
 	 * AUTOSLEEP doesn't work
 	 */
-	vnt_mac_reg_bits_on(pDevice, MAC_REG_PSCTL, PSCTL_GO2DOZE);
+	vnt_mac_reg_bits_on(priv, MAC_REG_PSCTL, PSCTL_GO2DOZE);
 
-	if (wListenInterval >= 2) {
+	if (listen_interval >= 2) {
 
 		/* clear always listen beacon */
-		vnt_mac_reg_bits_off(pDevice, MAC_REG_PSCTL, PSCTL_ALBCN);
+		vnt_mac_reg_bits_off(priv, MAC_REG_PSCTL, PSCTL_ALBCN);
 
 		/* first time set listen next beacon */
-		vnt_mac_reg_bits_on(pDevice, MAC_REG_PSCTL, PSCTL_LNBCN);
+		vnt_mac_reg_bits_on(priv, MAC_REG_PSCTL, PSCTL_LNBCN);
 
-		pMgmt->wCountToWakeUp = wListenInterval;
+		mgmt->wCountToWakeUp = listen_interval;
 
 	} else {
 
 		/* always listen beacon */
-		vnt_mac_reg_bits_on(pDevice, MAC_REG_PSCTL, PSCTL_ALBCN);
+		vnt_mac_reg_bits_on(priv, MAC_REG_PSCTL, PSCTL_ALBCN);
 
-		pMgmt->wCountToWakeUp = 0;
+		mgmt->wCountToWakeUp = 0;
 	}
 
-	pDevice->bEnablePSMode = true;
+	priv->bEnablePSMode = true;
 
 	/* We don't send null pkt in ad hoc mode
 	 * since beacon will handle this.
 	 */
-	if (pDevice->op_mode == NL80211_IFTYPE_STATION)
-		PSbSendNullPacket(pDevice);
+	if (priv->op_mode == NL80211_IFTYPE_STATION)
+		PSbSendNullPacket(priv);
 
-	pDevice->bPWBitOn = true;
+	priv->bPWBitOn = true;
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "PS:Power Saving Mode Enable...\n");
 }
 
-- 
1.9.1

