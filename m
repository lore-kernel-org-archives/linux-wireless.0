Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61612 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515Ab0EZVFq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 17:05:46 -0400
Received: by pvg3 with SMTP id 3so1310468pvg.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 May 2010 14:05:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BFD5C89.8000308@gmail.com>
References: <1274894056-2866-1-git-send-email-justinmattock@gmail.com>
	<1274894056-2866-2-git-send-email-justinmattock@gmail.com>
	<20100526171844.GB5823@tuxdriver.com> <4BFD5C89.8000308@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 26 May 2010 14:05:26 -0700
Message-ID: <AANLkTim6ef__fNdXUyP1T4HB7jxbyt-Jlqi3Xa5Y_whm@mail.gmail.com>
Subject: Re: [PATCH]wireless:ath9k Disable leds for Apple products.
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 26, 2010 at 10:38 AM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> On 05/26/2010 10:18 AM, John W. Linville wrote:
>>
>> On Wed, May 26, 2010 at 10:14:16AM -0700, Justin P. Mattock wrote:
>>
>>>
>>> Disable the leds on ath9k for Apple products, since
>>> there is no leds on any of there machines(or non that I can find!!).
>>>
>>>  Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>

Our team has confirmed Apple devices do not have LEDs so a change like
this is OK but this patch is wrong anyway. More details below.

>>>
>>>  void ath_init_leds(struct ath_softc *sc)
>>>  {
>>>        char *trigger;
>>>        int ret;
>>>
>>> +       /* Apple has no leds lights for their wireless.  */
>>> +       if (dmi_check_system(dmi_system_table)>  0)
>>> +               return -ENODEV;
>>> +       else
>>> +
>>>        if (AR_SREV_9287(sc->sc_ah))
>>>                sc->sc_ah->led_pin = ATH_LED_PIN_9287;
>>>        else
>>>
>>
>> Surely we don't need the 'else'.
>>
>> Does enabling the LEDs on these systems cause any problems?
>>
>> John
>>
>
> I picked up the idea, from this patch:
> http://kerneltrap.org/mailarchive/linux-kernel/2010/1/20/4530535
> while looking into a bug for ath9k(thinking maybe leds
> are causing something, which want  the case)
>
> so Id have to say I don't think the leds cause issue's,
> if anything just a wasted symlink, call, or whatever
> in /sys/class/leds/*

The patch is wrong anyway, ath_init_leds() is void and yet you return
a value. If this is really needed I'd also prefer if you define a bool
or something and use a ah->ignore_leds and set this to true if the DMI
stuff checks out for Apple up hw init. Then check for ignore_leds
prior to calling ath_init_leds() and also avoid it if set. Also check
for ingore_leds upon device cleanup and ignore the
acancel_delayed_work_sync(&sc->ath_led_blink_work) and
ath_deinit_leds() and skip that.

But given that it is not needed it seems a lot of work for something
that is a non-issue.

  Luis
