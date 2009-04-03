Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35274 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbZDCJXT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2009 05:23:19 -0400
Subject: Re: [PATCH 3/5] mac80211: check if HT40+/- is allowed before
 sending assoc
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1238711166-2208-4-git-send-email-lrodriguez@atheros.com>
References: <1238711166-2208-1-git-send-email-lrodriguez@atheros.com>
	 <1238711166-2208-4-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4VoL/XYgQEgqERg+uisi"
Date: Fri, 03 Apr 2009 11:22:44 +0200
Message-Id: <1238750564.27712.13.camel@johannes.local> (sfid-20090403_112321_308628_76947EF6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4VoL/XYgQEgqERg+uisi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-02 at 18:26 -0400, Luis R. Rodriguez wrote:
> We weren't checking this at all.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  net/mac80211/ht.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
> index 4e3c72f..01010e0 100644
> --- a/net/mac80211/ht.c
> +++ b/net/mac80211/ht.c
> @@ -114,6 +114,9 @@ u32 ieee80211_enable_ht(struct ieee80211_sub_if_data =
*sdata,
>  	    ieee80211_channel_to_frequency(hti->control_chan))
>  		enable_ht =3D false;
> =20
> +	if (local->hw.conf.channel->flags & IEEE80211_CHAN_NO_HT40)
> +		enable_ht =3D false;
> +
>  	if (enable_ht) {
>  		channel_type =3D NL80211_CHAN_HT20;

And that's a bug -- it disallows HT20. But you don't need to check
NO_HT40, just below you check each of the two options anyway.

johannes

--=-4VoL/XYgQEgqERg+uisi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ1dViAAoJEKVg1VMiehFYP4QP/Rr34bD9Ly8LfHAXez7Z+cxz
CaO/SBjTqC4dEJ+6S6A2YwyjaXQX8M1FNVnEhtKmQgd16ZMy+CAI8mqep8qohR1r
CzjuXym8Kns5DoeFzr/RWNVtMDxKkQscacKewV9hjJx/oamP3XKfvD+6CkGnjCCI
fvX6sdQAjghBd4EbYEUniCxi1Qiu9GaoHjT9Nf/0nP/NV5CWW973gitCRoGgXL1x
+8XamXDiwUXsnEjrGkdtnn66HyHS/Qv63rRK2t3zQOP+lobZxQewbwhgBxfR7YPy
HAz57f6zt66PaNbBWh5Ahccp9qTP1t3SjlnEoJ+RsWuvHp8xsuT7dlJOr/7hPcGO
/fg5BMtIXeYpLyoT0YFOQLr8Z/d9i7/hNkgxV0NGG9LE+/U+M2kC9O6sPNhyvO4U
EDP4VLnOz0w0gh7siL80c+/M7q+JLpFybBi3gZe+LzlZFMHfIsmi4Isv4ODg9eAl
Fzqfd+wR66FwOzb+pTshBDOon/ba4YzOjOBpBwld+E+9bLnvbsFQIxx1Sw2bwTH8
xAeKwV1fIhA3mgJaPjekZDD/DmO47onON9PnoPVh+APxgrpJAWDYXZL4cKpzrfWG
YJHYPvR4wpxilffXd6pvl+pue+DHTEX2hr0dflRLgE/VxDftib0+aFwpyyhgM4op
PUNVGX+bYmGzmCg85fRk
=gQ52
-----END PGP SIGNATURE-----

--=-4VoL/XYgQEgqERg+uisi--

