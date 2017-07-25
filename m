Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34752 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750839AbdGYNOe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2017 09:14:34 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Icenowy Zheng <icenowy@aosc.io>
Cc: Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH] dt-bindings: add device tree binding for Allwinner XR819 SDIO Wi-Fi
References: <20170718072940.17872-1-icenowy@aosc.io>
Date: Tue, 25 Jul 2017 16:14:28 +0300
In-Reply-To: <20170718072940.17872-1-icenowy@aosc.io> (Icenowy Zheng's message
        of "Tue, 18 Jul 2017 15:29:40 +0800")
Message-ID: <87bmo8irpn.fsf@codeaurora.org> (sfid-20170725_151450_673100_BDF39982)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Icenowy Zheng <icenowy@aosc.io> writes:

> Allwinner XR819 is a SDIO Wi-Fi chip, which has the functionality to use
> an out-of-band interrupt pin instead of SDIO in-band interrupt.
>
> Add the device tree binding of this chip, in order to make it possible
> to add this interrupt pin to device trees.
>
> Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
> ---
>  .../bindings/net/wireless/allwinner,xr819.txt      | 37 ++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/allwinner,xr819.txt
>
> diff --git
> a/Documentation/devicetree/bindings/net/wireless/allwinner,xr819.txt
> b/Documentation/devicetree/bindings/net/wireless/allwinner,xr819.txt
> new file mode 100644
> index 000000000000..64dd9c1c0584
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/allwinner,xr819.txt
> @@ -0,0 +1,37 @@
> +Allwinner XRadio wireless SDIO devices
> +
> +This node provides properties for controlling the XRadio wireless device. The
> +node is expected to be specified as a child node to the SDIO controller that
> +connects the device to the system.
> +
> +Required properties:
> +
> + - compatible : Should be "allwinner,xr819".
> +
> +Optional properties:
> + - interrupt-parent : the phandle for the interrupt controller to which the
> +	device interrupts are connected.
> + - interrupts : specifies attributes for the out-of-band interrupt (host-wake).
> +	When not specified the device will use in-band SDIO interrupts.

Where is the driver which uses this? I don't see it in
drivers/net/wireless but I guess that's not a blocker for the bindings?

-- 
Kalle Valo
