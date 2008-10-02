Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44093 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbYJBJWG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2008 05:22:06 -0400
Subject: Re: Oops with current kernel and ath5k
From: Johannes Berg <johannes@sipsolutions.net>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <87ej30m376.fsf@denkblock.local> (sfid-20081001_233512_736508_E3A89AFD)
References: <200808101401.03339.toralf.foerster@gmx.de>
	 <b6c5339f0808101124x6f9359dct9ad828db1e6d1b2c@mail.gmail.com>
	 <200810012055.58085.toralf.foerster@gmx.de>
	 <87ej30m376.fsf@denkblock.local> (sfid-20081001_233512_736508_E3A89AFD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-j3TpfPikgVbN+MDQrD6m"
Date: Thu, 02 Oct 2008 10:17:16 +0200
Message-Id: <1222935437.24551.11.camel@johannes.berg> (sfid-20081002_112210_888544_6A0C4884)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-j3TpfPikgVbN+MDQrD6m
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-01 at 23:10 +0200, Elias Oltmanns wrote:

> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -557,6 +557,12 @@ static int ieee80211_stop(struct net_device *dev)
>  	return 0;
>  }
> =20
> +int ieee80211_opened(struct ieee80211_hw *hw)
> +{
> +	return hw_to_local(hw)->open_count;
> +}
> +EXPORT_SYMBOL(ieee80211_opened);

No way. The driver has all the info it needs. Fix it.

johannes

--=-j3TpfPikgVbN+MDQrD6m
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI5IOJAAoJEKVg1VMiehFYXWEP/jOWWM27rrnZacSjmujhaWty
PglJf6aZat9etIyJaJeNgOr3KO5uqEkI5+X7rL81O4VWiJNiV+zt1YCkiiPkXu1e
wAmL9rkt3OCQYA1ftWhNbXQ6s+a8PrC3nyY0/izWMqksb0IKw6kgGKMi3M8BC6f+
gci+dUMCk+w73GcizfN9SelRFC4g/SfnQ8JQLWZN9H6CGSgAgNZh15rYgiq0M9ag
j/ozBQP90mVS5Mmvt4Tttl4oeJO3SNSX8s5edSeflqSyu1VU9qD16zHZbfpL5PrA
A3Xui6vOyh9KRLK/fwRO7GdY+KZtE72Dq5Ei9w7fKvdaFozuAdYxrlgymasQme/P
OLm2x38+cICZfL5e8HTbmgrghgLZeF31uMcP1O1Dimh14pWmkA1rdPTHU7rt0i9R
FAUkAVd9lAzDtU06RtbC4f+6M0aLbnQ47pDkn61FMr29KiLY4w8EEEMkw80ohyxW
HsNicGTpKBl9fGSt5UtpGanQp6GdMBVfMuu+APJdpDS16EMw2PmzTVa6Amb6E/dU
7+Aqk1SqFmK6iAYt6wek34dJSbhH5KugWOk5kwcmzXrygXbZy5Xx0qd7Di+tDVX+
BALhtnERHvKxGvMF5MXDhpRdnb/TTXSSVo20igFL/d7j/5r5xjOtttV/k+FFYKeO
4w5AADOIzhoKzFkSJ5Ft
=9mwx
-----END PGP SIGNATURE-----

--=-j3TpfPikgVbN+MDQrD6m--

