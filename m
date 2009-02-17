Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f222.google.com ([209.85.217.222]:37177 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbZBQBjI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 20:39:08 -0500
Received: by gxk22 with SMTP id 22so3671180gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 16 Feb 2009 17:39:06 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 16 Feb 2009 20:39:06 -0500
Message-ID: <c4d76b3b0902161739w2fc3bc6fp31fee6ea082702bf@mail.gmail.com> (sfid-20090217_023914_147506_A49F2BF9)
Subject: [PATCH] at76c50x-usb: fix Oops on disconnect
From: Jason Andryuk <jandryuk@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

flush_workqueue needs to be called instead of the generic one and the
associated functions need to be modified to prevent re-adding
themselves to the workqueue.

The rx_tasklet is also killed in the small (?) chance it is scheduled.

Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
--

diff --git a/drivers/net/wireless/at76c50x-usb.c
b/drivers/net/wireless/at76c50x-usb.c
index 8d508ca..7a03251 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -1860,6 +1860,9 @@ static void at76_dwork_hw_scan(struct work_struct *work)
                           dwork_hw_scan.work);
     int ret;

+    if (priv->device_unplugged)
+        return;
+
     mutex_lock(&priv->mtx);

     ret = at76_get_cmd_status(priv->udev, CMD_SCAN);
@@ -1897,6 +1900,9 @@ static int at76_hw_scan(struct ieee80211_hw *hw,

     at76_dbg(DBG_MAC80211, "%s():", __func__);

+    if (priv->device_unplugged)
+        return 0;
+
     mutex_lock(&priv->mtx);

     ieee80211_stop_queues(hw);
@@ -2003,6 +2009,10 @@ static void at76_configure_filter(struct
ieee80211_hw *hw,
     flags = changed_flags & AT76_SUPPORTED_FILTERS;
     *total_flags = AT76_SUPPORTED_FILTERS;

+    /* Bail out after updating flags to prevent a WARN_ON in mac80211. */
+          if (priv->device_unplugged)
+        return;
+
     /* FIXME: access to priv->promisc should be protected with
      * priv->mtx, but it's impossible because this function needs to be
      * atomic */
@@ -2103,8 +2113,7 @@ static struct at76_priv
*at76_alloc_new_device(struct usb_device *udev)
     INIT_WORK(&priv->work_submit_rx, at76_work_submit_rx);
     INIT_DELAYED_WORK(&priv->dwork_hw_scan, at76_dwork_hw_scan);

-    priv->rx_tasklet.func = at76_rx_tasklet;
-    priv->rx_tasklet.data = 0;
+    tasklet_init(&priv->rx_tasklet, at76_rx_tasklet, 0);

     priv->pm_mode = AT76_PM_OFF;
     priv->pm_period = 0;
@@ -2243,6 +2252,7 @@ static int at76_init_new_device(struct at76_priv *priv,
     priv->scan_min_time = DEF_SCAN_MIN_TIME;
     priv->scan_max_time = DEF_SCAN_MAX_TIME;
     priv->scan_mode = SCAN_TYPE_ACTIVE;
+    priv->device_unplugged = 0;

     /* mac80211 initialisation */
     priv->hw->wiphy->max_scan_ssids = 1;
@@ -2284,13 +2294,12 @@ static void at76_delete_device(struct at76_priv *priv)
     /* The device is gone, don't bother turning it off */
     priv->device_unplugged = 1;

-    if (priv->mac80211_registered)
-        ieee80211_unregister_hw(priv->hw);
+    tasklet_kill(&priv->rx_tasklet);

-    /* assuming we used keventd, it must quiesce too */
-    flush_scheduled_work();
-
-    kfree(priv->bulk_out_buffer);
+    if (priv->mac80211_registered) {
+        flush_workqueue(priv->hw->workqueue);
+        ieee80211_unregister_hw(priv->hw);
+    }

     if (priv->tx_urb) {
         usb_kill_urb(priv->tx_urb);
@@ -2303,6 +2312,8 @@ static void at76_delete_device(struct at76_priv *priv)

     at76_dbg(DBG_PROC_ENTRY, "%s: unlinked urbs", __func__);

+    kfree(priv->bulk_out_buffer);
+
     if (priv->rx_skb)
         kfree_skb(priv->rx_skb);
