Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290Ab2CIIWd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 03:22:33 -0500
Date: Fri, 9 Mar 2012 09:22:16 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 3.3 v2] rt2x00: fix random stalls
Message-ID: <20120309082216.GA2339@redhat.com> (sfid-20120309_092236_584600_4D716D27)
References: <20120307183103.GB15839@redhat.com>
 <4F59275B.2010309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F59275B.2010309@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gertjan

On Thu, Mar 08, 2012 at 10:40:43PM +0100, Gertjan van Wingerde wrote:
> > @@ -152,13 +152,20 @@ void rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
> >  	if (unlikely(rt2x00queue_write_tx_frame(queue, skb, false)))
> >  		goto exit_fail;
> >  
> > +	/*
> > +	 * Pausing queue has to be serialized with rt2x00lib_txdone() .
> > +	 */
> > +	spin_lock(&queue->tx_lock);
> >  	if (rt2x00queue_threshold(queue))
> >  		rt2x00queue_pause_queue(queue);
> > +	spin_unlock(&queue->tx_lock);
> >  
> >  	return;
> >  
> >   exit_fail:
> > +	spin_lock(&queue->tx_lock);
> >  	rt2x00queue_pause_queue(queue);
> > +	spin_unlock(&queue->tx_lock);
> >   exit_free_skb:
> >  	ieee80211_free_txskb(hw, skb);
> >  }
> 
> I'm sorry, but I'm still not convinced that we can use spin_lock_bh in
> one place of the code and then spin_lock in another place of the code,
> using the *same* spinlock.
> I always use the cheat sheet shown in:
> http://www.kernel.org/pub/linux/kernel/people/rusty/kernel-locking/c214.html
> 
> which to me shows that by definition we should be using spin_lock_bh in
> all cases now, the new ones and the existing cases where we lock tx_lock.

We have bh disabled here since ieee80211_xmit is always called with bh
disabled (early on dev_queue_xmit() or in ieee80211_tx_skb_tid()). I can
add comment about that.

Additionally I ran patch with CONFIG_LOCKDEP which is capable to detect
locking context errors and no warning was printed.

Thanks
Stanislaw
