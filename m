Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33695 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaGKAJb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 20:09:31 -0400
Received: by mail-wi0-f170.google.com with SMTP id cc10so706wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 17:09:30 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/13] staging: vt6656: rename s_vGetFreeContext to vnt_get_free_context
Date: Fri, 11 Jul 2014 01:08:28 +0100
Message-Id: <1405037311-3666-10-git-send-email-tvboxspy@gmail.com> (sfid-20140711_020936_331449_DFBEC5F5)
In-Reply-To: <1405037311-3666-1-git-send-email-tvboxspy@gmail.com>
References: <1405037311-3666-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 582bc1f..bd96627 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -82,7 +82,7 @@ static const u16 vnt_fb_opt1[2][5] = {
 #define DATADUR_A_F0    12
 #define DATADUR_A_F1    13
 
-static struct vnt_usb_send_context *s_vGetFreeContext(struct vnt_private *);
+static struct vnt_usb_send_context *vnt_get_free_context(struct vnt_private *);
 
 static unsigned int vnt_get_rsvtime(struct vnt_private *pDevice, u8 byPktType,
 	u32 cbFrameLength, u16 wRate, int bNeedAck);
@@ -98,7 +98,7 @@ static __le16 vnt_get_rtscts_duration_le(struct vnt_private *priv,
 	int need_ack);
 
 static struct vnt_usb_send_context
-	*s_vGetFreeContext(struct vnt_private *priv)
+	*vnt_get_free_context(struct vnt_private *priv)
 {
 	struct vnt_usb_send_context *context = NULL;
 	int ii;
@@ -831,7 +831,7 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	tx_context = s_vGetFreeContext(priv);
+	tx_context = vnt_get_free_context(priv);
 	if (!tx_context) {
 		dev_dbg(&priv->usb->dev, "%s No free context\n", __func__);
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -1006,7 +1006,7 @@ static int vnt_beacon_xmit(struct vnt_private *priv,
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	context = s_vGetFreeContext(priv);
+	context = vnt_get_free_context(priv);
 	if (!context) {
 		dev_dbg(&priv->usb->dev, "%s No free context!\n", __func__);
 		spin_unlock_irqrestore(&priv->lock, flags);
-- 
1.9.1

