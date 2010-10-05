Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33484 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab0JETFl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 15:05:41 -0400
Subject: Re: more crashing goodness with ath9k
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1286304768.3641.26.camel@jlt3.sipsolutions.net>
References: <4CAB6F96.6090701@candelatech.com>
	 <1286304768.3641.26.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 21:05:41 +0200
Message-ID: <1286305541.3641.27.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-05 at 20:52 +0200, Johannes Berg wrote:

> --- wireless-testing.orig/net/mac80211/agg-tx.c	2010-10-05 20:40:02.000000000 +0200
> +++ wireless-testing/net/mac80211/agg-tx.c	2010-10-05 20:51:59.000000000 +0200
> @@ -163,6 +163,7 @@ int ___ieee80211_stop_tx_ba_session(stru
>  		/* not even started yet! */
>  		rcu_assign_pointer(sta->ampdu_mlme.tid_tx[tid], NULL);
>  		spin_unlock_bh(&sta->lock);
> +		del_timer_sync(&tid_tx->addba_resp_timer);
>  		call_rcu(&tid_tx->rcu_head, kfree_tid_tx);
>  		return 0;
>  	}

That one's unnecessary, if we get into this branch the timer can't have
been started yet.

johannes

