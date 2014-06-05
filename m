Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:40082 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaFEOKp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 10:10:45 -0400
Received: by mail-wi0-f177.google.com with SMTP id f8so3515545wiw.16
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jun 2014 07:10:41 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: emmanuel.grumbach@intel.com, linux-wireless@vger.kernel.org,
	joerg.albert@gmx.de, alex@foogod.com, n0_5p4m_p13453@hotmail.com,
	proski@gnu.org, agx@sigxcpu.org, kalle.valo@iki.fi, sesmo@gmx.net,
	Andrea Merello <andrea.merello@gmail.com>
Subject: [PATCH] at76c50x: fix scan does not work with latest mac80211
Date: Thu,  5 Jun 2014 16:10:12 +0200
Message-Id: <1401977412-17778-1-git-send-email-andrea.merello@gmail.com> (sfid-20140605_161049_144499_13596CDD)
In-Reply-To: <1401971576.4168.3.camel@jlt4.sipsolutions.net>
References: <1401971576.4168.3.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

since commit 3afc2167f60a327a2c1e1e2600ef209a3c2b75b7 scan in not
working anymore, due to mac80211 requires rx frequency status
information.

This patch makes the driver report this information.

While NOT scanning this is straightforward.
While scanning the firmware performs RF sweep and we cannot track
the actual tuning frequency, so this is guessed by parsing beacons
and probe responses.
This should be enough for ensuring functionality.

Thanks-to: Johannes Berg <johannes@sipsolutions.net> [ for suggestions and reviewing ]
Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/at76c50x-usb.c | 53 +++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/at76c50x-usb.h |  1 +
 2 files changed, 54 insertions(+)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 10fd12e..d48776e 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -1429,6 +1429,8 @@ static int at76_startup_device(struct at76_priv *priv)
 	/* remove BSSID from previous run */
 	memset(priv->bssid, 0, ETH_ALEN);
 
+	priv->scanning = false;
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
+	size_t el_off;
+	const u8 *el;
+	int channel = priv->channel;
+	int len = priv->rx_skb->len;
+	struct ieee80211_hdr *hdr = (void *)priv->rx_skb->data;
+
+	if (!priv->scanning)
+		goto exit;
+
+	if (len < 24)
+		goto exit;
+
+	if (ieee80211_is_probe_resp(hdr->frame_control)) {
+		el_off = offsetof(struct ieee80211_mgmt, u.probe_resp.variable);
+		el = ((struct ieee80211_mgmt *)hdr)->u.probe_resp.variable;
+	} else if (ieee80211_is_beacon(hdr->frame_control)) {
+		el_off = offsetof(struct ieee80211_mgmt, u.beacon.variable);
+		el = ((struct ieee80211_mgmt *)hdr)->u.beacon.variable;
+	} else {
+		goto exit;
+	}
+	len -= el_off;
+
+	el = cfg80211_find_ie(WLAN_EID_DS_PARAMS, el, len);
+	if (el && el[1] > 0)
+		channel = el[2];
+
+exit:
+	return ieee80211_channel_to_frequency(channel, IEEE80211_BAND_2GHZ);
+}
+
 static void at76_rx_tasklet(unsigned long param)
 {
 	struct urb *urb = (struct urb *)param;
@@ -1542,6 +1590,8 @@ static void at76_rx_tasklet(unsigned long param)
 	rx_status.signal = buf->rssi;
 	rx_status.flag |= RX_FLAG_DECRYPTED;
 	rx_status.flag |= RX_FLAG_IV_STRIPPED;
+	rx_status.band = IEEE80211_BAND_2GHZ;
+	rx_status.freq = at76_guess_freq(priv);
 
 	at76_dbg(DBG_MAC80211, "calling ieee80211_rx_irqsafe(): %d/%d",
 		 priv->rx_skb->len, priv->rx_skb->data_len);
@@ -1894,6 +1944,8 @@ static void at76_dwork_hw_scan(struct work_struct *work)
 	if (is_valid_ether_addr(priv->bssid))
 		at76_join(priv);
 
+	priv->scanning = false;
+
 	mutex_unlock(&priv->mtx);
 
 	ieee80211_scan_completed(priv->hw, false);
@@ -1948,6 +2000,7 @@ static int at76_hw_scan(struct ieee80211_hw *hw,
 		goto exit;
 	}
 
+	priv->scanning = true;
 	ieee80211_queue_delayed_work(priv->hw, &priv->dwork_hw_scan,
 				     SCAN_POLL_INTERVAL);
 
diff --git a/drivers/net/wireless/at76c50x-usb.h b/drivers/net/wireless/at76c50x-usb.h
index 4718aa5..55090a3 100644
--- a/drivers/net/wireless/at76c50x-usb.h
+++ b/drivers/net/wireless/at76c50x-usb.h
@@ -418,6 +418,7 @@ struct at76_priv {
 	int scan_max_time;	/* scan max channel time */
 	int scan_mode;		/* SCAN_TYPE_ACTIVE, SCAN_TYPE_PASSIVE */
 	int scan_need_any;	/* if set, need to scan for any ESSID */
+	bool scanning;		/* if set, the scan is running */
 
 	u16 assoc_id;		/* current association ID, if associated */
 
-- 
1.9.1

