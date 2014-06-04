Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:58991 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaFDR0r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 13:26:47 -0400
Received: by mail-wi0-f171.google.com with SMTP id cc10so8993357wib.4
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2014 10:26:46 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 14/15] staging: vt6656: rename BBvCalculateParameter to vnt_get_phy_field
Date: Wed,  4 Jun 2014 18:25:34 +0100
Message-Id: <1401902735-3882-14-git-send-email-tvboxspy@gmail.com> (sfid-20140604_194613_943347_A1243AEE)
In-Reply-To: <1401902735-3882-1-git-send-email-tvboxspy@gmail.com>
References: <1401902735-3882-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function returns the phy fields rename to vnt_get_phy_field

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c |  4 ++--
 drivers/staging/vt6656/baseband.h |  2 +-
 drivers/staging/vt6656/card.c     |  8 ++++----
 drivers/staging/vt6656/rxtx.c     | 32 ++++++++++++++++----------------
 4 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index aada8e7..b74c412 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -27,7 +27,7 @@
  *
  * Functions:
  *      BBuGetFrameTime        - Calculate data frame transmitting time
- *      BBvCalculateParameter   - Calculate PhyLength, PhyService and Phy Signal parameter for baseband Tx
+ *      vnt_get_phy_field   - Calculate PhyLength, PhyService and Phy Signal parameter for baseband Tx
  *      BBbVT3184Init          - VIA VT3184 baseband chip init code
  *
  * Revision History:
@@ -705,7 +705,7 @@ unsigned int BBuGetFrameTime(u8 preamble_type, u8 pkt_type,
  * Return Value: none
  *
  */
-void BBvCalculateParameter(struct vnt_private *priv, u32 frame_length,
+void vnt_get_phy_field(struct vnt_private *priv, u32 frame_length,
 	u16 tx_rate, u8 pkt_type, struct vnt_phy_field *phy)
 {
 	u32 bit_count;
diff --git a/drivers/staging/vt6656/baseband.h b/drivers/staging/vt6656/baseband.h
index 3044d6c..002e58e 100644
--- a/drivers/staging/vt6656/baseband.h
+++ b/drivers/staging/vt6656/baseband.h
@@ -91,7 +91,7 @@ struct vnt_phy_field {
 unsigned int BBuGetFrameTime(u8 preamble_type, u8 pkt_type,
 	unsigned int frame_length, u16 tx_rate);
 
-void BBvCalculateParameter(struct vnt_private *, u32 frame_length,
+void vnt_get_phy_field(struct vnt_private *, u32 frame_length,
 	u16 tx_rate, u8 pkt_type, struct vnt_phy_field *);
 
 void BBvSetShortSlotTime(struct vnt_private *);
diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 9794116..8be3a89 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -300,19 +300,19 @@ void vnt_set_rspinf(struct vnt_private *priv, u8 bb_type)
 	int i;
 
 	/*RSPINF_b_1*/
-	BBvCalculateParameter(priv, 14,
+	vnt_get_phy_field(priv, 14,
 		vnt_get_cck_rate(priv, RATE_1M), PK_TYPE_11B, &phy[0]);
 
 	/*RSPINF_b_2*/
-	BBvCalculateParameter(priv, 14,
+	vnt_get_phy_field(priv, 14,
 		vnt_get_cck_rate(priv, RATE_2M), PK_TYPE_11B, &phy[1]);
 
 	/*RSPINF_b_5*/
-	BBvCalculateParameter(priv, 14,
+	vnt_get_phy_field(priv, 14,
 		vnt_get_cck_rate(priv, RATE_5M), PK_TYPE_11B, &phy[2]);
 
 	/*RSPINF_b_11*/
-	BBvCalculateParameter(priv, 14,
+	vnt_get_phy_field(priv, 14,
 		vnt_get_cck_rate(priv, RATE_11M), PK_TYPE_11B, &phy[3]);
 
 
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 22cb642..9604b8e 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -494,8 +494,8 @@ static u16 vnt_rxtx_datahead_g(struct vnt_usb_send_context *tx_context,
 	struct vnt_private *priv = tx_context->priv;
 
 	/* Get SignalField,ServiceField,Length */
-	BBvCalculateParameter(priv, frame_len, rate, pkt_type, &buf->a);
-	BBvCalculateParameter(priv, frame_len, priv->byTopCCKBasicRate,
+	vnt_get_phy_field(priv, frame_len, rate, pkt_type, &buf->a);
+	vnt_get_phy_field(priv, frame_len, priv->byTopCCKBasicRate,
 							PK_TYPE_11B, &buf->b);
 
 	/* Get Duration and TimeStamp */
@@ -518,9 +518,9 @@ static u16 vnt_rxtx_datahead_g_fb(struct vnt_usb_send_context *tx_context,
 	struct vnt_private *priv = tx_context->priv;
 
 	/* Get SignalField,ServiceField,Length */
-	BBvCalculateParameter(priv, frame_len, rate, pkt_type, &buf->a);
+	vnt_get_phy_field(priv, frame_len, rate, pkt_type, &buf->a);
 
-	BBvCalculateParameter(priv, frame_len, priv->byTopCCKBasicRate,
+	vnt_get_phy_field(priv, frame_len, priv->byTopCCKBasicRate,
 						PK_TYPE_11B, &buf->b);
 
 	/* Get Duration and TimeStamp */
@@ -546,7 +546,7 @@ static u16 vnt_rxtx_datahead_a_fb(struct vnt_usb_send_context *tx_context,
 	struct vnt_private *priv = tx_context->priv;
 
 	/* Get SignalField,ServiceField,Length */
-	BBvCalculateParameter(priv, frame_len, rate, pkt_type, &buf->a);
+	vnt_get_phy_field(priv, frame_len, rate, pkt_type, &buf->a);
 	/* Get Duration and TimeStampOff */
 	buf->duration = s_uGetDataDuration(priv, pkt_type, need_ack);
 
@@ -567,7 +567,7 @@ static u16 vnt_rxtx_datahead_ab(struct vnt_usb_send_context *tx_context,
 	struct vnt_private *priv = tx_context->priv;
 
 	/* Get SignalField,ServiceField,Length */
-	BBvCalculateParameter(priv, frame_len, rate, pkt_type, &buf->ab);
+	vnt_get_phy_field(priv, frame_len, rate, pkt_type, &buf->ab);
 	/* Get Duration and TimeStampOff */
 	buf->duration = s_uGetDataDuration(priv, pkt_type, need_ack);
 
@@ -608,9 +608,9 @@ static u16 vnt_rxtx_rts_g_head(struct vnt_usb_send_context *tx_context,
 	struct vnt_private *priv = tx_context->priv;
 	u16 rts_frame_len = 20;
 
-	BBvCalculateParameter(priv, rts_frame_len, priv->byTopCCKBasicRate,
+	vnt_get_phy_field(priv, rts_frame_len, priv->byTopCCKBasicRate,
 		PK_TYPE_11B, &buf->b);
-	BBvCalculateParameter(priv, rts_frame_len,
+	vnt_get_phy_field(priv, rts_frame_len,
 		priv->byTopOFDMBasicRate, pkt_type, &buf->a);
 
 	buf->duration_bb = s_uGetRTSCTSDuration(priv, RTSDUR_BB, frame_len,
@@ -634,9 +634,9 @@ static u16 vnt_rxtx_rts_g_fb_head(struct vnt_usb_send_context *tx_context,
 	struct vnt_private *priv = tx_context->priv;
 	u16 rts_frame_len = 20;
 
-	BBvCalculateParameter(priv, rts_frame_len, priv->byTopCCKBasicRate,
+	vnt_get_phy_field(priv, rts_frame_len, priv->byTopCCKBasicRate,
 		PK_TYPE_11B, &buf->b);
-	BBvCalculateParameter(priv, rts_frame_len,
+	vnt_get_phy_field(priv, rts_frame_len,
 		priv->byTopOFDMBasicRate, pkt_type, &buf->a);
 
 
@@ -671,7 +671,7 @@ static u16 vnt_rxtx_rts_ab_head(struct vnt_usb_send_context *tx_context,
 	struct vnt_private *priv = tx_context->priv;
 	u16 rts_frame_len = 20;
 
-	BBvCalculateParameter(priv, rts_frame_len,
+	vnt_get_phy_field(priv, rts_frame_len,
 		priv->byTopOFDMBasicRate, pkt_type, &buf->ab);
 
 	buf->duration = s_uGetRTSCTSDuration(priv, RTSDUR_AA, frame_len,
@@ -691,7 +691,7 @@ static u16 vnt_rxtx_rts_a_fb_head(struct vnt_usb_send_context *tx_context,
 	struct vnt_private *priv = tx_context->priv;
 	u16 rts_frame_len = 20;
 
-	BBvCalculateParameter(priv, rts_frame_len,
+	vnt_get_phy_field(priv, rts_frame_len,
 		priv->byTopOFDMBasicRate, pkt_type, &buf->a);
 
 	buf->duration = s_uGetRTSCTSDuration(priv, RTSDUR_AA, frame_len,
@@ -766,7 +766,7 @@ static u16 s_vFillCTSHead(struct vnt_usb_send_context *tx_context,
 		/* Auto Fall back */
 		struct vnt_cts_fb *pBuf = &head->cts_g_fb;
 		/* Get SignalField,ServiceField,Length */
-		BBvCalculateParameter(pDevice, uCTSFrameLen,
+		vnt_get_phy_field(pDevice, uCTSFrameLen,
 			pDevice->byTopCCKBasicRate, PK_TYPE_11B, &pBuf->b);
 		pBuf->duration_ba = s_uGetRTSCTSDuration(pDevice, CTSDUR_BA,
 			cbFrameLength, byPktType,
@@ -792,7 +792,7 @@ static u16 s_vFillCTSHead(struct vnt_usb_send_context *tx_context,
 	} else {
 		struct vnt_cts *pBuf = &head->cts_g;
 		/* Get SignalField,ServiceField,Length */
-		BBvCalculateParameter(pDevice, uCTSFrameLen,
+		vnt_get_phy_field(pDevice, uCTSFrameLen,
 			pDevice->byTopCCKBasicRate, PK_TYPE_11B, &pBuf->b);
 		/* Get CTSDuration_ba */
 		pBuf->duration_ba = s_uGetRTSCTSDuration(pDevice,
@@ -1651,7 +1651,7 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
 		wCurrentRate = RATE_6M;
 
 		/* Get SignalField,ServiceField,Length */
-		BBvCalculateParameter(pDevice, cbFrameSize, wCurrentRate,
+		vnt_get_phy_field(pDevice, cbFrameSize, wCurrentRate,
 			PK_TYPE_11A, &short_head->ab);
 
 		/* Get Duration and TimeStampOff */
@@ -1664,7 +1664,7 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
 		short_head->fifo_ctl |= FIFOCTL_11B;
 
 		/* Get SignalField,ServiceField,Length */
-		BBvCalculateParameter(pDevice, cbFrameSize, wCurrentRate,
+		vnt_get_phy_field(pDevice, cbFrameSize, wCurrentRate,
 					PK_TYPE_11B, &short_head->ab);
 
 		/* Get Duration and TimeStampOff */
-- 
1.9.1

