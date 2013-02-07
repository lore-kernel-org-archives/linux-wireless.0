Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56517 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759156Ab3BGT4H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 14:56:07 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix managed mode channel context use
Date: Thu,  7 Feb 2013 20:56:29 +0100
Message-Id: <1360266989-23582-1-git-send-email-johannes@sipsolutions.net> (sfid-20130207_205615_447278_08689902)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

My commit f2d9d270c15ae0139b54a7e7466d738327e97e03
("mac80211: support VHT association") introduced a
very stupid bug: the loop to downgrade the channel
width never attempted to actually use it again so
it would downgrade all the way to 20_NOHT. Fix it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a355292..3b9cb51 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3529,8 +3529,11 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 	 */
 	ret = ieee80211_vif_use_channel(sdata, &chandef,
 					IEEE80211_CHANCTX_SHARED);
-	while (ret && chandef.width != NL80211_CHAN_WIDTH_20_NOHT)
+	while (ret && chandef.width != NL80211_CHAN_WIDTH_20_NOHT) {
 		ifmgd->flags |= chandef_downgrade(&chandef);
+		ret = ieee80211_vif_use_channel(sdata, &chandef,
+						IEEE80211_CHANCTX_SHARED);
+	}
 	return ret;
 }
 
-- 
1.8.0

