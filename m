Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:40474 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843AbZB1Dha (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 22:37:30 -0500
Date: Sat, 28 Feb 2009 04:37:25 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH,RFC] initial mwl8k driver for marvell topdog wireless
Message-ID: <20090228033725.GG17040@xi.wantstofly.org> (sfid-20090228_043751_240608_8061EBDC)
References: <20081216025542.GO18056@xi.wantstofly.org> <1229628950.3601.43.camel@johannes.berg> <20090225023458.GB17040@xi.wantstofly.org> <1235755624.7426.71.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1235755624.7426.71.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 27, 2009 at 06:27:04PM +0100, Johannes Berg wrote:

> Hi Lennert,

Hi Johannes,


> Are you bringing your laptop?  Want to do a little direct review
> next week?

Yep.  Sounds good!


> > Actually, the firmware always runs in little endian.  I have yet to
> > test it on a big-endian host but I've done a pass over the driver to
> > make sure that all firmware struct fields >8 bits are annotated
> > as __le and that we use cpu_to_leXX/leXX_to_cpu in the right places,
> > and I think it's okay now.  (And I think we got rid of the bitfields
> > before the first submission.)
> 
> Sounds good :) If you've got pcie hardware but no big endian machine, I
> can test it for you if you want.

We have mini-PCIe cards.  Can you do anything with those?  I can
probably find a PCIe-to-mini-PCIe adapter if you need one.


> > > > +	/* Clear addr4 */
> > > > +	memset(tr->wh.addr4, 0, IEEE80211_ADDR_LEN);
> > > 
> > > ?
> > 
> > As per above, the firmware always expects a 4-address header, but we
> > won't actually end up with a 4-address header here currently, so we
> > can just unconditionally write zeroes here.  This might need to be
> > revisited in the future.
> 
> Yeah, if you want to support 4addr (WDS).

I think the current firmware wouldn't let us -- but we might want to
in the future.


> > > > +/*
> > > > + * Scan a list of BSSIDs to process for finalize join.
> > > > + * Allows for extension to process multiple BSSIDs.
> > > > + */
> > > 
> > > Can you explain why you need to do this much BSSID stuff? Maybe we
> > > can extend mac80211 a little instead?
> > 
> > There is a firmware command FINALIZE_JOIN which expects a copy of
> > the beacon used for association.  From the beacon it uses the BSSID
> > and TSF timer (to program the PS timers), and possibly a couple of
> > other fields (I'd have to check), which is why we have
> > priv->capture_bssid and priv->beacon_skb.  Ideas?  I guess we could
> > have mac80211 pass us a copy of the beacon it used for association,
> > but I don't think any other card needs this...
> 
> Might make sense to do that with some of the new cfg80211 assoc stuff
> that might have that anyway, but it seems ok to keep for now then. I
> guess mac80211 kinda passes all the information that the firmware will
> parse out of the beacon in an already parsed form.

Right.  We could re-synthesize a beacon frame from parsed-out data,
but I'm not sure if that'll give us all the data that the firmware
needs, since I'm not exactly sure what fields it uses.


> > We just ended up always queueing the work, since it's more consistent
> > that way, and you'll have to wait in line anyway since you don't want
> > to end up breaking up already-queued command sequences that the
> > firmware expects to be sequential.  So it seemed simpler to just use
> > the existing mechanism.
> 
> Ok, except, where does the requirement to use a workqueue come from
> at all? Can we remove that entirely maybe? Or is it the filter flags
> stuff (where we can't change atomicity requirement)?

->configure_filter() is one.  In general, we need to make sure that
firmware commands are strictly serialised, and that the packet TX path
is quiesced/drained when firmware commands are issued.  AFAICS, mac80211
doesn't in the general case guarantee that driver callbacks are
serialised w.r.t. each other and w.r.t. the TX path (e.g. running
scanning every couple of seconds while pumping a lot of data over RX/TX
is a way of triggering these situations) (which is fine), and the
workqueue seemed the easiest way to guarantee this.  Maybe we don't
strictly need the workqueue, as long as we have _some_ synchronisation
primitive that can guarantee these things.


thanks,
Lennert
