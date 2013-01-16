Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:33475 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171Ab3API7k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 03:59:40 -0500
Date: Wed, 16 Jan 2013 09:59:31 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Sven Eckelmann <sven@open-mesh.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	tobias.steinicke@net.t-labs.tu-berlin.de,
	mathias.kretschmer@fokus.fraunhofer.de, zefir.kurtisi@neratec.com
Subject: Re: [PATCH] ath9k: Save spectral scan data in network byteorder
Message-ID: <20130116085931.GA13648@pandem0nium> (sfid-20130116_114555_248273_5C95593B)
References: <1358251363-14385-1-git-send-email-sven@open-mesh.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
In-Reply-To: <1358251363-14385-1-git-send-email-sven@open-mesh.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 15, 2013 at 01:02:43PM +0100, Sven Eckelmann wrote:
> The sample data received through the spectral scan can be either in big or
> little endian byteorder. This information isn't stored in the output file.
> Therefore it is not possible for the analyzer software to find the correc=
t byte
> order.
>=20
> It is relative common to get the data from a low end AP in big endian mod=
e and
> transfer it to another computer in little endian mode to analyze it. Ther=
efore,
> it would be better to store it in network (big endian) byte order.

I'd agree that changing the byteorder to the "general" network order format=
 is
a good idea, although we will break compatibility again - which should hope=
fully
be no problem as the original patch is pretty new anyway.

I was pondering about performance loss when we run spectral on the same mac=
hine
(i.e. maybe adding two useless byteswaps per value). OTOH the byteswaps are=
 pretty
cheap and we do some computations anyway, so the performance difference sho=
uld be quite
small.

Therefore,

Acked-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>

(I've CCd some more people in the reply so they can scream if they don't li=
ke it. ;])

Thanks,
	Simon

>=20
> Signed-off-by: Sven Eckelmann <sven@open-mesh.com>
> Cc: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> ---
> A patch for FFT_eval was also sent to the author.
>=20
>  drivers/net/wireless/ath/ath9k/recv.c |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless=
/ath/ath9k/recv.c
> index d7c129b..2fac787 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -1064,8 +1064,9 @@ static void ath_process_fft(struct ath_softc *sc, s=
truct ieee80211_hdr *hdr,
> =20
>  	fft_sample.tlv.type =3D ATH_FFT_SAMPLE_HT20;
>  	fft_sample.tlv.length =3D sizeof(fft_sample) - sizeof(fft_sample.tlv);
> +	fft_sample.tlv.length =3D __cpu_to_be16(fft_sample.tlv.length);
> =20
> -	fft_sample.freq =3D ah->curchan->chan->center_freq;
> +	fft_sample.freq =3D __cpu_to_be16(ah->curchan->chan->center_freq);
>  	fft_sample.rssi =3D fix_rssi_inv_only(rs->rs_rssi_ctl0);
>  	fft_sample.noise =3D ah->noise;
> =20
> @@ -1106,13 +1107,16 @@ static void ath_process_fft(struct ath_softc *sc,=
 struct ieee80211_hdr *hdr,
>  	mag_info =3D ((struct ath_ht20_mag_info *)radar_info) - 1;
> =20
>  	/* Apply exponent and grab further auxiliary information. */
> -	for (i =3D 0; i < SPECTRAL_HT20_NUM_BINS; i++)
> +	for (i =3D 0; i < SPECTRAL_HT20_NUM_BINS; i++) {
>  		fft_sample.data[i] =3D bins[i] << mag_info->max_exp;
> +		fft_sample.data[i] =3D __cpu_to_be16(fft_sample.data[i]);
> +	}
> =20
>  	fft_sample.max_magnitude =3D spectral_max_magnitude(mag_info->all_bins);
> +	fft_sample.max_magnitude =3D __cpu_to_be16(fft_sample.max_magnitude);
>  	fft_sample.max_index =3D spectral_max_index(mag_info->all_bins);
>  	fft_sample.bitmap_weight =3D spectral_bitmap_weight(mag_info->all_bins);
> -	fft_sample.tsf =3D tsf;
> +	fft_sample.tsf =3D __cpu_to_be64(tsf);
> =20
>  	ath_debug_send_fft_sample(sc, &fft_sample.tlv);
>  #endif
> --=20
> 1.7.10.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlD2a/MACgkQrzg/fFk7axbiGwCg3QJnb/3fiI6fo1/ujGRJ+2Fi
LUgAni4euEz7lR6KBtg9BH0tr0dVT4+p
=jqWZ
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
