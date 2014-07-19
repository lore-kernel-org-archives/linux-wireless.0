Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:62837 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbaGSLa5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2014 07:30:57 -0400
Received: by mail-wi0-f173.google.com with SMTP id f8so2012909wiw.6
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2014 04:30:56 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 01/16] staging: vt6656: struct vnt_private rename cbRD to num_rcb
Date: Sat, 19 Jul 2014 12:30:03 +0100
Message-Id: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com> (sfid-20140719_133105_424008_4166A81C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Number of rcb

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 2 +-
 drivers/staging/vt6656/main_usb.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index ffcbaca..6b8c97f 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -289,7 +289,7 @@ struct vnt_private {
 
 	/* Variables to track resources for the BULK In Pipe */
 	struct vnt_rcb *rcb[CB_MAX_RX_DESC];
-	u32 cbRD;
+	u32 num_rcb;
 
 	/* Variables to track resources for the BULK Out Pipe */
 	struct vnt_usb_send_context *tx_context[CB_MAX_TX_DESC];
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 0802ecd..a612b15 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -114,9 +114,9 @@ static void device_set_options(struct vnt_private *priv)
 
 	/* Set number of RX buffers */
 	if (vnt_rx_buffers < CB_MIN_RX_DESC || vnt_rx_buffers > CB_MAX_RX_DESC)
-		priv->cbRD = RX_DESC_DEF0;
+		priv->num_rcb = RX_DESC_DEF0;
 	else
-		priv->cbRD = vnt_rx_buffers;
+		priv->num_rcb = vnt_rx_buffers;
 
 	priv->byShortRetryLimit = SHORT_RETRY_DEF;
 	priv->byLongRetryLimit = LONG_RETRY_DEF;
@@ -407,7 +407,7 @@ static void device_free_rx_bufs(struct vnt_private *priv)
 	struct vnt_rcb *rcb;
 	int ii;
 
-	for (ii = 0; ii < priv->cbRD; ii++) {
+	for (ii = 0; ii < priv->num_rcb; ii++) {
 		rcb = priv->rcb[ii];
 		if (!rcb)
 			continue;
@@ -475,7 +475,7 @@ static bool device_alloc_bufs(struct vnt_private *priv)
 		tx_context->in_use = false;
 	}
 
-	for (ii = 0; ii < priv->cbRD; ii++) {
+	for (ii = 0; ii < priv->num_rcb; ii++) {
 		priv->rcb[ii] = kzalloc(sizeof(struct vnt_rcb), GFP_KERNEL);
 		if (!priv->rcb[ii]) {
 			dev_err(&priv->usb->dev,
-- 
2.0.1

