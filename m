Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55844 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbZDSILx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 04:11:53 -0400
Subject: Re: [PATCH v2] mac80211: fix beacon loss detection after scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "John W.Linville" <linville@tuxdriver.com>,
	Jaswinder Singh Rajput <jaswinder@kernel.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090419054719.16621.48938.stgit@tikku>
References: <20090419054719.16621.48938.stgit@tikku>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Ta4RcPAaYYa2fr8+X+/x"
Date: Sun, 19 Apr 2009 10:11:42 +0200
Message-Id: <1240128702.25826.3.camel@johannes.local> (sfid-20090419_101159_887657_DB4729C2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ta4RcPAaYYa2fr8+X+/x
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-04-19 at 08:47 +0300, Kalle Valo wrote:
> Currently beacon loss detection triggers after a scan. A probe request
> is sent and a message like this is printed to the log:
>=20
> wlan0: beacon loss from AP 00:12:17:e7:98:de - sending probe request
>=20
> But in fact there is no beacon loss, the beacons are just not received
> because of the ongoing scan. Fix it by updating last_beacon after
> the scan has finished.
>=20
> Reported-by: Jaswinder Singh Rajput <jaswinder@kernel.org>
> Signed-off-by: Kalle Valo <kalle.valo@iki.fi>

Thanks.
Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>=20
>  net/mac80211/mlme.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index c0f91d5..1b8509d 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -2005,9 +2005,17 @@ static void ieee80211_sta_work(struct work_struct =
*work)
> =20
>  static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sd=
ata)
>  {
> -	if (sdata->vif.type =3D=3D NL80211_IFTYPE_STATION)
> +	if (sdata->vif.type =3D=3D NL80211_IFTYPE_STATION) {
> +		/*
> +		 * Need to update last_beacon to avoid beacon loss
> +		 * test to trigger.
> +		 */
> +		sdata->u.mgd.last_beacon =3D jiffies;
> +
> +
>  		queue_work(sdata->local->hw.workqueue,
>  			   &sdata->u.mgd.work);
> +	}
>  }
> =20
>  /* interface setup */
>=20
>=20

--=-Ta4RcPAaYYa2fr8+X+/x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ6ty6AAoJEKVg1VMiehFYjhoP/3YwErcdlrFFHKgMI7NX/tO7
GFwh2NT18ygXVezXOGyosHZzNjv4y3SkccJXU2iXSPdXY3nFlMGIQghtIsOP1Mnf
gigU/UcL0AkZ3Ri9QmMZgxVK/MwCXa+eE9liz3SxrR4UoMrT6TKDlqdv2aq9xvK7
TLd6I2A6VPlvdwGrpMj93zX8IzmpzSXEMyNBHmXtRRYqx9JkicmGMwU5YOMwolsm
gAkKHXk76K3RystrSWv2JkCCO33PEJ0yMLn2kBsbj9HxM+hvIlhmk+9P6Ta3fcNG
PwI67FfBuv3pTVejch95etZo4+98ieM178nDHvTxI04WhJFP/18oOajQp/uADKsp
x8g9s8DWLfLoYQKdCM+2Ax5TRmfligR1rizwPeWf4aTrn4Plee485/abH87zSPGQ
CBpbo5cKYCI8O2FCrNDuHtdq7GkJTbVF53nVHPlPTHKaoQfp6aCOx59gvGJnMPiC
+Yv/RWaZ1zPTBdWeVu6xGdjDljnHtWOWeuYyNW2VC2DRIfn4HMro/aalxhmKiriS
IXvOkxU+sQ0XT8WfP3s0cfP2i+tx+qi0oqOsysNfWKJT6N2XgsGOiVLCWMYtwpuE
ykO0b08wFUqh/sDBDidGxV/r9fCz+gyQon3Qh2gKnbb0nR1Y4/ZFZbqWV19lzHFn
iqbmNrgJT7Xg0EKAmj0+
=y743
-----END PGP SIGNATURE-----

--=-Ta4RcPAaYYa2fr8+X+/x--

