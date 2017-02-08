Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48626 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753313AbdBHLro (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 06:47:44 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Vishal Thanki <vishalthanki@gmail.com>
Subject: [PATCH 2/2] rt2x00usb: fix anchor initialization
Date: Wed,  8 Feb 2017 12:18:10 +0100
Message-Id: <1486552690-27597-2-git-send-email-sgruszka@redhat.com> (sfid-20170208_124748_272524_0B4759C4)
In-Reply-To: <1486552690-27597-1-git-send-email-sgruszka@redhat.com>
References: <1486552690-27597-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If device fail to initialize we can OOPS in rt2x00lib_remove_dev(), due
to using uninitialized usb_anchor structure:

[  855.435820] ieee80211 phy3: rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x1000 with error -19
[  855.435826] ieee80211 phy3: rt2800_probe_rt: Error - Invalid RT chipset 0x0000, rev 0000 detected
[  855.435829] ieee80211 phy3: rt2x00lib_probe_dev: Error - Failed to allocate device
[  855.435845] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
[  855.435900] IP: _raw_spin_lock_irq+0xd/0x30
[  855.435926] PGD 0
[  855.435953] Oops: 0002 [#1] SMP
<snip>
[  855.437011] Call Trace:
[  855.437029]  ? usb_kill_anchored_urbs+0x27/0xc0
[  855.437061]  rt2x00lib_remove_dev+0x190/0x1c0 [rt2x00lib]
[  855.437097]  rt2x00lib_probe_dev+0x246/0x7a0 [rt2x00lib]
[  855.437149]  ? ieee80211_roc_setup+0x9e/0xd0 [mac80211]
[  855.437183]  ? __kmalloc+0x1af/0x1f0
[  855.437207]  ? rt2x00usb_probe+0x13d/0xc50 [rt2x00usb]
[  855.437240]  rt2x00usb_probe+0x155/0xc50 [rt2x00usb]
[  855.437273]  rt2800usb_probe+0x15/0x20 [rt2800usb]
[  855.437304]  usb_probe_interface+0x159/0x2d0
[  855.437333]  driver_probe_device+0x2bb/0x460

Patch changes initialization sequence to fix the problem.

Cc: Vishal Thanki <vishalthanki@gmail.com>
Fixes: 8b4c0009313f ("rt2x00usb: Use usb anchor to manage URB")
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
index fe13dd0..c696f0a 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -825,10 +825,6 @@ int rt2x00usb_probe(struct usb_interface *usb_intf,
 	if (retval)
 		goto exit_free_device;
 
-	retval = rt2x00lib_probe_dev(rt2x00dev);
-	if (retval)
-		goto exit_free_reg;
-
 	rt2x00dev->anchor = devm_kmalloc(&usb_dev->dev,
 					sizeof(struct usb_anchor),
 					GFP_KERNEL);
@@ -836,10 +832,17 @@ int rt2x00usb_probe(struct usb_interface *usb_intf,
 		retval = -ENOMEM;
 		goto exit_free_reg;
 	}
-
 	init_usb_anchor(rt2x00dev->anchor);
+
+	retval = rt2x00lib_probe_dev(rt2x00dev);
+	if (retval)
+		goto exit_free_anchor;
+
 	return 0;
 
+exit_free_anchor:
+	usb_kill_anchored_urbs(rt2x00dev->anchor);
+
 exit_free_reg:
 	rt2x00usb_free_reg(rt2x00dev);
 
-- 
1.8.3.1
