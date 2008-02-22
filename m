Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39749 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747AbYBVQWI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 11:22:08 -0500
Subject: Re: [PATCH 07/13 v2] o11s: changes to ieee80211_sta
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47be773d.22b38c0a.2fbf.ffffb131@mx.google.com> (sfid-20080222_074745_247391_EDD9C862)
References: <47be773d.22b38c0a.2fbf.ffffb131@mx.google.com>
	 (sfid-20080222_074745_247391_EDD9C862)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MJR/hNrjB3/ggE4SHT0g"
Date: Fri, 22 Feb 2008 17:21:57 +0100
Message-Id: <1203697317.7082.68.camel@johannes.berg> (sfid-20080222_162213_269694_1D0DB397)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MJR/hNrjB3/ggE4SHT0g
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	atomic_inc(&bss->users);
> +	atomic_inc(&bss->users);

?
That was just allocated, shouldn't it just be atomic_set() then? And why
two anyway?

> @@ -3622,15 +3790,27 @@ ieee80211_sta_scan_result(struct net_device *dev,
> =20
>  	memset(&iwe, 0, sizeof(iwe));
>  	iwe.cmd =3D SIOCGIWESSID;
> -	iwe.u.data.length =3D bss->ssid_len;
> -	iwe.u.data.flags =3D 1;
> -	current_ev =3D iwe_stream_add_point(current_ev, end_buf, &iwe,
> -					  bss->ssid);
> +	if (bss->mesh_cfg) {
> +#ifdef CONFIG_MAC80211_MESH
> +		iwe.u.data.length =3D bss->mesh_id_len;
> +		iwe.u.data.flags =3D 1;
> +		current_ev =3D iwe_stream_add_point(current_ev, end_buf, &iwe,
> +						  bss->mesh_id);

Ok so you're using the ESSID as the mesh ID,

> -	if (bss->capability & (WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_IBSS)) {
> +	if (bss->capability & (WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_IBSS
> +	    || bss->mesh_cfg)) {

That seems to be parenthesized wrongly?

>  		memset(&iwe, 0, sizeof(iwe));
>  		iwe.cmd =3D SIOCGIWMODE;
> -		if (bss->capability & WLAN_CAPABILITY_ESS)
> +		if (bss->mesh_cfg)
> +			iwe.u.mode =3D IW_MODE_MESH;

If you say wireless-tools are fine with this that's great.

> +			memset(&iwe, 0, sizeof(iwe));
> +			iwe.cmd =3D IWEVCUSTOM;
> +			sprintf(buf, "Mesh network (version %d)\n"
> +			"\t\t\tPath Selection Protocol ID: 0x%02X%02X%02X%02X\n"
> +			"\t\t\tPath Selection Metric ID: 0x%02X%02X%02X%02X\n"
> +			"\t\t\tCongestion Control Mode ID: 0x%02X%02X%02X%02X\n"
> +			"\t\t\tChannel Precedence: 0x%02X%02X%02X%02X",

Maybe we should add separate items for this to make it easier to parse
them?

johannes

--=-MJR/hNrjB3/ggE4SHT0g
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR772pKVg1VMiehFYAQJLoA/+KFZK2ru/y5Pb/VoM3Uf5sa9klgI6edox
xTs5IeBbYCoH2Mulucw3RgXpCaTTHg/RzxHyCEKNcpejAFBVHvaMZOdkyk4AZgx5
7oCWeglTSM5289h4QsYQ7LrYgdgpR+L/bU/EtRK6DrhFHPc7V+mGuD7eXXB/ccAI
ljAAdBAenT6HNbPao4CeCIKtTIAuF5/IN3UsAsD1fHG6hDWtkflLaUbf5yp7Jo8z
cQ0W3qHo1k94w2XMQYkh8/7RkFvYLMeKFelRYx02rSRd5YyF0rexpgFMEOzgB+3a
u9RKdJuOk/o4CSl+jHH4b63tt6YMznS0icBNzLC4HUvChg6ezGT1wLInCSM6+0yh
3iJReul5P+xXlQbt76ciS4cygjpKjI5el+nAuceDCIWVpesbpDkSKLzeFEU0t2uf
ziHLsGR1Ikv7IR4f70qgWey0P0po3vHZvZtZK0sgjcSls/bpeOFQ0AsFmwf4Es2e
qev3SLX3FPg01LPKijQx/PwYDtWhCQN3up79sPEBd+F/7FMlNCeIbHNf2HVtcDP8
4TZRdtzeaKCYMrnZ/aN5gJh6MCX55S+Wf/ROxbX1b9lZXMxK8/CGWZXNQHJ2J6gk
ogIinmjKeWgf83GY+hjW61f3OxdqT6yBLWdrflCmJ1Ibu2z469BX9vrqNZH3CcSI
WHdVH15pfQ0=
=C4ZQ
-----END PGP SIGNATURE-----

--=-MJR/hNrjB3/ggE4SHT0g--

