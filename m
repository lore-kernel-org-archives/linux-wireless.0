Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:44639 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbXIFOb4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 10:31:56 -0400
Received: by an-out-0708.google.com with SMTP id d31so27246and
        for <linux-wireless@vger.kernel.org>; Thu, 06 Sep 2007 07:31:55 -0700 (PDT)
Message-ID: <1ba2fa240709060731n59d76023s61ac9c6f7152d631@mail.gmail.com>
Date: Thu, 6 Sep 2007 17:31:55 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH V2] Add iwlwifi wireless drivers
Cc: "Ian Schram" <ischram@telenet.be>, linux-wireless@vger.kernel.org,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Felix Fietkau" <nbd@nbd.name>
In-Reply-To: <1189088042.28781.86.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1188192012.13078.177.camel@debian.sh.intel.com>
	 <20070831205524.GA11128@tuxdriver.com>
	 <1188872746.13078.411.camel@debian.sh.intel.com>
	 <1188915229.9942.29.camel@johannes.berg> <46DF5894.70909@telenet.be>
	 <1189080026.28781.58.camel@johannes.berg>
	 <1ba2fa240709060704g4a5044beu298bb1d5ae42703d@mail.gmail.com>
	 <1189088042.28781.86.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/6/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2007-09-06 at 17:04 +0300, Tomas Winkler wrote:
>
> > There is nothing NOT general in 3945 rate scaling algorithm just the
> > current interfaces of rate scaling algorithm is a bit awkward, not
> > extensible. The struct ieee80211_tx_status is tight to mac80211 and
> > not to rate scale algorithm so if you create your own crazy rate scale
> > algorithm you cannot decide what parameters you need.
>
> Yeah, I agree, we need to improve this. "minstrel" really wants more
> retry rates too than just two.
>
> > 4965 is 11n card and rate scale algorithm is totally different.
> > One aspect is that rate scaling works  with much more parameters. MIMO
> > rates are rather 2 dimensional table, therefore the algorithm is
> > essentially different, but so far no interface change is needed.
> > Actually it covers also legacy rate scaling.
>
> Right. Maybe we can orthogonalize this into a rate control interface
> for .11n and one for "legacy"?
>
11n should cover also legacy rate scaling, and legacy mode in general.

> > The second aspect of HT is the aggregation. Bunch of packets at once
> > and they are also ACKed at once so regular TX status path of updating
> > rate scale algorithm is not so natural. Mostly because it is combined
> > with reclaiming the packet.
>
> This is something you need to work on in mac80211 anyway. I don't like
> how your driver does all the decisions about when to aggregate etc. This
> should be in the per-sta code in mac80211.
>
We have solved that it just as I said it is not rebased  against
latest wireless-dev so you don't see this code. I will probably
release some RFC patches first so nobody will accuse me of selling FUD
:)

> > Third part and this is 4965 specific is that  TX rate is not attached
> > to packet but rate table is updated when need on it's own path. This
> > is device specific.
>
> It seemed like the rate was attached to each station. This is a bit and
> I don't really know how to handle it.
???

> > Forth is that the aggregation. In general this involves some handshake
> > on protocol level i.e. MLME but efficiency of aggregation is kind of
> > rate scaling decision in addition  it might be enabled only for MIMO
> > rates (different plcp header)
>
> Right. I think you mentioned aggregation as number two already :)
>
Number 2 is the rate scaling update path this is rate scaling decision path

> > 1. rs_update_event(sta, struct rs_data *)  - function that brings rate
> > scaling statistics not connected to packet reclaim path
> >   struct rs_data is specific to rate scaling and opaque to mac80211
>
> What sort of statistics would it bring, and when?
>
In legacy TX it will be the same as current implementation, actual
rate, number of retries, etc
For aggregation it need rate and number of packets ACKed and NACked.
The whole aggregation is sent in one rate. Theoreticaly multi rate
aggregation might be sent, but no vendor creates such radios yet.

> > 2. rs_add_sta/rs_init(sta)  - create new instance of rate scaling for
> > added station including AP in STA mode
>
> That's what we have now afaict.
> Yes

> > 3. rs_compute(sta/sta_addr) - actual computation of rate scaling
> > algorithm possible also from RX path (tx reclaim)
>
> Where would it be called?

This can be run in reclaim path (RX) as now  but for 4965 I would
create period work

> > 4.  rs_get_rate - for regular TX path setting of rates
>
> Right.
>
> > 5. void (*rs_apply_rates)(sta_addr)  - driver supplied handler for
> > applying rate not through TX path.
>
> This needs more parameters, no?
Sure, the rates themselves. Currently I have in vision only 4965 rate
table. Need to find something more general probably.

Thanks for your comments
Tomas
>
