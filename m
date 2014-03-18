Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:55187 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757811AbaCRT0H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 15:26:07 -0400
Received: by mail-wg0-f49.google.com with SMTP id a1so6236517wgh.8
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 12:26:06 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/14] staging: vt6656: rxtx: Replace wRTSDuration* variables
Date: Tue, 18 Mar 2014 19:24:56 +0000
Message-Id: <1395170708-2990-2-git-send-email-tvboxspy@gmail.com> (sfid-20140318_202611_814742_D117941A)
In-Reply-To: <1395170708-2990-1-git-send-email-tvboxspy@gmail.com>
References: <1395170708-2990-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix base type to __le16 and remove camel case.

Camel case changes
wRTSDuration* -> rts_duration*

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 12 ++++++------
 drivers/staging/vt6656/rxtx.h | 12 ++++++------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 5507db8..1a29251 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -613,13 +613,13 @@ static u16 vnt_rxtx_rts_g_fb_head(struct vnt_private *priv,
 		pkt_type, current_rate, need_ack, fb_option);
 
 
-	buf->wRTSDuration_ba_f0 = s_uGetRTSCTSDuration(priv, RTSDUR_BA_F0,
+	buf->rts_duration_ba_f0 = s_uGetRTSCTSDuration(priv, RTSDUR_BA_F0,
 		frame_len, pkt_type, priv->tx_rate_fb0, need_ack, fb_option);
-	buf->wRTSDuration_aa_f0 = s_uGetRTSCTSDuration(priv, RTSDUR_AA_F0,
+	buf->rts_duration_aa_f0 = s_uGetRTSCTSDuration(priv, RTSDUR_AA_F0,
 		frame_len, pkt_type, priv->tx_rate_fb0, need_ack, fb_option);
-	buf->wRTSDuration_ba_f1 = s_uGetRTSCTSDuration(priv, RTSDUR_BA_F1,
+	buf->rts_duration_ba_f1 = s_uGetRTSCTSDuration(priv, RTSDUR_BA_F1,
 		frame_len, pkt_type, priv->tx_rate_fb1, need_ack, fb_option);
-	buf->wRTSDuration_aa_f1 = s_uGetRTSCTSDuration(priv, RTSDUR_AA_F1,
+	buf->rts_duration_aa_f1 = s_uGetRTSCTSDuration(priv, RTSDUR_AA_F1,
 		frame_len, pkt_type, priv->tx_rate_fb1, need_ack, fb_option);
 
 	vnt_fill_ieee80211_rts(priv, &buf->data, eth_hdr, buf->duration_aa);
@@ -660,10 +660,10 @@ static u16 vnt_rxtx_rts_a_fb_head(struct vnt_private *priv,
 	buf->duration = s_uGetRTSCTSDuration(priv, RTSDUR_AA, frame_len,
 		pkt_type, current_rate, need_ack, fb_option);
 
-	buf->wRTSDuration_f0 = s_uGetRTSCTSDuration(priv, RTSDUR_AA_F0,
+	buf->rts_duration_f0 = s_uGetRTSCTSDuration(priv, RTSDUR_AA_F0,
 		frame_len, pkt_type, priv->tx_rate_fb0, need_ack, fb_option);
 
-	buf->wRTSDuration_f1 = s_uGetRTSCTSDuration(priv, RTSDUR_AA_F1,
+	buf->rts_duration_f1 = s_uGetRTSCTSDuration(priv, RTSDUR_AA_F1,
 		frame_len, pkt_type, priv->tx_rate_fb1, need_ack, fb_option);
 
 	vnt_fill_ieee80211_rts(priv, &buf->data, eth_hdr, buf->duration);
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index d677d07..bb2d0ce 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -127,10 +127,10 @@ struct vnt_rts_g_fb {
 	__le16 duration_aa;
 	__le16 duration_bb;
 	u16 wReserved;
-	u16 wRTSDuration_ba_f0;
-	u16 wRTSDuration_aa_f0;
-	u16 wRTSDuration_ba_f1;
-	u16 wRTSDuration_aa_f1;
+	__le16 rts_duration_ba_f0;
+	__le16 rts_duration_aa_f0;
+	__le16 rts_duration_ba_f1;
+	__le16 rts_duration_aa_f1;
 	struct ieee80211_rts data;
 	struct vnt_tx_datahead_g_fb data_head;
 } __packed;
@@ -147,8 +147,8 @@ struct vnt_rts_a_fb {
 	struct vnt_phy_field a;
 	__le16 duration;
 	u16 wReserved;
-	u16 wRTSDuration_f0;
-	u16 wRTSDuration_f1;
+	__le16 rts_duration_f0;
+	__le16 rts_duration_f1;
 	struct ieee80211_rts data;
 	struct vnt_tx_datahead_a_fb data_head;
 } __packed;
-- 
1.9.0

