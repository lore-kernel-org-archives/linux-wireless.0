Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34354 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548Ab0I0Xxu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 19:53:50 -0400
Received: by bwz11 with SMTP id 11so3775565bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 16:53:48 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] carl9170: interrupt urbs must not set URB_ZERO_PACKET
Date: Tue, 28 Sep 2010 01:53:42 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009280153.42416.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a bug in the driver which was
exposed by CONFIG_USB_DEBUG:
	"usb 1-1.6.3: BOGUS urb flags, 40 --> 0"

The transfer flag "URB_ZERO_PACKET" is only valid
for bulk urbs.

Reported-by: André Erdmann
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -606,8 +606,6 @@ int __carl9170_exec_cmd(struct ar9170 *ar, struct carl9170_cmd *cmd,
 		AR9170_USB_EP_CMD), cmd, cmd->hdr.len + 4,
 		carl9170_usb_cmd_complete, ar, 1);
 
-	urb->transfer_flags |= URB_ZERO_PACKET;
-
 	if (free_buf)
 		urb->transfer_flags |= URB_FREE_BUFFER;
 
