Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:38296 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751879AbdGDIrJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Jul 2017 04:47:09 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Tony Lindgren <tony@atomide.com>, Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] wlcore: add missing nvs file name info for wilink8
Date: Tue, 4 Jul 2017 08:46:26 +0000
Message-ID: <8665E2433BC68541A24DFFCA87B70F5B363E29C8@DFRE01.ent.ti.com> (sfid-20170704_104748_139279_C5B67F05)
References: <8665E2433BC68541A24DFFCA87B70F5B363E1A3D@DFRE01.ent.ti.com>
 <87y3s5kbc3.fsf@kamboji.qca.qualcomm.com> <20170704081757.GH3730@atomide.com>
In-Reply-To: <20170704081757.GH3730@atomide.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tony,

>=20
> * Kalle Valo <kvalo@codeaurora.org> [170703 04:30]:
> > "Reizer, Eyal" <eyalr@ti.com> writes:
> >
> > > When working with wl18xx the nvs file is used for defining an alterna=
te
> > > mac address and override the default mac address that is stored insid=
e
> > > the wl18xx chip.
> > > update the structure field with the same default nvs file name that h=
as
> > > been used in the past, otherwise userspace backward compatibility is
> > > broken when upgrading from older kernels, as the alternate mac addres=
s
> > > would not be read from the nvs that is already present in the file sy=
stem
> > > (lib/firmware/ti-connectivity/wl1271-nvs.bin) causing mac address cha=
nge
> > > of the wlan interface.
> > >
> > > Signed-off-by: Eyal Reizer <eyalr@ti.com>
> >
> > Should we also cc stable? And a Fixes line would be nice.
>=20
> Argh this mess again. I think there are few things to consider here. What
> about booting the same rootfs on multiple devices for example with NFSroo=
t?
>=20
> Not sure if this really is a regression as we've always had a bogus
> wl1271-nvs.bin in linux-firmware.git. Sure would be nice to fix it,
> but going back to using a generic wl1271-nvs.bin sure does not seem
> like a good long term fix to me :)
A lot of legacy here...
Wl1271-nvs has been used mainly with wilink6/7 and indeed was device specif=
ic
Holding calibration info etc.
When they started with wilink8 the device specific configuration that was=20
Part of it has switched to wl18xx-conf.bin and using the wlaconf tool for s=
etting it.
Also there is no calibration specific info per device with wilink8 so the w=
l18xx-conf.bin
The only thing left in wl1271-nvs.bin for wilink8 was the mac address overr=
ide.
There are wilink8 customer using this feature which is the only reason for =
keeping=20
This file for wilink8.
So for wilink8 there is really not issue with having the same wl1271-nvs.bi=
n=20
On NFSroot.=20

>=20
> Isn't the nvs file supposed to be device specific? If so, we should not
> provide it in linux-firmware.git at all because of the issues it causes..
>=20
> And since it's provided, how are people supposed to know to remove it
> from their file system and replace it with something board specific?

I think the wl1271-nvs.bin should be removed from linux-firmware.git
anyway.
For wilink6/7 it is really device specific and for wilink8 if a customer
Want an alternate mac address he can create this file on his file system.

>=20
> Maybe add a check to first try to find wl18xx-nvs.bin if it exists (and
> not add it to linux-firmware.git), and if not found, then fall back to
> wl1271-nvs.bin, but only if it's not the bogus generic file.. Produce
> a warning if the bogux linux-firmware.git wl1271-nvs.bin is being used..
>=20
Removing it from linux-firmware.git may be better instead of adding an
additional check?
People are already familiar with the wl1271-nvs.bin file as a mean for
Mac address override for wilink8:
http://processors.wiki.ti.com/index.php/WL18xx_Writing_MAC_address

so I am not sure that a name change
Here is really necessary and may only create confusion especially for=20
Customers that already have products in the field and only updating
Their kernel.

Best Regards,
Eyal
