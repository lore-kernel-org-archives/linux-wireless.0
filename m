Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:45930 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548Ab1D2R0n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 13:26:43 -0400
Subject: [PATCH] net: fix rtnl even race in register_netdevice()
To: netdev@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 29 Apr 2011 20:26:34 +0300
Message-ID: <20110429172634.27130.25375.stgit@x201> (sfid-20110429_192646_168893_086F114A)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@atheros.com>

There's a race in register_netdevice so that the rtnl event is sent before
the device is actually ready. This was visible with flimflam, chrome os
connection manager:

00:21:35 roska flimflamd[2598]: src/udev.c:add_net_device()
00:21:35 roska flimflamd[2598]: connman_inet_ifname: SIOCGIFNAME(index
   4): No such device
00:21:45 roska flimflamd[2598]: src/rtnl.c:rtnl_message() buf
   0xbfefda3c len 1004
00:21:45 roska flimflamd[2598]: src/rtnl.c:rtnl_message()
   NEWLINK len 1004 type 16 flags 0x0000 seq 0

So the kobject is visible in udev before the device is ready.

(ignore the 10 s delay, I added that to reproduce the issue easily)

The issue is reported here:

https://bugzilla.kernel.org/show_bug.cgi?id=15606

The fix is to call netdev_register_kobject() after the device is added
to the list.

Signed-off-by: Kalle Valo <kalle.valo@atheros.com>
---
 net/core/dev.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 956d3b0..f2afbe6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5425,11 +5425,6 @@ int register_netdevice(struct net_device *dev)
 	if (ret)
 		goto err_uninit;
 
-	ret = netdev_register_kobject(dev);
-	if (ret)
-		goto err_uninit;
-	dev->reg_state = NETREG_REGISTERED;
-
 	netdev_update_features(dev);
 
 	/*
@@ -5443,6 +5438,11 @@ int register_netdevice(struct net_device *dev)
 	dev_hold(dev);
 	list_netdevice(dev);
 
+	ret = netdev_register_kobject(dev);
+	if (ret)
+		goto err_uninit;
+	dev->reg_state = NETREG_REGISTERED;
+
 	/* Notify protocols, that a new device appeared. */
 	ret = call_netdevice_notifiers(NETDEV_REGISTER, dev);
 	ret = notifier_to_errno(ret);

