Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52386 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab2FSOv2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 10:51:28 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 16/17] mac80211: make ieee80211_check_concurrent_iface netdev-independent
Date: Tue, 19 Jun 2012 16:50:55 +0200
Message-Id: <1340117456-10154-17-git-send-email-johannes@sipsolutions.net> (sfid-20120619_165135_897292_244300BF)
In-Reply-To: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
References: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

ieee80211_check_concurrent_iface() need not use the
netdev. Remove the use of the netdev here to prepare
the function for P2P device addition.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index cf598d8..b64c38a8 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -100,15 +100,12 @@ static int ieee80211_check_concurrent_iface(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_sub_if_data *nsdata;
-	struct net_device *dev = sdata->dev;
 
 	ASSERT_RTNL();
 
 	/* we hold the RTNL here so can safely walk the list */
 	list_for_each_entry(nsdata, &local->interfaces, list) {
-		struct net_device *ndev = nsdata->dev;
-
-		if (ndev != dev && ieee80211_sdata_running(nsdata)) {
+		if (nsdata != sdata && ieee80211_sdata_running(nsdata)) {
 			/*
 			 * Allow only a single IBSS interface to be up at any
 			 * time. This is restricted because beacon distribution
@@ -127,7 +124,8 @@ static int ieee80211_check_concurrent_iface(struct ieee80211_sub_if_data *sdata,
 			 * The remaining checks are only performed for interfaces
 			 * with the same MAC address.
 			 */
-			if (!ether_addr_equal(dev->dev_addr, ndev->dev_addr))
+			if (!ether_addr_equal(sdata->vif.addr,
+					      nsdata->vif.addr))
 				continue;
 
 			/*
-- 
1.7.10

