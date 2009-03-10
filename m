Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43986 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbZCJCFI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 22:05:08 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/4] mac80211: move early error branch check on ieee80211_set_freq()
Date: Mon,  9 Mar 2009 22:04:57 -0400
Message-Id: <1236650699-30538-3-git-send-email-lrodriguez@atheros.com> (sfid-20090310_030521_854319_84CC7A62)
In-Reply-To: <1236650699-30538-1-git-send-email-lrodriguez@atheros.com>
References: <1236650699-30538-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This has no functional change, we just move the bad case error check
early as we will soon add some more and this will make this easier to
read.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/util.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index e0431a1..32610a0 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -793,19 +793,20 @@ int ieee80211_set_freq(struct ieee80211_sub_if_data *sdata, int freqMHz)
 
 	chan = ieee80211_get_channel(local->hw.wiphy, freqMHz);
 
-	if (chan && !(chan->flags & IEEE80211_CHAN_DISABLED)) {
-		if (sdata->vif.type == NL80211_IFTYPE_ADHOC &&
-		    chan->flags & IEEE80211_CHAN_NO_IBSS)
-			return ret;
-		local->oper_channel = chan;
-		local->oper_channel_type = NL80211_CHAN_NO_HT;
-
-		if (local->sw_scanning || local->hw_scanning)
-			ret = 0;
-		else
-			ret = ieee80211_hw_config(
-				local, IEEE80211_CONF_CHANGE_CHANNEL);
-	}
+	if (!chan || (chan->flags & IEEE80211_CHAN_DISABLED))
+		return ret;
+
+	if (sdata->vif.type == NL80211_IFTYPE_ADHOC &&
+	    chan->flags & IEEE80211_CHAN_NO_IBSS)
+		return ret;
+	local->oper_channel = chan;
+	local->oper_channel_type = NL80211_CHAN_NO_HT;
+
+	if (local->sw_scanning || local->hw_scanning)
+		ret = 0;
+	else
+		ret = ieee80211_hw_config(
+			local, IEEE80211_CONF_CHANGE_CHANNEL);
 
 	return ret;
 }
-- 
1.6.0.6

