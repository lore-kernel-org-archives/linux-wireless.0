Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:45701 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932767Ab3LESyu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 13:54:50 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, luciano.coelho@intel.com,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH] mac80211: fix nested sdata lock for IBSS/CSA
Date: Thu,  5 Dec 2013 19:54:43 +0100
Message-Id: <1386269683-14079-1-git-send-email-sw@simonwunderlich.de> (sfid-20131205_195458_508854_9372E838)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a regression introduced by my patch "mac80211: don't cancel
csa finalize work within stop_ap", which added sdata locks to
ieee80211_csa_finalize_work() without removing the locking for
ieee80211_ibss_finish_csa(), which is called by the former, resulting
in a deadlock due to nested locking.

Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/mac80211/ibss.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 0f1fb5d..d09f662 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -534,7 +534,7 @@ int ieee80211_ibss_finish_csa(struct ieee80211_sub_if_data *sdata)
 	int err;
 	u16 capability;
 
-	sdata_lock(sdata);
+	sdata_assert_lock(sdata);
 	/* update cfg80211 bss information with the new channel */
 	if (!is_zero_ether_addr(ifibss->bssid)) {
 		capability = WLAN_CAPABILITY_IBSS;
@@ -559,7 +559,6 @@ int ieee80211_ibss_finish_csa(struct ieee80211_sub_if_data *sdata)
 
 	/* generate the beacon */
 	err = ieee80211_ibss_csa_beacon(sdata, NULL);
-	sdata_unlock(sdata);
 	if (err < 0)
 		return err;
 
-- 
1.7.10.4

