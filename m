Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45016 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932430Ab2E3Jji (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 05:39:38 -0400
Message-ID: <1338370773.4511.11.camel@jlt3.sipsolutions.net> (sfid-20120530_113941_713215_94670BB5)
Subject: [PATCH 3.5] mac80211: fix error in station state transitions during
 reconfig
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 30 May 2012 11:39:33 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

As part of hardware reconfig mac80211 tries
to restore the station state to its values
before the hardware reconfig, but it only
goes to the last-state - 1. Fix this
off-by-one error.

Cc: stable@kernel.org [3.4]
Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 22f2216..c7dc129 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1271,7 +1271,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			enum ieee80211_sta_state state;
 
 			for (state = IEEE80211_STA_NOTEXIST;
-			     state < sta->sta_state - 1; state++)
+			     state < sta->sta_state; state++)
 				WARN_ON(drv_sta_state(local, sta->sdata, sta,
 						      state, state + 1));
 		}
-- 
1.7.10



