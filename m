Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50122 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbaGSLa7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2014 07:30:59 -0400
Received: by mail-wi0-f178.google.com with SMTP id hi2so1967960wib.5
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2014 04:30:58 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/16] staging: vt6656: struct vnt_private rename cdTD to num_tx_context
Date: Sat, 19 Jul 2014 12:30:04 +0100
Message-Id: <1405769418-2815-2-git-send-email-tvboxspy@gmail.com> (sfid-20140719_133106_050701_A7318218)
In-Reply-To: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
References: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

number of tx_context

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 2 +-
 drivers/staging/vt6656/int.c      | 2 +-
 drivers/staging/vt6656/main_usb.c | 8 ++++----
 drivers/staging/vt6656/rxtx.c     | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 6b8c97f..416a55d 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -293,7 +293,7 @@ struct vnt_private {
 
 	/* Variables to track resources for the BULK Out Pipe */
 	struct vnt_usb_send_context *tx_context[CB_MAX_TX_DESC];
-	u32 cbTD;
+	u32 num_tx_context;
 
 	/* Variables to track resources for the Interrupt In Pipe */
 	struct vnt_interrupt_buffer int_buf;
diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index e404d9e..1ea2433 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -75,7 +75,7 @@ static int vnt_int_report_rate(struct vnt_private *priv, u8 pkt_no, u8 tsr)
 	u8 tx_retry = (tsr & 0xf0) >> 4;
 	s8 idx;
 
-	if (pkt_no >= priv->cbTD)
+	if (pkt_no >= priv->num_tx_context)
 		return -EINVAL;
 
 	context = priv->tx_context[pkt_no];
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index a612b15..ba2467c 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -108,9 +108,9 @@ static void device_set_options(struct vnt_private *priv)
 {
 	/* Set number of TX buffers */
 	if (vnt_tx_buffers < CB_MIN_TX_DESC || vnt_tx_buffers > CB_MAX_TX_DESC)
-		priv->cbTD = TX_DESC_DEF0;
+		priv->num_tx_context = TX_DESC_DEF0;
 	else
-		priv->cbTD = vnt_tx_buffers;
+		priv->num_tx_context = vnt_tx_buffers;
 
 	/* Set number of RX buffers */
 	if (vnt_rx_buffers < CB_MIN_RX_DESC || vnt_rx_buffers > CB_MAX_RX_DESC)
@@ -388,7 +388,7 @@ static void device_free_tx_bufs(struct vnt_private *priv)
 	struct vnt_usb_send_context *tx_context;
 	int ii;
 
-	for (ii = 0; ii < priv->cbTD; ii++) {
+	for (ii = 0; ii < priv->num_tx_context; ii++) {
 		tx_context = priv->tx_context[ii];
 		/* deallocate URBs */
 		if (tx_context->urb) {
@@ -452,7 +452,7 @@ static bool device_alloc_bufs(struct vnt_private *priv)
 	struct vnt_rcb *rcb;
 	int ii;
 
-	for (ii = 0; ii < priv->cbTD; ii++) {
+	for (ii = 0; ii < priv->num_tx_context; ii++) {
 		tx_context = kmalloc(sizeof(struct vnt_usb_send_context),
 								GFP_KERNEL);
 		if (tx_context == NULL) {
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index f3bbfba..c4b9ca2 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -81,7 +81,7 @@ static struct vnt_usb_send_context
 
 	dev_dbg(&priv->usb->dev, "%s\n", __func__);
 
-	for (ii = 0; ii < priv->cbTD; ii++) {
+	for (ii = 0; ii < priv->num_tx_context; ii++) {
 		if (!priv->tx_context[ii])
 			return NULL;
 
@@ -97,7 +97,7 @@ static struct vnt_usb_send_context
 		}
 	}
 
-	if (ii == priv->cbTD)
+	if (ii == priv->num_tx_context)
 		dev_dbg(&priv->usb->dev, "%s No Free Tx Context\n", __func__);
 
 	return NULL;
-- 
2.0.1

