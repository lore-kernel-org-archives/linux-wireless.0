Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:40659 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbaJYTmT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:42:19 -0400
Received: by mail-wi0-f175.google.com with SMTP id h11so1535325wiw.2
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:42:18 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/31] staging: vt6655: mac80211 conversion: s_uFillDataHead add power saving poll
Date: Sat, 25 Oct 2014 09:20:17 +0100
Message-Id: <1414225241-5480-8-git-send-email-tvboxspy@gmail.com> (sfid-20141025_214226_290740_229314E4)
In-Reply-To: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
References: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace variable wCurrentRate with is_pspoll.

add current_aid to structure vnt_private which is to be used by
mac80211 operations.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h |  1 +
 drivers/staging/vt6655/rxtx.c   | 64 +++++++++++++++++++++++++++++------------
 2 files changed, 47 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 5717fa5..6073076 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -332,6 +332,7 @@ struct vnt_private {
 	struct ieee80211_hw *hw;
 	struct ieee80211_vif *vif;
 	unsigned long key_entry_inuse;
+	u16 current_aid;
 // netdev
 	struct net_device *dev;
 
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index a1a594f..23ee379 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -169,7 +169,8 @@ s_uFillDataHead(
 	unsigned int cbLastFragmentSize,
 	unsigned int uMACfragNum,
 	unsigned char byFBOption,
-	unsigned short wCurrentRate
+	unsigned short wCurrentRate,
+	bool is_pspoll
 );
 
 /*---------------------  Export Variables  --------------------------*/
@@ -674,7 +675,8 @@ s_uFillDataHead(
 	unsigned int cbLastFragmentSize,
 	unsigned int uMACfragNum,
 	unsigned char byFBOption,
-	unsigned short wCurrentRate
+	unsigned short wCurrentRate,
+	bool is_pspoll
 )
 {
 
@@ -693,15 +695,24 @@ s_uFillDataHead(
 					  pDevice->byTopCCKBasicRate,
 					  PK_TYPE_11B, &buf->b);
 
-			/* Get Duration and TimeStamp */
-			buf->duration_a = cpu_to_le16((u16)s_uGetDataDuration(pDevice, DATADUR_A, cbFrameLength,
-									      byPktType, wCurrentRate, bNeedAck, uFragIdx,
-									      cbLastFragmentSize, uMACfragNum,
-									      byFBOption));
-			buf->duration_b = cpu_to_le16((u16)s_uGetDataDuration(pDevice, DATADUR_B, cbFrameLength,
-									      PK_TYPE_11B, pDevice->byTopCCKBasicRate,
-									      bNeedAck, uFragIdx, cbLastFragmentSize,
-									      uMACfragNum, byFBOption));
+			if (is_pspoll) {
+				__le16 dur = cpu_to_le16(pDevice->current_aid | BIT(14) | BIT(15));
+
+				buf->duration_a = dur;
+				buf->duration_b = dur;
+			} else {
+				/* Get Duration and TimeStamp */
+				buf->duration_a =
+					cpu_to_le16((u16)s_uGetDataDuration(pDevice, DATADUR_A, cbFrameLength,
+									    byPktType, wCurrentRate, bNeedAck, uFragIdx,
+									    cbLastFragmentSize, uMACfragNum,
+									    byFBOption));
+				buf->duration_b =
+					cpu_to_le16((u16)s_uGetDataDuration(pDevice, DATADUR_B, cbFrameLength,
+									    PK_TYPE_11B, pDevice->byTopCCKBasicRate,
+									    bNeedAck, uFragIdx, cbLastFragmentSize,
+									    uMACfragNum, byFBOption));
+			}
 
 			buf->time_stamp_off_a = vnt_time_stamp_off(pDevice, wCurrentRate);
 			buf->time_stamp_off_b = vnt_time_stamp_off(pDevice, pDevice->byTopCCKBasicRate);
@@ -755,11 +766,18 @@ s_uFillDataHead(
 			vnt_get_phy_field(pDevice, cbFrameLength, wCurrentRate,
 					  byPktType, &buf->ab);
 
-			/* Get Duration and TimeStampOff */
-			buf->duration = cpu_to_le16((u16)s_uGetDataDuration(pDevice, DATADUR_A, cbFrameLength, byPktType,
+			if (is_pspoll) {
+				__le16 dur = cpu_to_le16(pDevice->current_aid | BIT(14) | BIT(15));
+
+				buf->duration = dur;
+			} else {
+				/* Get Duration and TimeStampOff */
+				buf->duration =
+					cpu_to_le16((u16)s_uGetDataDuration(pDevice, DATADUR_A, cbFrameLength, byPktType,
 									    wCurrentRate, bNeedAck, uFragIdx,
 									    cbLastFragmentSize, uMACfragNum,
 									    byFBOption));
+			}
 
 			buf->time_stamp_off = vnt_time_stamp_off(pDevice, wCurrentRate);
 			return buf->duration;
@@ -769,17 +787,27 @@ s_uFillDataHead(
 		/* Get SignalField, ServiceField & Length */
 		vnt_get_phy_field(pDevice, cbFrameLength, wCurrentRate,
 				  byPktType, &buf->ab);
-		/* Get Duration and TimeStampOff */
-		buf->duration = cpu_to_le16((u16)s_uGetDataDuration(pDevice, DATADUR_B, cbFrameLength, byPktType,
+
+		if (is_pspoll) {
+			__le16 dur = cpu_to_le16(pDevice->current_aid | BIT(14) | BIT(15));
+
+			buf->duration = dur;
+		} else {
+			/* Get Duration and TimeStampOff */
+			buf->duration =
+				cpu_to_le16((u16)s_uGetDataDuration(pDevice, DATADUR_B, cbFrameLength, byPktType,
 								    wCurrentRate, bNeedAck, uFragIdx,
 								    cbLastFragmentSize, uMACfragNum,
 								    byFBOption));
+		}
+
 		buf->time_stamp_off = vnt_time_stamp_off(pDevice, wCurrentRate);
 		return buf->duration;
 	}
 	return 0;
 }
 
+
 static
 void
 s_vFillRTSHead(
@@ -1346,7 +1374,7 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 			       cbFrameSize, bNeedACK, uDMAIdx, hdr, pDevice->wCurrentRate);
 	/* Fill DataHead */
 	uDuration = s_uFillDataHead(pDevice, byPktType, pvTxDataHd, cbFrameSize, uDMAIdx, bNeedACK,
-				    0, 0, uMACfragNum, byFBOption, pDevice->wCurrentRate);
+				    0, 0, uMACfragNum, byFBOption, pDevice->wCurrentRate, is_pspoll);
 
 	hdr->duration_id = uDuration;
 
@@ -1750,7 +1778,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice, PSTxMgmtPacket pPacket)
 
 	//Fill DataHead
 	uDuration = s_uFillDataHead(pDevice, byPktType, pvTxDataHd, cbFrameSize, TYPE_TXDMA0, bNeedACK,
-				    0, 0, 1, AUTO_FB_NONE, wCurrentRate);
+				    0, 0, 1, AUTO_FB_NONE, wCurrentRate, false);
 
 	pMACHeader = (PS802_11Header) (pbyTxBufferAddr + cbHeaderSize);
 
@@ -2245,7 +2273,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb,
 
 	//Fill DataHead
 	uDuration = s_uFillDataHead(pDevice, byPktType, pvTxDataHd, cbFrameSize, TYPE_TXDMA0, bNeedACK,
-				    0, 0, 1, AUTO_FB_NONE, wCurrentRate);
+				    0, 0, 1, AUTO_FB_NONE, wCurrentRate, false);
 
 	pMACHeader = (PS802_11Header) (pbyTxBufferAddr + cbHeaderSize);
 
-- 
1.9.1

