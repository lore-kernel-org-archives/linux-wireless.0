Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:19347 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764157AbXIUVdo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2007 17:33:44 -0400
Received: by py-out-1112.google.com with SMTP id u77so1782111pyb
        for <linux-wireless@vger.kernel.org>; Fri, 21 Sep 2007 14:33:43 -0700 (PDT)
Message-ID: <43e72e890709211433hf6669f1y97d24663a97b21ff@mail.gmail.com>
Date: Fri, 21 Sep 2007 17:33:42 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/5] Move standard wireless defintions out of mac80211
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Michael Wu" <flamingice@sourmilk.net>,
	"Daniel Drake" <dsd@gentoo.org>,
	"Larry Finger" <Larry.Finger@lwfinger.net>
In-Reply-To: <1190409462.18521.160.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20070921210014.GE31768@pogo>
	 <1190409462.18521.160.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/21/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2007-09-21 at 17:00 -0400, Luis R. Rodriguez wrote:
>
> Ok one thing up front: I'm looking at this basically as "new code", iow
> something we should do right from the start. mac80211 stuff is a mess,
> so imho we should clean it up at this point when we break things anyway.

ACK. Hence the reason why I separated this into two patch series. The
first one allows integration so we can simply hack on it at will. The
idea is to clean this up really well for when it goes upstream.

> > + * @IEEE80211_CHAN_W_SCAN: if this flag is set it informs the lower layer that
> > + *   this channel can be passively scanned for.
>
> Are there really channels that don't have _SCAN?

Yup, as you will see, for example for Japan regdomains we disable SCAN
for 5170,  5190, 5210 and 5230 MHz.

> > +/**
> > + * ieee80211_channel - internal structure definiton for an IEEE-802.11 channel
> > + *
> > + * This defines an ieee80211_channel. The IEEE-802.11 regulatory domain agent
> > + * is in charge of filling most of these fields out. The low-level driver
> > + * is expected to fill in, if needed, the val field. Note that val is already
> > + * set by the regulatory agent to the same channel as in chan.
>
> Shouldn't you also set chan and freq in the driver?

Sure, later (patch series II) mac80211 util.c will have a routine
which can build the array of channels for each mode. The reg agent
will just set everything to the most common values most drivers uses,
which is to keep using the same channel mapping and the same freq
mapping. Drivers will each have their own channel arrays, for example.
The central reg agent will just be used by the higher subsystems to
enable/disable channels and update power restrictions.

> > + * @modulation_cap: could be IEEE80211_RATE_*
>
> Could be?

We can define our own if we can't borrow those.

> > + * @list: lets you make this structure part of a linked list
>
> What do we need this for?

Initially I wanted to move mac80211 to use a linked list of channels
instead of an array for each mode. As we discussed it over (you, me
and a few others) we determined it wasn't best to do this (I have a
patch that allows this just in case we later change our mind). But --
previous to doing this I had a wrapper on ieee80211_channel as I
wanted the central regdomain to have a linked list of reg domain
channels. If we don't want a wrapper we have to add this to the
ieee8021_channel struct. Otherwise I need to define my own channel
struct which wraps around ieee80211_channel.

> > +struct ieee80211_channel {
> > +     /* XXX change to u8 */
> > +     short chan;
>
> Not sure, is a u8 always enough? I thought 802.11a had huge channel
> numbers?

Not that huge :-) Highest I've heard is 220. u8 should suffice.

> > +/* XXX consider removing the holes bellow */
>
> I think these flags are shared with hostapd right now... :(

Then more reasons to move this out of mac80211 and later consolidate
into one place. That is the idea with this move. To start this.

> > +/**
> > + * enum rate_flags - internal &ieee80211_rate flags
>
> > + * Use these flags to indicate to the lower layers details about an
> > + * &ieee80211_rate.
>        ^ struct ieee80211_rate, for kernel-doc
>
> > + * @IEEE80211_RATE_ERP: indicates if the rate is an  Extended Rate PHY (ERP)
> > + * @IEEE80211_RATE_BASIC: indicates the rate is a basic rate for the
> > + *   currently used mode
> > + * @IEEE80211_RATE_PREAMBLE2: used to indicates that the rate for short
> > + *   preamble is to be used. This is set in &ieee80211_rate's @val2.
>
> Couldn't we just call it SHORT_PREAMBLE? :)

Sure, I just went with what was on mac80211. If this is added to
everything branch we can then clean it up as a subsequent patch.

> > + * @IEEE80211_RATE_SUPPORTED: indicates if rate is supported by the given mode
>
> What do we use this for?
>
> > + * @IEEE80211_RATE_OFDM: indicates support for ODFM modulation
> > + * @IEEE80211_RATE_CCK: indicates support for CCK modulation
>
> I think this should be called "this rate is an OFDM/CCK rate"

Sure, good point.

> > + * @IEEE80211_RATE_MANDATORY: indicates if this rate is mandatory for the
> > + *   currently used mode
>
> I think this is wrong. Isn't the "mandatory" flag something for an AP to
> ask it's stations for?

I'm not too sure, if so this can be fixed by a following patch.

> > +/* XXX move to inline and add documenation, kernel-doc can't doc
> > defines */
>
> Why don't you just do that then? :)

Hehe, I was, but I got tired of hogging this code up, and wanted to
post it for more review. A quick patch can fix this too ;)

> > + * Low-level driver should set PREAMBLE2, OFDM and CCK flags.
> > + * BASIC, SUPPORTED, ERP, and MANDATORY flags are set in 80211.o based on the
> > + * configuration.
>
> Oh come on. There hasn't been 80211.o for a loong time :)

Sorry, I moved docs from mac80211, I should have caught that :-P

> > + * @flags: IEEE80211_RATE_* flags
> > + * @val2: hw specific value for the rate when using short preamble
> > + *   (only when IEEE80211_RATE_PREAMBLE2 flag is set, i.e., for
> > + *   2, 5.5, and 11 Mbps)
>
> Can't we just get rid of this field? Does anybody use it?

Not too sure. Anyone?

> > + * @min_rssi_ack: Minimum required RSSI of packet to generate an ACK ??
> > + * @min_rssi_ack_delta: ??
>
> I thought we didn't use these fields.

Oops.. that was supposed to be removed, yes.

> > +     /* the following fields are set by 80211.o and need not be filled by the
>
> 80211.o again :)

Oopsy :-)

  Luis
