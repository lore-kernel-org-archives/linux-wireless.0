Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755191Ab2HVJB3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2012 05:01:29 -0400
Date: Wed, 22 Aug 2012 11:01:05 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mahesh Palivela <maheshp@posedge.com>,
	Kalle Valo <kvalo@adurom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH] cfg80211: VHT (11ac) Regulatory change
Message-ID: <20120822090104.GA4959@redhat.com> (sfid-20120822_110134_928819_77778748)
References: <502CF2D5.6020704@posedge.com>
 <20120817140657.GA1645@redhat.com>
 <502E85D9.5050301@posedge.com>
 <1345480718.4459.37.camel@jlt3.sipsolutions.net>
 <87d32k7kga.fsf@purkki.adurom.net>
 <20120821081839.GA2380@redhat.com>
 <50338E84.3050709@posedge.com>
 <1345564421.10280.9.camel@jlt3.sipsolutions.net>
 <5033CE76.6040306@posedge.com>
 <1345619008.4635.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1345619008.4635.3.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 22, 2012 at 09:03:28AM +0200, Johannes Berg wrote:
> On Tue, 2012-08-21 at 23:37 +0530, Mahesh Palivela wrote:
> > Yes it does. Basically we want to retire look up table approach and 
> > compute everytime as its not scalable. Fine. In that case, even we need 
> > to cover HT20, HT40-, HT40+ as well right?
> 
> I think we should, yeah. Might even just start with that to make the
> transition.

[snip]

> > > Still doesn't solve the problems we saw with how to configure the
> > > channel with considerations such as
> > >    - bandwidth
> > >    - center frequency
> > >    - primary subchannel
> > >    - 80 + 80 (which is basically two such channels?)
> > >
> > Yes It does. From center freq, width, control chan offset we know the 
> > secondary chans. That's all we want. For 80+80 configuration, we will 
> > get two center freq values.
> 
> Yeah but we don't have that yet. We could do it that way, sure, but it
> has wide-spread implications, since we'll need to
>  - use this new form of specifying channels all over mac80211 and all
>    drivers,
>  - define new nl80211 attributes for it,
>  - write new code in nl80211 to handle all this,
>  - and parse the old attributes into the new data structure(s) so
>    drivers use the new API but userspace can continue to use the old
> 
> None of that is done yet.

For starters (for regulatory purpose only) would be sufficient to
implement

regulatory_chan_use_permitted(center freq, bandwidth, whatever else),

and use it where currently IEEE80211_CHAN_NO_HT_X flags are used.

Stanislaw
