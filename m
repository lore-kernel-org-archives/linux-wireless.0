Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56906 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab0H0Kht (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 06:37:49 -0400
Message-Id: <20100827103658.158896919@sipsolutions.net>
Date: Fri, 27 Aug 2010 12:35:55 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/6] mac80211: switch to ieee80211_sdata_running
References: <20100827103553.559128239@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since the introduction of ieee80211_sdata_running(),
some new code was introduced that uses netif_running()
instead. Switch all these instances over.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c  |    6 ++----
 net/mac80211/main.c |    6 +++---
 net/mac80211/util.c |    2 +-
 3 files changed, 6 insertions(+), 8 deletions(-)

--- wireless-testing.orig/net/mac80211/cfg.c	2010-08-26 16:00:16.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2010-08-26 16:00:30.000000000 +0200
@@ -81,16 +81,14 @@ static int ieee80211_add_key(struct wiph
 			     u8 key_idx, const u8 *mac_addr,
 			     struct key_params *params)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sta_info *sta = NULL;
 	struct ieee80211_key *key;
 	int err;
 
-	if (!netif_running(dev))
+	if (!ieee80211_sdata_running(sdata))
 		return -ENETDOWN;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
 	/* reject WEP and TKIP keys if WEP failed to initialize */
 	switch (params->cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
--- wireless-testing.orig/net/mac80211/main.c	2010-08-26 16:00:28.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2010-08-26 16:00:30.000000000 +0200
@@ -339,9 +339,6 @@ static int ieee80211_ifa_changed(struct
 	struct ieee80211_if_managed *ifmgd;
 	int c = 0;
 
-	if (!netif_running(ndev))
-		return NOTIFY_DONE;
-
 	/* Make sure it's our interface that got changed */
 	if (!wdev)
 		return NOTIFY_DONE;
@@ -352,6 +349,9 @@ static int ieee80211_ifa_changed(struct
 	sdata = IEEE80211_DEV_TO_SUB_IF(ndev);
 	bss_conf = &sdata->vif.bss_conf;
 
+	if (!ieee80211_sdata_running(sdata))
+		return NOTIFY_DONE;
+
 	/* ARP filtering is only supported in managed mode */
 	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return NOTIFY_DONE;
--- wireless-testing.orig/net/mac80211/util.c	2010-08-26 16:00:17.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2010-08-26 16:00:30.000000000 +0200
@@ -1308,7 +1308,7 @@ void ieee80211_recalc_smps(struct ieee80
 	 */
 
 	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!netif_running(sdata->dev))
+		if (!ieee80211_sdata_running(sdata))
 			continue;
 		if (sdata->vif.type != NL80211_IFTYPE_STATION)
 			goto set;


