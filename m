Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42931 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbZGJNQx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 09:16:53 -0400
Subject: [PATCH v2.6.31] mac80211: disable mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Javier Cardona <javier@cozybit.com>,
	Andrey Yurovsky <andrey@cozybit.com>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 11:38:14 +0200
Message-Id: <1247218695.1905.18.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My kvm instance was complaining a lot about sleeping
in atomic contexts in the mesh code, and it turns out
that both mesh_path_add() and mpp_path_add() need to
be able to sleep (they even use synchronize_rcu()!).
I put in a might_sleep() to annotate that, but I see
no way, at least right now, of actually making sure
those functions are only called from process context
since they are both called during TX and RX and the
mesh code itself even calls them with rcu_read_lock()
"held".

Therefore, let's disable it completely for now.

It's possible that I'm only seeing this because the
hwsim's beaconing is broken and thus the peers aren't
discovered right away, but it is possible that this
happens even if beaconing is working, for a peer that
doesn't exist or so.

It should be possible to solve this by deferring the
freeing of the tables to call_rcu() instead of using
synchronize_rcu(), and also using atomic allocations,
but maybe it makes more sense to rework the code to
not call these from atomic contexts and defer more of
the work to the workqueue. Right now, I can't work on
either of those solutions though.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Javier, sorry -- I don't see how this could ever have
worked?

 net/mac80211/Kconfig        |    1 +
 net/mac80211/mesh_pathtbl.c |    3 +++
 2 files changed, 4 insertions(+)

--- wireless-testing.orig/net/mac80211/mesh_pathtbl.c	2009-07-10 11:27:09.000000000 +0200
+++ wireless-testing/net/mac80211/mesh_pathtbl.c	2009-07-10 11:28:49.000000000 +0200
@@ -175,6 +175,8 @@ int mesh_path_add(u8 *dst, struct ieee80
 	int err = 0;
 	u32 hash_idx;
 
+	might_sleep();
+
 	if (memcmp(dst, sdata->dev->dev_addr, ETH_ALEN) == 0)
 		/* never add ourselves as neighbours */
 		return -ENOTSUPP;
@@ -265,6 +267,7 @@ int mpp_path_add(u8 *dst, u8 *mpp, struc
 	int err = 0;
 	u32 hash_idx;
 
+	might_sleep();
 
 	if (memcmp(dst, sdata->dev->dev_addr, ETH_ALEN) == 0)
 		/* never add ourselves as neighbours */
--- wireless-testing.orig/net/mac80211/Kconfig	2009-07-10 11:28:57.000000000 +0200
+++ wireless-testing/net/mac80211/Kconfig	2009-07-10 11:29:05.000000000 +0200
@@ -67,6 +67,7 @@ endmenu
 config MAC80211_MESH
 	bool "Enable mac80211 mesh networking (pre-802.11s) support"
 	depends on MAC80211 && EXPERIMENTAL
+	depends on BROKEN
 	---help---
 	 This options enables support of Draft 802.11s mesh networking.
 	 The implementation is based on Draft 1.08 of the Mesh Networking


