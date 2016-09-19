Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36180 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751539AbcISQdU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 12:33:20 -0400
Received: by mail-oi0-f66.google.com with SMTP id i193so3723891oib.3
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2016 09:33:20 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH V2] rtl8xxxu: Stop log spam from each successful interrupt
Date: Mon, 19 Sep 2016 11:33:14 -0500
Message-Id: <1474302794-446-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160919_183323_589189_3D262B0D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As soon as debugging is turned on, the logs are filled with messages
reporting the interrupt status. As this quantity is usually zero, this
output is not needed. In fact, there will be a report if the status is
not zero, thus the debug line in question could probably be deleted.
Rather than taking that action, I have changed it to only be printed
when the newly added RTL8XXXU_DEBUG_INTERRUPT bit is set in the debug
mask.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
V2 - Added new debugging flag as requested by Jes.
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h      | 1 +
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 870c9cd..4508b6d 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -29,6 +29,7 @@
 #define RTL8XXXU_DEBUG_H2C		0x800
 #define RTL8XXXU_DEBUG_ACTION		0x1000
 #define RTL8XXXU_DEBUG_EFUSE		0x2000
+#define RTL8XXXU_DEBUG_INTERRUPT	0x4000
 
 #define RTW_USB_CONTROL_MSG_TIMEOUT	500
 #define RTL8XXXU_MAX_REG_POLL		500
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 9f6dbb4..efba8f1 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5260,7 +5260,8 @@ static void rtl8xxxu_int_complete(struct urb *urb)
 	struct device *dev = &priv->udev->dev;
 	int ret;
 
-	dev_dbg(dev, "%s: status %i\n", __func__, urb->status);
+	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_INTERRUPT)
+		dev_dbg(dev, "%s: status %i\n", __func__, urb->status);
 	if (urb->status == 0) {
 		usb_anchor_urb(urb, &priv->int_anchor);
 		ret = usb_submit_urb(urb, GFP_ATOMIC);
-- 
2.6.6
