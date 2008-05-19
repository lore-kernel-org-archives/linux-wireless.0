Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36385 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727AbYESRbJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 13:31:09 -0400
Subject: Re: [PATCHv4] mac80211: fix NULL pointer dereference in
	ieee80211_compatible_rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Helmut Schaa <hschaa@suse.de>,
	John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240805191002mc77db60q6736104923179cef@mail.gmail.com> (sfid-20080519_190253_571615_81F6DC05)
References: <200805191659.43961.hschaa@suse.de>
	 <1ba2fa240805191002mc77db60q6736104923179cef@mail.gmail.com>
	 (sfid-20080519_190253_571615_81F6DC05)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MZ3vA9jgvvotjjUaaFWn"
Date: Mon, 19 May 2008 19:29:21 +0200
Message-Id: <1211218161.6252.56.camel@johannes.berg> (sfid-20080519_193149_264982_446442CD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MZ3vA9jgvvotjjUaaFWn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-05-19 at 20:02 +0300, Tomas Winkler wrote:
> On Mon, May 19, 2008 at 5:59 PM, Helmut Schaa <hschaa@suse.de> wrote:
> > Fix a possible NULL pointer dereference in ieee80211_compatible_rates
> > introduced in the patch "mac80211: fix association with some APs". If n=
o bss
> > is available just use all supported rates in the association request.
> >
> > Signed-off-by: Helmut Schaa <hschaa@suse.de>
> > ---
> >
> > diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> > index 76ad4ed..7aff784 100644
> > --- a/net/mac80211/mlme.c
> > +++ b/net/mac80211/mlme.c
> > @@ -722,6 +722,15 @@ static void ieee80211_send_assoc(struct net_device=
 *dev,
> >                if (bss->wmm_ie)
> >                        wmm =3D 1;
> >                ieee80211_rx_bss_put(dev, bss);
> > +
> > +               /* get all rates supported by the device and the AP as
> > +                * some APs don't like getting a superset of their rate=
s
> > +                * in the association request (e.g. D-Link DAP 1353 in
> > +                * b-only mode) */
> > +               rates_len =3D ieee80211_compatible_rates(bss, sband, &r=
ates);
>=20
> Shuldn' t this call ieee80211_rx_bss_put(dev, bss);  after calling
> ieee80211_compatible_rates()

Ahrg. Umm, yes, of course. D'oh. I really need to look at things better,
thanks.

johannes

--=-MZ3vA9jgvvotjjUaaFWn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDG476Vg1VMiehFYAQIjqw//SmwDOFU2Tt85AAYTc3ISCu/yDuq7w830
exmzkA7mYde2NVs+NnzOxMJzkYr0n3u9+sE6B//5NpK1KJqVK9q5TsqMjyygduej
iGkJgJR6Zps+9Hd6MvMMAgYBPDeT9ImA9XaN1nTWXJQVy+ptUZVlKFl1JXo0IB2+
HkdXsOAVIOZ0Ok5s3EIlbI3cBl7yOCKb8YQSKx3ThobZ2tqy74I8IkLl75BwZa6B
ZemL7uehBy2ysl0vvJL1+5BZXeY54S1RsiqF1IMRHksxSuH+t75dFsMS2wRF5qLv
IjrMK2/mANDBgc9XTJGq2+hliAHlKLmWZXJYZSzlLd/vD0h6V3HVGfMai7Sb7aB0
Otj7huSB7za5vVNp54n4KCmn5pzLde8LkJzGjrfKw7TGOHsPbTBNAbFEY0VIdEth
MdAkQNyULzDYKCIM0zhEnpgw2u8mPP5yrcfG+lhOG0XJcCdPWebnwQZh0hFmcjQs
vnsV5XzgZepI35K5NwKAaEcJmdjFsJgLKoEyA2ouUbilqUMDcVARpgKFX51242Hh
/vOVR/1ADRDzTSpiFV6oYSpnEJ7hNP9i8Is1zqeI6lEjyrAFnuxAVeVv9OIEDo70
WWxS/p8+ZAwk2nuDT8sTcEeWnwbY/EAele/coDkMNSigmso/ZeHLU+EWQw57otY8
CxOWWN5s5jo=
=cXhI
-----END PGP SIGNATURE-----

--=-MZ3vA9jgvvotjjUaaFWn--

