Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35075 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbZEBEhX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 May 2009 00:37:23 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 4/5] cfg80211: check allowed channel type upon userspace requests
Date: Sat,  2 May 2009 00:37:20 -0400
Message-Id: <1241239041-2367-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1241239041-2367-1-git-send-email-lrodriguez@atheros.com>
References: <1241239041-2367-1-git-send-email-lrodriguez@atheros.com>
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
 net/wireless/nl80211.c |   39 +++++++++++++++++----------------------
 1 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3c53c5c..401b691 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -487,7 +487,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
 		struct ieee80211_channel *chan;
 		struct ieee80211_sta_ht_cap *ht_cap;
-		u32 freq, sec_freq;
+		u32 freq;
 
 		if (!rdev->ops->set_channel) {
 			result = -EOPNOTSUPP;
@@ -513,33 +513,28 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
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
-
-		/* no HT capabilities */
-		if (channel_type != NL80211_CHAN_NO_HT &&
-		    !ht_cap->ht_supported)
+		if (channel_type == NL80211_CHAN_HT40MINUS &&
+		    (chan->flags & IEEE80211_CHAN_NO_HT40MINUS))
+			goto bad_res;
+		else if (channel_type == NL80211_CHAN_HT40PLUS &&
+			 (chan->flags & IEEE80211_CHAN_NO_HT40PLUS))
 			goto bad_res;
 
-		if (sec_freq) {
-			struct ieee80211_channel *schan;
+		/*
+		 * At this point we know if that if HT40 was requested
+		 * we are allowed to use it and the extension channel
+		 * exists.
+		 */
 
-			/* no 40 MHz capabilities */
+		ht_cap = &rdev->wiphy.bands[chan->band]->ht_cap;
+
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
-- 
1.6.0.6

