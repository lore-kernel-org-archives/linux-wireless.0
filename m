Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44028 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758179AbYEVTN7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 15:13:59 -0400
Subject: Re: iwl4965 - wpa_supplicant can't see 5Ghz frequencies -
	2.6.26-rc1 kernel
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Vincent C Jones <v.jones@networkingunlimited.com>,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <egrumbach@gmail.com>
In-Reply-To: <1ba2fa240805221151q2e53b069n6658c6cd7d6f4ba0@mail.gmail.com> (sfid-20080522_205154_739984_95576FF6)
References: <1210352234.3763.23.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805101156q4dc52c2bt47d2f6e51b611eea@mail.gmail.com>
	 <1210456110.3787.26.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805101506p78c3eeb6q6e980ac4200fd56f@mail.gmail.com>
	 <1210474179.3787.31.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805120950mf983e97qac4cdfa2c84b6662@mail.gmail.com>
	 <1210617467.3792.4.camel@X61.DFGI.com>
	 <1ba2fa240805220953u746d3429q50faa1885104cadb@mail.gmail.com>
	 <1211478969.3698.56.camel@johannes.berg>
	 <1211481249.28022.15.camel@localhost.localdomain>
	 <1ba2fa240805221151q2e53b069n6658c6cd7d6f4ba0@mail.gmail.com>
	 (sfid-20080522_205154_739984_95576FF6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IhXPSPGPaZcfwyUcJuP9"
Date: Thu, 22 May 2008 21:12:48 +0200
Message-Id: <1211483568.3698.66.camel@johannes.berg> (sfid-20080522_211404_896413_C3BB8717)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IhXPSPGPaZcfwyUcJuP9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > wpa_supplicant cannot handle A-band channel #s.  Thus, with the previou=
s
> > code, the FREQ+frequency was sent first, and the FREQ+channel was sent
> > second.  Sending the FREQ+channel second made the supplicant overwrite
> > the value it already parsed from the FREQ+frequency for that BSSID.  Bu=
t
> > since the supplicant can't handle A-band channel #s, you end up with 0.
> >
> > Reversing the order of these two makes it work, but it's a total hack.
> > That may be what's needed right now though until everyone fixes their
> > supplicant.  There's overlap on A-band channels 7 - 12 (5035MHz ->
> > 5060MHz) with B/G band channel #s.  Obviously WEXT falls over here
> > because the band isn't passed.
> >
> > But what's the best fix to the supplicant?  It could just parse A-band
> > channels and where the numbers overlap, assume B/G band.  Or, it could
> > be patched to prefer FREQ+frequency over FREQ+channel if it received
> > both.  That's probably the best solution.

Fun. How about it we just make wpa supplicant ignore FREQ/channel
completely if it uses FREQ/frequency anyway?

> Actually we've also tried to removing FREQ+channel part and it has
> worked. So wpa_supplicant won't get into this dilemma.

Makes sense.

> Patch that broke it is below so  I guess the bug is in everything form
> 2.6.25 and up.
> '
> commit 8318d78a44d49ac1edf2bdec7299de3617c4232e
> Author: Johannes Berg <johannes@sipsolutions.net>
> Date:   Thu Jan 24 19:38:38 2008 +0100
>=20
>     cfg80211 API for channels/bitrates, mac80211 and driver conversion
> '

Yeah, sorry about that. Once more, bitten by the assumption wext was
useful and people would implement it properly.

johannes

--=-IhXPSPGPaZcfwyUcJuP9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDXFr6Vg1VMiehFYAQLixA//U+l4iPeGGXELUMoTxIAA/LR6oIt38kih
JAvE5Tvyyzvg7+L4DmBce8s/kTWD1cnqmIqDextfH6G/6fULXfe1JFFoKgM7nuKn
gXnUpMwp3/BqLaYGv1qiPkRQmSaFo9b0Ls9LbscsM8xeUZN+d0U41kaygyTthjdE
NdQgnB1quXR7O6YkKvkXPobRp2tSbjJNJF47Zv/uYRMIU77cl5Fw5RZpk+nFfPpw
NvKIvdSPxOo3crhUtwdsWDIuZg/Aq+GzTQrE9FwR5hzrvi8CsjE5JGV9B+9w7taA
9D/TELDlwFKIcgasvRx+v9AyIWRVEeh/nTyoJ7e6MI+do4alxkMutL6mbOI9thHT
cymEZxKbYfiKdGRMQhhAKsROXTYxFnUDO7zmW7JZRHkzBAe0KUscXiWqvPwYK86A
8JzC5tRf4cDt0ptx9XOKn8Qp2u8rhLoHs6Z1k4wSO9Lg6s95eZ1HNfgc78nfHLz+
hkvTSHQyJt7k3jG87gOX0mXEtq6Eah3e/YWuWgJWl0ZvNsGkX56gj/s5mNEE4LD3
xbyaGX6rSCYj2pzi/lpcwea1bqv2wVz6tUkqAV1i9OhyHdeWrY6UYFcSSt7xHduw
LeSPOxmiUsIgaMXk6cInhsbaX+kdU2WLLcHQeWgNAgcq+GAUAV9sM4ju4zwKhANj
9ZrdqbW97qo=
=AIxP
-----END PGP SIGNATURE-----

--=-IhXPSPGPaZcfwyUcJuP9--

