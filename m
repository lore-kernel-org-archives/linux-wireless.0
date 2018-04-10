Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:46043 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751600AbeDJKdO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 06:33:14 -0400
Subject: Re: [PATCH v13] ath10k: add LED and GPIO controlling support for
 various chipsets
To: Kalle Valo <kvalo@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>
References: <1523027875-5143-1-git-send-email-kvalo@codeaurora.org>
 <a249fc31-18bf-96a1-27ee-deea05d2d0ff@dd-wrt.com>
 <87k1tgbcs0.fsf@kamboji.qca.qualcomm.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <faaec345-4f7f-631b-9603-3de0305c58a1@dd-wrt.com> (sfid-20180410_123318_198047_DAAA2EF2)
Date: Tue, 10 Apr 2018 12:33:09 +0200
MIME-Version: 1.0
In-Reply-To: <87k1tgbcs0.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 09.04.2018 um 17:49 schrieb Kalle Valo:
> Sebastian Gottschall <s.gottschall@dd-wrt.com> writes:
>
>> you removed the call to leds_start from certain locations but you seem
>> to have ignored the comment i wrote above the function call.
> IIRC I moved the comment to ath10k_leds_start().
>
>> there is a reason why i reinitialize the gpio output state in these
>> locations. the firmware for 9984 and 99xx resets the gpio registers
>> at certain points. this will lead to a non working led code.
> What are the certain points exactly? I tried to be careful that from
> firmware's point of view the functionality is the same, even if I moved
> the call to a different location. Did you test the patch? Is it broken
> now?
i reviewed the firmware code as well, but havent found the reason. can 
be core/chipset specific and not firmware software related.
i just can say it doesnt happen on 988x, just newer chipsets are affected
> The naming refers to phases of ath10k initialisation which are:
>
> create() - destroy()
> register() - unregister()
> start() - stop()
>
> So the naming doesn't mean that every ath10k_foo_start() has to start
> something, it just describes the phase of driver initialisation it's
> called in.
yes, but its not a initialisation too. its just a gpio pin reset. the 
initialisation is
the trigger code itself from my point of view
> Is this really so frequently called that we need to think about CPU
> time? How often are we expecting the LED state to change?
>
> But I'm not really following you, from firmware point of view the
> functionality should be the same as with your patch.
a typical tpt trigger as used in openwrt for instance may trigger it 
several times per second.
i mean it might be really just a micro effect, but i just save cpu time 
whereever i can since i'm focused in
embedded development
>
>> so if you want to follow this up. remove ath10k_leds_start
>> and insert
>>
>> ath10k_wmi_gpio_config(ar, ar->hw_params.led_pin, 0,
>>                    WMI_GPIO_PULL_NONE, WMI_GPIO_INTTYPE_DISABLE);
>>
>> in ath10k_leds_set_brightness_blocking
> Calling ath10k_wmi_gpio_config() every time sounds like quite odd to me
> and your patch didn't do that either. Are you sure this is really
> needed?
yes. i tested this. you must set the gpio to output before setting it to 
any value, in case the output state was resetted back to input or any 
other default value. (which it does on 9984 at certain events)
i tested this on a netgear r7800 which is ipq8064 based with 2 9984 
chipsets.
but i cannot reproduce this on mips routers with 988x chipsets.

but as you say. its odd to call it every time. so i just call it with 
the reset method when neccessary. in our case, when interface operation 
starts.


-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
