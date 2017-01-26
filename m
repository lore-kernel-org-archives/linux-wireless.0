Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:35511 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751942AbdAZSjZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jan 2017 13:39:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Michael Schenk <michael.schenk@albis-elcon.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH] rtlwifi: rtl_usb: Fix for URB leaking when doing ifconfig up/down
Date: Thu, 26 Jan 2017 11:25:04 -0600
Message-Id: <20170126172504.17492-1-Larry.Finger@lwfinger.net> (sfid-20170126_193929_484085_033DB859)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Schenk <michael.schenk@albis-elcon.com>

In the function rtl_usb_start we pre-allocate a certain number of urbs
for RX path but they will not be freed when calling rtl_usb_stop. This
results in leaking urbs when doing ifconfig up and down. Eventually,
the system has no available urbs.

Signed-off-by: Michael Schenk <michael.schenk@albis-elcon.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---

Kalle,

This fix should be sent upstream whenever possible.

It is an old bug.

Thanks,

Larry
---
 drivers/net/wireless/realtek/rtlwifi/usb.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index 0bca263..4d989b8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -818,12 +818,30 @@ static void rtl_usb_stop(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
+	struct urb *urb;
 
 	/* should after adapter start and interrupt enable. */
 	set_hal_stop(rtlhal);
 	cancel_work_sync(&rtlpriv->works.fill_h2c_cmd);
 	/* Enable software */
 	SET_USB_STOP(rtlusb);
+
+	/* free pre-allocated URBs from rtl_usb_start() */
+	usb_kill_anchored_urbs(&rtlusb->rx_submitted);
+
+	tasklet_kill(&rtlusb->rx_work_tasklet);
+	cancel_work_sync(&rtlpriv->works.lps_change_work);
+
+	flush_workqueue(rtlpriv->works.rtl_wq);
+
+	skb_queue_purge(&rtlusb->rx_queue);
+
+	while ((urb = usb_get_from_anchor(&rtlusb->rx_cleanup_urbs))) {
+		usb_free_coherent(urb->dev, urb->transfer_buffer_length,
+				urb->transfer_buffer, urb->transfer_dma);
+		usb_free_urb(urb);
+	}
+
 	rtlpriv->cfg->ops->hw_disable(hw);
 }
 
-- 
2.10.2
