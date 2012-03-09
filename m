Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39805 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab2CIIdO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 03:33:14 -0500
Subject: Re: [rt2x00-users] [PATCH 3.3 v2] rt2x00: fix random stalls
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
In-Reply-To: <20120309082216.GA2339@redhat.com> (sfid-20120309_092236_584600_4D716D27)
References: <20120307183103.GB15839@redhat.com> <4F59275B.2010309@gmail.com>
	 <20120309082216.GA2339@redhat.com> (sfid-20120309_092236_584600_4D716D27)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Mar 2012 09:33:07 +0100
Message-ID: <1331281987.3491.0.camel@jlt3.sipsolutions.net> (sfid-20120309_093318_079436_39EA5F6E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-09 at 09:22 +0100, Stanislaw Gruszka wrote:

> > > +	spin_lock(&queue->tx_lock);
> > >  	rt2x00queue_pause_queue(queue);
> > > +	spin_unlock(&queue->tx_lock);
> > >   exit_free_skb:
> > >  	ieee80211_free_txskb(hw, skb);
> > >  }
> > 
> > I'm sorry, but I'm still not convinced that we can use spin_lock_bh in
> > one place of the code and then spin_lock in another place of the code,
> > using the *same* spinlock.
> > I always use the cheat sheet shown in:
> > http://www.kernel.org/pub/linux/kernel/people/rusty/kernel-locking/c214.html
> > 
> > which to me shows that by definition we should be using spin_lock_bh in
> > all cases now, the new ones and the existing cases where we lock tx_lock.
> 
> We have bh disabled here since ieee80211_xmit is always called with bh
> disabled (early on dev_queue_xmit() or in ieee80211_tx_skb_tid()). I can
> add comment about that.

And in fact if you were to use spin_unlock_bh() in that kind of context
it would be a bug :-)

johannes

