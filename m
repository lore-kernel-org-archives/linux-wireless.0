Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:45969 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761138AbaGYTwf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2014 15:52:35 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so4669142wgg.0
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jul 2014 12:52:33 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/12] staging: vt6656: rename device_free_tx_bufs to vnt_free_tx_bufs
Date: Fri, 25 Jul 2014 20:51:47 +0100
Message-Id: <1406317916-21884-3-git-send-email-tvboxspy@gmail.com> (sfid-20140725_215239_119175_DEF404B1)
In-Reply-To: <1406317916-21884-1-git-send-email-tvboxspy@gmail.com>
References: <1406317916-21884-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

changing device to vnt

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 51fad26..88484c8 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -34,7 +34,7 @@
  *   device_ioctl - ioctl entry
  *   device_close - shutdown mac/bbp & free dma/descriptor resource
  *   device_alloc_frag_buf - rx fragement pre-allocated function
- *   device_free_tx_bufs - free tx buffer function
+ *   vnt_free_tx_bufs - free tx buffer function
  *   device_dma0_tx_80211- tx 802.11 frame via dma0
  *   device_dma0_xmit- tx PS buffered frame via dma0
  *   vnt_init_registers- initial MAC & BBP & RF internal registers.
@@ -378,7 +378,7 @@ static int vnt_init_registers(struct vnt_private *priv)
 	return true;
 }
 
-static void device_free_tx_bufs(struct vnt_private *priv)
+static void vnt_free_tx_bufs(struct vnt_private *priv)
 {
 	struct vnt_usb_send_context *tx_context;
 	int ii;
@@ -521,7 +521,7 @@ free_rx_tx:
 	device_free_rx_bufs(priv);
 
 free_tx:
-	device_free_tx_bufs(priv);
+	vnt_free_tx_bufs(priv);
 
 	return false;
 }
@@ -568,7 +568,7 @@ static int vnt_start(struct ieee80211_hw *hw)
 
 free_all:
 	device_free_rx_bufs(priv);
-	device_free_tx_bufs(priv);
+	vnt_free_tx_bufs(priv);
 	device_free_int_bufs(priv);
 
 	usb_kill_urb(priv->interrupt_urb);
@@ -602,7 +602,7 @@ static void vnt_stop(struct ieee80211_hw *hw)
 
 	priv->cmd_running = false;
 
-	device_free_tx_bufs(priv);
+	vnt_free_tx_bufs(priv);
 	device_free_rx_bufs(priv);
 	device_free_int_bufs(priv);
 
-- 
2.0.1

