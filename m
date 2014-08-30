Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:38278 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbaH3V0e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Aug 2014 17:26:34 -0400
Received: by mail-wg0-f52.google.com with SMTP id m15so3619073wgh.23
        for <linux-wireless@vger.kernel.org>; Sat, 30 Aug 2014 14:26:33 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/23] staging: vt6655: rxtx.c create function to return __le16 wTimeStampOff
Date: Sat, 30 Aug 2014 22:25:33 +0100
Message-Id: <1409433949-5468-7-git-send-email-tvboxspy@gmail.com> (sfid-20140830_232645_107633_FC5C86F9)
In-Reply-To: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
References: <1409433949-5468-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wTimeStampOff always needs to be endian corrected.

Create vnt_time_stamp_off to return this value.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rxtx.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index afdf3ab..9617701 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -337,6 +337,12 @@ s_vSWencryption(
 	}
 }
 
+static __le16 vnt_time_stamp_off(struct vnt_private *priv, u16 rate)
+{
+	return cpu_to_le16(wTimeStampOff[priv->byPreambleType % 2]
+							[rate % MAX_RATE]);
+}
+
 /*byPktType : PK_TYPE_11A     0
   PK_TYPE_11B     1
   PK_TYPE_11GB    2
@@ -706,8 +712,8 @@ s_uFillDataHead(
 											   bNeedAck, uFragIdx, cbLastFragmentSize,
 											   uMACfragNum, byFBOption)); //1: 2.4
 
-			pBuf->wTimeStampOff_a = cpu_to_le16(wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE]);
-			pBuf->wTimeStampOff_b = cpu_to_le16(wTimeStampOff[pDevice->byPreambleType%2][pDevice->byTopCCKBasicRate%MAX_RATE]);
+			pBuf->wTimeStampOff_a = vnt_time_stamp_off(pDevice, wCurrentRate);
+			pBuf->wTimeStampOff_b = vnt_time_stamp_off(pDevice, pDevice->byTopCCKBasicRate);
 
 			return pBuf->wDuration_a;
 		} else {
@@ -730,8 +736,8 @@ s_uFillDataHead(
 			pBuf->wDuration_a_f1 = cpu_to_le16((unsigned short)s_uGetDataDuration(pDevice, DATADUR_A_F1, cbFrameLength, byPktType,
 											      wCurrentRate, bNeedAck, uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption)); //1: 2.4GHz
 
-			pBuf->wTimeStampOff_a = cpu_to_le16(wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE]);
-			pBuf->wTimeStampOff_b = cpu_to_le16(wTimeStampOff[pDevice->byPreambleType%2][pDevice->byTopCCKBasicRate%MAX_RATE]);
+			pBuf->wTimeStampOff_a = vnt_time_stamp_off(pDevice, wCurrentRate);
+			pBuf->wTimeStampOff_b = vnt_time_stamp_off(pDevice, pDevice->byTopCCKBasicRate);
 
 			return pBuf->wDuration_a;
 		} //if (byFBOption == AUTO_FB_NONE)
@@ -751,7 +757,7 @@ s_uFillDataHead(
 											    wCurrentRate, bNeedAck, uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption)); //0: 5GHz
 			pBuf->wDuration_f1 = cpu_to_le16((unsigned short)s_uGetDataDuration(pDevice, DATADUR_A_F1, cbFrameLength, byPktType,
 											    wCurrentRate, bNeedAck, uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption)); //0: 5GHz
-			pBuf->wTimeStampOff = cpu_to_le16(wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE]);
+			pBuf->wTimeStampOff = vnt_time_stamp_off(pDevice, wCurrentRate);
 			return pBuf->wDuration;
 		} else {
 			PSTxDataHead_ab pBuf = (PSTxDataHead_ab)pTxDataHead;
@@ -765,7 +771,7 @@ s_uFillDataHead(
 											 cbLastFragmentSize, uMACfragNum,
 											 byFBOption));
 
-			pBuf->wTimeStampOff = cpu_to_le16(wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE]);
+			pBuf->wTimeStampOff = vnt_time_stamp_off(pDevice, wCurrentRate);
 			return pBuf->wDuration;
 		}
 	} else {
@@ -778,7 +784,7 @@ s_uFillDataHead(
 										 wCurrentRate, bNeedAck, uFragIdx,
 										 cbLastFragmentSize, uMACfragNum,
 										 byFBOption));
-		pBuf->wTimeStampOff = cpu_to_le16(wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE]);
+		pBuf->wTimeStampOff = vnt_time_stamp_off(pDevice, wCurrentRate);
 		return pBuf->wDuration;
 	}
 	return 0;
@@ -2370,7 +2376,7 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice, PSTxMgmtPacket pPacket)
 			  wCurrentRate, byPktType, &short_head->ab);
 
 	/* Get TimeStampOff */
-	short_head->time_stamp_off = cpu_to_le16(wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE]);
+	short_head->time_stamp_off = vnt_time_stamp_off(pDevice, wCurrentRate);
 	cbHeaderSize = sizeof(struct vnt_tx_short_buf_head);
 
 	//Generate Beacon Header
-- 
1.9.1

