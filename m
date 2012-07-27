Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51451 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab2G0LRu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:17:50 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 13/20] mac80211: use RX status band instead of current band
Date: Fri, 27 Jul 2012 13:16:49 +0200
Message-Id: <1343387816-9414-14-git-send-email-johannes@sipsolutions.net> (sfid-20120727_131822_671923_0086BA66)
In-Reply-To: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Even for single-channel devices it is possible that we
switch the channel temporarily (e.g. for scanning) but
while doing so process a received frame that was still
received on the old channel, so checking the current
band is racy. Use the band from status instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3b74232..5983d3e 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2268,7 +2268,7 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 
 		goto queue;
 	case WLAN_CATEGORY_SPECTRUM_MGMT:
-		if (local->hw.conf.channel->band != IEEE80211_BAND_5GHZ)
+		if (status->band != IEEE80211_BAND_5GHZ)
 			break;
 
 		if (sdata->vif.type != NL80211_IFTYPE_STATION)
-- 
1.7.10.4

