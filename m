Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49685 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab1KGVYt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 16:24:49 -0500
Received: by wwi36 with SMTP id 36so7342083wwi.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Nov 2011 13:24:48 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2] mac80211: init rate-control for TDLS sta when supp-rates are known
Date: Mon,  7 Nov 2011 23:24:39 +0200
Message-Id: <1320701079-5584-1-git-send-email-arik@wizery.com> (sfid-20111107_222452_883011_42F65E9D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialize rate control algorithms only when supported rates are known
for a TDLS peer sta. Direct Tx between peers is not allowed before the
link is enabled. In turn, this only occurs after a change_station()
call that sets supported rates.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
v1->2: rebase on top of wireless-testing

net/mac80211/cfg.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a9ded52..8f774cb 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -847,7 +847,12 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 
 	sta_apply_parameters(local, sta, params);
 
-	rate_control_rate_init(sta);
+	/*
+	 * for TDLS, rate control should be initialized only when supported
+	 * rates are known.
+	 */
+	if (!test_sta_flag(sta, WLAN_STA_TDLS_PEER))
+		rate_control_rate_init(sta);
 
 	layer2_update = sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
 		sdata->vif.type == NL80211_IFTYPE_AP;
@@ -931,6 +936,9 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 
 	sta_apply_parameters(local, sta, params);
 
+	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER) && params->supported_rates)
+		rate_control_rate_init(sta);
+
 	rcu_read_unlock();
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
-- 
1.7.5.4

