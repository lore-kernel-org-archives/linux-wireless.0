Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:54430 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbaE0UGL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 16:06:11 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so9883392wgg.0
        for <linux-wireless@vger.kernel.org>; Tue, 27 May 2014 13:06:09 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/10] staging: vt6656: rf.c: rename IFRFbWriteEmbedded to vnt_rf_write_embedded
Date: Tue, 27 May 2014 21:05:20 +0100
Message-Id: <1401221126-4219-4-git-send-email-tvboxspy@gmail.com> (sfid-20140527_220626_552130_3B6D7CBA)
In-Reply-To: <1401221126-4219-1-git-send-email-tvboxspy@gmail.com>
References: <1401221126-4219-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rf.c | 48 ++++++++++++++++++++++-----------------------
 drivers/staging/vt6656/rf.h |  2 +-
 2 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index a8e50f7..b30a373 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -26,7 +26,7 @@
  * Date: Feb. 19, 2004
  *
  * Functions:
- *      IFRFbWriteEmbedded      - Embedded write RF register via MAC
+ *	vnt_rf_write_embedded	- Embedded write RF register via MAC
  *
  * Revision History:
  *	RF_VT3226: RobertYu:20051111, VT3226C0 and before
@@ -706,7 +706,7 @@ const u8 RFaby11aChannelIndex[200] = {
  * Return Value: true if succeeded; false if failed.
  *
  */
-int IFRFbWriteEmbedded(struct vnt_private *priv, u32 data)
+int vnt_rf_write_embedded(struct vnt_private *priv, u32 data)
 {
 	u8 reg_data[4];
 
@@ -827,42 +827,42 @@ int RFbRawSetPower(struct vnt_private *priv, u8 power, u32 rate)
 		if (priv->byCurPwr >= AL2230_PWR_IDX_LEN)
 			return false;
 
-		ret &= IFRFbWriteEmbedded(priv,
+		ret &= vnt_rf_write_embedded(priv,
 			al2230_power_table[priv->byCurPwr]);
 
 		if (rate <= RATE_11M)
-			ret &= IFRFbWriteEmbedded(priv, 0x0001b400 +
+			ret &= vnt_rf_write_embedded(priv, 0x0001b400 +
 				(BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW);
 		else
-			ret &= IFRFbWriteEmbedded(priv, 0x0005a400 +
+			ret &= vnt_rf_write_embedded(priv, 0x0005a400 +
 				(BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW);
 		break;
 	case RF_AL2230S:
 		if (priv->byCurPwr >= AL2230_PWR_IDX_LEN)
 			return false;
 
-		ret &= IFRFbWriteEmbedded(priv,
+		ret &= vnt_rf_write_embedded(priv,
 			al2230_power_table[priv->byCurPwr]);
 
 		if (rate <= RATE_11M) {
-			ret &= IFRFbWriteEmbedded(priv, 0x040c1400 +
+			ret &= vnt_rf_write_embedded(priv, 0x040c1400 +
 				(BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW);
-			ret &= IFRFbWriteEmbedded(priv, 0x00299b00 +
+			ret &= vnt_rf_write_embedded(priv, 0x00299b00 +
 				(BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW);
 		} else {
-			ret &= IFRFbWriteEmbedded(priv, 0x0005a400 +
+			ret &= vnt_rf_write_embedded(priv, 0x0005a400 +
 				(BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW);
-			ret &= IFRFbWriteEmbedded(priv, 0x00099b00 +
+			ret &= vnt_rf_write_embedded(priv, 0x00099b00 +
 				(BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW);
 		}
 		break;
 
 	case RF_AIROHA7230:
 		if (rate <= RATE_11M)
-			ret &= IFRFbWriteEmbedded(priv, 0x111bb900 +
+			ret &= vnt_rf_write_embedded(priv, 0x111bb900 +
 				(BY_AL7230_REG_LEN << 3)+IFREGCTL_REGW);
 		else
-			ret &= IFRFbWriteEmbedded(priv, 0x221bb900 +
+			ret &= vnt_rf_write_embedded(priv, 0x221bb900 +
 				(BY_AL7230_REG_LEN << 3)+IFREGCTL_REGW);
 
 		if (priv->byCurPwr > AL7230_PWR_IDX_LEN)
@@ -875,7 +875,7 @@ int RFbRawSetPower(struct vnt_private *priv, u8 power, u32 rate)
 		power_setting = 0x080c0b00 | ((priv->byCurPwr) << 12) |
 				(BY_AL7230_REG_LEN << 3) | IFREGCTL_REGW;
 
-		ret &= IFRFbWriteEmbedded(priv, power_setting);
+		ret &= vnt_rf_write_embedded(priv, power_setting);
 
 		break;
 
@@ -885,7 +885,7 @@ int RFbRawSetPower(struct vnt_private *priv, u8 power, u32 rate)
 		power_setting = ((0x3f - priv->byCurPwr) << 20) | (0x17 << 8) |
 				(BY_VT3226_REG_LEN << 3) | IFREGCTL_REGW;
 
-		ret &= IFRFbWriteEmbedded(priv, power_setting);
+		ret &= vnt_rf_write_embedded(priv, power_setting);
 
 		break;
 	case RF_VT3226D0:
@@ -897,27 +897,27 @@ int RFbRawSetPower(struct vnt_private *priv, u8 power, u32 rate)
 				(0xe07 << 8) | (BY_VT3226_REG_LEN << 3) |
 						IFREGCTL_REGW;
 
-			ret &= IFRFbWriteEmbedded(priv, power_setting);
-			ret &= IFRFbWriteEmbedded(priv, 0x03c6a200 +
+			ret &= vnt_rf_write_embedded(priv, power_setting);
+			ret &= vnt_rf_write_embedded(priv, 0x03c6a200 +
 					(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW);
 
 			if (priv->vnt_mgmt.eScanState != WMAC_NO_SCANNING) {
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 				"RFbRawSetPower> 11B mode uCurrChannel[%d]\n",
 						priv->vnt_mgmt.uScanChannel);
-				ret &= IFRFbWriteEmbedded(priv,
+				ret &= vnt_rf_write_embedded(priv,
 					vt3226d0_lo_current_table[priv->
 						vnt_mgmt.uScanChannel - 1]);
 			} else {
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 				"RFbRawSetPower> 11B mode uCurrChannel[%d]\n",
 						priv->vnt_mgmt.uCurrChannel);
-				ret &= IFRFbWriteEmbedded(priv,
+				ret &= vnt_rf_write_embedded(priv,
 					vt3226d0_lo_current_table[priv->
 						vnt_mgmt.uCurrChannel - 1]);
 			}
 
-			ret &= IFRFbWriteEmbedded(priv, 0x015C0800 +
+			ret &= vnt_rf_write_embedded(priv, 0x015C0800 +
 				(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW);
 		} else {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
@@ -927,12 +927,12 @@ int RFbRawSetPower(struct vnt_private *priv, u8 power, u32 rate)
 				(0x7 << 8) | (BY_VT3226_REG_LEN << 3) |
 					IFREGCTL_REGW;
 
-			ret &= IFRFbWriteEmbedded(priv, power_setting);
-			ret &= IFRFbWriteEmbedded(priv, 0x00C6A200 +
+			ret &= vnt_rf_write_embedded(priv, power_setting);
+			ret &= vnt_rf_write_embedded(priv, 0x00C6A200 +
 				(BY_VT3226_REG_LEN << 3) + IFREGCTL_REGW);
-			ret &= IFRFbWriteEmbedded(priv, 0x016BC600 +
+			ret &= vnt_rf_write_embedded(priv, 0x016BC600 +
 					(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW);
-			ret &= IFRFbWriteEmbedded(priv, 0x00900800 +
+			ret &= vnt_rf_write_embedded(priv, 0x00900800 +
 					(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW);
 		}
 		break;
@@ -945,7 +945,7 @@ int RFbRawSetPower(struct vnt_private *priv, u8 power, u32 rate)
 			(0x27 << 8) | (BY_VT3342_REG_LEN << 3) |
 					IFREGCTL_REGW;
 
-		ret &= IFRFbWriteEmbedded(priv, power_setting);
+		ret &= vnt_rf_write_embedded(priv, power_setting);
 
 		break;
 	default:
diff --git a/drivers/staging/vt6656/rf.h b/drivers/staging/vt6656/rf.h
index e9a01fe..70d5b82 100644
--- a/drivers/staging/vt6656/rf.h
+++ b/drivers/staging/vt6656/rf.h
@@ -57,7 +57,7 @@
 
 extern const u8 RFaby11aChannelIndex[200];
 
-int IFRFbWriteEmbedded(struct vnt_private *, u32 dwData);
+int vnt_rf_write_embedded(struct vnt_private *, u32);
 int RFbSetPower(struct vnt_private *, u32 uRATE, u32 uCH);
 int RFbRawSetPower(struct vnt_private *, u8 byPwr, u32 uRATE);
 void RFvRSSITodBm(struct vnt_private *, u8 byCurrRSSI, long *pldBm);
-- 
1.9.1

