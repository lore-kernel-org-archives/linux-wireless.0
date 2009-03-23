Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49527 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393AbZCWIny (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 04:43:54 -0400
Subject: Re: [RFC] regulatory information interpretation rules
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Green <Michael.Green@atheros.com>,
	Jouni Malinen <j@w1.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	David Quan <David.Quan@atheros.com>
In-Reply-To: <43e72e890903221552h56bbf914icc79dcfed46e0d59@mail.gmail.com> (sfid-20090322_235243_548893_734C32B8)
References: <1237712542.5100.766.camel@johannes.local>
	 <43e72e890903221348q3db85b30k7975d996c5269c28@mail.gmail.com>
	 <1237757583.19647.50.camel@johannes.local>
	 <43e72e890903221552h56bbf914icc79dcfed46e0d59@mail.gmail.com>
	 (sfid-20090322_235243_548893_734C32B8)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-YaW5bWxZym2C/afoebVO"
Date: Mon, 23 Mar 2009 09:43:46 +0100
Message-Id: <1237797826.19647.94.camel@johannes.local> (sfid-20090323_094357_892130_6223F320)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YaW5bWxZym2C/afoebVO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-03-22 at 15:52 -0700, Luis R. Rodriguez wrote:

> > Basically we do "MIN < freq <=3D MAX" rather than "MIN <=3D freq <=3D M=
AX" to
> > avoid problems with
> >        A - B @ ...
> >        B - C @ ...
> > and then determining which range "B" falls into. My interpretation says
> > that it belongs into the _first_ rather than the second range.
>=20
> Hm, it changes the way we think about the regulatory rules
> considerably. For example, if a regulatory domain is defined with only
> one rule as:
>=20
> 2412 - 2462 @ 40
>=20
> It would imply that a regular (20 MHz wide) channel 1 with a center of
> freq 2412 MHz would not be allowed while a regular (20 MHz wide)
> channel 11 with a center of freq 2462 MHz would be allowed. It means
> that to the regulatory rule patcher/contributor they would have to
> think of the first value used as the center of freq -1 at least, while
> the end freq can be equal to the max center of freq allowed.

No, of course we still require (rule 2) that the entire channel
bandwidth falls into the permitted range, so this would never allow
anything with centre 2412 or 2462 since those would span more than the
range.

> Would this also mean a channel who's center of freq is 2413 (although
> bogus) is allowed?

Only if it has a 2 MHz bandwidth :P

However, yes, I'm disregarding IEEE rules about allowed channels --
that's something we are handling by the channel array.

> > Indeed, this is first and foremost a definition of how to interpret the
> > database that we have, and not how to implement it.
>=20
> Right so reason I mentioned this is because ultimately I'm in favor
> for choosing the interpretation and implementation which is easiest,
> fastest and will also cause less pain for users of the old style reg
> rules.

Mind you -- unless the reg rules for a country contain overlap there's
nothing that really changes with these interpretation rules (some more
things would be allowed, technically, like HT40+ on channel 48, but
those are not valid according to the IEEE -- this is unrelated to
regulatory code though). If they do contain overlap I'm saying that we
should remove the overlap and specify how to use the rules w/o the
overlap to achieve the correct goal.

> >> For example we want to allow a channel change to occur
> >> as quickly as possible so if the above regulatory questions can be
> >> saved into flag form to avoid a direct regulatory rule lookup during
> >> channel change I think it would be great. How would we cache the
> >> answer to the HT40 question on the channel?
> >
> > Yeah, I need to think about this. We also need to think about 5/10 MHz
> > channels. I'm thinking that maybe the best way to do that is to add a
> > "supported channel types" bitmap to each channel, which we could then
> > modify to include HT40+/- as appropriate as well. Something like we hav=
e
> > with orig_flags and flags already.
>=20
> Yeah I think that would make sense. BTW so one way to deal with this
> is to keep the channel.bandwidth and to simply think about it as the
> max allowed bandwidth _per_channel_. Technically if this is =3D=3D 20 the=
n
> it is implied channels with custom bandwidths smaller than this would
> be allowed. Of course then its a matter of what the device and its
> device driver actually supports.=20

Yeah that's not going to work -- most devices will support 20 MHz but
not 10 MHz channels.

> As for HT40 the bandwidth required
> would be 20 per channel but you'd also need to ensure the channel doe
> snot have the NO_HT40 flag set which would have been propagated down
> from the regulatory rule.

But I don't want a NO_HT40 flag :P

> >> The same HT40 question could be made but instead of looking at the
> >> HT40 channel as an individual channel we'd be trying to answer this by
> >> looking at the two channels involved to make the HT40 channel happen.
> >
> > I kinda disagree here. How should we know whether 20+20 is allowed or
> > not if we don't treat it as 40?
>=20
> As of right now the assumption in our code is to disable a channel if
> we cannot use at least 20 MHz on it. Therefore if the channel is not
> disabled we _know_ we can use 20 MHz on it. If the primary and
> secondary channel exists on the device and are enabled then we can
> potentially use HT40. The only other question missing is whether or
> not the regulatory domain allows for it. We would know whether both
> channels' regulatory rule supports HT40 by looking at their respective
> freq_range->max_bandiwdth, this would have to be >=3D 40 MHz. Otherwise
> we can set a NO_HT40 flag on the channel. We'd then only allow HT40 if
> both channels' rules enable it.

Yeah but that's rather confusing. And it requires looking at even more
information?

> >> We'd know if HT40 is allowed by the allowed bandwidth in the given
> >> regulatory domain, we'd still have to find out whether or not HT40- or
> >> HT40+ is allowed but to answer this we first need to know on which
> >> channels HT40 is allowed and which channels are disabled. The
> >> assumption is if a channel is allowed then the channel can use 20 MHz.
> >
> > Not exactly -- we could have pure 10 MHz bands in the regdb in the
> > future.
>=20
> Agreed, the above was describing how we currently implement this. If
> 10 Mhz channels are enabled later then the channel's max_bandwidth
> would be set to 10 MHz and we'd then add a check to ensure for HT40
> both channels support at least 20 MHz.

s/20 MHz/40 MHz/ and that's where it gets too complicated IMHO
regulatory wise to treat HT40 as two channels. I'd rather view that as
an implementation detail and say we are nuking 40 MHz of the bandwidth
-- check if we are allowed to do _that_.

> > Ok, yes, we could do that, but it would be disregarding the MAXBW, no?
> > Or rather, how do you define "allows HT40"?
>=20
> Nope, the trick is to also rely on the regulatory rule's max bandwidth
> to determine whether or not HT40 is allowed or not. For example if you
> look at the wireless-regdb and find regulatory rules with a frequency
> range marked with a max bandwidth of 20 MHz you'd know the channels
> that are being queried that fit into those rules would not allow HT40,
> so you set a NO_HT40 flag on the channel.

Yeah, that works, but still seems like a rather complex thing to do, and
doesn't really address the problem of overlap in other areas. It's not
just HT40 that makes trouble there -- it is mostly HT40 _now_ because of
the way most rules were derived originally though.

> > Anyhow, yes, there are different ways to implement this, but then it
> > seems we'd need more regulatory flags, and I don't see a reason for tha=
t
> > given the information we have -- which is only a little quirky for JP
> > and KP.
>=20
> Depends on what you mean by needing more regulatory flags. We would
> certainly not require more regulatory flags in the wireless-regdb or
> crda, nor to interpret them in the kernel. We would however need them
> for the 802.11 code to help cache the answer to these questions. We'd
> need the NO_HT40 flag to cache whether or not a regulatory rule's max
> bandwidth allows HT40 or not, then we could end up re-using the FAT
> above and FAT below flags to indicate NO_HT40MINUS and NO_HT40PLUS. So
> technically we wouldn't be adding any other flag other than a NO_HT40
> flag just to indicate the regulatory domain's HT40 preferences.

Yes, but I think that we should not put this into the flags but rather
into a new bitmask of "supported channel types" so we're in a way
future-proofing ourselves for 5/10/40 MHz channels at the same time. And
then we can also use these bits to disallow Ht40 operation on channels
48/52 -- but we need to take care to not do that bit in the regulatory
code.

In fact, it seems like we will eventually need per-channel-type flags;
imagine a Ht40+ channel where the secondary channel is above the
boundary for DFS requirement and the control channel is below -- in that
case we have different DFS requirements for that channel for 20 and 40
MHz operation.

> Something we should also take into consideration is the changes
> required to the wireless-regdb and what this would imply for users of
> kernel code which interpret it differently. This could potentially
> mean we'd then have to release two different wireless-regdb files per
> release but I think it'd be nice to avoid that if possible

Yeah -- but I just realised that we can actually detect this in the
kernel, if there is overlap then the user is using an old database, if
there isn't then it's ok to use the new interpretation rules.

> An alternative to this proposal is to clarify how overlapping
> regulatory rules should be considered (which is how it works anyway).

Indeed, that is possible too, but I fear that will just come back to
haunt us in the future as new possibilities for using various parts of
the system come up.

> Here's my take on it:
>=20
> If you have overlapping rules you simply apply the first rule which
> fits your desired bandwidth and modulation type. Right now we only pay
> attention to the desired bandwidth, but we could add things like "OFMD
> required" and only return the first rule that allows OFDM for example
> for the given bandwidth.

That works too, but it seems that it would make rule matching a lot more
complicated, no? It also restricts the database use to 802.11 because it
requires the 802.11 channelisation for proper interpretation of the
database, which I think is undesirable.

johannes

--=-YaW5bWxZym2C/afoebVO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJx0u/AAoJEKVg1VMiehFYENIQALbX2OG8wOgsekm2Lzjbj6gy
IVUsz+8h/nMdOD/wjjC1MJ6xYc+1AfLMi4a3Z8OaVSnN2G8kdKUVnkGUgVeGMwvW
zuWC4QFP5HednqqvgzUWpDWjc7BsHtqup1TL3rbE3p8SL/qY6Vd9eeHPCWoJ6nzM
poS6ZJ85lszy+5sBxDEuQC7Zm1wISeBQfn07Nr8EPa07nVOOuIPSCKb5E1jchm+C
/M69RLDrLlMfJgMtzsOeRc/IxwJYS19QawckFeOSjyJDfUEGrnIwj/Z6IGUdhcGp
7RB92/bPpai5pGT3Tlz+jabk8nox+s5vh+wQZfjQU+a+djI07alXs5/bH+pC98y4
P91dzrfsYWCzdUx0+v/kH4oz2VD02RG0rejdtuBV07W9Mh6rtLscaR5DTL6ce6g5
P8Cg3mgYYii+MCsO1nE6EIQ3w9LBY2a+Nr87odgDZFUPCTc46hOMFDcBrU9YHAEH
QR9gS3axujv0sYXBMCi5CWls7F0LQ2tXyvt8hZ3bmTP6wsG4CFCn28MFkSxkFaLB
Wh7mjIBQI9et+VE1NVkZb9P7WQ7Re0NwLK+7xqOw1NjUWb6bk+QtPxG/LpextNgH
5TbTjw3YePwNS81fl5useuRgxrrYob5MKOOas4Qv8A2VUU8Njc1JGrwXEnPpXM/3
DgLM5RX6RAEV5Tev3fy9
=/Nkp
-----END PGP SIGNATURE-----

--=-YaW5bWxZym2C/afoebVO--

