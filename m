Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:34589 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759713AbaGRFhb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2014 01:37:31 -0400
Received: by mail-we0-f178.google.com with SMTP id w61so4094548wes.9
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 22:37:30 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 9/9] staging: vt6656: struct vnt_private rename apTD to tx_context
Date: Fri, 18 Jul 2014 06:36:16 +0100
Message-Id: <1405661776-3345-9-git-send-email-tvboxspy@gmail.com> (sfid-20140718_073738_292707_A1079D7D)
In-Reply-To: <1405661776-3345-1-git-send-email-tvboxspy@gmail.com>
References: <1405661776-3345-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 2 +-
 drivers/staging/vt6656/int.c      | 2 +-
 drivers/staging/vt6656/main_usb.c | 4 ++--
 drivers/staging/vt6656/rxtx.c     | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index a5a6c39..757d500 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -292,7 +292,7 @@ struct vnt_private {
 	u32 cbRD;
 
 	/* Variables to track resources for the BULK Out Pipe */
-	struct vnt_usb_send_context *apTD[CB_MAX_TX_DESC];
+	struct vnt_usb_send_context *tx_context[CB_MAX_TX_DESC];
 	u32 cbTD;
 
 	/* Variables to track resources for the Interrupt In Pipe */
diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index 87ac6a1..e404d9e 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -78,7 +78,7 @@ static int vnt_int_report_rate(struct vnt_private *priv, u8 pkt_no, u8 tsr)
 	if (pkt_no >= priv->cbTD)
 		return -EINVAL;
 
-	context = priv->apTD[pkt_no];
+	context = priv->tx_context[pkt_no];
 
 	if (!context->skb)
 		return -EINVAL;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 5c8ff98..ff4e18d 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -399,7 +399,7 @@ static void device_free_tx_bufs(struct vnt_private *priv)
 	int ii;
 
 	for (ii = 0; ii < priv->cbTD; ii++) {
-		tx_context = priv->apTD[ii];
+		tx_context = priv->tx_context[ii];
 		/* deallocate URBs */
 		if (tx_context->urb) {
 			usb_kill_urb(tx_context->urb);
@@ -471,7 +471,7 @@ static bool device_alloc_bufs(struct vnt_private *priv)
 			goto free_tx;
 		}
 
-		priv->apTD[ii] = tx_context;
+		priv->tx_context[ii] = tx_context;
 		tx_context->priv = priv;
 		tx_context->pkt_no = ii;
 
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 76b7f17..f3bbfba 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -82,10 +82,10 @@ static struct vnt_usb_send_context
 	dev_dbg(&priv->usb->dev, "%s\n", __func__);
 
 	for (ii = 0; ii < priv->cbTD; ii++) {
-		if (!priv->apTD[ii])
+		if (!priv->tx_context[ii])
 			return NULL;
 
-		context = priv->apTD[ii];
+		context = priv->tx_context[ii];
 		if (context->in_use == false) {
 			context->in_use = true;
 			memset(context->data, 0,
-- 
2.0.1

