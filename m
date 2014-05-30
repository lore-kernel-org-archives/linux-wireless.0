Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:52316 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933462AbaE3P2g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 11:28:36 -0400
Received: by mail-wi0-f175.google.com with SMTP id f8so1347865wiw.2
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 08:28:35 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/12] staging: vt6656: rename CARDvSetRSPINF to vnt_set_rspinf
Date: Fri, 30 May 2014 16:27:46 +0100
Message-Id: <1401463671-4705-7-git-send-email-tvboxspy@gmail.com> (sfid-20140530_172928_096022_27D84151)
In-Reply-To: <1401463671-4705-1-git-send-email-tvboxspy@gmail.com>
References: <1401463671-4705-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drop card and rename to vnt_set_rspinf

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c     | 6 +++---
 drivers/staging/vt6656/card.h     | 2 +-
 drivers/staging/vt6656/datarate.c | 2 +-
 drivers/staging/vt6656/wmgr.c     | 8 ++++----
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 7542b0d..cf46aa8 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -20,7 +20,7 @@
  * Purpose: Provide functions to setup NIC operation mode
  * Functions:
  *      s_vSafeResetTx - Rest Tx
- *      CARDvSetRSPINF - Set RSPINF
+ *      vnt_set_rspinf - Set RSPINF
  *      vnt_update_ifs - Update slotTime,SIFS,DIFS, and EIFS
  *      vnt_update_top_rates - Update BasicTopRate
  *      CARDbAddBasicRate - Add to BasicRateSet
@@ -291,7 +291,7 @@ static void vnt_calculate_ofdm_rate(u16 rate, u8 bb_type,
  *
  */
 
-void CARDvSetRSPINF(struct vnt_private *priv, u8 bb_type)
+void vnt_set_rspinf(struct vnt_private *priv, u8 bb_type)
 {
 	struct vnt_phy_field phy[4];
 	u8 tx_rate[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0}; /* For OFDM */
@@ -846,7 +846,7 @@ void CARDvSetBSSMode(struct vnt_private *priv)
 		vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x88, 0x08);
 
 	vnt_update_ifs(priv);
-	CARDvSetRSPINF(priv, (u8)priv->byBBType);
+	vnt_set_rspinf(priv, (u8)priv->byBBType);
 
 	if (priv->byBBType == BB_TYPE_11A) {
 		if (priv->byRFType == RF_AIROHA7230) {
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index f2afda4..b52a8c2 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -46,7 +46,7 @@ typedef enum _CARD_PHY_TYPE {
 struct vnt_private;
 
 void vnt_set_channel(struct vnt_private *, u32);
-void CARDvSetRSPINF(struct vnt_private *, u8);
+void vnt_set_rspinf(struct vnt_private *, u8);
 void vnt_update_ifs(struct vnt_private *);
 void vnt_update_top_rates(struct vnt_private *);
 void CARDbAddBasicRate(struct vnt_private *, u16);
diff --git a/drivers/staging/vt6656/datarate.c b/drivers/staging/vt6656/datarate.c
index 8032d6b..e4a3ac2 100644
--- a/drivers/staging/vt6656/datarate.c
+++ b/drivers/staging/vt6656/datarate.c
@@ -222,7 +222,7 @@ void RATEvParseMaxRate(struct vnt_private *pDevice,
 	else
 		*pwMaxBasicRate = pDevice->byTopOFDMBasicRate;
 	if (wOldBasicRate != pDevice->wBasicRate)
-		CARDvSetRSPINF((void *)pDevice, pDevice->byBBType);
+		vnt_set_rspinf(pDevice, pDevice->byBBType);
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Exit ParseMaxRate\n");
 }
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index c1151b9..4751242 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -1705,7 +1705,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
                     pDevice->byPreambleType = 0;
                 }
                 if (pDevice->byPreambleType != byOldPreambleType)
-                    CARDvSetRSPINF(pDevice, (u8)pDevice->byBBType);
+			vnt_set_rspinf(pDevice, (u8)pDevice->byBBType);
             //
             // Basic Rate Set may change dynamically
             //
@@ -1930,7 +1930,7 @@ if(ChannelExceedZoneType(pDevice,byCurrChannel)==true)
                         pDevice->byPreambleType = 0;
                     }
                     if (pDevice->byPreambleType != byOldPreambleType)
-                        CARDvSetRSPINF(pDevice, (u8)pDevice->byBBType);
+			vnt_set_rspinf(pDevice, (u8)pDevice->byBBType);
 
                      // MACvRegBitsOff(pDevice->PortOffset, MAC_REG_RCR, RCR_BSSID);
                      // set highest basic rate
@@ -2379,7 +2379,7 @@ void vMgrJoinBSSBegin(struct vnt_private *pDevice, PCMD_STATUS pStatus)
                 pDevice->byPreambleType = 0;
             }
             // Change PreambleType must set RSPINF again
-            CARDvSetRSPINF(pDevice, (u8)pDevice->byBBType);
+	    vnt_set_rspinf(pDevice, (u8)pDevice->byBBType);
 
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Join ESS\n");
 
@@ -2510,7 +2510,7 @@ void vMgrJoinBSSBegin(struct vnt_private *pDevice, PCMD_STATUS pStatus)
                 pDevice->byPreambleType = 0;
             }
             // Change PreambleType must set RSPINF again
-            CARDvSetRSPINF(pDevice, (u8)pDevice->byBBType);
+	    vnt_set_rspinf(pDevice, (u8)pDevice->byBBType);
 
             // Prepare beacon
 		bMgrPrepareBeaconToSend((void *) pDevice, pMgmt);
-- 
1.9.1

