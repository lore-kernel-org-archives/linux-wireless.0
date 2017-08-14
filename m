Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:35850 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752246AbdHNQEL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Aug 2017 12:04:11 -0400
Date: Mon, 14 Aug 2017 09:04:08 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Reizer, Eyal" <eyalr@ti.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sebastian.reichel@collabora.co.uk"
        <sebastian.reichel@collabora.co.uk>,
        Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [v7 wlcore: add missing nvs file name info for wilink8
Message-ID: <20170814160407.GU8569@atomide.com> (sfid-20170814_180429_276204_9C4148E1)
References: <8665E2433BC68541A24DFFCA87B70F5B36425E3C@DFRE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8665E2433BC68541A24DFFCA87B70F5B36425E3C@DFRE01.ent.ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Reizer, Eyal <eyalr@ti.com> [170814 05:15]:
> The following commits:
> commit c815fdebef44 ("wlcore: spi: Populate config firmware data")
> commit d776fc86b82f ("wlcore: sdio: Populate config firmware data")
> 
> Populated the nvs entry for wilink6 and wilink7 only while it is
> still needed for wilink8 as well.
> This broke user space backward compatibility when upgrading from older
> kernels, as the alternate mac address would not be read from the nvs that
> is present in the file system (lib/firmware/ti-connectivity/wl1271-nvs.bin)
> causing mac address change of the wlan interface.
> 
> This patch fix this and update the structure field with the same default
> nvs file name that has been used before.
> 
> In addition, some distros hold a default wl1271-nvs.bin in the file
> system with a bogus mac address (deadbeef...) that overrides the mac
> address that is stored inside the device.
> Warn users about this bogus mac address and use the internal mac address
> 
> Fixes: c815fdebef44 ("wlcore: spi: Populate config firmware data")
> Fixes: d776fc86b82f ("wlcore: sdio: Populate config firmware data")
> Signed-off-by: Eyal Reizer <eyalr@ti.com>
> ---
> v2->v3: add a check for default deadbeef... mac address and warn about it
> v3->v4: use a random TI mac address instead of the bogus one
> v4->v5: add constant definition for TI oui address
> v5->v6: after also verifying on wilink6/7 Use mac internal mac address
> instead of a random one
> v6->v7: use random mac in case internal mac is zero

Great, works for me! Thanks for fixing this issue properly:

Tested-by: Tony Lindgren <tony@atomide.com>
