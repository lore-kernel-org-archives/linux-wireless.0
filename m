Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56824 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab3JAOuh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 10:50:37 -0400
Received: by mail-wg0-f44.google.com with SMTP id b13so7503206wgh.35
        for <linux-wireless@vger.kernel.org>; Tue, 01 Oct 2013 07:50:36 -0700 (PDT)
Message-ID: <1380639024.2087.1.camel@canaries64-MCP7A> (sfid-20131001_165041_622475_E620E562)
Subject: [PATCH 1/8] staging: vt6656: rxtx.c change  tx functions to return
 u16
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 01 Oct 2013 15:50:24 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

s_vGenerateTxParameter, s_vFillCTSHead, s_vFillRTSHead, vnt_rxtx_rts* functions
to return u16

Initially this is the duration_id field for ieee80211_hdr

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 791144a..ff40255 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -98,7 +98,7 @@ static void s_vSaveTxPktInfo(struct vnt_private *pDevice, u8 byPktNum,
 
 static void *s_vGetFreeContext(struct vnt_private *pDevice);
 
-static void s_vGenerateTxParameter(struct vnt_private *pDevice,
+static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate,	struct vnt_tx_buffer *tx_buffer,
 	struct vnt_mic_hdr **mic_hdr, u32 need_mic, u32 cbFrameSize,
 	int bNeedACK, u32 uDMAIdx, struct ethhdr *psEthHeader, bool need_rts);
@@ -124,11 +124,11 @@ static unsigned int s_uGetTxRsvTime(struct vnt_private *pDevice, u8 byPktType,
 static u16 s_uGetRTSCTSRsvTime(struct vnt_private *pDevice, u8 byRTSRsvType,
 	u8 byPktType, u32 cbFrameLength, u16 wCurrentRate);
 
-static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
+static u16 s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 	u8 byPktType, union vnt_tx_data_head *head, u32 cbFrameLength,
 	int bNeedAck, u16 wCurrentRate, u8 byFBOption);
 
-static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
+static u16 s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 	union vnt_tx_data_head *head, u32 cbFrameLength, int bNeedAck,
 	struct ethhdr *psEthHeader, u16 wCurrentRate, u8 byFBOption);
 
@@ -630,7 +630,7 @@ static int vnt_fill_ieee80211_rts(struct vnt_private *priv,
 	return 0;
 }
 
-static int vnt_rxtx_rts_g_head(struct vnt_private *priv,
+static u16 vnt_rxtx_rts_g_head(struct vnt_private *priv,
 	struct vnt_rts_g *buf, struct ethhdr *eth_hdr,
 	u8 pkt_type, u32 frame_len, int need_ack,
 	u16 current_rate, u8 fb_option)
@@ -654,7 +654,7 @@ static int vnt_rxtx_rts_g_head(struct vnt_private *priv,
 	return 0;
 }
 
-static int vnt_rxtx_rts_g_fb_head(struct vnt_private *priv,
+static u16 vnt_rxtx_rts_g_fb_head(struct vnt_private *priv,
 	struct vnt_rts_g_fb *buf, struct ethhdr *eth_hdr,
 	u8 pkt_type, u32 frame_len, int need_ack,
 	u16 current_rate, u8 fb_option)
@@ -689,7 +689,7 @@ static int vnt_rxtx_rts_g_fb_head(struct vnt_private *priv,
 	return 0;
 }
 
-static int vnt_rxtx_rts_ab_head(struct vnt_private *priv,
+static u16 vnt_rxtx_rts_ab_head(struct vnt_private *priv,
 	struct vnt_rts_ab *buf, struct ethhdr *eth_hdr,
 	u8 pkt_type, u32 frame_len, int need_ack,
 	u16 current_rate, u8 fb_option)
@@ -707,7 +707,7 @@ static int vnt_rxtx_rts_ab_head(struct vnt_private *priv,
 	return 0;
 }
 
-static int vnt_rxtx_rts_a_fb_head(struct vnt_private *priv,
+static u16 vnt_rxtx_rts_a_fb_head(struct vnt_private *priv,
 	struct vnt_rts_a_fb *buf, struct ethhdr *eth_hdr,
 	u8 pkt_type, u32 frame_len, int need_ack,
 	u16 current_rate, u8 fb_option)
@@ -731,13 +731,13 @@ static int vnt_rxtx_rts_a_fb_head(struct vnt_private *priv,
 	return 0;
 }
 
-static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
+static u16 s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 	union vnt_tx_data_head *head, u32 cbFrameLength, int bNeedAck,
 	struct ethhdr *psEthHeader, u16 wCurrentRate, u8 byFBOption)
 {
 
 	if (!head)
-		return;
+		return 0;
 
 	/* Note: So far RTSHead doesn't appear in ATIM
 	*	& Beacom DMA, so we don't need to take them
@@ -768,16 +768,18 @@ static void s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 			psEthHeader, byPktType, cbFrameLength,
 			bNeedAck, wCurrentRate, byFBOption);
 	}
+
+	return 0;
 }
 
-static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
+static u16 s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 	u8 byPktType, union vnt_tx_data_head *head, u32 cbFrameLength,
 	int bNeedAck, u16 wCurrentRate, u8 byFBOption)
 {
 	u32 uCTSFrameLen = 14;
 
 	if (!head)
-		return;
+		return 0;
 
 	if (byFBOption != AUTO_FB_NONE) {
 		/* Auto Fall back */
@@ -814,6 +816,8 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
 		pBuf->data.frame_control = TYPE_CTL_CTS;
 		memcpy(pBuf->data.ra, pDevice->abyCurrentNetAddr, ETH_ALEN);
         }
+
+	return 0;
 }
 
 /*+
@@ -839,7 +843,7 @@ static void s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
  *
 -*/
 
-static void s_vGenerateTxParameter(struct vnt_private *pDevice,
+static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate,	struct vnt_tx_buffer *tx_buffer,
 	struct vnt_mic_hdr **mic_hdr, u32 need_mic, u32 cbFrameSize,
 	int bNeedACK, u32 uDMAIdx, struct ethhdr *psEthHeader, bool need_rts)
@@ -862,7 +866,7 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
     }
 
 	if (!pFifoHead)
-		return;
+		return 0;
 
     if (pDevice->bLongHeader)
         cbMACHdLen = WLAN_HDR_ADDR3_LEN + 6;
@@ -983,6 +987,8 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
         }
     }
     //DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"s_vGenerateTxParameter END.\n");
+
+	return 0;
 }
 /*
     u8 * pbyBuffer,//point to pTxBufHead
-- 
1.8.3.2

