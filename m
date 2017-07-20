Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:30496 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935140AbdGTMlc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Jul 2017 08:41:32 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        ",Tony Lindgren" <tony@atomide.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "sebastian.reichel@collabora.co.uk"
        <sebastian.reichel@collabora.co.uk>
Subject: RE: [v3] wl18xx: add missing nvs file name info for wilink8
Date: Thu, 20 Jul 2017 12:41:25 +0000
Message-ID: <8665E2433BC68541A24DFFCA87B70F5B3640955C@DFRE01.ent.ti.com> (sfid-20170720_144148_520837_FD1AC682)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please ignore this patch. Wrong header.
Submitted the correct one instead:
https://patchwork.kernel.org/patch/9854809/


> -----Original Message-----
> From: Reizer, Eyal
> Sent: Thursday, July 20, 2017 3:13 PM
> To: 'Kalle Valo'; ',Tony Lindgren'; 'linux-wireless@vger.kernel.org'; 'li=
nux-
> kernel@vger.kernel.org'
> Cc: 'sebastian.reichel@collabora.co.uk'
> Subject: [v3] wl18xx: add missing nvs file name info for wilink8
>=20
> The following commits:
> c815fde wlcore: spi: Populate config firmware data
> d776fc8 wlcore: sdio: Populate config firmware data
>=20
> Populated the nvs entry for wilink6 and wilink7 only while it is
> still needed for wilink8 as well.
> This broke user space backward compatibility when upgrading from older
> kernels, as the alternate mac address would not be read from the nvs that=
 is
> already present in the file system (lib/firmware/ti-connectivity/wl1271-n=
vs.bin)
> causing mac address change of the wlan interface.
>=20
> This patch fix this and update the structure field with the same default =
nvs file
> name that has been used before.
>=20
> In addition, some distros hold a default wl1271-nvs.bin in the file
> system with a bogus mac address (deadbeef...) that for a wl18xx device
> also overrides the mac address that is stored inside the device.
> Warn users about this bogus mac address.
>=20
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Eyal Reizer <eyalr@ti.com>
> ---
> v2->v3: add a check for default deadbeef... mac address and warn about it
>=20
>  drivers/net/wireless/ti/wlcore/main.c | 10 ++++++++++
>  drivers/net/wireless/ti/wlcore/sdio.c |  1 +
>  drivers/net/wireless/ti/wlcore/spi.c  |  1 +
>  3 files changed, 12 insertions(+)
>=20
> diff --git a/drivers/net/wireless/ti/wlcore/main.c
> b/drivers/net/wireless/ti/wlcore/main.c
> index 60aaa85..37c35aa 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -5961,6 +5961,16 @@ static void wl12xx_derive_mac_addresses(struct
> wl1271 *wl, u32 oui, u32 nic)
>  	if (nic + WLCORE_NUM_MAC_ADDRESSES - wl->num_mac_addr >
> 0xffffff)
>  		wl1271_warning("NIC part of the MAC address wraps
> around!");
>=20
> +	if (oui =3D=3D 0xdeadbe && nic =3D=3D 0xef0000)
> +		wl1271_warning("Detected unconfigured mac address in
> nvs.\n"
> +				"in case of using a wl12xx device, your "
> +				"device performance may not be optimized.\n"
> +				"Please use the calibrator tool to configure "
> +				"your device.\n"
> +				"When using a wl18xx device the nvs file can "
> +				"be removed as a default mac address is "
> +				"stored internally.\n");
> +
>  	for (i =3D 0; i < wl->num_mac_addr; i++) {
>  		wl->addresses[i].addr[0] =3D (u8)(oui >> 16);
>  		wl->addresses[i].addr[1] =3D (u8)(oui >> 8);
> diff --git a/drivers/net/wireless/ti/wlcore/sdio.c
> b/drivers/net/wireless/ti/wlcore/sdio.c
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
>=20
>  static const struct of_device_id wlcore_sdio_of_match_table[] =3D {
> diff --git a/drivers/net/wireless/ti/wlcore/spi.c
> b/drivers/net/wireless/ti/wlcore/spi.c
> index fdabb92..62ce54a 100644
> --- a/drivers/net/wireless/ti/wlcore/spi.c
> +++ b/drivers/net/wireless/ti/wlcore/spi.c
> @@ -92,6 +92,7 @@ static const struct wilink_family_data wl128x_data =3D =
{
>  static const struct wilink_family_data wl18xx_data =3D {
>  	.name =3D "wl18xx",
>  	.cfg_name =3D "ti-connectivity/wl18xx-conf.bin",
> +	.nvs_name =3D "ti-connectivity/wl1271-nvs.bin",
>  };
>=20
>  struct wl12xx_spi_glue {
> --
> 2.7.4

Best Regards,
Eyal
