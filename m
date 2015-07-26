Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:59986 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbbGZHlh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jul 2015 03:41:37 -0400
Message-ID: <55B48F15.9050302@rempel-privat.de> (sfid-20150726_094541_401833_1CEC4A54)
Date: Sun, 26 Jul 2015 09:41:09 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: miaoqing@qti.qualcomm.com, linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: Re: [PATCH 2/2] ath9k: export HW random number generator
References: <1436946847-10909-1-git-send-email-miaoqing@qca.qualcomm.com> <1436946847-10909-2-git-send-email-miaoqing@qca.qualcomm.com>
In-Reply-To: <1436946847-10909-2-git-send-email-miaoqing@qca.qualcomm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hV4pjA6WQ86ArrxGfKniolatnapgQakEF"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hV4pjA6WQ86ArrxGfKniolatnapgQakEF
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi all,

i did rngtest on top of this patch. The results are incredibly bad,
right now it is more a pattern generator not random number generator. Is
it possible to fix it?

/home/lex# cat /dev/hwrng | rngtest -c 1000
rngtest 5
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions.  There is
NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE.

rngtest: starting FIPS tests...
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 0
rngtest: FIPS 140-2 failures: 1000
rngtest: FIPS 140-2(2001-10-10) Monobit: 27
rngtest: FIPS 140-2(2001-10-10) Poker: 1000
rngtest: FIPS 140-2(2001-10-10) Runs: 1000
rngtest: FIPS 140-2(2001-10-10) Long run: 2
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=3D1.879; avg=3D871.897;
max=3D19531250.000)Kibits/s
rngtest: FIPS tests speed: (min=3D19.443; avg=3D48.374; max=3D70.123)Mibi=
ts/s
rngtest: Program run time: 23423736 microseconds



Am 15.07.2015 um 09:54 schrieb miaoqing@qti.qualcomm.com:
> From: Miaoqing Pan <miaoqing@qca.qualcomm.com>
>=20
> We measured the FFT-based entropy in 3 ways, Shannon entropy,
> collision entropy, and directly measured min-entropy. Just to
> be conservative, we recommend the estimated min-Entropy to be
> 10 bits per 16-bit value.
>=20
> Analysis was done by Jacobson,David(djacobso@qti.qualcomm.com).
>=20
> Signed-off-by: Miaoqing Pan <miaoqing@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/Kconfig  |  7 +++
>  drivers/net/wireless/ath/ath9k/Makefile |  1 +
>  drivers/net/wireless/ath/ath9k/ath9k.h  | 23 ++++++++++
>  drivers/net/wireless/ath/ath9k/main.c   |  4 ++
>  drivers/net/wireless/ath/ath9k/rng.c    | 75 +++++++++++++++++++++++++=
++++++++
>  5 files changed, 110 insertions(+)
>  create mode 100644 drivers/net/wireless/ath/ath9k/rng.c
>=20
> diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wirel=
ess/ath/ath9k/Kconfig
> index fee0cad..bde62ec9 100644
> --- a/drivers/net/wireless/ath/ath9k/Kconfig
> +++ b/drivers/net/wireless/ath/ath9k/Kconfig
> @@ -176,3 +176,10 @@ config ATH9K_HTC_DEBUGFS
>  	depends on ATH9K_HTC && DEBUG_FS
>  	---help---
>  	  Say Y, if you need access to ath9k_htc's statistics.
> +
> +config ATH9K_HWRNG
> +	bool "Random number generator support"
> +	depends on ATH9K && (HW_RANDOM =3D y || HW_RANDOM =3D ATH9K)
> +	default y
> +	---help---
> +	  Provides a hardware random number generator to the kernel.
> diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wire=
less/ath/ath9k/Makefile
> index ecda613..76f9dc3 100644
> --- a/drivers/net/wireless/ath/ath9k/Makefile
> +++ b/drivers/net/wireless/ath/ath9k/Makefile
> @@ -15,6 +15,7 @@ ath9k-$(CONFIG_ATH9K_DFS_DEBUGFS) +=3D dfs_debug.o
>  ath9k-$(CONFIG_ATH9K_DFS_CERTIFIED) +=3D dfs.o
>  ath9k-$(CONFIG_ATH9K_TX99) +=3D tx99.o
>  ath9k-$(CONFIG_ATH9K_WOW) +=3D wow.o
> +ath9k-$(CONFIG_ATH9K_HWRNG) +=3D rng.o
> =20
>  ath9k-$(CONFIG_ATH9K_DEBUGFS) +=3D debug.o
> =20
> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wirel=
ess/ath/ath9k/ath9k.h
> index a7a81b3..45596e5 100644
> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
> @@ -23,6 +23,7 @@
>  #include <linux/leds.h>
>  #include <linux/completion.h>
>  #include <linux/time.h>
> +#include <linux/hw_random.h>
> =20
>  #include "common.h"
>  #include "debug.h"
> @@ -1041,6 +1042,12 @@ struct ath_softc {
>  	u32 wow_intr_before_sleep;
>  	bool force_wow;
>  #endif
> +
> +#ifdef CONFIG_ATH9K_HWRNG
> +	struct hwrng rng;
> +	bool rng_initialized;
> +	u32 rng_last;
> +#endif
>  };
> =20
>  /********/
> @@ -1063,6 +1070,22 @@ static inline int ath9k_tx99_send(struct ath_sof=
tc *sc,
>  }
>  #endif /* CONFIG_ATH9K_TX99 */
> =20
> +/***************************/
> +/* Random Number Generator */
> +/***************************/
> +#ifdef CONFIG_ATH9K_HWRNG
> +void ath9k_rng_register(struct ath_softc *sc);
> +void ath9k_rng_unregister(struct ath_softc *sc);
> +#else
> +static inline void ath9k_rng_register(struct ath_softc *sc)
> +{
> +}
> +
> +static inline void ath9k_rng_unregister(struct ath_softc *sc)
> +{
> +}
> +#endif
> +
>  static inline void ath_read_cachesize(struct ath_common *common, int *=
csz)
>  {
>  	common->bus_ops->read_cachesize(common, csz);
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wirele=
ss/ath/ath9k/main.c
> index cfd45cb..5916ab2 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -739,6 +739,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
> =20
>  	ath9k_ps_restore(sc);
> =20
> +	ath9k_rng_register(sc);
> +
>  	return 0;
>  }
> =20
> @@ -828,6 +830,8 @@ static void ath9k_stop(struct ieee80211_hw *hw)
> =20
>  	ath9k_deinit_channel_context(sc);
> =20
> +	ath9k_rng_unregister(sc);
> +
>  	mutex_lock(&sc->mutex);
> =20
>  	ath_cancel_work(sc);
> diff --git a/drivers/net/wireless/ath/ath9k/rng.c b/drivers/net/wireles=
s/ath/ath9k/rng.c
> new file mode 100644
> index 0000000..d8fa7a5
> --- /dev/null
> +++ b/drivers/net/wireless/ath/ath9k/rng.c
> @@ -0,0 +1,75 @@
> +/*
> + * Copyright (c) 2015 Qualcomm Atheros, Inc.
> + *
> + * Permission to use, copy, modify, and/or distribute this software fo=
r any
> + * purpose with or without fee is hereby granted, provided that the ab=
ove
> + * copyright notice and this permission notice appear in all copies.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRA=
NTIES
> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE=
 FOR
> + * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMA=
GES
> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN =
AN
> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OU=
T OF
> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> + */
> +
> +#include "ath9k.h"
> +#include "hw.h"
> +#include "ar9003_phy.h"
> +
> +static int ath9k_rng_data_read(struct hwrng *rng, u32 *data)
> +{
> +	u32 v1, v2;
> +	struct ath_softc *sc =3D (struct ath_softc *)rng->priv;
> +	struct ath_hw *ah =3D sc->sc_ah;
> +
> +	ath9k_ps_wakeup(sc);
> +
> +	REG_RMW_FIELD(ah, AR_PHY_TEST, AR_PHY_TEST_BBB_OBS_SEL, 5);
> +	REG_CLR_BIT(ah, AR_PHY_TEST, AR_PHY_TEST_RX_OBS_SEL_BIT5);
> +	REG_RMW_FIELD(ah, AR_PHY_TEST_CTL_STATUS, AR_PHY_TEST_CTL_RX_OBS_SEL,=
 0);
> +
> +	v1 =3D REG_READ(ah, AR_PHY_TST_ADC);
> +	v2 =3D REG_READ(ah, AR_PHY_TST_ADC);
> +
> +	ath9k_ps_restore(sc);
> +
> +	/* wait for data ready */
> +	if (v1 && v2 && sc->rng_last !=3D v1 && v1 !=3D v2) {
> +		*data =3D (v1 & 0xffff) | (v2 << 16);
> +		sc->rng_last =3D v2;
> +
> +		return sizeof(u32);
> +	}
> +
> +	sc->rng_last =3D v2;
> +
> +	return 0;
> +}
> +
> +void ath9k_rng_register(struct ath_softc *sc)
> +{
> +	struct ath_hw *ah =3D sc->sc_ah;
> +
> +	if (WARN_ON(sc->rng_initialized))
> +		return;
> +
> +	if (!AR_SREV_9300_20_OR_LATER(ah))
> +		return;
> +
> +	sc->rng.name =3D "ath9k";
> +	sc->rng.data_read =3D ath9k_rng_data_read;
> +	sc->rng.priv =3D (unsigned long)sc;
> +
> +	if (!hwrng_register(&sc->rng))
> +		sc->rng_initialized =3D true;
> +}
> +
> +void ath9k_rng_unregister(struct ath_softc *sc)
> +{
> +	if (sc->rng_initialized) {
> +		hwrng_unregister(&sc->rng);
> +		sc->rng_initialized =3D false;
> +	}
> +}
>=20


--=20
Regards,
Oleksij


--hV4pjA6WQ86ArrxGfKniolatnapgQakEF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlW0jxoACgkQHwImuRkmbWnIcAD9GJrzrgYJjURNa/xwpMIX5Y45
p4QrwMTTMX8DAYpinqoA/1gLN1rlMVmCqSuyKUDOl87MQGwOA4ugTv9v+jiyL1le
=RwXt
-----END PGP SIGNATURE-----

--hV4pjA6WQ86ArrxGfKniolatnapgQakEF--
