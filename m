Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51586 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab0GUPPR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 11:15:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] zd1211rw: make CR_INTERRUPT cast explicit
Date: Wed, 21 Jul 2010 11:08:55 -0400
Message-Id: <1279724935-16581-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CHECK   drivers/net/wireless/zd1211rw/zd_usb.c
drivers/net/wireless/zd1211rw/zd_usb.c:376:24: warning: implicit cast from nocast type

The value comparison is intentional, so forcing the cast seems warranted
in order to silence the sparse warning.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 818e148..acbf4d9 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -373,7 +373,7 @@ static inline void handle_regs_int(struct urb *urb)
 	spin_lock(&intr->lock);
 
 	int_num = le16_to_cpu(*(__le16 *)(urb->transfer_buffer+2));
-	if (int_num == CR_INTERRUPT) {
+	if (int_num == (u16 __force) CR_INTERRUPT) {
 		struct zd_mac *mac = zd_hw_mac(zd_usb_to_hw(urb->context));
 		memcpy(&mac->intr_buffer, urb->transfer_buffer,
 				USB_MAX_EP_INT_BUFFER);
-- 
1.7.1.1

