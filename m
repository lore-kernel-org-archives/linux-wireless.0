Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:46740 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844AbaCRT0f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 15:26:35 -0400
Received: by mail-wg0-f46.google.com with SMTP id b13so6405251wgh.5
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 12:26:34 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 14/14] staging: vt6656: s_uGetRTSCTSRsvTime fix return.
Date: Tue, 18 Mar 2014 19:25:08 +0000
Message-Id: <1395170708-2990-14-git-send-email-tvboxspy@gmail.com> (sfid-20140318_202649_550546_38E7A23A)
In-Reply-To: <1395170708-2990-1-git-send-email-tvboxspy@gmail.com>
References: <1395170708-2990-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Always returns to __le16 type

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 924d9a2..3840323 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -118,7 +118,7 @@ static void s_vSWencryption(struct vnt_private *pDevice,
 static unsigned int s_uGetTxRsvTime(struct vnt_private *pDevice, u8 byPktType,
 	u32 cbFrameLength, u16 wRate, int bNeedAck);
 
-static u16 s_uGetRTSCTSRsvTime(struct vnt_private *priv,
+static __le16 s_uGetRTSCTSRsvTime(struct vnt_private *priv,
 	u8 rsv_type, u8 pkt_type, u32 frame_lenght, u16 current_rate);
 
 static u16 s_vFillCTSHead(struct vnt_private *pDevice, u32 uDMAIdx,
@@ -367,7 +367,7 @@ static __le16 vnt_rxtx_rsvtime_le16(struct vnt_private *priv, u8 pkt_type,
 }
 
 //byFreqType: 0=>5GHZ 1=>2.4GHZ
-static u16 s_uGetRTSCTSRsvTime(struct vnt_private *priv,
+static __le16 s_uGetRTSCTSRsvTime(struct vnt_private *priv,
 	u8 rsv_type, u8 pkt_type, u32 frame_lenght, u16 current_rate)
 {
 	u32 rrv_time, rts_time, cts_time, ack_time, data_time;
@@ -402,7 +402,7 @@ static u16 s_uGetRTSCTSRsvTime(struct vnt_private *priv,
 
 		rrv_time = cts_time + ack_time + data_time + 2 * priv->uSIFS;
 
-		return rrv_time;
+		return cpu_to_le16((u16)rrv_time);
 	}
 
 	rrv_time = rts_time + cts_time + ack_time + data_time + 3 * priv->uSIFS;
-- 
1.9.0

