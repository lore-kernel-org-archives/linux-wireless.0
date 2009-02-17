Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f222.google.com ([209.85.217.222]:41132 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbZBQAn6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 19:43:58 -0500
Received: by gxk22 with SMTP id 22so3629961gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 16 Feb 2009 16:43:56 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 16 Feb 2009 19:43:55 -0500
Message-ID: <c4d76b3b0902161643p73101b29hb55a9da696d16da9@mail.gmail.com> (sfid-20090217_014402_763116_51616F18)
Subject: [PATCH] at76c50x-usb: support cfg80211 scanning
From: Jason Andryuk <jandryuk@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the latest mac80211 stack, the driver needs to be updated for
cfg80211 scanning.  I based the changes off of modifications for
at76_usb found here:
http://johannes.sipsolutions.net/patches/old/all/2008-09-19-13:35/020-cfg80211-scan.patch

The trick was that max_signal also needs to be set to avoid a divide
by zero Oops.  I just guessed and used the value 100 for now.

Additionally, I added some ieee80211_{wake,stop}_queues calls that
were contained in the older at76_usb.  There is ambiguity as to
whether at76_join should be called before or after waking the queues.

Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
--

diff --git a/drivers/net/wireless/at76c50x-usb.c
b/drivers/net/wireless/at76c50x-usb.c
index 2f18248..8d508ca 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -1875,8 +1875,10 @@ static void at76_dwork_hw_scan(struct work_struct *work)

     ieee80211_scan_completed(priv->hw, false);

-    if (is_valid_ether_addr(priv->bssid))
+    if (is_valid_ether_addr(priv->bssid)) {
+        ieee80211_wake_queues(priv->hw);
         at76_join(priv);
+    }

     ieee80211_wake_queues(priv->hw);

@@ -1884,14 +1886,16 @@ exit:
     mutex_unlock(&priv->mtx);
 }

-static int at76_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
+static int at76_hw_scan(struct ieee80211_hw *hw,
+            struct cfg80211_scan_request *req)
 {
     struct at76_priv *priv = hw->priv;
     struct at76_req_scan scan;
     int ret;
+    u8 *ssid = NULL;
+    int len = 0;

     at76_dbg(DBG_MAC80211, "%s():", __func__);
-    at76_dbg_dump(DBG_MAC80211, ssid, len, "ssid %zd bytes:", len);

     mutex_lock(&priv->mtx);

@@ -1899,8 +1903,14 @@ static int at76_hw_scan(struct ieee80211_hw
*hw, u8 *ssid, size_t len)

     memset(&scan, 0, sizeof(struct at76_req_scan));
     memset(scan.bssid, 0xFF, ETH_ALEN);
-    scan.scan_type = SCAN_TYPE_ACTIVE;
-    if (priv->essid_size > 0) {
+    if (req->n_ssids) {
+        scan.scan_type = SCAN_TYPE_ACTIVE;
+        ssid = req->ssids[0].ssid;
+        len = req->ssids[0].ssid_len;
+    } else {
+        scan.scan_type = SCAN_TYPE_PASSIVE;
+    }
+    if (len) {
         memcpy(scan.essid, ssid, len);
         scan.essid_size = len;
     }
@@ -1939,10 +1949,13 @@ static int at76_config(struct ieee80211_hw
*hw, u32 changed)

     priv->channel = hw->conf.channel->hw_value;

-    if (is_valid_ether_addr(priv->bssid))
+    if (is_valid_ether_addr(priv->bssid)) {
         at76_join(priv);
-    else
+        ieee80211_wake_queues(priv->hw);
+    } else {
+        ieee80211_stop_queues(priv->hw);
         at76_start_monitor(priv);
+    }

     mutex_unlock(&priv->mtx);

@@ -1962,9 +1975,12 @@ static int at76_config_interface(struct ieee80211_hw *hw,

     memcpy(priv->bssid, conf->bssid, ETH_ALEN);

-    if (is_valid_ether_addr(priv->bssid))
+    if (is_valid_ether_addr(priv->bssid)) {
         /* mac80211 is joining a bss */
+        ieee80211_wake_queues(priv->hw);
         at76_join(priv);
+    } else
+        ieee80211_stop_queues(priv->hw);

     mutex_unlock(&priv->mtx);

@@ -2229,10 +2245,12 @@ static int at76_init_new_device(struct at76_priv *priv,
     priv->scan_mode = SCAN_TYPE_ACTIVE;

     /* mac80211 initialisation */
+    priv->hw->wiphy->max_scan_ssids = 1;
     priv->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
     priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &at76_supported_band;
     priv->hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
               IEEE80211_HW_SIGNAL_UNSPEC;
+    priv->hw->max_signal = 100;

     SET_IEEE80211_DEV(priv->hw, &interface->dev);
     SET_IEEE80211_PERM_ADDR(priv->hw, priv->mac_addr);
