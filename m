Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42978 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYBYJut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 04:50:49 -0500
Subject: [PATCH] mac80211: add missing "break" statement in mesh code
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 10:11:50 +0100
Message-Id: <1203930711.13162.46.camel@johannes.berg> (sfid-20080225_095100_986157_14F5140B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This inserts a missing break statement which, if hit, would cause
the code to fall-through and unlock a spinlock twice. Noticed via
sparse's "lock count wrong in basic block" warning and careful
code inspection.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/mesh_plink.c |    1 +
 1 file changed, 1 insertion(+)

--- everything.orig/net/mac80211/mesh_plink.c	2008-02-24 12:22:02.000000000 +0100
+++ everything/net/mac80211/mesh_plink.c	2008-02-24 12:22:18.000000000 +0100
@@ -691,6 +691,7 @@ void mesh_rx_plink_frame(struct net_devi
 			spin_unlock_bh(&sta->plink_lock);
 			mesh_plink_frame_tx(dev, PLINK_CLOSE, sta->addr, llid,
 					    plid, reason);
+			break;
 		case OPN_ACPT:
 			if (del_timer(&sta->plink_timer))
 				sta_info_put(sta);


