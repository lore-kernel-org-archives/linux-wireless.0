Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:53054 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761227AbaGSLb1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2014 07:31:27 -0400
Received: by mail-we0-f182.google.com with SMTP id k48so4365613wev.41
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2014 04:31:25 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 16/16] staging: vt6656: struct vnt_private remove camel case IFS names
Date: Sat, 19 Jul 2014 12:30:18 +0100
Message-Id: <1405769418-2815-16-git-send-email-tvboxspy@gmail.com> (sfid-20140719_135108_981682_D74F92E9)
In-Reply-To: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
References: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Camel case changes
uSIFS -> sifs
uDIFS -> difs
uEIFS -> eifs
uSlot -> slot

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c   | 46 ++++++++++++++++++++---------------------
 drivers/staging/vt6656/device.h |  8 +++----
 drivers/staging/vt6656/rxtx.c   | 14 ++++++-------
 3 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index f3fd7d6..5ce26fa 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -366,27 +366,27 @@ void vnt_update_ifs(struct vnt_private *priv)
 	u8 data[4];
 
 	if (priv->byPacketType == PK_TYPE_11A) {
-		priv->uSlot = C_SLOT_SHORT;
-		priv->uSIFS = C_SIFS_A;
-		priv->uDIFS = C_SIFS_A + 2 * C_SLOT_SHORT;
+		priv->slot = C_SLOT_SHORT;
+		priv->sifs = C_SIFS_A;
+		priv->difs = C_SIFS_A + 2 * C_SLOT_SHORT;
 		max_min = 4;
 	} else if (priv->byPacketType == PK_TYPE_11B) {
-		priv->uSlot = C_SLOT_LONG;
-		priv->uSIFS = C_SIFS_BG;
-		priv->uDIFS = C_SIFS_BG + 2 * C_SLOT_LONG;
+		priv->slot = C_SLOT_LONG;
+		priv->sifs = C_SIFS_BG;
+		priv->difs = C_SIFS_BG + 2 * C_SLOT_LONG;
 		max_min = 5;
 	} else {/* PK_TYPE_11GA & PK_TYPE_11GB */
 		bool ofdm_rate = false;
 		unsigned int ii = 0;
 
-		priv->uSIFS = C_SIFS_BG;
+		priv->sifs = C_SIFS_BG;
 
 		if (priv->bShortSlotTime)
-			priv->uSlot = C_SLOT_SHORT;
+			priv->slot = C_SLOT_SHORT;
 		else
-			priv->uSlot = C_SLOT_LONG;
+			priv->slot = C_SLOT_LONG;
 
-		priv->uDIFS = C_SIFS_BG + 2 * priv->uSlot;
+		priv->difs = C_SIFS_BG + 2 * priv->slot;
 
 		for (ii = RATE_54M; ii >= RATE_6M; ii--) {
 			if (priv->wBasicRate & ((u32)(0x1 << ii))) {
@@ -401,13 +401,13 @@ void vnt_update_ifs(struct vnt_private *priv)
 			max_min = 5;
 	}
 
-	priv->uEIFS = C_EIFS;
+	priv->eifs = C_EIFS;
 
 	switch (priv->rf_type) {
 	case RF_VT3226D0:
 		if (priv->byBBType != BB_TYPE_11B) {
-			priv->uSIFS -= 1;
-			priv->uDIFS -= 1;
+			priv->sifs -= 1;
+			priv->difs -= 1;
 			break;
 		}
 	case RF_AIROHA7230:
@@ -418,25 +418,25 @@ void vnt_update_ifs(struct vnt_private *priv)
 	case RF_RFMD2959:
 	case RF_VT3226:
 	case RF_VT3342A0:
-		priv->uSIFS -= 3;
-		priv->uDIFS -= 3;
+		priv->sifs -= 3;
+		priv->difs -= 3;
 		break;
 	case RF_MAXIM2829:
 		if (priv->byBBType == BB_TYPE_11A) {
-			priv->uSIFS -= 5;
-			priv->uDIFS -= 5;
+			priv->sifs -= 5;
+			priv->difs -= 5;
 		} else {
-			priv->uSIFS -= 2;
-			priv->uDIFS -= 2;
+			priv->sifs -= 2;
+			priv->difs -= 2;
 		}
 
 		break;
 	}
 
-	data[0] = (u8)priv->uSIFS;
-	data[1] = (u8)priv->uDIFS;
-	data[2] = (u8)priv->uEIFS;
-	data[3] = (u8)priv->uSlot;
+	data[0] = (u8)priv->sifs;
+	data[1] = (u8)priv->difs;
+	data[2] = (u8)priv->eifs;
+	data[3] = (u8)priv->slot;
 
 	vnt_control_out(priv, MESSAGE_TYPE_WRITE, MAC_REG_SIFS,
 		MESSAGE_REQUEST_MACREG, 4, &data[0]);
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index f67173b..b9753c1 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -324,10 +324,10 @@ struct vnt_private {
 	u8 radio_ctl;
 
 	/* IFS & Cw */
-	u32 uSIFS;  /* Current SIFS */
-	u32 uDIFS;  /* Current DIFS */
-	u32 uEIFS;  /* Current EIFS */
-	u32 uSlot;  /* Current SlotTime */
+	u32 sifs;  /* Current SIFS */
+	u32 difs;  /* Current DIFS */
+	u32 eifs;  /* Current EIFS */
+	u32 slot;  /* Current SlotTime */
 
 	/* Rate */
 	u8 byBBType; /* 0: 11A, 1:11B, 2:11G */
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 25a87b0..aa382e7 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -125,7 +125,7 @@ static u32 vnt_get_rsvtime(struct vnt_private *priv, u8 pkt_type,
 					14, (u16)priv->byTopOFDMBasicRate);
 
 	if (need_ack)
-		return data_time + priv->uSIFS + ack_time;
+		return data_time + priv->sifs + ack_time;
 
 	return data_time;
 }
@@ -170,12 +170,12 @@ static __le16 vnt_get_rtscts_rsvtime_le(struct vnt_private *priv,
 		ack_time = vnt_get_frame_time(priv->byPreambleType, pkt_type,
 			14, priv->byTopOFDMBasicRate);
 
-		rrv_time = cts_time + ack_time + data_time + 2 * priv->uSIFS;
+		rrv_time = cts_time + ack_time + data_time + 2 * priv->sifs;
 
 		return cpu_to_le16((u16)rrv_time);
 	}
 
-	rrv_time = rts_time + cts_time + ack_time + data_time + 3 * priv->uSIFS;
+	rrv_time = rts_time + cts_time + ack_time + data_time + 3 * priv->sifs;
 
 	return cpu_to_le16((u16)rrv_time);
 }
@@ -193,7 +193,7 @@ static __le16 vnt_get_duration_le(struct vnt_private *piv,
 			ack_time = vnt_get_frame_time(piv->byPreambleType,
 				pkt_type, 14, piv->byTopOFDMBasicRate);
 
-		return cpu_to_le16((u16)(piv->uSIFS + ack_time));
+		return cpu_to_le16((u16)(piv->sifs + ack_time));
 	}
 
 	return 0;
@@ -211,7 +211,7 @@ static __le16 vnt_get_rtscts_duration_le(struct vnt_private *priv, u8 dur_type,
 	case RTSDUR_BA_F1:
 		cts_time = vnt_get_frame_time(priv->byPreambleType,
 				pkt_type, 14, priv->byTopCCKBasicRate);
-		dur_time = cts_time + 2 * priv->uSIFS +
+		dur_time = cts_time + 2 * priv->sifs +
 			vnt_get_rsvtime(priv, pkt_type,
 						frame_length, rate, need_ack);
 		break;
@@ -221,7 +221,7 @@ static __le16 vnt_get_rtscts_duration_le(struct vnt_private *priv, u8 dur_type,
 	case RTSDUR_AA_F1:
 		cts_time = vnt_get_frame_time(priv->byPreambleType,
 				pkt_type, 14, priv->byTopOFDMBasicRate);
-		dur_time = cts_time + 2 * priv->uSIFS +
+		dur_time = cts_time + 2 * priv->sifs +
 			vnt_get_rsvtime(priv, pkt_type,
 						frame_length, rate, need_ack);
 		break;
@@ -229,7 +229,7 @@ static __le16 vnt_get_rtscts_duration_le(struct vnt_private *priv, u8 dur_type,
 	case CTSDUR_BA:
 	case CTSDUR_BA_F0:
 	case CTSDUR_BA_F1:
-		dur_time = priv->uSIFS + vnt_get_rsvtime(priv,
+		dur_time = priv->sifs + vnt_get_rsvtime(priv,
 				pkt_type, frame_length, rate, need_ack);
 		break;
 
-- 
2.0.1

