Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60444 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbZG3Pc2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 11:32:28 -0400
Subject: Re: [RFC PATCH] mac80211: FIF_PSPOLL filter flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Igor Perminov <igor.perminov@inbox.ru>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1248966336.29068.178.camel@sunlight>
References: <1248962000.29068.170.camel@sunlight>
	 <1248963525.16129.2.camel@johannes.local>
	 <1248966336.29068.178.camel@sunlight>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Wh8J+6qNgjy+RT04jt/e"
Date: Thu, 30 Jul 2009 17:31:57 +0200
Message-Id: <1248967917.16129.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Wh8J+6qNgjy+RT04jt/e
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-30 at 19:05 +0400, Igor Perminov wrote:
> > > @@ -497,6 +509,13 @@ static int ieee80211_stop(struct net_device *dev=
)
> > >  		}
> > >  		/* fall through */
> > >  	default:
> > > +		if (sdata->vif.type =3D=3D NL80211_IFTYPE_AP) {
> >=20
> > I'd probably put this after a
> > 	case NL80211_IFTYPE_AP:
> > label but you need the if () anyway ... hmm I guess we really should
> > clean up this code and split it into two switch statements...
>=20
> And may be do it above?
>=20
> 	if (sdata->flags & IEEE80211_SDATA_ALLMULTI)
> 		atomic_dec(&local->iff_allmultis);
>=20
> 	if (sdata->flags & IEEE80211_SDATA_PROMISC)
> 		atomic_dec(&local->iff_promiscs);
>=20
> +	if (sdata->vif.type =3D=3D NL80211_IFTYPE_AP)
> +		local->fif_pspoll--;
> +

Looks good, yeah, also saves another configure_filter call.

johannes

--=-Wh8J+6qNgjy+RT04jt/e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcbzqAAoJEODzc/N7+QmaqzEQAJTHUL2aLPzsbnrzk71X4yp4
oWw2UKBu4Po/Bv7qRUn4Nz/GFErcy2qWAysi3I6SmtDUu2d3K/eKq0lAW5TO4iGV
cp7eIEXYyxjPwAGnkTzw+XIUW3srfly98mEMHQT6QBONe6hXQDa7rKpEbzLlQyQR
KshpT5fojtTYuqp4wvjf3OUnJ1dvDb68tbQv8Ajeb6JNaQq4lEOeewn0LqPT3Dvs
d8+pViYkbURcNdtVDlT2pp4Xb3mbJNiKS6eTwDo45Ibme0HFhfxz0is9TFFLCu9G
2hgkE/07FDbxmAkRevsUEI/W3WSqviO2huhAJzO3aJBuPDC/d4Srlx+ZsYTCMRmV
I9n5Uf0fOCuR6SjjYHdRNcaxAn5uPB3IsvmTMHBoGq6AAQvJt+Gei/wqsGclMI4t
U468+aFd+4COL6XEEmvsqLc7SlIdd29uSXeU8FjtvmhuMrTm3W5wMH4ZgPwYfZ6C
TqzWCyxUI98OkKVNYBU/C7mR1jGtmRO4+/sg1ef5wKe9MkWRbZ6lBkT26tNPWxl0
m8noMF9gYJxO+EXHJWTCpJuOaDTD+LX4TDv6dvqCfYdLEfXe2zKrpqmIbwF5edVl
v9j3ftFRBKO+MWzNnc7OAsJYu4UUAXemHvZerwZzI3FJ9RkiT9t/m0X4KhFlDkvs
RUGfFTJpOklrNV6t2pF4
=YPwj
-----END PGP SIGNATURE-----

--=-Wh8J+6qNgjy+RT04jt/e--

