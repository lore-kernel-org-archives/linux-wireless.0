Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from diserzione.investici.org ([82.221.99.153]:34427 "EHLO
	diserzione.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935491Ab3DHSTk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 14:19:40 -0400
Date: Mon, 8 Apr 2013 19:53:52 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, zefir.kurtisi@neratec.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv3] mac80211: fix recalc_radar hwconf sync problem
Message-ID: <20130408175352.GC5938@ritirata.org> (sfid-20130408_201949_464525_F9811922)
References: <1365431343.25475.15.camel@jlt4.sipsolutions.net>
 <1365440698-16678-1-git-send-email-siwu@hrz.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="C+ts3FVlLX8+P6JN"
In-Reply-To: <1365440698-16678-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--C+ts3FVlLX8+P6JN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 08, 2013 at 07:04:58PM +0200, Simon Wunderlich wrote:
[...]

> @@ -108,6 +128,13 @@ static void ieee80211_free_chanctx(struct ieee80211_=
local *local,
>  		chandef->width =3D NL80211_CHAN_WIDTH_20_NOHT;
>  		chandef->center_freq1 =3D chandef->chan->center_freq;
>  		chandef->center_freq2 =3D 0;
> +
> +		/* NOTE: Disabling radar he is only valid here for
typo?                                    ^^


> +		 * single channel context. To be sure, check it ... */
> +		if (local->hw.conf.radar_enabled)
> +			check_single_channel =3D true;
> +		local->hw.conf.radar_enabled =3D false;
> +
>  		ieee80211_hw_config(local, 0);
>  	} else {
>  		drv_remove_chanctx(local, ctx);
> @@ -116,6 +143,10 @@ static void ieee80211_free_chanctx(struct ieee80211_=
local *local,
>  	list_del_rcu(&ctx->list);
>  	kfree_rcu(ctx, rcu_head);
> =20
> +	/* throw a warning if this wasn't the only channel context. */
> +	if (check_single_channel)
> +		WARN_ON(!list_empty(&local->chanctx_list));
> +

Why not using
	WARN_ON(check_single_channel && !list_empty(&local->chanctx_list));

? Moving the entire condition in the WARN_ON will optimise it all for being=
 'unlikely'.


But Johannes can simply destroy my comment if he thinks it is wrong :)


Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--C+ts3FVlLX8+P6JN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRYwQwAAoJEADl0hg6qKeODe4P+gMLgc8HfHS6+74ivPyURn8j
j8x8SRI7MzYpG+1+Kmh2VSb2V4N4uR48tdF20S9Mqv2KFvCLx2f3YnF6ULMmNaru
8Yzz3aPSBjkqaxzff24KIkFO3I0ToOPcGyJfmenUQ5aps7I2CKBgHev5IGU1+PZi
vUNCXTiWl6O3qGWpg5DDXrGYhAP0FBgeuZHgo/IF65j/IwHV3ShkgxjJaAuwJIHf
LZcNvU9587wX57utyRO2mQ48U12L2tIdOEWp17C8DXChwd6lczFLtApiAUdU4rxp
OGsohRF1xJy31evnHsXnDMBV4AHpoevPn9AONGJF8mD1hPo7h0Np2TWdoRB3ang5
hf2hgV4+L1qcnkUKvEKq7HiaN1ugNZI2XsFp/XhsVwSL6dEuYWI7GS/i0tv1qZSO
RH4C6E0IQWAV0dPFZNY/mS1W4mOotyqWggPKsYoLVfyqQBcEu1WBCg6IJWWwTPqA
VTALQkfccbU6d2xJst7ATr5wZItIwvjt/8y0A9qf4S/qq/oGtsm2pAerJPBKel8d
pp2/LXW+D52c1W89nvuxWwepXVwo4O4Mxb7r7OX8peOPL45oagbSOAz9gsq18e0p
EMF6u6vsJQpRL6wbyNooH6XJxCm9tRoe24DiEZeAszdDiBGkKzP76O3pjO/W99Va
BkIo/G5gWcHcKT8S9Qnv
=VkPO
-----END PGP SIGNATURE-----

--C+ts3FVlLX8+P6JN--
