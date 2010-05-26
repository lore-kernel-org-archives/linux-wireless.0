Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62601 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702Ab0EZRT3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 13:19:29 -0400
Received: by pwi7 with SMTP id 7so296328pwi.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 May 2010 10:19:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1274894056-2866-2-git-send-email-justinmattock@gmail.com>
References: <1274894056-2866-1-git-send-email-justinmattock@gmail.com>
	<1274894056-2866-2-git-send-email-justinmattock@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 26 May 2010 10:19:09 -0700
Message-ID: <AANLkTik_lsfVCumdryeS7azIPrQRd4NwCgbqV-vvlS6L@mail.gmail.com>
Subject: Re: [PATCH]wireless:ath9k Disable leds for Apple products.
To: "Justin P. Mattock" <justinmattock@gmail.com>,
	David Quan <David.Quan@atheros.com>,
	Vinod Nagarajan <vnagarajan@atheros.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Note: This e-mail is on a public mailing list.

David, Vinod, is it true, no Apple devices have LEDs?

On Wed, May 26, 2010 at 10:14 AM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> Disable the leds on ath9k for Apple products, since
> there is no leds on any of there machines(or non that I can find!!).
>
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>
> ---
>  drivers/net/wireless/ath/ath9k/gpio.c |   20 ++++++++++++++++++++
>  1 files changed, 20 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
> index 0ee75e7..c21e74f 100644
> --- a/drivers/net/wireless/ath/ath9k/gpio.c
> +++ b/drivers/net/wireless/ath/ath9k/gpio.c
> @@ -15,6 +15,7 @@
>  */
>
>  #include "ath9k.h"
> +#include <linux/dmi.h>
>
>  /********************************/
>  /*      LED functions          */
> @@ -127,11 +128,30 @@ void ath_deinit_leds(struct ath_softc *sc)
>        ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
>  }
>
> +static struct dmi_system_id __initdata dmi_system_table[] = {
> +       {
> +               .matches = {
> +                       DMI_MATCH(DMI_BIOS_VENDOR, "Apple Computer, Inc.")
> +               },
> +       },
> +       {
> +               .matches = {
> +                       DMI_MATCH(DMI_BIOS_VENDOR, "Apple Inc.")
> +               },
> +       },
> +       {}
> +};
> +
>  void ath_init_leds(struct ath_softc *sc)
>  {
>        char *trigger;
>        int ret;
>
> +       /* Apple has no leds lights for their wireless.  */
> +       if (dmi_check_system(dmi_system_table) > 0)
> +               return -ENODEV;
> +       else
> +
>        if (AR_SREV_9287(sc->sc_ah))
>                sc->sc_ah->led_pin = ATH_LED_PIN_9287;
>        else
> --
> 1.6.5.GIT
>
>
