Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43458 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbXKIUS5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 15:18:57 -0500
Subject: Re: [PATCH 09/14] iwlwifi: 802.11n configuring hw_mode parameters
	to support HT in A/G
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com, flamingice@sourmilk.net
In-Reply-To: <1194595331715-git-send-email-ron.rindjunsky@intel.com>
References: <1194595326527-git-send-email-ron.rindjunsky@intel.com>
	 <11945953311871-git-send-email-ron.rindjunsky@intel.com>
	 <11945953312850-git-send-email-ron.rindjunsky@intel.com>
	 <11945953312367-git-send-email-ron.rindjunsky@intel.com>
	 <1194595331658-git-send-email-ron.rindjunsky@intel.com>
	 <11945953312456-git-send-email-ron.rindjunsky@intel.com>
	 <11945953313491-git-send-email-ron.rindjunsky@intel.com>
	 <11945953313626-git-send-email-ron.rindjunsky@intel.com>
	 <11945953311042-git-send-email-ron.rindjunsky@intel.com>
	 <1194595331715-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RBHWISSjvS/6IlMUpcFP"
Date: Fri, 09 Nov 2007 17:51:18 +0100
Message-Id: <1194627078.4793.148.camel@johannes.berg> (sfid-20071109_201859_766929_34BA6ADB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RBHWISSjvS/6IlMUpcFP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	if (mode =3D=3D MODE_IEEE80211A) {
> +		ht_info->cap |=3D (u16)IEEE80211_HT_CAP_SUP_WIDTH;
> +		ht_info->cap |=3D (u16)IEEE80211_HT_CAP_SGI_40;
> +		ht_info->supp_mcs_set[4] =3D 0x01;
> +	}
> +	ht_info->cap |=3D (u16)IEEE80211_HT_CAP_GRN_FLD;
> +	ht_info->cap |=3D (u16)IEEE80211_HT_CAP_SGI_20;
> +	ht_info->cap |=3D (u16)(IEEE80211_HT_CAP_MIMO_PS &
> +			     (IWL_MIMO_PS_NONE << 2));
> +
> +	ht_info->ampdu_factor =3D CFG_HT_RX_AMPDU_FACTOR_DEF;
> +	ht_info->ampdu_density =3D CFG_HT_MPDU_DENSITY_DEF;
> +
> +	ht_info->supp_mcs_set[0] =3D 0xFF;
> +	ht_info->supp_mcs_set[1] =3D 0xFF;

Good to see an example. I see you're actually using the IEEE80211A mode
as "5 GHz" and IEEE80211G as "2.4 GHz". Big thanks for doing it that way
rather than adding new modes or some weird stuff, this makes it a lot
simpler to abstract it away into bands.

It'll probably look differently with no ht_info part of a band but
rather all the information clustered into a single structure, but this
looks pretty good to me given the current crappy infrastructure.

johannes

--=-RBHWISSjvS/6IlMUpcFP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzSQBaVg1VMiehFYAQKJ4RAAqfDZ3hQMZtaksGj5UFXd3UNIpaBuU2nC
c/sXtcYAGJXWjxX0pB6SQ+sFRaVcijvn/yWfbBAnxb0xh+nz0VEbE0Lj/R2RFjnN
bO34WTsLuX/D/1WhlMi3LVuJHL1DKSON/qJozqymDD1FqYMNr9haGeu+XMUGkp3o
5xAMn+8Ea9JlJ+JiWLYX9D6L9sfItc03ySicbo+sFtNeUf1R0GJhExp2fzxhURvn
z0JzrgXgEw50tkpYji6VZ1x3RNKAB/a0SBchx6OntNmucnuTdm6ROm5jAtmNl/mQ
a0xQMHMZmUoTLGd400dfs6Tmf219NgTSUXBSnNPe6RyDmdMSOePkeH3OQW7b75kZ
OpHngph52sbe9IW1eUf4DVABGuQcMaj0JgLuT+ZHAJsqAyun69hs5KrSVUMdGsJN
PIVPhl+nIn7ChhEvXlW6Y9Bm0gPy+DSgkzPezSlUgS389ZRA4ifFM/ULUwPGQn+j
mLcvTZ4tAYZnrGpNhAgxvC6t/OWo3C20bPSWbvQH5fx5R5SZucthfd04sEuHFx2H
WQjS7CUNXy6bFzrtQ1pbXQHv5rpYp5gxiuDuZXnxgPSyrITXOFtFlKG4NzmbRHdS
BRmaGkJFTH30poyGOgQKJiaR0wPlvyCURhSIjbz39MGIEz0iI9Vo//iprvlFpiMb
zTBKhPJqRhs=
=13zc
-----END PGP SIGNATURE-----

--=-RBHWISSjvS/6IlMUpcFP--

