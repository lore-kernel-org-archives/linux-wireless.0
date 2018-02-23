Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:59574 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750916AbeBWCJS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Feb 2018 21:09:18 -0500
Subject: Re: [PATCH v9] ath10k: add LED and GPIO controlling support for
 various chipsets
To: Steve deRosier <derosier@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>
References: <20180222111534.31047-1-s.gottschall@dd-wrt.com>
 <CALLGbRKimHh39DhnJP+mxB3=fkOzPDkXzbGrdJenLOgZUYCcCg@mail.gmail.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <8e2dae09-e8fa-b995-bd62-0f2e1533894d@dd-wrt.com> (sfid-20180223_030924_141793_B4B65B11)
Date: Fri, 23 Feb 2018 03:09:08 +0100
MIME-Version: 1.0
In-Reply-To: <CALLGbRKimHh39DhnJP+mxB3=fkOzPDkXzbGrdJenLOgZUYCcCg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 22.02.2018 um 23:17 schrieb Steve deRosier:
> On Thu, Feb 22, 2018 at 3:15 AM,  <s.gottschall@dd-wrt.com> wrote:
>> From: Sebastian Gottschall <s.gottschall@newmedia-net.de>
>>
>> Adds LED and GPIO Control support for 988x, 9887, 9888, 99x0, 9984 based chipsets with on chipset connected led's
>> using WMI Firmware API.
>> The LED device will get available named as "ath10k-phyX" at sysfs and can be controlled with various triggers.
>> adds also debugfs interface for gpio control.
>>
>> Signed-off-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
>>
>> v2  add correct gpio count per chipset and remove IPQ4019 support since this chipset does not make use of specific gpios)
>> v5  fix compiling without LED_CLASS and GPIOLIB support, fix also error by kbuild test robot which does not occur in standard builds. curious
>> v6  correct return values and fix comment style
>> v7  fix ath10k_unregister_led for compiling without LED_CLASS
>> v8  fix various code design issues reported by reviewers
>> v9  move led and led code to separate sourcefile (gpio.c)
>> ---
>>   drivers/net/wireless/ath/ath10k/Kconfig   |   3 +
>>   drivers/net/wireless/ath/ath10k/Makefile  |   1 +
>>   drivers/net/wireless/ath/ath10k/core.c    |  28 ++++-
>>   drivers/net/wireless/ath/ath10k/core.h    |  33 ++++-
>>   drivers/net/wireless/ath/ath10k/debug.c   | 142 ++++++++++++++++++++++
>>   drivers/net/wireless/ath/ath10k/gpio.c    | 196 ++++++++++++++++++++++++++++++
>>   drivers/net/wireless/ath/ath10k/hw.h      |   2 +
>>   drivers/net/wireless/ath/ath10k/mac.c     |   5 +
>>   drivers/net/wireless/ath/ath10k/wmi-ops.h |  36 +++++-
>>   drivers/net/wireless/ath/ath10k/wmi-tlv.c |  65 ++++++++++
>>   drivers/net/wireless/ath/ath10k/wmi.c     |  46 +++++++
>>   drivers/net/wireless/ath/ath10k/wmi.h     |  36 ++++++
>>   12 files changed, 590 insertions(+), 3 deletions(-)
>>   create mode 100644 drivers/net/wireless/ath/ath10k/gpio.c
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/Kconfig b/drivers/net/wireless/ath/ath10k/Kconfig
>> index deb5ae21a559..c46b7658a820 100644
>> --- a/drivers/net/wireless/ath/ath10k/Kconfig
>> +++ b/drivers/net/wireless/ath/ath10k/Kconfig
>> @@ -2,6 +2,9 @@ config ATH10K
>>           tristate "Atheros 802.11ac wireless cards support"
>>           depends on MAC80211 && HAS_DMA
>>          select ATH_COMMON
>> +        select MAC80211_LEDS
>> +        select LEDS_CLASS
>> +        select NEW_LEDS
>>          select CRC32
>>          select WANT_DEV_COREDUMP
>>           ---help---
> Pure question: do we require LEDS, or is this an option? I assumed all
> along it was an optional thing - ie if GPIOs and/or LEDs were
> configured, we added this code. And if not optional, then what happens
> if we are on a platform that can't support LEDS_CLASS or NEW_LEDS,
> assuming there is such a thing?
i took this behaviour from ath9k/ath5k, both driver auto select 
MAC80211_LEDS and LEDS_CLASS (by the way MAC80211_LEDS auto selects 
LEDS_CLASS too).  only chipsets which are known to have preconfigured 
leds are used
and led will only turn on if you enable it in sysfs by assigning a 
trigger to the led.
for sure this can be removed from the Kconfig. it will compile without 
it as well. so this is optional. i just added it since all other drivers 
behave in the same way.
in addition. LEDS_CLASS  / NEW_LEDS is a kernel api, not a driver. so 
all platforms to support LEDS_CLASS. just enabling LEDS_CLASS will not 
cause any platform specific dependency.
>
>
>> diff --git a/drivers/net/wireless/ath/ath10k/Makefile b/drivers/net/wireless/ath/ath10k/Makefile
>> index 6739ac26fd29..bcb234f0b940 100644
>> --- a/drivers/net/wireless/ath/ath10k/Makefile
>> +++ b/drivers/net/wireless/ath/ath10k/Makefile
>> @@ -20,6 +20,7 @@ ath10k_core-$(CONFIG_NL80211_TESTMODE) += testmode.o
>>   ath10k_core-$(CONFIG_ATH10K_TRACING) += trace.o
>>   ath10k_core-$(CONFIG_THERMAL) += thermal.o
>>   ath10k_core-$(CONFIG_MAC80211_DEBUGFS) += debugfs_sta.o
>> +ath10k_core-y += gpio.o
>>   ath10k_core-$(CONFIG_PM) += wow.o
>>   ath10k_core-$(CONFIG_DEV_COREDUMP) += coredump.o
>>
> I'd expect it would be something like `ath10k_core-$(CONFIG_GPIO) +=
> gpoi.o`.  Maybe I'm mistaken.
gpio.c contains the MAC80211_LEDS code and has a guard for GPIOLIB 
inside. it can be compiled even if GPIOLIB is disabled in system. (which 
is indeed platform specific)
and leds are still supported without gpio support since it does contain 
a led only driver and a separate gpio driver.
i suggest more somelike like

ath10k_core-$(ATH10K_LEDS) += gpio.o

if you want it totally optional which requires some other small changes as well (mainly renaming some ifdefs)

> (Note, I didn't look up the actual config option name, I'm guessing.
> Assume I wrote something reasonable for my example.)
>
> I only ask the above two questions, not because I think it's wrong,
> but because I don't quite know the intention and it makes me wonder.
>
> Other than those questions, which are optional as the code looks
> correct to me, the rest of it looks fine to me.
i fully understand your concerns, i just followed other drivers 
behaviour. for sure its more sane to make it optional and to compile it 
out of not required.
but then i suggest todo the same in ath5k and ath9k
>
> Reviewed-by: Steve deRosier <derosier@cal-sierra.com>
>
> - Steve
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
