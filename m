Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43767 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbXKPLzb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 06:55:31 -0500
Subject: [PATCH] mac80211: fix allmulti/promisc behaviour
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 16 Nov 2007 02:54:53 +0100
Message-Id: <1195178093.8147.91.camel@johannes.berg> (sfid-20071116_115534_836427_807A6FFF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When an interface with promisc/allmulti bit is taken down,
the mac80211 state can become confused. This fixes it by
making mac80211 keep track of all *active* interfaces that
have the promisc/allmulti bit set in the sdata, we sync
the interface bit into sdata at set_multicast_list() time
so this works.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
I'm 99.9% sure this is the correct fix but I need to test it.

 net/mac80211/ieee80211.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- everything.orig/net/mac80211/ieee80211.c	2007-11-16 02:43:01.668421822 +0100
+++ everything/net/mac80211/ieee80211.c	2007-11-16 02:49:56.508419055 +0100
@@ -267,6 +267,17 @@ static int ieee80211_open(struct net_dev
 		tasklet_enable(&local->tasklet);
 	}
 
+	/*
+	 * set_multicast_list will be invoked by the networking core
+	 * which will check whether any increments here were done in
+	 * error and sync them down to the hardware as filter flags.
+	 */
+	if (sdata->flags & IEEE80211_SDATA_ALLMULTI)
+		atomic_inc(&local->iff_allmultis);
+
+	if (sdata->flags & IEEE80211_SDATA_PROMISC)
+		atomic_inc(&local->iff_promiscs);
+
 	local->open_count++;
 
 	netif_start_queue(dev);
@@ -284,6 +295,18 @@ static int ieee80211_stop(struct net_dev
 
 	netif_stop_queue(dev);
 
+	/*
+	 * Don't count this interface for promisc/allmulti while it
+	 * is down. dev_mc_unsync() will invoke set_multicast_list
+	 * on the master interface which will sync these down to the
+	 * hardware as filter flags.
+	 */
+	if (sdata->flags & IEEE80211_SDATA_ALLMULTI)
+		atomic_dec(&local->iff_allmultis);
+
+	if (sdata->flags & IEEE80211_SDATA_PROMISC)
+		atomic_dec(&local->iff_promiscs);
+
 	dev_mc_unsync(local->mdev, dev);
 
 	/* down all dependent devices, that is VLANs */


