Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:54607 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115AbaGVVug (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 17:50:36 -0400
Received: by mail-wi0-f175.google.com with SMTP id ho1so6668446wib.2
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 14:50:35 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 6/7] staging: vt6656: struct vnt_tx_fifo_head fifo_ctl change base type to __le16
Date: Tue, 22 Jul 2014 22:49:48 +0100
Message-Id: <1406065789-3374-6-git-send-email-tvboxspy@gmail.com> (sfid-20140722_235039_711631_E4A01428)
In-Reply-To: <1406065789-3374-1-git-send-email-tvboxspy@gmail.com>
References: <1406065789-3374-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Endian is always little add correction in vnt_tx_packet.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 26 ++++++++++++++------------
 drivers/staging/vt6656/rxtx.h |  2 +-
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 2dc7a17..64ec206 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -830,16 +830,16 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 	if (pkt_type == PK_TYPE_11A)
 		tx_buffer_head->fifo_ctl = 0;
 	else if (pkt_type == PK_TYPE_11B)
-		tx_buffer_head->fifo_ctl = FIFOCTL_11B;
+		tx_buffer_head->fifo_ctl = cpu_to_le16(FIFOCTL_11B);
 	else if (pkt_type == PK_TYPE_11GB)
-		tx_buffer_head->fifo_ctl = FIFOCTL_11GB;
+		tx_buffer_head->fifo_ctl = cpu_to_le16(FIFOCTL_11GB);
 	else if (pkt_type == PK_TYPE_11GA)
-		tx_buffer_head->fifo_ctl = FIFOCTL_11GA;
+		tx_buffer_head->fifo_ctl = cpu_to_le16(FIFOCTL_11GA);
 
 	if (!ieee80211_is_data(hdr->frame_control)) {
-		tx_buffer_head->fifo_ctl |= (FIFOCTL_GENINT |
-			FIFOCTL_ISDMA0);
-		tx_buffer_head->fifo_ctl |= FIFOCTL_TMOEN;
+		tx_buffer_head->fifo_ctl |= cpu_to_le16(FIFOCTL_GENINT |
+							FIFOCTL_ISDMA0);
+		tx_buffer_head->fifo_ctl |= cpu_to_le16(FIFOCTL_TMOEN);
 
 		tx_buffer_head->time_stamp =
 			cpu_to_le16(DEFAULT_MGN_LIFETIME_RES_64us);
@@ -849,12 +849,12 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 	}
 
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
-		tx_buffer_head->fifo_ctl |= FIFOCTL_NEEDACK;
+		tx_buffer_head->fifo_ctl |= cpu_to_le16(FIFOCTL_NEEDACK);
 		tx_context->need_ack = true;
 	}
 
 	if (ieee80211_has_retry(hdr->frame_control))
-		tx_buffer_head->fifo_ctl |= FIFOCTL_LRETRY;
+		tx_buffer_head->fifo_ctl |= cpu_to_le16(FIFOCTL_LRETRY);
 
 	if (tx_rate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
 		priv->preamble_type = PREAMBLE_SHORT;
@@ -863,11 +863,11 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 	if (tx_rate->flags & IEEE80211_TX_RC_USE_RTS_CTS) {
 		need_rts = true;
-		tx_buffer_head->fifo_ctl |= FIFOCTL_RTS;
+		tx_buffer_head->fifo_ctl |= cpu_to_le16(FIFOCTL_RTS);
 	}
 
 	if (ieee80211_has_a4(hdr->frame_control))
-		tx_buffer_head->fifo_ctl |= FIFOCTL_LHEAD;
+		tx_buffer_head->fifo_ctl |= cpu_to_le16(FIFOCTL_LHEAD);
 
 	if (info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER)
 		is_pspoll = true;
@@ -899,7 +899,8 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 	/* legacy rates TODO use ieee80211_tx_rate */
 	if (current_rate >= RATE_18M && ieee80211_is_data(hdr->frame_control)) {
 		if (priv->auto_fb_ctrl == AUTO_FB_0) {
-			tx_buffer_head->fifo_ctl |= FIFOCTL_AUTO_FB_0;
+			tx_buffer_head->fifo_ctl |=
+						cpu_to_le16(FIFOCTL_AUTO_FB_0);
 
 			priv->tx_rate_fb0 =
 				vnt_fb_opt0[FB_RATE0][current_rate - RATE_18M];
@@ -908,7 +909,8 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 			fb_option = AUTO_FB_0;
 		} else if (priv->auto_fb_ctrl == AUTO_FB_1) {
-			tx_buffer_head->fifo_ctl |= FIFOCTL_AUTO_FB_1;
+			tx_buffer_head->fifo_ctl |=
+						cpu_to_le16(FIFOCTL_AUTO_FB_1);
 
 			priv->tx_rate_fb0 =
 				vnt_fb_opt1[FB_RATE0][current_rate - RATE_18M];
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index d5769c1..3f0ff7a 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -222,7 +222,7 @@ union vnt_tx_head {
 
 struct vnt_tx_fifo_head {
 	u8 tx_key[WLAN_KEY_LEN_CCMP];
-	u16 fifo_ctl;
+	__le16 fifo_ctl;
 	__le16 time_stamp;
 	__le16 frag_ctl;
 	__le16 current_rate;
-- 
2.0.1

