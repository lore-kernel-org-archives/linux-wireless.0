Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51290 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761158AbaGYTwp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2014 15:52:45 -0400
Received: by mail-wi0-f174.google.com with SMTP id d1so1578502wiv.1
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jul 2014 12:52:44 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/12] staging: vt6656: main_usb.c remove return from void functions
Date: Fri, 25 Jul 2014 20:51:53 +0100
Message-Id: <1406317916-21884-9-git-send-email-tvboxspy@gmail.com> (sfid-20140725_215248_982592_88D8A789)
In-Reply-To: <1406317916-21884-1-git-send-email-tvboxspy@gmail.com>
References: <1406317916-21884-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 87e89d7..422fcba 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -381,8 +381,6 @@ static void vnt_free_tx_bufs(struct vnt_private *priv)
 
 		kfree(tx_context);
 	}
-
-	return;
 }
 
 static void vnt_free_rx_bufs(struct vnt_private *priv)
@@ -407,8 +405,6 @@ static void vnt_free_rx_bufs(struct vnt_private *priv)
 
 		kfree(rcb);
 	}
-
-	return;
 }
 
 static void usb_device_reset(struct vnt_private *priv)
@@ -419,14 +415,11 @@ static void usb_device_reset(struct vnt_private *priv)
 	if (status)
 		dev_warn(&priv->usb->dev,
 			 "usb_device_reset fail status=%d\n", status);
-	return ;
 }
 
 static void vnt_free_int_bufs(struct vnt_private *priv)
 {
 	kfree(priv->int_buf.data_buf);
-
-	return;
 }
 
 static bool vnt_alloc_bufs(struct vnt_private *priv)
@@ -596,8 +589,6 @@ static void vnt_stop(struct ieee80211_hw *hw)
 
 	usb_kill_urb(priv->interrupt_urb);
 	usb_free_urb(priv->interrupt_urb);
-
-	return;
 }
 
 static int vnt_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
@@ -663,8 +654,6 @@ static void vnt_remove_interface(struct ieee80211_hw *hw,
 
 	/* LED slow blink */
 	vnt_mac_set_led(priv, LEDSTS_STS, LEDSTS_SLOW);
-
-	return;
 }
 
 static int vnt_config(struct ieee80211_hw *hw, u32 changed)
@@ -844,8 +833,6 @@ static void vnt_configure(struct ieee80211_hw *hw,
 	vnt_control_out_u8(priv, MESSAGE_REQUEST_MACREG, MAC_REG_RCR, rx_mode);
 
 	dev_dbg(&priv->usb->dev, "rx mode out= %x\n", rx_mode);
-
-	return;
 }
 
 static int vnt_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
-- 
2.0.1

