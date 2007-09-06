Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:8929 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbXIFOEl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 10:04:41 -0400
Received: by py-out-1112.google.com with SMTP id u77so337436pyb
        for <linux-wireless@vger.kernel.org>; Thu, 06 Sep 2007 07:04:40 -0700 (PDT)
Message-ID: <1ba2fa240709060704g4a5044beu298bb1d5ae42703d@mail.gmail.com>
Date: Thu, 6 Sep 2007 17:04:37 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH V2] Add iwlwifi wireless drivers
Cc: "Ian Schram" <ischram@telenet.be>, linux-wireless@vger.kernel.org,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Felix Fietkau" <nbd@nbd.name>
In-Reply-To: <1189080026.28781.58.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1188192012.13078.177.camel@debian.sh.intel.com>
	 <20070831205524.GA11128@tuxdriver.com>
	 <1188872746.13078.411.camel@debian.sh.intel.com>
	 <1188915229.9942.29.camel@johannes.berg> <46DF5894.70909@telenet.be>
	 <1189080026.28781.58.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/6/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2007-09-06 at 03:32 +0200, Ian Schram wrote:
>
> > I thought I'd try and answer this question to the best of my ability, since it
> > has been asked before. And even though it's open source and now has been submitted
> > to this list, leaving this unanswered feels like a creepy way of potential time bombs
> > and frustration. That said I'm probably not the best person to do it.
>
> Thanks, I appreciate it.
>
> > iwl3945-rs:
> >
> > - the device can retry at different rates, and hence is able to deduct
> > from the total number of retries a packet needed at which rates it failed/
> > succeeded
>
> We recently discussed this capability, atheros hardware as it as well,
> so we need a generic way to tell mac80211 how many retry rates the
> hardware can support so that better rate control algorithms can be
> written. I don't see this as device specific but rather as something the
> mac80211 driver interface is currently lacking. Cf. the "minstrel" rate
> control algorithm.

There is nothing NOT general in 3945 rate scaling algorithm just the
current interfaces of rate scaling algorithm is a bit awkward, not
extensible. The struct ieee80211_tx_status is tight to mac80211 and
not to rate scale algorithm so if you create your own crazy rate scale
algorithm you cannot decide what parameters you need.

> > - tables of expected tpt (throughput?) which are used in the the throughput
> > calculation are probably not very universal?
> > there aren't identical for 3945 and 4965.
>
> Seems to me like something the driver should be doing and reporting to
> the rate control algorithm via some defined interface.
>
Agree

> > -some synchronization of the station list with the device ucode happens here
>
> This is totally wrong. Please extend mac80211 instead, maybe the
> sta_table_notification callback.
>
True we have some RFC patches with that unfortunately need some time
to catchup on current  wireless-dev changes. Looks like students were
on vacation and spent more time behind computers then on the sea shore
:)

> > So that's that. Some questionable implementation details, but it does use
> > device specific logic/capabilities in order to decide which rate to use.
> > Now what do we do?
>
> As a first step, I think we (i.e. mostly you because only few other
> people have an interest right now) should work on defining an interface
> between the drivers and mac80211 that allows the drivers to export these
> capabilities like "how many different retry rates can I give you with
> one packet" in order to allow different rate control algorithms to take
> advantage of that. Oh and then don't just implement the interface and
> push it onto us as a "ok done" thing but discuss the interface first.
>
4965 is 11n card and rate scale algorithm is totally different.
One aspect is that rate scaling works  with much more parameters. MIMO
rates are rather 2 dimensional table, therefore the algorithm is
essentially different, but so far no interface change is needed.
Actually it covers also legacy rate scaling.

The second aspect of HT is the aggregation. Bunch of packets at once
and they are also ACKed at once so regular TX status path of updating
rate scale algorithm is not so natural. Mostly because it is combined
with reclaiming the packet.

Third part and this is 4965 specific is that  TX rate is not attached
to packet but rate table is updated when need on it's own path. This
is device specific.

Forth is that the aggregation. In general this involves some handshake
on protocol level i.e. MLME but efficiency of aggregation is kind of
rate scaling decision in addition  it might be enabled only for MIMO
rates (different plcp header)

I would suggest to change rate scaling interface algorithm in following way

1. rs_update_event(sta, struct rs_data *)  - function that brings rate
scaling statistics not connected to packet reclaim path
  struct rs_data is specific to rate scaling and opaque to mac80211

2. rs_add_sta/rs_init(sta)  - create new instance of rate scaling for
added station including AP in STA mode

3. rs_compute(sta/sta_addr) - actual computation of rate scaling
algorithm possible also from RX path (tx reclaim)

4.  rs_get_rate - for regular TX path setting of rates

5. void (*rs_apply_rates)(sta_addr)  - driver supplied handler for
applying rate not through TX path.


Tomas





> johannes
>
>
