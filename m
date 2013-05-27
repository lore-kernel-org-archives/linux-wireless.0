Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:55554 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353Ab3E0NDt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 09:03:49 -0400
Received: by mail-bk0-f52.google.com with SMTP id mz10so3588804bkb.25
        for <linux-wireless@vger.kernel.org>; Mon, 27 May 2013 06:03:47 -0700 (PDT)
Message-ID: <1369659822.8283.21.camel@canaries64> (sfid-20130527_150401_640281_6AE90E9F)
Subject: [PATCH 2/5] staging: vt6656: rf.c: RFbRawSetPower Remove camel case
 and cleanup.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 27 May 2013 14:03:42 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

White space clean up.

Camel case changes;
pDevice -> priv
uRATE -> rate
bResult -> ret
byPwr -> power

Functional change merged as one variable.
dwMax7230Pwr -> power_setting
dwVT3226Pwr -> power_setting
dwVT3342Pwr -> power_setting

Author changes moved to Revision history. 

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rf.c | 222 +++++++++++++++++++++++---------------------
 1 file changed, 117 insertions(+), 105 deletions(-)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 0c537b9..b7aad36 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -29,6 +29,8 @@
  *      IFRFbWriteEmbedded      - Embedded write RF register via MAC
  *
  * Revision History:
+ *	RF_VT3226: RobertYu:20051111, VT3226C0 and before
+ *	RF_VT3226D0: RobertYu:20051228
  *
  */
 
@@ -783,136 +785,146 @@ int RFbSetPower(struct vnt_private *priv, u32 rate, u32 channel)
  *
  */
 
-int RFbRawSetPower(struct vnt_private *pDevice, u8 byPwr, u32 uRATE)
+int RFbRawSetPower(struct vnt_private *priv, u8 power, u32 rate)
 {
-	int bResult = true;
+	u32 power_setting = 0;
+	int ret = true;
 
-    if (pDevice->byCurPwr == byPwr)
-        return true;
+	if (priv->byCurPwr == power)
+		return true;
 
-    pDevice->byCurPwr = byPwr;
+	priv->byCurPwr = power;
 
-    switch (pDevice->byRFType) {
-
-        case RF_AL2230 :
-            if (pDevice->byCurPwr >= AL2230_PWR_IDX_LEN)
-                return false;
-            bResult &= IFRFbWriteEmbedded(pDevice, dwAL2230PowerTable[pDevice->byCurPwr]);
-            if (uRATE <= RATE_11M)
-                bResult &= IFRFbWriteEmbedded(pDevice, 0x0001B400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
-            else
-                bResult &= IFRFbWriteEmbedded(pDevice, 0x0005A400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
-            break;
+	switch (priv->byRFType) {
+	case RF_AL2230:
+		if (priv->byCurPwr >= AL2230_PWR_IDX_LEN)
+			return false;
 
-        case RF_AL2230S :
-            if (pDevice->byCurPwr >= AL2230_PWR_IDX_LEN)
-                return false;
-            bResult &= IFRFbWriteEmbedded(pDevice, dwAL2230PowerTable[pDevice->byCurPwr]);
-            if (uRATE <= RATE_11M) {
-                bResult &= IFRFbWriteEmbedded(pDevice, 0x040C1400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
-                bResult &= IFRFbWriteEmbedded(pDevice, 0x00299B00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
-            }else {
-                bResult &= IFRFbWriteEmbedded(pDevice, 0x0005A400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
-                bResult &= IFRFbWriteEmbedded(pDevice, 0x00099B00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
-            }
-            break;
+		ret &= IFRFbWriteEmbedded(priv,
+			dwAL2230PowerTable[priv->byCurPwr]);
 
-        case RF_AIROHA7230:
-            {
-                u32       dwMax7230Pwr;
+		if (rate <= RATE_11M)
+			ret &= IFRFbWriteEmbedded(priv, 0x0001b400 +
+				(BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW);
+		else
+			ret &= IFRFbWriteEmbedded(priv, 0x0005a400 +
+				(BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW);
+		break;
+	case RF_AL2230S:
+		if (priv->byCurPwr >= AL2230_PWR_IDX_LEN)
+			return false;
+
+		ret &= IFRFbWriteEmbedded(priv,
+			dwAL2230PowerTable[priv->byCurPwr]);
+
+		if (rate <= RATE_11M) {
+			ret &= IFRFbWriteEmbedded(priv, 0x040c1400 +
+				(BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW);
+			ret &= IFRFbWriteEmbedded(priv, 0x00299b00 +
+				(BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW);
+		} else {
+			ret &= IFRFbWriteEmbedded(priv, 0x0005a400 +
+				(BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW);
+			ret &= IFRFbWriteEmbedded(priv, 0x00099b00 +
+				(BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW);
+		}
+		break;
 
-                if (uRATE <= RATE_11M) { //RobertYu:20060426, for better 11b mask
-                    bResult &= IFRFbWriteEmbedded(pDevice, 0x111BB900+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW);
-                }
-                else {
-                    bResult &= IFRFbWriteEmbedded(pDevice, 0x221BB900+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW);
-                }
+	case RF_AIROHA7230:
+		if (rate <= RATE_11M)
+			ret &= IFRFbWriteEmbedded(priv, 0x111bb900 +
+				(BY_AL7230_REG_LEN << 3)+IFREGCTL_REGW);
+		else
+			ret &= IFRFbWriteEmbedded(priv, 0x221bb900 +
+				(BY_AL7230_REG_LEN << 3)+IFREGCTL_REGW);
 
-                if (pDevice->byCurPwr > AL7230_PWR_IDX_LEN) return false;
+		if (priv->byCurPwr > AL7230_PWR_IDX_LEN)
+			return false;
 
-                //  0x080F1B00 for 3 wire control TxGain(D10) and 0x31 as TX Gain value
-                dwMax7230Pwr = 0x080C0B00 | ( (pDevice->byCurPwr) << 12 ) |
-                                 (BY_AL7230_REG_LEN << 3 )  | IFREGCTL_REGW;
+		/*
+		* 0x080F1B00 for 3 wire control TxGain(D10)
+		* and 0x31 as TX Gain value
+		*/
+		power_setting = 0x080c0b00 | ((priv->byCurPwr) << 12) |
+				(BY_AL7230_REG_LEN << 3) | IFREGCTL_REGW;
 
-                bResult &= IFRFbWriteEmbedded(pDevice, dwMax7230Pwr);
-                break;
-            }
-            break;
+		ret &= IFRFbWriteEmbedded(priv, power_setting);
 
-        case RF_VT3226: //RobertYu:20051111, VT3226C0 and before
-        {
-            u32       dwVT3226Pwr;
+		break;
 
-            if (pDevice->byCurPwr >= VT3226_PWR_IDX_LEN)
-                return false;
-            dwVT3226Pwr = ((0x3F-pDevice->byCurPwr) << 20 ) | ( 0x17 << 8 ) /* Reg7 */ |
-                           (BY_VT3226_REG_LEN << 3 )  | IFREGCTL_REGW;
-            bResult &= IFRFbWriteEmbedded(pDevice, dwVT3226Pwr);
-            break;
-        }
+	case RF_VT3226:
+		if (priv->byCurPwr >= VT3226_PWR_IDX_LEN)
+			return false;
+		power_setting = ((0x3f - priv->byCurPwr) << 20) | (0x17 << 8) |
+				(BY_VT3226_REG_LEN << 3) | IFREGCTL_REGW;
 
-        case RF_VT3226D0: //RobertYu:20051228
-        {
-            u32       dwVT3226Pwr;
+		ret &= IFRFbWriteEmbedded(priv, power_setting);
 
-            if (pDevice->byCurPwr >= VT3226_PWR_IDX_LEN)
-                return false;
+		break;
+	case RF_VT3226D0:
+		if (priv->byCurPwr >= VT3226_PWR_IDX_LEN)
+			return false;
 
-            if (uRATE <= RATE_11M) {
+		if (rate <= RATE_11M) {
+			power_setting = ((0x3f-priv->byCurPwr) << 20) |
+				(0xe07 << 8) | (BY_VT3226_REG_LEN << 3) |
+						IFREGCTL_REGW;
 
-                dwVT3226Pwr = ((0x3F-pDevice->byCurPwr) << 20 ) | ( 0xE07 << 8 ) /* Reg7 */ |   //RobertYu:20060420, TWIF 1.10
-                               (BY_VT3226_REG_LEN << 3 )  | IFREGCTL_REGW;
-                bResult &= IFRFbWriteEmbedded(pDevice, dwVT3226Pwr);
+			ret &= IFRFbWriteEmbedded(priv, power_setting);
+			ret &= IFRFbWriteEmbedded(priv, 0x03c6a200 +
+					(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW);
 
-                bResult &= IFRFbWriteEmbedded(pDevice, 0x03C6A200+(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW);
-		if (pDevice->vnt_mgmt.eScanState != WMAC_NO_SCANNING) {
-			/* scanning, channel number is pDevice->uScanChannel */
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			if (priv->vnt_mgmt.eScanState != WMAC_NO_SCANNING) {
+				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				"RFbRawSetPower> 11B mode uCurrChannel[%d]\n",
+						priv->vnt_mgmt.uScanChannel);
+				ret &= IFRFbWriteEmbedded(priv,
+					dwVT3226D0LoCurrentTable[priv->
+						vnt_mgmt.uScanChannel - 1]);
+			} else {
+				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 				"RFbRawSetPower> 11B mode uCurrChannel[%d]\n",
-				pDevice->vnt_mgmt.uScanChannel);
-			bResult &= IFRFbWriteEmbedded(pDevice,
-				dwVT3226D0LoCurrentTable[pDevice->
-					vnt_mgmt.uScanChannel - 1]);
+						priv->vnt_mgmt.uCurrChannel);
+				ret &= IFRFbWriteEmbedded(priv,
+					dwVT3226D0LoCurrentTable[priv->
+						vnt_mgmt.uCurrChannel - 1]);
+			}
+
+			ret &= IFRFbWriteEmbedded(priv, 0x015C0800 +
+				(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW);
 		} else {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-				"RFbRawSetPower> 11B mode uCurrChannel[%d]\n",
-				pDevice->vnt_mgmt.uCurrChannel);
-			bResult &= IFRFbWriteEmbedded(pDevice,
-				dwVT3226D0LoCurrentTable[pDevice->
-					vnt_mgmt.uCurrChannel - 1]);
+					"@@@@ RFbRawSetPower> 11G mode\n");
+
+			power_setting = ((0x3f-priv->byCurPwr) << 20) |
+				(0x7 << 8) | (BY_VT3226_REG_LEN << 3) |
+					IFREGCTL_REGW;
+
+			ret &= IFRFbWriteEmbedded(priv, power_setting);
+			ret &= IFRFbWriteEmbedded(priv, 0x00C6A200 +
+				(BY_VT3226_REG_LEN << 3) + IFREGCTL_REGW);
+			ret &= IFRFbWriteEmbedded(priv, 0x016BC600 +
+					(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW);
+			ret &= IFRFbWriteEmbedded(priv, 0x00900800 +
+					(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW);
 		}
+		break;
 
-                bResult &= IFRFbWriteEmbedded(pDevice, 0x015C0800+(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW); //RobertYu:20060420, ok now, new switching power (mini-pci can have bigger power consumption)
-            } else {
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"@@@@ RFbRawSetPower> 11G mode\n");
-                dwVT3226Pwr = ((0x3F-pDevice->byCurPwr) << 20 ) | ( 0x7 << 8 ) /* Reg7 */ |   //RobertYu:20060420, TWIF 1.10
-                               (BY_VT3226_REG_LEN << 3 )  | IFREGCTL_REGW;
-                bResult &= IFRFbWriteEmbedded(pDevice, dwVT3226Pwr);
-                bResult &= IFRFbWriteEmbedded(pDevice, 0x00C6A200+(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW); //RobertYu:20060327
-                bResult &= IFRFbWriteEmbedded(pDevice, 0x016BC600+(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW); //RobertYu:20060111
-                bResult &= IFRFbWriteEmbedded(pDevice, 0x00900800+(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW); //RobertYu:20060111
-            }
-            break;
-        }
-
-        //{{RobertYu:20060609
-        case RF_VT3342A0:
-        {
-            u32       dwVT3342Pwr;
+	case RF_VT3342A0:
+		if (priv->byCurPwr >= VT3342_PWR_IDX_LEN)
+			return false;
 
-            if (pDevice->byCurPwr >= VT3342_PWR_IDX_LEN)
-                return false;
+		power_setting =  ((0x3F-priv->byCurPwr) << 20) |
+			(0x27 << 8) | (BY_VT3342_REG_LEN << 3) |
+					IFREGCTL_REGW;
 
-            dwVT3342Pwr =  ((0x3F-pDevice->byCurPwr) << 20 ) | ( 0x27 << 8 ) /* Reg7 */ |
-                            (BY_VT3342_REG_LEN << 3 )  | IFREGCTL_REGW;
-            bResult &= IFRFbWriteEmbedded(pDevice, dwVT3342Pwr);
-            break;
-        }
+		ret &= IFRFbWriteEmbedded(priv, power_setting);
 
-        default :
-            break;
-    }
-    return bResult;
+		break;
+	default:
+		break;
+	}
+	return ret;
 }
 
 /*+
-- 
1.8.1.2





