Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33484 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752891AbcIQRJZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Sep 2016 13:09:25 -0400
Received: by mail-oi0-f68.google.com with SMTP id w11so9169776oia.0
        for <linux-wireless@vger.kernel.org>; Sat, 17 Sep 2016 10:09:25 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH] rtl8xxxu: Stop log spam from each successful interrupt
Date: Sat, 17 Sep 2016 12:09:15 -0500
Message-Id: <1474132155-9330-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160917_190933_759839_1A44D793)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As soon as debugging is turned on, the logs are filled with messages
reporting the interrupt status. As this quantity is usually zero, this
output is not needed. In fact, there will be a report if the status is
not zero, thus the debug line in question could probably be deleted.
Rather than taking that action, I have changed it to only be printed
when the RTL8XXXU_DEBUG_USB bit is set in the debug mask.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 9f6dbb4..236f33c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5260,7 +5260,8 @@ static void rtl8xxxu_int_complete(struct urb *urb)
 	struct device *dev = &priv->udev->dev;
 	int ret;
 
-	dev_dbg(dev, "%s: status %i\n", __func__, urb->status);
+	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_USB)
+		dev_dbg(dev, "%s: status %i\n", __func__, urb->status);
 	if (urb->status == 0) {
 		usb_anchor_urb(urb, &priv->int_anchor);
 		ret = usb_submit_urb(urb, GFP_ATOMIC);
-- 
2.6.6
