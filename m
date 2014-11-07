Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33393 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbaKGTGs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 14:06:48 -0500
Received: by mail-wi0-f171.google.com with SMTP id r20so5490884wiv.4
        for <linux-wireless@vger.kernel.org>; Fri, 07 Nov 2014 11:06:46 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/10] staging: vt6655: CARDbSetPhyParameter remove unused parameters
Date: Fri,  7 Nov 2014 19:06:06 +0000
Message-Id: <1415387169-3843-7-git-send-email-tvboxspy@gmail.com> (sfid-20141107_200652_913607_9CC13008)
In-Reply-To: <1415387169-3843-1-git-send-email-tvboxspy@gmail.com>
References: <1415387169-3843-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wCapInfo
byERPField,
*pvSupportRateIEs
*pvExtSupportRateIEs

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c        | 4 +---
 drivers/staging/vt6655/card.h        | 4 +---
 drivers/staging/vt6655/device_main.c | 5 ++---
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index e6e5f63..532c3c8 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -204,9 +204,7 @@ s_vCalculateOFDMRParameter(
  *
  * Return Value: None.
  */
-bool CARDbSetPhyParameter(struct vnt_private *pDevice, u8 bb_type,
-			  unsigned short wCapInfo, unsigned char byERPField,
-			  void *pvSupportRateIEs, void *pvExtSupportRateIEs)
+bool CARDbSetPhyParameter(struct vnt_private *pDevice, u8 bb_type)
 {
 	unsigned char byCWMaxMin = 0;
 	unsigned char bySlot = 0;
diff --git a/drivers/staging/vt6655/card.h b/drivers/staging/vt6655/card.h
index 30f3472..605d8a8 100644
--- a/drivers/staging/vt6655/card.h
+++ b/drivers/staging/vt6655/card.h
@@ -82,9 +82,7 @@ void CARDvSafeResetTx(struct vnt_private *);
 void CARDvSafeResetRx(struct vnt_private *);
 bool CARDbRadioPowerOff(struct vnt_private *);
 bool CARDbRadioPowerOn(struct vnt_private *);
-bool CARDbSetPhyParameter(struct vnt_private *, u8,
-			  unsigned short wCapInfo, unsigned char byERPField,
-			  void *pvSupportRateIEs, void *pvExtSupportRateIEs);
+bool CARDbSetPhyParameter(struct vnt_private *, u8);
 bool CARDbUpdateTSF(struct vnt_private *, unsigned char byRxRate,
 		    u64 qwBSSTimestamp, u64 qwLocalTSF);
 bool CARDbSetBeaconPeriod(struct vnt_private *, unsigned short wBeaconInterval);
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 397f13f..22a55f4 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1425,8 +1425,7 @@ static int vnt_config(struct ieee80211_hw *hw, u32 changed)
 		if (priv->byBBType != bb_type) {
 			priv->byBBType = bb_type;
 
-			CARDbSetPhyParameter(priv,
-					     priv->byBBType, 0, 0, NULL, NULL);
+			CARDbSetPhyParameter(priv, priv->byBBType);
 		}
 	}
 
@@ -1487,7 +1486,7 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 			priv->bShortSlotTime = false;
 
 		vUpdateIFS(priv);
-		CARDbSetPhyParameter(priv, priv->byBBType, 0, 0, NULL, NULL);
+		CARDbSetPhyParameter(priv, priv->byBBType);
 		BBvSetVGAGainOffset(priv, priv->abyBBVGA[0]);
 	}
 
-- 
2.1.0

