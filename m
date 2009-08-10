Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:43325 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbZHJT1k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 15:27:40 -0400
Received: by mail-pz0-f196.google.com with SMTP id 34so3033885pzk.4
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2009 12:27:41 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, andrey@cozybit.com,
	johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org
Subject: [PATCH 5/7] mac80211: Early detection of broken mesh paths when using minstrel.
Date: Mon, 10 Aug 2009 12:15:50 -0700
Message-Id: <1249931752-18127-6-git-send-email-javier@cozybit.com>
In-Reply-To: <1249931752-18127-5-git-send-email-javier@cozybit.com>
References: <20090810175225.GF2733@tuxdriver.com>
 <1249931752-18127-1-git-send-email-javier@cozybit.com>
 <1249931752-18127-2-git-send-email-javier@cozybit.com>
 <1249931752-18127-3-git-send-email-javier@cozybit.com>
 <1249931752-18127-4-git-send-email-javier@cozybit.com>
 <1249931752-18127-5-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This change triggers a path discovery as soon as the link quality degrades
below a certain threshold.  This results in a faster path recovery time than
by simply relying on the periodic path refresh mechanism to detect broken
links.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/rc80211_minstrel.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

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

