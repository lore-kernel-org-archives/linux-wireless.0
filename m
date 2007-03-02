Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48629 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992432AbXCBN3g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2007 08:29:36 -0500
Subject: [PATCH] add privid field to wiphy
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain
Date: Fri, 02 Mar 2007 14:29:10 +0100
Message-Id: <1172842150.3482.41.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While working on more sysfs removal (moving all the per-netdev stuff as
well) I noticed that we have no easy way to tell, given a netdev,
whether it belongs to a wiphy mac80211 controls or maybe somebody else.

This patch adds a void *privid field to the wiphy that you can assign to
something global in the driver/stack module to find out whether the
wiphy belongs to you or not when given a netdev with ieee80211_ptr, a
wireless dev or a wiphy by some other code.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
netdevs aren't notified themselves if the name changes but we can
install a notifier chain handler for that, but then need to find out
whether the netdev is ours or not :)

---
 include/net/wireless.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- wireless-dev.orig/include/net/wireless.h	2007-03-02 14:24:02.184333268 +0100
+++ wireless-dev/include/net/wireless.h	2007-03-02 14:25:46.634333268 +0100
@@ -23,6 +23,13 @@ struct wiphy {
 	/* permanent MAC address */
 	u8 perm_addr[ETH_ALEN];
 
+	/* If multiple wiphys are registered and you're handed e.g.
+	 * a regular netdev with assigned ieee80211_ptr, you won't
+	 * know whether it points to a wiphy your driver has registered
+	 * or not. Assign this to something global to your driver to
+	 * help determine whether you own this wiphy or not. */
+	void *privid;
+
 	/* fields below are read-only, assigned by cfg80211 */
 
 	/* the item in /sys/class/ieee80211/ points to this,


