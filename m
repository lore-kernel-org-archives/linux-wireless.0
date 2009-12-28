Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22594 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbZL1DSh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Dec 2009 22:18:37 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: delete addba_resp_timer when stop Tx BA session
Date: Mon, 28 Dec 2009 11:18:28 +0800
Message-Id: <1261970308-22926-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We start an one shot addba_resp_timer in ieee80211_start_tx_ba_session
but don't delete it in __ieee80211_stop_tx_ba_session. This will cause
problem in suspend and resume. When suspend happens without the timer
deleted, the timer handler will be called immediately after resume and
messes up driver status.

See http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2134
comment #22 for more details.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 net/mac80211/agg-tx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index ceda366..d122082 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -509,6 +509,8 @@ int __ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 	u8 *state;
 	int ret;
 
+	del_timer_sync(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
+
 	/* check if the TID is in aggregation */
 	state = &sta->ampdu_mlme.tid_state_tx[tid];
 	spin_lock_bh(&sta->lock);
-- 
1.6.3.3

