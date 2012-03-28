Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37325 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757736Ab2C1JGQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 05:06:16 -0400
Message-Id: <20120328090432.701363420@sipsolutions.net> (sfid-20120328_110624_704396_7E9719A2)
Date: Wed, 28 Mar 2012 11:04:26 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/7] mac80211: decouple # of netdev queues from HW queues
References: <20120328090422.367469100@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When we get more hardware queues, we'll still want
to only have netdev queues per AC, so set it up in
that way. If the hardware doesn't support QoS (by
not supporting at least 4 queues) the netdevs get
a single queue only (this is no change in behavior
as there are no drivers with 2 or 3 queues today.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c |    6 +++++-
 net/mac80211/wme.c   |    2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/net/mac80211/iface.c	2012-03-23 17:11:52.000000000 +0100
+++ b/net/mac80211/iface.c	2012-03-23 17:11:54.000000000 +0100
@@ -1133,11 +1133,15 @@ int ieee80211_if_add(struct ieee80211_lo
 	struct net_device *ndev;
 	struct ieee80211_sub_if_data *sdata = NULL;
 	int ret, i;
+	int txqs = 1;
 
 	ASSERT_RTNL();
 
+	if (local->hw.queues >= IEEE80211_NUM_ACS)
+		txqs = IEEE80211_NUM_ACS;
+
 	ndev = alloc_netdev_mqs(sizeof(*sdata) + local->hw.vif_data_size,
-				name, ieee80211_if_setup, local->hw.queues, 1);
+				name, ieee80211_if_setup, txqs, 1);
 	if (!ndev)
 		return -ENOMEM;
 	dev_net_set(ndev, wiphy_net(local->hw.wiphy));
--- a/net/mac80211/wme.c	2012-03-23 17:11:52.000000000 +0100
+++ b/net/mac80211/wme.c	2012-03-23 17:11:54.000000000 +0100
@@ -108,7 +108,7 @@ u16 ieee80211_select_queue(struct ieee80
 
 	if (local->hw.queues < 4 || skb->len < 6) {
 		skb->priority = 0; /* required for correct WPA/11i MIC */
-		return min_t(u16, local->hw.queues - 1, IEEE80211_AC_BE);
+		return 0;
 	}
 
 	rcu_read_lock();


