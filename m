Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55259 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615AbZDBBfs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2009 21:35:48 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 1/3] cfg80211: respect API on orig_flags on channel for beacon hint
Date: Wed,  1 Apr 2009 21:35:28 -0400
Message-Id: <1238636130-27747-1-git-send-email-lrodriguez@atheros.com> (sfid-20090402_033551_280164_DA676C55)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As part of our documented API we always respect the orig_flag
settings on a channel. We forgot to follow this for the beacon
hints.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 6327e16..c3e39e1 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1070,12 +1070,14 @@ static void handle_reg_beacon(struct wiphy *wiphy,
 	if (likely(chan->center_freq != reg_beacon->chan.center_freq))
 		return;
 
-	if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN) {
+	if ((chan->flags & IEEE80211_CHAN_PASSIVE_SCAN) &&
+	    !(chan->orig_flags & IEEE80211_CHAN_PASSIVE_SCAN)) {
 		chan->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
 		REG_DEBUG_BEACON_FLAG("active scanning");
 	}
 
-	if (chan->flags & IEEE80211_CHAN_NO_IBSS) {
+	if ((chan->flags & IEEE80211_CHAN_NO_IBSS) &&
+	    !(chan->orig_flags & IEEE80211_CHAN_NO_IBSS)) {
 		chan->flags &= ~IEEE80211_CHAN_NO_IBSS;
 		REG_DEBUG_BEACON_FLAG("beaconing");
 	}
-- 
1.6.0.6

