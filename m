Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56981 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbbCYM1s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2015 08:27:48 -0400
Message-ID: <5512A9BC.5010902@pengutronix.de> (sfid-20150325_132752_308601_95E56EA8)
Date: Wed, 25 Mar 2015 13:27:40 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Eliad Peller <eliad@wizery.com>,
	Kobi Leibovitch <kobi.lev100@gmail.com>,
	"kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH 06/13] wlcore: enable sleep during AP mode operation
References: <1419834253-18331-1-git-send-email-eliad@wizery.com> <1419834253-18331-6-git-send-email-eliad@wizery.com>
In-Reply-To: <1419834253-18331-6-git-send-email-eliad@wizery.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="5DOCbBkpbwsExwuPXKE3qaOdSgefDsjeW"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5DOCbBkpbwsExwuPXKE3qaOdSgefDsjeW
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/29/2014 07:24 AM, Eliad Peller wrote:
> From: Kobi L <kobi.lev100@gmail.com>
>=20
> Enable ELP authorization in AP mode and enable the use
> of the wakeup bit in the ELP register.
>=20
> Introduce AP role sleep configuration which is disabled
> by default. When configured, it allows the AP to sleep
> when ELP is authorized for it.
>=20
> Signed-off-by: Kobi Leibovitch <kobi.lev100@gmail.com>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>

[...]

> diff --git a/drivers/net/wireless/ti/wl18xx/conf.h b/drivers/net/wirele=
ss/ti/wl18xx/conf.h
> index e34302e..71f1ec4 100644
> --- a/drivers/net/wireless/ti/wl18xx/conf.h
> +++ b/drivers/net/wireless/ti/wl18xx/conf.h
> @@ -23,7 +23,7 @@
>  #define __WL18XX_CONF_H__
> =20
>  #define WL18XX_CONF_MAGIC	0x10e100ca
> -#define WL18XX_CONF_VERSION	(WLCORE_CONF_VERSION | 0x0006)
> +#define WL18XX_CONF_VERSION	(WLCORE_CONF_VERSION | 0x0007)
>  #define WL18XX_CONF_MASK	0x0000ffff
>  #define WL18XX_CONF_SIZE	(WLCORE_CONF_SIZE + \
>  				 sizeof(struct wl18xx_priv_conf))
> @@ -110,12 +110,33 @@ struct wl18xx_ht_settings {
>  	u8 mode;
>  } __packed;
> =20
> +struct conf_ap_sleep_settings {
> +	/* Duty Cycle (20-80% of staying Awake) for IDLE AP
> +	 * (0: disable)
> +	 */
> +	u8 idle_duty_cycle;
> +	/* Duty Cycle (20-80% of staying Awake) for Connected AP
> +	 * (0: disable)
> +	 */
> +	u8 connected_duty_cycle;
> +	/* Maximum stations that are allowed to be connected to AP
> +	 *  (255: no limit)
> +	 */
> +	u8 max_stations_thresh;
> +	/* Timeout till enabling the Sleep Mechanism after data stops
> +	 * [unit: 100 msec]
> +	 */
> +	u8 idle_conn_thresh;
> +} __packed;
> +
>  struct wl18xx_priv_conf {
>  	/* Module params structures */
>  	struct wl18xx_ht_settings ht;
> =20
>  	/* this structure is copied wholesale to FW */
>  	struct wl18xx_mac_and_phy_params phy;
> +
> +	struct conf_ap_sleep_settings ap_sleep;
>  } __packed;

This patch requires a new firmware, loading of "wl18xx-conf.bin" from
[1] fails with:

> wlcore: ERROR configuration binary file size is wrong, expected 1226 go=
t 1221

regards,
Marc

[1]
http://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/t=
ree/ti-connectivity

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--5DOCbBkpbwsExwuPXKE3qaOdSgefDsjeW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCgAGBQJVEqm/AAoJECte4hHFiupUJ/AP/04GefdYjFBOylIAgld0fBJs
BNYqx3hkf7655mk60vvEvQY1gH880CS1UbbsTHmzzaSxwfUkoix1XoS1Ud2Ils36
YuqVJ30i9LUduDlZicsGIpznvINXP0RC7pTJwDWQqYG9zma48PCYhNDO6PE5FUbY
+EThd4bndvgSXWs0psJcztspA/woxk+MV4byv2aasAzGuQ8RN9bLljsmaJfejstL
aaz6KjosXFNzqoMNV+h9RZZrhpQ3pbPJqiFfhwaeEa9/tGU0xsgAAqo9b+eqYbrP
jinHbJCKLaIJs7XWWnrQAovGNR1m0o7Hl60D8NdnPKqWsuJKca0UHhQxSed1WvyV
igu8Zjd56Et2ZOCdtmXXn/3T7VKzSuYuc9IZEM5KXgqwoDBnWBC8ha0T7Ob/a/ij
rESspQUupZrYKkG29hketKDqNFK0YuDnkLPmfxaVp8ZuEzc8sy4iytpttlavv+Rj
wATCsy6eWT0hmCqzAm3VtZJF7TXC+/xLlZtuX7DAMYgouucEexWOotRjGPJvFS2J
31I4h9GL7s1Cc0sT5G9AzShfUhYASXugfS2k9XScHDsEu9ea7boS3dU/XcE/rCWi
OzPgGc7IH9puot09tyYGJtPmH6mA3208J66psBLN+ycBsEpYdGOBwzUpssRqWFjL
tOs7j9SQZkBMux50tFlD
=6NEO
-----END PGP SIGNATURE-----

--5DOCbBkpbwsExwuPXKE3qaOdSgefDsjeW--
