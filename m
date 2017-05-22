Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45492 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757923AbdEVJ2a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 May 2017 05:28:30 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "David S. Miller" <davem@davemloft.net>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: Sebastian Reichel <sre@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-wireless@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCHv4] wlcore: add wl1285 compatible
References: <20170505141553.2605-1-sebastian.reichel@collabora.co.uk>
Date: Mon, 22 May 2017 12:28:20 +0300
In-Reply-To: <20170505141553.2605-1-sebastian.reichel@collabora.co.uk>
        (Sebastian Reichel's message of "Fri, 5 May 2017 16:15:53 +0200")
Message-ID: <8737bx5jgr.fsf@purkki.adurom.net> (sfid-20170522_112901_222697_903E08B5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sebastian Reichel <sebastian.reichel@collabora.co.uk> writes:

> Motorola Droid 4 uses a WL1285C. With differences between the
> chips not being public let's add explicit binding for wl1285
> instead of relying on wl1283 being very similar.
>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Acked-by: Kalle Valo <kvalo@codeaurora.org>
> Acked-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
> ---
> Hi Dave,
>
> I previously send this in two patches, but its hard to apply without
> requiring multiple kernel releases (the driver must be updated before
> the DTS change). Since the actual change is not very complex Marcel
> Holtmann & Tony Lindgren suggested, that I send this directly to you
> in a single patch for inclusion into 4.12. This also means, that the
> remaining series can be queued normally for 4.13.

I noticed that Dave set this patch to Awaiting Upstream state on his
patchwork:

https://patchwork.ozlabs.org/patch/759042/

Which makes me suspect that he is waiting me to apply this (as I
normally apply wlcore patches). Dave, should I actually take this patch?
What do you prefer?

There's a small change to arm directory but I don't see that as a
problem as Tony acked it:

 Documentation/devicetree/bindings/net/wireless/ti,wlcore.txt | 1 +
 arch/arm/boot/dts/omap4-droid4-xt894.dts                     | 2 +-
 drivers/net/wireless/ti/wlcore/sdio.c                        | 1 +
 drivers/net/wireless/ti/wlcore/spi.c                         | 1 +
 4 files changed, 4 insertions(+), 1 deletion(-)

-- 
Kalle Valo
