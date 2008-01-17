Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35687 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbYAQPR6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2008 10:17:58 -0500
Subject: Re: [RFC] nl80211: export frequencies/bitrates
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890801161350v3cb44068p15a32b71af26a8d2@mail.gmail.com> (sfid-20080116_215041_038995_5EDDE572)
References: <1200439921.5887.148.camel@johannes.berg>
	 <43e72e890801161350v3cb44068p15a32b71af26a8d2@mail.gmail.com>
	 (sfid-20080116_215041_038995_5EDDE572)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IjSjN9FnxY7P2lj0wlbp"
Date: Thu, 17 Jan 2008 16:17:43 +0100
Message-Id: <1200583063.8007.32.camel@johannes.berg> (sfid-20080117_151802_936293_F3AE2E29)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IjSjN9FnxY7P2lj0wlbp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> If you mean by "SET support" as for SET support for the regulatory
> domain struct then no, I need a few more. Here's a list of some:
>=20
> * Power (EIRP, IR and for PtP or PtMP)
> * Antenna gain
> * Environment capabilities (Indoor/outdoor)
> * Modulation capabilities

Right. I haven't really considered any of those yet so yes, you'll have
to add them.

> Of these we can use to export more wiphy capabilities:  power (just
> IR), modulation capabilities, and antenna gain (we could assume ~dBi
> for antenna gain, and let user configure this).

Sure.

> Hmm -- not sure if rates should be an attribute of the band. In terms
> of IEEE-802.11 I would think we could add to the band IEEE-802.11
> "modes" (a, b, g or n), and each mode can have a set of modulations
> and each modulation a set of rates. This is from the wiphy device
> capability point of view.

Well, "modes" don't really make sense any more, ever since 11g and
especially with 11n it makes a lot more sense to specify what sort of
operation the hardware is capable which in which band (2.4 or 5 GHz).

> From the regulatory point of view I broke
> things down a bit differently -- a band can have set of subbands and a
> subband can have a set of possible modulations (flags). This is
> because regulatory laws usually speak about frequency ranges and on
> these ranges you usually have the same set of power/antenna
> restrictions. One thing we'll have to think about later is channel
> usage for 802.11n, haven't started toying with that yet in terms of
> regulatory restrictions but I think it may just be the list of
> channels (center of freqs) which can be used at the same time.

Right. So you're saying we should have sub-bands here? Do we really need
to have per-sub-band modulations rather than per-band as we do now?

> Should we have an nl80211_wiphy_band_attr and an
> nl80211_reg_band_attr? Or should we try to come up with just one which
> would work and make sense for both device capability and regulatory
> structure definition?

I think we should use just one. On the other hand, regulatory info is
only relevant temporally while hardware capabilities don't change.
Therefore, if there really need to be modulation restrictions a la "no
OFDM on channel 1 in Takatukaland" we could add a NO_OFDM flag to the
channel and use that to disable/enable OFDM rates whenever we change
channels...

> Is @NL80211_FREQUENCY_ATTR_CENTER_FREQ too long? If so then can we
> specify that its used for the center of freq in the kdoc comment?

Who's going to type it? :) I called it "center frequency" all through so
wanted to be consistent here.

johannes

--=-IjSjN9FnxY7P2lj0wlbp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR49xlqVg1VMiehFYAQI7xRAAgJzYRafSakiN0pezs21R9EhhUUs75U57
3lBqMwZHk8ihTCRr6SGzZC7WeXgIgK3lWP02H4q86zrKoY3EU5yEPRsQQwKihKdm
wORXqA2ex0HWUuQ88bZAwxZnOaaQBLSwXVUqyEyCP5DmiAaNPZtBDW1sxIRElPDg
avzBL4ZcJ3YPPk6R0QJmNmUK5Kgp8CuXXYnL2rGDVqY0zBDATLlAlrgqwq/O2Zxw
UeHvmIQPkRjkrhmyCUQaPBnWTcFnH+f6ldmeuZR7y4uTF4zPmrXywsV8gW/LwWg/
itrmEOHwRqB6ItjoFaVaRY837rHwYhq1LF8KLr6fPfPMIQUeOK7AomfA/tzh6W4w
OE1A3tXlKBesyO5Ck3PKoUfOqGQATrZdSdDbWHeIIAExTfkgFiwUVswk4sUdbS5b
VpzYY7gDMKJeetqv3TUUa2RchUBEOxJhVcHm4sOmk0on6urIlEVm5XG/Eb7GsW3H
6ry3gcFPXarXMoBmnWA8Jpn4MboBo78EJIh0wqm6/m9Gg4miWrgLzzUHD7pBjUxs
BXD7TvX7ufZRsNdvYf1qWTOvLbtIrryExfhxvvfG5gFga8mt70EL/XBUNl4JVZuY
O/FcqsKOWyLEWpqHOYGgcv3LIn+Tm0BxHLXtEOKo1itHNg4pUP072CjY6NH3Gcbl
42oTu0SSkmY=
=yCv3
-----END PGP SIGNATURE-----

--=-IjSjN9FnxY7P2lj0wlbp--

