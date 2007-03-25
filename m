Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:10501 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753182AbXCYXRt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Mar 2007 19:17:49 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: kune@deine-taler.de
Subject: [PATCH] zd1211rw-mac80211: tweak reset-on-probe behaviour
Message-Id: <20070325231754.5E2267B409F@zog.reactivated.net>
Date: Mon, 26 Mar 2007 00:17:54 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ulrich Kunitz <kune@deine-taler.de>

This is an update to the earlier commit 8b4ebaabf12. The argument
is directly used and an error condition will be handled.

Here are some sentences about the reason for this commit. There
have been a larger number of reports of problems after rebooting
the machine. According to reports the resetting of the stick
during probe makes this problem disappear. Notify that it doesn't
help while reloading the module.

Signed-off-by: Ulrich Kunitz <kune@deine-taler.de>
Signed-off-by: Daniel Drake <dsd@gentoo.org>
---
 drivers/net/wireless/mac80211/zd1211rw/zd_usb.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_usb.c b/drivers/net/wireless/mac80211/zd1211rw/zd_usb.c
index 418a8ad..8867110 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_usb.c
@@ -917,7 +917,12 @@ static int probe(struct usb_interface *intf, const struct usb_device_id *id)
 		goto error;
 	}
 
-	usb_reset_device(interface_to_usbdev(intf));
+	r = usb_reset_device(udev);
+	if (r) {
+		dev_err(&intf->dev,
+			"couldn't reset usb device. Error number %d\n", r);
+		goto error;
+	}
 
 	dev = zd_mac_alloc(intf);
 	if (dev == NULL) {
-- 
1.5.0.5

