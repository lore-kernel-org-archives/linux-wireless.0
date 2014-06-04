Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:34022 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbaFDVCn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 17:02:43 -0400
Received: by mail-wg0-f49.google.com with SMTP id m15so68305wgh.32
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2014 14:02:42 -0700 (PDT)
MIME-Version: 1.0
Reply-To: andrea.merello@gmail.com
In-Reply-To: <1401825462.4157.42.camel@jlt4.sipsolutions.net>
References: <CAN8YU5Nh-FwrBWuCz-YArmHg9NSLqsS2aan_6edaVDg+i6018g@mail.gmail.com>
 <1400509775.4273.8.camel@jlt4.sipsolutions.net> <1400510950.4273.9.camel@jlt4.sipsolutions.net>
 <CAN8YU5OdpxQ0F7RMEFeQWC6PNzppHu6bDEt7Tv6dKntEUMy-9A@mail.gmail.com>
 <1400515344.4273.19.camel@jlt4.sipsolutions.net> <CAN8YU5P5rFjjF9kjLBi0qXwZ1-Zphfi-fbY048wbO9oBmKoULQ@mail.gmail.com>
 <CAN8YU5OgcuaLv3C=_Lg0E6p1kHqhYZ-PjSgqaTxjJ=EV7VhNaw@mail.gmail.com>
 <1401285737.8146.21.camel@jlt4.sipsolutions.net> <CAN8YU5Mxxqs1H4caXQ_tS0Sq5YKwk9NatgSqWferCqBu_+jnyQ@mail.gmail.com>
 <1401825462.4157.42.camel@jlt4.sipsolutions.net>
From: Andrea Merello <andrea.merello@gmail.com>
Date: Wed, 4 Jun 2014 23:02:19 +0200
Message-ID: <CAN8YU5NVmAMQ06oJ2Urze7=m4XNUox4-QmYbE1ozoRTFOEY0=g@mail.gmail.com> (sfid-20140604_230250_960112_1D47C60C)
Subject: Re: [RFC] mac80211: at76x50x_usb driver broken by commit 3afc216..
 and RX path involved in scan
To: Johannes Berg <johannes@sipsolutions.net>
Cc: emmanuel.grumbach@intel.com,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	joerg.albert@gmx.de, Alex Stewart <alex@foogod.com>,
	n0_5p4m_p13453@hotmail.com, Pavel Roskin <proski@gnu.org>,
	agx@sigxcpu.org, Kalle Valo <kalle.valo@iki.fi>, sesmo@gmx.net,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> Yeah, and it would do much more than what you want. You could use
> cfg80211_find_ie() though to simplify the code.

Excellent! I missed it..

> So the loop can be simplified to
>
>         el = cfg80211_find_ie(WLAN_EID_DS_PARAMS, el, el_len);
>         if (el && el[1] > 0)
>                 channel = el[2];

I guess el_len should be len, but I got it :)

> You might also invoke this only when you know you're scanning, to avoid
> the overhead otherwise, but with this driver it probably doesn't matter
> much.

Probably it doesn't, but you are right that is useless to waste time
parsing those mgmt frames when not scanning.

I modified the function (and I changed also its name) in a way that
when scanning it avoid parsing and it does return priv->channel, and I
made it also inline.

So this is the updated patch.
If you agree, we could push it for merge :)

Thank you
Andrea

 drivers/net/wireless/at76c50x-usb.c | 53 +++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/at76c50x-usb.h |  1 +
 2 files changed, 54 insertions(+)

diff --git a/drivers/net/wireless/at76c50x-usb.c
b/drivers/net/wireless/at76c50x-usb.c
index 10fd12e..6f52633 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -1429,6 +1429,8 @@ static int at76_startup_device(struct at76_priv *priv)
     /* remove BSSID from previous run */
     memset(priv->bssid, 0, ETH_ALEN);

+    priv->scanning = false;
+
     if (at76_set_radio(priv, 1) == 1)
         at76_wait_completion(priv, CMD_RADIO_ON);

@@ -1502,6 +1504,52 @@ static void at76_work_submit_rx(struct work_struct *work)
     mutex_unlock(&priv->mtx);
 }

+/* This is a workaround to make scan working:
+ * currently mac80211 does not process frames with no frequency
+ * information.
+ * However during scan the HW performs a sweep by itself, and we
+ * are unable to know where the radio is actually tuned.
+ * This function tries to do its best to guess this information..
+ * During scan, If the current frame is a beacon or a probe response,
+ * the channel information is extracted from it.
+ * When not scanning, for other frames, or if it happens that for
+ * whatever reason we fail to parse beacons and probe responses, this
+ * function returns the priv->channel information, that should be correct
+ * at least when we are not scanning.
+ */
+static inline int at76_guess_freq(struct at76_priv *priv)
+{
+    size_t el_off;
+    const u8 *el;
+    int channel = priv->channel;
+    int len = priv->rx_skb->len;
+    struct ieee80211_hdr *hdr = (void *)priv->rx_skb->data;
+
+    if (!priv->scanning)
+        goto exit;
+
+    if (len < 24)
+        goto exit;
+
+    if (ieee80211_is_probe_resp(hdr->frame_control)) {
+        el_off = offsetof(struct ieee80211_mgmt, u.probe_resp.variable);
+        el = ((struct ieee80211_mgmt *)hdr)->u.probe_resp.variable;
+    } else if (ieee80211_is_beacon(hdr->frame_control)) {
+        el_off = offsetof(struct ieee80211_mgmt, u.beacon.variable);
+        el = ((struct ieee80211_mgmt *)hdr)->u.beacon.variable;
+    } else
+        goto exit;
+
+    len -= el_off;
+
+    el = cfg80211_find_ie(WLAN_EID_DS_PARAMS, el, len);
+    if (el && el[1] > 0)
+        channel = el[2];
+
+exit:
+    return ieee80211_channel_to_frequency(channel, IEEE80211_BAND_2GHZ);
+}
+
 static void at76_rx_tasklet(unsigned long param)
 {
     struct urb *urb = (struct urb *)param;
@@ -1542,6 +1590,8 @@ static void at76_rx_tasklet(unsigned long param)
     rx_status.signal = buf->rssi;
     rx_status.flag |= RX_FLAG_DECRYPTED;
     rx_status.flag |= RX_FLAG_IV_STRIPPED;
+    rx_status.band = IEEE80211_BAND_2GHZ;
+    rx_status.freq = at76_guess_freq(priv);

     at76_dbg(DBG_MAC80211, "calling ieee80211_rx_irqsafe(): %d/%d",
          priv->rx_skb->len, priv->rx_skb->data_len);
@@ -1894,6 +1944,8 @@ static void at76_dwork_hw_scan(struct work_struct *work)
     if (is_valid_ether_addr(priv->bssid))
         at76_join(priv);

+    priv->scanning = false;
+
     mutex_unlock(&priv->mtx);

     ieee80211_scan_completed(priv->hw, false);
@@ -1948,6 +2000,7 @@ static int at76_hw_scan(struct ieee80211_hw *hw,
         goto exit;
     }

+    priv->scanning = true;
     ieee80211_queue_delayed_work(priv->hw, &priv->dwork_hw_scan,
                      SCAN_POLL_INTERVAL);

diff --git a/drivers/net/wireless/at76c50x-usb.h
b/drivers/net/wireless/at76c50x-usb.h
index 4718aa5..55090a3 100644
--- a/drivers/net/wireless/at76c50x-usb.h
+++ b/drivers/net/wireless/at76c50x-usb.h
@@ -418,6 +418,7 @@ struct at76_priv {
     int scan_max_time;    /* scan max channel time */
     int scan_mode;        /* SCAN_TYPE_ACTIVE, SCAN_TYPE_PASSIVE */
     int scan_need_any;    /* if set, need to scan for any ESSID */
+    bool scanning;        /* if set, the scan is running */

     u16 assoc_id;        /* current association ID, if associated */

-- 
1.9.1
