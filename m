Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51116 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932755Ab1JZNrz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Oct 2011 09:47:55 -0400
Received: by wwe6 with SMTP id 6so2464623wwe.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Oct 2011 06:47:54 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] mac80211: init rate-control for TDLS sta when supp-rates are known
Date: Wed, 26 Oct 2011 15:47:46 +0200
Message-Id: <1319636866-12171-1-git-send-email-arik@wizery.com> (sfid-20111026_154759_463490_721BFD6C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialize rate control algorithms only when supported rates are known
for a TDLS peer sta. Direct Tx between peers is not allowed before the
link is enabled. In turn, this only occurs after a change_station()
call that sets supported rates.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/cfg.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1309bb9..9f05416d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -829,7 +829,12 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 	      sdata->vif.type == NL80211_IFTYPE_STATION))
 		return -ENOTSUPP;
 
-	rate_control_rate_init(sta);
+	/*
+	 * for TDLS, rate control should be initialized only when supported
+	 * rates are known.
+	 */
+	if (!test_sta_flag(sta, WLAN_STA_TDLS_PEER))
+		rate_control_rate_init(sta);
 
 	layer2_update = sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
 		sdata->vif.type == NL80211_IFTYPE_AP;
@@ -913,6 +918,9 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 
 	sta_apply_parameters(local, sta, params);
 
+	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER) && params->supported_rates)
+		rate_control_rate_init(sta);
+
 	rcu_read_unlock();
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
-- 
1.7.5.4

