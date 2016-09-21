Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53592 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755381AbcIUBTb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 21:19:31 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 4/4] rtl8xxxu: Stop log spam from each successful interrupt
Date: Tue, 20 Sep 2016 21:19:29 -0400
Message-Id: <1474420769-20086-5-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160921_031934_924550_0444A2F3)
In-Reply-To: <1474420769-20086-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1474420769-20086-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Larry Finger <Larry.Finger@lwfinger.net>

As soon as debugging is turned on, the logs are filled with messages
reporting the interrupt status. As this quantity is usually zero, this
output is not needed. In fact, there will be a report if the status is
not zero, thus the debug line in question could probably be deleted.
Rather than taking that action, I have changed it to only be printed
when the newly added RTL8XXXU_DEBUG_INTERRUPT bit is set in the debug
mask.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h      | 1 +
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index a10a57c..10166289 100644
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
index 71145eb..b2d7f6e 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5375,7 +5375,8 @@ static void rtl8xxxu_int_complete(struct urb *urb)
 	struct device *dev = &priv->udev->dev;
 	int ret;
 
-	dev_dbg(dev, "%s: status %i\n", __func__, urb->status);
+	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_INTERRUPT)
+		dev_dbg(dev, "%s: status %i\n", __func__, urb->status);
 	if (urb->status == 0) {
 		usb_anchor_urb(urb, &priv->int_anchor);
 		ret = usb_submit_urb(urb, GFP_ATOMIC);
-- 
2.7.4
