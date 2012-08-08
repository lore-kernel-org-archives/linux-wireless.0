Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:59107 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab2HHTe3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 15:34:29 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCH] mac80211: do not reply to AUTH frame if sta allocation fails
Date: Wed,  8 Aug 2012 21:34:12 +0200
Message-Id: <1344454452-19480-1-git-send-email-ordex@autistici.org> (sfid-20120808_213434_455471_DB86ECF4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whenever we get an AUTH frame we first allocate a new station and then we reply
with another AUTH frame. However, if sta allocations fails we have to do not
reply so that the other hand do not think we have correctly set everything up

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---
 net/mac80211/ibss.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 5746d62..37e71a3 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -337,6 +337,7 @@ static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
 					size_t len)
 {
 	u16 auth_alg, auth_transaction;
+	struct sta_info *sta;
 
 	lockdep_assert_held(&sdata->u.ibss.mtx);
 
@@ -352,10 +353,17 @@ static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
 		 "RX Auth SA=%pM DA=%pM BSSID=%pM (auth_transaction=%d)\n",
 		 mgmt->sa, mgmt->da, mgmt->bssid, auth_transaction);
 	sta_info_destroy_addr(sdata, mgmt->sa);
-	ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, 0, false);
+	sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, 0, false);
 	rcu_read_unlock();
 
 	/*
+	 * if we have any problem in allocating the new station, we do not reply
+	 * with the AUTH frame
+	 */
+	if (!sta)
+		return;
+
+	/*
 	 * IEEE 802.11 standard does not require authentication in IBSS
 	 * networks and most implementations do not seem to use it.
 	 * However, try to reply to authentication attempts if someone
-- 
1.7.9.4

