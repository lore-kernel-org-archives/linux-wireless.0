Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:60838 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750995AbeEPG5C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 02:57:02 -0400
Message-ID: <1526453819.2877.10.camel@sipsolutions.net> (sfid-20180516_085706_635087_E827D40A)
Subject: Re: [PATCH v2] mac80211: Fix wlan freezes under load at rekey
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Wetzel <alexander.wetzel@web.de>
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
        s.gottschall@dd-wrt.com
Date: Wed, 16 May 2018 08:56:59 +0200
In-Reply-To: <e37c7000-c281-dfc1-70a0-66d4001d78ed@web.de>
References: <1523258757.3076.5.camel@sipsolutions.net>
         <20180515102202.2021-1-alexander.wetzel@web.de>
         <1526399448.4450.10.camel@sipsolutions.net>
         <e37c7000-c281-dfc1-70a0-66d4001d78ed@web.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-05-16 at 00:41 +0200, Alexander Wetzel wrote:
> 
> I'm on very thin ice here,

I think we all are, since we're talking about interoperability :-)

> but my impression was that this should work
> without too many problems for all (most?) systems:
> - An aggregation session is only started when needed
> - ADDBA can't be expected to succeed
> - It's normal to tear down an aggregation session once your queue is empty.
> 
> The only unusual thing here is, that the originator can get a DELBA from
> the recipient while transmitting data and not after some inactivity
> timeout. But reading IEEE802.11-2016 chapter 11.5.4 seems to indicate
> that you have to expect and handle DELBA frames any time.

There's not necessarily any inactivity timeout. Many STAs (AP STAs
included) will set that to 0 if the aggregation session doesn't cost
them an appreciable amount of resources.

You're reading the spec correctly, but the spec also omits entirely when
you would (want to) start a session, and in my experience the logic in
many STAs will not easily reopen sessions that were torn down (multiple
times) by a recipient DelBA, since they don't know that it won't be torn
down immediately again.

I think the issue is more pronounced with *rejecting* the AddBA, rather
than sending a recipient DelBA, but I'd still be cautious about it.

> So far I've found only one device which is handling a PSK rekey
> correctly (Windows Surface Pro 3 running Win 10) and that one was
> working fine with my patched AP for three rekeys while downloading at
> full speed. The fourth rekey failed and caused an re-associated, but
> according to the OTA capture the AP did not respond to at least 5 EAPOL
> #2 frames and we therefore never got to the code stopping the
> aggregation for rekey.

:-)

That's kinda my point though - you will not really find devices that
work correctly ;-)

> Problem here is the reorder buffer can have already decoded packets
> queued from both the old and the new key. And once the session is
> complete will releases those when we are on the new key, poisoning our PN.
> First plan would be to mark any running RX aggregation queue as tainted
> and once the aggregation is complete discard all packets in it.

Yes, good point, the reorder buffer definitely is a concern here. But
it's also completely managed in software in this case, so I guess we
could tag the key that was used into the frames somehow?

OTOH, if we allow that then we also open ourselves up to replay attacks
during this scenario since we can no longer check the frames properly,
so we'd better drop them.

> Assuming the other STA is not totally broken this should only degrade
> the speed, but keep the connection operable.

Yes.

> If you prefer to not stop the RX aggregation I'll try my hand on that
> next. (I assume stopping TX is fine?)

Stopping TX is fine, that's a local problem. We should make sure we
reopen the sessions but that's at least something we control.

Stopping RX - well, maybe I'm thinking now that it's not so bad. Given
that it's an infrequent DelBA rather than AddBA rejection, it should be
more or less OK.

> The tests I've run so far are showing that we have at least two group of
> "broken" devices out in the wild:
> 1) The first group is handling rekeys pretty much like mac80211. Some
> are better on TX like my HTC 10 (seems to be fullmac) but are failing to
> separate RX frames properly based on the key used to decode it.

No surprise here. It's a very common trade-off - do the PN checks in
software so that you don't waste precious device memory on all the PNs
for all the TIDs, but for speed/CPU reasons do the encryption in
hardware. Basically any time you have this, you run into the problem.
Even if you have full-MAC that may still happen since often this is
implemented in two different "CPUs" (like e.g. Broadcom) or different
hardware blocks perhaps.

> 2) The second group is even worse implemented, but in a nice twist are
> seeming to work quite fine for the users. Those are simply encoding
> eapol #4 with the new key, preventing any rekey to ever succeed and
> triggering a re-associate.

:-)

> Statistically my data is less than insufficient, but I suspect that
> there are quite some APs in the wild running rekeys but the combination
> of hour long rekey intervals, the fact hat you must have traffic during
> the rekey and that at least some common network cards handle eapol #4
> wrong keeps the heat down. And of course this issue is next to
> impossible to track down if you are not some kind of expert.

Indeed.

> Nevertheless I can you find many "magic" solutions to fix linux wlan
> issues by switching over to software encryption and disabling 802.11n,
> which are exactly the actions which drastically reduce the chance to
> freeze a wlan during a PSK rekey. (I'm sure many of those are other
> issues, but I'm equally sure a sizeable fraction is not.)
> 
> One of the "better" reports is here:
> https://bugzilla.kernel.org/show_bug.cgi?id=42877

Right.

I think the part that I misinterpreted in a way is that I thought these
issues mostly happened to people who were explicitly configuring their
(Open|*)Wrt routers to do PTK rekeying. I hadn't really seen any vendors
enabling it in their stock configuration. But perhaps I'm mistaken here,
or perhaps people are actually running into PN wraps after 2**48
packets, which requires a rekey?

Anyway, next step is I think for me to take a closer look at this patch
- I'm starting to think that the aggregation issue isn't so bad.

Thanks for all your work on this!

johannes
