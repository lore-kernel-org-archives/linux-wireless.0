Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45112 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625AbYFII6V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 04:58:21 -0400
Subject: Re: [PATCH 2/7] mac80211: replace ieee80211_get_morefrag with
	ieee80211_has_morefrags
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1212774671.6340.76.camel@brick> (sfid-20080606_195947_229598_F1790495)
References: <1212774671.6340.76.camel@brick>
	 (sfid-20080606_195947_229598_F1790495)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-O2o2kMSWwt6juGDZEL4o"
Date: Mon, 09 Jun 2008 09:38:51 +0200
Message-Id: <1212997132.698.53.camel@johannes.berg> (sfid-20080609_105824_688892_510BB59C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-O2o2kMSWwt6juGDZEL4o
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> -	if (ieee80211_get_morefrag(hdr))
> +	if (ieee80211_has_morefrags(hdr->frame_control))

looks fine to me, though I wonder if we should have

ieee80211_has_morefrags(struct 80211hdr)
and
__ieee80211_has_morefrags(__le16 fc)

or something with variants of the functions that do the ->frame_control?

johannes

--=-O2o2kMSWwt6juGDZEL4o
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJITN4IAAoJEKVg1VMiehFY0cYP/jCp3ND+8xLd5KRBTJRLGhEG
wY7W2MFeUNhr0aYQesQ2RC0v9bgGek7FO0bpvG/u45eeygKoY7RJ6ThqVhGGFVpl
Wmmo1YlO3O7Cm62gfrtVpxPKB85jkHGr44pUyiSWZGkMfZCWxuiZKoSsP7yvWpPX
odcNWfTTSiet3UgWhDmcuG5SJMhk1CKCfLSmmcKITt/Md37J7tveslr3zKXEQPqa
i62a3XbIO3J0D6SNzNVT89uaZT1cOpMRAIM1aZ4oqf3eLDCNvIatXPvIWT5Sn1M2
YSWESFG9TvOx1WSzoCEA9zc2Kf+BhdZzKcNm1sZMA2YtixzmefCw3Lf+vvptkw9O
ECZ0cchKcQNpjwAKMbf3deFdoSfoDCk2TF87xXWOpZaoEymXzs5NODwQbA01zg5A
jm+tDmuW59LYQsw0cwy+n7oaEjQiZI7VOnEnlK9LhkXVYvJGhX36TGekxXfb5Kpd
nIOcwMuGJmWgWLC3YNOdNvphMCjPBQAxAbfiYX7mNtjiBYQcYO8q9WbAdhxKy3hT
4s5UV7Vde049pOCPPiqfs95gqYeVMerO8M2uvnLXBQBX8tn1NuoMTpDRzd1KPD21
tvBGQXvNlETdSBcpfQIqi5mPgyOoaVb670Oc63mSxAkFPR8+9qjEZJ94F4TcFxQM
S0lthZwKbEJPV1L0LDzC
=gHNA
-----END PGP SIGNATURE-----

--=-O2o2kMSWwt6juGDZEL4o--

