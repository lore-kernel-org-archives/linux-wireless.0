Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45351 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbYLVIpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 03:45:10 -0500
Subject: Re: [PATCH] [RFC v2] mac80211: Scale down to non-HT association
	with TKIP/WEP as pairwise cipher
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
In-Reply-To: <20081222081050.GA3500@localhost.localdomain>
References: <1229927497-30923-1-git-send-email-vasanth@atheros.com>
	 <1229928585.3087.1.camel@johannes>
	 <20081222081050.GA3500@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gvHGHnKJ4yRjMJ8kp1mE"
Date: Mon, 22 Dec 2008 09:45:04 +0100
Message-Id: <1229935505.3481.0.camel@johannes.berg> (sfid-20081222_094517_418328_3EAB70D8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gvHGHnKJ4yRjMJ8kp1mE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-22 at 13:40 +0530, Vasanthakumar Thiagarajan wrote:
> On Mon, Dec 22, 2008 at 12:19:45PM +0530, Johannes Berg wrote:
> > > +	case IW_AUTH_CIPHER_PAIRWISE:
> > > +		if (sdata->vif.type =3D=3D NL80211_IFTYPE_STATION) {
> > > +			if (data->value & (IW_AUTH_CIPHER_WEP40 |
> > > +			    IW_AUTH_CIPHER_WEP104 | IW_AUTH_CIPHER_TKIP))
> > > +				sdata->u.sta.flags |=3D
> > > +					IEEE80211_STA_TKIP_WEP_USED;
> > > +			else
> > > +				sdata->u.sta.flags &=3D
> > > +					~IEEE80211_STA_TKIP_WEP_USED;
> > > +		}
> > > +		break;
> >=20
> > Can't we check
> > the key algorithm for the pairwise key associated with the AP's sta_inf=
o
> > directly in _send_assoc?
>=20
> AP's sta_info will not have the negotiated pirwise cipher before associat=
ion.

Ok. I guess this patch is the way to go then, and we'll figure out how
to make it work with nl80211/cfg80211 when we actually push all the key
operations there.

johannes

--=-gvHGHnKJ4yRjMJ8kp1mE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJT1OMAAoJEKVg1VMiehFYfBQP/2/Pk4sh7tAlZjKSzzR+x0fp
5ZFB7gh4sv8emMRCtaiqqc8VGCDqe6bKANXVHV/dn11Dy5HzNUrtZqFN04L7MzBh
aRU+HamQTtKtoLXs/hWJWb9ia6YTaSoqY0buLlNgLjf6tGKh/MttNTDiFyN8/D0Z
3BjdRLKLy54ciANs8QFJRcTtWT4oHCihgCVB6UYAW1RdHaLlQ7Yrhbg9OwllA7YL
NL73bf9j0AGFWy+MPf7ivmRuV58vMpNbkDl8J4ndysiLXL2pRmZgGjWUb1WomUuy
1e3UKx14c14uOKKgwOgH/Z8nxpkKJpT+WlZMeRhInHbjFSTCthY3sR5GSLGRcHje
FJb82m1zue1sirUHhP/G76PNP/MlPzwGCLYiQYta0bFjbz+IsMHFJf5DSbi3u9pz
MzF3e3xW+obRrL6kBxBDuNOFgaKJNglBdK8O/XdrIq6H0Q/ZvEohzZwq7VtZQGYV
wVgnNzNW2pUtgUXccMlG4guHHWCFZIBuEMe2RTSqrbTVQVAdgQzyv3vJH0U/gCC9
CG7YeELLGWI2X+qHz5tlb4fEpy9HsVLygU2mOx4Mfe/tnZiE76+Q33ChQRX1LQct
fq5Ba674QWYrW1m5R0vGKr0Dni7/JMllCpri8We/qj/kJYc5RzZ/HEk4wvYDycXh
70DNVhWqFjPx6LJwqx8x
=PnBd
-----END PGP SIGNATURE-----

--=-gvHGHnKJ4yRjMJ8kp1mE--

