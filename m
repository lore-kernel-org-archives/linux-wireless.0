Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:45350 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbaE0UGP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 16:06:15 -0400
Received: by mail-wi0-f181.google.com with SMTP id n15so2487383wiw.14
        for <linux-wireless@vger.kernel.org>; Tue, 27 May 2014 13:06:14 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 06/10] staging: vt6656: rf.c/h rename RFbRawSetPower to vnt_rf_set_txpower
Date: Tue, 27 May 2014 21:05:22 +0100
Message-Id: <1401221126-4219-6-git-send-email-tvboxspy@gmail.com> (sfid-20140527_220627_826851_65665242)
In-Reply-To: <1401221126-4219-1-git-send-email-tvboxspy@gmail.com>
References: <1401221126-4219-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove raw and use txpower.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c |  6 +++---
 drivers/staging/vt6656/rf.c   | 10 +++++-----
 drivers/staging/vt6656/rf.h   |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 5ad0a98..d662e54 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -99,15 +99,15 @@ void CARDbSetMediaChannel(struct vnt_private *priv, u32 connection_channel)
 
 	if (priv->byBBType == BB_TYPE_11A) {
 		priv->byCurPwr = 0xff;
-		RFbRawSetPower(priv,
+		vnt_rf_set_txpower(priv,
 			priv->abyOFDMAPwrTbl[connection_channel-15], RATE_54M);
 	} else if (priv->byBBType == BB_TYPE_11G) {
 		priv->byCurPwr = 0xff;
-		RFbRawSetPower(priv,
+		vnt_rf_set_txpower(priv,
 			priv->abyOFDMPwrTbl[connection_channel-1], RATE_54M);
 	} else {
 		priv->byCurPwr = 0xff;
-		RFbRawSetPower(priv,
+		vnt_rf_set_txpower(priv,
 			priv->abyCCKPwrTbl[connection_channel-1], RATE_1M);
 	}
 
diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index c1e0a79..fd69960 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -763,7 +763,7 @@ int vnt_rf_setpower(struct vnt_private *priv, u32 rate, u32 channel)
 		break;
 	}
 
-	ret = RFbRawSetPower(priv, power, rate);
+	ret = vnt_rf_set_txpower(priv, power, rate);
 
 	return ret;
 }
@@ -808,7 +808,7 @@ static u8 vnt_rf_addpower(struct vnt_private *priv)
  *
  */
 
-int RFbRawSetPower(struct vnt_private *priv, u8 power, u32 rate)
+int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
 {
 	u32 power_setting = 0;
 	int ret = true;
@@ -903,14 +903,14 @@ int RFbRawSetPower(struct vnt_private *priv, u8 power, u32 rate)
 
 			if (priv->vnt_mgmt.eScanState != WMAC_NO_SCANNING) {
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-				"RFbRawSetPower> 11B mode uCurrChannel[%d]\n",
+				"vnt_rf_set_txpower> 11B mode uCurrChannel[%d]\n",
 						priv->vnt_mgmt.uScanChannel);
 				ret &= vnt_rf_write_embedded(priv,
 					vt3226d0_lo_current_table[priv->
 						vnt_mgmt.uScanChannel - 1]);
 			} else {
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-				"RFbRawSetPower> 11B mode uCurrChannel[%d]\n",
+				"vnt_rf_set_txpower> 11B mode uCurrChannel[%d]\n",
 						priv->vnt_mgmt.uCurrChannel);
 				ret &= vnt_rf_write_embedded(priv,
 					vt3226d0_lo_current_table[priv->
@@ -921,7 +921,7 @@ int RFbRawSetPower(struct vnt_private *priv, u8 power, u32 rate)
 				(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW);
 		} else {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-					"@@@@ RFbRawSetPower> 11G mode\n");
+					"@@@@ vnt_rf_set_txpower> 11G mode\n");
 
 			power_setting = ((0x3f-priv->byCurPwr) << 20) |
 				(0x7 << 8) | (BY_VT3226_REG_LEN << 3) |
diff --git a/drivers/staging/vt6656/rf.h b/drivers/staging/vt6656/rf.h
index e47b67d..2040d50 100644
--- a/drivers/staging/vt6656/rf.h
+++ b/drivers/staging/vt6656/rf.h
@@ -59,7 +59,7 @@ extern const u8 RFaby11aChannelIndex[200];
 
 int vnt_rf_write_embedded(struct vnt_private *, u32);
 int vnt_rf_setpower(struct vnt_private *, u32, u32);
-int RFbRawSetPower(struct vnt_private *, u8 byPwr, u32 uRATE);
+int vnt_rf_set_txpower(struct vnt_private *, u8, u32);
 void RFvRSSITodBm(struct vnt_private *, u8 byCurrRSSI, long *pldBm);
 void RFbRFTableDownload(struct vnt_private *pDevice);
 
-- 
1.9.1

