Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:36156 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756461AbcK2RNt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 12:13:49 -0500
Received: by mail-io0-f194.google.com with SMTP id k19so30605146iod.3
        for <linux-wireless@vger.kernel.org>; Tue, 29 Nov 2016 09:13:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1479434109-8745-1-git-send-email-matt@ranostay.consulting>
References: <1479434109-8745-1-git-send-email-matt@ranostay.consulting>
From: Javier Martinez Canillas <javier@dowhile0.org>
Date: Tue, 29 Nov 2016 14:13:47 -0300
Message-ID: <CABxcv=nEih8xX4fM0eqjkqprdt1uGTEyx5tzK04GuSgsHc=Haw@mail.gmail.com> (sfid-20161129_181425_058265_AF4BDB6B)
Subject: Re: [PATCH] mmc: pwrseq: add support for Marvell SD8787 chip
To: Matt Ranostay <matt@ranostay.consulting>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Matt,

On Thu, Nov 17, 2016 at 10:55 PM, Matt Ranostay
<matt@ranostay.consulting> wrote:
> Allow power sequencing for the Marvell SD8787 Wifi/BT chip.
> This can be abstracted to other chipsets if needed in the future.
>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Signed-off-by: Matt Ranostay <matt@ranostay.consulting>
> ---
>  .../devicetree/bindings/mmc/mmc-pwrseq-sd8787.txt  |  14 +++
>  .../bindings/net/wireless/marvell-sd8xxx.txt       |   4 +
>  drivers/mmc/core/Kconfig                           |  10 ++
>  drivers/mmc/core/Makefile                          |   1 +
>  drivers/mmc/core/pwrseq_sd8787.c                   | 117 +++++++++++++++++++++
>  5 files changed, 146 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mmc/mmc-pwrseq-sd8787.txt
>  create mode 100644 drivers/mmc/core/pwrseq_sd8787.c
>
> diff --git a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-sd8787.txt b/Documentation/devicetree/bindings/mmc/mmc-pwrseq-sd8787.txt

According Documentation/devicetree/bindings/submitting-patches.txt,
the DT bindings patches should posted as a separate patch.

> new file mode 100644
> index 000000000000..1b658351629b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mmc/mmc-pwrseq-sd8787.txt
> @@ -0,0 +1,14 @@
> +* Marvell SD8787 power sequence provider
> +
> +Required properties:
> +- compatible: must be "mmc-pwrseq-sd8787".

Since this is not a generic binding, the compatible string should have
a vendor prefix.

> +- pwndn-gpio: contains a power down GPIO specifier.
> +- reset-gpio: contains a reset GPIO specifier.
> +

I wonder if we really need a custom power sequence provider for just
this SDIO WiFI chip though. AFAICT the only missing piece in
mmc-pwrseq-simple is the power down GPIO property, so maybe
mmc-pwrseq-simple could be extended instead to have an optional
powerdown-gpios property and instead in the Marvell SD8787 DT binding
can be mentioned which mmc-pwrseq-simple properties are required for
the device.

> +Example:
> +
> +       wifi_pwrseq: wifi_pwrseq {
> +               compatible = "mmc-pwrseq-sd8787";
> +               pwrdn-gpio = <&twl_gpio 0 GPIO_ACTIVE_LOW>;
> +               reset-gpio = <&twl_gpio 1 GPIO_ACTIVE_LOW>;
> +       }
> diff --git a/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt b/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt

Does this patch depend on a previous posted series? I don't see this
file in today's linux-next...

> index c421aba0a5bc..08fd65d35725 100644
> --- a/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt
> +++ b/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt
> @@ -32,6 +32,9 @@ Optional properties:
>                  so that the wifi chip can wakeup host platform under certain condition.
>                  during system resume, the irq will be disabled to make sure
>                  unnecessary interrupt is not received.
> +  - vmmc-supply: a phandle of a regulator, supplying VCC to the card
> +  - mmc-pwrseq:  phandle to the MMC power sequence node. See "mmc-pwrseq-*"
> +                for documentation of MMC power sequence bindings.
>
>  Example:
>
> @@ -44,6 +47,7 @@ so that firmware can wakeup host using this device side pin.
>  &mmc3 {
>         status = "okay";
>         vmmc-supply = <&wlan_en_reg>;
> +       mmc-pwrseq = <&wifi_pwrseq>;
>         bus-width = <4>;
>         cap-power-off-card;
>         keep-power-in-suspend;

I think this change should be split in a separate patch as well.

Best regards,
Javier
