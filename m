Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46944 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727597AbeIEJes (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 05:34:48 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  5 Sep 2018 08:06:10 +0300
Message-Id: <20180905050614.23273-6-luca@coelho.fi> (sfid-20180905_070633_316402_C16F53D7)
In-Reply-To: <20180905050614.23273-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
 <20180905050614.23273-1-luca@coelho.fi>
Subject: [RESEND PATCH v2 5/9] mac80211: allow AMSDU size limitation per-TID
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
index fe71cec8ba42..28da9e27ea70 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1853,6 +1853,7 @@ struct ieee80211_sta_rates {
  *	unlimited.
  * @support_p2p_ps: indicates whether the STA supports P2P PS mechanism or not.
  * @max_rc_amsdu_len: Maximum A-MSDU size in bytes recommended by rate control.
+ * @max_tid_amsdu_len: Maximum A-MSDU size in bytes for this TID
  * @txq: per-TID data TX queues (if driver uses the TXQ abstraction); note that
  *	the last entry (%IEEE80211_NUM_TIDS) is used for non-data frames
  */
@@ -1894,6 +1895,7 @@ struct ieee80211_sta {
 	u16 max_amsdu_len;
 	bool support_p2p_ps;
 	u16 max_rc_amsdu_len;
+	u16 max_tid_amsdu_len[IEEE80211_NUM_TIDS];
 
 	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS + 1];
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 6689492c9713..41eaa8e6a938 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3234,6 +3234,10 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
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
