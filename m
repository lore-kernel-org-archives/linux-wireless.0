Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:41986 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402Ab3FCVqK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 17:46:10 -0400
Received: by mail-we0-f181.google.com with SMTP id p58so2191712wes.40
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jun 2013 14:46:09 -0700 (PDT)
Message-ID: <1370295965.9091.28.camel@canaries64> (sfid-20130603_234615_362049_8786405B)
Subject: [PATCH 2/8] staging: vt6656: rf.c: rename IFRFbWriteEmbedded
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 03 Jun 2013 22:46:05 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove camel case rename IFRFbWriteEmbedded to vnt_rf_write_embedded

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rf.c | 48 ++++++++++++++++++++++-----------------------
 drivers/staging/vt6656/rf.h |  2 +-
 2 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 9fbef8c..8c10886 100644
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
@@ -707,7 +707,7 @@ const u8 RFaby11aChannelIndex[200] = {
  * Return Value: true if succeeded; false if failed.
  *
  */
-int IFRFbWriteEmbedded(struct vnt_private *priv, u32 data)
+int vnt_rf_write_embedded(struct vnt_private *priv, u32 data)
 {
 	u8 reg_data[4];
 
@@ -801,42 +801,42 @@ int RFbRawSetPower(struct vnt_private *priv, u8 power, u32 rate)
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
@@ -849,7 +849,7 @@ int RFbRawSetPower(struct vnt_private *priv, u8 power, u32 rate)
 		power_setting = 0x080c0b00 | ((priv->byCurPwr) << 12) |
 				(BY_AL7230_REG_LEN << 3) | IFREGCTL_REGW;
 
-		ret &= IFRFbWriteEmbedded(priv, power_setting);
+		ret &= vnt_rf_write_embedded(priv, power_setting);
 
 		break;
 
@@ -859,7 +859,7 @@ int RFbRawSetPower(struct vnt_private *priv, u8 power, u32 rate)
 		power_setting = ((0x3f - priv->byCurPwr) << 20) | (0x17 << 8) |
 				(BY_VT3226_REG_LEN << 3) | IFREGCTL_REGW;
 
-		ret &= IFRFbWriteEmbedded(priv, power_setting);
+		ret &= vnt_rf_write_embedded(priv, power_setting);
 
 		break;
 	case RF_VT3226D0:
@@ -871,27 +871,27 @@ int RFbRawSetPower(struct vnt_private *priv, u8 power, u32 rate)
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
@@ -901,12 +901,12 @@ int RFbRawSetPower(struct vnt_private *priv, u8 power, u32 rate)
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
@@ -919,7 +919,7 @@ int RFbRawSetPower(struct vnt_private *priv, u8 power, u32 rate)
 			(0x27 << 8) | (BY_VT3342_REG_LEN << 3) |
 					IFREGCTL_REGW;
 
-		ret &= IFRFbWriteEmbedded(priv, power_setting);
+		ret &= vnt_rf_write_embedded(priv, power_setting);
 
 		break;
 	default:
diff --git a/drivers/staging/vt6656/rf.h b/drivers/staging/vt6656/rf.h
index de5c613..9de28c0 100644
--- a/drivers/staging/vt6656/rf.h
+++ b/drivers/staging/vt6656/rf.h
@@ -55,7 +55,7 @@
 
 extern const u8 RFaby11aChannelIndex[200];
 
-int IFRFbWriteEmbedded(struct vnt_private *, u32 dwData);
+int vnt_rf_write_embedded(struct vnt_private *, u32);
 int RFbSetPower(struct vnt_private *, u32 uRATE, u32 uCH);
 int RFbRawSetPower(struct vnt_private *, u8 byPwr, u32 uRATE);
 void RFvRSSITodBm(struct vnt_private *, u8 byCurrRSSI, long *pldBm);
-- 
1.8.1.2

