Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:21316 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbZBEED3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 23:03:29 -0500
Received: by yx-out-2324.google.com with SMTP id 8so15822yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2009 20:03:27 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 4 Feb 2009 23:03:27 -0500
Message-ID: <c4d76b3b0902042003p7e2b28a0pcbf0953282becd27@mail.gmail.com> (sfid-20090205_050333_350005_87A03F98)
Subject: [PATCH] at76_usb: fix Oops on disconnect
From: Jason Andryuk <jandryuk@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

flush_workqueue needs to be called instead of the generic one and the
associated functions need to be modified to prevent re-adding
themselves to the workqueue.

Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
--

diff --git a/drivers/staging/at76_usb/at76_usb.c
b/drivers/staging/at76_usb/at76_usb.c
index 185533e..211a6dd 100644
--- a/drivers/staging/at76_usb/at76_usb.c
+++ b/drivers/staging/at76_usb/at76_usb.c
@@ -1967,6 +1967,9 @@ static void at76_dwork_hw_scan(struct work_struct *work)
 					      dwork_hw_scan.work);
 	int ret;

+	if (priv->device_unplugged)
+		return;
+
 	ret = at76_get_cmd_status(priv->udev, CMD_SCAN);
 	at76_dbg(DBG_MAC80211, "%s: CMD_SCAN status 0x%02x", __func__, ret);

@@ -2000,6 +2003,9 @@ static int at76_hw_scan(struct ieee80211_hw *hw,
u8 *ssid, size_t len)
 	at76_dbg(DBG_MAC80211, "%s():", __func__);
 	at76_dbg_dump(DBG_MAC80211, ssid, len, "ssid %zd bytes:", len);

+	if (priv->device_unplugged)
+		return 0;
+
 	mutex_lock(&priv->mtx);

 	ieee80211_stop_queues(hw);
@@ -2102,6 +2108,12 @@ static void at76_configure_filter(struct
ieee80211_hw *hw,
 	flags = changed_flags & AT76_SUPPORTED_FILTERS;
 	*total_flags = AT76_SUPPORTED_FILTERS;

+	/* We bail out of the function to prevent work from being queued
+	 * in the case when the device is no longer present.  We do so
+	 * after updating total_flags to avoid a WARN_ON in mac80211. */
+	if (priv->device_unplugged)
+		return;
+
 	/* FIXME: access to priv->promisc should be protected with
 	 * priv->mtx, but it's impossible because this function needs to be
 	 * atomic */
@@ -2511,6 +2523,8 @@ static int at76_init_new_device(struct at76_priv *priv,
 	/* mac80211 initialisation */
 	priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &at76_supported_band;

+	priv->device_unplugged = 0;
+
 	if (FIRMWARE_IS_WPA(priv->fw_version) &&
 		(at76_is_503rfmd(priv->board_type) ||
 		 at76_is_505(priv->board_type)))
@@ -2561,13 +2575,11 @@ static void at76_delete_device(struct at76_priv *priv)
 	/* The device is gone, don't bother turning it off */
 	priv->device_unplugged = 1;

-	if (priv->mac80211_registered)
-		ieee80211_unregister_hw(priv->hw);
-
-	/* assuming we used keventd, it must quiesce too */
-	flush_scheduled_work();
+	if (priv->mac80211_registered) {
+		flush_workqueue(priv->hw->workqueue);

-	kfree(priv->bulk_out_buffer);
+		ieee80211_unregister_hw(priv->hw);
+	}

 	if (priv->tx_urb) {
 		usb_kill_urb(priv->tx_urb);
@@ -2580,8 +2592,12 @@ static void at76_delete_device(struct at76_priv *priv)

 	at76_dbg(DBG_PROC_ENTRY, "%s: unlinked urbs", __func__);

-	if (priv->rx_skb)
+	/* move me after urb unlink? */
+	kfree(priv->bulk_out_buffer);
+
+	if (priv->rx_skb) {
 		kfree_skb(priv->rx_skb);
+	}

 	usb_put_dev(priv->udev);
