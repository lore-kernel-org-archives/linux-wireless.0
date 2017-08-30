Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:45430 "EHLO
        smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751297AbdH3C2t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Aug 2017 22:28:49 -0400
MIME-Version: 1.0
In-Reply-To: <20170829214309.34466-1-antony@phenome.org>
References: <20170829214309.34466-1-antony@phenome.org>
From: Chen-Yu Tsai <wens@csie.org>
Date: Wed, 30 Aug 2017 10:28:20 +0800
Message-ID: <CAGb2v66=JvS9wHkUNBwd+vHwx4NAQsaWyhx1OyEokSZizo+7-g@mail.gmail.com> (sfid-20170830_042853_046342_BA6207B7)
Subject: Re: [PATCH] Documentation: dt-binding: net: wireless: add bcm43430-fmac
To: Antony Antony <antony@phenome.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Icenowy Zheng <icenowy@aosc.io>,
        devicetree <devicetree@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Chen-Yu Tsai <wens@csie.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, Aug 30, 2017 at 5:43 AM, Antony Antony <antony@phenome.org> wrote:
> Add device tree binding documentation for Broadcom BCM43430
> AMPAK AP6212A has this chip.
>
> e.g
> compatible = "brcm,bcm43430-fmac";
>
> NanoPi NEO Plus2 has an AMPAK AP6212A WiFi module
> with BCM43430 rev=1 inside.
> brcmf_chip_recognition found AXI chip: BCM43430, rev=1
> brcmf_ops_sdio_probe sdio vendor ID: 0x02d0
> brcmf_ops_sdio_probe sdio device ID: 0xa9a6
>
> Signed-off-by: Antony Antony <antony@phenome.org>
> ---
>  Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>  NanoPi Neo Plus2 Kernel DT propsed patch
>  https://patchwork.kernel.org/patch/9925387/
>
> diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> index 590f622..9107e1a 100644
> --- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> +++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> @@ -6,7 +6,9 @@ connects the device to the system.
>
>  Required properties:
>
> - - compatible : Should be "brcm,bcm4329-fmac".
> + - compatible : should be one of the following:
> +       * "brcm,bcm4329-fmac"
> +       * "brcm,bcm43430-fmac"

You updated the bindings, but not the driver. So it's not actually
going to work. More specifically, OOB interrupts won't work.

IIRC, The compatible string for this particular case, as it was
originally proposed, only serves as a placeholder for the driver
to check against. None of the instances in sunxi device trees
match the actual chip model. Actual model matching is done
through SDIO, as you've already seen.

ChenYu


>
>  Optional properties:
>   - brcm,drive-strength : drive strength used for SDIO pins on device in mA
> --
> 2.9.3
>
