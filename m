Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:55231 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbXIVVQU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Sep 2007 17:16:20 -0400
Received: by py-out-1112.google.com with SMTP id u77so2193827pyb
        for <linux-wireless@vger.kernel.org>; Sat, 22 Sep 2007 14:16:20 -0700 (PDT)
Message-ID: <43e72e890709221416o25bf3287v5d8d7bb5c2fe15ab@mail.gmail.com>
Date: Sat, 22 Sep 2007 17:16:19 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: API to regulatory control (1)
Cc: linux-wireless@vger.kernel.org, "Jouni Malinen" <j@w1.fi>
In-Reply-To: <1190456574.18521.220.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1190456574.18521.220.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/22/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> Ok since I'm having trouble communicating this via IRC and other people
> may have input too, let me summarise how I think regulatory control
> should be implemented. This is a high-level overview and maybe Luis's
> stuff actually implements things this way, but I can't really tell
> because the interesting information (i.e. the API) is buried in
> thousands of lines of code of boring definitions. Not to dismiss the
> effort to collect all this info, but I think it's rather unimportant at
> this stage.

In essence you are addressing here what would be series II of my
patchset which I haven't sent. This consists of the actual integration
of the regualtory work onto wireless drivers themselves.

> So let me first explain how I see a mac80211-based driver communicating
> with mac80211/cfg80211 on regulatory info.

See ;)

> I think each driver should include a few arrays that define which
> channels the hardware is capable of operating in. These arrays may be
> statically or dynamically allocated depending on the needs. This
> basically consists of:
>
> struct ieee80211_channel {
>         /* first part set by driver */
>         u16 freq;               /* in MHz */
>         int hardware_value;     /* arbitrary */
>         enum ieee80211_modulation modulation; /* CCK, OFDM */
>
>         u8 supp_dbm_power_max;  /* maximum TX power device supports */
>
>         /* second part updated by regulatory agent */
>         u32 flags;              /* disabled, active scan, passive scan, IBSS, DFS, ... */
>         u8 perm_dbm_ptmp_power_max; /* permitted pmtp power */
>         u8 perm_dbm_ptp_power_max;  /* permitted ptp power */
> };

ACK -- note here how you've changed ieee80211_channel struct. There's
a reason why I haven't done so although the regulatory work does
provide means to allocate and provide all this other information you
have entered here. I'll explain towards the end of this e-mail.

> [NOTE: I think there's a restriction on OFDM somewhere so we must have a
> channel struct for each modulation to be able to disable OFDM/force
> lower power with OFDM]

We'll need to elaborate on this later.

> These are aggregated into an array as such:
> struct ieee80211_channels {
>         struct ieee80211_channel *band2ghz;
>         struct ieee80211_channel *band5ghz;
>         int num_band2ghz, num_band5ghz;
> };
>
> It would not really be necessary to have a separate list for the two
> bands currently in use but it is definitely a lot easier on the code
> later.

ACK

> Now, the driver (say b43) has defined a struct ieee80211_channels it may
> call say b43_supported_channels.
>
> Next, the driver needs to say which modulations/bitrates it supports:
> struct ieee80211_rate {
>         /* stuff from the driver */
>         enum ieee80211_modulation modulation; /* OFDM, CCK, CCK_SHORTPRE */
>         u32 rate; /* in units of 100 Kbps */
>         /* internal stuff */
>         TBD;
> };
>
> Again, it's stuffed together into an array:
> struct ieee80211_rates {
>         struct ieee80211_rate *rates;
>         int num_rates;
> };

ACK -- however note that these are defined already by the IEEE "mode"
we operate in. The vendor rates and vendor modulations are the things
that will vary out of the norm I believe.

> so let's say we now have a b43_supported_rates variable although we
> really have one for A, B, BG and ABG devices.
>
> NOTE: All this rate stuff is *NOT* interesting for regulatory. *IFF*
> there are regulatory restrictions on bitrates anywhere then we need to
> make this part of the channels array!

I think it may have been Jouni who pointed this out for Japan at some
point. It was big news to me. If this is an exception we can treat it
as such just as with the FCC 3:1 rule between max IR and antenna_gain
for PtMP links, or Japan's rules for not allowing disabling active
scan on old 5GHz channels.

> Ok enough of the declarations.
>
> Now, before the driver registers it's hardware struct, it puts both
> &b43_supported_channels into the "struct wiphy".

Did you mean both &b43_supported_channels *and* &b43_supported_rates?
If not what did you mean by "both" here?

Anyway -- I now see what you were saying on IRC and I think its a
pretty good idea as the path I was following for series II of patches
was ab it different :-) But let me ask you this though -- is that
necessary? Since each mac80211 driver mode right now has a
ieee80211_channel array pointer can't we just have cfg80211 be aware
of this, at least for now?

> This is how both
> mac80211 and cfg80211 get told about it. &b43_supported_rates is put
> into struct ieee80211_hw, only mac80211 needs to know about it, fullmac
> drivers never need to show this information to anything outside except
> maybe for some cfg80211 *hooks*.

Hm, as I said above rate stuff seems pretty common amongst modes.
Can't we just assume if your card supports a certain IEEE-802.11 mode
that you'll have at least certain rates?

Then again -- its the vendor rates and vendor modulations which we can
implement exceptions for.

> **For mac80211 drivers, this is it!**

ACK

> Internally, mac80211 or fullmac drivers of course need to check the
> channel structs internally when they are asked to move to a different
> channel or change TX power.

Sure, cfg8021 can just do this. We just need to be sure cfg80211 won't
break anything.

> At this point, however, the regulatory agent API only starts. First of
> all, the channel list has already been registered with cfg80211 because
> a pointer is part of struct wiphy

If we take this approach, sure.

>  Then, when by any way possible, the
> regulatory restrictions change (user setting, ...) the fields marked
> "second part updated by regulatory agent" are updated for each wiphy

As of right now I think changing channel rules and power restrictions
(ir, eirp, and antenna gain) is all the regulatory agent should do.
Beyond that its news to me that regulatory laws say we have to change
other aspects of wireless communication.

> and
> a notifier chain is invoked that drivers may register on to get updates.
> I'm not sure how important this notifier chain is but it can't hurt to
> have it.

If all we have to do is update the channel flags and power
restrictions, why should drivers be informed about regulatory change?
I agree, it may be good to have, but I'm just wondering why we should
make this a priority right now if don't have a good reason for drivers
be informed about this.

I was thinking one simple way of doing this was to add to the wiphy
struct a reg timestamp or counter, and also have one for the central
reg agent. If the stamps don't match, well then we know the central
reg agent has changed the central regdomain and the driver can do
whatever work it needs to. A notifier seems much better than polling
though. But I just am not sure if we need this right now.

> From what I can see, this finishes the channel restrictions API. Since
> none of the information in the channels list is specific to some device,
> it may be allocated statically.

I don't quite get by what you mean in this last part. Can you
elaborate a bit further?

OK -- so now let me address why I haven't done some changes which you
have addressed yet. It's because I don't want to cause a headache to
driver developers and for introduction of this work it would mean A
LOT of work and changes. I rather introduce this work gently, only
modifying absolutely necessary things first.

If patchset series I work is embraced we can later push further
changes as cleanup patches for all drivers and such patches will be
easier work than trying to keep the work as a whole in synch with
current mac80211 changes and introducing a huge bomb patch which may
break some drivers.

  Luis
