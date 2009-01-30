Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57913 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbZA3Mg2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 07:36:28 -0500
Subject: [PATCH] mac80211: convert master interface to netdev_ops
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 13:36:25 +0100
Message-Id: <1233318985.4201.4.camel@johannes.local> (sfid-20090130_133632_933021_58FFC39F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also call our own ieee80211_master_setup routine instead of
overwriting almost all the values from ether_setup; this
loses a few assignments that are pointless on the master
interface anyway.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/main.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

--- wireless-testing.orig/net/mac80211/main.c	2009-01-30 13:21:45.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-01-30 13:22:43.000000000 +0100
@@ -791,6 +791,23 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 }
 EXPORT_SYMBOL(ieee80211_alloc_hw);
 
+static const struct net_device_ops ieee80211_master_ops = {
+	.ndo_start_xmit = ieee80211_master_start_xmit,
+	.ndo_open = ieee80211_master_open,
+	.ndo_stop = ieee80211_master_stop,
+	.ndo_set_multicast_list = ieee80211_master_set_multicast_list,
+	.ndo_select_queue = ieee80211_select_queue,
+};
+
+static void ieee80211_master_setup(struct net_device *mdev)
+{
+	mdev->type = ARPHRD_IEEE80211;
+	mdev->netdev_ops = &ieee80211_master_ops;
+	mdev->header_ops = &ieee80211_header_ops;
+	mdev->tx_queue_len = 1000;
+	mdev->addr_len = ETH_ALEN;
+}
+
 int ieee80211_register_hw(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
@@ -840,7 +857,7 @@ int ieee80211_register_hw(struct ieee802
 		hw->ampdu_queues = 0;
 
 	mdev = alloc_netdev_mq(sizeof(struct ieee80211_master_priv),
-			       "wmaster%d", ether_setup,
+			       "wmaster%d", ieee80211_master_setup,
 			       ieee80211_num_queues(hw));
 	if (!mdev)
 		goto fail_mdev_alloc;
@@ -851,13 +868,6 @@ int ieee80211_register_hw(struct ieee802
 
 	ieee80211_rx_bss_list_init(local);
 
-	mdev->hard_start_xmit = ieee80211_master_start_xmit;
-	mdev->open = ieee80211_master_open;
-	mdev->stop = ieee80211_master_stop;
-	mdev->type = ARPHRD_IEEE80211;
-	mdev->header_ops = &ieee80211_header_ops;
-	mdev->set_multicast_list = ieee80211_master_set_multicast_list;
-
 	local->hw.workqueue =
 		create_singlethread_workqueue(wiphy_name(local->hw.wiphy));
 	if (!local->hw.workqueue) {
@@ -924,8 +934,6 @@ int ieee80211_register_hw(struct ieee802
 		goto fail_wep;
 	}
 
-	local->mdev->select_queue = ieee80211_select_queue;
-
 	/* add one default STA interface if supported */
 	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_STATION)) {
 		result = ieee80211_if_add(local, "wlan%d", NULL,


