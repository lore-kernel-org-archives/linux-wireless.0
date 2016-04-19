Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48907 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbcDSJGe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 05:06:34 -0400
Message-ID: <1461056788.2766.13.camel@sipsolutions.net> (sfid-20160419_110638_666607_C24F4CC7)
Subject: Re: [PATCHv3 4/5] mac80211: implement codel on fair queuing flows
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dave Taht <dave.taht@gmail.com>,
	make-wifi-fast@lists.bufferbloat.net, codel@lists.bufferbloat.net,
	Avery Pennarun <apenwarr@gmail.com>
Date: Tue, 19 Apr 2016 11:06:28 +0200
In-Reply-To: <CA+BoTQkQrUyihsk9MMMGY3XXGD+RqwziLwe+jKsKTG5q=StuAg@mail.gmail.com> (sfid-20160418_143823_205581_D0138FB9)
References: <1459420104-31554-1-git-send-email-michal.kazior@tieto.com>
	 <1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
	 <1460636302-31161-5-git-send-email-michal.kazior@tieto.com>
	 <1460845772.2075.31.camel@sipsolutions.net>
	 <CA+BoTQkHAOhwFh5grveGCH5tfsxOT=BXAx2qgF1c=GcT7SrSQw@mail.gmail.com>
	 <CA+BoTQkQrUyihsk9MMMGY3XXGD+RqwziLwe+jKsKTG5q=StuAg@mail.gmail.com>
	 (sfid-20160418_143823_205581_D0138FB9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-04-18 at 14:38 +0200, Michal Kazior wrote:
> On 18 April 2016 at 07:31, Michal Kazior <michal.kazior@tieto.com>
> wrote:
> > 
> > On 17 April 2016 at 00:29, Johannes Berg <johannes@sipsolutions.net
> > > wrote:
> > > 
> > > On Thu, 2016-04-14 at 14:18 +0200, Michal Kazior wrote:
> > > > 
> > > > 
> > > > +                             struct ieee80211_vif *vif;
> > > > +
> > > > +                             /* When packets are enqueued on
> > > > txq
> > > > it's easy
> > > > +                              * to re-construct the vif
> > > > pointer.
> > > > There's no
> > > > +                              * more space in tx_info so it
> > > > can
> > > > be used to
> > > > +                              * store the necessary enqueue
> > > > time
> > > > for packet
> > > > +                              * sojourn time computation.
> > > > +                              */
> > > > +                             u64 enqueue_time;
> > > > +                     };
> > > I wonder if we could move something like the hw_key into
> > > tx_control
> > > instead?
> > Hmm.. It's probably doable. From a quick look it'll require quite
> > some
> > change here and there (e.g. tdls_channel_switch op will need to be
> > extended to pass tx_control). I'll play with the idea..
> This is actually far more than I thought initially. 

Fair enough. Perhaps it could be done for the vif? But ISTR there were
issues with that when I looked.

We should just get rid of all the rate stuff and convert everything to
use rate tables, but ... :)

> A lot of drivers
> (b43, b43legacy, rtlwifi, wlxxxx, cw1200) access hw_key outside of tx
> op context (tx workers, tx completions). I'm not even sure this is
> safe (keys can be freed in the meantime by mac80211 hence invaliding
> the pointer inside skb, no?).
> 

Hm, yeah, that does seem problematic unless they synchronize against
key removal somehow?

johannes
