Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62175 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab1HYBlH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 21:41:07 -0400
Received: by gwaa12 with SMTP id a12so1345427gwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 18:41:06 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH 1/9] mac80211: Fix RCU pointer dereference in mesh_path_discard_frame()
Date: Wed, 24 Aug 2011 18:40:44 -0700
Message-Id: <1314236452-7226-2-git-send-email-thomas@cozybit.com> (sfid-20110825_034110_891615_7CED4DF1)
In-Reply-To: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
References: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Reported by Pedro Larbig (ASPj)

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_pathtbl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 3c2bcb2..ee35f75 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -991,7 +991,9 @@ void mesh_path_discard_frame(struct sk_buff *skb,
 
 		da = hdr->addr3;
 		ra = hdr->addr1;
+		rcu_read_lock();
 		mpath = mesh_path_lookup(da, sdata);
+		rcu_read_unlock();
 		if (mpath)
 			sn = ++mpath->sn;
 		mesh_path_error_tx(sdata->u.mesh.mshcfg.element_ttl, skb->data,
-- 
1.7.4.1

