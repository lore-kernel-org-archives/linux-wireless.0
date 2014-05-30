Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:50132 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933498AbaE3P2i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 11:28:38 -0400
Received: by mail-wg0-f50.google.com with SMTP id x12so2211158wgg.9
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 08:28:36 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 08/12] staging: vt6656: rename CARDbAddBasicRate to vnt_add_basic_rate
Date: Fri, 30 May 2014 16:27:47 +0100
Message-Id: <1401463671-4705-8-git-send-email-tvboxspy@gmail.com> (sfid-20140530_172919_804305_EC6B7882)
In-Reply-To: <1401463671-4705-1-git-send-email-tvboxspy@gmail.com>
References: <1401463671-4705-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drop card and rename to vnt_add_basic_rate

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c     | 4 ++--
 drivers/staging/vt6656/card.h     | 2 +-
 drivers/staging/vt6656/datarate.c | 4 ++--
 drivers/staging/vt6656/main_usb.c | 4 ++--
 drivers/staging/vt6656/wmgr.c     | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index cf46aa8..a905076 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -23,7 +23,7 @@
  *      vnt_set_rspinf - Set RSPINF
  *      vnt_update_ifs - Update slotTime,SIFS,DIFS, and EIFS
  *      vnt_update_top_rates - Update BasicTopRate
- *      CARDbAddBasicRate - Add to BasicRateSet
+ *      vnt_add_basic_rate - Add to BasicRateSet
  *      CARDbSetBasicRate - Set Basic Tx Rate
  *      CARDbIsOFDMinBasicRate - Check if any OFDM rate is in BasicRateSet
  *      CARDvSetLoopbackMode - Set Loopback mode
@@ -505,7 +505,7 @@ void vnt_update_top_rates(struct vnt_private *priv)
  * Return Value: true if succeeded; false if failed.
  *
  */
-void CARDbAddBasicRate(struct vnt_private *priv, u16 rate_idx)
+void vnt_add_basic_rate(struct vnt_private *priv, u16 rate_idx)
 {
 
 	priv->wBasicRate |= (1 << rate_idx);
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index b52a8c2..ef5a671 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -49,7 +49,7 @@ void vnt_set_channel(struct vnt_private *, u32);
 void vnt_set_rspinf(struct vnt_private *, u8);
 void vnt_update_ifs(struct vnt_private *);
 void vnt_update_top_rates(struct vnt_private *);
-void CARDbAddBasicRate(struct vnt_private *, u16);
+void vnt_add_basic_rate(struct vnt_private *, u16);
 int CARDbIsOFDMinBasicRate(struct vnt_private *pDevice);
 void CARDvAdjustTSF(struct vnt_private *pDevice, u8 byRxRate,
 		u64 qwBSSTimestamp, u64 qwLocalTSF);
diff --git a/drivers/staging/vt6656/datarate.c b/drivers/staging/vt6656/datarate.c
index e4a3ac2..517fbf7 100644
--- a/drivers/staging/vt6656/datarate.c
+++ b/drivers/staging/vt6656/datarate.c
@@ -163,7 +163,7 @@ void RATEvParseMaxRate(struct vnt_private *pDevice,
 			 * add to basic rate set, update pDevice->byTopCCKBasicRate and
 			 * pDevice->byTopOFDMBasicRate
 			 */
-			CARDbAddBasicRate((void *)pDevice, RATEwGetRateIdx(byRate));
+			vnt_add_basic_rate(pDevice, RATEwGetRateIdx(byRate));
 			DBG_PRT(MSG_LEVEL_DEBUG,
 				KERN_INFO"ParseMaxRate AddBasicRate: %d\n",
 				RATEwGetRateIdx(byRate));
@@ -191,7 +191,7 @@ void RATEvParseMaxRate(struct vnt_private *pDevice,
 				 * add to basic rate set, update pDevice->byTopCCKBasicRate and
 				 * pDevice->byTopOFDMBasicRate
 				 */
-				CARDbAddBasicRate((void *)pDevice, RATEwGetRateIdx(byRate));
+				vnt_add_basic_rate(pDevice, RATEwGetRateIdx(byRate));
 				DBG_PRT(MSG_LEVEL_DEBUG,
 						KERN_INFO"ParseMaxRate AddBasicRate: %d\n",
 						RATEwGetRateIdx(byRate));
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index aca486d..636afc2 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -517,10 +517,10 @@ static int device_init_registers(struct vnt_private *pDevice)
 	* set Short Slot Time, xIFS, and RSPINF
 	*/
 	if (pDevice->byBBType == BB_TYPE_11A) {
-		CARDbAddBasicRate(pDevice, RATE_6M);
+		vnt_add_basic_rate(pDevice, RATE_6M);
 		pDevice->bShortSlotTime = true;
 	} else {
-		CARDbAddBasicRate(pDevice, RATE_1M);
+		vnt_add_basic_rate(pDevice, RATE_1M);
 		pDevice->bShortSlotTime = false;
 	}
 
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 4751242..652e8b6 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -2573,7 +2573,7 @@ static void s_vMgrSynchBSS(struct vnt_private *pDevice, u32 uBSSMode,
     pDevice->byPreambleType = 0;
     pDevice->wBasicRate = 0;
     // Set Basic Rate
-    CARDbAddBasicRate((void *)pDevice, RATE_1M);
+    vnt_add_basic_rate(pDevice, RATE_1M);
 
     // calculate TSF offset
     // TSF Offset = Received Timestamp TSF - Marked Local's TSF
-- 
1.9.1

