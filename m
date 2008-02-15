Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36211 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759221AbYBOPJn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 10:09:43 -0500
Subject: Re: [PATCH 3/3] mac80211: enable IBSS merging
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <bruno@thinktube.com>
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, flamingice@sourmilk.net, jbenc@suse.cz
In-Reply-To: <20080215070202.32461.62689.stgit@one>
References: <20080215070116.32461.80795.stgit@one>
	 <20080215070202.32461.62689.stgit@one>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EBDOacG/0bncuQfThU/K"
Date: Fri, 15 Feb 2008 16:09:11 +0100
Message-Id: <1203088151.8931.197.camel@johannes.berg> (sfid-20080215_150948_270970_FFCC98FE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EBDOacG/0bncuQfThU/K
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +static inline int ieee80211_get_bitrate(struct wiphy *phy,
> +					enum ieee80211_band band, int rate_idx)
> +{
> +	struct ieee80211_supported_band *sband;
> +	if (band > 0 && band < IEEE80211_NUM_BANDS) {
> +		sband =3D phy->bands[band];
> +		if (rate_idx > 0 && rate_idx < sband->n_bitrates)
> +			return sband->bitrates[rate_idx].bitrate;
> +	}
> +	return 0;
> +}

You don't need to do this. In the rx info (struct ieee80211_txrx_data
rx) we already have the bitrate info available (rx->u.rx.rate), you
might not have access to it but __ieee80211_rx() refuses packets with an
invalid rate or band. Hence, you can leave out *all* the sanity checks
and just do

phy->bands[band]->bitrates[rate_idx]

which doesn't need an inline function.

johannes

--=-EBDOacG/0bncuQfThU/K
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7WrFqVg1VMiehFYAQKKZw//eqAj7zKTBsih7g8bLNZxXlkVsOeU7TYr
jqcwnBlIt1QtptiddPtr6albKixeSxSf/S0D3LuD+Ik5vdkUHy78SPf/Je0YcXaH
FZw4wCH0oEkOrslEURXzNx+OS/pn94KPVbtt7p1yQP15XyGKlbkWjcP+Gx/Kvf4t
kGfWbBz/g6GbxsEcqfKajKxkRb8+0cJfzlkOsC8UVWFVVUYnP64lK6huIT5WdvX+
xtDbVWr9QlpBsCTiA21qvtbDAqiwxdDjE46xltBO6WQ4jUSze+Q/JRCn5eOSBrDS
q4o/GJ/sS9Uiur3HOWOYoWbNE24ujc9nyoCL0rVG/k/jJXxu+ISBK6idb4zZg/5d
KNAmMcjXQ8Pi+BJNRbXJpk3LRq63Vz2AXji0/Y3zl5FUbAbVkCbp3LtKMX+OQHQ3
XG/a2tm+hgDRM6UsAmILntXxtVa92U0Abcu4WS9cBbKs+UJe59TQMbBhq2O/SaTI
yNqZ2MazhiyQax9xzq9Ui4xpr/VOBRZlBABM2T45JsAHvs41664kByTPjwMOvMpl
nOgR5LRfBA+pTwXg7dYll4gR1sxevLoN6MZ86cxNCHe8GkHbt4N4bGramkyNHbfy
4E4RkJzxMu2YEq6kVDYibTNQdLaoSHlLazBIVkHf2DK3iEzcqY/BMUPfpH8if0NT
whzN4ngrJL8=
=tTod
-----END PGP SIGNATURE-----

--=-EBDOacG/0bncuQfThU/K--

