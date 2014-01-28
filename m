Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:60541 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbaA1CAT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jan 2014 21:00:19 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <sw@simonwunderlich.de>,
	<stable@vger.kernel.org>
Subject: [PATCH] mac80211: Fix IBSS join
Date: Tue, 28 Jan 2014 07:24:55 +0530
Message-Id: <1390874095-28008-1-git-send-email-sujith@msujith.org> (sfid-20140128_030023_231303_D26316F7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Currently, when a station leaves an IBSS network, the
corresponding BSS is not dropped from cfg80211 if there are
other active stations in the network. But, the small
window that is present when trying to determine a station's
status based on IEEE80211_IBSS_MERGE_INTERVAL introduces
a race.

Instead of trying to keep the BSS, always remove it when
leaving an IBSS network. There is not much benefit to retain
the BSS entry since it will be added with a subsequent join
operation.

This fixes an issue where a dangling BSS entry causes ath9k
to wait for a beacon indefinitely.

Cc: <stable@vger.kernel.org>
Reported-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 net/mac80211/ibss.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 771080e..e1688cd 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -688,17 +688,18 @@ static int ieee80211_sta_active_ibss(struct ieee80211_sub_if_data *sdata)
 	return active;
 }
 
-static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
+static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata, bool leave)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
 	struct cfg80211_bss *cbss;
 	struct beacon_data *presp;
 	struct sta_info *sta;
-	int active_ibss;
+	int active_ibss = 0;
 	u16 capability;
 
-	active_ibss = ieee80211_sta_active_ibss(sdata);
+	if (!leave)
+		active_ibss = ieee80211_sta_active_ibss(sdata);
 
 	if (!active_ibss && !is_zero_ether_addr(ifibss->bssid)) {
 		capability = WLAN_CAPABILITY_IBSS;
@@ -765,7 +766,7 @@ static void ieee80211_csa_connection_drop_work(struct work_struct *work)
 
 	sdata_lock(sdata);
 
-	ieee80211_ibss_disconnect(sdata);
+	ieee80211_ibss_disconnect(sdata, false);
 	synchronize_rcu();
 	skb_queue_purge(&sdata->skb_queue);
 
@@ -1721,7 +1722,7 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 
-	ieee80211_ibss_disconnect(sdata);
+	ieee80211_ibss_disconnect(sdata, true);
 	ifibss->ssid_len = 0;
 	memset(ifibss->bssid, 0, ETH_ALEN);
 
-- 
1.8.5.3

