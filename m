Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55682 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbbCUKFk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2015 06:05:40 -0400
Message-ID: <550D424B.9020005@pengutronix.de> (sfid-20150321_110546_144823_C0FE36C1)
Date: Sat, 21 Mar 2015 11:04:59 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>,
	linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH v2 06/18] ath9k: add new function ath9k_hw_read_array
References: <1426927641-18474-1-git-send-email-linux@rempel-privat.de> <1426927641-18474-7-git-send-email-linux@rempel-privat.de>
In-Reply-To: <1426927641-18474-7-git-send-email-linux@rempel-privat.de>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="ximrbQWOhBm3vfk9ido7QHPdoGBw24o0Q"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ximrbQWOhBm3vfk9ido7QHPdoGBw24o0Q
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 03/21/2015 09:47 AM, Oleksij Rempel wrote:
> REG_READ generate most overhead on usb bus. It send and read micro pack=
ages
> and reduce usb bandwidth. To reduce this overhead we should read in bat=
ches.
>=20
> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
> ---
>  drivers/net/wireless/ath/ath9k/hw.c | 20 ++++++++++++++++++++
>  drivers/net/wireless/ath/ath9k/hw.h |  3 +++
>  2 files changed, 23 insertions(+)
>=20
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless=
/ath/ath9k/hw.c
> index 60aa8d7..15433c7 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -121,6 +121,26 @@ void ath9k_hw_write_array(struct ath_hw *ah, const=
 struct ar5416IniArray *array,
>  	REGWRITE_BUFFER_FLUSH(ah);
>  }
> =20
> +void ath9k_hw_read_array(struct ath_hw *ah, u32 array[][2], int size)
> +{
> +	u32 *tmp_reg_list, *tmp_data;
> +	int i;
> +
> +	tmp_reg_list =3D kmalloc(size * sizeof(u32), GFP_KERNEL);
> +	tmp_data =3D kmalloc(size * sizeof(u32), GFP_KERNEL);

You probably want to check for kmalloc returning NULL here.

> +
> +	for (i =3D 0; i < size; i++)
> +		tmp_reg_list[i] =3D array[i][0];
> +
> +	REG_READ_MULTI(ah, tmp_reg_list, tmp_data, size);
> +
> +	for (i =3D 0; i < size; i++)
> +		array[i][1] =3D tmp_data[i];
> +
> +	kfree(tmp_reg_list);
> +	kfree(tmp_data);
> +}
> +
>  u32 ath9k_hw_reverse_bits(u32 val, u32 n)
>  {
>  	u32 retval;
> diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless=
/ath/ath9k/hw.h
> index f1864cc..66aba10 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.h
> +++ b/drivers/net/wireless/ath/ath9k/hw.h
> @@ -138,6 +138,8 @@
> =20
>  #define REG_WRITE_ARRAY(iniarray, column, regWr) \
>  	ath9k_hw_write_array(ah, iniarray, column, &(regWr))
> +#define REG_READ_ARRAY(ah, array, size) \
> +	ath9k_hw_read_array(ah, array, size)
> =20
>  #define AR_GPIO_OUTPUT_MUX_AS_OUTPUT             0
>  #define AR_GPIO_OUTPUT_MUX_AS_PCIE_ATTENTION_LED 1
> @@ -1020,6 +1022,7 @@ void ath9k_hw_synth_delay(struct ath_hw *ah, stru=
ct ath9k_channel *chan,
>  bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val, u32 =
timeout);
>  void ath9k_hw_write_array(struct ath_hw *ah, const struct ar5416IniArr=
ay *array,
>  			  int column, unsigned int *writecnt);
> +void ath9k_hw_read_array(struct ath_hw *ah, u32 array[][2], int size);=

>  u32 ath9k_hw_reverse_bits(u32 val, u32 n);
>  u16 ath9k_hw_computetxtime(struct ath_hw *ah,
>  			   u8 phy, int kbps,
>=20

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--ximrbQWOhBm3vfk9ido7QHPdoGBw24o0Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCgAGBQJVDUJOAAoJECte4hHFiupU8voP/iEfegrwVzBGWqpLTM/X1kjF
mByKaT3y8KYWMVePgb1Ww01mC7b8T3Nz8fmTblaWWTgXM8EV9VR6wAuGfcA+OIdS
iYbjivpTELcugo6LtZh1iJKeHeqOf/n6Qb8G6n0oXtPIw6X6gBXnhvVTPR4fufvB
jONtE18p9TlfqbJhqYMK0mbLbm1WOaWQcxxKlPScmrK3OaAJSskVCHSpoIGA+z6g
pyfNP8eHTmAIYOUC48DsY/x+abRgPnwwxYdwQajYq76chcMX09+kd1TlPONKaFNe
XEYidLKAQC5igXnjO7nLbpFEnU0RQV5pUhx73f7yXvZjTho8sXvuhc+gkuHov6ZA
RLMNA8b7vvvqmx6U5g5amDXm0nRcWMA0AsxkcONtTEuDlQ65lnQNfU17x2G+Bk0j
vBIQqzTg17u8/v6I6ieuFWVPVIzInRQz+qcrFso5ecJElCQicyVlEyt/+xJipB9P
5I4VX3wiVTDYuK0Bvdd64l+YXnM4kDJzou/RzGn0V6846ohgeW9zL5Le5/zNDWN9
FQ8q8vyLXkzjc7ctYemQbSSwS6yb/fILcqtU73i1UHdam9KW5fK8QsPp9H8tWUhB
QhFenrFLYP4j6JlRFeA3ImwI/UBFUy9OOxvM4ywjKxhzCt8AHsZy/6khnwcXlIrv
gyIPzDFH3WbIJaXx0nvN
=RLIE
-----END PGP SIGNATURE-----

--ximrbQWOhBm3vfk9ido7QHPdoGBw24o0Q--
