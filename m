Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44075 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab2HVHDg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2012 03:03:36 -0400
Message-ID: <1345619008.4635.3.camel@jlt3.sipsolutions.net> (sfid-20120822_090340_425710_3C85915D)
Subject: Re: [PATCH] cfg80211: VHT (11ac) Regulatory change
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Kalle Valo <kvalo@adurom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Date: Wed, 22 Aug 2012 09:03:28 +0200
In-Reply-To: <5033CE76.6040306@posedge.com>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCDD559@mbx022-e1-nj-10.exch022.domain.local>
	  <20120816102211.GD17659@redhat.com> <502CF2D5.6020704@posedge.com>
	  <20120817140657.GA1645@redhat.com> <502E85D9.5050301@posedge.com>
	  <1345480718.4459.37.camel@jlt3.sipsolutions.net>
	  <87d32k7kga.fsf@purkki.adurom.net> <20120821081839.GA2380@redhat.com>
	  <50338E84.3050709@posedge.com>
	 <1345564421.10280.9.camel@jlt3.sipsolutions.net>
	 <5033CE76.6040306@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-08-21 at 23:37 +0530, Mahesh Palivela wrote:

> > I think the question really is whether or not we actually need the
> > flags. Sometimes, but very rarely really, we need to answer the question
> >
> >          Is this set of parameters allowed with the current regulatory
> >          rules?
> >
> > There's nothing that says this needs to be a flag. It could just as well
> > be a function
> >
> > bool regulatory_chan_use_permitted(...);
> >
> > where the ... gives all the necessary parameters or maybe some structure
> > holding all these.
> >
> > If this was a function, it could go back to the regulatory definitions
> > (that we hopefully keep track of in the kernel) and actually use the
> > algorithm that today we use to determine the flags to determine the
> > answer.
> >
> > Today, with the flags, we basically pre-determine the answers to all
> > possible such questions, and encode the answers in the flags for each
> > channel. If we don't pre-determine the answers, then we can get away
> > without any flags at all.
> >
> > Does that make sense?
> >
> Yes it does. Basically we want to retire look up table approach and 
> compute everytime as its not scalable. Fine. In that case, even we need 
> to cover HT20, HT40-, HT40+ as well right?

I think we should, yeah. Might even just start with that to make the
transition.

> > Still doesn't solve the problems we saw with how to configure the
> > channel with considerations such as
> >    - bandwidth
> >    - center frequency
> >    - primary subchannel
> >    - 80 + 80 (which is basically two such channels?)
> >
> Yes It does. From center freq, width, control chan offset we know the 
> secondary chans. That's all we want. For 80+80 configuration, we will 
> get two center freq values.

Yeah but we don't have that yet. We could do it that way, sure, but it
has wide-spread implications, since we'll need to
 - use this new form of specifying channels all over mac80211 and all
   drivers,
 - define new nl80211 attributes for it,
 - write new code in nl80211 to handle all this,
 - and parse the old attributes into the new data structure(s) so
   drivers use the new API but userspace can continue to use the old

None of that is done yet.

johannes

