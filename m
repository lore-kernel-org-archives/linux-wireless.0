Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59804 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752997AbeBSMtw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 07:49:52 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Feb 2018 14:48:44 +0200
Message-Id: <20180219124847.27169-11-luca@coelho.fi> (sfid-20180219_135005_557077_929210CD)
In-Reply-To: <20180219124847.27169-1-luca@coelho.fi>
References: <20180219124847.27169-1-luca@coelho.fi>
Subject: [PATCH v2 10/13] mac80211: agg-rx: Accept ADDBA request update if timeout did not change
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

As there is no support for updating an existing ADDBA session with
a peer, we decline the request (while keeping the session active).
However, in case that the timeout did not change, there is no need
to decline the request, so modify the code to reply with status success
in such a case (this is useful for interoperability with APs that send an
ADDBA request update without changing the timeout value).

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/agg-rx.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 1f3188d03840..e83c19d4c292 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -298,13 +298,23 @@ void ___ieee80211_start_rx_ba_session(struct sta_info *sta,
 
 	if (test_bit(tid, sta->ampdu_mlme.agg_session_valid)) {
 		if (sta->ampdu_mlme.tid_rx_token[tid] == dialog_token) {
+			struct tid_ampdu_rx *tid_rx;
+
 			ht_dbg_ratelimited(sta->sdata,
 					   "updated AddBA Req from %pM on tid %u\n",
 					   sta->sta.addr, tid);
 			/* We have no API to update the timeout value in the
-			 * driver so reject the timeout update.
+			 * driver so reject the timeout update if the timeout
+			 * changed. If if did not change, i.e., no real update,
+			 * just reply with success.
 			 */
-			status = WLAN_STATUS_REQUEST_DECLINED;
+			rcu_read_lock();
+			tid_rx = rcu_dereference(sta->ampdu_mlme.tid_rx[tid]);
+			if (tid_rx && tid_rx->timeout == timeout)
+				status = WLAN_STATUS_SUCCESS;
+			else
+				status = WLAN_STATUS_REQUEST_DECLINED;
+			rcu_read_unlock();
 			goto end;
 		}
 
-- 
2.15.1
