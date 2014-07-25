Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43862 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145AbaGYTwq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2014 15:52:46 -0400
Received: by mail-wi0-f174.google.com with SMTP id d1so1578532wiv.1
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jul 2014 12:52:45 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/12] staging: vt6656: remove return from all void functions
Date: Fri, 25 Jul 2014 20:51:54 +0100
Message-Id: <1406317916-21884-10-git-send-email-tvboxspy@gmail.com> (sfid-20140725_215250_690151_797EC44B)
In-Reply-To: <1406317916-21884-1-git-send-email-tvboxspy@gmail.com>
References: <1406317916-21884-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c    | 4 ----
 drivers/staging/vt6656/mac.c     | 2 --
 drivers/staging/vt6656/usbpipe.c | 6 ------
 drivers/staging/vt6656/wcmd.c    | 2 --
 4 files changed, 14 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index c06dd9d..8c0b8fa 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -669,8 +669,6 @@ void vnt_reset_next_tbtt(struct vnt_private *priv, u16 beacon_interval)
 
 	vnt_control_out(priv, MESSAGE_TYPE_SET_TSFTBTT,
 		MESSAGE_REQUEST_TBTT, 0, 8, data);
-
-	return;
 }
 
 /*
@@ -708,8 +706,6 @@ void vnt_update_next_tbtt(struct vnt_private *priv, u64 tsf,
 			MESSAGE_REQUEST_TBTT, 0, 8, data);
 
 	dev_dbg(&priv->usb->dev, "%s TBTT: %8llx\n", __func__, tsf);
-
-	return;
 }
 
 /*
diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 641d77b..bb37e33 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -243,6 +243,4 @@ void vnt_mac_set_led(struct vnt_private *priv, u8 state, u8 led)
 
 	vnt_control_out(priv, MESSAGE_TYPE_WRITE_MASK, MAC_REG_PAPEDELAY,
 			MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
-
-	return;
 }
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index f1969fe..df31ae6 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -137,8 +137,6 @@ static void vnt_start_interrupt_urb_complete(struct urb *urb)
 	} else {
 		priv->int_buf.in_use = true;
 	}
-
-	return;
 }
 
 int vnt_start_interrupt_urb(struct vnt_private *priv)
@@ -216,8 +214,6 @@ static void vnt_submit_rx_urb_complete(struct urb *urb)
 
 		rcb->in_use = false;
 	}
-
-	return;
 }
 
 int vnt_submit_rx_urb(struct vnt_private *priv, struct vnt_rcb *rcb)
@@ -279,8 +275,6 @@ static void vnt_tx_context_complete(struct urb *urb)
 
 		context->in_use = false;
 	}
-
-	return;
 }
 
 int vnt_tx_context(struct vnt_private *priv,
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 8f6417bc..3cbf479 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -164,8 +164,6 @@ void vnt_run_command(struct work_struct *work)
 	}
 
 	vnt_cmd_complete(priv);
-
-	return;
 }
 
 int vnt_schedule_command(struct vnt_private *priv, enum vnt_cmd command)
-- 
2.0.1

