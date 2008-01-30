Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48120 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbYA3Mql (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2008 07:46:41 -0500
Subject: Re: RFC: unified BSS configuration approach
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	John Linville <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>, mb@bu3sch.de,
	dsd@gentoo.org, linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240801291505p19175a9fj86a50e0d0d8683b0@mail.gmail.com> (sfid-20080129_230530_145368_322A4D70)
References: <c85cb4470801270333r618e53a1yf1fdf118d48b93a8@mail.gmail.com>
	 <1201623943.4394.49.camel@johannes.berg>
	 <1ba2fa240801291505p19175a9fj86a50e0d0d8683b0@mail.gmail.com>
	 (sfid-20080129_230530_145368_322A4D70)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bsMSkFCotznEuDZlBuDv"
Date: Wed, 30 Jan 2008 13:38:30 +0100
Message-Id: <1201696710.4014.14.camel@johannes.berg> (sfid-20080130_124645_103016_8B50BB5B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bsMSkFCotznEuDZlBuDv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Hm, true, that could happen. Does it happen in practice though? I can't
> > see why a low level driver would decide that it should have short
> > preamble or CTS protection on by default. Maybe we should just document
> > initial state? Or we can keep the initial call and remove that "don't
> > call w/o BSS" restriction instead, which seems saner. We should then
> > probably rename reset_erp_info() to reset_bss_info() though.
>=20
> Yes it happens in practices. I think with short slot.
> reset_bss_info() sounds good.

Ok so let's rename reset_erp_info() to reset_bss_info() and have it
handle all the other stuff too.

> > > 1 - change the original intention of bss_info_changed so mac80211 wil=
l
> > > be able to set low-level driver in the "init" or "configure" flows as
> > > well, not only as BSS is formed or changes
> > > 2 - maintain original intention, use "bss_info_changed" only when we
> > > want to deliver BSS configuration when we get associate or during
> > > association state,  and deliver all initial configuration info throug=
h
> > > different ops
> >
> > I prefer the first option since that's essentially just a small
> > documentation change and it makes sense. We just should make sure that
> > it's called only when the device is started (through ->start()).
>=20
> what about reset_bss_info() ?

Well reset_bss_info() would still call ->bss_info_changed(), no?

johannes

--=-bsMSkFCotznEuDZlBuDv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6BvxaVg1VMiehFYAQKVkQ//Qq6cVg3edbS+1wc818dNUMgHEk1v/fbU
PjhPi+e3X40k9gHK3WmG512VVuynPzoWcwb/0XZBOr16hWUzNznBJWXxie+R3yyr
0RQCHyS0qCvqAT+Rf1JXuTEzmPiD1BR/RVkByde+2nD2sdtsrZ7ETzZD+sit3LBs
57Z0ZPx/C1TwbxxyXXztU/zlwZtcITU+qIGeUK37xYiH/P0I88UFwy8MS3iCE6dK
t5IXJySuG2jFcIXWp0VH/VTzFSsEu3pouvLTXqh+UxfhjPhyprSGaHMQKCv8tpyD
m9cKwx76uW9OkW6Hu/yDkT2s665FQ/WduSzEeU7fpozW4jUPAWcNAGHdprG9vNSL
bJ5xZbQPgRkXOFhHb83/YKYodmR4dwrLL65LJYHuIuWRYnL+mvekBbunfnAavnue
3DbjWR5RBFshlAU9RTVE+TgphSK49ntsTCi4iH4Usj7pLw1k3IYo8W4RWCe6UeWZ
mOgFfelFI+GgLmPUda2/IiMXjaKshCYxZ/f6l+2hSyy2juKEdOnVdoRho00f+QGi
VB3S5tlfiHjKzbwpAtBbXmFF/EzcHvi99tRLrTx9DiyJm9e/BOPDz+BlrbDKEdwb
8ggwvmcHYcGya/ixm7iGojpaqP430S2KDFCBZ9b6g9u+ukSoZ/t0DUn0GduY/mhH
/L9dR7JMooM=
=4Xlx
-----END PGP SIGNATURE-----

--=-bsMSkFCotznEuDZlBuDv--

