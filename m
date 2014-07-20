Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:60196 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbaGTOeg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:34:36 -0400
Received: by mail-wi0-f177.google.com with SMTP id ho1so2843440wib.4
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 07:34:35 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/25] staging: vt6656: struct vnt_private remove camel case retry limit
Date: Sun, 20 Jul 2014 15:33:20 +0100
Message-Id: <1405866815-2687-10-git-send-email-tvboxspy@gmail.com> (sfid-20140720_165109_036139_100FB9F6)
In-Reply-To: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
References: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
byShortRetryLimit -> short_retry_limit
byLongRetryLimit -> long_retry_limit

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 4 ++--
 drivers/staging/vt6656/main_usb.c | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 9e095eb..fd230b3 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -353,8 +353,8 @@ struct vnt_private {
 	u16 tx_rate_fb0;
 	u16 tx_rate_fb1;
 
-	u8 byShortRetryLimit;
-	u8 byLongRetryLimit;
+	u8 short_retry_limit;
+	u8 long_retry_limit;
 
 	enum nl80211_iftype op_mode;
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 5939f9a..e8ce52d 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -118,8 +118,8 @@ static void device_set_options(struct vnt_private *priv)
 	else
 		priv->num_rcb = vnt_rx_buffers;
 
-	priv->byShortRetryLimit = SHORT_RETRY_DEF;
-	priv->byLongRetryLimit = LONG_RETRY_DEF;
+	priv->short_retry_limit = SHORT_RETRY_DEF;
+	priv->long_retry_limit = LONG_RETRY_DEF;
 	priv->op_mode = NL80211_IFTYPE_UNSPECIFIED;
 	priv->bb_type = BBP_TYPE_DEF;
 	priv->packet_type = priv->bb_type;
@@ -166,8 +166,8 @@ static int device_init_registers(struct vnt_private *priv)
 	init_cmd->exist_sw_net_addr = priv->exist_sw_net_addr;
 	for (ii = 0; ii < 6; ii++)
 		init_cmd->sw_net_addr[ii] = priv->current_net_addr[ii];
-	init_cmd->short_retry_limit = priv->byShortRetryLimit;
-	init_cmd->long_retry_limit = priv->byLongRetryLimit;
+	init_cmd->short_retry_limit = priv->short_retry_limit;
+	init_cmd->long_retry_limit = priv->long_retry_limit;
 
 	/* issue card_init command to device */
 	status = vnt_control_out(priv,
-- 
2.0.1

