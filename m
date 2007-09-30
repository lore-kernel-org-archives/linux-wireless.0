Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:32690 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbXI3Sj0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 14:39:26 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 07/26] at76_usb: Integrate at76_set_monitor_mode() into  at76_dwork_restart()
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Sep 2007 14:39:23 -0400
Message-ID: <20070930183923.23921.48573.stgit@tt.roinet.com>
In-Reply-To: <20070930183409.23921.97762.stgit@tt.roinet.com>
References: <20070930183409.23921.97762.stgit@tt.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reorder some statements in at76_dwork_restart()

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   24 ++++++------------------
 1 files changed, 6 insertions(+), 18 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 62ddae7..be578a9 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -965,20 +965,6 @@ static int at76_set_autorate_fallback(struct at76_priv *priv, int onoff)
 	return ret;
 }
 
-/* Set network device type for the current mode */
-static void at76_set_monitor_mode(struct at76_priv *priv)
-{
-	if (priv->iw_mode == IW_MODE_MONITOR) {
-		at76_dbg(DBG_MONITOR_MODE, "%s: MONITOR MODE ON",
-			 priv->netdev->name);
-		priv->netdev->type = ARPHRD_IEEE80211_RADIOTAP;
-	} else {
-		at76_dbg(DBG_MONITOR_MODE, "%s: MONITOR MODE OFF",
-			 priv->netdev->name);
-		priv->netdev->type = ARPHRD_ETHER;
-	}
-}
-
 static int at76_add_mac_address(struct at76_priv *priv, void *addr)
 {
 	int ret = 0;
@@ -3976,8 +3962,6 @@ static int at76_startup_device(struct at76_priv *priv)
 	if (ret < 0)
 		return ret;
 
-	at76_set_monitor_mode(priv);
-
 	if (at76_debug & DBG_MIB) {
 		at76_dump_mib_mac(priv);
 		at76_dump_mib_mac_addr(priv);
@@ -3999,15 +3983,19 @@ static void at76_dwork_restart(struct work_struct *work)
 
 	mutex_lock(&priv->mtx);
 
-	at76_startup_device(priv);
 	netif_carrier_off(priv->netdev);	/* stop netdev watchdog */
 	netif_stop_queue(priv->netdev);	/* stop tx data packets */
 
+	at76_startup_device(priv);
+
 	if (priv->iw_mode != IW_MODE_MONITOR) {
+		priv->netdev->type = ARPHRD_ETHER;
 		at76_set_mac_state(priv, MAC_SCANNING);
 		schedule_work(&priv->work_start_scan);
-	} else
+	} else {
+		priv->netdev->type = ARPHRD_IEEE80211_RADIOTAP;
 		at76_start_monitor(priv);
+	}
 
 	mutex_unlock(&priv->mtx);
 }
