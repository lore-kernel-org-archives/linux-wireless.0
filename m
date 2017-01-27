Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38196 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754297AbdA0Iei (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 03:34:38 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, sgruszka@redhat.com, vishalthanki@gmail.com
Subject: [PATCH] rt2x00: avoid introducing a USB dependency in the rt2x00lib module
Date: Fri, 27 Jan 2017 09:34:26 +0100
Message-Id: <20170127083426.22655-1-nbd@nbd.name> (sfid-20170127_093629_879152_5F0C16B3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Though protected by an ifdef, introducing an usb symbol dependency in
the rt2x00lib module is a major inconvenience for distributions that
package kernel modules split into individual packages.

Get rid of this unnecessary dependency by calling the usb related
function from a more suitable place

Fixes: 8b4c0009313f ("rt2x00usb: Use usb anchor to manage URB")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c | 3 ---
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c | 2 ++
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index 8fcbc8dc94c1..75f838405344 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -1436,14 +1436,11 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	cancel_work_sync(&rt2x00dev->intf_work);
 	cancel_delayed_work_sync(&rt2x00dev->autowakeup_work);
 	cancel_work_sync(&rt2x00dev->sleep_work);
-#if IS_ENABLED(CONFIG_RT2X00_LIB_USB)
 	if (rt2x00_is_usb(rt2x00dev)) {
-		usb_kill_anchored_urbs(rt2x00dev->anchor);
 		hrtimer_cancel(&rt2x00dev->txstatus_timer);
 		cancel_work_sync(&rt2x00dev->rxdone_work);
 		cancel_work_sync(&rt2x00dev->txdone_work);
 	}
-#endif
 	if (rt2x00dev->workqueue)
 		destroy_workqueue(rt2x00dev->workqueue);
 
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
index 838ca58d2dd6..be5beaacf4f0 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -858,11 +858,13 @@ void rt2x00usb_disconnect(struct usb_interface *usb_intf)
 {
 	struct ieee80211_hw *hw = usb_get_intfdata(usb_intf);
 	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct usb_anchor *anchor = rt2x00dev->anchor;
 
 	/*
 	 * Free all allocated data.
 	 */
 	rt2x00lib_remove_dev(rt2x00dev);
+	usb_kill_anchored_urbs(anchor);
 	rt2x00usb_free_reg(rt2x00dev);
 	ieee80211_free_hw(hw);
 
-- 
2.11.0
