Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:44339 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344Ab3I3Qso (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 12:48:44 -0400
Date: Mon, 30 Sep 2013 18:48:40 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	mcgrof@qca.qualcomm.com, simon.wunderlich@s2003.tu-chemnitz.de
Subject: Re: [RFC] ath9k: add HT40 spectral scan capability
Message-ID: <20130930164840.GB15780@pandem0nium> (sfid-20130930_184847_884833_F2E002D3)
References: <1380206258-16452-1-git-send-email-lorenzo.bianconi83@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
In-Reply-To: <1380206258-16452-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 26, 2013 at 04:37:38PM +0200, Lorenzo Bianconi wrote:
> Add spectral scan feature on HT40 channels for ath9k. This patch extends
> previous capability added by Simon Wunderlich
>=20
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
> ---
>  drivers/net/wireless/ath/ath9k/ath9k.h |  47 +++++++----
>  drivers/net/wireless/ath/ath9k/calib.c |  10 +--
>  drivers/net/wireless/ath/ath9k/calib.h |   3 +-
>  drivers/net/wireless/ath/ath9k/hw.c    |   2 +-
>  drivers/net/wireless/ath/ath9k/link.c  |   3 +-
>  drivers/net/wireless/ath/ath9k/recv.c  | 142 ++++++++++++++++++++++-----=
------
>  6 files changed, 139 insertions(+), 68 deletions(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireles=
s/ath/ath9k/ath9k.h
> index 2ee35f6..b44955e 100644
> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
> @@ -875,32 +875,49 @@ static inline u8 spectral_bitmap_weight(u8 *bins)
>   * TODO: this might need rework when switching to nl80211-based
>   * interface.
>   */
> -enum ath_fft_sample_type {
> -	ATH_FFT_SAMPLE_HT20 =3D 1,
> +enum fft_sample_type {
> +	FFT_SAMPLE_HT20 =3D 1,
> +	FFT_SAMPLE_HT20_40,
>  };
> =20
>  struct fft_sample_tlv {
> -	u8 type;	/* see ath_fft_sample */
> +	enum fft_sample_type type;
>  	__be16 length;
>  	/* type dependent data follows */
>  } __packed;
> =20
> -struct fft_sample_ht20 {
> +struct fft_sample {
>  	struct fft_sample_tlv tlv;
> -
> -	u8 max_exp;
> -
>  	__be16 freq;
> -	s8 rssi;
> -	s8 noise;
> -
> -	__be16 max_magnitude;
> -	u8 max_index;
> -	u8 bitmap_weight;
> -
>  	__be64 tsf;
> =20
> -	u8 data[SPECTRAL_HT20_NUM_BINS];
> +	union {
> +		struct {
> +			s8 rssi;
> +			s8 nf;
> +
> +			u8 data[SPECTRAL_HT20_NUM_BINS];
> +			__be16 max_mag;
> +			u8 max_idx;
> +			u8 bitmap_w;
> +			u8 max_exp;
> +		} ht20;
> +		struct {
> +			s8 lower_rssi;
> +			s8 upper_rssi;
> +			s8 lower_nf;
> +			s8 upper_nf;
> +
> +			u8 data[SPECTRAL_HT20_40_NUM_BINS];
> +			__be16 lower_max_mag;
> +			__be16 upper_max_mag;
> +			u8 lower_max_idx;
> +			u8 upper_max_idx;
> +			u8 lower_bitmap_w;
> +			u8 upper_bitmap_w;
> +			u8 max_exp;
> +		} ht20_40;
> +	};
>  } __packed;

One more thing: please don't change the format for HT20 - there are already=
 userspace
programs which rely on the order of the parameters as they are now. This is=
 why we have
added the TLVs in the first place - you can just add a new type for HT40 (a=
s you did),
but keep the format of other formats (HT20).

Thanks,
	Simon

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlJJq2cACgkQrzg/fFk7axZRnwCgzXHpBcWkns68AdvUlUDvh/zd
TRAAn3iMSMAXaHUFBXOP+fbtOEaVCddO
=Ilat
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--
