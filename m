Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:47101 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaGRFhS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2014 01:37:18 -0400
Received: by mail-we0-f181.google.com with SMTP id k48so2839202wev.26
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 22:37:17 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/9] staging: vt6656: usb_device_reset remove camel case
Date: Fri, 18 Jul 2014 06:36:08 +0100
Message-Id: <1405661776-3345-1-git-send-email-tvboxspy@gmail.com> (sfid-20140718_073723_836318_797B6E59)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Camel case change
pDevice -> priv

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 6a46203..436523f 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -438,13 +438,13 @@ static void device_free_rx_bufs(struct vnt_private *priv)
 	return;
 }
 
-static void usb_device_reset(struct vnt_private *pDevice)
+static void usb_device_reset(struct vnt_private *priv)
 {
 	int status;
 
-	status = usb_reset_device(pDevice->usb);
+	status = usb_reset_device(priv->usb);
 	if (status)
-		dev_warn(&pDevice->usb->dev,
+		dev_warn(&priv->usb->dev,
 			 "usb_device_reset fail status=%d\n", status);
 	return ;
 }
-- 
2.0.1

