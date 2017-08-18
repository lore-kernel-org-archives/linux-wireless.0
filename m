Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:44394 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750913AbdHRMeE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 08:34:04 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 18 Aug 2017 15:33:56 +0300
Message-Id: <20170818123357.19646-2-luca@coelho.fi> (sfid-20170818_143408_648371_9790911F)
In-Reply-To: <20170818123357.19646-1-luca@coelho.fi>
References: <20170818123357.19646-1-luca@coelho.fi>
Subject: [PATCH 1/2] mac80211: add documentation to ieee80211_rx_ba_offl()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Add documentation to ieee80211_rx_ba_offl() function and, while at it,
rename the bit argument to tid, for consistency.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/mac80211.h | 8 +++++++-
 net/mac80211/agg-rx.c  | 4 ++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f8149ca192b4..b232487be696 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5452,8 +5452,14 @@ void ieee80211_mark_rx_ba_filtered_frames(struct ieee80211_sta *pubsta, u8 tid,
  */
 void ieee80211_send_bar(struct ieee80211_vif *vif, u8 *ra, u16 tid, u16 ssn);
 
+/**
+ * ieee80211_manage_rx_ba_offl - helper to queue an RX BA work
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback
+ * @addr: station mac address
+ * @tid: the rx tid
+ */
 void ieee80211_manage_rx_ba_offl(struct ieee80211_vif *vif, const u8 *addr,
-				 unsigned int bit);
+				 unsigned int tid);
 
 /**
  * ieee80211_start_rx_ba_session_offl - start a Rx BA session
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 2b36eff5d97e..90e7807d3505 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -449,7 +449,7 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 }
 
 void ieee80211_manage_rx_ba_offl(struct ieee80211_vif *vif,
-				 const u8 *addr, unsigned int bit)
+				 const u8 *addr, unsigned int tid)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct ieee80211_local *local = sdata->local;
@@ -460,7 +460,7 @@ void ieee80211_manage_rx_ba_offl(struct ieee80211_vif *vif,
 	if (!sta)
 		goto unlock;
 
-	set_bit(bit, sta->ampdu_mlme.tid_rx_manage_offl);
+	set_bit(tid, sta->ampdu_mlme.tid_rx_manage_offl);
 	ieee80211_queue_work(&local->hw, &sta->ampdu_mlme.work);
  unlock:
 	rcu_read_unlock();
-- 
2.14.1
