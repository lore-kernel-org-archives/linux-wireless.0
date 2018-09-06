Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43710 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727706AbeIFNch (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:32:37 -0400
From: Yuan-Chi Pang <fu3mo6goo@gmail.com>
Cc: fu3mo6goo@gmail.com, Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mac80211: fix TX status reporting for ieee80211s
Date: Thu,  6 Sep 2018 16:57:48 +0800
Message-Id: <1536224269-69350-1-git-send-email-fu3mo6goo@gmail.com> (sfid-20180906_105821_135924_64F6DB09)
In-Reply-To: <1535963610.3437.10.camel@sipsolutions.net>
References: <1535963610.3437.10.camel@sipsolutions.net>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TX status reporting to ieee80211s is through ieee80211s_update_metric.
There are two problems about ieee80211s_update_metric:

1. The purpose is to estimate the fail probability
to a specific link. No need to restrict to data frame.

2. Current implementation does not work if wireless driver does not
pass tx_status with skb.

Fix this by removing ieee80211_is_data condition, passing
ieee80211_tx_status directly to ieee80211s_update_metric, and
putting it in both __ieee80211_tx_status and ieee80211_tx_status_ext.

Signed-off-by: Yuan-Chi Pang <fu3mo6goo@gmail.com>
---
 net/mac80211/mesh.h      | 2 +-
 net/mac80211/mesh_hwmp.c | 8 ++------
 net/mac80211/status.c    | 4 +++-
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index ee56f18..7ffe56a 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -217,7 +217,7 @@ void mesh_rmc_free(struct ieee80211_sub_if_data *sdata);
 int mesh_rmc_init(struct ieee80211_sub_if_data *sdata);
 void ieee80211s_init(void);
 void ieee80211s_update_metric(struct ieee80211_local *local,
-			      struct sta_info *sta, struct sk_buff *skb);
+			 struct sta_info *sta, struct ieee80211_tx_status *st);
 void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mesh_teardown_sdata(struct ieee80211_sub_if_data *sdata);
 int ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index daf9db3..4286673 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -295,15 +295,11 @@ int mesh_path_error_tx(struct ieee80211_sub_if_data *sdata,
 }
 
 void ieee80211s_update_metric(struct ieee80211_local *local,
-		struct sta_info *sta, struct sk_buff *skb)
+		struct sta_info *sta, struct ieee80211_tx_status *st)
 {
-	struct ieee80211_tx_info *txinfo = IEEE80211_SKB_CB(skb);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_tx_info *txinfo = st->info;
 	int failed;
 
-	if (!ieee80211_is_data(hdr->frame_control))
-		return;
-
 	failed = !(txinfo->flags & IEEE80211_TX_STAT_ACK);
 
 	/* moving average, scaled to 100.
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 9a6d720..dfcd419 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -811,7 +811,7 @@ static void __ieee80211_tx_status(struct ieee80211_hw *hw,
 
 		rate_control_tx_status(local, sband, status);
 		if (ieee80211_vif_is_mesh(&sta->sdata->vif))
-			ieee80211s_update_metric(local, sta, skb);
+			ieee80211s_update_metric(local, sta, status);
 
 		if (!(info->flags & IEEE80211_TX_CTL_INJECTED) && acked)
 			ieee80211_frame_acked(sta, skb);
@@ -972,6 +972,8 @@ void ieee80211_tx_status_ext(struct ieee80211_hw *hw,
 		}
 
 		rate_control_tx_status(local, sband, status);
+		if (ieee80211_vif_is_mesh(&sta->sdata->vif))
+			ieee80211s_update_metric(local, sta, status);
 	}
 
 	if (acked || noack_success) {
-- 
2.7.4
