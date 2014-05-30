Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:55330 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbaE3P21 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 11:28:27 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so2183829wgg.24
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 08:28:26 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 01/12] staging: vt6656: rename CARDbSetMediaChannel to vnt_set_channel
Date: Fri, 30 May 2014 16:27:40 +0100
Message-Id: <1401463671-4705-1-git-send-email-tvboxspy@gmail.com> (sfid-20140530_172831_235891_41E3F9CE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drop card and media and just use vnt_set_channel.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c     | 2 +-
 drivers/staging/vt6656/card.h     | 2 +-
 drivers/staging/vt6656/main_usb.c | 3 ++-
 drivers/staging/vt6656/wcmd.c     | 6 +++---
 drivers/staging/vt6656/wmgr.c     | 4 ++--
 5 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index d662e54..f8ba75b 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -75,7 +75,7 @@ static const u16 cwRXBCNTSFOff[MAX_RATE] =
  *  Out:
  *      none
  */
-void CARDbSetMediaChannel(struct vnt_private *priv, u32 connection_channel)
+void vnt_set_channel(struct vnt_private *priv, u32 connection_channel)
 {
 
 	if (priv->byBBType == BB_TYPE_11A) {
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index ac73471..06498ef 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -45,7 +45,7 @@ typedef enum _CARD_PHY_TYPE {
 
 struct vnt_private;
 
-void CARDbSetMediaChannel(struct vnt_private *pDevice, u32 uConnectionChannel);
+void vnt_set_channel(struct vnt_private *, u32);
 void CARDvSetRSPINF(struct vnt_private *, u8);
 void vUpdateIFS(struct vnt_private *);
 void CARDvUpdateBasicTopRate(struct vnt_private *);
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index e18071f..aca486d 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -500,7 +500,8 @@ static int device_init_registers(struct vnt_private *pDevice)
 	pMgmt->eScanType = WMAC_SCAN_PASSIVE;
 	pMgmt->uCurrChannel = pDevice->uChannel;
 	pMgmt->uIBSSChannel = pDevice->uChannel;
-	CARDbSetMediaChannel(pDevice, pMgmt->uCurrChannel);
+
+	vnt_set_channel(pDevice, pMgmt->uCurrChannel);
 
 	/* get permanent network address */
 	memcpy(pDevice->abyPermanentNetAddr, init_rsp->net_addr, 6);
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index da72d4d..cec6fc6 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -341,7 +341,7 @@ void vRunCommand(struct work_struct *work)
 			}
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Scanning....  channel: [%d]\n", pMgmt->uScanChannel);
 			// Set channel
-			CARDbSetMediaChannel(pDevice, pMgmt->uScanChannel);
+			vnt_set_channel(pDevice, pMgmt->uScanChannel);
 			// Set Baseband to be more sensitive.
 
 			BBvSetShortSlotTime(pDevice);
@@ -387,7 +387,7 @@ void vRunCommand(struct work_struct *work)
 		// Set channel back
 		vAdHocBeaconRestart(pDevice);
 		// Set channel back
-		CARDbSetMediaChannel(pDevice, pMgmt->uCurrChannel);
+		vnt_set_channel(pDevice, pMgmt->uCurrChannel);
 		// Set Filter
 		if (pMgmt->bCurrBSSIDFilterOn) {
 			MACvRegBitsOn(pDevice, MAC_REG_RCR, RCR_BSSID);
@@ -876,7 +876,7 @@ void vRunCommand(struct work_struct *work)
 		break;
 
 	case WLAN_CMD_11H_CHSW_START:
-		CARDbSetMediaChannel(pDevice, pDevice->byNewChannel);
+		vnt_set_channel(pDevice, pDevice->byNewChannel);
 		pDevice->bChannelSwitch = false;
 		pMgmt->uCurrChannel = pDevice->byNewChannel;
 		pDevice->bStopDataPkt = false;
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 18723ea..c30782f 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -2059,7 +2059,7 @@ void vMgrCreateOwnIBSS(struct vnt_private *pDevice, PCMD_STATUS pStatus)
         pMgmt->uIBSSChannel = DEFAULT_IBSS_CHANNEL;
 
     // set channel and clear NAV
-    CARDbSetMediaChannel(pDevice, pMgmt->uIBSSChannel);
+    vnt_set_channel(pDevice, pMgmt->uIBSSChannel);
     pMgmt->uCurrChannel = pMgmt->uIBSSChannel;
 
     pDevice->byPreambleType = pDevice->byShortPreamble;
@@ -2642,7 +2642,7 @@ static void s_vMgrSynchBSS(struct vnt_private *pDevice, u32 uBSSMode,
     }
 
     // set channel and clear NAV
-    CARDbSetMediaChannel(pDevice, pCurr->uChannel);
+    vnt_set_channel(pDevice, pCurr->uChannel);
     pMgmt->uCurrChannel = pCurr->uChannel;
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "<----s_bSynchBSS Set Channel [%d]\n", pCurr->uChannel);
 
-- 
1.9.1

