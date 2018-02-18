Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:57218 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751259AbeBRQkH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Feb 2018 11:40:07 -0500
Subject: Re: [PATCH] v5 ath10k: add LED and GPIO controlling support for
 various chipsets
To: Bo YU <tsu.yubo@gmail.com>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        ath10k@lists.infradead.org,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>
References: <20180218120300.5997-1-s.gottschall@dd-wrt.com>
 <20180218143351.GA30308@yubo-2>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <8f49257f-b40b-2e97-5f45-04fc1e6e544a@dd-wrt.com> (sfid-20180218_174012_253996_53E63929)
Date: Sun, 18 Feb 2018 17:40:01 +0100
MIME-Version: 1.0
In-Reply-To: <20180218143351.GA30308@yubo-2>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 18.02.2018 um 15:33 schrieb Bo YU:
> Hi,
> I am just wondering about something.I am a newbies.
>
> On Sun, Feb 18, 2018 at 01:03:00PM +0100, s.gottschall@dd-wrt.com wrote:
>>
>>
>> +#ifdef CONFIG_GPIOLIB
>> +
>> +static int ath10k_gpio_pin_cfg_input(struct gpio_chip *chip, 
>> unsigned offset)
>> +{
>> +    struct ath10k_gpiocontrol *gpio = container_of(chip, struct 
>> ath10k_gpiocontrol, gchip);
>> +    ath10k_wmi_gpio_config(gpio->ar, offset, 1, WMI_GPIO_PULL_NONE, 
>> WMI_GPIO_INTTYPE_DISABLE); // configure to input
> If i remember right,comment style in kernel code would better to use
> /* .. */. Same the below comment.
true
> + +/* register GPIO chip */
>> +static int ath10k_register_gpio_chip(struct ath10k *ar)
>> +{
>> +    struct ath10k_gpiocontrol *gpio;
>> +    gpio = kzalloc(sizeof(struct ath10k_gpiocontrol), GFP_KERNEL);
>> +    if (!gpio) {
>> +        return -1;
> There is rare value returned after allocing memory from kernel.Maybe
> "return -ENOMEM"?
not really relevant since the return check just checks for value present 
and not for value type
but i applied it for next patch version

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
