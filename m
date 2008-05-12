Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47752 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbYELQe6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 12:34:58 -0400
Message-ID: <48287189.8080706@trash.net> (sfid-20080512_183504_494673_EC8CA609)
Date: Mon, 12 May 2008 18:34:17 +0200
From: Patrick McHardy <kaber@trash.net>
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>,
	Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: prism54: revert "prism54: set carrier flags correctly"
Content-Type: multipart/mixed;
 boundary="------------050104050706020804010904"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050104050706020804010904
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit


--------------050104050706020804010904
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit 47230a6beff4656a55bf23d92daee27f96c5b5a1
Author: Patrick McHardy <kaber@trash.net>
Date:   Mon May 12 18:25:51 2008 +0200

    prism54: revert "prism54: set carrier flags correctly"

    Commit 7b463ced6 (prism54: set carrier flags correctly) causes a
    regression: in AP-mode, the device comes up without a carrier,
    which (in my case) causes IPv6 to not add a link-local address,
    which in turn causes radvd (configured to announce routes on that
    device) to refuse to start, breaking IPv6 for the entire network.
    Additionally it most likely will be unable to pass packets because
    the queue in never started.

    A patch that seems to fix the issue is available, however the
    wireless developers have not merged it upstream for three weeks
    now and not responded to further email, so this patch reverts
    the faulty change.

    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
index 5b375b2..5d7951a 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -2081,7 +2081,6 @@ link_changed(struct net_device *ndev, u32 bitrate)
 	islpci_private *priv = netdev_priv(ndev);
 
 	if (bitrate) {
-		netif_carrier_on(ndev);
 		if (priv->iw_mode == IW_MODE_INFRA) {
 			union iwreq_data uwrq;
 			prism54_get_wap(ndev, NULL, (struct sockaddr *) &uwrq,
@@ -2090,10 +2089,8 @@ link_changed(struct net_device *ndev, u32 bitrate)
 		} else
 			send_simple_event(netdev_priv(ndev),
 					  "Link established");
-	} else {
-		netif_carrier_off(ndev);
+	} else
 		send_simple_event(netdev_priv(ndev), "Link lost");
-	}
 }
 
 /* Beacon/ProbeResp payload header */
diff --git a/drivers/net/wireless/prism54/islpci_dev.c b/drivers/net/wireless/prism54/islpci_dev.c
index 04c2638..eb7c1c6 100644
--- a/drivers/net/wireless/prism54/islpci_dev.c
+++ b/drivers/net/wireless/prism54/islpci_dev.c
@@ -387,9 +387,7 @@ islpci_open(struct net_device *ndev)
 	}
 
 	netif_start_queue(ndev);
-
-	/* Turn off carrier unless we know we have associated */
-	netif_carrier_off(ndev);
+/*      netif_mark_up( ndev ); */
 
 	return 0;
 }

--------------050104050706020804010904--
