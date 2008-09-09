Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57718 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbYIIPqQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 11:46:16 -0400
Subject: Re: [PATCH] ath9k: Add RF kill support
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
In-Reply-To: <20080909153422.GA7651@vasanth-lnx.users.atheros.com> (sfid-20080909_173954_277503_9881BAF1)
References: <20080909153422.GA7651@vasanth-lnx.users.atheros.com>
	 (sfid-20080909_173954_277503_9881BAF1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-isAae4iNyllMa/LN92m5"
Date: Tue, 09 Sep 2008 17:46:10 +0200
Message-Id: <1220975170.31304.184.camel@johannes.berg> (sfid-20080909_174619_979342_73BFE9C6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-isAae4iNyllMa/LN92m5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +#ifdef CONFIG_RFKILL
> +	u16 ah_rfsilent;
> +	u32 ah_rfkill_gpio ;

small typo, space too much.

> --- a/drivers/net/wireless/ath9k/core.h
> +++ b/drivers/net/wireless/ath9k/core.h
> @@ -40,6 +40,9 @@
>  #include <asm/page.h>
>  #include <net/mac80211.h>
>  #include <linux/leds.h>
> +#ifdef CONFIG_RFKILL
> +#include <linux/rfkill.h>
> +#endif
> =20
>  #include "ath9k.h"
>  #include "rc.h"
> @@ -823,6 +826,17 @@ struct ath_led {
>  	bool registered;
>  };
> =20
> +#ifdef CONFIG_RFKILL
> +/* Rfkill */
> +#define ATH_RFKILL_POLL_INTERVAL	2000 /* msecs */
> +
> +struct ath_rfkill {
> +	struct rfkill *rfkill;
> +	struct delayed_work rfkill_poll;
> +	char rfkill_name[32];
> +};
> +#endif
> +

No need to protect any of this with an #ifdef.

> +#ifdef CONFIG_RFKILL
> +#define SC_OP_RFKILL_REGISTERED	BIT(11)
> +#define SC_OP_RFKILL_SW_BLOCKED	BIT(12)
> +#define SC_OP_RFKILL_HW_BLOCKED	BIT(13)
> +#endif

Nor that.
=20
> +static void ath9k_ht_conf(struct ath_softc *sc,
> +			  struct ieee80211_bss_conf *bss_conf)
> +{
> +#define IEEE80211_HT_CAP_40MHZ_INTOLERANT BIT(14)
> +	struct ath_ht_info *ht_info =3D &sc->sc_ht_info;

All that doesn't seem to belong into this patch?

johannes

--=-isAae4iNyllMa/LN92m5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIxpo+AAoJEKVg1VMiehFY3BAQAL8Wa/i1WOLjWN12heIpcdv7
DQ8wuAebCSElx32BtlrakZBj9JapCaANxo2tXW6Xt+9kqcdRfSYDQeKTlS8dagUd
Lr3Fgp4oNks1f/d9BuzHNffxmQcv0q7vzN3ki/cpeM8g+7mVNikNmxK1XzZbjOx9
2eTtSf4zFZzm2ckMgZqkXXQdIMSi1ol/3kvCX4KOnu4gRiOVLg/DLEt+oBjb8PAA
VZRuV/eAD82/vopZ1jx3CK2Vo5eSOreFIecSUeBW2gAXRC4oiyxZgqIimu8nWU53
Nax+J9cn/bkrJkwPLwLvhQr++Io3bWDiR5l/Awd40b3uMLBwQ9EVVAzU+bl/i0t+
gIj3jTFmpoAHUzodHSZwZHff32gpBiA6LeWzBhWBTFK7/iB8snoL3LtneCXMcYZG
G+pyRVeBjeyYjpUggPDHKE1Cl2mY4RovxIjfVVYLv5t4eI2vZIjYzeTa5dx3IqGD
6sO45Iuo14ynyXZ9fqwzKbSbeigWcucrb1zt7q2kj7gLXJMCkaJrcvB0jqErnWpX
0/dSrjpu/auz8uShGOoHR+Amq17rFbnAH0Js5Q3rm5qx8qYYP1zDFY8uDclgxKpL
pr0caxwELFnLr0yFRWvK3Oad4njc0zGgeg747C9GRWYJibSGiGx2Kjts6o14fUPQ
Z+sh2R283VcfJmy+y7YK
=Sc0z
-----END PGP SIGNATURE-----

--=-isAae4iNyllMa/LN92m5--

