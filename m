Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:36283 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbXIAEgK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:36:10 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id 7F719618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:36:09 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 20/35] Protect at76_iw_handler_set_scan() with mutex
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:36:09 -0400
Message-ID: <20070901043608.2498.9450.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This prevents a race condition when a response from an AP comes before
we set state to MAC_SCANNING, but after at76_quiesce().

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 4a86b48..8b9f75a 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -2305,13 +2305,20 @@ static int at76_iw_handler_set_scan(struct net_device *netdev,
 
 	at76_dbg(DBG_IOCTL, "%s: SIOCSIWSCAN", netdev->name);
 
-	if (!netif_running(netdev))
-		return -ENETDOWN;
+	if (mutex_lock_interruptible(&priv->mtx))
+		return -EINTR;
+
+	if (!netif_running(netdev)) {
+		ret = -ENETDOWN;
+		goto exit;
+	}
 
 	/* jal: we don't allow "iwlist ethX scan" while we are
 	   in monitor mode */
-	if (priv->iw_mode == IW_MODE_MONITOR)
-		return -EBUSY;
+	if (priv->iw_mode == IW_MODE_MONITOR) {
+		ret = -EBUSY;
+		goto exit;
+	}
 
 	/* Discard old scan results */
 	if ((jiffies - priv->last_scan) > (20 * HZ))
@@ -2319,8 +2326,10 @@ static int at76_iw_handler_set_scan(struct net_device *netdev,
 	priv->last_scan = jiffies;
 
 	/* Initiate a scan command */
-	if (priv->scan_state == SCAN_IN_PROGRESS)
-		return -EBUSY;
+	if (priv->scan_state == SCAN_IN_PROGRESS) {
+		ret = -EBUSY;
+		goto exit;
+	}
 
 	priv->scan_state = SCAN_IN_PROGRESS;
 
@@ -2348,6 +2357,8 @@ static int at76_iw_handler_set_scan(struct net_device *netdev,
 	at76_set_mac_state(priv, MAC_SCANNING);
 	schedule_work(&priv->work_start_scan);
 
+exit:
+	mutex_unlock(&priv->mtx);
 	return ret;
 }
 
