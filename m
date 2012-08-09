Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:43137 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756303Ab2HIJpI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 05:45:08 -0400
Date: Thu, 9 Aug 2012 11:44:56 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: add sta_update_rates callback
Message-ID: <20120809094455.GH6767@ritirata.org> (sfid-20120809_114514_821245_A85B60AE)
References: <1344474712-22561-1-git-send-email-ordex@autistici.org>
 <1344492897.4494.1.camel@jlt3.sipsolutions.net>
 <20120809093245.GG6767@ritirata.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hABqaeELJqnDDeDE"
In-Reply-To: <20120809093245.GG6767@ritirata.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--hABqaeELJqnDDeDE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 09, 2012 at 11:32:46AM +0200, Antonio Quartulli wrote:
> On Thu, Aug 09, 2012 at 08:14:57AM +0200, Johannes Berg wrote:
> > Also there's already an update call sta_rc_update() so I think you
> > should just define a new change flag for that?
>=20
> mh, at the very beginning I thought it was not correct what you said, but=
 indeed
> we should be able to do the job in sta_rc_update().
>=20
> But then why does the ath9k_htc driver implement ath9k_htc_update_rate() =
to
> update the rate used to talk to the AP? Should it use sta_rc_update() as =
well?

Well, I am digging into the driver a bit more and I realised that the suppo=
rted
rate set does not touch the RC at all. The supported rates are only stored =
in
the device (this is why there is another function for doing that in case of=
 STA
mode) and then the RC will play its game from a different point.

For the reason above sta_rc_update() can't do what we want. At this point I
think we have two options:
1) mac80211 forces this change to be done by sta_rc_update() =3D> ath9k has=
 to
adapt it's implementation to follow the API
2) mac80211 uses another callback (sta_update_rates()) to refresh the suppo=
rted
rates set.

I think that option 2) is probably the way to go, because the RC stuff is
usually not strictly related to the real device (e.g. ath9k has its own rc
routines shared among ath9k and ath9k_htc but they have different routins t=
o set
the supported_rates set for a station.)

Cheers,

>=20
> Cheers,
>=20
>=20
> >=20
> > johannes
>=20
> --=20
> Antonio Quartulli
>=20
> ..each of us alone is worth nothing..
> Ernesto "Che" Guevara



--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--hABqaeELJqnDDeDE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlAjhpcACgkQpGgxIkP9cweygQCgg3zga1OB3hBcjqzXpEs2uwxw
UGgAn1djpTL2WaeVcqYQzpgLyd5g8Vpo
=kmsE
-----END PGP SIGNATURE-----

--hABqaeELJqnDDeDE--
