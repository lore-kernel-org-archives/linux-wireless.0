Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:51783 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbaEYUi0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 May 2014 16:38:26 -0400
Received: by mail-wi0-f176.google.com with SMTP id n15so3253224wiw.9
        for <linux-wireless@vger.kernel.org>; Sun, 25 May 2014 13:38:25 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 6/8] staging: vt6656: s_uGetRTSCTSRsvTime fix word lenght
Date: Sun, 25 May 2014 21:36:27 +0100
Message-Id: <1401050189-3249-6-git-send-email-tvboxspy@gmail.com> (sfid-20140525_223831_592075_D6C49A83)
In-Reply-To: <1401050189-3249-1-git-send-email-tvboxspy@gmail.com>
References: <1401050189-3249-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct to length

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index ae80e18..742559d 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -117,7 +117,7 @@ static unsigned int s_uGetTxRsvTime(struct vnt_private *pDevice, u8 byPktType,
 	u32 cbFrameLength, u16 wRate, int bNeedAck);
 
 static __le16 s_uGetRTSCTSRsvTime(struct vnt_private *priv,
-	u8 rsv_type, u8 pkt_type, u32 frame_lenght, u16 current_rate);
+	u8 rsv_type, u8 pkt_type, u32 frame_length, u16 current_rate);
 
 static u16 s_vFillCTSHead(struct vnt_private *pDevice,
 	u8 byPktType, union vnt_tx_data_head *head, u32 cbFrameLength,
@@ -366,14 +366,14 @@ static __le16 vnt_rxtx_rsvtime_le16(struct vnt_private *priv, u8 pkt_type,
 
 //byFreqType: 0=>5GHZ 1=>2.4GHZ
 static __le16 s_uGetRTSCTSRsvTime(struct vnt_private *priv,
-	u8 rsv_type, u8 pkt_type, u32 frame_lenght, u16 current_rate)
+	u8 rsv_type, u8 pkt_type, u32 frame_length, u16 current_rate)
 {
 	u32 rrv_time, rts_time, cts_time, ack_time, data_time;
 
 	rrv_time = rts_time = cts_time = ack_time = data_time = 0;
 
 	data_time = BBuGetFrameTime(priv->byPreambleType, pkt_type,
-						frame_lenght, current_rate);
+						frame_length, current_rate);
 
 	if (rsv_type == 0) {
 		rts_time = BBuGetFrameTime(priv->byPreambleType,
-- 
1.9.1

