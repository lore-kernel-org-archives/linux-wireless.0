Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35849 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751264AbdECLs6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 May 2017 07:48:58 -0400
Received: by mail-pf0-f194.google.com with SMTP id v14so3979891pfd.3
        for <linux-wireless@vger.kernel.org>; Wed, 03 May 2017 04:48:58 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>
Subject: [PATCH 2/6] mwifiex: usb: urb->context sanity check in complete handler
Date: Wed,  3 May 2017 11:48:39 +0000
Message-Id: <1493812123-12053-2-git-send-email-huxinming820@gmail.com> (sfid-20170503_134902_260178_4AB109C9)
In-Reply-To: <1493812123-12053-1-git-send-email-huxinming820@gmail.com>
References: <1493812123-12053-1-git-send-email-huxinming820@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

urb/context might be freed in cornel case, add sanity check to avoid
use-after-free.

Signed-off-by: Xinming Hu <huxm@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/usb.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 2f7705c..ee5f488 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -169,6 +169,11 @@ static void mwifiex_usb_rx_complete(struct urb *urb)
 	int recv_length = urb->actual_length;
 	int size, status;
 
+	if (!urb || !urb->context) {
+		pr_err("URB or URB context is not valid in USB Rx complete\n");
+		return;
+	}
+
 	if (!adapter || !adapter->card) {
 		pr_err("mwifiex adapter or card structure is not valid\n");
 		return;
@@ -260,6 +265,11 @@ static void mwifiex_usb_tx_complete(struct urb *urb)
 	struct usb_tx_data_port *port;
 	int i;
 
+	if (!urb || !urb->context) {
+		pr_err("URB or URB context is not valid in USB Tx complete\n");
+		return;
+	}
+
 	mwifiex_dbg(adapter, INFO,
 		    "%s: status: %d\n", __func__, urb->status);
 
-- 
1.9.1
