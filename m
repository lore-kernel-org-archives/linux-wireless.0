Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:38644 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933314AbZHHDnl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 23:43:41 -0400
Received: by mail-pz0-f196.google.com with SMTP id 34so1941429pzk.4
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2009 20:43:42 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, andrey@cozybit.com,
	johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org
Subject: [PATCH] mac80211: Early detection of broken mesh paths when using minstrel.
Date: Fri,  7 Aug 2009 20:31:52 -0700
Message-Id: <1249702314-32504-7-git-send-email-javier@cozybit.com>
In-Reply-To: <1249702314-32504-6-git-send-email-javier@cozybit.com>
References: <>
 <1249702314-32504-1-git-send-email-javier@cozybit.com>
 <1249702314-32504-2-git-send-email-javier@cozybit.com>
 <1249702314-32504-3-git-send-email-javier@cozybit.com>
 <1249702314-32504-4-git-send-email-javier@cozybit.com>
 <1249702314-32504-5-git-send-email-javier@cozybit.com>
 <1249702314-32504-6-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_hwmp.c        |    1 -
 net/mac80211/rc80211_minstrel.c |    8 +++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index b4309b2..1cd1e72 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -272,7 +272,6 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 	}
 
 	last_hop_metric = airtime_link_metric_get(local, sta);
-	printk("XXX: last_hop_metric = %d\n", last_hop_metric);
 	/* Update and check originator routing info */
 	fresh_info = true;
 
diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 3ea9740..0071649 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -51,6 +51,7 @@
 #include <linux/random.h>
 #include <linux/ieee80211.h>
 #include <net/mac80211.h>
+#include "mesh.h"
 #include "rate.h"
 #include "rc80211_minstrel.h"
 
@@ -178,9 +179,14 @@ minstrel_tx_status(void *priv, struct ieee80211_supported_band *sband,
 
 		if ((i != IEEE80211_TX_MAX_RATES - 1) && (ar[i + 1].idx < 0)) {
 			mi->r[ndx].success += success;
-			if (si)
+			if (si) {
 				si->fail_avg = (18050 - mi->r[ndx].probability)
 					/ 180;
+				WARN_ON(si->fail_avg > 100);
+				if (si->fail_avg == 100 &&
+					ieee80211_vif_is_mesh(&si->sdata->vif))
+					mesh_plink_broken(si);
+			}
 		}
 	}
 
-- 
1.5.4.3

