Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59601 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757478AbZDFUQI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Apr 2009 16:16:08 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 4/5] cfg80211: check allowed channel type upon userspace requests
Date: Mon,  6 Apr 2009 16:15:57 -0400
Message-Id: <1239048958-11775-5-git-send-email-lrodriguez@atheros.com> (sfid-20090406_221614_954519_AC9959FB)
In-Reply-To: <1239048958-11775-1-git-send-email-lrodriguez@atheros.com>
References: <1239048958-11775-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks to nl80211 userspace can be very specific upon device
configuration. Before processing the request for the new HT40
channel types (HT40- or HT40+) we need to ensure we can use them
regulatory-wise. This wasn't required with wireless extensions as
specifying the channel type wasn't not available and configuration
was done towards the end implicitly upon association or reception
of beacons from the AP. For the new nl80211 we have to check this
when configuring the interfaces explicitly.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/nl80211.c |   47 ++++++++++++++++++++++++++---------------------
 1 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 411c233..4e3af27 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -431,7 +431,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
 		struct ieee80211_channel *chan;
 		struct ieee80211_sta_ht_cap *ht_cap;
-		u32 freq, sec_freq;
+		u32 freq;
 
 		if (!rdev->ops->set_channel) {
 			result = -EOPNOTSUPP;
@@ -457,39 +457,44 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		if (!chan || chan->flags & IEEE80211_CHAN_DISABLED)
 			goto bad_res;
 
-		if (channel_type == NL80211_CHAN_HT40MINUS)
-			sec_freq = freq - 20;
-		else if (channel_type == NL80211_CHAN_HT40PLUS)
-			sec_freq = freq + 20;
-		else
-			sec_freq = 0;
-
-		ht_cap = &rdev->wiphy.bands[chan->band]->ht_cap;
+		if (channel_type == NL80211_CHAN_HT40MINUS ||
+		    channel_type == NL80211_CHAN_HT40PLUS)
+			if (chan->flags & IEEE80211_CHAN_NO_HT40)
+				goto bad_res;
 
-		/* no HT capabilities */
-		if (channel_type != NL80211_CHAN_NO_HT &&
-		    !ht_cap->ht_supported)
+		if (channel_type == NL80211_CHAN_HT40MINUS &&
+		    (chan->flags & IEEE80211_CHAN_NO_HT40MINUS))
 			goto bad_res;
+		else if (channel_type == NL80211_CHAN_HT40PLUS &&
+			 (chan->flags & IEEE80211_CHAN_NO_HT40PLUS))
+			goto bad_res;
+
+		/*
+		 * At this point we know if that if HT40 was requested
+		 * we are allowed to use it and the extension channel
+		 * exists.
+		 */
 
-		if (sec_freq) {
-			struct ieee80211_channel *schan;
+		ht_cap = &rdev->wiphy.bands[chan->band]->ht_cap;
 
-			/* no 40 MHz capabilities */
+		/* no HT capabilities or intolerant */
+		if (channel_type != NL80211_CHAN_NO_HT) {
+			if (!ht_cap->ht_supported)
+				goto bad_res;
 			if (!(ht_cap->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) ||
 			    (ht_cap->cap & IEEE80211_HT_CAP_40MHZ_INTOLERANT))
 				goto bad_res;
-
-			schan = ieee80211_get_channel(&rdev->wiphy, sec_freq);
-
-			/* Secondary channel not allowed */
-			if (!schan || schan->flags & IEEE80211_CHAN_DISABLED)
-				goto bad_res;
 		}
 
 		result = rdev->ops->set_channel(&rdev->wiphy, chan,
 						channel_type);
 		if (result)
 			goto bad_res;
+
+		result = rdev->ops->set_channel(&rdev->wiphy, chan,
+						channel_type);
+		if (result)
+			goto bad_res;
 	}
 
 
-- 
1.6.0.6

