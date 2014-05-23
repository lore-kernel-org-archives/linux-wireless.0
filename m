Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:48431 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbaEWRBd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 13:01:33 -0400
Received: by mail-we0-f169.google.com with SMTP id u56so5220128wes.14
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 10:01:32 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 18/20] staging: vt6656: camel case cleanup vUpdateIFS
Date: Fri, 23 May 2014 18:00:17 +0100
Message-Id: <1400864419-8327-18-git-send-email-tvboxspy@gmail.com> (sfid-20140523_192148_982302_8C793405)
In-Reply-To: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
References: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
pDevice -> priv
byMaxMin -> max_min
byData -> data
pItemRates -> item_rates

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 159 +++++++++++++++++++++---------------------
 drivers/staging/vt6656/card.h |   2 +-
 2 files changed, 79 insertions(+), 82 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 43554e0..58d31bc 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -385,95 +385,92 @@ void CARDvSetRSPINF(struct vnt_private *priv, u8 bb_type)
  *
  * Parameters:
  *  In:
- *      pDevice             - The adapter to be set
- *  Out:
- *      none
+ *	priv - The adapter to be set
+ * Out:
+ *	none
  *
  * Return Value: None.
  *
  */
-void vUpdateIFS(struct vnt_private *pDevice)
+void vUpdateIFS(struct vnt_private *priv)
 {
-	u8 byMaxMin = 0;
-	u8 byData[4];
-
-    if (pDevice->byPacketType==PK_TYPE_11A) {//0000 0000 0000 0000,11a
-        pDevice->uSlot = C_SLOT_SHORT;
-        pDevice->uSIFS = C_SIFS_A;
-        pDevice->uDIFS = C_SIFS_A + 2*C_SLOT_SHORT;
-        pDevice->uCwMin = C_CWMIN_A;
-        byMaxMin = 4;
-    }
-    else if (pDevice->byPacketType==PK_TYPE_11B) {//0000 0001 0000 0000,11b
-        pDevice->uSlot = C_SLOT_LONG;
-        pDevice->uSIFS = C_SIFS_BG;
-        pDevice->uDIFS = C_SIFS_BG + 2*C_SLOT_LONG;
-          pDevice->uCwMin = C_CWMIN_B;
-        byMaxMin = 5;
-    }
-    else {// PK_TYPE_11GA & PK_TYPE_11GB
-        u8 byRate = 0;
-        bool bOFDMRate = false;
-	unsigned int ii = 0;
-        PWLAN_IE_SUPP_RATES pItemRates = NULL;
-
-        pDevice->uSIFS = C_SIFS_BG;
-        if (pDevice->bShortSlotTime) {
-            pDevice->uSlot = C_SLOT_SHORT;
-        } else {
-            pDevice->uSlot = C_SLOT_LONG;
-        }
-        pDevice->uDIFS = C_SIFS_BG + 2*pDevice->uSlot;
-
-	pItemRates = (PWLAN_IE_SUPP_RATES)pDevice->vnt_mgmt.abyCurrSuppRates;
-        for (ii = 0; ii < pItemRates->len; ii++) {
-            byRate = (u8)(pItemRates->abyRates[ii]&0x7F);
-            if (RATEwGetRateIdx(byRate) > RATE_11M) {
-                bOFDMRate = true;
-                break;
-            }
-        }
-        if (bOFDMRate == false) {
-		pItemRates = (PWLAN_IE_SUPP_RATES)pDevice->vnt_mgmt
-			.abyCurrExtSuppRates;
-            for (ii = 0; ii < pItemRates->len; ii++) {
-                byRate = (u8)(pItemRates->abyRates[ii]&0x7F);
-                if (RATEwGetRateIdx(byRate) > RATE_11M) {
-                    bOFDMRate = true;
-                    break;
-                }
-            }
-        }
-        if (bOFDMRate == true) {
-            pDevice->uCwMin = C_CWMIN_A;
-            byMaxMin = 4;
-        } else {
-            pDevice->uCwMin = C_CWMIN_B;
-            byMaxMin = 5;
-        }
-    }
+	u8 max_min = 0;
+	u8 data[4];
+
+	if (priv->byPacketType == PK_TYPE_11A) {
+		priv->uSlot = C_SLOT_SHORT;
+		priv->uSIFS = C_SIFS_A;
+		priv->uDIFS = C_SIFS_A + 2 * C_SLOT_SHORT;
+		priv->uCwMin = C_CWMIN_A;
+		max_min = 4;
+	} else if (priv->byPacketType == PK_TYPE_11B) {
+		priv->uSlot = C_SLOT_LONG;
+		priv->uSIFS = C_SIFS_BG;
+		priv->uDIFS = C_SIFS_BG + 2 * C_SLOT_LONG;
+		priv->uCwMin = C_CWMIN_B;
+		max_min = 5;
+	} else {/* PK_TYPE_11GA & PK_TYPE_11GB */
+		u8 rate = 0;
+		bool ofdm_rate = false;
+		unsigned int ii = 0;
+		PWLAN_IE_SUPP_RATES item_rates = NULL;
+
+		priv->uSIFS = C_SIFS_BG;
+
+		if (priv->bShortSlotTime)
+			priv->uSlot = C_SLOT_SHORT;
+		else
+			priv->uSlot = C_SLOT_LONG;
+
+		priv->uDIFS = C_SIFS_BG + 2 * priv->uSlot;
+
+		item_rates =
+			(PWLAN_IE_SUPP_RATES)priv->vnt_mgmt.abyCurrSuppRates;
+
+		for (ii = 0; ii < item_rates->len; ii++) {
+			rate = (u8)(item_rates->abyRates[ii] & 0x7f);
+			if (RATEwGetRateIdx(rate) > RATE_11M) {
+				ofdm_rate = true;
+				break;
+			}
+		}
 
-    pDevice->uCwMax = C_CWMAX;
-    pDevice->uEIFS = C_EIFS;
+		if (ofdm_rate == false) {
+			item_rates = (PWLAN_IE_SUPP_RATES)priv->vnt_mgmt
+				.abyCurrExtSuppRates;
+			for (ii = 0; ii < item_rates->len; ii++) {
+				rate = (u8)(item_rates->abyRates[ii] & 0x7f);
+				if (RATEwGetRateIdx(rate) > RATE_11M) {
+					ofdm_rate = true;
+					break;
+				}
+			}
+		}
 
-    byData[0] = (u8)pDevice->uSIFS;
-    byData[1] = (u8)pDevice->uDIFS;
-    byData[2] = (u8)pDevice->uEIFS;
-    byData[3] = (u8)pDevice->uSlot;
-    CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_WRITE,
-                        MAC_REG_SIFS,
-                        MESSAGE_REQUEST_MACREG,
-                        4,
-                        &byData[0]);
+		if (ofdm_rate == true) {
+			priv->uCwMin = C_CWMIN_A;
+			max_min = 4;
+		} else {
+			priv->uCwMin = C_CWMIN_B;
+			max_min = 5;
+			}
+	}
 
-    byMaxMin |= 0xA0;//1010 1111,C_CWMAX = 1023
-    CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_WRITE,
-                        MAC_REG_CWMAXMIN0,
-                        MESSAGE_REQUEST_MACREG,
-                        1,
-                        &byMaxMin);
+	priv->uCwMax = C_CWMAX;
+	priv->uEIFS = C_EIFS;
+
+	data[0] = (u8)priv->uSIFS;
+	data[1] = (u8)priv->uDIFS;
+	data[2] = (u8)priv->uEIFS;
+	data[3] = (u8)priv->uSlot;
+
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE, MAC_REG_SIFS,
+		MESSAGE_REQUEST_MACREG, 4, &data[0]);
+
+	max_min |= 0xa0;
+
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE, MAC_REG_CWMAXMIN0,
+		MESSAGE_REQUEST_MACREG, 1, &max_min);
 }
 
 void CARDvUpdateBasicTopRate(struct vnt_private *pDevice)
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index 6123c13..4986e2d 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -47,7 +47,7 @@ struct vnt_private;
 
 void CARDbSetMediaChannel(struct vnt_private *pDevice, u32 uConnectionChannel);
 void CARDvSetRSPINF(struct vnt_private *, u8);
-void vUpdateIFS(struct vnt_private *pDevice);
+void vUpdateIFS(struct vnt_private *);
 void CARDvUpdateBasicTopRate(struct vnt_private *pDevice);
 void CARDbAddBasicRate(struct vnt_private *pDevice, u16 wRateIdx);
 int CARDbIsOFDMinBasicRate(struct vnt_private *pDevice);
-- 
1.9.1

