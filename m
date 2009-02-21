Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:47983 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbZBUHxT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 02:53:19 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 1/4] at76c50x-usb: fix oops on disconnect
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Sat, 21 Feb 2009 09:53:14 +0200
Message-ID: <20090221075314.15991.63558.stgit@tikku> (sfid-20090221_085322_324226_E618AC44)
In-Reply-To: <20090221075013.15991.66595.stgit@tikku>
References: <20090221075013.15991.66595.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jason Andryuk <jandryuk@gmail.com>

flush_workqueue needs to be called instead of the generic one and the
associated functions need to be modified to prevent re-adding
themselves to the workqueue.

The rx_tasklet is also killed in the small (?) chance it is scheduled.

Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---

 drivers/net/wireless/at76c50x-usb.c |   27 +++++++++++++++++++--------
 1 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index aa06b90..c79591e 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -1848,6 +1848,9 @@ static void at76_dwork_hw_scan(struct work_struct *work)
 					      dwork_hw_scan.work);
 	int ret;
 
+	if (priv->device_unplugged)
+		return;
+
 	mutex_lock(&priv->mtx);
 
 	ret = at76_get_cmd_status(priv->udev, CMD_SCAN);
@@ -1882,6 +1885,9 @@ static int at76_hw_scan(struct ieee80211_hw *hw,
 
 	at76_dbg(DBG_MAC80211, "%s():", __func__);
 
+	if (priv->device_unplugged)
+		return 0;
+
 	mutex_lock(&priv->mtx);
 
 	ieee80211_stop_queues(hw);
@@ -1985,6 +1991,10 @@ static void at76_configure_filter(struct ieee80211_hw *hw,
 	flags = changed_flags & AT76_SUPPORTED_FILTERS;
 	*total_flags = AT76_SUPPORTED_FILTERS;
 
+	/* Bail out after updating flags to prevent a WARN_ON in mac80211. */
+	if (priv->device_unplugged)
+		return;
+
 	/* FIXME: access to priv->promisc should be protected with
 	 * priv->mtx, but it's impossible because this function needs to be
 	 * atomic */
@@ -2085,8 +2095,7 @@ static struct at76_priv *at76_alloc_new_device(struct usb_device *udev)
 	INIT_WORK(&priv->work_submit_rx, at76_work_submit_rx);
 	INIT_DELAYED_WORK(&priv->dwork_hw_scan, at76_dwork_hw_scan);
 
-	priv->rx_tasklet.func = at76_rx_tasklet;
-	priv->rx_tasklet.data = 0;
+	tasklet_init(&priv->rx_tasklet, at76_rx_tasklet, 0);
 
 	priv->pm_mode = AT76_PM_OFF;
 	priv->pm_period = 0;
@@ -2225,6 +2234,7 @@ static int at76_init_new_device(struct at76_priv *priv,
 	priv->scan_min_time = DEF_SCAN_MIN_TIME;
 	priv->scan_max_time = DEF_SCAN_MAX_TIME;
 	priv->scan_mode = SCAN_TYPE_ACTIVE;
+	priv->device_unplugged = 0;
 
 	/* mac80211 initialisation */
 	priv->hw->wiphy->max_scan_ssids = 1;
@@ -2266,13 +2276,12 @@ static void at76_delete_device(struct at76_priv *priv)
 	/* The device is gone, don't bother turning it off */
 	priv->device_unplugged = 1;
 
-	if (priv->mac80211_registered)
-		ieee80211_unregister_hw(priv->hw);
+	tasklet_kill(&priv->rx_tasklet);
 
-	/* assuming we used keventd, it must quiesce too */
-	flush_scheduled_work();
-
-	kfree(priv->bulk_out_buffer);
+	if (priv->mac80211_registered) {
+		flush_workqueue(priv->hw->workqueue);
+		ieee80211_unregister_hw(priv->hw);
+	}
 
 	if (priv->tx_urb) {
 		usb_kill_urb(priv->tx_urb);
@@ -2285,6 +2294,8 @@ static void at76_delete_device(struct at76_priv *priv)
 
 	at76_dbg(DBG_PROC_ENTRY, "%s: unlinked urbs", __func__);
 
+	kfree(priv->bulk_out_buffer);
+
 	if (priv->rx_skb)
 		kfree_skb(priv->rx_skb);
 

