Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689Ab1AJMic (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 07:38:32 -0500
Date: Mon, 10 Jan 2011 13:38:21 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Andi Kleen <ak@linux.intel.com>, stable@kernel.org,
	Kyle McMartin <kmcmartin@redhat.com>,
	kernel@lists.fedoraproject.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2.6.35] mac80211: fix hard lockup in
 sta_addba_resp_timer_expired
Message-ID: <20110110123808.GA3683@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Problem is 2.6.35 specific, bug was introduced in backport
of upstream 44271488b91c9eecf249e075a1805dd887e222d2 commit.

We can not call del_timer_sync(addba_resp_timer) from
___ieee80211_stop_tx_ba_session(), as this function can be called from
that timer callback. To fix, simply use not synchronous del_timer().

Resolve https://bugzilla.redhat.com/show_bug.cgi?id=667459

Reported-and-tested-by: Mathieu Chouquet-Stringer <mathieu-acct@csetco.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/agg-tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index f935490..72ab63d 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -138,7 +138,7 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 	       sta->sta.addr, tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
-	del_timer_sync(&tid_tx->addba_resp_timer);
+	del_timer(&tid_tx->addba_resp_timer);
 
 	state = &sta->ampdu_mlme.tid_state_tx[tid];
 
-- 
1.7.3.4

