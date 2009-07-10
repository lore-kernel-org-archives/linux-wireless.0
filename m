Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42936 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231AbZGJNSQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 09:18:16 -0400
Subject: [PATCH] mac80211: mesh: fix two small problems
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 11:39:26 +0200
Message-Id: <1247218766.1905.20.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

1) there's a spin_lock() that needs to be spin_lock_bh()
2) action frames of size 24 might cause an out-of-bounds
   memory access (for the 25th byte only, so no big deal)

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mesh.c      |    5 ++++-
 net/mac80211/mesh_hwmp.c |    6 +++---
 2 files changed, 7 insertions(+), 4 deletions(-)

--- wireless-testing.orig/net/mac80211/mesh_hwmp.c	2009-07-10 11:03:05.000000000 +0200
+++ wireless-testing/net/mac80211/mesh_hwmp.c	2009-07-10 11:03:18.000000000 +0200
@@ -686,11 +686,11 @@ void mesh_path_start_discovery(struct ie
 	u8 ttl, dst_flags;
 	u32 lifetime;
 
-	spin_lock(&ifmsh->mesh_preq_queue_lock);
+	spin_lock_bh(&ifmsh->mesh_preq_queue_lock);
 	if (!ifmsh->preq_queue_len ||
 		time_before(jiffies, ifmsh->last_preq +
 				min_preq_int_jiff(sdata))) {
-		spin_unlock(&ifmsh->mesh_preq_queue_lock);
+		spin_unlock_bh(&ifmsh->mesh_preq_queue_lock);
 		return;
 	}
 
@@ -698,7 +698,7 @@ void mesh_path_start_discovery(struct ie
 			struct mesh_preq_queue, list);
 	list_del(&preq_node->list);
 	--ifmsh->preq_queue_len;
-	spin_unlock(&ifmsh->mesh_preq_queue_lock);
+	spin_unlock_bh(&ifmsh->mesh_preq_queue_lock);
 
 	rcu_read_lock();
 	mpath = mesh_path_lookup(preq_node->dst, sdata);
--- wireless-testing.orig/net/mac80211/mesh.c	2009-07-10 11:20:36.000000000 +0200
+++ wireless-testing/net/mac80211/mesh.c	2009-07-10 11:20:44.000000000 +0200
@@ -685,9 +685,12 @@ ieee80211_mesh_rx_mgmt(struct ieee80211_
 	fc = le16_to_cpu(mgmt->frame_control);
 
 	switch (fc & IEEE80211_FCTL_STYPE) {
+	case IEEE80211_STYPE_ACTION:
+		if (skb->len < IEEE80211_MIN_ACTION_SIZE)
+			return RX_DROP_MONITOR;
+		/* fall through */
 	case IEEE80211_STYPE_PROBE_RESP:
 	case IEEE80211_STYPE_BEACON:
-	case IEEE80211_STYPE_ACTION:
 		skb_queue_tail(&ifmsh->skb_queue, skb);
 		queue_work(local->hw.workqueue, &ifmsh->work);
 		return RX_QUEUED;


