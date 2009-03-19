Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34128 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbZCSFyp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 01:54:45 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 3/6] mac80211: check if HT40+/- is allowed before sending assoc
Date: Thu, 19 Mar 2009 01:54:37 -0400
Message-Id: <1237442080-27509-4-git-send-email-lrodriguez@atheros.com> (sfid-20090319_065449_322373_F9369DA1)
In-Reply-To: <1237442080-27509-1-git-send-email-lrodriguez@atheros.com>
References: <1237442080-27509-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We weren't checking this at all.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/ht.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 4e3c72f..01010e0 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -114,6 +114,9 @@ u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 	    ieee80211_channel_to_frequency(hti->control_chan))
 		enable_ht = false;
 
+	if (local->hw.conf.channel->flags & IEEE80211_CHAN_NO_HT40)
+		enable_ht = false;
+
 	if (enable_ht) {
 		channel_type = NL80211_CHAN_HT20;
 
@@ -122,10 +125,14 @@ u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 		    (hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
 			switch(hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
 			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
-				channel_type = NL80211_CHAN_HT40PLUS;
+				if (local->hw.conf.channel->flags &
+				    IEEE80211_CHAN_NO_HT40PLUS)
+					channel_type = NL80211_CHAN_HT40PLUS;
 				break;
 			case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
-				channel_type = NL80211_CHAN_HT40MINUS;
+				if (local->hw.conf.channel->flags &
+				    IEEE80211_CHAN_NO_HT40MINUS)
+					channel_type = NL80211_CHAN_HT40MINUS;
 				break;
 			}
 		}
-- 
1.6.0.6

