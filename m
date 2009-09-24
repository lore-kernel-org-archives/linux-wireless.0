Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39565 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbZIXK3S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 06:29:18 -0400
Subject: Re: [PATCH, v2]: nl80211: report age of scan results
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200909241221.01456.hs4233@mail.mn-solutions.de>
References: <200909241221.01456.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-WoxSOJ+ja24762lUe7Qd"
Date: Thu, 24 Sep 2009 12:29:19 +0200
Message-Id: <1253788159.3868.23.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WoxSOJ+ja24762lUe7Qd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-09-24 at 12:21 +0200, Holger Schurig wrote:
> Linux keeps scan results up to 15 seconds. This can be a problem for fast
> moving clients: they get back stale data. But if the kernel reports the a=
ge
> of the BSS items, then user-space can simply weed out old entries by itse=
lf.
>=20
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Fine with me, I don't care if there is a #define or not.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

>=20
> ---
>=20
> v2: renamed NL80211_BSS_AGE_MS to NL80211_BSS_SEEN_MS_AGO to underline th=
at
>     it's a relativene time
>=20
> --- linux-wl.orig/include/linux/nl80211.h
> +++ linux-wl/include/linux/nl80211.h
> @@ -1277,6 +1277,7 @@
>   * @NL80211_BSS_SIGNAL_UNSPEC: signal strength of the probe response/bea=
con
>   *	in unspecified units, scaled to 0..100 (u8)
>   * @NL80211_BSS_STATUS: status, if this BSS is "used"
> + * @NL80211_BSS_SEEN_MS_AGO: age of this BSS entry in ms
>   * @__NL80211_BSS_AFTER_LAST: internal
>   * @NL80211_BSS_MAX: highest BSS attribute
>   */
> @@ -1291,6 +1292,7 @@
>  	NL80211_BSS_SIGNAL_MBM,
>  	NL80211_BSS_SIGNAL_UNSPEC,
>  	NL80211_BSS_STATUS,
> +	NL80211_BSS_SEEN_MS_AGO,
> =20
>  	/* keep last */
>  	__NL80211_BSS_AFTER_LAST,
> --- linux-wl.orig/net/wireless/nl80211.c
> +++ linux-wl/net/wireless/nl80211.c
> @@ -3105,6 +3105,8 @@
>  		NLA_PUT_U16(msg, NL80211_BSS_BEACON_INTERVAL, res->beacon_interval);
>  	NLA_PUT_U16(msg, NL80211_BSS_CAPABILITY, res->capability);
>  	NLA_PUT_U32(msg, NL80211_BSS_FREQUENCY, res->channel->center_freq);
> +	NLA_PUT_U32(msg, NL80211_BSS_SEEN_MS_AGO,
> +		jiffies_to_msecs(jiffies - intbss->ts));
> =20
>  	switch (rdev->wiphy.signal_type) {
>  	case CFG80211_SIGNAL_TYPE_MBM:
>=20


--=-WoxSOJ+ja24762lUe7Qd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKu0n3AAoJEODzc/N7+QmaZ14QANQO6dg9QnbhOMh/RvXLk7cp
kuboBEwj6ark9kf3yhDHqJdY9plzMwK3UV0zbLSQzrGJ+1wAc3yIlfA9CQ+hjXRX
6lGXVcioJ67lXEl83pGq2Auo4XIbKGxfXiqrlJU0Aq2iBxID9z7Sl7EoSlZuoXKG
qqlZ9/lMZZOJg8tUIdtKfe6qVZd7Z7hM0spSiDGPSnRC+kiGYCBB0pnQNOWnOzFO
u3ZupgnOJ30yrvZukF7NfSQYC8G94Y1I4rKC6tauhFaeS2YLNjleCkDhEBP9G0gj
6/g/4Udlq+lwL9f39m8PfEfnAg3gSW5Aogoofpjr8NPukYl0oPAwfggPvAqp2YGs
ouRa/Pmdpf8zniIcDMNIEsHh7v7OTDV0WydayxCvNFLqJQWxFZD6XvBijCzp1NFs
3OXZTT/qxpeUuPiDB8jn53vYnOWmACznmOq62zauWwUYfpwmDGGYzhvfjn1/Wj2w
m/ScWC72zfc96m7+FSFsb76EkgxrgXY66sAViU4rR39KrMxvn9lrKrLiI6AOSrjk
E8oog2+wUxbmVwnn7IJ75RXmbdbIp9JBUeYcBhe0+3KTmSS10MhBKkwMfzLpjIJR
cmmnC0892lzjUDVOdEef7yArkZnM6aGtKqMCdFTXaGqPnkcf/jr6ubPnZLpmbxBH
tdShv8W6GAGgUwiMxFZa
=Rgk5
-----END PGP SIGNATURE-----

--=-WoxSOJ+ja24762lUe7Qd--

