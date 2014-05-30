Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:51637 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934768AbaE3WYS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 18:24:18 -0400
Received: by mail-wg0-f47.google.com with SMTP id x12so2602370wgg.6
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 15:24:17 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 8/8] staging: vt6656: rename CARDvSetBSSMode to vnt_set_bss_mode
Date: Fri, 30 May 2014 23:22:54 +0100
Message-Id: <1401488574-16508-8-git-send-email-tvboxspy@gmail.com> (sfid-20140531_002423_278271_AB200854)
In-Reply-To: <1401488574-16508-1-git-send-email-tvboxspy@gmail.com>
References: <1401488574-16508-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drop card and rename to vnt_set_bss_mode

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c     |  2 +-
 drivers/staging/vt6656/card.h     |  2 +-
 drivers/staging/vt6656/main_usb.c |  2 +-
 drivers/staging/vt6656/wcmd.c     |  6 +++---
 drivers/staging/vt6656/wmgr.c     | 10 +++++-----
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 366d7d5..ffd6a01 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -829,7 +829,7 @@ int vnt_radio_power_on(struct vnt_private *priv)
 	return ret;
 }
 
-void CARDvSetBSSMode(struct vnt_private *priv)
+void vnt_set_bss_mode(struct vnt_private *priv)
 {
 	if (priv->byRFType == RF_AIROHA7230 && priv->byBBType == BB_TYPE_11A)
 		MACvSetBBType(priv, BB_TYPE_11G);
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index 150f870..8c6f67d 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -61,6 +61,6 @@ u64 vnt_get_tsf_offset(u8 byRxRate, u64 qwTSF1, u64 qwTSF2);
 int vnt_radio_power_off(struct vnt_private *);
 int vnt_radio_power_on(struct vnt_private *);
 u8 vnt_get_pkt_type(struct vnt_private *);
-void CARDvSetBSSMode(struct vnt_private *pDevice);
+void vnt_set_bss_mode(struct vnt_private *);
 
 #endif /* __CARD_H__ */
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 09da861..bdb9de8 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -525,7 +525,7 @@ static int device_init_registers(struct vnt_private *pDevice)
 	}
 
 	BBvSetShortSlotTime(pDevice);
-	CARDvSetBSSMode(pDevice);
+	vnt_set_bss_mode(pDevice);
 
 	pDevice->byBBVGACurrent = pDevice->abyBBVGA[0];
 	pDevice->byBBVGANew = pDevice->byBBVGACurrent;
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 191e788..acd5be7 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -333,11 +333,11 @@ void vRunCommand(struct work_struct *work)
 			if ((pDevice->byBBType != BB_TYPE_11A) &&
 			    (pMgmt->uScanChannel > CB_MAX_CHANNEL_24G)) {
 				pDevice->byBBType = BB_TYPE_11A;
-				CARDvSetBSSMode(pDevice);
+				vnt_set_bss_mode(pDevice);
 			} else if ((pDevice->byBBType == BB_TYPE_11A) &&
 				   (pMgmt->uScanChannel <= CB_MAX_CHANNEL_24G)) {
 				pDevice->byBBType = BB_TYPE_11G;
-				CARDvSetBSSMode(pDevice);
+				vnt_set_bss_mode(pDevice);
 			}
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Scanning....  channel: [%d]\n", pMgmt->uScanChannel);
 			// Set channel
@@ -377,7 +377,7 @@ void vRunCommand(struct work_struct *work)
 		// Set Baseband's sensitivity back.
 		if (pDevice->byBBType != pDevice->byScanBBType) {
 			pDevice->byBBType = pDevice->byScanBBType;
-			CARDvSetBSSMode(pDevice);
+			vnt_set_bss_mode(pDevice);
 		}
 
 		BBvSetShortSlotTime(pDevice);
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 1646aaf..0ba292c 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -2081,7 +2081,7 @@ void vMgrCreateOwnIBSS(struct vnt_private *pDevice, PCMD_STATUS pStatus)
     // vUpdateIFS() use pDevice->bShortSlotTime as parameter so it must be called
     // after setting ShortSlotTime.
     // CARDvSetBSSMode call vUpdateIFS()
-    CARDvSetBSSMode(pDevice);
+    vnt_set_bss_mode(pDevice);
 
     if (pMgmt->eConfigMode == WMAC_CONFIG_AP) {
         MACvRegBitsOn(pDevice, MAC_REG_HOSTCR, HOSTCR_AP);
@@ -2601,7 +2601,7 @@ static void s_vMgrSynchBSS(struct vnt_private *pDevice, u32 uBSSMode,
             pMgmt->eCurrentPHYMode = PHY_TYPE_11A;
             pDevice->bShortSlotTime = true;
             BBvSetShortSlotTime(pDevice);
-            CARDvSetBSSMode(pDevice);
+	    vnt_set_bss_mode(pDevice);
         } else {
             return;
         }
@@ -2613,7 +2613,7 @@ static void s_vMgrSynchBSS(struct vnt_private *pDevice, u32 uBSSMode,
             pMgmt->eCurrentPHYMode = PHY_TYPE_11B;
             pDevice->bShortSlotTime = false;
             BBvSetShortSlotTime(pDevice);
-            CARDvSetBSSMode(pDevice);
+	    vnt_set_bss_mode(pDevice);
         } else {
             return;
         }
@@ -2624,12 +2624,12 @@ static void s_vMgrSynchBSS(struct vnt_private *pDevice, u32 uBSSMode,
             pMgmt->eCurrentPHYMode = PHY_TYPE_11G;
             pDevice->bShortSlotTime = true;
             BBvSetShortSlotTime(pDevice);
-            CARDvSetBSSMode(pDevice);
+	    vnt_set_bss_mode(pDevice);
         } else if (pDevice->eConfigPHYMode == PHY_TYPE_11B) {
             pDevice->byBBType = BB_TYPE_11B;
             pDevice->bShortSlotTime = false;
             BBvSetShortSlotTime(pDevice);
-            CARDvSetBSSMode(pDevice);
+	    vnt_set_bss_mode(pDevice);
         } else {
             return;
         }
-- 
1.9.1

