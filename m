Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34319 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966040AbdEWHMo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 May 2017 03:12:44 -0400
Received: by mail-pf0-f196.google.com with SMTP id w69so25538786pfk.1
        for <linux-wireless@vger.kernel.org>; Tue, 23 May 2017 00:12:43 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>
Subject: [PATCH v4 2/5] mwifiex: usb: kill urb before free its memory
Date: Tue, 23 May 2017 07:12:31 +0000
Message-Id: <1495523554-30753-2-git-send-email-huxinming820@gmail.com> (sfid-20170523_091250_414907_E532A6E8)
In-Reply-To: <1495523554-30753-1-git-send-email-huxinming820@gmail.com>
References: <1495523554-30753-1-git-send-email-huxinming820@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

we have observed host system hang when device firmware crash,
stack trace show it was an use-after-free case: previous submitted
urb will be holding in usbcore, and given back to device driver
when device disconnected, while the urb have been freed in usb
device disconnect handler. This patch kill the holding urb before
free its memory.

Signed-off-by: Xinming Hu <huxm@marvell.com>
---
v2: replace unnecessary sanity check with right handle of
    pending urb (Arend)
v4: same as v2,v3
---
 drivers/net/wireless/marvell/mwifiex/usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 2f7705c..5a760ec 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -363,6 +363,7 @@ static void mwifiex_usb_free(struct usb_card_rec *card)
 	for (i = 0; i < MWIFIEX_TX_DATA_PORT; i++) {
 		port = &card->port[i];
 		for (j = 0; j < MWIFIEX_TX_DATA_URB; j++) {
+			usb_kill_urb(port->tx_data_list[j].urb);
 			usb_free_urb(port->tx_data_list[j].urb);
 			port->tx_data_list[j].urb = NULL;
 		}
-- 
1.9.1
