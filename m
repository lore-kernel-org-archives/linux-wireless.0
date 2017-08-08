Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:57004 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750727AbdHHEU6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 00:20:58 -0400
Date: Mon, 7 Aug 2017 21:20:55 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Reizer, Eyal" <eyalr@ti.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sebastian.reichel@collabora.co.uk"
        <sebastian.reichel@collabora.co.uk>,
        Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [v5] wlcore: add missing nvs file name info for wilink8
Message-ID: <20170808042054.GI5190@atomide.com> (sfid-20170808_062112_268106_353D1C1A)
References: <1502090869-8833-1-git-send-email-eyalr@ti.com>
 <8665E2433BC68541A24DFFCA87B70F5B3641E25B@DFRE01.ent.ti.com>
 <20170807073808.GD5487@atomide.com>
 <8665E2433BC68541A24DFFCA87B70F5B3641E339@DFRE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8665E2433BC68541A24DFFCA87B70F5B3641E339@DFRE01.ent.ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Reizer, Eyal <eyalr@ti.com> [170807 00:47]:
> Hi Tony,
> > 
> > * Reizer, Eyal <eyalr@ti.com> [170807 00:32]:
> > > The following commits:
> > > c815fde wlcore: spi: Populate config firmware data
> > > d776fc8 wlcore: sdio: Populate config firmware data
> > >
> > > Populated the nvs entry for wilink6 and wilink7 only while it is
> > > still needed for wilink8 as well.
> > > This broke user space backward compatibility when upgrading from older
> > > kernels, as the alternate mac address would not be read from the nvs that
> > is
> > > present in the file system (lib/firmware/ti-connectivity/wl1271-nvs.bin)
> > > causing mac address change of the wlan interface.
> > >
> > > This patch fix this and update the structure field with the same default
> > > nvs file name that has been used before.
> > >
> > > In addition, some distros hold a default wl1271-nvs.bin in the file
> > > system with a bogus mac address (deadbeef...) that for a wl18xx device
> > > also overrides the mac address that is stored inside the device.
> > > Warn users about this bogus mac address and use a random mac instead
> > 
> > Hmm looks pretty good to me except for one more thing I just noticed.
> > 
> > Why don't you just use the hardware mac address instead of a random
> > mac address on wl18xx device when you see a bogus nvs file?
> > 
> 
> I agree that this would have been better but the problem is that hardware 
> mac address is available for wilink8 onlyWilink6/7 don't have one stored.
> The wlcore code responsible for handling mac address is common code 
> and there is method for detecting between them in this module.

Care to clarify a bit.. Are you saying wilink8 will use the hardware
mac address in case of bogus nvs file?

Regards,

Tony
