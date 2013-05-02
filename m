Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58730 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759101Ab3EBXNW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 19:13:22 -0400
Received: by mail-pb0-f46.google.com with SMTP id rq8so589499pbb.5
        for <linux-wireless@vger.kernel.org>; Thu, 02 May 2013 16:13:22 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH] mac80211: clean up mesh RCU warning
Date: Thu,  2 May 2013 16:11:19 -0700
Message-Id: <1367536279-14241-1-git-send-email-thomas@cozybit.com> (sfid-20130503_011352_995070_23B3D8AE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When running a kernel with CONFIG_PROVE_RCU, the minstrel
rate update code would complain about being called without
the RCU read lock held. This is because
mesh_sta_info_init() may or may not have been called under
RCU read lock. Perform some bureaucratic critical section
toggling to always call mesh_sta_info_init() under RCU,
and silence this warning.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_plink.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 09bebed..4058bd7 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -473,13 +473,15 @@ mesh_sta_info_get(struct ieee80211_sub_if_data *sdata,
 		rcu_read_unlock();
 		/* can't run atomic */
 		sta = mesh_sta_info_alloc(sdata, addr, elems);
-		if (!sta) {
-			rcu_read_lock();
+
+		rcu_read_lock();
+		if (!sta)
 			return NULL;
-		}
 
 		mesh_sta_info_init(sdata, sta, elems, true);
 
+		rcu_read_unlock();
+		/* also might sleep */
 		if (sta_info_insert_rcu(sta))
 			return NULL;
 	}
-- 
1.7.10.4

