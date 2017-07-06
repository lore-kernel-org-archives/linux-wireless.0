Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:53460 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752872AbdGFG0j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 02:26:39 -0400
Date: Wed, 5 Jul 2017 23:26:35 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: "Reizer, Eyal" <eyalr@ti.com>, Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wlcore: add missing nvs file name info for wilink8
Message-ID: <20170706062634.GL3730@atomide.com> (sfid-20170706_082658_252560_FD80E8E8)
References: <8665E2433BC68541A24DFFCA87B70F5B363E1A3D@DFRE01.ent.ti.com>
 <87y3s5kbc3.fsf@kamboji.qca.qualcomm.com>
 <20170704081757.GH3730@atomide.com>
 <8665E2433BC68541A24DFFCA87B70F5B363E29C8@DFRE01.ent.ti.com>
 <20170705080653.GJ3730@atomide.com>
 <20170705082837.g6tmsfeeld6dvsw3@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170705082837.g6tmsfeeld6dvsw3@earth>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Sebastian Reichel <sebastian.reichel@collabora.co.uk> [170705 01:29]:
> Hi,
> 
> On Wed, Jul 05, 2017 at 01:06:54AM -0700, Tony Lindgren wrote:
> > > > Not sure if this really is a regression as we've always had a bogus
> > > > wl1271-nvs.bin in linux-firmware.git. Sure would be nice to fix it,
> > > > but going back to using a generic wl1271-nvs.bin sure does not seem
> > > > like a good long term fix to me :)
> > > A lot of legacy here...
> > > Wl1271-nvs has been used mainly with wilink6/7 and indeed was device specific
> > > Holding calibration info etc.
> > > When they started with wilink8 the device specific configuration that was 
> > > Part of it has switched to wl18xx-conf.bin and using the wlaconf tool for setting it.
> > > Also there is no calibration specific info per device with wilink8 so the wl18xx-conf.bin
> > > The only thing left in wl1271-nvs.bin for wilink8 was the mac address override.
> > 
> > And the default wl1271-nvs.bin sets the mac address to a bogus deadbeef address,
> > so it's wrong to use and totally broken for distros :(
> 
> So use something like the following pseudo-code?
> 
> if (fw->mac_address == deadbeef) {
>     fw->mac_address = get_random_mac();
>     dev_warn(dev, "Detected unconfigured wl1271-nvs.bin.\n"
>         "Your device will run with limited performance.\n"
>         "Please use ti-utils to configure your device.\n");
> }

Yeah something like that should do the trick  :)

Regards,

Tony
