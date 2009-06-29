Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52244 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757528AbZF2H7a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2009 03:59:30 -0400
Subject: Re: [PATCH] wireless: Compare ethernet addresses by unaligned safe
 way
From: Johannes Berg <johannes@sipsolutions.net>
To: ivan.kuten@promwad.com
Cc: linux-wireless@vger.kernel.org,
	Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>
In-Reply-To: <4A475F82.9040007@promwad.com>
References: <1245149672-18063-1-git-send-email-yauhen.kharuzhy@promwad.com>
	 <1245150895.8623.3.camel@johannes.local>  <4A475F82.9040007@promwad.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-m/FOmKfnfD653g/xhurV"
Date: Mon, 29 Jun 2009 09:58:40 +0200
Message-Id: <1246262320.5947.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-m/FOmKfnfD653g/xhurV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-06-28 at 15:18 +0300, Ivan Kuten wrote:
> Hello,
>=20
> In net/wireless/scan.c : cfg80211_wext_siwscan there seems also unaligned=
 allocations
> for creq->ssids and creq->channels. Should it be something like that?

Seems alright, but there is more than one instance of this, maybe you
can make a function to allocate a scan request properly and have it be
called from all the places it's needed.

johannes

> Modified: trunk/uClinux-dist-2008R1-RC8/compat-wireless-2009-06-11/net/wi=
reless/scan.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> --- trunk/uClinux-dist-2008R1-RC8/compat-wireless-2009-06-11/net/wireless=
/scan.c (original)
> +++ trunk/uClinux-dist-2008R1-RC8/compat-wireless-2009-06-11/net/wireless=
/scan.c Fri Jun 26 14:00:52 2009
> @@ -619,7 +619,7 @@
>  		if (wiphy->bands[band])
>  			n_channels +=3D wiphy->bands[band]->n_channels;
>=20
> -	creq =3D kzalloc(sizeof(*creq) + sizeof(struct cfg80211_ssid) +
> +	creq =3D kzalloc(roundup(sizeof(*creq), 4) + roundup(sizeof(struct cfg8=
0211_ssid), 4) +
>  		       n_channels * sizeof(void *),
>  		       GFP_ATOMIC);
>  	if (!creq) {
> @@ -629,8 +629,8 @@
>=20
>  	creq->wiphy =3D wiphy;
>  	creq->ifidx =3D dev->ifindex;
> -	creq->ssids =3D (void *)(creq + 1);
> -	creq->channels =3D (void *)(creq->ssids + 1);
> +	creq->ssids =3D (void *)creq + roundup(sizeof(*creq), 4);
> +	creq->channels =3D (void *)creq->ssids + roundup(sizeof(*creq->ssids), =
4);
>  	creq->n_channels =3D n_channels;
>  	creq->n_ssids =3D 1;
>=20
> Regards,
> Ivan
>=20
> > On Tue, 2009-06-16 at 13:54 +0300, Yauhen Kharuzhy wrote:
> >> When we try to run RTL8187 driver on AD BlackFin platform, we got
> >> messages from kernel about unaligned memory access at
> >> compare_ether_addr() calls.
> >>
> >> Replacing of compare_ether_addr() by memcmp() fixes this problem.
> >=20
> > This shouldn't be necessary. Which operand is unaligned?
> >=20
> >> --- a/net/mac80211/ibss.c
> >> +++ b/net/mac80211/ibss.c
> >> @@ -395,7 +395,7 @@ struct sta_info *ieee80211_ibss_add_sta(struct iee=
e80211_sub_if_data *sdata,
> >>  		return NULL;
> >>  	}
> >> =20
> >> -	if (compare_ether_addr(bssid, sdata->u.ibss.bssid))
> >> +	if (memcmp(bssid, sdata->u.ibss.bssid, ETH_ALEN))
> >>  		return NULL;
> >=20
> > So in this case it seems that it is possible that u.ibss.bssid is not
> > aligned, consider fixing by doing
> >=20
> > --- ieee80211_i.h
> > +++ ieee80211_i.h
> > -	u8 bssid[ETH_ALEN];
> > +	u8 bssid[ETH_ALEN] __align(2);
> >=20
> > or so instead.
> > =20
> >> --- a/net/wireless/scan.c
> >> +++ b/net/wireless/scan.c
> >> @@ -134,7 +134,7 @@ static bool is_bss(struct cfg80211_bss *a,
> >>  {
> >>  	const u8 *ssidie;
> >> =20
> >> -	if (bssid && compare_ether_addr(a->bssid, bssid))
> >> +	if (bssid && memcmp(a->bssid, bssid, ETH_ALEN))
> >=20
> > Since a->bssid is after a pointer I can't see how it would be unaligned=
,
> > and bssid should be unaligned only if the call trace shows it's coming
> > from the above u.ibss.bssid.
> >=20
> > johannes
>=20
>=20

--=-m/FOmKfnfD653g/xhurV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKSHQsAAoJEODzc/N7+QmaX9IP/3FZ7yky8r4Ph1MRz9T5qCkV
2WqyVnSI4dCm0XtiX5JL9d5hX49Xq961zvJAev+QsOpo7exU/skpS5Jc5zcyRtn2
KoUKW4J9jvZC0SnLV9NVopymry+/3AgaNIitATN491WpSavxIANDqUSivZslp3NP
q45TluCGnwQukhqwMmGvfM0qUrbWzLqGMk6RsfuQRkwl0PXZ3Ye7xtUwBZ67IEPu
r/PzevUzW8m8Yk1a3dVsYP0rlFjV5JRpyxU/Des0/ggPugUCKb4Q0Rcq5xuHT1fV
wxQpi03lsr5xCofFawNJGDvok8jnH833iBaA5hCmAMoVP0RTFeQ3ESKpcTs1lB3c
w+GBmKhH7UYkNLU9QwNkLkz2C1KudFEn4ELWPnz6sq8i72otcwkzhbPeAd1a6fMi
1712DdzN2QAXSgvG5hR9dliv6q6xUuKjRGN3+l3QEghw3KY8T2YgKOqcoW6mw5jo
GwyFzcwwk35Fvf70gouWJbgQaTEOatjhip13tcKlN3Q7NcZdpY2lLdm3aDH1x0O1
N/QyrjLjT7MOfXbFh23+wh+bRzC4I6Q3zA7n3blNvbHVhGGHoveP3Lr6SSoBAkGa
CuQlacemlCaonlKVQGHC1wh4NzwWMFvhwK2I8uv8yKO1DkrNH7U1LE03dubbq6Vz
0SGIHkDH9TqN5Sxxn4wC
=FnGN
-----END PGP SIGNATURE-----

--=-m/FOmKfnfD653g/xhurV--

