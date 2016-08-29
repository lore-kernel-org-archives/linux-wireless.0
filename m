Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40748 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933252AbcH2NkK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Aug 2016 09:40:10 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Date: Mon, 29 Aug 2016 16:39:58 +0300
Message-Id: <1472477998-25972-5-git-send-email-luca@coelho.fi> (sfid-20160829_154019_681861_AF136D54)
Subject: [PATCH 5/5] mac80211: send delBA on unexpected BlockAck Request
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If we don't have a BA session, send delBA, as requested by the
IEEE 802.11 spec. Apply the same limit of sending such a delBA
only once as in the previous patch.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 7a60b59..bea9e11 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2593,6 +2593,12 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx, struct sk_buff_head *frames)
 
 		tid = le16_to_cpu(bar_data.control) >> 12;
 
+		if (!test_bit(tid, rx->sta->ampdu_mlme.agg_session_valid) &&
+		    !test_and_set_bit(tid, rx->sta->ampdu_mlme.unexpected_agg))
+			ieee80211_send_delba(rx->sdata, rx->sta->sta.addr, tid,
+					     WLAN_BACK_RECIPIENT,
+					     WLAN_REASON_QSTA_REQUIRE_SETUP);
+
 		tid_agg_rx = rcu_dereference(rx->sta->ampdu_mlme.tid_rx[tid]);
 		if (!tid_agg_rx)
 			return RX_DROP_MONITOR;
-- 
2.8.1
