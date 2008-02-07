Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42043 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760133AbYBGKgR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2008 05:36:17 -0500
Subject: Re: [PATCH 04/13] o11s: various definitions and support functions
	for mesh interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47a7826d.08102c0a.1d2c.ffff96d2@mx.google.com> (sfid-20080204_212413_136777_9A62E0BA)
References: <47a7826d.08102c0a.1d2c.ffff96d2@mx.google.com>
	 (sfid-20080204_212413_136777_9A62E0BA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gI45Rwr8wGo22bUDDrnO"
Date: Thu, 07 Feb 2008 01:21:57 +0100
Message-Id: <1202343717.9965.52.camel@johannes.berg> (sfid-20080207_103644_635823_FE5BA304)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gI45Rwr8wGo22bUDDrnO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


>  	key.o \
>  	util.o \
> -	event.o
> +	event.o \
> +	mesh.o \
> +	mesh_pathtbl.o \
> +	mesh_plinktbl.o \
> +	mesh_plinkfsm.o \
> +	mesh_hwmp.o

Since this is a lot of code, any opinion on making it build-time
conditional? I can imagine that you don't want mesh when building an
embedded AP device.
=20
> @@ -358,6 +366,10 @@ static int ieee80211_stop(struct net_device *dev)

> +	case IEEE80211_IF_TYPE_MESH_POINT:
> +		sdata->u.sta.state =3D IEEE80211_DISABLED;
> +		flush_mesh_interface(dev);
> +		/* fall through */
>  	case IEEE80211_IF_TYPE_STA:
>  	case IEEE80211_IF_TYPE_IBSS:
>  		sdata->u.sta.state =3D IEEE80211_DISABLED;

Setting the state twice seems a bit odd.

> +	} else if (sdata->vif.type =3D=3D IEEE80211_IF_TYPE_MESH_POINT) {
> +		/* SSID is wildcard (all 0s) */
> +		ieee80211_set_mesh_beacon_template(dev, &conf);
> +		local->hw.flags |=3D IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE;
> +		local->hw.conf.beacon_int =3D 100;
> +		ieee80211_start_mesh(dev);

I already mentioned how that is wrong. Let me know if you need any more
info/help.

johannes

--=-gI45Rwr8wGo22bUDDrnO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6pPJKVg1VMiehFYAQKhXxAAvof9VYMgdE7HFje1jImH/nHUJI4R0Smm
/R7RFeUqLyvB7witctczCnqaM1vFtmH9ffnSkOmTxDiBSHwZPPKbTK9WqfGJuzne
MjUxX7uUp0Fg2vKgEqdx2UNRP0HNPitMS6+1xULKk6uMgx+EOMxjOBaQQZlMqS/2
7cLJXn3THQD5nyHM9Og/XE2wuNW6Qv1utVelbj2O0K6/aMxz7sI1KctY/5C4YxsR
D1yt1LEkfmfM8oIv2VBcJLZ6pgDQ1SoBNG7lMGMaBzI4YAfWMzEjquntyaYLh4dq
FD/7DK85UhIx/QdsR7L+3JivVogL/UJlZwyc7wSDE9gHyM64AAPsIxJSJEGSC8qa
/8vIemNjpTzghc69imObxSGLB/fVl6Zo6DVbDcw++kJuYSDQJGUqhJTuvlYGCsAT
gCWj0jqui1n1byzM1FLVcvw5if+cPn/BjLL38g3HKhDIK/v/+aNN17n4i9RRvStQ
imsE0/vZ4V+R/U3h8BWwiJWE70m665JVogdJhHmyJu/IrzM4zp/5fVys62+QTDfr
8CSAketbUwoGy6xYI3dVMGv+R8R13s9I0BI53M6/ZXbKJ9r+7RkscZq1dNtCzGlC
IyM8l/MiLaMV+lK6ReOIARXFMKp3aHCiTuQZiobhE19fy6RXQZh2TOzmqyIP5tD5
iAATam3Z9AM=
=2hJU
-----END PGP SIGNATURE-----

--=-gI45Rwr8wGo22bUDDrnO--

