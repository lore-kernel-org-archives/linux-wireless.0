Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:43817 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751505AbZG3QvX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 12:51:23 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 05/10] rndis_wlan: set current packet filter to zero on stop
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Date: Thu, 30 Jul 2009 19:41:42 +0300
Message-ID: <20090730164142.28317.41617.stgit@fate.lan>
In-Reply-To: <20090730164120.28317.53313.stgit@fate.lan>
References: <20090730164120.28317.53313.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set current packet filter to zero to block receiving data packets from
device.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index bfb9861..974f724 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2530,7 +2530,8 @@ static int rndis_wlan_reset(struct usbnet *usbdev)
 	if (retval)
 		devwarn(usbdev, "rndis_reset() failed: %d", retval);
 
-	/* rndis_reset cleared multicast list, so restore here. */
+	/* rndis_reset cleared multicast list, so restore here.
+	   (set_multicast_list() also turns on current packet filter) */
 	set_multicast_list(usbdev);
 
 	queue_delayed_work(priv->workqueue, &priv->stats_work,
@@ -2544,6 +2545,7 @@ static int rndis_wlan_stop(struct usbnet *usbdev)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	int retval;
+	__le32 filter;
 
 	devdbg(usbdev, "rndis_wlan_stop");
 
@@ -2560,6 +2562,12 @@ static int rndis_wlan_stop(struct usbnet *usbdev)
 		priv->scan_request = NULL;
 	}
 
+	/* Set current packet filter zero to block receiving data packets from
+	   device. */
+	filter = 0;
+	rndis_set_oid(usbdev, OID_GEN_CURRENT_PACKET_FILTER, &filter,
+								sizeof(filter));
+
 	return retval;
 }
 

