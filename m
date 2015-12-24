Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f176.google.com ([209.85.160.176]:34825 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbbLXQdX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 11:33:23 -0500
Received: by mail-yk0-f176.google.com with SMTP id x67so40414531ykd.2
        for <linux-wireless@vger.kernel.org>; Thu, 24 Dec 2015 08:33:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1450971335-15961-4-git-send-email-uri.mashiach@compulab.co.il>
References: <1450971335-15961-1-git-send-email-uri.mashiach@compulab.co.il>
	<1450971335-15961-4-git-send-email-uri.mashiach@compulab.co.il>
Date: Thu, 24 Dec 2015 13:33:22 -0300
Message-ID: <CABxcv=kjwE2JJ_NDWEF7goHaYpsbP5gMV4P_bHdwyj5iDk-SqA@mail.gmail.com> (sfid-20151224_173354_031458_F5170E71)
Subject: Re: [PATCH v2 3/3] wlcore/wl12xx: spi: add wifi support to cm-t335
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Uri Mashiach <uri.mashiach@compulab.co.il>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Rob Herring <robh+dt@kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Benoit Cousson <bcousson@baylibre.com>,
	Igor Grinberg <grinberg@compulab.co.il>,
	Eliad Peller <eliad@wizery.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Uri,

On Thu, Dec 24, 2015 at 12:35 PM, Uri Mashiach
<uri.mashiach@compulab.co.il> wrote:
> Device tree modifications:
> - Pinmux for SPI0 and WiFi GPIOs.
> - SPI0 node with wlcore as a child node.
>
> Cc: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Uri Mashiach <uri.mashiach@compulab.co.il>
> Acked-by: Igor Grinberg <grinberg@complab.co.il>
> ---
> v1 -> v2: replace interrupts and interrupt-parent with interrupts-extended.
>
>  arch/arm/boot/dts/am335x-cm-t335.dts | 57 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 56 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/am335x-cm-t335.dts b/arch/arm/boot/dts/am335x-cm-t335.dts
> index 42e9b66..31f8371 100644
> --- a/arch/arm/boot/dts/am335x-cm-t335.dts
> +++ b/arch/arm/boot/dts/am335x-cm-t335.dts
> @@ -11,6 +11,7 @@
>  /dts-v1/;
>
>  #include "am33xx.dtsi"
> +#include <dt-bindings/interrupt-controller/irq.h>
>
>  / {
>         model = "CompuLab CM-T335";
> @@ -40,6 +41,15 @@
>                 regulator-max-microvolt = <3300000>;
>         };
>
> +       /* Regulator for WiFi */
> +       vwlan_fixed: fixedregulator@2 {
> +               compatible = "regulator-fixed";
> +               regulator-name = "vwlan_fixed";
> +               gpio = <&gpio0 20 GPIO_ACTIVE_HIGH>; /* gpio0_20 */
> +               enable-active-high;
> +               regulator-boot-off;
> +       };
> +
>         backlight {
>                 compatible = "pwm-backlight";
>                 pwms = <&ecap0 0 50000 0>;
> @@ -50,7 +60,10 @@
>
>  &am33xx_pinmux {
>         pinctrl-names = "default";
> -       pinctrl-0 = <&bluetooth_pins>;
> +       pinctrl-0 = <
> +                 &bluetooth_pins
> +                 &wifi_pins
> +       >;

The pinctrl lines should be in the device node that needs the pin
muxing (unless there isn't a device node) so I think is better if you
mofe the pinctrl-0 = <&wifi_pins> to the wlcore dev node.

Best regards,
Javier
