Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42288 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751436AbdHEIpX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Aug 2017 04:45:23 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Sharon Dvir <sharon.dvir@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  5 Aug 2017 11:44:30 +0300
Message-Id: <20170805084438.12550-3-luca@coelho.fi> (sfid-20170805_104553_468869_73884A64)
In-Reply-To: <20170805084438.12550-1-luca@coelho.fi>
References: <20170805084438.12550-1-luca@coelho.fi>
Subject: [PATCH 02/10] mac80211: shorten debug prints using ht_dbg() to avoid warning
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sharon Dvir <sharon.dvir@intel.com>

Invoking ht_dbg() with too long of a string will print a warning.
Shorten the messages while retaining the printed patameters.

Signed-off-by: Sharon Dvir <sharon.dvir@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/agg-tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index cbd48762256c..420486b5a1d9 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -436,7 +436,7 @@ static void sta_addba_resp_timer_expired(unsigned long data)
 	    test_bit(HT_AGG_STATE_RESPONSE_RECEIVED, &tid_tx->state)) {
 		rcu_read_unlock();
 		ht_dbg(sta->sdata,
-		       "timer expired on %pM tid %d but we are not (or no longer) expecting addBA response there\n",
+		       "timer expired on %pM tid %d not expecting addBA response\n",
 		       sta->sta.addr, tid);
 		return;
 	}
@@ -639,7 +639,7 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 	    time_before(jiffies, sta->ampdu_mlme.last_addba_req_time[tid] +
 			HT_AGG_RETRIES_PERIOD)) {
 		ht_dbg(sdata,
-		       "BA request denied - waiting a grace period after %d failed requests on %pM tid %u\n",
+		       "BA request denied - %d failed requests on %pM tid %u\n",
 		       sta->ampdu_mlme.addba_req_num[tid], sta->sta.addr, tid);
 		ret = -EBUSY;
 		goto err_unlock_sta;
-- 
2.13.2
