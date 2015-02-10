Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:45968 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbbBJQkm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2015 11:40:42 -0500
Received: by pdjz10 with SMTP id z10so1487265pdj.12
        for <linux-wireless@vger.kernel.org>; Tue, 10 Feb 2015 08:40:41 -0800 (PST)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net, ap420073@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Modify some USB de-initialize code.
Date: Wed, 11 Feb 2015 01:40:30 +0900
Message-Id: <1423586430-12454-1-git-send-email-ap420073@gmail.com> (sfid-20150210_174045_636956_C8A64F58)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Delete SET_USB_STOP macro and rtl_usb_deinit because
those are called twice in USB de-initialize routine.
Add some de-initialize workqueue function in USB disconnect routine.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/rtlwifi/usb.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 46ee956..f0188c8 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -701,12 +701,18 @@ free:
 
 static void _rtl_usb_cleanup_rx(struct ieee80211_hw *hw)
 {
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
 	struct urb *urb;
 
 	usb_kill_anchored_urbs(&rtlusb->rx_submitted);
 
 	tasklet_kill(&rtlusb->rx_work_tasklet);
+	cancel_work_sync(&rtlpriv->works.lps_change_work);
+
+	flush_workqueue(rtlpriv->works.rtl_wq);
+	destroy_workqueue(rtlpriv->works.rtl_wq);
+
 	skb_queue_purge(&rtlusb->rx_queue);
 
 	while ((urb = usb_get_from_anchor(&rtlusb->rx_cleanup_urbs))) {
@@ -794,8 +800,6 @@ static void rtl_usb_cleanup(struct ieee80211_hw *hw)
 	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
 	struct ieee80211_tx_info *txinfo;
 
-	SET_USB_STOP(rtlusb);
-
 	/* clean up rx stuff. */
 	_rtl_usb_cleanup_rx(hw);
 
@@ -834,7 +838,6 @@ static void rtl_usb_stop(struct ieee80211_hw *hw)
 	cancel_work_sync(&rtlpriv->works.fill_h2c_cmd);
 	/* Enable software */
 	SET_USB_STOP(rtlusb);
-	rtl_usb_deinit(hw);
 	rtlpriv->cfg->ops->hw_disable(hw);
 }
 
@@ -1147,9 +1150,9 @@ void rtl_usb_disconnect(struct usb_interface *intf)
 
 	if (unlikely(!rtlpriv))
 		return;
-
 	/* just in case driver is removed before firmware callback */
 	wait_for_completion(&rtlpriv->firmware_loading_complete);
+	clear_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status);
 	/*ieee80211_unregister_hw will call ops_stop */
 	if (rtlmac->mac80211_registered == 1) {
 		ieee80211_unregister_hw(hw);
-- 
1.9.1

