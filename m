Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43983 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbZCJCFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 22:05:07 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/4] mac80211: disallow HT40 if max channel bandwidth is less than 40 MHz
Date: Mon,  9 Mar 2009 22:04:58 -0400
Message-Id: <1236650699-30538-4-git-send-email-lrodriguez@atheros.com> (sfid-20090310_030522_588890_70448F87)
In-Reply-To: <1236650699-30538-1-git-send-email-lrodriguez@atheros.com>
References: <1236650699-30538-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/util.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 32610a0..a891d7e 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -796,6 +796,9 @@ int ieee80211_set_freq(struct ieee80211_sub_if_data *sdata, int freqMHz)
 	if (!chan || (chan->flags & IEEE80211_CHAN_DISABLED))
 		return ret;
 
+	if (conf_is_ht40(&local->hw.conf) && chan->max_bandwidth < 40)
+		return ret;
+
 	if (sdata->vif.type == NL80211_IFTYPE_ADHOC &&
 	    chan->flags & IEEE80211_CHAN_NO_IBSS)
 		return ret;
-- 
1.6.0.6

