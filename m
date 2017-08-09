Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:49426 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750879AbdHIHZ6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Aug 2017 03:25:58 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sebastian.reichel@collabora.co.uk"
        <sebastian.reichel@collabora.co.uk>,
        Julian Calaby <julian.calaby@gmail.com>
Subject: RE: [v5] wlcore: add missing nvs file name info for wilink8
Date: Wed, 9 Aug 2017 07:24:52 +0000
Message-ID: <8665E2433BC68541A24DFFCA87B70F5B36420D9E@DFRE01.ent.ti.com> (sfid-20170809_092624_541570_FE05DB97)
References: <1502090869-8833-1-git-send-email-eyalr@ti.com>
 <8665E2433BC68541A24DFFCA87B70F5B3641E25B@DFRE01.ent.ti.com>
 <20170807073808.GD5487@atomide.com>
 <8665E2433BC68541A24DFFCA87B70F5B3641E339@DFRE01.ent.ti.com>
 <20170808042054.GI5190@atomide.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>=20
> > Subject: Re: [v5] wlcore: add missing nvs file name info for wilink8
> >
> > * Reizer, Eyal <eyalr@ti.com> [170807 00:47]:
> > > Hi Tony,
> > > >
> > > > * Reizer, Eyal <eyalr@ti.com> [170807 00:32]:
> > > > > The following commits:
> > > > > c815fde wlcore: spi: Populate config firmware data
> > > > > d776fc8 wlcore: sdio: Populate config firmware data
> > > > >
> > > > > Populated the nvs entry for wilink6 and wilink7 only while it is
> > > > > still needed for wilink8 as well.
> > > > > This broke user space backward compatibility when upgrading from
> > older
> > > > > kernels, as the alternate mac address would not be read from the =
nvs
> > that
> > > > is
> > > > > present in the file system (lib/firmware/ti-connectivity/wl1271-
> nvs.bin)
> > > > > causing mac address change of the wlan interface.
> > > > >
> > > > > This patch fix this and update the structure field with the same
> default
> > > > > nvs file name that has been used before.
> > > > >
> > > > > In addition, some distros hold a default wl1271-nvs.bin in the fi=
le
> > > > > system with a bogus mac address (deadbeef...) that for a wl18xx
> device
> > > > > also overrides the mac address that is stored inside the device.
> > > > > Warn users about this bogus mac address and use a random mac
> > instead
> > > >
> > > > Hmm looks pretty good to me except for one more thing I just notice=
d.
> > > >
> > > > Why don't you just use the hardware mac address instead of a random
> > > > mac address on wl18xx device when you see a bogus nvs file?
> > > >
> > >
> > > I agree that this would have been better but the problem is that
> hardware
> > > mac address is available for wilink8 onlyWilink6/7 don't have one sto=
red.
> > > The wlcore code responsible for handling mac address is common code
> > > and there is method for detecting between them in this module.
> >
> > Care to clarify a bit.. Are you saying wilink8 will use the hardware
> > mac address in case of bogus nvs file?
> >
> With present implementation it will not. It will use the random one for b=
oth
> wilink6/7 as well as wilink8.
> I need to get a hold of a wilink6/7 module and see if reverting to an int=
ernal
> mac address is working. Will try to look around as it has been a while si=
nce
> I used one.
>=20
Managed to test with a wilink6 module and in fact reading hardware mac
Address from fuse is working ok for wilink6/7 as well.
submitting v6 using this mac address instead of a random one when the=20
bogus (deadbeef...) mac address is read from default nvs file.

Best Regards,
Eyal
