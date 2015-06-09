Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54614 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbbFIS5t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 14:57:49 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: handle aggregation session timeout on fast-xmit path
Date: Tue,  9 Jun 2015 20:57:45 +0200
Message-Id: <1433876265-25557-1-git-send-email-johannes@sipsolutions.net> (sfid-20150609_205804_902930_EAA90338)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The conversion to the fast-xmit path lost proper aggregation session
timeout handling - the last_tx wasn't set on that path and the timer
would therefore incorrectly tear down the session periodically (with
those drivers/rate control algorithms that have a timeout.)

In case of iwlwifi, this was every 5 seconds and caused significant
throughput degradation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 82e1e8484593..8410bb3bf5e8 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2719,9 +2719,12 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) {
 		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
 		tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[tid]);
-		if (tid_tx &&
-		    !test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state))
-			return false;
+		if (tid_tx) {
+			if (!test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state))
+				return false;
+			if (tid_tx->timeout)
+				tid_tx->last_tx = jiffies;
+		}
 	}
 
 	/* after this point (skb is modified) we cannot return false */
-- 
2.1.4

