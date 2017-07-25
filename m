Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lelnx194.ext.ti.com ([198.47.27.80]:27054 "EHLO
        lelnx194.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751624AbdGYLcg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2017 07:32:36 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sebastian.reichel@collabora.co.uk"
        <sebastian.reichel@collabora.co.uk>
Subject: RE: [v3] wlcore: add missing nvs file name info for wilink8
Date: Tue, 25 Jul 2017 11:32:28 +0000
Message-ID: <8665E2433BC68541A24DFFCA87B70F5B3640DDC7@DFRE01.ent.ti.com> (sfid-20170725_133251_271412_A56EDC97)
References: <8665E2433BC68541A24DFFCA87B70F5B36409500@DFRE01.ent.ti.com>
 <20170725102211.GT10026@atomide.com>
In-Reply-To: <20170725102211.GT10026@atomide.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: Tony Lindgren [mailto:tony@atomide.com]
> Sent: Tuesday, July 25, 2017 1:22 PM
> To: Reizer, Eyal
> Cc: Kalle Valo; linux-wireless@vger.kernel.org; linux-kernel@vger.kernel.=
org;
> sebastian.reichel@collabora.co.uk
> Subject: Re: [v3] wlcore: add missing nvs file name info for wilink8
>=20
> * Reizer, Eyal <eyalr@ti.com> [170720 05:17]:
> > The following commits:
> > c815fde wlcore: spi: Populate config firmware data
> > d776fc8 wlcore: sdio: Populate config firmware data
> >
> > Populated the nvs entry for wilink6 and wilink7 only while it is
> > still needed for wilink8 as well.
> > This broke user space backward compatibility when upgrading from older
> > kernels, as the alternate mac address would not be read from the nvs th=
at is
> > already present in the file system (lib/firmware/ti-connectivity/wl1271=
-
> nvs.bin)
> > causing mac address change of the wlan interface.
> >
> > This patch fix this and update the structure field with the same defaul=
t nvs
> file
> > name that has been used before.
> >
> > In addition, some distros hold a default wl1271-nvs.bin in the file
> > system with a bogus mac address (deadbeef...) that for a wl18xx device
> > also overrides the mac address that is stored inside the device.
> > Warn users about this bogus mac address.
> >
> > Cc: stable <stable@vger.kernel.org>
> > Signed-off-by: Eyal Reizer <eyalr@ti.com>
> > ---
> > v2->v3: add a check for default deadbeef... mac address and warn about =
it
> >
> >  drivers/net/wireless/ti/wlcore/main.c | 10 ++++++++++
> >  drivers/net/wireless/ti/wlcore/sdio.c |  1 +
> >  drivers/net/wireless/ti/wlcore/spi.c  |  1 +
> >  3 files changed, 12 insertions(+)
> >
> > diff --git a/drivers/net/wireless/ti/wlcore/main.c
> b/drivers/net/wireless/ti/wlcore/main.c
> > index 60aaa85..37c35aa 100644
> > --- a/drivers/net/wireless/ti/wlcore/main.c
> > +++ b/drivers/net/wireless/ti/wlcore/main.c
> > @@ -5961,6 +5961,16 @@ static void wl12xx_derive_mac_addresses(struct
> wl1271 *wl, u32 oui, u32 nic)
> >  	if (nic + WLCORE_NUM_MAC_ADDRESSES - wl->num_mac_addr >
> 0xffffff)
> >  		wl1271_warning("NIC part of the MAC address wraps
> around!");
> >
> > +	if (oui =3D=3D 0xdeadbe && nic =3D=3D 0xef0000)
> > +		wl1271_warning("Detected unconfigured mac address in
> nvs.\n"
> > +				"in case of using a wl12xx device, your "
> > +				"device performance may not be optimized.\n"
> > +				"Please use the calibrator tool to configure "
> > +				"your device.\n"
> > +				"When using a wl18xx device the nvs file can "
> > +				"be removed as a default mac address is "
> > +				"stored internally.\n");
> > +
> >  	for (i =3D 0; i < wl->num_mac_addr; i++) {
> >  		wl->addresses[i].addr[0] =3D (u8)(oui >> 16);
> >  		wl->addresses[i].addr[1] =3D (u8)(oui >> 8);
>=20
> Hmm so why would we ever even use this bogus nvs file? In addition to
> warning,
> I think we should just ignore the bogus nvs file completely.
>=20
While it looks bogus, it is still at least a valid mac address and the chip=
 will function
Using it.
Wilink6/7 doesn't have a  default mac address in hardware (wilink8 does hav=
e one)
so we need to assign one for it so It can work, even if not optimally until=
 configured=20
using the calibrator tool and a unique mac address is assigned to it.

Best Regards,
Eyal
