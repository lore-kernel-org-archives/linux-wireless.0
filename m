Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34123 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932992AbcK1OPa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 09:15:30 -0500
Date: Mon, 28 Nov 2016 08:15:13 -0600
From: Rob Herring <robh@kernel.org>
To: Matt Ranostay <matt@ranostay.consulting>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-mmc@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH] mmc: pwrseq: add support for Marvell SD8787 chip
Message-ID: <20161128141513.agnkyz6ronigbukn@rob-hp-laptop> (sfid-20161128_151559_019107_631E4D0B)
References: <1479434109-8745-1-git-send-email-matt@ranostay.consulting>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1479434109-8745-1-git-send-email-matt@ranostay.consulting>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 17, 2016 at 05:55:09PM -0800, Matt Ranostay wrote:
> Allow power sequencing for the Marvell SD8787 Wifi/BT chip.
> This can be abstracted to other chipsets if needed in the future.

I don't like the MMC pwrseq bindings, so I won't be acking any. Look at 
the USB pwrseq for why.

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
> new file mode 100644
> index 000000000000..1b658351629b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mmc/mmc-pwrseq-sd8787.txt
> @@ -0,0 +1,14 @@
> +* Marvell SD8787 power sequence provider
> +
> +Required properties:
> +- compatible: must be "mmc-pwrseq-sd8787".
> +- pwndn-gpio: contains a power down GPIO specifier.

powerdown-gpios

> +- reset-gpio: contains a reset GPIO specifier.

reset-gpios

> +
> +Example:
> +
> +	wifi_pwrseq: wifi_pwrseq {
> +		compatible = "mmc-pwrseq-sd8787";
> +		pwrdn-gpio = <&twl_gpio 0 GPIO_ACTIVE_LOW>;
> +		reset-gpio = <&twl_gpio 1 GPIO_ACTIVE_LOW>;
> +	}
> diff --git a/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt b/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt
> index c421aba0a5bc..08fd65d35725 100644
> --- a/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt
> +++ b/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt
> @@ -32,6 +32,9 @@ Optional properties:
>  		 so that the wifi chip can wakeup host platform under certain condition.
>  		 during system resume, the irq will be disabled to make sure
>  		 unnecessary interrupt is not received.
> +  - vmmc-supply: a phandle of a regulator, supplying VCC to the card

This is why pwrseq is wrong. You have some properties in the card node 
and some in pwrseq node. Everything should be in the card node.

> +  - mmc-pwrseq:  phandle to the MMC power sequence node. See "mmc-pwrseq-*"
> +		 for documentation of MMC power sequence bindings.
>  
>  Example:
>  
> @@ -44,6 +47,7 @@ so that firmware can wakeup host using this device side pin.
>  &mmc3 {
>  	status = "okay";
>  	vmmc-supply = <&wlan_en_reg>;
> +	mmc-pwrseq = <&wifi_pwrseq>;
>  	bus-width = <4>;
>  	cap-power-off-card;
>  	keep-power-in-suspend;
