Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:53996 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab3A3QZp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 11:25:45 -0500
Date: Wed, 30 Jan 2013 17:25:31 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	victorg@ti.com, linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv7 1/3] nl80211/cfg80211: add radar detection
 command/event
Message-ID: <20130130162531.GA27532@pandem0nium> (sfid-20130130_172552_673441_A5E7EA0E)
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1359462120-22898-2-git-send-email-siwu@hrz.tu-chemnitz.de>
 <5107D345.7010101@neratec.com>
 <20130129143652.GA23425@pandem0nium>
 <5109094C.8050703@neratec.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
In-Reply-To: <5109094C.8050703@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Zefir,

> [...]
> >> Not sure if IEEE80211_DFS_UNKNOWN is not missing here, i.e. whether a =
channel that
> >> never passed a CAC (or the CAC has been aborted) is always USABLE. Onc=
e I realized
> >> why ETSI defined an UNKNOWN state, but forgot meanwhile - so maybe onl=
y relevant
> >> for managed operation (like an UNKNOWN state can be overridden by exte=
rnal
> >> information, whereas e.g. UNAVAILABLE can't).
> >=20
> > I've seen the UNKNOWN state in your last mail and your last slides, but=
 didn't see
> > a purpose for it. If you can remember what we need it for, please tell =
me. :) We could
> > reject changes for an UNAVAILABLE channel from outside access if this i=
s required.
>=20
> Double checked it and realized that ETSI removed that state between v1.5 =
and v1.7.
> Before, it enabled the frequency manager to differentiate between untouch=
ed
> channels and channels that passed a NOP (which is the only way to become =
USABLE).
>=20

OK, good, then we can skip it. :)

> > The idea was that a CAC can always be started, and state transition is =
only performed
> > after a succesful CAC. This simplifies the state machine and some corne=
r cases. A
> > channel stays USABLE through the CAC, and is only changed to AVAILABLE =
after CAC is
> > completed. We also don't forbid checking the same channel on different =
WiFi modules,
> > if any of them completes the channel is changed to AVAILABLE.
> >
> Really, a CAC is done whenever you switch to a DFS channel? I'd expect th=
at
> switching from an operating channel and back does not require a CAC (that=
's the
> sole purpose of the AVAILABLE state and a centralized state handler).
>=20

No, as you say: if you switch operating channel to another one which is ava=
ilable, both
channels stay available. You can CAC all channels after booting and switch =
between them
without doing any other CAC (at least as long as you don't sense a radar).


What I was trying to say: If the channel is USABLE before (this is also the=
 initial state),
it is only set AVAILABLE after CAC has finished on this device. If the CAC =
is aborted, no
state transition is done.

If you have a second AP instance (when multiple interfaces are supported at=
 one point, they
are not in the current version), it can also do start a CAC independently f=
rom the first AP.

I like to keep the interfaces as independent as possible, to prevent weird =
race conditions/interactions
between the interfaces which would be hard to debug. :)

> > The same goes for the OPERATING state (defined in ETSI at least) - I do=
n't have this
> > as dfs state, because it is just the same as AVAILABLE plus the informa=
tion that
> > we currently use it, and that we know in the driver. Adding the state w=
ould just
> > add management overhead with no practical gain, IMHO.
> >=20
> Would there be a benefit of an OPERATING state on systems with multiple w=
iphys?
>=20

I don't know - I've not looked up who creates the channels, but Johannes to=
ld me that different
wiphys might have independent channel structs, if I remember correctly.

If we have an OPERATING state we have to sync it over multiple wiphys and/o=
r multiple interfaces
- for example, when an interface goes down we have to check all other inter=
faces if they still
use the channel before setting it back to AVAILABLE. Certainly doable, but =
bothersome.

I currently don't see any benefit, but maybe someone else does and can expl=
ain. :)

Cheers,
	Simon

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlEJSXsACgkQrzg/fFk7axYcagCfZAowe1iu9dD+sG19ZuAw9uV0
mOAAnjDKkw/d8s6q41mwF1hvH4ZKD0RT
=Kdcx
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
