Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:51331 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab3FCVsh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 17:48:37 -0400
Received: by mail-wg0-f46.google.com with SMTP id l18so3679517wgh.25
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jun 2013 14:48:36 -0700 (PDT)
Message-ID: <1370296110.9091.30.camel@canaries64> (sfid-20130603_234840_708360_868912B3)
Subject: [PATCH 4/8] staging: vt6656: rf.c/h rename RFbRawSetPower
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 03 Jun 2013 22:48:30 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we are actually setting the tx power rename vnt_rf_set_txpower.

Remove camel case rename RFbRawSetPower to vnt_rf_set_txpower

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c |  9 ++++++---
 drivers/staging/vt6656/rf.c   | 10 +++++-----
 drivers/staging/vt6656/rf.h   |  2 +-
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 24291ae..56a6a57 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -112,13 +112,16 @@ void CARDbSetMediaChannel(struct vnt_private *pDevice, u32 uConnectionChannel)
 
     if (pDevice->byBBType == BB_TYPE_11A) {
         pDevice->byCurPwr = 0xFF;
-        RFbRawSetPower(pDevice, pDevice->abyOFDMAPwrTbl[uConnectionChannel-15], RATE_54M);
+	vnt_rf_set_txpower(pDevice,
+		pDevice->abyOFDMAPwrTbl[uConnectionChannel-15], RATE_54M);
     } else if (pDevice->byBBType == BB_TYPE_11G) {
         pDevice->byCurPwr = 0xFF;
-        RFbRawSetPower(pDevice, pDevice->abyOFDMPwrTbl[uConnectionChannel-1], RATE_54M);
+	vnt_rf_set_txpower(pDevice,
+		pDevice->abyOFDMPwrTbl[uConnectionChannel-1], RATE_54M);
     } else {
         pDevice->byCurPwr = 0xFF;
-        RFbRawSetPower(pDevice, pDevice->abyCCKPwrTbl[uConnectionChannel-1], RATE_1M);
+	vnt_rf_set_txpower(pDevice,
+		pDevice->abyCCKPwrTbl[uConnectionChannel-1], RATE_1M);
     }
     ControlvWriteByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_CHANNEL,(u8)(uConnectionChannel|0x80));
 }
diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 7e6e386..1706d8d 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -767,7 +767,7 @@ int vnt_rf_setpower(struct vnt_private *priv, u32 rate, u32 channel)
 		break;
 	}
 
-	ret = RFbRawSetPower(priv, power, rate);
+	ret = vnt_rf_set_txpower(priv, power, rate);
 
 	return ret;
 }
@@ -786,7 +786,7 @@ int vnt_rf_setpower(struct vnt_private *priv, u32 rate, u32 channel)
  *
  */
 
-int RFbRawSetPower(struct vnt_private *priv, u8 power, u32 rate)
+int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
 {
 	u32 power_setting = 0;
 	int ret = true;
@@ -877,14 +877,14 @@ int RFbRawSetPower(struct vnt_private *priv, u8 power, u32 rate)
 
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
@@ -895,7 +895,7 @@ int RFbRawSetPower(struct vnt_private *priv, u8 power, u32 rate)
 				(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW);
 		} else {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-					"@@@@ RFbRawSetPower> 11G mode\n");
+					"@@@@ vnt_rf_set_txpower> 11G mode\n");
 
 			power_setting = ((0x3f-priv->byCurPwr) << 20) |
 				(0x7 << 8) | (BY_VT3226_REG_LEN << 3) |
diff --git a/drivers/staging/vt6656/rf.h b/drivers/staging/vt6656/rf.h
index 62fcfc6..1c0dd25 100644
--- a/drivers/staging/vt6656/rf.h
+++ b/drivers/staging/vt6656/rf.h
@@ -57,7 +57,7 @@ extern const u8 RFaby11aChannelIndex[200];
 
 int vnt_rf_write_embedded(struct vnt_private *, u32);
 int vnt_rf_setpower(struct vnt_private *, u32, u32);
-int RFbRawSetPower(struct vnt_private *, u8 byPwr, u32 uRATE);
+int vnt_rf_set_txpower(struct vnt_private *, u8, u32);
 void RFvRSSITodBm(struct vnt_private *, u8 byCurrRSSI, long *pldBm);
 void RFbRFTableDownload(struct vnt_private *pDevice);
 
-- 
1.8.1.2

