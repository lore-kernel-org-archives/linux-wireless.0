Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:46206 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332AbaJ2Ro7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:44:59 -0400
Received: by mail-wi0-f175.google.com with SMTP id ex7so2399896wid.14
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:44:58 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 07/34] staging: vt6655: mac80211 conversion: s_uFillDataHead add power saving poll
Date: Wed, 29 Oct 2014 17:43:42 +0000
Message-Id: <1414604649-9105-8-git-send-email-tvboxspy@gmail.com> (sfid-20141029_185400_580744_4AA6BCBF)
In-Reply-To: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
References: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
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
index bc9b81a..7d521c6 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -324,6 +324,7 @@ struct vnt_private {
 	struct ieee80211_hw *hw;
 	struct ieee80211_vif *vif;
 	unsigned long key_entry_inuse;
+	u16 current_aid;
 /* netdev */
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
2.1.0

