Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38770 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754778Ab0KSPVJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 10:21:09 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH v2 2/2] mac80211: reduce the number of retries for nullfunc probing
Date: Fri, 19 Nov 2010 16:20:59 +0100
Message-Id: <1290180059-43536-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1290180059-43536-1-git-send-email-nbd@openwrt.org>
References: <1290180059-43536-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since nullfunc frames are transmitted as unicast frames, they're more
reliable than the broadcast probe requests, so we need fewer retries
to figure out whether the AP is really gone.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/mlme.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b24e51f..36b7ea3 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -28,6 +28,7 @@
 #include "rate.h"
 #include "led.h"
 
+#define IEEE80211_MAX_NULLFUNC_TRIES 2
 #define IEEE80211_MAX_PROBE_TRIES 5
 
 /*
@@ -1913,12 +1914,18 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 			    IEEE80211_STA_CONNECTION_POLL) &&
 	    ifmgd->associated) {
 		u8 bssid[ETH_ALEN];
+		int max_tries;
+
+		if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
+			max_tries = IEEE80211_MAX_NULLFUNC_TRIES;
+		else
+			max_tries = IEEE80211_MAX_PROBE_TRIES;
 
 		memcpy(bssid, ifmgd->associated->bssid, ETH_ALEN);
 		if (time_is_after_jiffies(ifmgd->probe_timeout))
 			run_again(ifmgd, ifmgd->probe_timeout);
 
-		else if (ifmgd->probe_send_count < IEEE80211_MAX_PROBE_TRIES) {
+		else if (ifmgd->probe_send_count < max_tries) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 			wiphy_debug(local->hw.wiphy,
 				    "%s: No probe response from AP %pM"
-- 
1.7.3.2

