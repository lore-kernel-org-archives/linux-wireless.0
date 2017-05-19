Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36732 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755848AbdESJHF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 05:07:05 -0400
Received: by mail-pg0-f68.google.com with SMTP id h64so9105555pge.3
        for <linux-wireless@vger.kernel.org>; Fri, 19 May 2017 02:07:00 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>
Subject: [PATCH v3 2/6] mwifiex: usb: kill urb before free its memory
Date: Fri, 19 May 2017 09:06:41 +0000
Message-Id: <1495184805-6631-2-git-send-email-huxinming820@gmail.com> (sfid-20170519_110715_906074_6F3B513B)
In-Reply-To: <1495184805-6631-1-git-send-email-huxinming820@gmail.com>
References: <1495184805-6631-1-git-send-email-huxinming820@gmail.com>
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
v3: same as v2
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
