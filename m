Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43008 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab0BOJWp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 04:22:45 -0500
Subject: Re: [PATCH 1/2] mac80211: Ignore replay for IBSS interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1266190346-2247-1-git-send-email-benoit.papillault@free.fr>
References: <1266190346-2247-1-git-send-email-benoit.papillault@free.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-i67MGpQtjAOVlOdwnZ5D"
Date: Mon, 15 Feb 2010 10:22:42 +0100
Message-ID: <1266225762.3758.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-i67MGpQtjAOVlOdwnZ5D
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-02-15 at 00:32 +0100, Benoit Papillault wrote:
> Using WPA-NONE, the same key is used on multiple stations. As such,
> with
> at least 3 nodes, a node will receive frames from the other 2 nodes
> and
> frames from one of those nodes will be ignored since they are being
> detected as replayed.
>=20
> Note: WPA-NONE is not specified in 802.11i. Instead WPA2 should be
> used,
> but it is not currently implemented.
>=20
> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
> ---
>  net/mac80211/tkip.c |    6 +++++-
>  net/mac80211/wpa.c  |   10 +++++++---
>  2 files changed, 12 insertions(+), 4 deletions(-)
>=20
> diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
> index 7ef491e..f7e0062 100644
> --- a/net/mac80211/tkip.c
> +++ b/net/mac80211/tkip.c
> @@ -234,6 +234,7 @@ int ieee80211_tkip_decrypt_data(struct
> crypto_blkcipher *tfm,
>  	u8 rc4key[16], keyid, *pos =3D payload;
>  	int res;
>  	const u8 *tk =3D &key->conf.key[NL80211_TKIP_DATA_OFFSET_ENCR_KEY];
> +	bool tkip_decrypt_replay =3D 0;
> =20
>  	if (payload_len < 12)
>  		return -1;
> @@ -271,7 +272,7 @@ int ieee80211_tkip_decrypt_data(struct
> crypto_blkcipher *tfm,
>  		       iv32, iv16, key->u.tkip.rx[queue].iv32,
>  		       key->u.tkip.rx[queue].iv16);
>  #endif
> -		return TKIP_DECRYPT_REPLAY;
> +		tkip_decrypt_replay =3D 1;
>  	}
> =20
>  	if (only_iv) {
> @@ -338,5 +339,8 @@ int ieee80211_tkip_decrypt_data(struct
> crypto_blkcipher *tfm,
>  		*out_iv16 =3D iv16;
>  	}
> =20
> +	if (tkip_decrypt_replay)
> +		return TKIP_DECRYPT_REPLAY;
> +
>  	return res;
>  }
> diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
> index f4971cd..da1186d 100644
> --- a/net/mac80211/wpa.c
> +++ b/net/mac80211/wpa.c
> @@ -242,7 +242,9 @@ ieee80211_crypto_tkip_decrypt(struct
> ieee80211_rx_data *rx)
>  					  hdr->addr1, hwaccel, rx->queue,
>  					  &rx->tkip_iv32,
>  					  &rx->tkip_iv16);
> -	if (res !=3D TKIP_DECRYPT_OK || wpa_test)
> +	if ((res !=3D TKIP_DECRYPT_OK || wpa_test) &&
> +	    !(res =3D=3D TKIP_DECRYPT_REPLAY &&
> +	      rx->sdata->vif.type !=3D NL80211_IFTYPE_ADHOC))
>  		return RX_DROP_UNUSABLE;

NACK. This will clearly _break_ any proper RSN implementation. WPA-NONE
is the non-standard thing here, so requiring that somebody wanting to
implement proper RSN fix this doesn't seem right to me. And RSN
shouldn't actually be hard to implement with the events that we have now
-- it might just be a userspace thing.

johannes

--=-i67MGpQtjAOVlOdwnZ5D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLeRJeAAoJEODzc/N7+QmamYcQANH5E4wifk+Pmmz+0b9cNVbB
2lACBuYJ8DQ7h+BZofIdb6gjTnr6QTfdoRI7+ikEX0stEFhrXY+lbN2Pi/ig11Ma
HkQIy7kL3AFYKKhPT6HOttxsIhZNTGdFyzfeeOYefyTmQxvYHfvwnFt2G7Vgxhqp
cwjBS3XccTzN6UVF/T4+EcCRZz7EShNC/DG0Nl/01ta0Cn2G9f14hlJdkGyTuuik
MDbyfmFDtA0GkDRfYuq9BAgZJGs4u+riNKI40HBKa+66m7NFCyll5vuj7WWlKPVu
ZKQ5BDmRHfsY621QtzsyGE4WZ5wdqn7mCzuNCYdjIFCzyCOSWE1IRl3GpjcnM4z1
rYPN9Zq13uxw3ZjWdAkPNtAZOchGBL+JRCV+9O2MsMoZ5xUj7fC5QGb3thfVs+IF
JKk2Fsmt90VNai3oxx2Kfe3C3N3uuHFuKgz2uMeP08X+Evw1os4KK6vhRWPHnlDD
FhpEgQtq/ZOmbEJFjNzt2TBLzi9AW9cLQEfgiuZQN6DFRBxgxUl121kbxGPJV14c
RVSs8QBOEXHsVwqHaA5deaW4fYxR1CzYDqFD78v6N3cgrAN3HV52Oj3ZKWCwAMch
GwY7tp30i0mLLcP/EwxLR1UkizWy/QL/Eil4FJGmaY90i5VF9rn3qzS/wjuOPwdU
qEorpd+J4Z4s2g3JWXuu
=0EA7
-----END PGP SIGNATURE-----

--=-i67MGpQtjAOVlOdwnZ5D--

