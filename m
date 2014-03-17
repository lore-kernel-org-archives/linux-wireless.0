Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:64616 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaCQVQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 17:16:07 -0400
Received: by mail-wi0-f179.google.com with SMTP id f8so2852365wiw.0
        for <linux-wireless@vger.kernel.org>; Mon, 17 Mar 2014 14:16:04 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH] staging: vt6656: [BUG] set usb_fill_int_urb interval to 1
Date: Mon, 17 Mar 2014 21:15:03 +0000
Message-Id: <1395090903-2988-1-git-send-email-tvboxspy@gmail.com> (sfid-20140317_221611_549599_8F83B87D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As result of patch
staging: vt6656: [BUG] Fix Warning BOGUS urb xfer, pipe 3 != type 1

has resulted in sluggish TX performance due to interupt inverval
being too long.

Set int_interval to 1 as set in bInterval of endpoint 1.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 7dd885f..3c93230 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1007,7 +1007,7 @@ static int  device_open(struct net_device *dev)
 
 	schedule_delayed_work(&pDevice->second_callback_work, HZ);
 
-	pDevice->int_interval = 100;  /* max 100 microframes */
+	pDevice->int_interval = 1;  /* bInterval is set to 1 */
     pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 
     pDevice->bIsRxWorkItemQueued = true;
-- 
1.9.0

