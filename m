Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:58737 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbbBAMAS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Feb 2015 07:00:18 -0500
Received: by mail-we0-f169.google.com with SMTP id u56so34421385wes.0
        for <linux-wireless@vger.kernel.org>; Sun, 01 Feb 2015 04:00:17 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 6/6] staging: vt6656: parse cts fall back out of vnt_fill_cts_head
Date: Sun,  1 Feb 2015 11:59:43 +0000
Message-Id: <1422791983-3408-6-git-send-email-tvboxspy@gmail.com> (sfid-20150201_130029_213274_3E5385F5)
In-Reply-To: <1422791983-3408-1-git-send-email-tvboxspy@gmail.com>
References: <1422791983-3408-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Creating new function vnt_fill_cts_fb_head for the fall back rates.

The check for fb_option is now done in vnt_rxtx_cts.

This fixes checkpatch warning
WARNING: else is not generally useful after a break or return
	559: FILE: drivers/staging/vt6656/rxtx.c:559:

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 99 +++++++++++++++++++++++--------------------
 1 file changed, 54 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 3b90497..33baf26 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -518,60 +518,66 @@ static u16 vnt_rxtx_rts_a_fb_head(struct vnt_usb_send_context *tx_context,
 	return vnt_rxtx_datahead_a_fb(tx_context, &buf->data_head);
 }
 
-static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
-	union vnt_tx_data_head *head)
+static u16 vnt_fill_cts_fb_head(struct vnt_usb_send_context *tx_context,
+				union vnt_tx_data_head *head)
 {
 	struct vnt_private *priv = tx_context->priv;
+	struct vnt_cts_fb *buf = &head->cts_g_fb;
 	u32 cts_frame_len = 14;
 	u16 current_rate = tx_context->tx_rate;
 
-	if (tx_context->fb_option) {
-		/* Auto Fall back */
-		struct vnt_cts_fb *buf = &head->cts_g_fb;
-		/* Get SignalField,ServiceField,Length */
-		vnt_get_phy_field(priv, cts_frame_len,
-			priv->top_cck_basic_rate, PK_TYPE_11B, &buf->b);
-		buf->duration_ba =
-			vnt_get_rtscts_duration_le(tx_context, CTSDUR_BA,
-						   tx_context->pkt_type,
-						   current_rate);
-		/* Get CTSDuration_ba_f0 */
-		buf->cts_duration_ba_f0 =
-			vnt_get_rtscts_duration_le(tx_context, CTSDUR_BA_F0,
-						   tx_context->pkt_type,
-						   priv->tx_rate_fb0);
-		/* Get CTSDuration_ba_f1 */
-		buf->cts_duration_ba_f1 =
-			vnt_get_rtscts_duration_le(tx_context, CTSDUR_BA_F1,
-						   tx_context->pkt_type,
-						   priv->tx_rate_fb1);
-		/* Get CTS Frame body */
-		buf->data.duration = buf->duration_ba;
-		buf->data.frame_control =
-			cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS);
+	/* Get SignalField,ServiceField,Length */
+	vnt_get_phy_field(priv, cts_frame_len, priv->top_cck_basic_rate,
+			  PK_TYPE_11B, &buf->b);
 
-		ether_addr_copy(buf->data.ra, priv->current_net_addr);
+	buf->duration_ba =
+		vnt_get_rtscts_duration_le(tx_context, CTSDUR_BA,
+					   tx_context->pkt_type,
+					   current_rate);
+	/* Get CTSDuration_ba_f0 */
+	buf->cts_duration_ba_f0 =
+		vnt_get_rtscts_duration_le(tx_context, CTSDUR_BA_F0,
+					   tx_context->pkt_type,
+					   priv->tx_rate_fb0);
+	/* Get CTSDuration_ba_f1 */
+	buf->cts_duration_ba_f1 =
+		vnt_get_rtscts_duration_le(tx_context, CTSDUR_BA_F1,
+					   tx_context->pkt_type,
+					   priv->tx_rate_fb1);
+	/* Get CTS Frame body */
+	buf->data.duration = buf->duration_ba;
+	buf->data.frame_control =
+		cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS);
 
-		return vnt_rxtx_datahead_g_fb(tx_context, &buf->data_head);
-	} else {
-		struct vnt_cts *buf = &head->cts_g;
-		/* Get SignalField,ServiceField,Length */
-		vnt_get_phy_field(priv, cts_frame_len,
-			priv->top_cck_basic_rate, PK_TYPE_11B, &buf->b);
-		/* Get CTSDuration_ba */
-		buf->duration_ba =
-			vnt_get_rtscts_duration_le(tx_context, CTSDUR_BA,
-						   tx_context->pkt_type,
-						   current_rate);
-		/*Get CTS Frame body*/
-		buf->data.duration = buf->duration_ba;
-		buf->data.frame_control =
-			cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS);
+	ether_addr_copy(buf->data.ra, priv->current_net_addr);
 
-		ether_addr_copy(buf->data.ra, priv->current_net_addr);
+	return vnt_rxtx_datahead_g_fb(tx_context, &buf->data_head);
+}
 
-		return vnt_rxtx_datahead_g(tx_context, &buf->data_head);
-	}
+static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
+			     union vnt_tx_data_head *head)
+{
+	struct vnt_private *priv = tx_context->priv;
+	struct vnt_cts *buf = &head->cts_g;
+	u32 cts_frame_len = 14;
+	u16 current_rate = tx_context->tx_rate;
+
+	/* Get SignalField,ServiceField,Length */
+	vnt_get_phy_field(priv, cts_frame_len, priv->top_cck_basic_rate,
+			  PK_TYPE_11B, &buf->b);
+	/* Get CTSDuration_ba */
+	buf->duration_ba =
+		vnt_get_rtscts_duration_le(tx_context, CTSDUR_BA,
+					   tx_context->pkt_type,
+					   current_rate);
+	/*Get CTS Frame body*/
+	buf->data.duration = buf->duration_ba;
+	buf->data.frame_control =
+		cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS);
+
+	ether_addr_copy(buf->data.ra, priv->current_net_addr);
+
+	return vnt_rxtx_datahead_g(tx_context, &buf->data_head);
 }
 
 static u16 vnt_rxtx_rts(struct vnt_usb_send_context *tx_context,
@@ -628,6 +634,9 @@ static u16 vnt_rxtx_cts(struct vnt_usb_send_context *tx_context,
 		head = &tx_head->tx_cts.tx.mic.head;
 
 	/* Fill CTS */
+	if (tx_context->fb_option)
+		return vnt_fill_cts_fb_head(tx_context, head);
+
 	return vnt_fill_cts_head(tx_context, head);
 }
 
-- 
2.1.0

