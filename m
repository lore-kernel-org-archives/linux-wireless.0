Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:49068 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751813AbZKAJar (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Nov 2009 04:30:47 -0500
Date: Sun, 1 Nov 2009 11:30:48 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211_hwsim: Check idle state on TX
Message-ID: <20091101093048.GA1058@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Track the idle state for hwsim radios and reject TX if mac80211 is
trying to transmit something when the radio is supposed to be idle. In
addition, do not deliver frames if the receiving radio is in the idle
state.

Signed-off-by: Jouni Malinen <j@w1.fi>

---
 drivers/net/wireless/mac80211_hwsim.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- uml.orig/drivers/net/wireless/mac80211_hwsim.c	2009-10-01 17:06:49.000000000 +0300
+++ uml/drivers/net/wireless/mac80211_hwsim.c	2009-10-01 17:22:15.000000000 +0300
@@ -284,7 +284,7 @@ struct mac80211_hwsim_data {
 	struct ieee80211_channel *channel;
 	unsigned long beacon_int; /* in jiffies unit */
 	unsigned int rx_filter;
-	int started;
+	bool started, idle;
 	struct timer_list beacon_timer;
 	enum ps_mode {
 		PS_DISABLED, PS_ENABLED, PS_AUTO_POLL, PS_MANUAL_POLL
@@ -402,6 +402,12 @@ static bool mac80211_hwsim_tx_frame(stru
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_rx_status rx_status;
 
+	if (data->idle) {
+		printk(KERN_DEBUG "%s: Trying to TX when idle - reject\n",
+		       wiphy_name(hw->wiphy));
+		return false;
+	}
+
 	memset(&rx_status, 0, sizeof(rx_status));
 	/* TODO: set mactime */
 	rx_status.freq = data->channel->center_freq;
@@ -428,7 +434,8 @@ static bool mac80211_hwsim_tx_frame(stru
 		if (data == data2)
 			continue;
 
-		if (!data2->started || !hwsim_ps_rx_ok(data2, skb) ||
+		if (data2->idle || !data2->started ||
+		    !hwsim_ps_rx_ok(data2, skb) ||
 		    !data->channel || !data2->channel ||
 		    data->channel->center_freq != data2->channel->center_freq ||
 		    !(data->group & data2->group))
@@ -571,6 +578,8 @@ static int mac80211_hwsim_config(struct 
 	       !!(conf->flags & IEEE80211_CONF_IDLE),
 	       !!(conf->flags & IEEE80211_CONF_PS));
 
+	data->idle = !!(conf->flags & IEEE80211_CONF_IDLE);
+
 	data->channel = conf->channel;
 	if (!data->started || !data->beacon_int)
 		del_timer(&data->beacon_timer);

-- 
Jouni Malinen                                            PGP id EFC895FA
