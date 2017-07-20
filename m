Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:28344 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933883AbdGTHiW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Jul 2017 03:38:22 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>
CC: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] wlcore: add missing nvs file name info for wilink8
Date: Thu, 20 Jul 2017 07:38:13 +0000
Message-ID: <8665E2433BC68541A24DFFCA87B70F5B36408E3D@DFRE01.ent.ti.com> (sfid-20170720_093839_971084_5BA3DC03)
References: <8665E2433BC68541A24DFFCA87B70F5B363E1A3D@DFRE01.ent.ti.com>
 <87y3s5kbc3.fsf@kamboji.qca.qualcomm.com>
 <20170704081757.GH3730@atomide.com>
 <8665E2433BC68541A24DFFCA87B70F5B363E29C8@DFRE01.ent.ti.com>
 <20170705080653.GJ3730@atomide.com> <20170705082837.g6tmsfeeld6dvsw3@earth>
 <20170706062634.GL3730@atomide.com>
In-Reply-To: <20170706062634.GL3730@atomide.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >
> > On Wed, Jul 05, 2017 at 01:06:54AM -0700, Tony Lindgren wrote:
> > > > > Not sure if this really is a regression as we've always had a bog=
us
> > > > > wl1271-nvs.bin in linux-firmware.git. Sure would be nice to fix i=
t,
> > > > > but going back to using a generic wl1271-nvs.bin sure does not se=
em
> > > > > like a good long term fix to me :)
> > > > A lot of legacy here...
> > > > Wl1271-nvs has been used mainly with wilink6/7 and indeed was devic=
e
> specific
> > > > Holding calibration info etc.
> > > > When they started with wilink8 the device specific configuration th=
at was
> > > > Part of it has switched to wl18xx-conf.bin and using the wlaconf to=
ol for
> setting it.
> > > > Also there is no calibration specific info per device with wilink8 =
so the
> wl18xx-conf.bin
> > > > The only thing left in wl1271-nvs.bin for wilink8 was the mac addre=
ss
> override.
> > >
> > > And the default wl1271-nvs.bin sets the mac address to a bogus deadbe=
ef
> address,
> > > so it's wrong to use and totally broken for distros :(
> >
> > So use something like the following pseudo-code?
> >
> > if (fw->mac_address =3D=3D deadbeef) {
> >     fw->mac_address =3D get_random_mac();

Deadbeef0000 is a valid mac address, so I suggest detecting it and warning
the user of the bogus (default) nvs but don't attempt to get a random mac
address for him as it has to many rules (registered oui addresses etc.)

> >     dev_warn(dev, "Detected unconfigured wl1271-nvs.bin.\n"
> >         "Your device will run with limited performance.\n"
> >         "Please use ti-utils to configure your device.\n");
> > }
>=20
> Yeah something like that should do the trick  :)
>=20

Seems logical, will submit a v3 using wl1271-nvs.bin for wl18xx while addin=
g this
Check/warn.

Best Regards,
Eyal
