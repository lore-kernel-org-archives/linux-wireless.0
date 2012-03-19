Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43433 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab2CSNui (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 09:50:38 -0400
Subject: Re: [RFC] mac80211: fix possible tid_rx->reorder_timer use after
 free
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20120319134016.GC6169@redhat.com>
References: <1332161442-7315-1-git-send-email-sgruszka@redhat.com>
	 <1332162188.3359.33.camel@jlt3.sipsolutions.net>
	 <20120319134016.GC6169@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Mar 2012 14:50:36 +0100
Message-ID: <1332165036.3359.37.camel@jlt3.sipsolutions.net> (sfid-20120319_145041_994910_C747BE33)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-03-19 at 14:40 +0100, Stanislaw Gruszka wrote:

> > > +static void ieee80211_free_tid_rx(struct tid_ampdu_rx *tid_rx)
> > >  {
> > > -	struct tid_ampdu_rx *tid_rx =
> > > -		container_of(h, struct tid_ampdu_rx, rcu_head);
> > >  	int i;
> > >  
> > >  	for (i = 0; i < tid_rx->buf_size; i++)
> > > @@ -90,10 +88,12 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
> > >  		ieee80211_send_delba(sta->sdata, sta->sta.addr,
> > >  				     tid, WLAN_BACK_RECIPIENT, reason);
> > >  
> > > +	synchronize_rcu();
> > > +
> > >  	del_timer_sync(&tid_rx->session_timer);
> > >  	del_timer_sync(&tid_rx->reorder_timer);
> > >  
> > > -	call_rcu(&tid_rx->rcu_head, ieee80211_free_tid_rx);
> > > +	ieee80211_free_tid_rx(tid_rx);
> > 
> > Hmmm. That synchronize_rcu() could become rather expensive. I've been
> > trying to reduce our use of synchronize_rcu() now.
> 
> Expensive in what sense? Since we are in process context we are allowed
> to sleep, and some other processes will run while we sleep.

It takes a long time, and we have to wait for it. So for example, it
could delay roaming by another 100ms or however long it takes (yes, it
can take a very long time, we've seen up to 200ms I think)

johannes

