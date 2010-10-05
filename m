Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38335 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab0JESwt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 14:52:49 -0400
Subject: Re: more crashing goodness with ath9k
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CAB6F96.6090701@candelatech.com>
References: <4CAB6F96.6090701@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 20:52:48 +0200
Message-ID: <1286304768.3641.26.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-05 at 11:33 -0700, Ben Greear wrote:
> This is with 8 STA configured with WPA.
> 
> Memory poisoning, etc is enabled.
> 
> 
> Reading symbols from /home/greearb/kernel/2.6/wireless-testing-dbg.p4s/net/mac80211/mac80211.ko...done.
> (gdb) l *(sta_addba_resp_timer_expired+0x7c)
> 0x5b38 is in sta_addba_resp_timer_expired (/home/greearb/git/linux.wireless-testing/arch/x86/include/asm/bitops.h:312).

This ought to help, but I'm not sure the locking etc. is 100% correct
yet.

johannes

---
 net/mac80211/agg-tx.c |    3 +++
 1 file changed, 3 insertions(+)

--- wireless-testing.orig/net/mac80211/agg-tx.c	2010-10-05 20:40:02.000000000 +0200
+++ wireless-testing/net/mac80211/agg-tx.c	2010-10-05 20:51:59.000000000 +0200
@@ -163,6 +163,7 @@ int ___ieee80211_stop_tx_ba_session(stru
 		/* not even started yet! */
 		rcu_assign_pointer(sta->ampdu_mlme.tid_tx[tid], NULL);
 		spin_unlock_bh(&sta->lock);
+		del_timer_sync(&tid_tx->addba_resp_timer);
 		call_rcu(&tid_tx->rcu_head, kfree_tid_tx);
 		return 0;
 	}
@@ -176,6 +177,8 @@ int ___ieee80211_stop_tx_ba_session(stru
 
 	set_bit(HT_AGG_STATE_STOPPING, &tid_tx->state);
 
+	del_timer_sync(&tid_tx->addba_resp_timer);
+
 	/*
 	 * After this packets are no longer handed right through
 	 * to the driver but are put onto tid_tx->pending instead,


