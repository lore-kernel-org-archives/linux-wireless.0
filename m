Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49752 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbXJ1Nto (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 09:49:44 -0400
Subject: [PATCH] mac80211: allow driver to ask for a rate control algorithm
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 28 Oct 2007 14:51:05 +0100
Message-Id: <1193579465.5197.9.camel@johannes.berg> (sfid-20071028_134946_895020_53CE943F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows a driver to ask for a specific rate control algorithm.
The rate control algorithm asked for must be registered and be
available as a module or built-in.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
The fix that makes rc80211 simple built-in will break Intel's drivers
because they never bothered to fix the rate control selection bugs they
have. This is required to fix those bugs.

 include/net/mac80211.h   |    5 +++++
 net/mac80211/ieee80211.c |    3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- linux-2.6.orig/include/net/mac80211.h	2007-10-28 14:23:16.625046333 +0100
+++ linux-2.6/include/net/mac80211.h	2007-10-28 14:29:51.925037218 +0100
@@ -704,11 +704,16 @@ enum ieee80211_hw_flags {
  *
  * @queues: number of available hardware transmit queues for
  *	data packets. WMM/QoS requires at least four.
+ *
+ * @rate_control_algorithm: rate control algorithm for this hardware.
+ *	If unset (NULL), the default algorithm will be used. Must be
+ *	set before calling ieee80211_register_hw().
  */
 struct ieee80211_hw {
 	struct ieee80211_conf conf;
 	struct wiphy *wiphy;
 	struct workqueue_struct *workqueue;
+	const char *rate_control_algorithm;
 	void *priv;
 	u32 flags;
 	unsigned int extra_tx_headroom;
--- linux-2.6.orig/net/mac80211/ieee80211.c	2007-10-28 14:28:46.655082356 +0100
+++ linux-2.6/net/mac80211/ieee80211.c	2007-10-28 14:29:03.805036512 +0100
@@ -1272,7 +1272,8 @@ int ieee80211_register_hw(struct ieee802
 	ieee80211_debugfs_add_netdev(IEEE80211_DEV_TO_SUB_IF(local->mdev));
 	ieee80211_if_set_type(local->mdev, IEEE80211_IF_TYPE_AP);
 
-	result = ieee80211_init_rate_ctrl_alg(local, NULL);
+	result = ieee80211_init_rate_ctrl_alg(local,
+					      hw->rate_control_algorithm);
 	if (result < 0) {
 		printk(KERN_DEBUG "%s: Failed to initialize rate control "
 		       "algorithm\n", wiphy_name(local->hw.wiphy));


