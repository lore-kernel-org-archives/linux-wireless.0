Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:51827 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbZHRAVb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 20:21:31 -0400
Received: by rv-out-0506.google.com with SMTP id f6so878818rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2009 17:21:33 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, andrey@cozybit.com,
	johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org
Subject: [PATCH] mac80211: Decouple fail_avg stats used by mesh from rate control algorithm.
Date: Mon, 17 Aug 2009 17:09:40 -0700
Message-Id: <1250554180-30646-1-git-send-email-javier@cozybit.com>
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh uses the tx failure average to compute the (m)path metric.  This used to
be done inside the rate control module.  This patch breaks the dependency
between the mesh stack and the rate control algorithm.  Mesh will now work
independently of the chosen rate control algorithm.

The mesh stack keeps a moving average of the average transmission losses for
each mesh peer station.  If the fail average exceeds a certain threshold, the
peer link is marked as broken.
---
 net/mac80211/main.c             |    2 ++
 net/mac80211/mesh.h             |    2 ++
 net/mac80211/mesh_hwmp.c        |   18 ++++++++++++++++++
 net/mac80211/rc80211_minstrel.c |   16 +---------------
 net/mac80211/rc80211_pid_algo.c |   15 +--------------
 5 files changed, 24 insertions(+), 29 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 3302df9..f80efd7 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -482,6 +482,8 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 		}
 
 		rate_control_tx_status(local, sband, sta, skb);
+		if (ieee80211_vif_is_mesh(&sta->sdata->vif))
+			ieee80211s_update_metric(local, sta, skb);
 	}
 
 	rcu_read_unlock();
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index eb23fc6..dd1c193 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -226,6 +226,8 @@ void mesh_mgmt_ies_add(struct sk_buff *skb,
 void mesh_rmc_free(struct ieee80211_sub_if_data *sdata);
 int mesh_rmc_init(struct ieee80211_sub_if_data *sdata);
 void ieee80211s_init(void);
+void ieee80211s_update_metric(struct ieee80211_local *local,
+		struct sta_info *stainfo, struct sk_buff *skb);
 void ieee80211s_stop(void);
 void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata);
 ieee80211_rx_result
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index ef1efd3..7aeba00 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -201,6 +201,24 @@ int mesh_path_error_tx(u8 *dst, __le32 dst_dsn, u8 *ra,
 	return 0;
 }
 
+void ieee80211s_update_metric(struct ieee80211_local *local,
+		struct sta_info *stainfo, struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *txinfo = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	int failed;
+
+	if (!ieee80211_is_data(hdr->frame_control))
+		return;
+
+	failed = !(txinfo->flags & IEEE80211_TX_STAT_ACK);
+
+	/* moving average, scaled to 100 */
+	stainfo->fail_avg = ((80 * stainfo->fail_avg + 5) / 100 + 20 * failed);
+	if (stainfo->fail_avg > 95)
+		mesh_plink_broken(stainfo);
+}
+
 static u32 airtime_link_metric_get(struct ieee80211_local *local,
 				   struct sta_info *sta)
 {
diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 0071649..7c51429 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -51,7 +51,6 @@
 #include <linux/random.h>
 #include <linux/ieee80211.h>
 #include <net/mac80211.h>
-#include "mesh.h"
 #include "rate.h"
 #include "rc80211_minstrel.h"
 
@@ -156,16 +155,12 @@ minstrel_tx_status(void *priv, struct ieee80211_supported_band *sband,
 		   struct sk_buff *skb)
 {
 	struct minstrel_sta_info *mi = priv_sta;
-	struct minstrel_priv *mp = (struct minstrel_priv *)priv;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_rate *ar = info->status.rates;
-	struct ieee80211_local *local = hw_to_local(mp->hw);
-	struct sta_info *si;
 	int i, ndx;
 	int success;
 
 	success = !!(info->flags & IEEE80211_TX_STAT_ACK);
-	si = sta_info_get(local, sta->addr);
 
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
 		if (ar[i].idx < 0)
@@ -177,17 +172,8 @@ minstrel_tx_status(void *priv, struct ieee80211_supported_band *sband,
 
 		mi->r[ndx].attempts += ar[i].count;
 
-		if ((i != IEEE80211_TX_MAX_RATES - 1) && (ar[i + 1].idx < 0)) {
+		if ((i != IEEE80211_TX_MAX_RATES - 1) && (ar[i + 1].idx < 0))
 			mi->r[ndx].success += success;
-			if (si) {
-				si->fail_avg = (18050 - mi->r[ndx].probability)
-					/ 180;
-				WARN_ON(si->fail_avg > 100);
-				if (si->fail_avg == 100 &&
-					ieee80211_vif_is_mesh(&si->sdata->vif))
-					mesh_plink_broken(si);
-			}
-		}
 	}
 
 	if ((info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE) && (i >= 0))
diff --git a/net/mac80211/rc80211_pid_algo.c b/net/mac80211/rc80211_pid_algo.c
index 8c053be..f6e25d7 100644
--- a/net/mac80211/rc80211_pid_algo.c
+++ b/net/mac80211/rc80211_pid_algo.c
@@ -169,19 +169,9 @@ static void rate_control_pid_sample(struct rc_pid_info *pinfo,
 	 * still a good measurement and copy it. */
 	if (unlikely(spinfo->tx_num_xmit == 0))
 		pf = spinfo->last_pf;
-	else {
-		/* XXX: BAD HACK!!! */
-		struct sta_info *si = container_of(sta, struct sta_info, sta);
-
+	else
 		pf = spinfo->tx_num_failed * 100 / spinfo->tx_num_xmit;
 
-		if (ieee80211_vif_is_mesh(&si->sdata->vif) && pf == 100)
-			mesh_plink_broken(si);
-		pf <<= RC_PID_ARITH_SHIFT;
-		si->fail_avg = ((pf + (spinfo->last_pf << 3)) / 9)
-					>> RC_PID_ARITH_SHIFT;
-	}
-
 	spinfo->tx_num_xmit = 0;
 	spinfo->tx_num_failed = 0;
 
@@ -348,9 +338,6 @@ rate_control_pid_rate_init(void *priv, struct ieee80211_supported_band *sband,
 	}
 
 	spinfo->txrate_idx = rate_lowest_index(sband, sta);
-	/* HACK */
-	si = container_of(sta, struct sta_info, sta);
-	si->fail_avg = 0;
 }
 
 static void *rate_control_pid_alloc(struct ieee80211_hw *hw,
-- 
1.5.4.3

