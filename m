Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37699 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629AbbJUTHo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 15:07:44 -0400
From: Punit Vara <punitvara@gmail.com>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, jslaby@suse.cz, lkp@intel.com,
	Punit Vara <punitvara@gmail.com>
Subject: [PATCH v2 08/15] net: wireless: simplify return flow for usb_control_msg
Date: Thu, 22 Oct 2015 00:37:08 +0530
Message-Id: <1445454428-12331-2-git-send-email-punitvara@gmail.com> (sfid-20151021_210803_057869_DA8CE8F2)
In-Reply-To: <1445454428-12331-1-git-send-email-punitvara@gmail.com>
References: <1445454428-12331-1-git-send-email-punitvara@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove int ret suggested by Jiri Slaby
This patch is to the at76c50x-usb.c file that fixes up warning
reported by coccicheck:

WARNING: end returns can be simplified if negative or 0 value

Prefer direct return value instead of writing 2-3 more sentence.

Signed-off-by: Punit Vara <punitvara@gmail.com>
---
 drivers/net/wireless/at76c50x-usb.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index dab2513..b4aa062 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -543,14 +543,10 @@ static void at76_ledtrig_tx_activity(void)
 
 static int at76_remap(struct usb_device *udev)
 {
-	int ret;
-	ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x0a,
+	return usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x0a,
 			      USB_TYPE_VENDOR | USB_DIR_OUT |
 			      USB_RECIP_INTERFACE, 0, 0, NULL, 0,
 			      USB_CTRL_GET_TIMEOUT);
-	if (ret < 0)
-		return ret;
-	return 0;
 }
 
 static int at76_get_op_mode(struct usb_device *udev)
-- 
2.5.3

