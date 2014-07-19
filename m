Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:61112 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759888AbaGSLbJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2014 07:31:09 -0400
Received: by mail-we0-f176.google.com with SMTP id q58so5615862wes.7
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2014 04:31:07 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 08/16] staging: vt6656: remame abyCurrentNetAddr to current_net_addr
Date: Sat, 19 Jul 2014 12:30:10 +0100
Message-Id: <1405769418-2815-8-git-send-email-tvboxspy@gmail.com> (sfid-20140719_133114_636756_C8A863F0)
In-Reply-To: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
References: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing prefix and camel case

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 2 +-
 drivers/staging/vt6656/main_usb.c | 6 +++---
 drivers/staging/vt6656/rxtx.c     | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 183d9c9..9287948 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -306,7 +306,7 @@ struct vnt_private {
 
 	struct vnt_cmd_card_init init_command;
 	struct vnt_rsp_card_init init_response;
-	u8 abyCurrentNetAddr[ETH_ALEN];
+	u8 current_net_addr[ETH_ALEN];
 	u8 abyPermanentNetAddr[ETH_ALEN];
 
 	int bExistSWNetAddr;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index c8b4914..e8e4de5 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -165,7 +165,7 @@ static int device_init_registers(struct vnt_private *priv)
 	init_cmd->init_class = DEVICE_INIT_COLD;
 	init_cmd->exist_sw_net_addr = (u8) priv->bExistSWNetAddr;
 	for (ii = 0; ii < 6; ii++)
-		init_cmd->sw_net_addr[ii] = priv->abyCurrentNetAddr[ii];
+		init_cmd->sw_net_addr[ii] = priv->current_net_addr[ii];
 	init_cmd->short_retry_limit = priv->byShortRetryLimit;
 	init_cmd->long_retry_limit = priv->byLongRetryLimit;
 
@@ -335,12 +335,12 @@ static int device_init_registers(struct vnt_private *priv)
 
 	/* get permanent network address */
 	memcpy(priv->abyPermanentNetAddr, init_rsp->net_addr, 6);
-	memcpy(priv->abyCurrentNetAddr,
+	memcpy(priv->current_net_addr,
 				priv->abyPermanentNetAddr, ETH_ALEN);
 
 	/* if exist SW network address, use it */
 	dev_dbg(&priv->usb->dev, "Network address = %pM\n",
-		priv->abyCurrentNetAddr);
+		priv->current_net_addr);
 
 	/*
 	* set BB and packet type at the same time
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index c4b9ca2..25a87b0 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -517,7 +517,7 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 		buf->data.frame_control =
 			cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS);
 
-		memcpy(buf->data.ra, priv->abyCurrentNetAddr, ETH_ALEN);
+		memcpy(buf->data.ra, priv->current_net_addr, ETH_ALEN);
 
 		return vnt_rxtx_datahead_g_fb(tx_context, pkt_type,
 				current_rate, &buf->data_head, frame_len,
@@ -536,7 +536,7 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 		buf->data.frame_control =
 			cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS);
 
-		memcpy(buf->data.ra, priv->abyCurrentNetAddr, ETH_ALEN);
+		memcpy(buf->data.ra, priv->current_net_addr, ETH_ALEN);
 
 		return vnt_rxtx_datahead_g(tx_context, pkt_type, current_rate,
 				&buf->data_head, frame_len, need_ack);
-- 
2.0.1

