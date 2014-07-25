Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:53452 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761152AbaGYTwi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2014 15:52:38 -0400
Received: by mail-wi0-f173.google.com with SMTP id f8so1572255wiw.6
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jul 2014 12:52:37 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/12] staging: vt6656: rename device_free_int_bufs to vnt_free_int_bufs
Date: Fri, 25 Jul 2014 20:51:49 +0100
Message-Id: <1406317916-21884-5-git-send-email-tvboxspy@gmail.com> (sfid-20140725_215242_647089_4A7833C7)
In-Reply-To: <1406317916-21884-1-git-send-email-tvboxspy@gmail.com>
References: <1406317916-21884-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

changing device to vnt

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 76678c8..50955d2 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -434,7 +434,7 @@ static void usb_device_reset(struct vnt_private *priv)
 	return ;
 }
 
-static void device_free_int_bufs(struct vnt_private *priv)
+static void vnt_free_int_bufs(struct vnt_private *priv)
 {
 	kfree(priv->int_buf.data_buf);
 
@@ -569,7 +569,7 @@ static int vnt_start(struct ieee80211_hw *hw)
 free_all:
 	vnt_free_rx_bufs(priv);
 	vnt_free_tx_bufs(priv);
-	device_free_int_bufs(priv);
+	vnt_free_int_bufs(priv);
 
 	usb_kill_urb(priv->interrupt_urb);
 	usb_free_urb(priv->interrupt_urb);
@@ -604,7 +604,7 @@ static void vnt_stop(struct ieee80211_hw *hw)
 
 	vnt_free_tx_bufs(priv);
 	vnt_free_rx_bufs(priv);
-	device_free_int_bufs(priv);
+	vnt_free_int_bufs(priv);
 
 	usb_kill_urb(priv->interrupt_urb);
 	usb_free_urb(priv->interrupt_urb);
-- 
2.0.1

