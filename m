Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:61599 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab3CSLI2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 07:08:28 -0400
Received: by mail-pb0-f50.google.com with SMTP id up1so338001pbc.37
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2013 04:08:28 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC] mac80211: avoid rearming BA session timers unnecessarily
Date: Tue, 19 Mar 2013 04:08:22 -0700
Message-Id: <1363691302-11947-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20130319_120833_510818_F0C8EF46)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

If mac80211 tears down the BA sessions with del_timer_sync()
technically mod_timer() can still rearm them. If mac80211
tears the BA sessions down we don't want to rearm the timers
at a later time so avoid this possibility.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---

Figure I'd start reviewing mod_timer()/mod_timer_pending() as
no one caught on. Likely not an issue on mac80211 but I suspect
drivers will all be poo.

 net/mac80211/agg-rx.c |    2 +-
 net/mac80211/agg-tx.c |    2 +-
 net/mac80211/rx.c     |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 31bf258..47d7468 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -153,7 +153,7 @@ static void sta_rx_agg_session_timer_expired(unsigned long data)
 
 	timeout = tid_rx->last_rx + TU_TO_JIFFIES(tid_rx->timeout);
 	if (time_is_after_jiffies(timeout)) {
-		mod_timer(&tid_rx->session_timer, timeout);
+		mod_timer_pending(&tid_rx->session_timer, timeout);
 		rcu_read_unlock();
 		return;
 	}
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 13b7683..b15b629 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -488,7 +488,7 @@ static void sta_tx_agg_session_timer_expired(unsigned long data)
 
 	timeout = tid_tx->last_tx + TU_TO_JIFFIES(tid_tx->timeout);
 	if (time_is_after_jiffies(timeout)) {
-		mod_timer(&tid_tx->session_timer, timeout);
+		mod_timer_pending(&tid_tx->session_timer, timeout);
 		rcu_read_unlock();
 		return;
 	}
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5b4492a..0b81653 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2216,8 +2216,8 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx, struct sk_buff_head *frames)
 
 		/* reset session timer */
 		if (tid_agg_rx->timeout)
-			mod_timer(&tid_agg_rx->session_timer,
-				  TU_TO_EXP_TIME(tid_agg_rx->timeout));
+			mod_timer_pending(&tid_agg_rx->session_timer,
+					  TU_TO_EXP_TIME(tid_agg_rx->timeout));
 
 		spin_lock(&tid_agg_rx->reorder_lock);
 		/* release stored frames up to start of BAR */
-- 
1.7.10.4

