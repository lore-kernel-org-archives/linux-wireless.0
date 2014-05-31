Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:43846 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbaEaKve (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 06:51:34 -0400
Received: by mail-we0-f172.google.com with SMTP id k48so3129040wev.3
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 03:51:33 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/14] staging: vt6656: rename MACvRegBitsOff to vnt_mac_reg_bits_off
Date: Sat, 31 May 2014 11:50:42 +0100
Message-Id: <1401533449-2972-7-git-send-email-tvboxspy@gmail.com> (sfid-20140531_125141_183466_C7B5BFDE)
In-Reply-To: <1401533449-2972-1-git-send-email-tvboxspy@gmail.com>
References: <1401533449-2972-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c |  8 ++++----
 drivers/staging/vt6656/card.c     |  8 ++++----
 drivers/staging/vt6656/mac.c      |  2 +-
 drivers/staging/vt6656/mac.h      |  2 +-
 drivers/staging/vt6656/main_usb.c |  5 +++--
 drivers/staging/vt6656/power.c    | 20 ++++++++++----------
 drivers/staging/vt6656/wcmd.c     |  6 +++---
 drivers/staging/vt6656/wmgr.c     | 16 ++++++++--------
 8 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 694e34a..aada8e7 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -994,7 +994,7 @@ int BBbVT3184Init(struct vnt_private *priv)
 		priv->ldBmThreshold[2] = 0;
 		priv->ldBmThreshold[3] = 0;
 		/* Fix VT3226 DFC system timing issue */
-		MACvRegBitsOn(priv, MAC_REG_SOFTPWRCTL2, SOFTPWRCTL_RFLEOPT);
+		vnt_mac_reg_bits_on(priv, MAC_REG_SOFTPWRCTL2, SOFTPWRCTL_RFLEOPT);
 	} else if ((priv->byRFType == RF_VT3342A0)) {
 		priv->byBBRxConf = abyVT3184_VT3226D0[10];
 		length = sizeof(abyVT3184_VT3226D0);
@@ -1011,7 +1011,7 @@ int BBbVT3184Init(struct vnt_private *priv)
 		priv->ldBmThreshold[2] = 0;
 		priv->ldBmThreshold[3] = 0;
 		/* Fix VT3226 DFC system timing issue */
-		MACvRegBitsOn(priv, MAC_REG_SOFTPWRCTL2, SOFTPWRCTL_RFLEOPT);
+		vnt_mac_reg_bits_on(priv, MAC_REG_SOFTPWRCTL2, SOFTPWRCTL_RFLEOPT);
 	} else {
 		return true;
 	}
@@ -1030,11 +1030,11 @@ int BBbVT3184Init(struct vnt_private *priv)
 		(priv->byRFType == RF_VT3342A0)) {
 		vnt_control_out_u8(priv, MESSAGE_REQUEST_MACREG,
 						MAC_REG_ITRTMSET, 0x23);
-		MACvRegBitsOn(priv, MAC_REG_PAPEDELAY, 0x01);
+		vnt_mac_reg_bits_on(priv, MAC_REG_PAPEDELAY, 0x01);
 	} else if (priv->byRFType == RF_VT3226D0) {
 		vnt_control_out_u8(priv, MESSAGE_REQUEST_MACREG,
 						MAC_REG_ITRTMSET, 0x11);
-		MACvRegBitsOn(priv, MAC_REG_PAPEDELAY, 0x01);
+		vnt_mac_reg_bits_on(priv, MAC_REG_PAPEDELAY, 0x01);
 	}
 
 	vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x04, 0x7f);
diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 4e3f34a..9794116 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -89,7 +89,7 @@ void vnt_set_channel(struct vnt_private *priv, u32 connection_channel)
 	}
 
 	/* clear NAV */
-	MACvRegBitsOn(priv, MAC_REG_MACCR, MACCR_CLRNAV);
+	vnt_mac_reg_bits_on(priv, MAC_REG_MACCR, MACCR_CLRNAV);
 
 	/* Set Channel[7] = 0 to tell H/W channel is changing now. */
 	vnt_mac_reg_bits_off(priv, MAC_REG_CHANNEL, 0xb0);
@@ -636,7 +636,7 @@ bool vnt_get_current_tsf(struct vnt_private *priv, u64 *current_tsf)
 bool vnt_clear_current_tsf(struct vnt_private *priv)
 {
 
-	MACvRegBitsOn(priv, MAC_REG_TFTCTL, TFTCTL_TSFCNTRST);
+	vnt_mac_reg_bits_on(priv, MAC_REG_TFTCTL, TFTCTL_TSFCNTRST);
 
 	priv->qwCurrTSF = 0;
 
@@ -812,7 +812,7 @@ int vnt_radio_power_on(struct vnt_private *priv)
 
 	BBvExitDeepSleep(priv);
 
-	MACvRegBitsOn(priv, MAC_REG_HOSTCR, HOSTCR_RXON);
+	vnt_mac_reg_bits_on(priv, MAC_REG_HOSTCR, HOSTCR_RXON);
 
 	switch (priv->byRFType) {
 	case RF_AL2230:
@@ -821,7 +821,7 @@ int vnt_radio_power_on(struct vnt_private *priv)
 	case RF_VT3226:
 	case RF_VT3226D0:
 	case RF_VT3342A0:
-		MACvRegBitsOn(priv, MAC_REG_SOFTPWRCTL,
+		vnt_mac_reg_bits_on(priv, MAC_REG_SOFTPWRCTL,
 			(SOFTPWRCTL_SWPE2 | SOFTPWRCTL_SWPE3));
 		break;
 	}
diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index cf62ddf..58a1a01 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -158,7 +158,7 @@ void vnt_mac_reg_bits_off(struct vnt_private *priv, u8 reg_ofs, u8 bits)
 		reg_ofs, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
-void MACvRegBitsOn(struct vnt_private *priv, u8 reg_ofs, u8 bits)
+void vnt_mac_reg_bits_on(struct vnt_private *priv, u8 reg_ofs, u8 bits)
 {
 	u8 data[2];
 
diff --git a/drivers/staging/vt6656/mac.h b/drivers/staging/vt6656/mac.h
index a12f883..d41299c 100644
--- a/drivers/staging/vt6656/mac.h
+++ b/drivers/staging/vt6656/mac.h
@@ -420,7 +420,7 @@ void vnt_mac_set_bb_type(struct vnt_private *, u8);
 void vnt_mac_disable_keyentry(struct vnt_private *, u8);
 void vnt_mac_set_keyentry(struct vnt_private *, u16, u32, u32, u8 *, u8 *);
 void vnt_mac_reg_bits_off(struct vnt_private *, u8, u8);
-void MACvRegBitsOn(struct vnt_private *, u8, u8);
+void vnt_mac_reg_bits_on(struct vnt_private *, u8, u8);
 void MACvWriteWord(struct vnt_private *, u8, u16);
 void MACvWriteBSSIDAddress(struct vnt_private *, u8 *);
 void MACvEnableProtectMD(struct vnt_private *);
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index e8c5f97..ebb0955 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -544,7 +544,8 @@ static int device_init_registers(struct vnt_private *pDevice)
 
 		if ((byTmp & GPIO3_DATA) == 0) {
 			pDevice->bHWRadioOff = true;
-			MACvRegBitsOn(pDevice, MAC_REG_GPIOCTL1, GPIO3_INTMD);
+			vnt_mac_reg_bits_on(pDevice, MAC_REG_GPIOCTL1,
+								GPIO3_INTMD);
 		} else {
 			vnt_mac_reg_bits_off(pDevice, MAC_REG_GPIOCTL1,
 								GPIO3_INTMD);
@@ -557,7 +558,7 @@ static int device_init_registers(struct vnt_private *pDevice)
 
 	vnt_mac_set_led(pDevice, LEDSTS_STS, LEDSTS_SLOW);
 
-	MACvRegBitsOn(pDevice, MAC_REG_GPIOCTL0, 0x01);
+	vnt_mac_reg_bits_on(pDevice, MAC_REG_GPIOCTL0, 0x01);
 
 	if ((pDevice->bHWRadioOff == true) ||
 				(pDevice->bRadioControlOff == true)) {
diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
index fc7a29b..7c61da6 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -75,15 +75,15 @@ void PSvEnablePowerSaving(struct vnt_private *pDevice, u16 wListenInterval)
 	 * PSEN->AUTOSLEEP->GO2DOZE
 	 */
 	/* enable power saving hw function */
-	MACvRegBitsOn(pDevice, MAC_REG_PSCTL, PSCTL_PSEN);
+	vnt_mac_reg_bits_on(pDevice, MAC_REG_PSCTL, PSCTL_PSEN);
 
 	/* Set AutoSleep */
-	MACvRegBitsOn(pDevice, MAC_REG_PSCFG, PSCFG_AUTOSLEEP);
+	vnt_mac_reg_bits_on(pDevice, MAC_REG_PSCFG, PSCFG_AUTOSLEEP);
 
 	/* Warren:MUST turn on this once before turn on AUTOSLEEP ,or the
 	 * AUTOSLEEP doesn't work
 	 */
-	MACvRegBitsOn(pDevice, MAC_REG_PSCTL, PSCTL_GO2DOZE);
+	vnt_mac_reg_bits_on(pDevice, MAC_REG_PSCTL, PSCTL_GO2DOZE);
 
 	if (wListenInterval >= 2) {
 
@@ -91,14 +91,14 @@ void PSvEnablePowerSaving(struct vnt_private *pDevice, u16 wListenInterval)
 		vnt_mac_reg_bits_off(pDevice, MAC_REG_PSCTL, PSCTL_ALBCN);
 
 		/* first time set listen next beacon */
-		MACvRegBitsOn(pDevice, MAC_REG_PSCTL, PSCTL_LNBCN);
+		vnt_mac_reg_bits_on(pDevice, MAC_REG_PSCTL, PSCTL_LNBCN);
 
 		pMgmt->wCountToWakeUp = wListenInterval;
 
 	} else {
 
 		/* always listen beacon */
-		MACvRegBitsOn(pDevice, MAC_REG_PSCTL, PSCTL_ALBCN);
+		vnt_mac_reg_bits_on(pDevice, MAC_REG_PSCTL, PSCTL_ALBCN);
 
 		pMgmt->wCountToWakeUp = 0;
 	}
@@ -136,7 +136,7 @@ void PSvDisablePowerSaving(struct vnt_private *pDevice)
 	vnt_mac_reg_bits_off(pDevice, MAC_REG_PSCFG, PSCFG_AUTOSLEEP);
 
 	/* set always listen beacon */
-	MACvRegBitsOn(pDevice, MAC_REG_PSCTL, PSCTL_ALBCN);
+	vnt_mac_reg_bits_on(pDevice, MAC_REG_PSCTL, PSCTL_ALBCN);
 	pDevice->bEnablePSMode = false;
 
 	if (pDevice->op_mode == NL80211_IFTYPE_STATION)
@@ -183,7 +183,7 @@ int PSbConsiderPowerDown(struct vnt_private *pDevice, int bCheckRxDMA,
 		return false;
 
 	/* Froce PSEN on */
-	MACvRegBitsOn(pDevice, MAC_REG_PSCTL, PSCTL_PSEN);
+	vnt_mac_reg_bits_on(pDevice, MAC_REG_PSCTL, PSCTL_PSEN);
 
 	if (pMgmt->eCurrMode != WMAC_MODE_IBSS_STA) {
 		if (bCheckCountToWakeUp && (pMgmt->wCountToWakeUp == 0
@@ -195,7 +195,7 @@ int PSbConsiderPowerDown(struct vnt_private *pDevice, int bCheckRxDMA,
 	pDevice->bPSRxBeacon = true;
 
 	/* no Tx, no Rx isr, now go to Doze */
-	MACvRegBitsOn(pDevice, MAC_REG_PSCTL, PSCTL_GO2DOZE);
+	vnt_mac_reg_bits_on(pDevice, MAC_REG_PSCTL, PSCTL_GO2DOZE);
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Go to Doze ZZZZZZZZZZZZZZZ\n");
 	return true;
 }
@@ -325,12 +325,12 @@ int PSbIsNextTBTTWakeUp(struct vnt_private *pDevice)
 
 		if (pMgmt->wCountToWakeUp == 1) {
 			/* Turn on wake up to listen next beacon */
-			MACvRegBitsOn(pDevice, MAC_REG_PSCTL, PSCTL_LNBCN);
+			vnt_mac_reg_bits_on(pDevice, MAC_REG_PSCTL, PSCTL_LNBCN);
 			pDevice->bPSRxBeacon = false;
 			bWakeUp = true;
 		} else if (!pDevice->bPSRxBeacon) {
 			/* Listen until RxBeacon */
-			MACvRegBitsOn(pDevice, MAC_REG_PSCTL, PSCTL_LNBCN);
+			vnt_mac_reg_bits_on(pDevice, MAC_REG_PSCTL, PSCTL_LNBCN);
 		}
 	}
 	return bWakeUp;
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 35cf0cf..ae773a6 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -142,7 +142,7 @@ static void vAdHocBeaconRestart(struct vnt_private *pDevice)
 	if ((pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) &&
 	    (pMgmt->eCurrState >= WMAC_STATE_STARTED)) {
 		//PMESG(("RESTART_BEACON\n"));
-		MACvRegBitsOn(pDevice, MAC_REG_TCR, TCR_AUTOBCNTX);
+		vnt_mac_reg_bits_on(pDevice, MAC_REG_TCR, TCR_AUTOBCNTX);
 	}
 
 }
@@ -390,7 +390,7 @@ void vRunCommand(struct work_struct *work)
 		vnt_set_channel(pDevice, pMgmt->uCurrChannel);
 		// Set Filter
 		if (pMgmt->bCurrBSSIDFilterOn) {
-			MACvRegBitsOn(pDevice, MAC_REG_RCR, RCR_BSSID);
+			vnt_mac_reg_bits_on(pDevice, MAC_REG_RCR, RCR_BSSID);
 			pDevice->byRxMode |= RCR_BSSID;
 		}
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Scanning, set back to channel: [%d]\n", pMgmt->uCurrChannel);
@@ -799,7 +799,7 @@ void vRunCommand(struct work_struct *work)
 
 				netif_stop_queue(pDevice->dev);
 				vnt_radio_power_off(pDevice);
-				MACvRegBitsOn(pDevice, MAC_REG_GPIOCTL1, GPIO3_INTMD);
+				vnt_mac_reg_bits_on(pDevice, MAC_REG_GPIOCTL1, GPIO3_INTMD);
 
 				vnt_mac_set_led(pDevice, LEDSTS_STS, LEDSTS_OFF);
 
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 7827d79..66548ff 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -2048,7 +2048,7 @@ void vMgrCreateOwnIBSS(struct vnt_private *pDevice, PCMD_STATUS pStatus)
     vnt_clear_current_tsf(pDevice);
 
     // enable TSF counter
-    MACvRegBitsOn(pDevice,MAC_REG_TFTCTL,TFTCTL_TSFCNTREN);
+    vnt_mac_reg_bits_on(pDevice, MAC_REG_TFTCTL, TFTCTL_TSFCNTREN);
     // set Next TBTT
     vnt_reset_next_tbtt(pDevice, pMgmt->wIBSSBeaconPeriod);
 
@@ -2083,12 +2083,12 @@ void vMgrCreateOwnIBSS(struct vnt_private *pDevice, PCMD_STATUS pStatus)
     vnt_set_bss_mode(pDevice);
 
     if (pMgmt->eConfigMode == WMAC_CONFIG_AP) {
-        MACvRegBitsOn(pDevice, MAC_REG_HOSTCR, HOSTCR_AP);
+	vnt_mac_reg_bits_on(pDevice, MAC_REG_HOSTCR, HOSTCR_AP);
         pMgmt->eCurrMode = WMAC_MODE_ESS_AP;
     }
 
     if (pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) {
-        MACvRegBitsOn(pDevice, MAC_REG_HOSTCR, HOSTCR_ADHOC);
+	vnt_mac_reg_bits_on(pDevice, MAC_REG_HOSTCR, HOSTCR_ADHOC);
         pMgmt->eCurrMode = WMAC_MODE_IBSS_STA;
     }
 
@@ -2142,7 +2142,7 @@ void vMgrCreateOwnIBSS(struct vnt_private *pDevice, PCMD_STATUS pStatus)
     MACvWriteBSSIDAddress(pDevice, pMgmt->abyCurrBSSID);
     memcpy(pDevice->abyBSSID, pMgmt->abyCurrBSSID, WLAN_ADDR_LEN);
 
-    MACvRegBitsOn(pDevice, MAC_REG_RCR, RCR_BSSID);
+    vnt_mac_reg_bits_on(pDevice, MAC_REG_RCR, RCR_BSSID);
     pDevice->byRxMode |= RCR_BSSID;
     pMgmt->bCurrBSSIDFilterOn = true;
 
@@ -2636,7 +2636,7 @@ static void s_vMgrSynchBSS(struct vnt_private *pDevice, u32 uBSSMode,
 
     if (uBSSMode == WMAC_MODE_ESS_STA) {
 	vnt_mac_reg_bits_off(pDevice, MAC_REG_HOSTCR, HOSTCR_ADHOC);
-        MACvRegBitsOn(pDevice, MAC_REG_RCR, RCR_BSSID);
+	vnt_mac_reg_bits_on(pDevice, MAC_REG_RCR, RCR_BSSID);
         pDevice->byRxMode |= RCR_BSSID;
         pMgmt->bCurrBSSIDFilterOn = true;
     }
@@ -2658,8 +2658,8 @@ static void s_vMgrSynchBSS(struct vnt_private *pDevice, u32 uBSSMode,
     // 2. In Infra mode : Supposed we already synchronized with AP right now.
 
     if (uBSSMode == WMAC_MODE_IBSS_STA) {
-        MACvRegBitsOn(pDevice, MAC_REG_HOSTCR, HOSTCR_ADHOC);
-        MACvRegBitsOn(pDevice, MAC_REG_RCR, RCR_BSSID);
+	vnt_mac_reg_bits_on(pDevice, MAC_REG_HOSTCR, HOSTCR_ADHOC);
+	vnt_mac_reg_bits_on(pDevice, MAC_REG_RCR, RCR_BSSID);
         pDevice->byRxMode |= RCR_BSSID;
         pMgmt->bCurrBSSIDFilterOn = true;
     }
@@ -4059,7 +4059,7 @@ int bMgrPrepareBeaconToSend(struct vnt_private *pDevice,
 
 	spin_unlock_irqrestore(&pDevice->lock, flags);
 
-	MACvRegBitsOn(pDevice, MAC_REG_TCR, TCR_AUTOBCNTX);
+	vnt_mac_reg_bits_on(pDevice, MAC_REG_TCR, TCR_AUTOBCNTX);
 
     return true;
 }
-- 
1.9.1

