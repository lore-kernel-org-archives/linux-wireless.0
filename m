Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34163 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204AbZJKJn6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 05:43:58 -0400
Subject: Re: [PATCH] mac80211: fix logic error ibss merge bssid check
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <4AD14F26.6030304@openwrt.org>
References: <4AD14F26.6030304@openwrt.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-zCJ/2E7WuAGDLGTgnALp"
Date: Sun, 11 Oct 2009 11:43:16 +0200
Message-Id: <1255254196.4095.44.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zCJ/2E7WuAGDLGTgnALp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-10-11 at 05:21 +0200, Felix Fietkau wrote:
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>=20
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -544,7 +544,7 @@ static void ieee80211_sta_find_ibss(stru
>  		       "%pM\n", bss->cbss.bssid, ifibss->bssid);
>  #endif /* CONFIG_MAC80211_IBSS_DEBUG */
>=20
> -	if (bss && memcmp(ifibss->bssid, bss->cbss.bssid, ETH_ALEN)) {
> +	if (bss && !memcmp(ifibss->bssid, bss->cbss.bssid, ETH_ALEN)) {

Acked-by: Johannes Berg <johannes@sipsolutions.net>

I'll also send the race fix now, would appreciate you giving it a try.

Thanks,
johannes

--=-zCJ/2E7WuAGDLGTgnALp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK0aixAAoJEODzc/N7+Qmal7gP/2dyfZEwEDYqjpOp/LC3X4MV
QwNs5avdsLFPclVpGNoyUQO6FXlrUCJdPWhqoJc7LXDCA7cEemh2gxMH3Ghp+NbY
grXMxp0hB5FQrYIt+QV8t5NeAUo7QJuVKHSvLqaq6TJ7WSavV0PU0ZlO8OUd41Y9
NPZgUVocuWDSLmq3+PCWSZpJzKV5BcWmd47lrUuTDv3y3zGHtBy0arCr+SUDx6nx
OHK7qto0NHkg0hggCRvqTiob66ARgjZ+PS4K2S7bbx8AFQtm1u/1DsV59dgZ68S6
mxIn7dERMyqTk/7216HG3dZEojg9uOoQwpQI9ZDPUrubZILdUzJAnxqGKYrWmckC
qaeZf6aBjE0A/tZAGaFFYHtezD8/+wieuhkqsX0VUrrnfWI4iUu9bcLfPtWtw+lk
gziZNITH6m62f6Yy7T1n9lXWtTRsfMeCgnXfq9r2LWLsigT7z1BMT1xhpjVOOvXO
uAh/ChypsS53c0CS+IQGvm/iaQERtI5eqKsst+6GfJGfeTX7vkiTUqZ91GhJk5oV
5lR5y7f5QHPs0mssipC5x9S2L4+LPN9lyIc/TWoH2bxERr/2OPIViteJcLV4KZs5
Pi6p/77Ht0CVxzQoKozgbdfbUoRT06F67ll4MplzcWFi/RDmXmsR+W2NtlEPyOrc
px/5mrW2k4MjBNgvSb6I
=PH71
-----END PGP SIGNATURE-----

--=-zCJ/2E7WuAGDLGTgnALp--

