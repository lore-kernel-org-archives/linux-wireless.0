Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35072 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbZEBEhW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 May 2009 00:37:22 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/5] mac80211: check if HT40+/- is allowed before sending assoc
Date: Sat,  2 May 2009 00:37:19 -0400
Message-Id: <1241239041-2367-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1241239041-2367-1-git-send-email-lrodriguez@atheros.com>
References: <1241239041-2367-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We weren't checking this at all.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/mlme.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 02f93fa..b1ed8c9 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -122,10 +122,14 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 		    (hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
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
1.6.0.6

