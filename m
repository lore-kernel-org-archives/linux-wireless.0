Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:36871
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbXGCRho (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 13:37:44 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH RFC] mac80211: Make stop_queues() usable
Date: Tue, 3 Jul 2007 19:36:23 +0200
Cc: Jiri Benc <jbenc@suse.cz>, John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200707022235.38791.mb@bu3sch.de> <200707031039.56710.mb@bu3sch.de> <200707031015.23890.flamingice@sourmilk.net>
In-Reply-To: <200707031015.23890.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200707031936.24084.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 03 July 2007 19:15:19 Michael Wu wrote:
> On Tuesday 03 July 2007 01:39, Michael Buesch wrote:
> > On Tuesday 03 July 2007 06:09:19 Michael Wu wrote:
> > > On Monday 02 July 2007 13:35, Michael Buesch wrote:
> > > > +	netif_tx_lock_bh(mdev);
> > > >  	for (i = 0; i < hw->queues; i++)
> > > >  		ieee80211_stop_queue(hw, i);
> > > > +	netif_tx_unlock_bh(mdev);
> > >
> > > Well, looks like this will break stopping all tx queues from the tx
> > > handler by deadlocking. It may be useless for bcm43xx to call
> > > ieee80211_stop_queue, but there are other drivers which rely on it.
> >
> > Nobody said that. Of course bcm43xx needs stop_queue, too.
> >
> I mean stop_queues, in the tx path, which this patch would break.

It's useless to stop all queues from the TX handler.
If a queue overflows we should just stop _that_ one.


> > No, that is not enough. For example for switching bands we need to
> > reinitialize the board completely. Before I take the board down I must
> > ensure that no traffic is going on any longer.
> >
> Ok sure.
> 
> However, ensuring that there is no attempt to TX while the channel is being 
> changed is generally good so stopping the queues before every channel change 
> in mac80211 would be preferred.

Yes. That may also be a mac80211 issue.
The driver should really be able to completely stop TX, too.
Otherwise it is forced to implement ugly locks and workarounds
to prevent concurrency issues. I'm not sure if it's easily possible
to workaround without races.

> > > Of course, the ieee80211_stop_queue deadlock should still get fixed
> > > eventually..
> >
> > That's not needed, as it's only sane to call in the TX handler, where
> > it can't deadlock.
> By stop_queue, I mean stop_queues, which you do seem to want to call outside 
> of the tx_handler.

the _only_ place where it's sane to call stop_queues (to stop all queues)
is outside of the TX handler. Why would you stop all queues inside of
the TX path?

-- 
Greetings Michael.
