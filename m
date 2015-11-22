Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:33378 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbbKVJIM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Nov 2015 04:08:12 -0500
Received: by wmec201 with SMTP id c201so123235576wme.0
        for <linux-wireless@vger.kernel.org>; Sun, 22 Nov 2015 01:08:11 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/8] staging: vt6655: power.c replace pDevice with priv
Date: Sun, 22 Nov 2015 09:07:19 +0000
Message-Id: <1448183242-3397-5-git-send-email-tvboxspy@gmail.com> (sfid-20151122_100833_183750_DEA3F92B)
In-Reply-To: <1448183242-3397-1-git-send-email-tvboxspy@gmail.com>
References: <1448183242-3397-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing camel case.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/power.c | 56 +++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/vt6655/power.c b/drivers/staging/vt6655/power.c
index 06e6b9d..e58afbd 100644
--- a/drivers/staging/vt6655/power.c
+++ b/drivers/staging/vt6655/power.c
@@ -68,40 +68,40 @@ PSvEnablePowerSaving(
 	unsigned short wListenInterval
 )
 {
-	struct vnt_private *pDevice = hDeviceContext;
-	u16 wAID = pDevice->current_aid | BIT(14) | BIT(15);
+	struct vnt_private *priv = hDeviceContext;
+	u16 wAID = priv->current_aid | BIT(14) | BIT(15);
 
 	/* set period of power up before TBTT */
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_PWBT, C_PWBT);
-	if (pDevice->op_mode != NL80211_IFTYPE_ADHOC) {
+	VNSvOutPortW(priv->PortOffset + MAC_REG_PWBT, C_PWBT);
+	if (priv->op_mode != NL80211_IFTYPE_ADHOC) {
 		/* set AID */
-		VNSvOutPortW(pDevice->PortOffset + MAC_REG_AIDATIM, wAID);
+		VNSvOutPortW(priv->PortOffset + MAC_REG_AIDATIM, wAID);
 	} else {
 		/* set ATIM Window */
 #if 0 /* TODO atim window */
-		MACvWriteATIMW(pDevice->PortOffset, pMgmt->wCurrATIMWindow);
+		MACvWriteATIMW(priv->PortOffset, pMgmt->wCurrATIMWindow);
 #endif
 	}
 	/* Set AutoSleep */
-	MACvRegBitsOn(pDevice->PortOffset, MAC_REG_PSCFG, PSCFG_AUTOSLEEP);
+	MACvRegBitsOn(priv->PortOffset, MAC_REG_PSCFG, PSCFG_AUTOSLEEP);
 	/* Set HWUTSF */
-	MACvRegBitsOn(pDevice->PortOffset, MAC_REG_TFTCTL, TFTCTL_HWUTSF);
+	MACvRegBitsOn(priv->PortOffset, MAC_REG_TFTCTL, TFTCTL_HWUTSF);
 
 	if (wListenInterval >= 2) {
 		/* clear always listen beacon */
-		MACvRegBitsOff(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_ALBCN);
+		MACvRegBitsOff(priv->PortOffset, MAC_REG_PSCTL, PSCTL_ALBCN);
 		/* first time set listen next beacon */
-		MACvRegBitsOn(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_LNBCN);
+		MACvRegBitsOn(priv->PortOffset, MAC_REG_PSCTL, PSCTL_LNBCN);
 	} else {
 		/* always listen beacon */
-		MACvRegBitsOn(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_ALBCN);
+		MACvRegBitsOn(priv->PortOffset, MAC_REG_PSCTL, PSCTL_ALBCN);
 	}
 
 	/* enable power saving hw function */
-	MACvRegBitsOn(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_PSEN);
-	pDevice->bEnablePSMode = true;
+	MACvRegBitsOn(priv->PortOffset, MAC_REG_PSCTL, PSCTL_PSEN);
+	priv->bEnablePSMode = true;
 
-	pDevice->bPWBitOn = true;
+	priv->bPWBitOn = true;
 	pr_debug("PS:Power Saving Mode Enable...\n");
 }
 
@@ -120,20 +120,20 @@ PSvDisablePowerSaving(
 	void *hDeviceContext
 )
 {
-	struct vnt_private *pDevice = hDeviceContext;
+	struct vnt_private *priv = hDeviceContext;
 
 	/* disable power saving hw function */
-	MACbPSWakeup(pDevice->PortOffset);
+	MACbPSWakeup(priv->PortOffset);
 	/* clear AutoSleep */
-	MACvRegBitsOff(pDevice->PortOffset, MAC_REG_PSCFG, PSCFG_AUTOSLEEP);
+	MACvRegBitsOff(priv->PortOffset, MAC_REG_PSCFG, PSCFG_AUTOSLEEP);
 	/* clear HWUTSF */
-	MACvRegBitsOff(pDevice->PortOffset, MAC_REG_TFTCTL, TFTCTL_HWUTSF);
+	MACvRegBitsOff(priv->PortOffset, MAC_REG_TFTCTL, TFTCTL_HWUTSF);
 	/* set always listen beacon */
-	MACvRegBitsOn(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_ALBCN);
+	MACvRegBitsOn(priv->PortOffset, MAC_REG_PSCTL, PSCTL_ALBCN);
 
-	pDevice->bEnablePSMode = false;
+	priv->bEnablePSMode = false;
 
-	pDevice->bPWBitOn = false;
+	priv->bPWBitOn = false;
 }
 
 
@@ -152,20 +152,20 @@ PSbIsNextTBTTWakeUp(
 	void *hDeviceContext
 )
 {
-	struct vnt_private *pDevice = hDeviceContext;
-	struct ieee80211_hw *hw = pDevice->hw;
+	struct vnt_private *priv = hDeviceContext;
+	struct ieee80211_hw *hw = priv->hw;
 	struct ieee80211_conf *conf = &hw->conf;
 	bool bWakeUp = false;
 
 	if (conf->listen_interval > 1) {
-		if (!pDevice->wake_up_count)
-			pDevice->wake_up_count = conf->listen_interval;
+		if (!priv->wake_up_count)
+			priv->wake_up_count = conf->listen_interval;
 
-		--pDevice->wake_up_count;
+		--priv->wake_up_count;
 
-		if (pDevice->wake_up_count == 1) {
+		if (priv->wake_up_count == 1) {
 			/* Turn on wake up to listen next beacon */
-			MACvRegBitsOn(pDevice->PortOffset,
+			MACvRegBitsOn(priv->PortOffset,
 				      MAC_REG_PSCTL, PSCTL_LNBCN);
 			bWakeUp = true;
 		}
-- 
2.6.2

