Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23006 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965030AbbLHOGe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2015 09:06:34 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 4/9] mac80211: pass aggregation window size to lower level
Date: Tue,  8 Dec 2015 16:04:34 +0200
Message-Id: <1449583479-26658-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151208_150652_323430_3BD284C8)
In-Reply-To: <1449583479-26658-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1449583479-26658-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Currently mac80211 does not inform the driver of the window
size when starting a rx aggregation session.
Following patches will enable managing the reorder buffer in
the driver or hardware, and the window size is needed.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h | 8 +++++---
 net/mac80211/agg-rx.c  | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f4cbad4..dca010a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3061,9 +3061,11 @@ enum ieee80211_reconfig_type {
  * 	ieee80211_ampdu_mlme_action. Starting sequence number (@ssn)
  * 	is the first frame we expect to perform the action on. Notice
  * 	that TX/RX_STOP can pass NULL for this parameter.
- *	The @buf_size parameter is only valid when the action is set to
- *	%IEEE80211_AMPDU_TX_OPERATIONAL and indicates the peer's reorder
- *	buffer size (number of subframes) for this session -- the driver
+ *	The @buf_size parameter is valid only when the action is set to
+ *	%IEEE80211_AMPDU_RX_START or %IEEE80211_AMPDU_TX_OPERATIONAL and
+ *	indicates the reorder buffer size (number of subframes) for this
+ *	session.
+ *	When the action is set to %IEEE80211_AMPDU_TX_OPERATIONAL the driver
  *	may neither send aggregates containing more subframes than this
  *	nor send aggregates in a way that lost frames would exceed the
  *	buffer size. If just limiting the aggregate size, this would be
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 10ad4ac..7867273 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -323,7 +323,7 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 		__skb_queue_head_init(&tid_agg_rx->reorder_buf[i]);
 
 	ret = drv_ampdu_action(local, sta->sdata, IEEE80211_AMPDU_RX_START,
-			       &sta->sta, tid, &start_seq_num, 0, false);
+			       &sta->sta, tid, &start_seq_num, buf_size, false);
 	ht_dbg(sta->sdata, "Rx A-MPDU request on %pM tid %d result %d\n",
 	       sta->sta.addr, tid, ret);
 	if (ret) {
-- 
2.5.0

