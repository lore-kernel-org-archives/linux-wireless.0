Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:46734 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752216AbZLRKfU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2009 05:35:20 -0500
Date: Fri, 18 Dec 2009 11:36:49 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Holger Schurig <holgerschurig@gmail.com>
Subject: [PATCH] libertas: Remove carrier signaling from the scan code
Message-ID: <20091218103649.GA3568@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

    
There is no reason to signal a carrier off when doing a 802.11 scan.

Cc: Dan Williams <dcbw@redhat.com>
Cc: Holger Schurig <holgerschurig@gmail.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/net/wireless/libertas/scan.c |   22 ++++++++--------------
 1 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index c6a6c04..b0b1c78 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -567,11 +567,8 @@ int lbs_scan_networks(struct lbs_private *priv, int full_scan)
 	chan_count = lbs_scan_create_channel_list(priv, chan_list);
 
 	netif_stop_queue(priv->dev);
-	netif_carrier_off(priv->dev);
-	if (priv->mesh_dev) {
+	if (priv->mesh_dev)
 		netif_stop_queue(priv->mesh_dev);
-		netif_carrier_off(priv->mesh_dev);
-	}
 
 	/* Prepare to continue an interrupted scan */
 	lbs_deb_scan("chan_count %d, scan_channel %d\n",
@@ -635,16 +632,13 @@ out2:
 	priv->scan_channel = 0;
 
 out:
-	if (priv->connect_status == LBS_CONNECTED) {
-		netif_carrier_on(priv->dev);
-		if (!priv->tx_pending_len)
-			netif_wake_queue(priv->dev);
-	}
-	if (priv->mesh_dev && (priv->mesh_connect_status == LBS_CONNECTED)) {
-		netif_carrier_on(priv->mesh_dev);
-		if (!priv->tx_pending_len)
-			netif_wake_queue(priv->mesh_dev);
-	}
+	if (priv->connect_status == LBS_CONNECTED && !priv->tx_pending_len)
+		netif_wake_queue(priv->dev);
+
+	if (priv->mesh_dev && (priv->mesh_connect_status == LBS_CONNECTED) &&
+	    !priv->tx_pending_len)
+		netif_wake_queue(priv->mesh_dev);
+
 	kfree(chan_list);
 
 	lbs_deb_leave_args(LBS_DEB_SCAN, "ret %d", ret);
-- 
1.6.3.3

Intel Open Source Technology Centre
http://oss.intel.com/
