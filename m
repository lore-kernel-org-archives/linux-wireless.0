Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:42068 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaGLGyf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 02:54:35 -0400
Received: by mail-wi0-f170.google.com with SMTP id cc10so260328wib.3
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jul 2014 23:54:34 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/10] staging: vt6656: vRunCommand remove camel case.
Date: Sat, 12 Jul 2014 07:53:42 +0100
Message-Id: <1405148028-4053-4-git-send-email-tvboxspy@gmail.com> (sfid-20140712_085439_543257_645B0412)
In-Reply-To: <1405148028-4053-1-git-send-email-tvboxspy@gmail.com>
References: <1405148028-4053-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pDevice -> priv

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/wcmd.c | 56 ++++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 5001193..5621c14 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -61,78 +61,80 @@ static void vCommandTimerWait(struct vnt_private *priv, unsigned long msecs)
 
 void vRunCommand(struct work_struct *work)
 {
-	struct vnt_private *pDevice =
+	struct vnt_private *priv =
 		container_of(work, struct vnt_private, run_command_work.work);
 
-	if (pDevice->Flags & fMP_DISCONNECTED)
+	if (priv->Flags & fMP_DISCONNECTED)
 		return;
 
-	if (pDevice->bCmdRunning != true)
+	if (priv->bCmdRunning != true)
 		return;
 
-	switch (pDevice->eCommandState) {
+	switch (priv->eCommandState) {
 	case WLAN_CMD_INIT_MAC80211_START:
-		if (pDevice->mac_hw)
+		if (priv->mac_hw)
 			break;
 
-		dev_info(&pDevice->usb->dev, "Starting mac80211\n");
+		dev_info(&priv->usb->dev, "Starting mac80211\n");
 
-		if (vnt_init(pDevice)) {
+		if (vnt_init(priv)) {
 			/* If fail all ends TODO retry */
-			dev_err(&pDevice->usb->dev, "failed to start\n");
-			ieee80211_free_hw(pDevice->hw);
+			dev_err(&priv->usb->dev, "failed to start\n");
+			ieee80211_free_hw(priv->hw);
 			return;
 		}
 
 		break;
 
 	case WLAN_CMD_TBTT_WAKEUP_START:
-		vnt_next_tbtt_wakeup(pDevice);
+		vnt_next_tbtt_wakeup(priv);
 		break;
 
 	case WLAN_CMD_BECON_SEND_START:
-		if (!pDevice->vif)
+		if (!priv->vif)
 			break;
 
-		vnt_beacon_make(pDevice, pDevice->vif);
+		vnt_beacon_make(priv, priv->vif);
 
-		vnt_mac_reg_bits_on(pDevice, MAC_REG_TCR, TCR_AUTOBCNTX);
+		vnt_mac_reg_bits_on(priv, MAC_REG_TCR, TCR_AUTOBCNTX);
 
 		break;
 
 	case WLAN_CMD_SETPOWER_START:
 
-		vnt_rf_setpower(pDevice, pDevice->wCurrentRate,
-				pDevice->hw->conf.chandef.chan->hw_value);
+		vnt_rf_setpower(priv, priv->wCurrentRate,
+				priv->hw->conf.chandef.chan->hw_value);
 
 		break;
 
 	case WLAN_CMD_CHANGE_ANTENNA_START:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Change from Antenna%d to", (int)pDevice->dwRxAntennaSel);
-		if (pDevice->dwRxAntennaSel == 0) {
-			pDevice->dwRxAntennaSel = 1;
-			if (pDevice->bTxRxAntInv == true)
-				BBvSetAntennaMode(pDevice, ANT_RXA);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"Change from Antenna%d to", (int)priv->dwRxAntennaSel);
+
+		if (priv->dwRxAntennaSel == 0) {
+			priv->dwRxAntennaSel = 1;
+			if (priv->bTxRxAntInv == true)
+				BBvSetAntennaMode(priv, ANT_RXA);
 			else
-				BBvSetAntennaMode(pDevice, ANT_RXB);
+				BBvSetAntennaMode(priv, ANT_RXB);
 		} else {
-			pDevice->dwRxAntennaSel = 0;
-			if (pDevice->bTxRxAntInv == true)
-				BBvSetAntennaMode(pDevice, ANT_RXB);
+			priv->dwRxAntennaSel = 0;
+			if (priv->bTxRxAntInv == true)
+				BBvSetAntennaMode(priv, ANT_RXB);
 			else
-				BBvSetAntennaMode(pDevice, ANT_RXA);
+				BBvSetAntennaMode(priv, ANT_RXA);
 		}
 		break;
 
 	case WLAN_CMD_11H_CHSW_START:
-		vnt_set_channel(pDevice, pDevice->hw->conf.chandef.chan->hw_value);
+		vnt_set_channel(priv, priv->hw->conf.chandef.chan->hw_value);
 		break;
 
 	default:
 		break;
 	} //switch
 
-	s_bCommandComplete(pDevice);
+	s_bCommandComplete(priv);
 
 	return;
 }
-- 
1.9.1

