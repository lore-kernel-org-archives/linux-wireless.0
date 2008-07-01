Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:55917 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116AbYGASny (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 14:43:54 -0400
Received: by py-out-1112.google.com with SMTP id p76so14209pyb.10
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jul 2008 11:43:54 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
Subject: [PATCH] libertas: support USB persistence on suspend/resume (resend)
From: andrey@cozybit.com
Date: Tue, 01 Jul 2008 11:43:53 -0700 (PDT)
Message-ID: <486a7ae9.14be600a.11a8.ffffa94a@mx.google.com> (sfid-20080701_204419_434289_A997CEA1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Handle .reset_resume() so that libertas can survive suspend/resume without 
reloading the firmware.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
---
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 39b8fbb..aa3a4ff 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -962,6 +962,7 @@ static struct usb_driver if_usb_driver = {
 	.id_table = if_usb_table,
 	.suspend = if_usb_suspend,
 	.resume = if_usb_resume,
+	.reset_resume = if_usb_resume,
 };
 
 static int __init if_usb_init_module(void)


