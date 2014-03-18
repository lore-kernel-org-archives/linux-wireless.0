Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:47100 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757836AbaCRT00 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 15:26:26 -0400
Received: by mail-wg0-f49.google.com with SMTP id a1so6470561wgh.32
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 12:26:25 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/14] staging: vt6656: rxtx endian correct return duration
Date: Tue, 18 Mar 2014 19:25:04 +0000
Message-Id: <1395170708-2990-10-git-send-email-tvboxspy@gmail.com> (sfid-20140318_202634_594984_34CE8A33)
In-Reply-To: <1395170708-2990-1-git-send-email-tvboxspy@gmail.com>
References: <1395170708-2990-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All duration base types are __le16 correct back to cpu

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 4ae8c9c..63bffc2 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -488,7 +488,7 @@ static u16 vnt_rxtx_datahead_g(struct vnt_private *priv, u8 pkt_type, u16 rate,
 	buf->time_stamp_off_b = vnt_time_stamp_off(priv,
 					priv->byTopCCKBasicRate);
 
-	return buf->duration_a;
+	return le16_to_cpu(buf->duration_a);
 }
 
 static u16 vnt_rxtx_datahead_g_fb(struct vnt_private *priv, u8 pkt_type,
@@ -512,7 +512,7 @@ static u16 vnt_rxtx_datahead_g_fb(struct vnt_private *priv, u8 pkt_type,
 	buf->time_stamp_off_b = vnt_time_stamp_off(priv,
 						priv->byTopCCKBasicRate);
 
-	return buf->duration_a;
+	return le16_to_cpu(buf->duration_a);
 }
 
 static u16 vnt_rxtx_datahead_a_fb(struct vnt_private *priv, u8 pkt_type,
@@ -529,7 +529,7 @@ static u16 vnt_rxtx_datahead_a_fb(struct vnt_private *priv, u8 pkt_type,
 
 	buf->time_stamp_off = vnt_time_stamp_off(priv, rate);
 
-	return buf->duration;
+	return le16_to_cpu(buf->duration);
 }
 
 static u16 vnt_rxtx_datahead_ab(struct vnt_private *priv, u8 pkt_type,
@@ -543,7 +543,7 @@ static u16 vnt_rxtx_datahead_ab(struct vnt_private *priv, u8 pkt_type,
 
 	buf->time_stamp_off = vnt_time_stamp_off(priv, rate);
 
-	return buf->duration;
+	return le16_to_cpu(buf->duration);
 }
 
 static int vnt_fill_ieee80211_rts(struct vnt_private *priv,
-- 
1.9.0

