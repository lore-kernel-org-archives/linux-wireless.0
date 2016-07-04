Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53639 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270AbcGDIfn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2016 04:35:43 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.87)
	(envelope-from <johannes@sipsolutions.net>)
	id 1bJzLu-0003GW-Ef
	for linux-wireless@vger.kernel.org; Mon, 04 Jul 2016 10:35:38 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: agg-rx: refuse ADDBA Request with timeout update
Date: Mon,  4 Jul 2016 10:35:33 +0200
Message-Id: <1467621333-12317-1-git-send-email-johannes@sipsolutions.net> (sfid-20160704_103546_990407_C1D3C78C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current implementation of handling ADDBA Request while a session
is already active with the peer is wrong - in case the peer is using
the existing session's dialog token this should be treated as update
to the session, which can update the timeout value.

We don't really have a good way of supporting that, so reject, but
implement the required behaviour in the spec of "Even if the updated
ADDBA Request frame is not accepted, the original Block ACK setup
remains active." (802.11-2012 10.5.4)

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/agg-rx.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 3a8f881b22f1..a9aff6079c42 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -306,6 +306,24 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 	mutex_lock(&sta->ampdu_mlme.mtx);
 
 	if (test_bit(tid, sta->ampdu_mlme.agg_session_valid)) {
+		tid_agg_rx = rcu_dereference_protected(
+				sta->ampdu_mlme.tid_rx[tid],
+				lockdep_is_held(&sta->ampdu_mlme.mtx));
+
+		if (tid_agg_rx->dialog_token == dialog_token) {
+			ht_dbg_ratelimited(sta->sdata,
+					   "updated AddBA Req from %pM on tid %u\n",
+					   sta->sta.addr, tid);
+			/* We have no API to update the timeout value in the
+			 * driver so reject the timeout update.
+			 */
+			status = WLAN_STATUS_REQUEST_DECLINED;
+			ieee80211_send_addba_resp(sta->sdata, sta->sta.addr,
+						  tid, dialog_token, status,
+						  1, buf_size, timeout);
+			goto end;
+		}
+
 		ht_dbg_ratelimited(sta->sdata,
 				   "unexpected AddBA Req from %pM on tid %u\n",
 				   sta->sta.addr, tid);
-- 
2.8.1

