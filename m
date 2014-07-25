Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:48582 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761146AbaGYTwg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2014 15:52:36 -0400
Received: by mail-wi0-f179.google.com with SMTP id f8so1550283wiw.12
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jul 2014 12:52:35 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/12] staging: vt6656: rename device_free_rx_bufs to vnt_free_rx_bufs
Date: Fri, 25 Jul 2014 20:51:48 +0100
Message-Id: <1406317916-21884-4-git-send-email-tvboxspy@gmail.com> (sfid-20140725_215240_912742_67102ACA)
In-Reply-To: <1406317916-21884-1-git-send-email-tvboxspy@gmail.com>
References: <1406317916-21884-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

changing vnt to device

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 88484c8..76678c8 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -397,7 +397,7 @@ static void vnt_free_tx_bufs(struct vnt_private *priv)
 	return;
 }
 
-static void device_free_rx_bufs(struct vnt_private *priv)
+static void vnt_free_rx_bufs(struct vnt_private *priv)
 {
 	struct vnt_rcb *rcb;
 	int ii;
@@ -518,7 +518,7 @@ static bool device_alloc_bufs(struct vnt_private *priv)
 	return true;
 
 free_rx_tx:
-	device_free_rx_bufs(priv);
+	vnt_free_rx_bufs(priv);
 
 free_tx:
 	vnt_free_tx_bufs(priv);
@@ -567,7 +567,7 @@ static int vnt_start(struct ieee80211_hw *hw)
 	return 0;
 
 free_all:
-	device_free_rx_bufs(priv);
+	vnt_free_rx_bufs(priv);
 	vnt_free_tx_bufs(priv);
 	device_free_int_bufs(priv);
 
@@ -603,7 +603,7 @@ static void vnt_stop(struct ieee80211_hw *hw)
 	priv->cmd_running = false;
 
 	vnt_free_tx_bufs(priv);
-	device_free_rx_bufs(priv);
+	vnt_free_rx_bufs(priv);
 	device_free_int_bufs(priv);
 
 	usb_kill_urb(priv->interrupt_urb);
-- 
2.0.1

