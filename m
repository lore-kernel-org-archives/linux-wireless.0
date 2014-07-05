Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:35573 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964792AbaGESYu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2014 14:24:50 -0400
Received: by mail-we0-f169.google.com with SMTP id t60so2772200wes.14
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jul 2014 11:24:49 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/8] staging: vt6656: turn radio off after mac registered.
Date: Sat,  5 Jul 2014 19:24:20 +0100
Message-Id: <1404584667-3582-1-git-send-email-tvboxspy@gmail.com> (sfid-20140705_202453_526528_8D491177)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Turn the radio off to save power is the device is unused
on system.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 8a4695e..9d0441f 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1074,6 +1074,8 @@ int vnt_init(struct vnt_private *priv)
 
 	priv->mac_hw = true;
 
+	vnt_radio_power_off(priv);
+
 	return 0;
 }
 
-- 
1.9.1

