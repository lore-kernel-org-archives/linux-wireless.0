Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40081 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab2EGP5j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 11:57:39 -0400
Message-ID: <1336406256.4325.33.camel@jlt3.sipsolutions.net> (sfid-20120507_175742_340845_7A40DD14)
Subject: [PATCH] mac80211: fix TX aggregation session timer
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 07 May 2012 17:57:36 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In commit 12d3952fc4a1cd96234bc7023bf7eefeb0bb6355
("mac80211: optimize aggregation session timeout handling")
two bugs were introduced:
 1) RCU usage was completely broken since no locks are held
 2) the timer must not rearm when agg session is stopping

Reported-and-tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/mac80211/agg-tx.c	2012-04-12 05:40:36.000000000 +0200
+++ b/net/mac80211/agg-tx.c	2012-05-07 17:54:14.000000000 +0200
@@ -421,16 +421,22 @@ static void sta_tx_agg_session_timer_exp
 	struct tid_ampdu_tx *tid_tx;
 	unsigned long timeout;
 
-	tid_tx = rcu_dereference_protected_tid_tx(sta, *ptid);
-	if (!tid_tx)
+	rcu_read_lock();
+	tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[*ptid]);
+	if (!tid_tx || test_bit(HT_AGG_STATE_STOPPING, &tid_tx->state)) {
+		rcu_read_unlock();
 		return;
+	}
 
 	timeout = tid_tx->last_tx + TU_TO_JIFFIES(tid_tx->timeout);
 	if (time_is_after_jiffies(timeout)) {
 		mod_timer(&tid_tx->session_timer, timeout);
+		rcu_read_unlock();
 		return;
 	}
 
+	rcu_read_unlock();
+
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "tx session timer expired on tid %d\n", (u16)*ptid);
 #endif


