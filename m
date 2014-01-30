Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:44803 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaA3Iw6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jan 2014 03:52:58 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, <stable@vger.kernel.org>
Subject: [PATCH v2] mac80211: Fix IBSS disconnect
Date: Thu, 30 Jan 2014 14:17:28 +0530
Message-Id: <1391071648-12863-1-git-send-email-sujith@msujith.org> (sfid-20140130_095301_911576_DEEAECF4)
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
v2 - Remove BSS entry in the CSA-failure case too.

 net/mac80211/ibss.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 771080e..2796a19 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -695,12 +695,9 @@ static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
 	struct cfg80211_bss *cbss;
 	struct beacon_data *presp;
 	struct sta_info *sta;
-	int active_ibss;
 	u16 capability;
 
-	active_ibss = ieee80211_sta_active_ibss(sdata);
-
-	if (!active_ibss && !is_zero_ether_addr(ifibss->bssid)) {
+	if (!is_zero_ether_addr(ifibss->bssid)) {
 		capability = WLAN_CAPABILITY_IBSS;
 
 		if (ifibss->privacy)
-- 
1.8.5.3

