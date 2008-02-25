Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54666 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbYBYPPW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 10:15:22 -0500
Subject: [PATCH] mac80211: export mesh_plink_broken
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Carlos Cobo <luisca@cozybit.com>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 16:15:06 +0100
Message-Id: <1203952506.13162.105.camel@johannes.berg> (sfid-20080225_151530_294590_0E721D92)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This needs to be exported because rate control algorithms
can be modular.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mesh_pathtbl.c |    1 +
 1 file changed, 1 insertion(+)

--- everything.orig/net/mac80211/mesh_pathtbl.c	2008-02-25 16:14:08.000000000 +0100
+++ everything/net/mac80211/mesh_pathtbl.c	2008-02-25 16:14:15.000000000 +0100
@@ -257,6 +257,7 @@ void mesh_plink_broken(struct sta_info *
 	}
 	rcu_read_unlock();
 }
+EXPORT_SYMBOL(mesh_plink_broken);
 
 /**
  * mesh_path_flush_by_nexthop - Deletes mesh paths if their next hop matches


