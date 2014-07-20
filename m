Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:64014 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbaGTOe4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:34:56 -0400
Received: by mail-we0-f176.google.com with SMTP id q58so6455677wes.21
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 07:34:55 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 20/25] staging: vt6656: vnt_get_duration_le fix typo piv to priv
Date: Sun, 20 Jul 2014 15:33:30 +0100
Message-Id: <1405866815-2687-20-git-send-email-tvboxspy@gmail.com> (sfid-20140720_165108_639047_D4EFD611)
In-Reply-To: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
References: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 0febd03..5d2072f 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -180,20 +180,20 @@ static __le16 vnt_get_rtscts_rsvtime_le(struct vnt_private *priv,
 	return cpu_to_le16((u16)rrv_time);
 }
 
-static __le16 vnt_get_duration_le(struct vnt_private *piv,
+static __le16 vnt_get_duration_le(struct vnt_private *priv,
 					u8 pkt_type, int need_ack)
 {
 	u32 ack_time = 0;
 
 	if (need_ack) {
 		if (pkt_type == PK_TYPE_11B)
-			ack_time = vnt_get_frame_time(piv->preamble_type,
-				pkt_type, 14, piv->top_cck_basic_rate);
+			ack_time = vnt_get_frame_time(priv->preamble_type,
+				pkt_type, 14, priv->top_cck_basic_rate);
 		else
-			ack_time = vnt_get_frame_time(piv->preamble_type,
-				pkt_type, 14, piv->top_ofdm_basic_rate);
+			ack_time = vnt_get_frame_time(priv->preamble_type,
+				pkt_type, 14, priv->top_ofdm_basic_rate);
 
-		return cpu_to_le16((u16)(piv->sifs + ack_time));
+		return cpu_to_le16((u16)(priv->sifs + ack_time));
 	}
 
 	return 0;
-- 
2.0.1

