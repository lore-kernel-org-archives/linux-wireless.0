Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44238 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971Ab2ISKH5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 06:07:57 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/3] mac80211: don't send delBA before disassoc
Date: Wed, 19 Sep 2012 12:08:31 +0200
Message-Id: <1348049313-7650-2-git-send-email-johannes@sipsolutions.net> (sfid-20120919_120802_629411_F931A4BC)
In-Reply-To: <1348049313-7650-1-git-send-email-johannes@sipsolutions.net>
References: <1348049313-7650-1-git-send-email-johannes@sipsolutions.net>
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
index 2dbd9e1..e714ed8 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1399,7 +1399,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	sta = sta_info_get(sdata, ifmgd->bssid);
 	if (sta) {
 		set_sta_flag(sta, WLAN_STA_BLOCK_BA);
-		ieee80211_sta_tear_down_BA_sessions(sta, tx);
+		ieee80211_sta_tear_down_BA_sessions(sta, false);
 	}
 	mutex_unlock(&local->sta_mtx);
 
-- 
1.7.10.4

