Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:43325 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbZHJT1o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 15:27:44 -0400
Received: by mail-pz0-f196.google.com with SMTP id 34so3033885pzk.4
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2009 12:27:46 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, andrey@cozybit.com,
	johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org
Subject: [PATCH 6/7] mac80211: Assign a default mesh beaconing interval.
Date: Mon, 10 Aug 2009 12:15:51 -0700
Message-Id: <1249931752-18127-7-git-send-email-javier@cozybit.com>
In-Reply-To: <1249931752-18127-6-git-send-email-javier@cozybit.com>
References: <20090810175225.GF2733@tuxdriver.com>
 <1249931752-18127-1-git-send-email-javier@cozybit.com>
 <1249931752-18127-2-git-send-email-javier@cozybit.com>
 <1249931752-18127-3-git-send-email-javier@cozybit.com>
 <1249931752-18127-4-git-send-email-javier@cozybit.com>
 <1249931752-18127-5-git-send-email-javier@cozybit.com>
 <1249931752-18127-6-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mesh stack was enabling beaconing without specifying an interval.  This
patch defines a default beaconing interval of 1s.

Incidentally, this fixes mesh beaconing in mac80211_hwsim devices.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh.c |    6 ++++--
 net/mac80211/mesh.h |    1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 10d9338..25d0065 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -525,9 +525,11 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_local *local = sdata->local;
 
 	ifmsh->housekeeping = true;
-	ieee80211_queue_work(&local->hw, &ifmsh->work);
+	queue_work(local->hw, &ifmsh->work);
+	sdata->vif.bss_conf.beacon_int = MESH_DEFAULT_BEACON_INTERVAL;
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON |
-						BSS_CHANGED_BEACON_ENABLED);
+						BSS_CHANGED_BEACON_ENABLED |
+						BSS_CHANGED_BEACON_INT);
 }
 
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 2ebd74c..4241925 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -174,6 +174,7 @@ struct mesh_rmc {
  */
 #define MESH_PATH_REFRESH_TIME			1000
 #define MESH_MIN_DISCOVERY_TIMEOUT (2 * MESH_DIAM_TRAVERSAL_TIME)
+#define MESH_DEFAULT_BEACON_INTERVAL		1000 	/* in 1024 us units */
 
 #define MESH_MAX_PREQ_RETRIES 4
 #define MESH_PATH_EXPIRE (600 * HZ)
-- 
1.5.4.3

