Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42372 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782AbYBYUgm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 15:36:42 -0500
Subject: [PATCH] mac80211: fix kernel-doc comment for mesh_plink_deactivate
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 21:36:27 +0100
Message-Id: <1203971787.13162.159.camel@johannes.berg> (sfid-20080225_203646_889989_134141A7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Accidentally copied in a __mesh_plink_deactivate, noticed by Luis
Carlos Cobo.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mesh_plink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- everything.orig/net/mac80211/mesh_plink.c	2008-02-25 21:33:56.000000000 +0100
+++ everything/net/mac80211/mesh_plink.c	2008-02-25 21:34:03.000000000 +0100
@@ -141,21 +141,21 @@ static void __mesh_plink_deactivate(stru
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
 	if (sta->plink_state == ESTAB)
 		mesh_plink_dec_estab_count(sdata);
 	sta->plink_state = BLOCKED;
 	mesh_path_flush_by_nexthop(sta);
 }
 
 /**
- * __mesh_plink_deactivate - deactivate mesh peer link
+ * mesh_plink_deactivate - deactivate mesh peer link
  *
  * @sta: mesh peer link to deactivate
  *
  * All mesh paths with this peer as next hop will be flushed
  */
 void mesh_plink_deactivate(struct sta_info *sta)
 {
 	spin_lock_bh(&sta->plink_lock);
 	__mesh_plink_deactivate(sta);
 	spin_unlock_bh(&sta->plink_lock);


