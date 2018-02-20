Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:53252 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751376AbeBTSGY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 13:06:24 -0500
Subject: Re: [PATCH v7] ath10k: add LED and GPIO controlling support for
 various chipsets
To: Steve deRosier <steve.derosier@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>
References: <20180220073259.17254-1-s.gottschall@dd-wrt.com>
 <CALLGbRLwmPLTEXDbnLy8Ba0G0CYXM2HehbgDy2HEz9BdBNx1sQ@mail.gmail.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <a8958e0e-8f54-4869-d69a-2f29eae57f14@dd-wrt.com> (sfid-20180220_190630_573128_29FED8A3)
Date: Tue, 20 Feb 2018 19:06:12 +0100
MIME-Version: 1.0
In-Reply-To: <CALLGbRLwmPLTEXDbnLy8Ba0G0CYXM2HehbgDy2HEz9BdBNx1sQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 20.02.2018 um 17:52 schrieb Steve deRosier:
>
>> +static int ath10k_register_gpio_chip(struct ath10k *ar)
>> +{
>> +       struct ath10k_gpiocontrol *gpio;
>> +       gpio = kzalloc(sizeof(struct ath10k_gpiocontrol), GFP_KERNEL);
>> +       if (!gpio) {
>> +               return -ENOMEM;
>> +       }
>> +
>> +       snprintf(gpio->label, sizeof(gpio->label), "ath10k-%s",
>> +                wiphy_name(ar->hw->wiphy));
>> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,5,0)
>> +       gpio->gchip.parent = ar->dev;
>> +#else
>> +       gpio->gchip.dev = ar->dev;
>> +#endif
>> +       gpio->gchip.base = -1;  /* determine base automatically */
> I may be wrong, but I think that version guards are unwelcome here.
> The patch is supposed to go and apply specifically to the upstream
> version, which is clearly >= KERNEL_VERSION(4,5,0). I think you can
> drop this, only use the 'gpio->gchip.parent = ar->dev;' and call it
> good. This fixup should be picked up by Backports.  I understand that
> you might need to keep it for your internal tree, but I don't think
> the maintainers want to see this.
the original patch comes from my sources which are supposed to work with 
compat-wireless für multiple kernels. but for sure i can change that :-)
>
>
>> +/* remove GPIO chip */
>> +static void ath10k_unregister_gpio_chip(struct ath10k *ar)
>> +{
>> +#ifdef CONFIG_GPIOLIB
>> +       struct ath10k_gpiocontrol *gpio = ar->gpio;
>> +       if (gpio) {
>> +               gpiochip_remove(&gpio->gchip);
>> +               kfree(gpio);
>> +       }
>> +#endif
>> +}
> Instead of entering/exiting the guards inside every function, I think
> the usually accepted way to handle this is to place a block in the
> that looks basically like:
>
> #ifdef CONFIG_GPIOLIB
> static void ath10k_unregister_gpio_chip(struct ath10k *ar) {
>         struct ath10k_gpiocontrol *gpio = ar->gpio;
>         if (gpio) {
>                 gpiochip_remove(&gpio->gchip);
>                 kfree(gpio);
>         }
>   }
>
> next function....
> next function...
>
> #else
> static void ath10k_unregister_gpio_chip(struct ath10k *ar) {
>   }
> next function....
> next function...
> #endif
>
> If they weren't static, you'd do it in the .h file, with the
> declaration of the full function there and the definition in the .c.
>
> I may be nit-picking and your style is perfectly acceptable to the
> other maintainers.
i'm not a fan of bloat code. and making funktions static which are just 
called one will allow the compiler to optimize the code better
than making it non static. that makes no sense here for sure. its just a 
question how you handle it.
>
>
>> +
>> +static void ath10k_unregister_led(struct ath10k *ar)
>> +{
>> +#if defined (CONFIG_GPIOLIB) && defined(CONFIG_LEDS_CLASS)
>> +       if (ar->gpio)
>> +               led_classdev_unregister(&ar->gpio->cdev);
>> +#endif
>> +}
>> +
>> +
>>   int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
>>                        const struct ath10k_fw_components *fw)
>>   {
>>          int status;
>>          u32 val;
>> -
>>          lockdep_assert_held(&ar->conf_mutex);
>>
> Whitespace change for no apparent reason.
count it as typo
>
>> @@ -2372,8 +2524,32 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
>>          if (status)
>>                  goto err_hif_stop;
>>
>> -       return 0;
>>
>> +#ifdef CONFIG_GPIOLIB
>> +       /* LED Code */
>> +       if (ar->hw_params.led_pin) { /* only attach if non zero since some chipsets are unsupported yet */
>> +               if (!ar->gpio_attached) {
>> +                       status = ath10k_register_gpio_chip(ar);
>> +                       if (status) {
>> +                               goto err_no_led;
>> +                       }
>> +#ifdef CONFIG_LEDS_CLASS
>> +                       ar->gpio_attached = 1;
>> +                       ar->gpio->wifi_led.active_low = 1;
>> +                       ar->gpio->wifi_led.gpio = ar->hw_params.led_pin;
>> +                       ar->gpio->wifi_led.name = ar->gpio->label;
>> +                       ar->gpio->wifi_led.default_state = LEDS_GPIO_DEFSTATE_KEEP;
>> +
>> +                       ath10k_add_led(ar, &ar->gpio->wifi_led);
>> +#endif
>> +               }
>> +               ath10k_wmi_gpio_config(ar, ar->hw_params.led_pin, 0, WMI_GPIO_PULL_NONE, WMI_GPIO_INTTYPE_DISABLE); /* configure to output */
>> +               ath10k_wmi_gpio_output(ar, ar->hw_params.led_pin, 1);
>> +       }
>> +err_no_led:;
>> +#endif
>> +
>> +       return 0;
>>   err_hif_stop:
>>          ath10k_hif_stop(ar);
>>   err_htt_rx_detach:
> The guards make it harder to read. In this chunk, every component
> should be defined acceptably even if the CONFIG flags aren't defined
> because they're all under your control. Make sure they are, and then
> you can drop the guards here. The only trick is to be sure that any
> accessed struct members that are protected by guards are abstracted
> and only accessed inside your guarded functions. Alternately, you
> could encapsulate it into a function ath10k_core_gpios_start() and
> just have the single call there. The additional benefit being that you
> don't need the err_no_led: jump.
true, but consider that required structures like gpio_chip (ar->gpio) 
and led_classdev arent defined in the kernel if these CONFIG options 
arent configured. so i may move it into a separate function ,but the 
guards will remain.
thats not my fault. thats a fault of the kernel api.

> The rest of this looks OK to me.
okay. i already changed some code, based on your requests but will wait 
for reply of you and for other comments until i send out a new version
>
> - Steve
>
> --
> Steve deRosier
> Cal-Sierra Consulting LLC
> https://www.cal-sierra.com/
>

-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
