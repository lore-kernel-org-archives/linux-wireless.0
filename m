Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50547 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbXFTLSo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2007 07:18:44 -0400
Subject: [PATCH] clarify some mac80211 things
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 20 Jun 2007 12:05:59 +0200
Message-Id: <1182333960.3714.54.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The semantics of not having an add_interface callback are not well
defined, this callback is required because otherwise you cannot obtain
the requested MAC address of the device. Change the documentation to
reflect this, add a note about having no MAC address at all, add a
warning that mac_addr in struct ieee80211_if_init_conf can be NULL and
finally verify that a few callbacks are assigned by way of BUG_ON()

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/net/mac80211.h   |   16 ++++++++++++----
 net/mac80211/ieee80211.c |   29 ++++++++++++-----------------
 2 files changed, 24 insertions(+), 21 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-06-20 11:47:09.327357152 +0200
+++ wireless-dev/include/net/mac80211.h	2007-06-20 12:00:13.137357152 +0200
@@ -346,9 +346,16 @@ enum ieee80211_if_types {
  * @mac_addr: pointer to MAC address of the interface. This pointer is valid
  *	until the interface is removed (i.e. it cannot be used after
  *	remove_interface() callback was called for this interface).
+ *	This pointer will be %NULL for monitor interfaces, be careful.
  *
  * This structure is used in add_interface() and remove_interface()
  * callbacks of &struct ieee80211_hw.
+ *
+ * When you allow multiple interfaces to be added to your PHY, take care
+ * that the hardware can actually handle multiple MAC addresses. However,
+ * also take care that when there's no interface left with mac_addr != %NULL
+ * you remove the MAC address from the device to avoid acknowledging packets
+ * in pure monitor mode.
  */
 struct ieee80211_if_init_conf {
 	int if_id;
@@ -576,10 +583,11 @@ struct ieee80211_ops {
 	 * to returning zero. By returning non-zero addition of the interface
 	 * is inhibited. Unless monitor_during_oper is set, it is guaranteed
 	 * that monitor interfaces and normal interfaces are mutually
-	 * exclusive. The open() handler is called after add_interface()
-	 * if this is the first device added. At least one of the open()
-	 * open() and add_interface() callbacks has to be assigned. If
-	 * add_interface() is NULL, one STA interface is permitted only. */
+	 * exclusive. If assigned, the open() handler is called after
+	 * add_interface() if this is the first device added. The
+	 * add_interface() callback has to be assigned because it is the only
+	 * way to obtain the requested MAC address for any interface.
+	 */
 	int (*add_interface)(struct ieee80211_hw *hw,
 			     struct ieee80211_if_init_conf *conf);
 
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-06-20 11:53:35.147357152 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-06-20 11:58:24.137357152 +0200
@@ -2384,8 +2384,7 @@ static void ieee80211_start_hard_monitor
 	struct ieee80211_if_init_conf conf;
 
 	if (local->open_count && local->open_count == local->monitors &&
-	    !(local->hw.flags & IEEE80211_HW_MONITOR_DURING_OPER) &&
-	    local->ops->add_interface) {
+	    !(local->hw.flags & IEEE80211_HW_MONITOR_DURING_OPER)) {
 		conf.if_id = -1;
 		conf.type = IEEE80211_IF_TYPE_MNTR;
 		conf.mac_addr = NULL;
@@ -2428,21 +2427,14 @@ static int ieee80211_open(struct net_dev
 	}
 	ieee80211_start_soft_monitor(local);
 
-	if (local->ops->add_interface) {
-		conf.if_id = dev->ifindex;
-		conf.type = sdata->type;
-		conf.mac_addr = dev->dev_addr;
-		res = local->ops->add_interface(local_to_hw(local), &conf);
-		if (res) {
-			if (sdata->type == IEEE80211_IF_TYPE_MNTR)
-				ieee80211_start_hard_monitor(local);
-			return res;
-		}
-	} else {
-		if (sdata->type != IEEE80211_IF_TYPE_STA)
-			return -EOPNOTSUPP;
-		if (local->open_count > 0)
-			return -ENOBUFS;
+	conf.if_id = dev->ifindex;
+	conf.type = sdata->type;
+	conf.mac_addr = dev->dev_addr;
+	res = local->ops->add_interface(local_to_hw(local), &conf);
+	if (res) {
+		if (sdata->type == IEEE80211_IF_TYPE_MNTR)
+			ieee80211_start_hard_monitor(local);
+		return res;
 	}
 
 	if (local->open_count == 0) {
@@ -4763,6 +4755,9 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 			 ((sizeof(struct ieee80211_local) +
 			   NETDEV_ALIGN_CONST) & ~NETDEV_ALIGN_CONST);
 
+	BUG_ON(!ops->tx);
+	BUG_ON(!ops->config);
+	BUG_ON(!ops->add_interface);
 	local->ops = ops;
 
 	/* for now, mdev needs sub_if_data :/ */


