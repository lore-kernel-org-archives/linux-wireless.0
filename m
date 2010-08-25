Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36057 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab0HYU6W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Aug 2010 16:58:22 -0400
Message-Id: <20100825205726.741362601@sipsolutions.net>
Date: Wed, 25 Aug 2010 22:56:22 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 3/6] mac80211: simplify zero address checks
References: <20100825205619.152295081@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The libertas_tf special code for zero addresses
is a bit too complex, it compares against a stack
value instead of using is_zero_ether_addr() and
tries to update all interfaces even if just the
one that's being brought up needs to be changed.
Additionally, the repeated check for a valid MAC
address need only be done if we actually changed
it on the fly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c |   38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

--- wireless-testing.orig/net/mac80211/iface.c	2010-08-25 21:59:11.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2010-08-25 22:01:50.000000000 +0200
@@ -103,10 +103,9 @@ static int ieee80211_open(struct net_dev
 	u32 changed = 0;
 	int res;
 	u32 hw_reconf_flags = 0;
-	u8 null_addr[ETH_ALEN] = {0};
 
 	/* fail early if user set an invalid address */
-	if (compare_ether_addr(dev->dev_addr, null_addr) &&
+	if (!is_zero_ether_addr(dev->dev_addr) &&
 	    !is_valid_ether_addr(dev->dev_addr))
 		return -EADDRNOTAVAIL;
 
@@ -195,33 +194,22 @@ static int ieee80211_open(struct net_dev
 	}
 
 	/*
-	 * Check all interfaces and copy the hopefully now-present
-	 * MAC address to those that have the special null one.
+	 * Copy the hopefully now-present MAC address to
+	 * this interface, if it has the special null one.
 	 */
-	list_for_each_entry(nsdata, &local->interfaces, list) {
-		struct net_device *ndev = nsdata->dev;
-
-		/*
-		 * No need to check running since we do not allow
-		 * it to start up with this invalid address.
-		 */
-		if (compare_ether_addr(null_addr, ndev->dev_addr) == 0) {
-			memcpy(ndev->dev_addr,
-			       local->hw.wiphy->perm_addr,
-			       ETH_ALEN);
-			memcpy(ndev->perm_addr, ndev->dev_addr, ETH_ALEN);
+	if (is_zero_ether_addr(dev->dev_addr)) {
+		memcpy(dev->dev_addr,
+		       local->hw.wiphy->perm_addr,
+		       ETH_ALEN);
+		memcpy(dev->perm_addr, dev->dev_addr, ETH_ALEN);
+
+		if (!is_valid_ether_addr(dev->dev_addr)) {
+			if (!local->open_count)
+				drv_stop(local);
+			return -EADDRNOTAVAIL;
 		}
 	}
 
-	/*
-	 * Validate the MAC address for this device.
-	 */
-	if (!is_valid_ether_addr(dev->dev_addr)) {
-		if (!local->open_count)
-			drv_stop(local);
-		return -EADDRNOTAVAIL;
-	}
-
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP_VLAN:
 		/* no need to tell driver */


