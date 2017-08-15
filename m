Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55904 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750859AbdHONJ5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Aug 2017 09:09:57 -0400
Date: Tue, 15 Aug 2017 09:09:52 -0400
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: "Reizer, Eyal" <eyalr@ti.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        ",Tony Lindgren" <tony@atomide.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [v7 wlcore: add missing nvs file name info for wilink8
Message-ID: <20170815130952.bknron5yuqsdlazb@earth> (sfid-20170815_151013_821573_5988A59A)
References: <8665E2433BC68541A24DFFCA87B70F5B36425E3C@DFRE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hbmpzobj4ppj2jwm"
In-Reply-To: <8665E2433BC68541A24DFFCA87B70F5B36425E3C@DFRE01.ent.ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--hbmpzobj4ppj2jwm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Aug 14, 2017 at 12:15:16PM +0000, Reizer, Eyal wrote:
> The following commits:
> commit c815fdebef44 ("wlcore: spi: Populate config firmware data")
> commit d776fc86b82f ("wlcore: sdio: Populate config firmware data")
>=20
> Populated the nvs entry for wilink6 and wilink7 only while it is
> still needed for wilink8 as well.
> This broke user space backward compatibility when upgrading from older
> kernels, as the alternate mac address would not be read from the nvs that
> is present in the file system (lib/firmware/ti-connectivity/wl1271-nvs.bi=
n)
> causing mac address change of the wlan interface.
>=20
> This patch fix this and update the structure field with the same default
> nvs file name that has been used before.
>=20
> In addition, some distros hold a default wl1271-nvs.bin in the file
> system with a bogus mac address (deadbeef...) that overrides the mac
> address that is stored inside the device.
> Warn users about this bogus mac address and use the internal mac address
>=20
> Fixes: c815fdebef44 ("wlcore: spi: Populate config firmware data")
> Fixes: d776fc86b82f ("wlcore: sdio: Populate config firmware data")
> Signed-off-by: Eyal Reizer <eyalr@ti.com>
> ---
> v2->v3: add a check for default deadbeef... mac address and warn about it
> v3->v4: use a random TI mac address instead of the bogus one
> v4->v5: add constant definition for TI oui address
> v5->v6: after also verifying on wilink6/7 Use mac internal mac address
> instead of a random one
> v6->v7: use random mac in case internal mac is zero
> ---
>  drivers/net/wireless/ti/wlcore/main.c   | 23 +++++++++++++++++++++++
>  drivers/net/wireless/ti/wlcore/sdio.c   |  1 +
>  drivers/net/wireless/ti/wlcore/spi.c    |  1 +
>  drivers/net/wireless/ti/wlcore/wlcore.h |  3 +++
>  4 files changed, 28 insertions(+)
>=20
> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless=
/ti/wlcore/main.c
> index 60aaa85..40692ac 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -6040,6 +6040,29 @@ static int wl1271_register_hw(struct wl1271 *wl)
>  		nic_addr =3D wl->fuse_nic_addr + 1;
>  	}
> =20
> +	if (oui_addr =3D=3D 0xdeadbe && nic_addr =3D=3D 0xef0000) {
> +		wl1271_warning("Detected unconfigured mac address in nvs.\n"
> +				"derive from fuse instead.\n"
> +				"in case of using a wl12xx device, your "
> +				"device performance may not be optimized.\n"
> +				"Please use the calibrator tool to configure "
> +				"your device.\n"
> +				"When using a wl18xx device this default nvs "
> +				"file can be removed from the file system\n");

Usually we do not break multiline messages to make it easier to grep
for them. Also it feels weird to say "if your device is ..., then
=2E..", when we actually know which device it is. I suggest the
following:

wl1271_warning("Detected unconfigured mac address in nvs, derive from fuse =
instead.\n");
if (device_is_wl12xx) {
  wl1271_warning("Your device performance is not optimized.\n");
  wl1271_warning("Please use the calibrator tool to configure your device.\=
n");
} else {
  wl1271_warning("This default nvs file can be removed from the file system=
\n");
}

> +		if (wl->fuse_oui_addr =3D=3D 0 && wl->fuse_nic_addr =3D=3D 0) {
> +			wl1271_warning("Fuse mac address is zero. using "
> +					"random mac\n");

This one should also go into one line.

> +			/* Use TI oui and a random nic */
> +			oui_addr =3D WLCORE_TI_OUI_ADDRESS;
> +			nic_addr =3D get_random_int();
> +		} else {
> +			oui_addr =3D wl->fuse_oui_addr;
> +			/* fuse has the BD_ADDR, the WLAN addresses are the next two */
> +			nic_addr =3D wl->fuse_nic_addr + 1;
> +		}
> +	}
> +
>  	wl12xx_derive_mac_addresses(wl, oui_addr, nic_addr);
> =20
>  	ret =3D ieee80211_register_hw(wl->hw);
> diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless=
/ti/wlcore/sdio.c
> index 2fb3871..f8a1fea 100644
> --- a/drivers/net/wireless/ti/wlcore/sdio.c
> +++ b/drivers/net/wireless/ti/wlcore/sdio.c
> @@ -230,6 +230,7 @@ static const struct wilink_family_data wl128x_data =
=3D {
>  static const struct wilink_family_data wl18xx_data =3D {
>  	.name =3D "wl18xx",
>  	.cfg_name =3D "ti-connectivity/wl18xx-conf.bin",
> +	.nvs_name =3D "ti-connectivity/wl1271-nvs.bin",
>  };
> =20
>  static const struct of_device_id wlcore_sdio_of_match_table[] =3D {
> diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/=
ti/wlcore/spi.c
> index fdabb92..62ce54a 100644
> --- a/drivers/net/wireless/ti/wlcore/spi.c
> +++ b/drivers/net/wireless/ti/wlcore/spi.c
> @@ -92,6 +92,7 @@ static const struct wilink_family_data wl128x_data =3D {
>  static const struct wilink_family_data wl18xx_data =3D {
>  	.name =3D "wl18xx",
>  	.cfg_name =3D "ti-connectivity/wl18xx-conf.bin",
> +	.nvs_name =3D "ti-connectivity/wl1271-nvs.bin",
>  };
> =20
>  struct wl12xx_spi_glue {
> diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wirele=
ss/ti/wlcore/wlcore.h
> index 1827546..95fbedc 100644
> --- a/drivers/net/wireless/ti/wlcore/wlcore.h
> +++ b/drivers/net/wireless/ti/wlcore/wlcore.h
> @@ -40,6 +40,9 @@
>  /* wl12xx/wl18xx maximum transmission power (in dBm) */
>  #define WLCORE_MAX_TXPWR        25
> =20
> +/* Texas Instruments pre assigned OUI */
> +#define WLCORE_TI_OUI_ADDRESS 0x080028
> +
>  /* forward declaration */
>  struct wl1271_tx_hw_descr;
>  enum wl_rx_buf_align;

Otherwise:

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

--hbmpzobj4ppj2jwm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlmS8p0ACgkQ2O7X88g7
+ppGZw//RvGdqdcDeQGZQqPKr2i7t3TMMKxEwafzv74W9DjOPjJG5LiOPb3cGVcX
t1kNAYQCOV7Fvy+17eVNanhI1Sc8xkCh3dbtdPbSuF7xfixyrJSqQfyNy+NnAK9Y
soMkS4fDPbO7I+A2vCiQAkWW6DwkkziW79KRC4gXoKULHjXkcQsG/iJcoSWmHxB3
AVP7nUpOUvNllAe6tn5MEkuaAM1VsLPqEIKK1VOXzmEri0Cu19CvPi0ScO4jIwQw
lK6qwgM7ZNHAl0HstC9AVNvvEIiHrpMx97tc0smN9RWDAZBow2npBPXg7ytgPgQJ
C8PqyOotsv0MsBUlsbphJDUvBwIon7aLW7jUw2Yh1ejDYIx2AtNbbfFNWm/WCljN
AYa95f2+A27BG84zelyDvclrVs4aIrLOlB4LpQrpBAkvXuMOt2rc6YHUmigKVimn
03neYm/VzvN6r16yNHmzlNcXO6H+sH9nEzqiX5/7eKwfPtQx1+/NpsV7XoyS2aui
2mPjChvBAw6WOqdMO6uGwkcjHYRI90WpdX/wm0cviXDFNQFiaEeqm7a2dGTnHCd+
88+ccFgkpLtfDk931QZoKdAxMaowuGYTQy8KwHI48Df6g/9FAZWE10uDJ1gVMFNh
iJYbKU/dol3sgCYJRUQNLlWsvXGogmeRltStghNjIdpEkDkHLZg=
=swoK
-----END PGP SIGNATURE-----

--hbmpzobj4ppj2jwm--
