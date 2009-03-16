Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36877 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbZCPHPi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 03:15:38 -0400
Subject: Re: [PATCH] mac80211: Tear down aggregation sessions for
 suspend/resume
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni.Malinen@Atheros.com
In-Reply-To: <18877.56125.181203.703218@gargle.gargle.HOWL>
References: <18876.41851.397740.847705@gargle.gargle.HOWL>
	 <1237140134.24621.0.camel@johannes.local>
	 <b6c5339f0903151828m4e5b3d2dg5ae03bbed5538bd4@mail.gmail.com>
	 <18877.56125.181203.703218@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-lIHMr14m2PMwzKnpUd/u"
Date: Mon, 16 Mar 2009 08:15:28 +0100
Message-Id: <1237187728.27769.2.camel@johannes.local> (sfid-20090316_081542_593055_2EA0AE7B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lIHMr14m2PMwzKnpUd/u
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-16 at 10:23 +0530, Sujith wrote:

> > I think the deadlock went away, not sure what fixed it but I guess
> > the HT rework.  I tested it a couple of weeks ago on ath5k and Luis
> > did on ath9k so I say let's go ahead and apply the patch... in the
> > meantime I'll try again on ath5k just to be sure.

Ok.

> There is a window for a race. Something like this:
>=20
> From mac80211:
>=20
> __ieee80211_suspend()
>      tear_down_BA_sessions(TX, RX)
>           ampdu_action(STOP)
>                remove_vifs()
>=20
> At this point, the driver executes its remove_interface routine.
> While we are doing this, a TX completion interrupt could be raised,
> (HW hasn't been stopped yet) and nothing stops the driver from calling
> ieee80211_start_tx_ba_session().
>=20
> So the question is: should mac80211 deny ADDBA requests in this case ?

Interesting observation. We probably should indeed reject that, and also
if the peer asks for sending aggregation again right away like some
Broadcom APs will.

johannes

--=-lIHMr14m2PMwzKnpUd/u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJvfyNAAoJEKVg1VMiehFY5P4P/Rnk5hlaZYAfHtbjNoDxJwuv
CwcS2QqmVfMGgGgbjTOtlEbUcdn3DlRXmP5BNMPWSFQ//FlHPx8mGad5d/kd6RuB
bXHa5ECprokE7eYd1kcz6RCGhk/8uPMf4F8s3N3/zmB0pPTy6hyAfkJ7BoaoZfCH
sIQGAqqa3zORK5KM9dnXzdAuaTYB5492PnJL9l+qtYs/RWuHHLoksb/1rOxDEqW/
D2BAwd7Xk1tIfHZdY+TMm9zYk89ZtL0sjQGIkuy1kbG0cLYo/roiNRj2t7cJxO49
/vJfCv/Cvwtq8pUtkRVhAMSLMSvTHEy6gz6lvglTbuHCZ1EmAIWxGUZwyFNHi+2R
IAjQRH2mMEedI60Grn5vPCTTLF6Tm7DrXi6JYLznGLWK6HJfjmFiAv9qj0Yhr5qH
VdiJqryff5jIsszEGpNyBC2f6OvLgkBM7w4qypnUpUwZ8D1+CYx+I0H5yAL7rl/5
pA/s/hyRZnR+m7FyhU9LXbzGYelwk06028oeJ88ZjqfJgZvoSbS0qKkRpfmydqWb
PC2XdCUPctCLlQ1x025fF2rQU0Omfbrcp342/dQUEX8BDFQKFzd2MZVfb3KASr+l
YIaFaVN3nYDi/ZX3C/RYkAj1abLIRj63SoQsaszw6sSILJ0F54zr5NYJsH1mZUfN
ryz4wsNpxWK1yOn0sy6X
=p6V+
-----END PGP SIGNATURE-----

--=-lIHMr14m2PMwzKnpUd/u--

