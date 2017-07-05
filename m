Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:53372 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752525AbdGEIHD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Jul 2017 04:07:03 -0400
Date: Wed, 5 Jul 2017 01:06:54 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Reizer, Eyal" <eyalr@ti.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wlcore: add missing nvs file name info for wilink8
Message-ID: <20170705080653.GJ3730@atomide.com> (sfid-20170705_100817_890901_611253CB)
References: <8665E2433BC68541A24DFFCA87B70F5B363E1A3D@DFRE01.ent.ti.com>
 <87y3s5kbc3.fsf@kamboji.qca.qualcomm.com>
 <20170704081757.GH3730@atomide.com>
 <8665E2433BC68541A24DFFCA87B70F5B363E29C8@DFRE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8665E2433BC68541A24DFFCA87B70F5B363E29C8@DFRE01.ent.ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Reizer, Eyal <eyalr@ti.com> [170704 01:47]:
> Hi Tony,
> 
> > 
> > * Kalle Valo <kvalo@codeaurora.org> [170703 04:30]:
> > > "Reizer, Eyal" <eyalr@ti.com> writes:
> > >
> > > > When working with wl18xx the nvs file is used for defining an alternate
> > > > mac address and override the default mac address that is stored inside
> > > > the wl18xx chip.
> > > > update the structure field with the same default nvs file name that has
> > > > been used in the past, otherwise userspace backward compatibility is
> > > > broken when upgrading from older kernels, as the alternate mac address
> > > > would not be read from the nvs that is already present in the file system
> > > > (lib/firmware/ti-connectivity/wl1271-nvs.bin) causing mac address change
> > > > of the wlan interface.
> > > >
> > > > Signed-off-by: Eyal Reizer <eyalr@ti.com>
> > >
> > > Should we also cc stable? And a Fixes line would be nice.
> > 
> > Argh this mess again. I think there are few things to consider here. What
> > about booting the same rootfs on multiple devices for example with NFSroot?
> > 
> > Not sure if this really is a regression as we've always had a bogus
> > wl1271-nvs.bin in linux-firmware.git. Sure would be nice to fix it,
> > but going back to using a generic wl1271-nvs.bin sure does not seem
> > like a good long term fix to me :)
> A lot of legacy here...
> Wl1271-nvs has been used mainly with wilink6/7 and indeed was device specific
> Holding calibration info etc.
> When they started with wilink8 the device specific configuration that was 
> Part of it has switched to wl18xx-conf.bin and using the wlaconf tool for setting it.
> Also there is no calibration specific info per device with wilink8 so the wl18xx-conf.bin
> The only thing left in wl1271-nvs.bin for wilink8 was the mac address override.

And the default wl1271-nvs.bin sets the mac address to a bogus deadbeef address,
so it's wrong to use and totally broken for distros :(

> There are wilink8 customer using this feature which is the only reason for keeping 
> This file for wilink8.
> So for wilink8 there is really not issue with having the same wl1271-nvs.bin 
> On NFSroot. 
> 
> > 
> > Isn't the nvs file supposed to be device specific? If so, we should not
> > provide it in linux-firmware.git at all because of the issues it causes..
> > 
> > And since it's provided, how are people supposed to know to remove it
> > from their file system and replace it with something board specific?
> 
> I think the wl1271-nvs.bin should be removed from linux-firmware.git
> anyway.

I agree. But distros carry it already, so we need to also add checks to
the device driver to warn about the bogus wl1271-nvs.bin. And the driver
should only attempt to use wl1271-nvs.bin if not the bogus one.

> For wilink6/7 it is really device specific and for wilink8 if a customer
> Want an alternate mac address he can create this file on his file system.

Yes makes sense, but only with fixing the driver to ignore the bogus
wl1271-nvs.bin.

> > Maybe add a check to first try to find wl18xx-nvs.bin if it exists (and
> > not add it to linux-firmware.git), and if not found, then fall back to
> > wl1271-nvs.bin, but only if it's not the bogus generic file.. Produce
> > a warning if the bogux linux-firmware.git wl1271-nvs.bin is being used..
> > 
> Removing it from linux-firmware.git may be better instead of adding an
> additional check?

I think we need both to avoid totally broken defaults.

> People are already familiar with the wl1271-nvs.bin file as a mean for
> Mac address override for wilink8:
> http://processors.wiki.ti.com/index.php/WL18xx_Writing_MAC_address

Yes so checking, ignoring and warning about the bogus one should solve
your customer issues. And it will also fix the defaults for distros.

> so I am not sure that a name change

Well that can be done later. The problem of booting the same rootfs
on multiple devices remains where having wl1271-nvs.bin breaks things.

> Here is really necessary and may only create confusion especially for 
> Customers that already have products in the field and only updating
> Their kernel.

Yeah using wl1271-nvs.bin should be the last resort but only if properly
configured.

Regards,

Tony
