Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:36251 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbXIAEfz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:35:55 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id 77C1E618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:35:52 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 17/35] Start beacon timeout task when connected
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:35:52 -0400
Message-ID: <20070901043551.2498.68351.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Limit beacon timeout task to the managed mode.  Don't warn of the wrong
mode or state, just exit.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 218641e..bda7632 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -1889,6 +1889,7 @@ static void at76_work_assoc_done(struct work_struct *work)
 			at76_dump_mib_mac_mgmt(priv);
 #endif
 		}
+		schedule_delayed_work(&priv->dwork_beacon, BEACON_TIMEOUT);
 	}
 	at76_set_pm_mode(priv);
 
@@ -3796,7 +3797,6 @@ static void at76_work_join(struct work_struct *work)
 		netif_start_queue(priv->netdev);
 		/* just to be sure */
 		cancel_delayed_work(&priv->dwork_get_scan);
-		cancel_delayed_work(&priv->dwork_beacon);
 		cancel_delayed_work(&priv->dwork_auth);
 		cancel_delayed_work(&priv->dwork_assoc);
 	} else {
@@ -3921,23 +3921,18 @@ static void at76_dwork_beacon(struct work_struct *work)
 					      dwork_beacon.work);
 
 	mutex_lock(&priv->mtx);
-	WARN_ON(priv->mac_state != MAC_CONNECTED);
-	if (priv->mac_state != MAC_CONNECTED)
+	if (priv->mac_state != MAC_CONNECTED || priv->iw_mode != IW_MODE_INFRA)
 		goto exit;
 
 	/* We haven't received any beacons from out AP for BEACON_TIMEOUT */
 	printk(KERN_INFO "%s: lost beacon bssid %s\n",
 	       priv->netdev->name, mac2str(priv->curr_bss->bssid));
 
-	/* jal: starting mgmt_timer in ad-hoc mode is questionable,
-	   but I'll leave it here to debug another lockup problem */
-	if (priv->iw_mode != IW_MODE_ADHOC) {
-		netif_carrier_off(priv->netdev);
-		netif_stop_queue(priv->netdev);
-		at76_iwevent_bss_disconnect(priv->netdev);
-		at76_set_mac_state(priv, MAC_SCANNING);
-		schedule_work(&priv->work_start_scan);
-	}
+	netif_carrier_off(priv->netdev);
+	netif_stop_queue(priv->netdev);
+	at76_iwevent_bss_disconnect(priv->netdev);
+	at76_set_mac_state(priv, MAC_SCANNING);
+	schedule_work(&priv->work_start_scan);
 
 exit:
 	mutex_unlock(&priv->mtx);
