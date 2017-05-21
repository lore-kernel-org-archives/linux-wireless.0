Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48406 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756510AbdEUOyF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 May 2017 10:54:05 -0400
Subject: Re: [PATCH 1/1] dt-binding: net: wireless: fix node name in the
 BCM43xx example
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kvalo@codeaurora.org, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Chen-Yu Tsai <wens@csie.org>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>
References: <20170515201356.26384-1-martin.blumenstingl@googlemail.com>
 <20170515201356.26384-2-martin.blumenstingl@googlemail.com>
From: =?UTF-8?Q?Andreas_F=c3=a4rber?= <afaerber@suse.de>
Message-ID: <e0b336e6-538e-eeea-0ed4-33460dbef7e0@suse.de> (sfid-20170521_165418_530223_145F1409)
Date: Sun, 21 May 2017 16:54:01 +0200
MIME-Version: 1.0
In-Reply-To: <20170515201356.26384-2-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 15.05.2017 um 22:13 schrieb Martin Blumenstingl:
> The example in the BCM43xx documentation uses "brcmf" as node name.

No, it doesn't, it uses "bcrmf".

This typo has spread to all ARM device trees:

$ git grep bcrmf -- arch/arm/boot/dts/
arch/arm/boot/dts/imx6sx-nitrogen6sx.dts:       brcmf: bcrmf@1 {
arch/arm/boot/dts/imx6ul-opos6ul.dtsi:  brcmf: bcrmf@1 {
arch/arm/boot/dts/sun6i-a31s-sinovoip-bpi-m2.dts:       brcmf: bcrmf@1 {
arch/arm/boot/dts/sun7i-a20-bananapi-m1-plus.dts:       brcmf: bcrmf@1 {
arch/arm/boot/dts/sun7i-a20-bananapro.dts:      brcmf: bcrmf@1 {
arch/arm/boot/dts/sun7i-a20-cubietruck.dts:     brcmf: bcrmf@1 {
arch/arm/boot/dts/sun7i-a20-i12-tvbox.dts:      brcmf: bcrmf@1 {
arch/arm/boot/dts/sun7i-a20-wits-pro-a20-dkt.dts:       brcmf: bcrmf@1 {
arch/arm/boot/dts/sun8i-h3-bananapi-m2-plus.dts:        brcmf: bcrmf@1 {

For arch/arm64/boot/dts/amlogic/* I've already fixed it, originally by
changing to "brcmf", in a second step "wifi" was requested.

> However, wireless devices should be named "wifi" instead. Fix this to
> make sure that .dts authors can simply use the documentation as
> reference (or simply copy the node from the documentation and then
> adjust only the board specific bits).
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> index 5dbf169cd81c..590f622188de 100644
> --- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> +++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> @@ -31,7 +31,7 @@ mmc3: mmc@01c12000 {
>  	non-removable;
>  	status = "okay";
>  
> -	brcmf: bcrmf@1 {
> +	brcmf: wifi@1 {
>  		reg = <1>;
>  		compatible = "brcm,bcm4329-fmac";
>  		interrupt-parent = <&pio>;

Thanks for fixing this at its source.

Hopefully the maintainers in CC can make sure that at least it doesn't
spread further into new DTs.

Regards,
Andreas

-- 
SUSE Linux GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
