Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58750 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbYEJQLk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 12:11:40 -0400
Subject: Re: [PATCH 04/16] mac80211: Don't encrypt beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	rt2400-devel@lists.sourceforge.net
In-Reply-To: <200805101340.15709.IvDoorn@gmail.com> (sfid-20080510_140955_120722_E6DC20F8)
References: <200805101337.14536.IvDoorn@gmail.com>
	 <200805101340.15709.IvDoorn@gmail.com>
	 (sfid-20080510_140955_120722_E6DC20F8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0GcYBT/SoKnOWG+1V0tn"
Date: Sat, 10 May 2008 18:11:22 +0200
Message-Id: <1210435882.12837.3.camel@johannes.berg> (sfid-20080510_181143_998163_5FB8CCDC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0GcYBT/SoKnOWG+1V0tn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-05-10 at 13:40 +0200, Ivo van Doorn wrote:
> Beacons shouldn't be encryped, so mac80211 should set
> the IEEE80211_TX_CTL_DO_NOT_ENCRYPT flag in tx info flags.
> Otherwise the driver will cause a NULL pointer dereference
> when it tries to access the info->control.hw_key which isn't
> configured.
>=20
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

Thanks.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/tx.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index f35eaea..28d8bd5 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1898,6 +1898,7 @@ struct sk_buff *ieee80211_beacon_get(struct ieee802=
11_hw *hw,
>  			control->flags |=3D IEEE80211_TXCTL_SHORT_PREAMBLE;
>  		control->antenna_sel_tx =3D local->hw.conf.antenna_sel_tx;
>  		control->flags |=3D IEEE80211_TXCTL_NO_ACK;
> +		control->flags |=3D IEEE80211_TXCTL_DO_NOT_ENCRYPT;
>  		control->retry_limit =3D 1;
>  		control->flags |=3D IEEE80211_TXCTL_CLEAR_PS_FILT;
>  	}

--=-0GcYBT/SoKnOWG+1V0tn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCXJKaVg1VMiehFYAQIP4RAAqPQMpr0EHv81Mamam7cbC1moEswLWGLm
bwoMEYAjyO0+k2yP0NAg9E8tQ7jbhSnp8G1NGRLV8Fgetl70wOTXTAsC96i7q5jL
smLW/LexvuByq51IymOYMpafQ1Wka2tMnZjsE55ZmBVSKVrvQ2U0WPEGSX5OJ2jZ
qkfmnBwJB1xMl5137b8SiIit691gin8jMFDsbM0j/pCj3ee+5pqLRTbC+pcNv2i+
jAOdXzK4v5m4K+7ANq+5TX2KbsRnNcYJgYOY48P479YSgEfUrN63OvJSvGUvYY8A
+VjUVzbrGfi0bfe6QfUD+ShGuXGlPVNnUSPOih812t7QZImfz+w7rBnjkYVzs7B+
2L7zCSYvFeqCNr/vLQBqwm2yt12faugqhVLAIRcFoMZAHkA+RBFnDn9lJSB/lQRf
MBHNfhQU2DtbAnn0tCSUISkNUJ4FdkctY49vl6A6jTFLy2cTzkGhDRNsqjntgzzS
P+Y4aeyR5ncIdudkuXBQ6txHF6M/+sHhg+X4sMbodNMpj4qOHFyxUPFFt/y0kQvu
ZMB5xi79vUpYJASO+WFVcfnkjYDu5il+AKv0L8heT4dIJPvzNgpIj6doE+pDXsqI
uLYjvEWwuPtImkQPyHy7Z/zPh1As+Tlch8KawG1xOzQL4VVhJ4fhVU4t9iT1hq+8
WQbsl9hdrpo=
=5IKY
-----END PGP SIGNATURE-----

--=-0GcYBT/SoKnOWG+1V0tn--

