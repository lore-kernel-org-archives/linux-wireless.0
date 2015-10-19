Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47048 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416AbbJSPaQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 11:30:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
	RUC_Soft_Sec <rucsoftsec@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] orinoco_usb: return error in ezusb_probe when alloc_orinocodev fails
Date: Mon, 19 Oct 2015 11:15:00 -0400
Message-Id: <1445267700-21554-1-git-send-email-linville@tuxdriver.com> (sfid-20151019_173028_118538_1010A100)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current code exits after alloc_orinocodev, but fails to change the
return value to something that indicates the failure.  This patch
changes the return value to -ENOMEM.

https://bugzilla.kernel.org/show_bug.cgi?id=106181

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/orinoco/orinoco_usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
index 26a57d773d30..f2cd513d54b2 100644
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -1576,6 +1576,7 @@ static int ezusb_probe(struct usb_interface *interface,
 				ezusb_hard_reset, NULL);
 	if (!priv) {
 		err("Couldn't allocate orinocodev");
+		retval = -ENOMEM;
 		goto exit;
 	}
 
-- 
2.4.3

