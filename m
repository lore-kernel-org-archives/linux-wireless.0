Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:37976 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab2KMRnN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 12:43:13 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Ignacy Gawedzki <i@lri.fr>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCHv3] mac80211: deinitialize ibss-internals after emptiness check
Date: Tue, 13 Nov 2012 18:43:03 +0100
Message-Id: <1352828583-19502-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20121113_184317_125714_179E68F7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The check whether the IBSS is active and can be removed should be
performed before deinitializing the fields used for the check/search.
Otherwise, the configured BSS will not be found and removed properly.

To make it more clear for the future, rename sdata->u.ibss to the
local pointer ifibss which is used within the checks.

This behaviour was introduced by
f3209bea110cade12e2b133da8b8499689cb0e2e
("mac80211: fix IBSS teardown race")

Cc: Ignacy Gawedzki <i@lri.fr>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 net/mac80211/ibss.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index c7386b2..67774b0 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1156,10 +1156,6 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 
 	mutex_lock(&sdata->u.ibss.mtx);
 
-	sdata->u.ibss.state = IEEE80211_IBSS_MLME_SEARCH;
-	memset(sdata->u.ibss.bssid, 0, ETH_ALEN);
-	sdata->u.ibss.ssid_len = 0;
-
 	active_ibss = ieee80211_sta_active_ibss(sdata);
 
 	if (!active_ibss && !is_zero_ether_addr(ifibss->bssid)) {
@@ -1180,6 +1176,10 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 		}
 	}
 
+	ifibss->state = IEEE80211_IBSS_MLME_SEARCH;
+	memset(ifibss->bssid, 0, ETH_ALEN);
+	ifibss->ssid_len = 0;
+
 	sta_info_flush(sdata->local, sdata);
 
 	spin_lock_bh(&ifibss->incomplete_lock);
-- 
1.7.10

