Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:19435 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751781AbdHPHSB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Aug 2017 03:18:01 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
CC: Kalle Valo <kvalo@codeaurora.org>,
        ",Tony Lindgren" <tony@atomide.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Julian Calaby <julian.calaby@gmail.com>
Subject: RE: [v7 wlcore: add missing nvs file name info for wilink8
Date: Wed, 16 Aug 2017 07:17:53 +0000
Message-ID: <8665E2433BC68541A24DFFCA87B70F5B36427AC2@DFRE01.ent.ti.com> (sfid-20170816_091816_590707_AB5FF3EB)
References: <8665E2433BC68541A24DFFCA87B70F5B36425E3C@DFRE01.ent.ti.com>
 <20170815130952.bknron5yuqsdlazb@earth>
In-Reply-To: <20170815130952.bknron5yuqsdlazb@earth>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >
> > +	if (oui_addr =3D=3D 0xdeadbe && nic_addr =3D=3D 0xef0000) {
> > +		wl1271_warning("Detected unconfigured mac address in
> nvs.\n"
> > +				"derive from fuse instead.\n"
> > +				"in case of using a wl12xx device, your "
> > +				"device performance may not be
> optimized.\n"
> > +				"Please use the calibrator tool to configure "
> > +				"your device.\n"
> > +				"When using a wl18xx device this default nvs
> "
> > +				"file can be removed from the file
> system\n");
>=20
> Usually we do not break multiline messages to make it easier to grep
> for them. Also it feels weird to say "if your device is ..., then
> ...", when we actually know which device it is. I suggest the
> following:
>=20
> wl1271_warning("Detected unconfigured mac address in nvs, derive from
> fuse instead.\n");
> if (device_is_wl12xx) {
>   wl1271_warning("Your device performance is not optimized.\n");
>   wl1271_warning("Please use the calibrator tool to configure your
> device.\n");
> } else {
>   wl1271_warning("This default nvs file can be removed from the file
> system\n");
> }
OK, will try that out.

>=20
> > +		if (wl->fuse_oui_addr =3D=3D 0 && wl->fuse_nic_addr =3D=3D 0) {
> > +			wl1271_warning("Fuse mac address is zero. using "
> > +					"random mac\n");
>=20
> This one should also go into one line.

This will still exceed 80 characters. Is this still ok?

>=20
> > +			/* Use TI oui and a random nic */
> > +			oui_addr =3D WLCORE_TI_OUI_ADDRESS;
> > +			nic_addr =3D get_random_int();
> > +		} else {
> > +			oui_addr =3D wl->fuse_oui_addr;
> > +			/* fuse has the BD_ADDR, the WLAN addresses are
> the next two */
> > +			nic_addr =3D wl->fuse_nic_addr + 1;
> > +		}
> > +	}
> > +
> >  	wl12xx_derive_mac_addresses(wl, oui_addr, nic_addr);
> >
> >  	ret =3D ieee80211_register_hw(wl->hw);
> > diff --git a/drivers/net/wireless/ti/wlcore/sdio.c
> b/drivers/net/wireless/ti/wlcore/sdio.c
> > index 2fb3871..f8a1fea 100644
> > --- a/drivers/net/wireless/ti/wlcore/sdio.c
> > +++ b/drivers/net/wireless/ti/wlcore/sdio.c
> > @@ -230,6 +230,7 @@ static const struct wilink_family_data wl128x_data =
=3D
> {
> >  static const struct wilink_family_data wl18xx_data =3D {
> >  	.name =3D "wl18xx",
> >  	.cfg_name =3D "ti-connectivity/wl18xx-conf.bin",
> > +	.nvs_name =3D "ti-connectivity/wl1271-nvs.bin",
> >  };
> >
> >  static const struct of_device_id wlcore_sdio_of_match_table[] =3D {
> > diff --git a/drivers/net/wireless/ti/wlcore/spi.c
> b/drivers/net/wireless/ti/wlcore/spi.c
> > index fdabb92..62ce54a 100644
> > --- a/drivers/net/wireless/ti/wlcore/spi.c
> > +++ b/drivers/net/wireless/ti/wlcore/spi.c
> > @@ -92,6 +92,7 @@ static const struct wilink_family_data wl128x_data =
=3D {
> >  static const struct wilink_family_data wl18xx_data =3D {
> >  	.name =3D "wl18xx",
> >  	.cfg_name =3D "ti-connectivity/wl18xx-conf.bin",
> > +	.nvs_name =3D "ti-connectivity/wl1271-nvs.bin",
> >  };
> >
> >  struct wl12xx_spi_glue {
> > diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h
> b/drivers/net/wireless/ti/wlcore/wlcore.h
> > index 1827546..95fbedc 100644
> > --- a/drivers/net/wireless/ti/wlcore/wlcore.h
> > +++ b/drivers/net/wireless/ti/wlcore/wlcore.h
> > @@ -40,6 +40,9 @@
> >  /* wl12xx/wl18xx maximum transmission power (in dBm) */
> >  #define WLCORE_MAX_TXPWR        25
> >
> > +/* Texas Instruments pre assigned OUI */
> > +#define WLCORE_TI_OUI_ADDRESS 0x080028
> > +
> >  /* forward declaration */
> >  struct wl1271_tx_hw_descr;
> >  enum wl_rx_buf_align;
>=20
> Otherwise:
>=20
> Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
>=20
Thank you. Will submit v8 with  your comments about the strings.=20
Just waiting for clarification on the 80 characters question above

Best Regards,
Eyal
