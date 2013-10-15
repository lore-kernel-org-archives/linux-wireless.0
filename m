Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:58069 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757504Ab3JOUAR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 16:00:17 -0400
Received: by mail-we0-f182.google.com with SMTP id t61so9258236wes.27
        for <linux-wireless@vger.kernel.org>; Tue, 15 Oct 2013 13:00:15 -0700 (PDT)
Message-ID: <1381867209.5100.19.camel@canaries32-MCP7A> (sfid-20131015_220022_297113_625250B1)
Subject: [PATCH 1/3] staging: vt6656: rxtx.c s_bPacketToWirelessUsb set
 fallback tx rates
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 15 Oct 2013 21:00:09 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the two TX fall back rates in s_bPacketToWirelessUsb and
pass to private area of driver in variables tx_rate_fb0
and tx_rate_fb1 from the wFB_Opt0/wFB_Opt1 array.

Apply these rates were needed in the TX structure and
remove byFBOption settings in s_uGetRTSCTSDuration.

This greatly simplifies s_uGetRTSCTSDuration and
more future flexibility of setting rates from
upper levels of driver.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h |  3 ++
 drivers/staging/vt6656/rxtx.c   | 99 +++++++++++++++++++----------------------
 2 files changed, 49 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 95b181d..62b7de1 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -579,6 +579,9 @@ struct vnt_private {
 	u8 abyOFDMAPwrTbl[42];
 
 	u16 wCurrentRate;
+	u16 tx_rate_fb0;
+	u16 tx_rate_fb1;
+
 	u16 wRTSThreshold;
 	u16 wFragmentationThreshold;
 	u8 byShortRetryLimit;
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 821b2e1..3404730 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -450,55 +450,37 @@ static u16 s_uGetRTSCTSDuration(struct vnt_private *pDevice, u8 byDurType,
 
     case RTSDUR_BA_F0: //RTSDuration_ba_f0
         uCTSTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopCCKBasicRate);
-        if ((byFBOption == AUTO_FB_0) && (wRate >= RATE_18M) && (wRate <=RATE_54M)) {
-            uDurTime = uCTSTime + 2*pDevice->uSIFS + s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt0[FB_RATE0][wRate-RATE_18M], bNeedAck);
-        } else if ((byFBOption == AUTO_FB_1) && (wRate >= RATE_18M) && (wRate <=RATE_54M)) {
-            uDurTime = uCTSTime + 2*pDevice->uSIFS + s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt1[FB_RATE0][wRate-RATE_18M], bNeedAck);
-        }
+	uDurTime = uCTSTime + 2 * pDevice->uSIFS + s_uGetTxRsvTime(pDevice,
+			byPktType, cbFrameLength, wRate, bNeedAck);
         break;
 
     case RTSDUR_AA_F0: //RTSDuration_aa_f0
         uCTSTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopOFDMBasicRate);
-        if ((byFBOption == AUTO_FB_0) && (wRate >= RATE_18M) && (wRate <=RATE_54M)) {
-            uDurTime = uCTSTime + 2*pDevice->uSIFS + s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt0[FB_RATE0][wRate-RATE_18M], bNeedAck);
-        } else if ((byFBOption == AUTO_FB_1) && (wRate >= RATE_18M) && (wRate <=RATE_54M)) {
-            uDurTime = uCTSTime + 2*pDevice->uSIFS + s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt1[FB_RATE0][wRate-RATE_18M], bNeedAck);
-        }
+	uDurTime = uCTSTime + 2 * pDevice->uSIFS + s_uGetTxRsvTime(pDevice,
+			byPktType, cbFrameLength, wRate, bNeedAck);
         break;
 
     case RTSDUR_BA_F1: //RTSDuration_ba_f1
         uCTSTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopCCKBasicRate);
-        if ((byFBOption == AUTO_FB_0) && (wRate >= RATE_18M) && (wRate <=RATE_54M)) {
-            uDurTime = uCTSTime + 2*pDevice->uSIFS + s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt0[FB_RATE1][wRate-RATE_18M], bNeedAck);
-        } else if ((byFBOption == AUTO_FB_1) && (wRate >= RATE_18M) && (wRate <=RATE_54M)) {
-            uDurTime = uCTSTime + 2*pDevice->uSIFS + s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt1[FB_RATE1][wRate-RATE_18M], bNeedAck);
-        }
+	uDurTime = uCTSTime + 2 * pDevice->uSIFS + s_uGetTxRsvTime(pDevice,
+		byPktType, cbFrameLength, wRate, bNeedAck);
         break;
 
     case RTSDUR_AA_F1: //RTSDuration_aa_f1
         uCTSTime = BBuGetFrameTime(pDevice->byPreambleType, byPktType, 14, pDevice->byTopOFDMBasicRate);
-        if ((byFBOption == AUTO_FB_0) && (wRate >= RATE_18M) && (wRate <=RATE_54M)) {
-            uDurTime = uCTSTime + 2*pDevice->uSIFS + s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt0[FB_RATE1][wRate-RATE_18M], bNeedAck);
-        } else if ((byFBOption == AUTO_FB_1) && (wRate >= RATE_18M) && (wRate <=RATE_54M)) {
-            uDurTime = uCTSTime + 2*pDevice->uSIFS + s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt1[FB_RATE1][wRate-RATE_18M], bNeedAck);
-        }
-        break;
+	uDurTime = uCTSTime + 2 * pDevice->uSIFS + s_uGetTxRsvTime(pDevice,
+				byPktType, cbFrameLength, wRate, bNeedAck);
+	break;
 
     case CTSDUR_BA_F0: //CTSDuration_ba_f0
-        if ((byFBOption == AUTO_FB_0) && (wRate >= RATE_18M) && (wRate <=RATE_54M)) {
-            uDurTime = pDevice->uSIFS + s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt0[FB_RATE0][wRate-RATE_18M], bNeedAck);
-        } else if ((byFBOption == AUTO_FB_1) && (wRate >= RATE_18M) && (wRate <=RATE_54M)) {
-            uDurTime = pDevice->uSIFS + s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt1[FB_RATE0][wRate-RATE_18M], bNeedAck);
-        }
-        break;
+	uDurTime = pDevice->uSIFS + s_uGetTxRsvTime(pDevice,
+				byPktType, cbFrameLength, wRate, bNeedAck);
+	break;
 
     case CTSDUR_BA_F1: //CTSDuration_ba_f1
-        if ((byFBOption == AUTO_FB_0) && (wRate >= RATE_18M) && (wRate <=RATE_54M)) {
-            uDurTime = pDevice->uSIFS + s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt0[FB_RATE1][wRate-RATE_18M], bNeedAck);
-        } else if ((byFBOption == AUTO_FB_1) && (wRate >= RATE_18M) && (wRate <=RATE_54M)) {
-            uDurTime = pDevice->uSIFS + s_uGetTxRsvTime(pDevice, byPktType, cbFrameLength, wFB_Opt1[FB_RATE1][wRate-RATE_18M], bNeedAck);
-        }
-        break;
+	uDurTime = pDevice->uSIFS + s_uGetTxRsvTime(pDevice,
+				byPktType, cbFrameLength, wRate, bNeedAck);
+	break;
 
     default:
         break;
@@ -648,13 +630,13 @@ static u16 vnt_rxtx_rts_g_fb_head(struct vnt_private *priv,
 

 	buf->wRTSDuration_ba_f0 = s_uGetRTSCTSDuration(priv, RTSDUR_BA_F0,
-		frame_len, pkt_type, current_rate, need_ack, fb_option);
+		frame_len, pkt_type, priv->tx_rate_fb0, need_ack, fb_option);
 	buf->wRTSDuration_aa_f0 = s_uGetRTSCTSDuration(priv, RTSDUR_AA_F0,
-		frame_len, pkt_type, current_rate, need_ack, fb_option);
+		frame_len, pkt_type, priv->tx_rate_fb0, need_ack, fb_option);
 	buf->wRTSDuration_ba_f1 = s_uGetRTSCTSDuration(priv, RTSDUR_BA_F1,
-		frame_len, pkt_type, current_rate, need_ack, fb_option);
+		frame_len, pkt_type, priv->tx_rate_fb1, need_ack, fb_option);
 	buf->wRTSDuration_aa_f1 = s_uGetRTSCTSDuration(priv, RTSDUR_AA_F1,
-		frame_len, pkt_type, current_rate, need_ack, fb_option);
+		frame_len, pkt_type, priv->tx_rate_fb1, need_ack, fb_option);
 
 	vnt_fill_ieee80211_rts(priv, &buf->data, eth_hdr, buf->wDuration_aa);
 
@@ -695,10 +677,10 @@ static u16 vnt_rxtx_rts_a_fb_head(struct vnt_private *priv,
 		pkt_type, current_rate, need_ack, fb_option);
 
 	buf->wRTSDuration_f0 = s_uGetRTSCTSDuration(priv, RTSDUR_AA_F0,
-		frame_len, pkt_type, current_rate, need_ack, fb_option);
+		frame_len, pkt_type, priv->tx_rate_fb0, need_ack, fb_option);
 
 	buf->wRTSDuration_f1 = s_uGetRTSCTSDuration(priv, RTSDUR_AA_F1,
-		frame_len, pkt_type, current_rate, need_ack, fb_option);
+		frame_len, pkt_type, priv->tx_rate_fb1, need_ack, fb_option);
 
 	vnt_fill_ieee80211_rts(priv, &buf->data, eth_hdr, buf->wDuration);
 
@@ -767,12 +749,12 @@ static u16 s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 			wCurrentRate, bNeedAck, byFBOption);
 		/* Get CTSDuration_ba_f0 */
 		pBuf->wCTSDuration_ba_f0 = s_uGetRTSCTSDuration(pDevice,
-			CTSDUR_BA_F0, cbFrameLength, byPktType, wCurrentRate,
-			bNeedAck, byFBOption);
+			CTSDUR_BA_F0, cbFrameLength, byPktType,
+			pDevice->tx_rate_fb0, bNeedAck, byFBOption);
 		/* Get CTSDuration_ba_f1 */
 		pBuf->wCTSDuration_ba_f1 = s_uGetRTSCTSDuration(pDevice,
-			CTSDUR_BA_F1, cbFrameLength, byPktType, wCurrentRate,
-			bNeedAck, byFBOption);
+			CTSDUR_BA_F1, cbFrameLength, byPktType,
+			pDevice->tx_rate_fb1, bNeedAck, byFBOption);
 		/* Get CTS Frame body */
 		pBuf->data.duration = pBuf->wDuration_ba;
 		pBuf->data.frame_control = TYPE_CTL_CTS;
@@ -1076,16 +1058,27 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
         pTxBufHead->wFIFOCtl |=	FIFOCTL_GRPACK;
     }
 
-    //Set Auto Fallback Ctl
-    if (wCurrentRate >= RATE_18M) {
-        if (pDevice->byAutoFBCtrl == AUTO_FB_0) {
-            pTxBufHead->wFIFOCtl |= FIFOCTL_AUTO_FB_0;
-            byFBOption = AUTO_FB_0;
-        } else if (pDevice->byAutoFBCtrl == AUTO_FB_1) {
-            pTxBufHead->wFIFOCtl |= FIFOCTL_AUTO_FB_1;
-            byFBOption = AUTO_FB_1;
-        }
-    }
+	/* Set Auto Fallback Ctl */
+	if (wCurrentRate >= RATE_18M) {
+		if (pDevice->byAutoFBCtrl == AUTO_FB_0) {
+			pTxBufHead->wFIFOCtl |= FIFOCTL_AUTO_FB_0;
+
+			pDevice->tx_rate_fb0 =
+				wFB_Opt0[FB_RATE0][wCurrentRate - RATE_18M];
+			pDevice->tx_rate_fb1 =
+				wFB_Opt0[FB_RATE1][wCurrentRate - RATE_18M];
+
+			byFBOption = AUTO_FB_0;
+		} else if (pDevice->byAutoFBCtrl == AUTO_FB_1) {
+			pTxBufHead->wFIFOCtl |= FIFOCTL_AUTO_FB_1;
+			pDevice->tx_rate_fb0 =
+				wFB_Opt1[FB_RATE0][wCurrentRate - RATE_18M];
+			pDevice->tx_rate_fb1 =
+				wFB_Opt1[FB_RATE1][wCurrentRate - RATE_18M];
+
+			byFBOption = AUTO_FB_1;
+		}
+	}
 
     if (bSoftWEP != true) {
         if ((bNeedEncryption) && (pTransmitKey != NULL))  { //WEP enabled
-- 
1.8.3.2


