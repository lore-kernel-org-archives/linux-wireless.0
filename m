Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:63562 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757811AbaCRT0T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 15:26:19 -0400
Received: by mail-wi0-f181.google.com with SMTP id hm4so4187792wib.2
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 12:26:18 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/14] staging: vt6656: rxtx Replace wTimeStampOff* variables
Date: Tue, 18 Mar 2014 19:25:01 +0000
Message-Id: <1395170708-2990-7-git-send-email-tvboxspy@gmail.com> (sfid-20140318_202628_215015_8AAA800D)
In-Reply-To: <1395170708-2990-1-git-send-email-tvboxspy@gmail.com>
References: <1395170708-2990-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix base type to __le16 and remove camel case.

Camel case changes
wTimeStampOff* -> time_stamp_off*

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 14 +++++++-------
 drivers/staging/vt6656/rxtx.h | 12 ++++++------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 69afabc..c0c3f50 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -484,8 +484,8 @@ static u16 vnt_rxtx_datahead_g(struct vnt_private *priv, u8 pkt_type, u16 rate,
 	buf->duration_a = s_uGetDataDuration(priv, pkt_type, need_ack);
 	buf->duration_b = s_uGetDataDuration(priv, PK_TYPE_11B, need_ack);
 
-	buf->wTimeStampOff_a = vnt_time_stamp_off(priv, rate);
-	buf->wTimeStampOff_b = vnt_time_stamp_off(priv,
+	buf->time_stamp_off_a = vnt_time_stamp_off(priv, rate);
+	buf->time_stamp_off_b = vnt_time_stamp_off(priv,
 					priv->byTopCCKBasicRate);
 
 	return buf->duration_a;
@@ -508,8 +508,8 @@ static u16 vnt_rxtx_datahead_g_fb(struct vnt_private *priv, u8 pkt_type,
 	buf->duration_a_f0 = s_uGetDataDuration(priv, pkt_type, need_ack);
 	buf->duration_a_f1 = s_uGetDataDuration(priv, pkt_type, need_ack);
 
-	buf->wTimeStampOff_a = vnt_time_stamp_off(priv, rate);
-	buf->wTimeStampOff_b = vnt_time_stamp_off(priv,
+	buf->time_stamp_off_a = vnt_time_stamp_off(priv, rate);
+	buf->time_stamp_off_b = vnt_time_stamp_off(priv,
 						priv->byTopCCKBasicRate);
 
 	return buf->duration_a;
@@ -527,7 +527,7 @@ static u16 vnt_rxtx_datahead_a_fb(struct vnt_private *priv, u8 pkt_type,
 	buf->duration_f0 = s_uGetDataDuration(priv, pkt_type, need_ack);
 	buf->duration_f1 = s_uGetDataDuration(priv, pkt_type, need_ack);
 
-	buf->wTimeStampOff = vnt_time_stamp_off(priv, rate);
+	buf->time_stamp_off = vnt_time_stamp_off(priv, rate);
 
 	return buf->duration;
 }
@@ -541,14 +541,14 @@ static u16 vnt_rxtx_datahead_ab(struct vnt_private *priv, u8 pkt_type,
 	/* Get Duration and TimeStampOff */
 	buf->duration = s_uGetDataDuration(priv, pkt_type, need_ack);
 
-	buf->wTimeStampOff = vnt_time_stamp_off(priv, rate);
+	buf->time_stamp_off = vnt_time_stamp_off(priv, rate);
 
 	return buf->duration;
 }
 
 static int vnt_fill_ieee80211_rts(struct vnt_private *priv,
 	struct ieee80211_rts *rts, struct ethhdr *eth_hdr,
-		u16 duration)
+		__le16 duration)
 {
 	rts->duration = duration;
 	rts->frame_control = TYPE_CTL_RTS;
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index bbb571a..3978174 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -79,8 +79,8 @@ struct vnt_tx_datahead_g {
 	struct vnt_phy_field a;
 	__le16 duration_b;
 	__le16 duration_a;
-	u16 wTimeStampOff_b;
-	u16 wTimeStampOff_a;
+	__le16 time_stamp_off_b;
+	__le16 time_stamp_off_a;
 } __packed;
 
 struct vnt_tx_datahead_g_fb {
@@ -90,20 +90,20 @@ struct vnt_tx_datahead_g_fb {
 	__le16 duration_a;
 	__le16 duration_a_f0;
 	__le16 duration_a_f1;
-	u16 wTimeStampOff_b;
-	u16 wTimeStampOff_a;
+	__le16 time_stamp_off_b;
+	__le16 time_stamp_off_a;
 } __packed;
 
 struct vnt_tx_datahead_ab {
 	struct vnt_phy_field ab;
 	__le16 duration;
-	u16 wTimeStampOff;
+	__le16 time_stamp_off;
 } __packed;
 
 struct vnt_tx_datahead_a_fb {
 	struct vnt_phy_field a;
 	__le16 duration;
-	u16 wTimeStampOff;
+	__le16 time_stamp_off;
 	__le16 duration_f0;
 	__le16 duration_f1;
 } __packed;
-- 
1.9.0

