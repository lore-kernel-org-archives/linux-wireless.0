Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37789 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbaGYTwb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2014 15:52:31 -0400
Received: by mail-wi0-f180.google.com with SMTP id n3so1553035wiv.13
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jul 2014 12:52:30 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 01/12] staging: vt6656: rename device_set_options to vnt_set_options
Date: Fri, 25 Jul 2014 20:51:45 +0100
Message-Id: <1406317916-21884-1-git-send-email-tvboxspy@gmail.com> (sfid-20140725_215236_196529_C055522F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

changing device to vnt

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index fdc5c7b..7e8551f 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -104,7 +104,7 @@ static struct usb_device_id vt6656_table[] = {
 	{}
 };
 
-static void device_set_options(struct vnt_private *priv)
+static void vnt_set_options(struct vnt_private *priv)
 {
 	/* Set number of TX buffers */
 	if (vnt_tx_buffers < CB_MIN_TX_DESC || vnt_tx_buffers > CB_MAX_TX_DESC)
@@ -997,7 +997,7 @@ vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	priv->hw = hw;
 	priv->usb = udev;
 
-	device_set_options(priv);
+	vnt_set_options(priv);
 
 	spin_lock_init(&priv->lock);
 	mutex_init(&priv->usb_lock);
-- 
2.0.1

