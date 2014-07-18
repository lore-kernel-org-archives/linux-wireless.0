Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:44098 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaGRFha (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2014 01:37:30 -0400
Received: by mail-wi0-f182.google.com with SMTP id d1so226435wiv.3
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 22:37:28 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 8/9] staging: vt6656: struct vnt_private rename apRCB to rcb
Date: Fri, 18 Jul 2014 06:36:15 +0100
Message-Id: <1405661776-3345-8-git-send-email-tvboxspy@gmail.com> (sfid-20140718_073735_628227_B215A806)
In-Reply-To: <1405661776-3345-1-git-send-email-tvboxspy@gmail.com>
References: <1405661776-3345-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 2 +-
 drivers/staging/vt6656/main_usb.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 22554af..a5a6c39 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -288,7 +288,7 @@ struct vnt_private {
 	u32 int_interval;
 
 	/* Variables to track resources for the BULK In Pipe */
-	struct vnt_rcb *apRCB[CB_MAX_RX_DESC];
+	struct vnt_rcb *rcb[CB_MAX_RX_DESC];
 	u32 cbRD;
 
 	/* Variables to track resources for the BULK Out Pipe */
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index fe2f0bc..5c8ff98 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -418,7 +418,7 @@ static void device_free_rx_bufs(struct vnt_private *priv)
 	int ii;
 
 	for (ii = 0; ii < priv->cbRD; ii++) {
-		rcb = priv->apRCB[ii];
+		rcb = priv->rcb[ii];
 		if (!rcb)
 			continue;
 
@@ -486,14 +486,14 @@ static bool device_alloc_bufs(struct vnt_private *priv)
 	}
 
 	for (ii = 0; ii < priv->cbRD; ii++) {
-		priv->apRCB[ii] = kzalloc(sizeof(struct vnt_rcb), GFP_KERNEL);
-		if (!priv->apRCB[ii]) {
+		priv->rcb[ii] = kzalloc(sizeof(struct vnt_rcb), GFP_KERNEL);
+		if (!priv->rcb[ii]) {
 			dev_err(&priv->usb->dev,
 					"failed to allocate rcb no %d\n", ii);
 			goto free_rx_tx;
 		}
 
-		rcb = priv->apRCB[ii];
+		rcb = priv->rcb[ii];
 
 		rcb->priv = priv;
 
-- 
2.0.1

