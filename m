Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:49599 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295AbaBRNhL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 08:37:11 -0500
Received: by mail-pa0-f48.google.com with SMTP id kx10so16737238pab.35
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 05:37:10 -0800 (PST)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 6/7] orinoco: replace function ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan}
Date: Tue, 18 Feb 2014 21:36:02 +0800
Message-Id: <be3f8f8f679b4665e3306869a35f830a94e727df.1392728354.git.gamerh2o@gmail.com> (sfid-20140218_143717_361601_9F42148D)
In-Reply-To: <cover.1392728354.git.gamerh2o@gmail.com>
References: <cover.1392728354.git.gamerh2o@gmail.com>
In-Reply-To: <cover.1392728354.git.gamerh2o@gmail.com>
References: <cover.1392728354.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan} with more
generic ieee80211_{channel_to_frequency, frequency_to_channel}.

File <net/cfg80211.h> has already been included. It's safe to use
IEEE80211_BAND_2GHZ here.

This change is a preparation for the removal of function
ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan}.

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 drivers/net/wireless/orinoco/cfg.c  | 4 ++--
 drivers/net/wireless/orinoco/hw.c   | 2 +-
 drivers/net/wireless/orinoco/scan.c | 5 +++--
 drivers/net/wireless/orinoco/wext.c | 2 +-
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/orinoco/cfg.c b/drivers/net/wireless/orinoco/cfg.c
index d01edd2..c5ef3ab 100644
--- a/drivers/net/wireless/orinoco/cfg.c
+++ b/drivers/net/wireless/orinoco/cfg.c
@@ -59,7 +59,7 @@ int orinoco_wiphy_register(struct wiphy *wiphy)
 	for (i = 0; i < NUM_CHANNELS; i++) {
 		if (priv->channel_mask & (1 << i)) {
 			priv->channels[i].center_freq =
-				ieee80211_dsss_chan_to_freq(i + 1);
+		     ieee80211_channel_to_frequency(i + 1, IEEE80211_BAND_2GHZ);
 			channels++;
 		}
 	}
@@ -177,7 +177,7 @@ static int orinoco_set_monitor_channel(struct wiphy *wiphy,
 	if (chandef->chan->band != IEEE80211_BAND_2GHZ)
 		return -EINVAL;
 
-	channel = ieee80211_freq_to_dsss_chan(chandef->chan->center_freq);
+	channel = ieee80211_frequency_to_channel(chandef->chan->center_freq);
 
 	if ((channel < 1) || (channel > NUM_CHANNELS) ||
 	     !(priv->channel_mask & (1 << (channel - 1))))
diff --git a/drivers/net/wireless/orinoco/hw.c b/drivers/net/wireless/orinoco/hw.c
index c09c843..49300d0 100644
--- a/drivers/net/wireless/orinoco/hw.c
+++ b/drivers/net/wireless/orinoco/hw.c
@@ -1193,7 +1193,7 @@ int orinoco_hw_get_freq(struct orinoco_private *priv)
 		goto out;
 
 	}
-	freq = ieee80211_dsss_chan_to_freq(channel);
+	freq = ieee80211_channel_to_frequency(channel, IEEE80211_BAND_2GHZ);
 
  out:
 	orinoco_unlock(priv, &flags);
diff --git a/drivers/net/wireless/orinoco/scan.c b/drivers/net/wireless/orinoco/scan.c
index e8c5714..e175b9b 100644
--- a/drivers/net/wireless/orinoco/scan.c
+++ b/drivers/net/wireless/orinoco/scan.c
@@ -110,7 +110,8 @@ static void orinoco_add_hostscan_result(struct orinoco_private *priv,
 		break;
 	}
 
-	freq = ieee80211_dsss_chan_to_freq(le16_to_cpu(bss->a.channel));
+	freq = ieee80211_channel_to_frequency(
+		le16_to_cpu(bss->a.channel), IEEE80211_BAND_2GHZ);
 	channel = ieee80211_get_channel(wiphy, freq);
 	if (!channel) {
 		printk(KERN_DEBUG "Invalid channel designation %04X(%04X)",
@@ -146,7 +147,7 @@ void orinoco_add_extscan_result(struct orinoco_private *priv,
 	ie_len = len - sizeof(*bss);
 	ie = cfg80211_find_ie(WLAN_EID_DS_PARAMS, bss->data, ie_len);
 	chan = ie ? ie[2] : 0;
-	freq = ieee80211_dsss_chan_to_freq(chan);
+	freq = ieee80211_channel_to_frequency(chan, IEEE80211_BAND_2GHZ);
 	channel = ieee80211_get_channel(wiphy, freq);
 
 	timestamp = le64_to_cpu(bss->timestamp);
diff --git a/drivers/net/wireless/orinoco/wext.c b/drivers/net/wireless/orinoco/wext.c
index 3b5508f..b7a867b 100644
--- a/drivers/net/wireless/orinoco/wext.c
+++ b/drivers/net/wireless/orinoco/wext.c
@@ -444,7 +444,7 @@ static int orinoco_ioctl_setfreq(struct net_device *dev,
 		for (i = 0; i < (6 - frq->e); i++)
 			denom *= 10;
 
-		chan = ieee80211_freq_to_dsss_chan(frq->m / denom);
+		chan = ieee80211_frequency_to_channel(frq->m / denom);
 	}
 
 	if ((chan < 1) || (chan > NUM_CHANNELS) ||
-- 
1.8.5.3

