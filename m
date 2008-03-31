Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4726 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835AbYCaSd0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 14:33:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@gmail.com, Roy Marples <uberlord@gentoo.org>
Subject: [PATCH] [PATCH] prism54: set carrier flags correctly
Date: Mon, 31 Mar 2008 14:28:55 -0400
Message-Id: <1206988135-12309-1-git-send-email-linville@tuxdriver.com> (sfid-20080331_193330_175451_FAB5FBCA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roy Marples <uberlord@gentoo.org>

prism54 should set the carrier flags correctly when it thinks the
link can be used.

Signed-off-by: Roy Marples <uberlord@gentoo.org>
---
I found this in my pile from a long time back.  Anyone have any
comments on it?

 drivers/net/wireless/prism54/isl_ioctl.c  |    5 ++++-
 drivers/net/wireless/prism54/islpci_dev.c |    4 +++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
index 838d510..25d42ac 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -2093,8 +2093,11 @@ link_changed(struct net_device *ndev, u32 bitrate)
 		} else
 			send_simple_event(netdev_priv(ndev),
 					  "Link established");
-	} else
+		netif_carrier_on(ndev);
+	} else {
 		send_simple_event(netdev_priv(ndev), "Link lost");
+		netif_carrier_off(ndev);
+	}
 }
 
 /* Beacon/ProbeResp payload header */
diff --git a/drivers/net/wireless/prism54/islpci_dev.c b/drivers/net/wireless/prism54/islpci_dev.c
index f057fd9..9c8c6f2 100644
--- a/drivers/net/wireless/prism54/islpci_dev.c
+++ b/drivers/net/wireless/prism54/islpci_dev.c
@@ -386,7 +386,9 @@ islpci_open(struct net_device *ndev)
 	}
 
 	netif_start_queue(ndev);
-/*      netif_mark_up( ndev ); */
+
+	/* Turn off carrier unless we know we have associated */
+	netif_carrier_off(ndev);
 
 	return 0;
 }
-- 
1.4.4.2

