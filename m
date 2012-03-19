Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083Ab2CSNkZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 09:40:25 -0400
Date: Mon, 19 Mar 2012 14:40:17 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: fix possible tid_rx->reorder_timer use after free
Message-ID: <20120319134016.GC6169@redhat.com> (sfid-20120319_144028_919666_5128231D)
References: <1332161442-7315-1-git-send-email-sgruszka@redhat.com>
 <1332162188.3359.33.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1332162188.3359.33.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 19, 2012 at 02:03:08PM +0100, Johannes Berg wrote:
> On Mon, 2012-03-19 at 13:50 +0100, Stanislaw Gruszka wrote:
> > Is possible that we arm tid_rx->reorder_timer after del_timer_sync(). To
> > fix: first wait for RCU grace period finish and then delete timer. Timer
> > will not be armed again as rcu_dereference(sta->ampdu_mlme.tid_rx[tid])
> > will return NULL.
> > 
> > Debug object detected problem with the following warning:
> > ODEBUG: free active (active state 0) object type: timer_list hint: sta_rx_agg_reorder_timer_expired+0x0/0xf0 [mac80211]
> > 
> > Bug report (with full warning):
> > https://bugzilla.redhat.com/show_bug.cgi?id=804007
> > 
> > Reported-by: "jan p. springer" <jsd@igroup.org>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  net/mac80211/agg-rx.c   |    8 ++++----
> >  net/mac80211/sta_info.h |    1 -
> >  2 files changed, 4 insertions(+), 5 deletions(-)
> > 
> > diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
> > index 1068f66..2c1223e 100644
> > --- a/net/mac80211/agg-rx.c
> > +++ b/net/mac80211/agg-rx.c
> > @@ -43,10 +43,8 @@
> >  #include "ieee80211_i.h"
> >  #include "driver-ops.h"
> >  
> > -static void ieee80211_free_tid_rx(struct rcu_head *h)
> > +static void ieee80211_free_tid_rx(struct tid_ampdu_rx *tid_rx)
> >  {
> > -	struct tid_ampdu_rx *tid_rx =
> > -		container_of(h, struct tid_ampdu_rx, rcu_head);
> >  	int i;
> >  
> >  	for (i = 0; i < tid_rx->buf_size; i++)
> > @@ -90,10 +88,12 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
> >  		ieee80211_send_delba(sta->sdata, sta->sta.addr,
> >  				     tid, WLAN_BACK_RECIPIENT, reason);
> >  
> > +	synchronize_rcu();
> > +
> >  	del_timer_sync(&tid_rx->session_timer);
> >  	del_timer_sync(&tid_rx->reorder_timer);
> >  
> > -	call_rcu(&tid_rx->rcu_head, ieee80211_free_tid_rx);
> > +	ieee80211_free_tid_rx(tid_rx);
> 
> Hmmm. That synchronize_rcu() could become rather expensive. I've been
> trying to reduce our use of synchronize_rcu() now.

Expensive in what sense? Since we are in process context we are allowed
to sleep, and some other processes will run while we sleep.

> I was checking if we could move the timer deletions into
> ieee80211_free_tid_rx since call_rcu runs from another softirq, but I'm
> not really sure -- the timer softirq could be running on another CPU?

Yes. I considered using async del_timer() from rcu callback, but that
would be racy too. 

We could do rcu_dereference (and check if it is not null) just
before mod_timer(). But that will still be racy as long spin_lock
will not be used.

Stanislaw
