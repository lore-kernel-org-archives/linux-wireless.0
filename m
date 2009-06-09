Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49426 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbZFIOTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 10:19:02 -0400
Subject: [PATCH] mac80211: don't use master netdev name
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 09 Jun 2009 16:18:32 +0200
Message-Id: <1244557112.4672.20.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Always use the wiphy name instead.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c  |    4 ++--
 net/mac80211/mlme.c |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-06-09 16:17:44.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-06-09 16:17:47.000000000 +0200
@@ -793,13 +793,13 @@ static void ieee80211_sta_wmm_params(str
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		printk(KERN_DEBUG "%s: WMM queue=%d aci=%d acm=%d aifs=%d "
 		       "cWmin=%d cWmax=%d txop=%d\n",
-		       local->mdev->name, queue, aci, acm, params.aifs, params.cw_min,
-		       params.cw_max, params.txop);
+		       wiphy_name(local->hw.wiphy), queue, aci, acm,
+		       params.aifs, params.cw_min, params.cw_max, params.txop);
 #endif
 		if (drv_conf_tx(local, queue, &params) && local->ops->conf_tx)
 			printk(KERN_DEBUG "%s: failed to set TX queue "
-			       "parameters for queue %d\n", local->mdev->name,
-			       queue);
+			       "parameters for queue %d\n",
+			       wiphy_name(local->hw.wiphy), queue);
 	}
 }
 
--- wireless-testing.orig/net/mac80211/cfg.c	2009-06-09 16:17:44.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-06-09 16:17:47.000000000 +0200
@@ -1122,8 +1122,8 @@ static int ieee80211_set_txq_params(stru
 	p.txop = params->txop;
 	if (drv_conf_tx(local, params->queue, &p)) {
 		printk(KERN_DEBUG "%s: failed to set TX queue "
-		       "parameters for queue %d\n", local->mdev->name,
-		       params->queue);
+		       "parameters for queue %d\n",
+		       wiphy_name(local->hw.wiphy), params->queue);
 		return -EINVAL;
 	}
 


