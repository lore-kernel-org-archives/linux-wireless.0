Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44046 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbZCSGl3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 02:41:29 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v4 3/6] mac80211: check if HT40+/- is allowed before sending assoc
Date: Thu, 19 Mar 2009 02:41:26 -0400
Message-Id: <1237444886-24530-1-git-send-email-lrodriguez@atheros.com> (sfid-20090319_074132_434800_DF9E8552)
To: johannes@sipsolutions.net, linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We weren't checking this at all.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

Another mistake on my part, caught by sujith -- we were disabling HT
completley if NOHT40 was set, we now stick to HT20 when HT40 is not
set.

 net/mac80211/ht.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 4e3c72f..9c4faa4 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -119,13 +119,18 @@ u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 
 		if (!(ap_ht_cap_flags & IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
 		    (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
-		    (hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
+		    (hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY) &&
+		    !(local->hw.conf.channel->flags & IEEE80211_CHAN_NO_HT40)) {
 			switch(hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
 			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
-				channel_type = NL80211_CHAN_HT40PLUS;
+				if (!(local->hw.conf.channel->flags &
+				    IEEE80211_CHAN_NO_HT40PLUS))
+					channel_type = NL80211_CHAN_HT40PLUS;
 				break;
 			case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
-				channel_type = NL80211_CHAN_HT40MINUS;
+				if (!(local->hw.conf.channel->flags &
+				    IEEE80211_CHAN_NO_HT40MINUS))
+					channel_type = NL80211_CHAN_HT40MINUS;
 				break;
 			}
 		}
-- 
1.5.6.4

