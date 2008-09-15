Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44315 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbYIOP5Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 11:57:24 -0400
Subject: Re: [PATCH 1/2] mac80211: Support iwconfig enc restricted with WEP
From: Johannes Berg <johannes@sipsolutions.net>
To: Ortwin =?ISO-8859-1?Q?Gl=FCck?= <odi@odi.ch>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <48CE837E.2010109@odi.ch> (sfid-20080915_174719_472906_26C0ABC9)
References: <48CE837E.2010109@odi.ch> (sfid-20080915_174719_472906_26C0ABC9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GU9KoLTZmV24DxVRLXhD"
Date: Mon, 15 Sep 2008 17:56:50 +0200
Message-Id: <1221494210.3700.50.camel@johannes.berg> (sfid-20080915_175726_992604_5474600F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GU9KoLTZmV24DxVRLXhD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-15 at 17:47 +0200, Ortwin Gl=C3=BCck wrote:
> The mac80211 code doesn't handle WEP with shared keys correctly. Using th=
e ath9k=20
> driver on my MacBook I am unable to put the driver into restricted mode (=
shared=20
> key). It stays in open mode. That is the following command has no effect:=
=20
> iwconfig wlan0 enc restricted. I can also confirm this when looking at th=
e=20
> authentication packets that go over the air: they are sent with the open =
flag,=20
> and not the shared key flag.
>=20
> Signed-off-by: Ortwin Glueck <odi@odi.ch>
> ---
>   net/mac80211/wext.c |   12 ++++++++++++
>   1 files changed, 12 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
> index 34fa8ed..645c276 100644
> --- a/net/mac80211/wext.c
> +++ b/net/mac80211/wext.c
> @@ -929,6 +929,18 @@ static int ieee80211_ioctl_siwencode(struct net_devi=
ce *dev,
>   	else
>   		idx--;
>=20
> +	if (sdata->vif.type =3D=3D IEEE80211_IF_TYPE_STA) {
> +		struct ieee80211_if_sta *ifsta =3D &sdata->u.sta;
> +		if (erq->flags & IW_ENCODE_OPEN) {
> +			printk("wext: open\n");
> +			ifsta->auth_alg =3D WLAN_AUTH_OPEN;
> +		}
> +		else if (erq->flags & IW_ENCODE_RESTRICTED) {
> +			printk("wext: shared key\n");
> +			ifsta->auth_alg =3D WLAN_AUTH_SHARED_KEY;
> +

Come to think of it, since we already fall back from open to shared-key
when the AP rejects, why would we want to support this at all? The
semantics aren't well defined enough to support it _properly_, that is
have it change the ifsta->auth_algs variable, and touching this variable
as you're doing in these two patches is just plain wrong since it can be
changed underneath (yes, you're removing the automatic changing, but
that's totally wrong).

johannes

--=-GU9KoLTZmV24DxVRLXhD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIzoW+AAoJEKVg1VMiehFYzV8P/Anbo89afAQdfUujNblE5lxq
AB4jVEJ0+f/IN0+NretjHa+5s8fO/qlONNJW4AwWPXIkXGVpw5Pm9HTsT6aUQs7F
jGrIx+Gu4LpGmd/Y/M9sRga/srhHHueigrIPobQOfTlsCNzEbyjmeY8/Z7ahaPnW
YYMrCFsmR6zQ7wBAryPf7eworFzkkaQ/QLqpDzmOsXYCEVNs2gZdX4yOcxnZ3ZcJ
46L1E5vp2zW4OQnpKsvjaD3n6QwXsO3au89K7ZzkQ2mZLKGIkzenfEZGTExV52Xn
EIOu83+G7SS6uXtaNo6icJvQVXe9AQeGMOTQ2jV1TenXUuflhpVn6gs//xAaB+zJ
mJW6S3NanCibGmyXuuD2Dyv/f7QP/OIelu1G/jvrn2+PwxoDIUDgSs5Ol37/W7FH
V2w67W23brpVyfCjrPSUJqTONAzUwJH/7y92AW1kCxF8VepcuBQnpN8me939wZjz
c1hDsSyBQ95b4ZCFYLtwfIFodIjRoKKwabag9AVcWD+R1lhuAlHQE7U7DkIHhyCI
rcNb8xvPBJeK/uQguCWVLbU85mhFj9h1OOWYX7FnuRqCLuyxQFCMiwfw5TJxZ14B
fq/y8s7sZ7eIELgPMAGfkILLP+oG+jjzfVrDgW7WllvQ6FxfnOE3XIx5EAfmGMGZ
L2KNEsRb9YXhfZUmie3z
=DOWB
-----END PGP SIGNATURE-----

--=-GU9KoLTZmV24DxVRLXhD--

