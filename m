Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44819 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbYIOPuA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 11:50:00 -0400
Subject: Re: [PATCH 1/2] mac80211: Support iwconfig enc restricted with WEP
From: Johannes Berg <johannes@sipsolutions.net>
To: Ortwin =?ISO-8859-1?Q?Gl=FCck?= <odi@odi.ch>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <48CE837E.2010109@odi.ch> (sfid-20080915_174719_472906_26C0ABC9)
References: <48CE837E.2010109@odi.ch> (sfid-20080915_174719_472906_26C0ABC9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WJNbBYfKuwUQqWpR2MCs"
Date: Mon, 15 Sep 2008 17:49:26 +0200
Message-Id: <1221493766.3700.43.camel@johannes.berg> (sfid-20080915_175003_767407_27BB4438)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WJNbBYfKuwUQqWpR2MCs
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
> +		}

remove the printks please

johannes

--=-WJNbBYfKuwUQqWpR2MCs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIzoQCAAoJEKVg1VMiehFYHpAQAK2ZAVqvi0ClWtM6cbDGLkjm
veR+syP3Yga0KF0EEeLQ8DbBtxwdo2hciI1vWMB1Ve4PjLP2TL7SkX0X8xx3xhIR
T/k/lAo3NMVACanLRhk/TfHD9fwhXrHgyl1sJjUrdjChwM4BCcHDLOy8xMCskjHr
0rpvAuc3OOsOyCJDsaPZ82U+eiRAQLr2mzwcGoRtifTTh75pn0PjukwTXPJaZf5r
ecdaPNqTzBQvXbwKy9DwwgxeLwKWqr5AOEVi/4uL/Nces/GWNRoEA9HErCqUbprH
lPnni+LLG9hofhPC2Erh5rIgheaYr9CznB9mVc5Q8L7hi4L4QSgYqHX+ECC/7jWJ
QIOcTcjKaZLmYxKQEVqGXtLHMCyJAWLMHADK7JRMI8g+JYLBqnnBf6CA1N2c+qtN
mkiJpRxKZlcm4WS1RPUmgqT3AxkLchnhEuox1yFUD9yXb7ZKA4IT9mOxsACNhn3i
l7Ttzhs4P4fWQ0NQEFoNKarBKXcZiTxMWr15/YAS9FRqgiO5mXDul8qONbJBEg9R
NsQOvKMyomQjFWaC4NLk2doGdRaSnNISynr8S0+8ERaHfNdDv/lGNsDbVp2uVL1X
nSakEuBccAKdqNmkoTdqYlmFka1x9uOv8hLwntfi24c/vx9ViG24y1RQ3JAGMzF8
t3ri6BVFb0TZIGlCrltM
=z3Oy
-----END PGP SIGNATURE-----

--=-WJNbBYfKuwUQqWpR2MCs--

