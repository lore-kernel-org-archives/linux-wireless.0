Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:39137 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179Ab0EZRiE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 13:38:04 -0400
Received: by pxi18 with SMTP id 18so2631274pxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 May 2010 10:38:02 -0700 (PDT)
Message-ID: <4BFD5C89.8000308@gmail.com>
Date: Wed, 26 May 2010 10:38:17 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, mcgrof@gmail.com
Subject: Re: [PATCH]wireless:ath9k Disable leds for Apple products.
References: <1274894056-2866-1-git-send-email-justinmattock@gmail.com> <1274894056-2866-2-git-send-email-justinmattock@gmail.com> <20100526171844.GB5823@tuxdriver.com>
In-Reply-To: <20100526171844.GB5823@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/26/2010 10:18 AM, John W. Linville wrote:
> On Wed, May 26, 2010 at 10:14:16AM -0700, Justin P. Mattock wrote:
>    
>> Disable the leds on ath9k for Apple products, since
>> there is no leds on any of there machines(or non that I can find!!).
>>
>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>>      
>    
>>   void ath_init_leds(struct ath_softc *sc)
>>   {
>>   	char *trigger;
>>   	int ret;
>>
>> +	/* Apple has no leds lights for their wireless.  */
>> +	if (dmi_check_system(dmi_system_table)>  0)
>> +		return -ENODEV;
>> +	else
>> +
>>   	if (AR_SREV_9287(sc->sc_ah))
>>   		sc->sc_ah->led_pin = ATH_LED_PIN_9287;
>>   	else
>>      
> Surely we don't need the 'else'.
>
> Does enabling the LEDs on these systems cause any problems?
>
> John
>    
I picked up the idea, from this patch:
http://kerneltrap.org/mailarchive/linux-kernel/2010/1/20/4530535
while looking into a bug for ath9k(thinking maybe leds
are causing something, which want  the case)

so Id have to say I don't think the leds cause issue's,
if anything just a wasted symlink, call, or whatever
in /sys/class/leds/*

Justin P. mattock

