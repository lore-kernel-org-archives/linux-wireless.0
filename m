Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:10028 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755985AbYEIQfm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2008 12:35:42 -0400
From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
To: linux-wireless@vger.kernel.org
Cc: yi.zhu@intel.com, Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Subject: [RFC PATCH] mac80211 : Association with 11n hidden ssid ap.
Date: Fri,  9 May 2008 09:35:41 -0700
Message-Id: <12103509413156-git-send-email-abhijeet.kolekar@intel.com> (sfid-20080509_183433_953836_C922E998)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the association problem with 11n hidden ssid ap.
Patch fixes the problem of associating with hidden ssid when
all three parameters ap,essid and channel are given to iwconfig.
This patch removes the condition of checking three parameters
and always checks for bss in bss list while associating.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
---
 net/mac80211/mlme.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index cb01995..872b105 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3390,13 +3390,6 @@ static int ieee80211_sta_config_auth(struct net_device *dev,
 	struct ieee80211_sta_bss *bss, *selected = NULL;
 	int top_rssi = 0, freq;
 
-	if (!(ifsta->flags & (IEEE80211_STA_AUTO_SSID_SEL |
-	    IEEE80211_STA_AUTO_BSSID_SEL | IEEE80211_STA_AUTO_CHANNEL_SEL))) {
-		ifsta->state = IEEE80211_AUTHENTICATE;
-		ieee80211_sta_reset_auth(dev, ifsta);
-		return 0;
-	}
-
 	spin_lock_bh(&local->sta_bss_lock);
 	freq = local->oper_channel->center_freq;
 	list_for_each_entry(bss, &local->sta_bss_list, list) {
-- 
1.5.2.5

