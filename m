Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:63120 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730AbaFYUPo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:15:44 -0400
Received: by mail-wg0-f46.google.com with SMTP id y10so2623179wgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:15:43 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 17/17] staging: vt6656: mac80211 conversion: rxtx implement power save poll
Date: Wed, 25 Jun 2014 21:14:38 +0100
Message-Id: <1403727278-6666-18-git-send-email-tvboxspy@gmail.com> (sfid-20140625_221614_421956_80F5B4ED)
In-Reply-To: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
References: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 7f7c13a..c3d4778 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -492,6 +492,8 @@ static u16 vnt_rxtx_datahead_g(struct vnt_usb_send_context *tx_context,
 {
 
 	struct vnt_private *priv = tx_context->priv;
+	struct ieee80211_hdr *hdr =
+				(struct ieee80211_hdr *)tx_context->skb->data;
 
 	/* Get SignalField,ServiceField,Length */
 	vnt_get_phy_field(priv, frame_len, rate, pkt_type, &buf->a);
@@ -499,8 +501,16 @@ static u16 vnt_rxtx_datahead_g(struct vnt_usb_send_context *tx_context,
 							PK_TYPE_11B, &buf->b);
 
 	/* Get Duration and TimeStamp */
-	buf->duration_a = s_uGetDataDuration(priv, pkt_type, need_ack);
-	buf->duration_b = s_uGetDataDuration(priv, PK_TYPE_11B, need_ack);
+	if (ieee80211_is_pspoll(hdr->frame_control)) {
+		__le16 dur = cpu_to_le16(priv->current_aid | BIT(14) | BIT(15));
+
+		buf->duration_a = dur;
+		buf->duration_b = dur;
+	} else {
+		buf->duration_a = s_uGetDataDuration(priv, pkt_type, need_ack);
+		buf->duration_b = s_uGetDataDuration(priv,
+							PK_TYPE_11B, need_ack);
+	}
 
 	buf->time_stamp_off_a = vnt_time_stamp_off(priv, rate);
 	buf->time_stamp_off_b = vnt_time_stamp_off(priv,
@@ -565,11 +575,20 @@ static u16 vnt_rxtx_datahead_ab(struct vnt_usb_send_context *tx_context,
 		u32 frame_len, int need_ack)
 {
 	struct vnt_private *priv = tx_context->priv;
+	struct ieee80211_hdr *hdr =
+				(struct ieee80211_hdr *)tx_context->skb->data;
 
 	/* Get SignalField,ServiceField,Length */
 	vnt_get_phy_field(priv, frame_len, rate, pkt_type, &buf->ab);
+
 	/* Get Duration and TimeStampOff */
-	buf->duration = s_uGetDataDuration(priv, pkt_type, need_ack);
+	if (ieee80211_is_pspoll(hdr->frame_control)) {
+		__le16 dur = cpu_to_le16(priv->current_aid | BIT(14) | BIT(15));
+
+		buf->duration = dur;
+	} else {
+		buf->duration = s_uGetDataDuration(priv, pkt_type, need_ack);
+	}
 
 	buf->time_stamp_off = vnt_time_stamp_off(priv, rate);
 
-- 
1.9.1

