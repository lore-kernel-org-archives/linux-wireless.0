Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:53242 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750830AbdGDISC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Jul 2017 04:18:02 -0400
Date: Tue, 4 Jul 2017 01:17:58 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: "Reizer, Eyal" <eyalr@ti.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wlcore: add missing nvs file name info for wilink8
Message-ID: <20170704081757.GH3730@atomide.com> (sfid-20170704_101833_299796_F5FFBED0)
References: <8665E2433BC68541A24DFFCA87B70F5B363E1A3D@DFRE01.ent.ti.com>
 <87y3s5kbc3.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87y3s5kbc3.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Kalle Valo <kvalo@codeaurora.org> [170703 04:30]:
> "Reizer, Eyal" <eyalr@ti.com> writes:
> 
> > When working with wl18xx the nvs file is used for defining an alternate
> > mac address and override the default mac address that is stored inside
> > the wl18xx chip.
> > update the structure field with the same default nvs file name that has
> > been used in the past, otherwise userspace backward compatibility is
> > broken when upgrading from older kernels, as the alternate mac address
> > would not be read from the nvs that is already present in the file system
> > (lib/firmware/ti-connectivity/wl1271-nvs.bin) causing mac address change
> > of the wlan interface.
> >
> > Signed-off-by: Eyal Reizer <eyalr@ti.com>
> 
> Should we also cc stable? And a Fixes line would be nice.

Argh this mess again. I think there are few things to consider here. What
about booting the same rootfs on multiple devices for example with NFSroot?

Not sure if this really is a regression as we've always had a bogus
wl1271-nvs.bin in linux-firmware.git. Sure would be nice to fix it,
but going back to using a generic wl1271-nvs.bin sure does not seem
like a good long term fix to me :)

Isn't the nvs file supposed to be device specific? If so, we should not
provide it in linux-firmware.git at all because of the issues it causes..

And since it's provided, how are people supposed to know to remove it
from their file system and replace it with something board specific?

Maybe add a check to first try to find wl18xx-nvs.bin if it exists (and
not add it to linux-firmware.git), and if not found, then fall back to
wl1271-nvs.bin, but only if it's not the bogus generic file.. Produce
a warning if the bogux linux-firmware.git wl1271-nvs.bin is being used..

Regards,

Tony
