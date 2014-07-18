Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:37835 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759606AbaGRFhU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2014 01:37:20 -0400
Received: by mail-wg0-f45.google.com with SMTP id x12so2885141wgg.28
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 22:37:19 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/9] staging: vt6656: fix module_param_named tx_buffers variable
Date: Fri, 18 Jul 2014 06:36:09 +0100
Message-Id: <1405661776-3345-2-git-send-email-tvboxspy@gmail.com> (sfid-20140718_073726_554410_2A5FE6B5)
In-Reply-To: <1405661776-3345-1-git-send-email-tvboxspy@gmail.com>
References: <1405661776-3345-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Should point to vnt_tx_buffers

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 436523f..06e4861 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -79,7 +79,7 @@ MODULE_PARM_DESC(rx_buffers, "Number of receive usb rx buffers");
 
 #define TX_DESC_DEF0 64
 static int vnt_tx_buffers = TX_DESC_DEF0;
-module_param_named(tx_buffers, vnt_rx_buffers, int, 0644);
+module_param_named(tx_buffers, vnt_tx_buffers, int, 0644);
 MODULE_PARM_DESC(tx_buffers, "Number of receive usb tx buffers");
 
 #define RTS_THRESH_DEF     2347
-- 
2.0.1

