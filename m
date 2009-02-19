Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:33455 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbZBSDJc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 22:09:32 -0500
Received: by ewy14 with SMTP id 14so175196ewy.13
        for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2009 19:09:30 -0800 (PST)
Subject: Re: [PATCH] at76c50x-usb: fix Oops on disconnect
From: Jason Andryuk <jandryuk@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <871vtvqxsq.fsf@litku.valot.fi>
References: <c4d76b3b0902161739w2fc3bc6fp31fee6ea082702bf@mail.gmail.com>
	 <871vtvqxsq.fsf@litku.valot.fi>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 22:09:22 -0500
Message-Id: <1235012962.6344.4.camel@rainbow> (sfid-20090219_040938_884698_331F86DB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-02-18 at 22:45 +0200, Kalle Valo wrote:
> Jason Andryuk <jandryuk@gmail.com> writes:
> 
> > flush_workqueue needs to be called instead of the generic one and the
> > associated functions need to be modified to prevent re-adding
> > themselves to the workqueue.
> >
> > The rx_tasklet is also killed in the small (?) chance it is scheduled.
> 
> Unfortunately the patch is corrupted:
> 
> patching file drivers/net/wireless/at76c50x-usb.c
> Hunk #1 FAILED at 1860.
> Hunk #2 FAILED at 1900.
> patch: **** malformed patch at line 80: ieee80211_hw *hw,
> 
> Can you resend it?

I the problem was line wrapping from gmail's web interface.

---

flush_workqueue needs to be called instead of the generic one and the
associated functions need to be modified to prevent re-adding
themselves to the workqueue.

The rx_tasklet is also killed in the small (?) chance it is scheduled.

Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
--

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 8d508ca..7a03251 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -1860,6 +1860,9 @@ static void at76_dwork_hw_scan(struct work_struct *work)
 					      dwork_hw_scan.work);
 	int ret;
 
+	if (priv->device_unplugged)
+		return;
+
 	mutex_lock(&priv->mtx);
 
 	ret = at76_get_cmd_status(priv->udev, CMD_SCAN);
@@ -1897,6 +1900,9 @@ static int at76_hw_scan(struct ieee80211_hw *hw,
 
 	at76_dbg(DBG_MAC80211, "%s():", __func__);
 
+	if (priv->device_unplugged)
+		return 0;
+
 	mutex_lock(&priv->mtx);
 
 	ieee80211_stop_queues(hw);
@@ -2003,6 +2009,10 @@ static void at76_configure_filter(struct ieee80211_hw *hw,
 	flags = changed_flags & AT76_SUPPORTED_FILTERS;
 	*total_flags = AT76_SUPPORTED_FILTERS;
 
+	/* Bail out after updating flags to prevent a WARN_ON in mac80211. */
+      	if (priv->device_unplugged)
+		return;
+
 	/* FIXME: access to priv->promisc should be protected with
 	 * priv->mtx, but it's impossible because this function needs to be
 	 * atomic */
@@ -2103,8 +2113,7 @@ static struct at76_priv *at76_alloc_new_device(struct usb_device *udev)
 	INIT_WORK(&priv->work_submit_rx, at76_work_submit_rx);
 	INIT_DELAYED_WORK(&priv->dwork_hw_scan, at76_dwork_hw_scan);
 
-	priv->rx_tasklet.func = at76_rx_tasklet;
-	priv->rx_tasklet.data = 0;
+	tasklet_init(&priv->rx_tasklet, at76_rx_tasklet, 0);
 
 	priv->pm_mode = AT76_PM_OFF;
 	priv->pm_period = 0;
@@ -2243,6 +2252,7 @@ static int at76_init_new_device(struct at76_priv *priv,
 	priv->scan_min_time = DEF_SCAN_MIN_TIME;
 	priv->scan_max_time = DEF_SCAN_MAX_TIME;
 	priv->scan_mode = SCAN_TYPE_ACTIVE;
+	priv->device_unplugged = 0;
 
 	/* mac80211 initialisation */
 	priv->hw->wiphy->max_scan_ssids = 1;
@@ -2284,13 +2294,12 @@ static void at76_delete_device(struct at76_priv *priv)
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
@@ -2303,6 +2312,8 @@ static void at76_delete_device(struct at76_priv *priv)
 
 	at76_dbg(DBG_PROC_ENTRY, "%s: unlinked urbs", __func__);
 
+	kfree(priv->bulk_out_buffer);
+
 	if (priv->rx_skb)
 		kfree_skb(priv->rx_skb);
 

