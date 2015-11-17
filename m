Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:33816 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbbKQGZZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2015 01:25:25 -0500
Received: by ioir85 with SMTP id r85so9111869ioi.1
        for <linux-wireless@vger.kernel.org>; Mon, 16 Nov 2015 22:25:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1447738373-15804-2-git-send-email-steve.derosier@lairdtech.com>
References: <1447738373-15804-1-git-send-email-steve.derosier@lairdtech.com> <1447738373-15804-2-git-send-email-steve.derosier@lairdtech.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 17 Nov 2015 17:25:05 +1100
Message-ID: <CAGRGNgUdSrwxw7j885ghFu5ivHfWgDCUC7RODbV8iW_AcmfE5Q@mail.gmail.com> (sfid-20151117_072533_571622_810A5F3A)
Subject: Re: [PATCH 1/2] ath6kl_sdio: Add reset gpio module parameter for
 CHIP_PWD_L pin
To: Steve deRosier <derosier@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath6kl@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Steve deRosier <steve.derosier@lairdtech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Steve,

On Tue, Nov 17, 2015 at 4:32 PM, Steve deRosier <derosier@gmail.com> wrote:
> Many ath6k chips have a reset pin, usually labeled CHIP_PWD_L. This pin can
> be pulled low by the host processor to hold the wifi chip in reset. By
> holding the chip in reset, the lowest power consumption available can be
> achieved.
>
> This adds a module parameter so the ath6kl_sdio driver can control the
> CHIP_PWD_L pin if the implementer so desires. This code is only available
> if GPIOLIB is configured.

linux/gpio.h is built so that the exported functions are no-ops when
GPIOLIB isn't defined. Providing you include linux/gpio.h
unconditionally, all of your #ifdefs except the one around the module
parameter can be removed and the code will be optimised away by the
compiler.

> Signed-off-by: Steve deRosier <steve.derosier@lairdtech.com>
> ---
>  drivers/net/wireless/ath/ath6kl/sdio.c | 80 +++++++++++++++++++++++++++++++++-
>  1 file changed, 79 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
> index eab0ab9..7a732f3 100644
> --- a/drivers/net/wireless/ath/ath6kl/sdio.c
> +++ b/drivers/net/wireless/ath/ath6kl/sdio.c
> @@ -67,8 +67,18 @@ struct ath6kl_sdio {
>
>         /* protects access to wr_asyncq */
>         spinlock_t wr_async_lock;
> +
>  };
>
> +#ifdef CONFIG_GPIOLIB
> +#include <linux/gpio.h>
> +#define NO_GPIO    0xffffffff

ARCH_NR_GPIOS could be used here instead of defining NO_GPIO.

> +
> +static unsigned int reset_pwd_gpio = NO_GPIO;
> +module_param(reset_pwd_gpio, uint, 0644);
> +MODULE_PARM_DESC(reset_pwd_gpio, "WIFI CHIP_PWD reset pin GPIO");
> +#endif
> +
>  #define CMD53_ARG_READ          0
>  #define CMD53_ARG_WRITE         1
>  #define CMD53_ARG_BLOCK_BASIS   1
> @@ -1414,20 +1424,88 @@ static struct sdio_driver ath6kl_sdio_driver = {
>         .drv.pm = ATH6KL_SDIO_PM_OPS,
>  };
>
> +static int __init ath6kl_sdio_init_gpio(void)
> +{
> +       int ret = 0;
> +
> +#ifdef CONFIG_GPIOLIB
> +       if (!gpio_is_valid(reset_pwd_gpio))
> +               return 0;
> +
> +       /* Request the reset GPIO, and assert it to make sure we get a 100%
> +        * clean boot in-case we had a floating input or other issue.
> +        */
> +       ret = gpio_request_one(reset_pwd_gpio,
> +                              GPIOF_OUT_INIT_LOW | GPIOF_EXPORT_DIR_FIXED,
> +                              "WIFI_RESET");
> +       if (ret) {
> +               ath6kl_err("Unable to get WIFI power gpio: %d\n", ret);
> +               return ret;
> +       }
> +
> +       ath6kl_dbg(ATH6KL_DBG_SUSPEND, "Setup wifi gpio #%d\n", reset_pwd_gpio);
> +       usleep_range(20, 50); /* Pin must be asserted at least 5 usec */
> +       gpio_set_value(reset_pwd_gpio, 1); /* De-assert the pin for operation */
> +
> +       /* Delay to avoid the mmc driver calling the probe on the prior notice
> +        * of the chip, which we just killed. If this is missing, it results in
> +        * a spurious warning:
> +        * "ath6kl_sdio: probe of mmc0:0001:1 failed with error -110"
> +        */
> +       msleep(150); /* Time chosen experimentally, with padding */

Should this be in a #define?

> +#endif
> +
> +       return ret;

ret is always zero here. You should just return 0 here.

> +}
> +
> +static void __exit ath6kl_sdio_release_gpio(void)
> +{
> +#ifdef CONFIG_GPIOLIB
> +       if (gpio_is_valid(reset_pwd_gpio)) {
> +               /* Be sure we leave the chip in reset when we unload and also
> +                * release the GPIO
> +                */
> +               gpio_set_value(reset_pwd_gpio, 0);
> +               gpio_free(reset_pwd_gpio);
> +       }
> +#endif
> +}
> +
>  static int __init ath6kl_sdio_init(void)
>  {
>         int ret;
>
> -       ret = sdio_register_driver(&ath6kl_sdio_driver);
> +       ret = ath6kl_sdio_init_gpio();
>         if (ret)
> +               goto err_gpio;
> +
> +       ret = sdio_register_driver(&ath6kl_sdio_driver);
> +       if (ret) {
>                 ath6kl_err("sdio driver registration failed: %d\n", ret);
> +               goto err_register;
> +       }
> +
> +       return ret;
> +
> +err_register:
> +       ath6kl_sdio_release_gpio();
>
> +err_gpio:
>         return ret;
>  }
>
>  static void __exit ath6kl_sdio_exit(void)
>  {
>         sdio_unregister_driver(&ath6kl_sdio_driver);
> +
> +#ifdef CONFIG_GPIOLIB
> +       /* Delay to avoid pulling the plug on the chip when an irq is pending
> +        * and then getting a spurious message:
> +        * "ath6kl: failed to get pending recv messages: -125"
> +        */
> +       msleep(300);

Is there some actual synchronisation you can do here against the IRQ?
300msec isn't a long time to wait, but it seems wrong here.

> +       ath6kl_sdio_release_gpio();
> +#endif
>  }
>
>  module_init(ath6kl_sdio_init);

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
