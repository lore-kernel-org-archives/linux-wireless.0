Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44259 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab2GRSnU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 14:43:20 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 1/6] mac80211: don't send delBA before disassoc
Date: Wed, 18 Jul 2012 20:43:15 +0200
Message-Id: <1342637000-5270-2-git-send-email-johannes@sipsolutions.net> (sfid-20120718_204330_493075_443058E7)
In-Reply-To: <1342637000-5270-1-git-send-email-johannes@sipsolutions.net>
References: <1342637000-5270-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When we disassociate, it's not really useful to
send delBA action frames since we're going to send
disassoc/deauth anyway, so change that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b7975be..42b2a06 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1363,7 +1363,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	sta = sta_info_get(sdata, bssid);
 	if (sta) {
 		set_sta_flag(sta, WLAN_STA_BLOCK_BA);
-		ieee80211_sta_tear_down_BA_sessions(sta, tx);
+		ieee80211_sta_tear_down_BA_sessions(sta, false);
 	}
 	mutex_unlock(&local->sta_mtx);
 
-- 
1.7.10.4

