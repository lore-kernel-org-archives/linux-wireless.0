Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40535 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab0J1JB0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 05:01:26 -0400
Received: by eye27 with SMTP id 27so1333272eye.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Oct 2010 02:01:25 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 28 Oct 2010 02:01:24 -0700
Message-ID: <AANLkTi=t-rEsFKMv-V7Q3cyY6A_+LiBBYW2WbwXzg50b@mail.gmail.com>
Subject: [PATCH] mac80211_hwsim: Incorporate txpower into rssi
From: Blaise Gassend <blaise@willowgarage.com>
To: linville@redhat.com
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Up to now mac80211_hwsim has been reporting an rssi of -50. This patch
improves the model slightly by returning txpower-50. This makes it
easy to stimulate tests that need to see a varying rssi.

Signed-off-by: Blaise Gassend <blaise@willowgarage.com>
---
diff --git a/drivers/net/wireless/mac80211_hwsim.c
b/drivers/net/wireless/mac80211
index 7eaaa3b..3c44246 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -309,6 +309,8 @@ struct mac80211_hwsim_data {
         */
        u64 group;
        struct dentry *debugfs_group;
+
+       int power_level;
 };


@@ -497,7 +499,7 @@ static bool mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
        rx_status.band = data->channel->band;
        rx_status.rate_idx = info->control.rates[0].idx;
        /* TODO: simulate real signal strength (and optional packet loss) */
-       rx_status.signal = -50;
+       rx_status.signal = data->power_level-50;

        if (data->ps != PS_DISABLED)
                hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
@@ -698,6 +700,7 @@ static int mac80211_hwsim_config(struct
ieee80211_hw *hw, u32
        data->idle = !!(conf->flags & IEEE80211_CONF_IDLE);

        data->channel = conf->channel;
+       data->power_level = conf->power_level;
        if (!data->started || !data->beacon_int)
                del_timer(&data->beacon_timer);
        else
