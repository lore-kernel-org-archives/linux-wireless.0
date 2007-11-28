Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52508 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758016AbXK1N1F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 08:27:05 -0500
Subject: [PATCH] mac80211: make ieee80211_iterate_active_interfaces not
	need rtnl
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 28 Nov 2007 10:55:32 +0100
Message-Id: <1196243733.6058.117.camel@johannes.berg> (sfid-20071128_132710_226273_17F224E5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Interface iteration in mac80211 can be done without holding any
locks because I converted it to RCU. Initially, I thought this
wouldn't be needed for ieee80211_iterate_active_interfaces but
it's turning out that multi-BSS AP support can be much simpler
in a driver if ieee80211_iterate_active_interfaces can be called
without holding locks. This converts it to use RCU, it adds a
requirement that the callback it invokes cannot sleep.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |    3 +--
 net/mac80211/util.c    |    7 ++++---
 2 files changed, 5 insertions(+), 5 deletions(-)

--- everything.orig/include/net/mac80211.h	2007-11-28 01:24:04.030767632 +0100
+++ everything/include/net/mac80211.h	2007-11-28 10:51:18.718922797 +0100
@@ -1408,10 +1408,9 @@ void ieee80211_scan_completed(struct iee
  *
  * This function iterates over the interfaces associated with a given
  * hardware that are currently active and calls the callback for them.
- * Must be called under RTNL.
  *
  * @hw: the hardware struct of which the interfaces should be iterated over
- * @iterator: the iterator function to call
+ * @iterator: the iterator function to call, cannot sleep
  * @data: first argument of the iterator function
  */
 void ieee80211_iterate_active_interfaces(struct ieee80211_hw *hw,
--- everything.orig/net/mac80211/util.c	2007-11-28 01:24:24.310766384 +0100
+++ everything/net/mac80211/util.c	2007-11-28 01:26:40.510763509 +0100
@@ -482,10 +482,9 @@ void ieee80211_iterate_active_interfaces
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
 
-	ASSERT_RTNL();
+	rcu_read_lock();
 
-	/* we hold the RTNL here so can safely walk the list */
-	list_for_each_entry(sdata, &local->interfaces, list) {
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		switch (sdata->type) {
 		case IEEE80211_IF_TYPE_INVALID:
 		case IEEE80211_IF_TYPE_MNTR:
@@ -504,5 +503,7 @@ void ieee80211_iterate_active_interfaces
 			iterator(data, sdata->dev->dev_addr,
 				 sdata->dev->ifindex);
 	}
+
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces);


