Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45462 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727410AbeHaMsu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 08:48:50 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 31 Aug 2018 11:31:26 +0300
Message-Id: <20180831083130.15525-25-luca@coelho.fi> (sfid-20180831_104232_985803_CB0A17A7)
In-Reply-To: <20180831083130.15525-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
Subject: [PATCH 24/28] mac80211: allow AMSDU size limitation per-TID
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

)

From: Sara Sharon <sara.sharon@intel.com>

Some drivers may have AMSDU size limitation per TID, due to
HW constrains. Add an option to set this limit.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/mac80211.h | 2 ++
 net/mac80211/tx.c      | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1d1dbd8123a4..e448a633a242 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1852,6 +1852,7 @@ struct ieee80211_sta_rates {
  *	unlimited.
  * @support_p2p_ps: indicates whether the STA supports P2P PS mechanism or not.
  * @max_rc_amsdu_len: Maximum A-MSDU size in bytes recommended by rate control.
+ * @max_tid_amsdu_len: Maximum A-MSDU size in bytes for this TID
  * @twt_req_support: indicates whether the STA advertised support for TWT
  *	requester in the Extended Capabilities element.
  * @twt_resp_support: indicates whether the STA advertised support for TWT
@@ -1897,6 +1898,7 @@ struct ieee80211_sta {
 	u16 max_amsdu_len;
 	bool support_p2p_ps;
 	u16 max_rc_amsdu_len;
+	u16 max_tid_amsdu_len[IEEE80211_NUM_TIDS];
 	bool twt_req_support;
 	bool twt_resp_support;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index b184906611b6..a2cc33652f2a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3221,6 +3221,10 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 		max_amsdu_len = min_t(int, max_amsdu_len,
 				      sta->sta.max_rc_amsdu_len);
 
+	if (sta->sta.max_tid_amsdu_len[tid])
+		max_amsdu_len = min_t(int, max_amsdu_len,
+				      sta->sta.max_tid_amsdu_len[tid]);
+
 	spin_lock_bh(&fq->lock);
 
 	/* TODO: Ideally aggregation should be done on dequeue to remain
-- 
2.18.0
