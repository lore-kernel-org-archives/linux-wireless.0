Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34136 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbYKNLDd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 06:03:33 -0500
Subject: Re: [PATCH] mac80211: Use the HT capabilities from the IE instead
	of the station's caps.
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <18717.22961.296661.281335@gargle.gargle.HOWL>
References: <18717.22961.296661.281335@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TTPPyEwEEQ59WeiqSMJy"
Date: Fri, 14 Nov 2008 12:02:58 +0100
Message-Id: <1226660579.4120.5.camel@johannes.berg> (sfid-20081114_120336_489033_FB6B48D3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TTPPyEwEEQ59WeiqSMJy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-11-14 at 16:27 +0530, Sujith wrote:
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>

Thanks.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/ht.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
> index 0ffbe12..ece79ae 100644
> --- a/net/mac80211/ht.c
> +++ b/net/mac80211/ht.c
> @@ -36,7 +36,7 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211=
_supported_band *sband,
> =20
>  	ht_cap->ht_supported =3D true;
> =20
> -	ht_cap->cap =3D ht_cap->cap & sband->ht_cap.cap;
> +	ht_cap->cap =3D le16_to_cpu(ht_cap_ie->cap_info) & sband->ht_cap.cap;
>  	ht_cap->cap &=3D ~IEEE80211_HT_CAP_SM_PS;
>  	ht_cap->cap |=3D sband->ht_cap.cap & IEEE80211_HT_CAP_SM_PS;
> =20

--=-TTPPyEwEEQ59WeiqSMJy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJHVrfAAoJEKVg1VMiehFY9c8P/0jJWat0+JMvv25MQVGVJMBp
sCX7crJn5c4U6+SNwCQWtaYkFmx2R5WYU5x+LdNStaUyCWNaAa+iVUmmGTfm+wYR
+nUk534K3Zn33Qe/81PnEQK3kQslXNYW5ZWbjFY7tUWJ/0o7RURjqmXfWDL0i6yq
qWulPYGy7H9M3jxqVptrfp9RIAR8UHvFkqNpuH4WXewypzcbkY29ej7rfz+DzRoX
be05b7Qj/rPH8+oGzZSuS8GpfQjr8ZBngAW9cLZ/AHTI/4F1BvezDR6f4IZ3wZMh
lbihc8IpN/1h5HjFYm0LQ1SuWdG4iSPVUdAykIsXNvYKbIuwbhlXc3Sou/B+TZgX
ChrgpyFJkrEvoRMEFI2QtuYlc/VYOYCL9o6L/9iZ91rsfORrj1TiFo+wbz1XbvB0
7ZOqHxVRisXzs6Q3ACtGPKlPrmRPOrya71DtZ+wJW6kEQhcMxttazR+4gHJsEhiB
I+5FH5s8QuANNRjROQf7+MlT0jQZyRHrdiYy/8SkNYOpkLjQ6rRq8o8vbE9xQRpk
T57SlW/w+lhuZ2sFX9dRZ8t9HOZjXzHWi/uxExUxM7VYZW0Sq2MUEAZa8v1SRY4m
pbLh1JtYycLCvEMvlksYVMPTAuzcx3pV4N3qNIqky9IXg/+h2nm+3TPhL0q0KM8I
goq0F2x4mjfdw7mJCWEd
=zGWQ
-----END PGP SIGNATURE-----

--=-TTPPyEwEEQ59WeiqSMJy--

