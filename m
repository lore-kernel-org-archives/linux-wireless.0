Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57527 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbXIXJBU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 05:01:20 -0400
Subject: Re: API to regulatory control (1)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <43e72e890709221416o25bf3287v5d8d7bb5c2fe15ab@mail.gmail.com>
References: <1190456574.18521.220.camel@johannes.berg>
	 <43e72e890709221416o25bf3287v5d8d7bb5c2fe15ab@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1gSK14rKlhIl17qoJSgC"
Date: Mon, 24 Sep 2007 11:02:34 +0200
Message-Id: <1190624554.18521.261.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1gSK14rKlhIl17qoJSgC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> In essence you are addressing here what would be series II of my
> patchset which I haven't sent. This consists of the actual integration
> of the regualtory work onto wireless drivers themselves.

:)

> > [NOTE: I think there's a restriction on OFDM somewhere so we must have =
a
> > channel struct for each modulation to be able to disable OFDM/force
> > lower power with OFDM]
>=20
> We'll need to elaborate on this later.

I'm not sure. I haven't looked up those restrictions but ISTR somebody
told me there were such restrictions. I'm happy to be proven wrong---it
can only simplify things.

> > Next, the driver needs to say which modulations/bitrates it supports:
> > struct ieee80211_rate {
> >         /* stuff from the driver */
> >         enum ieee80211_modulation modulation; /* OFDM, CCK, CCK_SHORTPR=
E */
> >         u32 rate; /* in units of 100 Kbps */
> >         /* internal stuff */
> >         TBD;
> > };
> >
> > Again, it's stuffed together into an array:
> > struct ieee80211_rates {
> >         struct ieee80211_rate *rates;
> >         int num_rates;
> > };
>=20
> ACK -- however note that these are defined already by the IEEE "mode"
> we operate in. The vendor rates and vendor modulations are the things
> that will vary out of the norm I believe.

We don't really have a plan how to support vendor modulations because it
heavily influences calculations in the stack. Anybody have ideas? I'd
prefer if we'd defer that until later.

> > so let's say we now have a b43_supported_rates variable although we
> > really have one for A, B, BG and ABG devices.
> >
> > NOTE: All this rate stuff is *NOT* interesting for regulatory. *IFF*
> > there are regulatory restrictions on bitrates anywhere then we need to
> > make this part of the channels array!
>=20
> I think it may have been Jouni who pointed this out for Japan at some
> point. It was big news to me. If this is an exception we can treat it
> as such just as with the FCC 3:1 rule between max IR and antenna_gain
> for PtMP links, or Japan's rules for not allowing disabling active
> scan on old 5GHz channels.

Ouch. Will have to change plans then.

Another thing I considered was to have a function to get "regulatory
OK", i.e. the only thing we'd have in regulatory code would be a few
functions like this:

int regulatory_check(freq, modulation, ...);
-> returns 0 or 1 (if allowed)

int regulatory_get_max_power(freq, modulation, ..., pmtp_or_ptp);

But I then thought we'd be calling this function a lot during scanning
so discarded this idea. However, with all the complexity here, maybe we
can revive it and provide some sort of "for each allowed channel" loop
or something too.

> > Now, before the driver registers it's hardware struct, it puts both
> > &b43_supported_channels into the "struct wiphy".
>=20
> Did you mean both &b43_supported_channels *and* &b43_supported_rates?
> If not what did you mean by "both" here?

Sorry, scratch "both", I reworded the email last minute because I no
longer thought supported_rates was of any importance to regulatory.

> Anyway -- I now see what you were saying on IRC and I think its a
> pretty good idea as the path I was following for series II of patches
> was ab it different :-)=20

I never meant to distract you from the ideas you have, I'm open for
other suggestions too. I didn't think long about this anyhow, just the
stuff I came up with after looking at it for a bit.

> But let me ask you this though -- is that
> necessary? Since each mac80211 driver mode right now has a
> ieee80211_channel array pointer can't we just have cfg80211 be aware
> of this, at least for now?

Do we actually need the modes? I'm a bit confused now.

> > This is how both
> > mac80211 and cfg80211 get told about it. &b43_supported_rates is put
> > into struct ieee80211_hw, only mac80211 needs to know about it, fullmac
> > drivers never need to show this information to anything outside except
> > maybe for some cfg80211 *hooks*.
>=20
> Hm, as I said above rate stuff seems pretty common amongst modes.
> Can't we just assume if your card supports a certain IEEE-802.11 mode
> that you'll have at least certain rates?

Ahh. I see what you mean. Well, what I'd do is provide an array in
mac80211 that is EXPORT_SYMBOL'ed so you can simply refer to that if you
don't have any special hardware-values for the stuff. And maybe provide
allocation functions for when you do need special hardware-values. Then
only drivers that need really special stuff need to do all the array
building themselves, but in principle can.

> > Internally, mac80211 or fullmac drivers of course need to check the
> > channel structs internally when they are asked to move to a different
> > channel or change TX power.
>=20
> Sure, cfg8021 can just do this. We just need to be sure cfg80211 won't
> break anything.

Hm. cfg80211 could do it but I think it might be wise to have it in
drivers since scanning will require the driver to do it anyway.

> > At this point, however, the regulatory agent API only starts. First of
> > all, the channel list has already been registered with cfg80211 because
> > a pointer is part of struct wiphy
>=20
> If we take this approach, sure.

No need to, of course, we could register it explicitly as well.

> >  Then, when by any way possible, the
> > regulatory restrictions change (user setting, ...) the fields marked
> > "second part updated by regulatory agent" are updated for each wiphy
>=20
> As of right now I think changing channel rules and power restrictions
> (ir, eirp, and antenna gain) is all the regulatory agent should do.
> Beyond that its news to me that regulatory laws say we have to change
> other aspects of wireless communication.

Right. I'm not sure about modulations (see above) but I agree with this.

> If all we have to do is update the channel flags and power
> restrictions, why should drivers be informed about regulatory change?
> I agree, it may be good to have, but I'm just wondering why we should
> make this a priority right now if don't have a good reason for drivers
> be informed about this.

Well, I think it's not too important when you think of channels, but say
you have an AP open and for some reason move into a new regulatory
domain, the TX power might need to be adjusted. This isn't important,
but implementing the hook to allow (notifier chain) is trivial so I
figured we might as well do it.

> I was thinking one simple way of doing this was to add to the wiphy
> struct a reg timestamp or counter, and also have one for the central
> reg agent. If the stamps don't match, well then we know the central
> reg agent has changed the central regdomain and the driver can do
> whatever work it needs to. A notifier seems much better than polling
> though. But I just am not sure if we need this right now.

Yeah I agree about polling, that sucks since we're all in the kernel.
But see above as for why I think we should do it anyway.

> > From what I can see, this finishes the channel restrictions API. Since
> > none of the information in the channels list is specific to some device=
,
> > it may be allocated statically.
>=20
> I don't quite get by what you mean in this last part. Can you
> elaborate a bit further?

Well, I think that there's no need to allocate the channels array
dynamically, each driver can have just a single one indicating what the
hardware is capable of and use it multiple times if you say plug in 20
zd1211 devices.

> OK -- so now let me address why I haven't done some changes which you
> have addressed yet. It's because I don't want to cause a headache to
> driver developers and for introduction of this work it would mean A
> LOT of work and changes. I rather introduce this work gently, only
> modifying absolutely necessary things first.

I'm not sure. I think I prefer getting the API right and having some
driver pain than trying to introduce it over a few weeks and having
longer pain ;) But I suppose that's just me, you may well prefer to do
it slower and I won't push it.

> If patchset series I work is embraced

I think the patches you posted are pretty much unusable as they stand,
you should at least clean out the number of lines you have in headers
and the ugly macros that declare arrays (why is that anyway? does
openbsd really ship such code?)

johannes

--=-1gSK14rKlhIl17qoJSgC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG930q/ETPhpq3jKURArbYAKCEl/V3UlfHf6jAWXps6eNIV8j+JgCdHjPx
QY4swHtg8XxKaMAGoN7fh1Q=
=KRXT
-----END PGP SIGNATURE-----

--=-1gSK14rKlhIl17qoJSgC--

