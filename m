Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:32892 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933271AbaE3P2d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 11:28:33 -0400
Received: by mail-wi0-f176.google.com with SMTP id n15so1343329wiw.3
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 08:28:32 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/12] staging: vt6656: rename vUpdateIFS to vnt_update_ifs
Date: Fri, 30 May 2014 16:27:44 +0100
Message-Id: <1401463671-4705-5-git-send-email-tvboxspy@gmail.com> (sfid-20140530_172838_922974_5E7E68C9)
In-Reply-To: <1401463671-4705-1-git-send-email-tvboxspy@gmail.com>
References: <1401463671-4705-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/bssdb.c |  4 ++--
 drivers/staging/vt6656/card.c  |  8 ++++----
 drivers/staging/vt6656/card.h  |  2 +-
 drivers/staging/vt6656/wmgr.c  | 13 +++++++------
 4 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
index 8e9ce96..fd7ed1d 100644
--- a/drivers/staging/vt6656/bssdb.c
+++ b/drivers/staging/vt6656/bssdb.c
@@ -959,12 +959,12 @@ void BSSvSecondCallBack(struct work_struct *work)
 			if (pDevice->bShortSlotTime) {
 				pDevice->bShortSlotTime = false;
 				BBvSetShortSlotTime(pDevice);
-				vUpdateIFS((void *) pDevice);
+				vnt_update_ifs(pDevice);
 			}
 		} else if (!pDevice->bShortSlotTime) {
 				pDevice->bShortSlotTime = true;
 				BBvSetShortSlotTime(pDevice);
-				vUpdateIFS((void *) pDevice);
+				vnt_update_ifs(pDevice);
 		}
 
 		/* on/off barker long preamble mode */
diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 9c88134..b2192c1 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -21,7 +21,7 @@
  * Functions:
  *      s_vSafeResetTx - Rest Tx
  *      CARDvSetRSPINF - Set RSPINF
- *      vUpdateIFS - Update slotTime,SIFS,DIFS, and EIFS
+ *      vnt_update_ifs - Update slotTime,SIFS,DIFS, and EIFS
  *      CARDvUpdateBasicTopRate - Update BasicTopRate
  *      CARDbAddBasicRate - Add to BasicRateSet
  *      CARDbSetBasicRate - Set Basic Tx Rate
@@ -41,7 +41,7 @@
  * Revision History:
  *      06-10-2003 Bryan YC Fan:  Re-write codes to support VT3253 spec.
  *      08-26-2003 Kyle Hsu:      Modify the definition type of dwIoBase.
- *      09-01-2003 Bryan YC Fan:  Add vUpdateIFS().
+ *      09-01-2003 Bryan YC Fan:  Add vnt_update_ifs().
  *
  */
 
@@ -384,7 +384,7 @@ void CARDvSetRSPINF(struct vnt_private *priv, u8 bb_type)
  * Return Value: None.
  *
  */
-void vUpdateIFS(struct vnt_private *priv)
+void vnt_update_ifs(struct vnt_private *priv)
 {
 	u8 max_min = 0;
 	u8 data[4];
@@ -845,7 +845,7 @@ void CARDvSetBSSMode(struct vnt_private *priv)
 	else if (priv->byBBType == BB_TYPE_11G)
 		vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x88, 0x08);
 
-	vUpdateIFS(priv);
+	vnt_update_ifs(priv);
 	CARDvSetRSPINF(priv, (u8)priv->byBBType);
 
 	if (priv->byBBType == BB_TYPE_11A) {
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index 06498ef..0b5c11c 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -47,7 +47,7 @@ struct vnt_private;
 
 void vnt_set_channel(struct vnt_private *, u32);
 void CARDvSetRSPINF(struct vnt_private *, u8);
-void vUpdateIFS(struct vnt_private *);
+void vnt_update_ifs(struct vnt_private *);
 void CARDvUpdateBasicTopRate(struct vnt_private *);
 void CARDbAddBasicRate(struct vnt_private *, u16);
 int CARDbIsOFDMinBasicRate(struct vnt_private *pDevice);
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index c30782f..c1151b9 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -1659,7 +1659,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
                         } else {
                             MACvDisableProtectMD(pDevice);
                         }
-                        vUpdateIFS(pDevice);
+			vnt_update_ifs(pDevice);
                     }
                     if ((pBSSList->sERP.byERP & WLAN_EID_ERP_NONERP_PRESENT) != pDevice->bNonERPPresent) {//0000 0001
                         pDevice->bNonERPPresent = (pBSSList->sERP.byERP & WLAN_EID_ERP_USE_PROTECTION);
@@ -1690,7 +1690,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
                     if (bShortSlotTime != pDevice->bShortSlotTime) {
                         pDevice->bShortSlotTime = bShortSlotTime;
                         BBvSetShortSlotTime(pDevice);
-                        vUpdateIFS(pDevice);
+			vnt_update_ifs(pDevice);
                     }
                 }
 
@@ -2337,7 +2337,8 @@ void vMgrJoinBSSBegin(struct vnt_private *pDevice, PCMD_STATUS pStatus)
 	    RATEvParseMaxRate((void *)pDevice, pItemRates, pItemExtRates, true,
                               &wMaxBasicRate, &wMaxSuppRate, &wSuppRate,
                               &byTopCCKBasicRate, &byTopOFDMBasicRate);
-            vUpdateIFS(pDevice);
+
+	    vnt_update_ifs(pDevice);
             // TODO: deal with if wCapInfo the privacy is on, but station WEP is off
             // TODO: deal with if wCapInfo the PS-Pollable is on.
             pMgmt->wCurrBeaconPeriod = pCurr->wBeaconInterval;
@@ -2391,7 +2392,7 @@ void vMgrJoinBSSBegin(struct vnt_private *pDevice, PCMD_STATUS pStatus)
                     } else {
                         MACvDisableProtectMD(pDevice);
                     }
-                    vUpdateIFS(pDevice);
+		    vnt_update_ifs(pDevice);
                 }
                 if ((pCurr->sERP.byERP & WLAN_EID_ERP_NONERP_PRESENT) != pDevice->bNonERPPresent) {//0000 0001
                     pDevice->bNonERPPresent = (pCurr->sERP.byERP & WLAN_EID_ERP_USE_PROTECTION);
@@ -2421,7 +2422,7 @@ void vMgrJoinBSSBegin(struct vnt_private *pDevice, PCMD_STATUS pStatus)
                 if (bShortSlotTime != pDevice->bShortSlotTime) {
                     pDevice->bShortSlotTime = bShortSlotTime;
                     BBvSetShortSlotTime(pDevice);
-                    vUpdateIFS(pDevice);
+		    vnt_update_ifs(pDevice);
                 }
             }
 
@@ -2480,7 +2481,7 @@ void vMgrJoinBSSBegin(struct vnt_private *pDevice, PCMD_STATUS pStatus)
 			      (PWLAN_IE_SUPP_RATES)pMgmt->abyCurrSuppRates,
                               NULL, true, &wMaxBasicRate, &wMaxSuppRate, &wSuppRate,
                               &byTopCCKBasicRate, &byTopOFDMBasicRate);
-            vUpdateIFS(pDevice);
+	    vnt_update_ifs(pDevice);
             pMgmt->wCurrCapInfo = pCurr->wCapInfo;
             pMgmt->wCurrBeaconPeriod = pCurr->wBeaconInterval;
             memset(pMgmt->abyCurrSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN);
-- 
1.9.1

