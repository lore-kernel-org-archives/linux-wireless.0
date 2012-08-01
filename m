Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43876 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493Ab2HAPVd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 11:21:33 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 1/8] mac80211: remove unneeded 'bssid' variable
Date: Wed,  1 Aug 2012 17:21:20 +0200
Message-Id: <1343834487-23737-2-git-send-email-johannes@sipsolutions.net> (sfid-20120801_172146_672777_2DC16589)
In-Reply-To: <1343834487-23737-1-git-send-email-johannes@sipsolutions.net>
References: <1343834487-23737-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to copy the BSSID just to print
it, remove the unnecessary variable.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c416a08..55cf04c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1696,7 +1696,6 @@ static void __ieee80211_connection_loss(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
-	u8 bssid[ETH_ALEN];
 	u8 frame_buf[DEAUTH_DISASSOC_LEN];
 
 	mutex_lock(&ifmgd->mtx);
@@ -1705,9 +1704,8 @@ static void __ieee80211_connection_loss(struct ieee80211_sub_if_data *sdata)
 		return;
 	}
 
-	memcpy(bssid, ifmgd->associated->bssid, ETH_ALEN);
-
-	sdata_info(sdata, "Connection to AP %pM lost\n", bssid);
+	sdata_info(sdata, "Connection to AP %pM lost\n",
+		   ifmgd->associated->bssid);
 
 	ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
 			       WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
-- 
1.7.10.4

