Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:65193 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750929Ab0KDWOO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 18:14:14 -0400
From: Daniel Drake <dsd@laptop.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
Cc: dcbw@redhat.com
Cc: dkiran@marvell.com
Cc: hs4233@mail.mn-solutions.de
Subject: [PATCH] libertas: terminate scan when stopping interface
Message-Id: <20101104212153.0F7B59D401B@zog.reactivated.net>
Date: Thu,  4 Nov 2010 21:21:52 +0000 (GMT)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are currently no provisions in place to ensure that the scanning
task has been stopped when the interface is stopped or removed.

This can result in a WARNING at net/wireless/core.c:643 and other badness
when you remove the module while a scan is happening.

Terminate the scanning task during interface stop.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/cfg.c  |    5 +++--
 drivers/net/wireless/libertas/dev.h  |    1 +
 drivers/net/wireless/libertas/main.c |    7 +++++++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 5046a00..373930a 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -700,8 +700,9 @@ static void lbs_scan_worker(struct work_struct *work)
 
 	if (priv->scan_channel < priv->scan_req->n_channels) {
 		cancel_delayed_work(&priv->scan_work);
-		queue_delayed_work(priv->work_thread, &priv->scan_work,
-			msecs_to_jiffies(300));
+		if (!priv->stopping)
+			queue_delayed_work(priv->work_thread, &priv->scan_work,
+				msecs_to_jiffies(300));
 	}
 
 	/* This is the final data we are about to send */
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index f062ed5..cb14c38 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -36,6 +36,7 @@ struct lbs_private {
 	/* CFG80211 */
 	struct wireless_dev *wdev;
 	bool wiphy_registered;
+	bool stopping;
 	struct cfg80211_scan_request *scan_req;
 	u8 assoc_bss[ETH_ALEN];
 	u8 disassoc_reason;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 47ce5a6..46b88b1 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -104,6 +104,7 @@ static int lbs_dev_open(struct net_device *dev)
 	lbs_deb_enter(LBS_DEB_NET);
 
 	spin_lock_irq(&priv->driver_lock);
+	priv->stopping = false;
 
 	if (priv->connect_status == LBS_CONNECTED)
 		netif_carrier_on(dev);
@@ -131,10 +132,16 @@ static int lbs_eth_stop(struct net_device *dev)
 	lbs_deb_enter(LBS_DEB_NET);
 
 	spin_lock_irq(&priv->driver_lock);
+	priv->stopping = true;
 	netif_stop_queue(dev);
 	spin_unlock_irq(&priv->driver_lock);
 
 	schedule_work(&priv->mcast_work);
+	cancel_delayed_work_sync(&priv->scan_work);
+	if (priv->scan_req) {
+		cfg80211_scan_done(priv->scan_req, false);
+		priv->scan_req = NULL;
+	}
 
 	lbs_deb_leave(LBS_DEB_NET);
 	return 0;
-- 
1.7.2.3

