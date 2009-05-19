Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48971 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbZESIdl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 04:33:41 -0400
Subject: Re: [PATCH] mac80211: fix managed mode BSSID handling
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Wey-Yi W Guy <wey-yi.w.guy@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1242674411-26301-1-git-send-email-linville@tuxdriver.com>
References: <1242299414.500.7.camel@johannes.local>
	 <1242674411-26301-1-git-send-email-linville@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-12sUOGSV6QRKLM5di3PL"
Date: Tue, 19 May 2009 10:33:38 +0200
Message-Id: <1242722018.17164.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-12sUOGSV6QRKLM5di3PL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-18 at 15:20 -0400, John W. Linville wrote:

> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -157,20 +157,28 @@ int ieee80211_if_config(struct ieee80211_sub_if_dat=
a *sdata, u32 changed)
>  {
>  	struct ieee80211_local *local =3D sdata->local;
>  	struct ieee80211_if_conf conf;
> +	static const u8 zero[ETH_ALEN] =3D { 0 };
> =20
>  	if (WARN_ON(!netif_running(sdata->dev)))
>  		return 0;
> =20
>  	memset(&conf, 0, sizeof(conf));
> =20
> -	if (sdata->vif.type =3D=3D NL80211_IFTYPE_STATION)
> -		conf.bssid =3D sdata->u.mgd.bssid;
> -	else if (sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC)
> +	if (sdata->vif.type =3D=3D NL80211_IFTYPE_STATION) {
> +		/*
> +		 * While not associated, claim a BSSID of all-zeroes
> +		 * so that drivers don't do any weird things with the
> +		 * BSSID at that time.
> +		 */
> +		if (sdata->vif.bss_conf.assoc)
> +			sdata->vif.bss_conf.bssid =3D sdata->u.mgd.bssid;
> +		else
> +			sdata->vif.bss_conf.bssid =3D zero;
> +	} else if (sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC)
>  		conf.bssid =3D sdata->u.ibss.bssid;
>  	else if (sdata->vif.type =3D=3D NL80211_IFTYPE_AP)
>  		conf.bssid =3D sdata->dev->dev_addr;
>  	else if (ieee80211_vif_is_mesh(&sdata->vif)) {
> -		static const u8 zero[ETH_ALEN] =3D { 0 };
>  		conf.bssid =3D zero;
>  	} else {
>  		WARN_ON(1);

Yes, this looks correct, thanks. The difference is just due to the
config_interface vs. bss_info_changed change.

johannes

--=-12sUOGSV6QRKLM5di3PL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKEm7bAAoJEODzc/N7+QmaLu8P/1ssivPWaq82hXnSZ8W8F/1s
tJMnqrmWRcKxznMseRs89gycNL+U03PQUhQQCSWdzAfoy+x5NJ+b+YiBiH/9laVz
IVPte1BtjoC9IEHk2ElP2DODwm7GIxbHNGt8NKnuN0JLT28ysf55yswGXsd0ozEl
p+PLohy9coz2/n4UiqxGTLiYkFH85NRbi8Y3Bbdr6kuK4q5vbMLYN20ySS6HLE+O
gZX4i1uZh/NMFqnK82/xW79XOWZ4/lkZjxXqyPEsKPC0YFYKMNgndCAzwXUjf6GB
631NXMA+jzirQUFmiWVJSq2STJklP7mVKhhVOpLmfqmoW+ADwv6VNNz4XxnNstQ3
L9r7ZNqejoDmazfTRYcpV2X7yxUE7OgeBhM2B34wKJt1wSEQB6aZOWNTB1hGJ+1E
cPEHWTuyZKKbb9V8deAU63rMIGd1/fhY9wAE7ISOR80rya0d5LluSRbfepxzaTHq
AK/1QVsVGW9uz1Fo5HNvjww+gOwR+6ckfcjfRBC6HuMKeLBVWceAQzSsEUVCj6n1
cEVqvbg8qkF911nCy3ahUNkMMdylCCOSXxxa7TxYoP8LRDHatd7eldza22H5cgVp
GAf+VF8451nYVO3DC6ydEFiyr2sITWOr90bRM7VoOixrS4e3pohAjKkb8qj9jtk8
UmCyQtz5UGkMFYdKulIi
=MPpp
-----END PGP SIGNATURE-----

--=-12sUOGSV6QRKLM5di3PL--

