Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:50737 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224AbaFYUVj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:21:39 -0400
Received: by mail-we0-f176.google.com with SMTP id u56so2685154wes.7
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:21:38 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 21/34] staging: vt6656: remove dead code from power.c/h
Date: Wed, 25 Jun 2014 21:19:58 +0100
Message-Id: <1403727611-6825-22-git-send-email-tvboxspy@gmail.com> (sfid-20140625_223023_842485_967D62D0)
In-Reply-To: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
References: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/power.c | 153 -----------------------------------------
 drivers/staging/vt6656/power.h |   7 --
 2 files changed, 160 deletions(-)

diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
index 1bdbefc..dbda303 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -28,9 +28,6 @@
  * Functions:
  *      vnt_enable_power_saving - Enable Power Saving Mode
  *      PSvDiasblePowerSaving - Disable Power Saving Mode
- *      PSbConsiderPowerDown - Decide if we can Power Down
- *      PSvSendPSPOLL - Send PS-POLL packet
- *      PSbSendNullPacket - Send Null packet
  *      vnt_next_tbtt_wakeup - Decide if we need to wake up at next Beacon
  *
  * Revision History:
@@ -39,7 +36,6 @@
 
 #include "mac.h"
 #include "device.h"
-#include "wmgr.h"
 #include "power.h"
 #include "wcmd.h"
 #include "rxtx.h"
@@ -127,155 +123,6 @@ void vnt_disable_power_saving(struct vnt_private *priv)
 /*
  *
  * Routine Description:
- * Consider to power down when no more packets to tx or rx.
- *
- * Return Value:
- *    true, if power down success
- *    false, if fail
- */
-
-int PSbConsiderPowerDown(struct vnt_private *pDevice, int bCheckRxDMA,
-	int bCheckCountToWakeUp)
-{
-	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
-	u8 byData;
-
-	/* check if already in Doze mode */
-	vnt_control_in_u8(pDevice, MESSAGE_REQUEST_MACREG,
-					MAC_REG_PSCTL, &byData);
-
-	if ((byData & PSCTL_PS) != 0)
-		return true;
-
-	if (pMgmt->eCurrMode != WMAC_MODE_IBSS_STA) {
-		/* check if in TIM wake period */
-		if (pMgmt->bInTIMWake)
-			return false;
-	}
-
-	/* check scan state */
-	if (pDevice->bCmdRunning)
-		return false;
-
-	/* Tx Burst */
-	if (pDevice->bPSModeTxBurst)
-		return false;
-
-	/* Froce PSEN on */
-	vnt_mac_reg_bits_on(pDevice, MAC_REG_PSCTL, PSCTL_PSEN);
-
-	if (pMgmt->eCurrMode != WMAC_MODE_IBSS_STA) {
-		if (bCheckCountToWakeUp && (pMgmt->wCountToWakeUp == 0
-			|| pMgmt->wCountToWakeUp == 1)) {
-				return false;
-		}
-	}
-
-	pDevice->bPSRxBeacon = true;
-
-	/* no Tx, no Rx isr, now go to Doze */
-	vnt_mac_reg_bits_on(pDevice, MAC_REG_PSCTL, PSCTL_GO2DOZE);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Go to Doze ZZZZZZZZZZZZZZZ\n");
-	return true;
-}
-
-/*
- *
- * Routine Description:
- * Send PS-POLL packet
- *
- * Return Value:
- *    None.
- *
- */
-
-void PSvSendPSPOLL(struct vnt_private *pDevice)
-{
-	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
-	struct vnt_tx_mgmt *pTxPacket = NULL;
-
-	memset(pMgmt->pbyPSPacketPool, 0, sizeof(struct vnt_tx_mgmt)
-		+ WLAN_HDR_ADDR2_LEN);
-	pTxPacket = (struct vnt_tx_mgmt *)pMgmt->pbyPSPacketPool;
-	pTxPacket->p80211Header = (PUWLAN_80211HDR)((u8 *)pTxPacket
-		+ sizeof(struct vnt_tx_mgmt));
-
-	pTxPacket->p80211Header->sA2.wFrameCtl = cpu_to_le16(
-		(
-			WLAN_SET_FC_FTYPE(WLAN_TYPE_CTL) |
-			WLAN_SET_FC_FSTYPE(WLAN_FSTYPE_PSPOLL) |
-			WLAN_SET_FC_PWRMGT(0)
-		));
-
-	pTxPacket->p80211Header->sA2.wDurationID =
-		pMgmt->wCurrAID | BIT14 | BIT15;
-	memcpy(pTxPacket->p80211Header->sA2.abyAddr1, pMgmt->abyCurrBSSID,
-		WLAN_ADDR_LEN);
-	memcpy(pTxPacket->p80211Header->sA2.abyAddr2, pMgmt->abyMACAddr,
-		WLAN_ADDR_LEN);
-	pTxPacket->cbMPDULen = WLAN_HDR_ADDR2_LEN;
-	pTxPacket->cbPayloadLen = 0;
-
-	/* log failure if sending failed */
-}
-
-/*
- *
- * Routine Description:
- * Send NULL packet to AP for notification power state of STA
- *
- * Return Value:
- *    None.
- *
- */
-
-int PSbSendNullPacket(struct vnt_private *pDevice)
-{
-	struct vnt_tx_mgmt *pTxPacket = NULL;
-	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
-	u16 flags = 0;
-
-	if (pDevice->bLinkPass == false)
-		return false;
-
-	if (pDevice->bEnablePSMode == false && pDevice->tx_trigger == false)
-		return false;
-
-	memset(pMgmt->pbyPSPacketPool, 0, sizeof(struct vnt_tx_mgmt)
-		+ WLAN_NULLDATA_FR_MAXLEN);
-	pTxPacket = (struct vnt_tx_mgmt *)pMgmt->pbyPSPacketPool;
-	pTxPacket->p80211Header = (PUWLAN_80211HDR)((u8 *)pTxPacket
-		+ sizeof(struct vnt_tx_mgmt));
-
-	flags = WLAN_SET_FC_FTYPE(WLAN_TYPE_DATA) |
-			WLAN_SET_FC_FSTYPE(WLAN_FSTYPE_NULL);
-
-	if (pDevice->bEnablePSMode)
-		flags |= WLAN_SET_FC_PWRMGT(1);
-	else
-		flags |= WLAN_SET_FC_PWRMGT(0);
-
-	pTxPacket->p80211Header->sA3.wFrameCtl = cpu_to_le16(flags);
-
-	if (pMgmt->eCurrMode != WMAC_MODE_IBSS_STA)
-		pTxPacket->p80211Header->sA3.wFrameCtl |=
-			cpu_to_le16((u16)WLAN_SET_FC_TODS(1));
-
-	memcpy(pTxPacket->p80211Header->sA3.abyAddr1, pMgmt->abyCurrBSSID,
-		WLAN_ADDR_LEN);
-	memcpy(pTxPacket->p80211Header->sA3.abyAddr2, pMgmt->abyMACAddr,
-		WLAN_ADDR_LEN);
-	memcpy(pTxPacket->p80211Header->sA3.abyAddr3, pMgmt->abyCurrBSSID,
-		WLAN_BSSID_LEN);
-	pTxPacket->cbMPDULen = WLAN_HDR_ADDR3_LEN;
-	pTxPacket->cbPayloadLen = 0;
-	/* log error if sending failed */
-	return true;
-}
-
-/*
- *
- * Routine Description:
  * Check if Next TBTT must wake up
  *
  * Return Value:
diff --git a/drivers/staging/vt6656/power.h b/drivers/staging/vt6656/power.h
index 313f077..bd9de77 100644
--- a/drivers/staging/vt6656/power.h
+++ b/drivers/staging/vt6656/power.h
@@ -33,15 +33,8 @@
 #define     PS_FAST_INTERVAL         1         // Fast power saving listen interval
 #define     PS_MAX_INTERVAL          4         // MAX power saving listen interval
 
-/*  PSDevice pDevice */
-/*  PSDevice hDeviceContext */
-
-int PSbConsiderPowerDown(struct vnt_private *, int bCheckRxDMA,
-	int bCheckCountToWakeUp);
 void vnt_disable_power_saving(struct vnt_private *);
 void vnt_enable_power_saving(struct vnt_private *, u16);
-void PSvSendPSPOLL(struct vnt_private *);
-int PSbSendNullPacket(struct vnt_private *);
 int vnt_next_tbtt_wakeup(struct vnt_private *);
 
 #endif /* __POWER_H__ */
-- 
1.9.1

