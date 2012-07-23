Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-2.exch022.serverdata.net ([206.225.164.185]:21685
	"EHLO HUB022-nj-2.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751041Ab2GWJRl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 05:17:41 -0400
From: Mahesh Palivela <maheshp@posedge.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: [PATCH] cfg80211: 80MHz (11ac) regulatory change
Date: Mon, 23 Jul 2012 09:17:40 +0000
Message-ID: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC5E3B@mbx022-e1-nj-10.exch022.domain.local> (sfid-20120723_111745_286055_4794D47A)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

80MHz Regulatory changes for 11ac.

Signed-off-by: Mahesh Palivela <maheshp@posedge.com>
---
 include/net/cfg80211.h |    8 +++++
 net/wireless/reg.c     |   76 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 493fa0c..bde0fee 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -104,10 +104,18 @@ enum ieee80211_channel_flags {
 	IEEE80211_CHAN_RADAR		= 1<<3,
 	IEEE80211_CHAN_NO_HT40PLUS	= 1<<4,
 	IEEE80211_CHAN_NO_HT40MINUS	= 1<<5,
+	IEEE80211_CHAN_NO_VHT80PLUS	= 1<<6,
+	IEEE80211_CHAN_NO_VHT80MINUS	= 1<<7,
+	IEEE80211_CHAN_NO_VHT160PLUS	= 1<<8,
+	IEEE80211_CHAN_NO_VHT160MINUS	= 1<<9,
 };
 
 #define IEEE80211_CHAN_NO_HT40 \
 	(IEEE80211_CHAN_NO_HT40PLUS | IEEE80211_CHAN_NO_HT40MINUS)
+#define IEEE80211_CHAN_NO_VHT80 \
+	(IEEE80211_CHAN_NO_VHT80PLUS | IEEE80211_CHAN_NO_VHT80MINUS)
+#define IEEE80211_CHAN_NO_VHT160 \
+	(IEEE80211_CHAN_NO_VHT160PLUS | IEEE80211_CHAN_NO_VHT160MINUS)
 
 /**
  * struct ieee80211_channel - channel definition
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2303ee7..0ad6c15 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1124,6 +1124,81 @@ static void reg_process_beacons(struct wiphy *wiphy)
 	wiphy_update_beacon_reg(wiphy);
 }
 
+static bool is_vht80_not_allowed(struct ieee80211_channel *chan)
+{
+	if (!chan)
+		return true;
+	if (chan->flags & IEEE80211_CHAN_DISABLED)
+		return true;
+	/* This would happen when regulatory rules disallow VHT80 completely */
+	if (IEEE80211_CHAN_NO_VHT80 == (chan->flags & (IEEE80211_CHAN_NO_VHT80)))
+		return true;
+	return false;
+}
+
+static void reg_process_vht_flags_channel(struct wiphy *wiphy,
+					 unsigned int chan_idx)
+{
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *channel;
+	struct ieee80211_channel *channel_before = NULL, *channel_after = NULL;
+	unsigned int i;
+
+	assert_cfg80211_lock();
+
+	sband = wiphy->bands[IEEE80211_BAND_5GHZ];
+	BUG_ON(chan_idx >= sband->n_channels);
+	channel = &sband->channels[chan_idx];
+
+	if (is_vht80_not_allowed(channel)) {
+		channel->flags |= IEEE80211_CHAN_NO_VHT80;
+		return;
+	}
+
+	/*
+	 * We need to ensure the extension channels exist to
+	 * be able to use VHT80- or VHT80+, this finds them (or not)
+	 */
+	for (i = 0; i < sband->n_channels; i++) {
+		struct ieee80211_channel *c = &sband->channels[i];
+		if (c->center_freq == (channel->center_freq - 40))
+			channel_before = c;
+		if (c->center_freq == (channel->center_freq + 40))
+			channel_after = c;
+	}
+
+	/*
+	 * Please note that this assumes target bandwidth is 40 MHz,
+	 * if that ever changes we also need to change the below logic
+	 * to include that as well.
+	 */
+	if (is_vht80_not_allowed(channel_before))
+		channel->flags |= IEEE80211_CHAN_NO_VHT80MINUS;
+	else
+		channel->flags &= ~IEEE80211_CHAN_NO_VHT80MINUS;
+
+	if (is_vht80_not_allowed(channel_after))
+		channel->flags |= IEEE80211_CHAN_NO_VHT80PLUS;
+	else
+		channel->flags &= ~IEEE80211_CHAN_NO_VHT80PLUS;
+}
+
+static void reg_process_vht_flags(struct wiphy *wiphy)
+{
+	unsigned int i;
+	struct ieee80211_supported_band *sband;
+
+	if(!wiphy->bands[IEEE80211_BAND_5GHZ]) {
+		/* 5GHz band is not supported, which is 
+		 * mandatory for VHT. so simply return */
+		return;
+	}
+	sband = wiphy->bands[IEEE80211_BAND_5GHZ];
+
+	for (i = 0; i < sband->n_channels; i++)
+		reg_process_vht_flags_channel(wiphy, i);
+}
+
 static bool is_ht40_not_allowed(struct ieee80211_channel *chan)
 {
 	if (!chan)
@@ -1230,6 +1305,7 @@ static void wiphy_update_regulatory(struct wiphy *wiphy,
 
 	reg_process_beacons(wiphy);
 	reg_process_ht_flags(wiphy);
+	reg_process_vht_flags(wiphy);
 	if (wiphy->reg_notifier)
 		wiphy->reg_notifier(wiphy, last_request);
 }