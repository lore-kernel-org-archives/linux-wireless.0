Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59602 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751260AbdHXJvx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 05:51:53 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v9] wlcore: add missing nvs file name info for wilink8
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <8665E2433BC68541A24DFFCA87B70F5B3642BE11@DFRE01.ent.ti.com>
References: <8665E2433BC68541A24DFFCA87B70F5B3642BE11@DFRE01.ent.ti.com>
To: "Reizer, Eyal" <eyalr@ti.com>
Cc: ", Tony Lindgren" <tony@atomide.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sebastian.reichel@collabora.co.uk"
        <sebastian.reichel@collabora.co.uk>,
        Julian Calaby <julian.calaby@gmail.com>
Message-Id: <20170824095152.EC917606DD@smtp.codeaurora.org> (sfid-20170824_115215_924381_E9CCD705)
Date: Thu, 24 Aug 2017 09:51:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Reizer, Eyal" <eyalr@ti.com> wrote:

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
> Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
> Tested-by: Tony Lindgren <tony@atomide.com>

Patch applied to wireless-drivers-next.git, thanks.

d382b9c00782 wlcore: add missing nvs file name info for wilink8

-- 
https://patchwork.kernel.org/patch/9911123/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
