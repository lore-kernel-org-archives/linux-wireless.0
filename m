Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63527 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab2CGHXH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 02:23:07 -0500
Received: by wibhm2 with SMTP id hm2so3150371wib.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Mar 2012 23:23:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACna6rwCbwW4iaZ8HRVo_Hrfk_Z+q-E7ad=i9f0C=pF=-zHeEQ@mail.gmail.com>
References: <1331071898-3651-1-git-send-email-zajec5@gmail.com>
	<4F5695CC.3010206@hauke-m.de>
	<CACna6rwCbwW4iaZ8HRVo_Hrfk_Z+q-E7ad=i9f0C=pF=-zHeEQ@mail.gmail.com>
Date: Wed, 7 Mar 2012 08:23:05 +0100
Message-ID: <CACna6rxq5XHjB=21iaNWADMZOUativUe1DQOAb_SGPST7nhcCg@mail.gmail.com> (sfid-20120307_082311_934220_FA5B067C)
Subject: Re: [RFT][PATCH] b43: fix logic in GPIO configuration
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, larry.finger@lwfinger.net,
	florian@openwrt.org, m@bues.ch
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 7 marca 2012 07:52 użytkownik Rafał Miłecki <zajec5@gmail.com> napisał:
> W dniu 6 marca 2012 23:55 użytkownik Hauke Mehrtens <hauke@hauke-m.de> napisał:
>> On 03/06/2012 11:11 PM, Rafał Miłecki wrote:
>>> By using reverted mask we were taking over pins we were not supporsed to
>>> touch. After fixing this workaround for BCM5354 should not be needed
>>> anymore.
>>>
>>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>>> ---
>>>  drivers/net/wireless/b43/main.c |    6 ++----
>>>  1 files changed, 2 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
>>> index 1d633f3..8a89885 100644
>>> --- a/drivers/net/wireless/b43/main.c
>>> +++ b/drivers/net/wireless/b43/main.c
>>> @@ -2706,8 +2706,6 @@ static int b43_gpio_init(struct b43_wldev *dev)
>>>               mask |= 0x0060;
>>>               set |= 0x0060;
>>>       }
>>> -     if (dev->dev->chip_id == 0x5354)
>>> -             set &= 0xff02;
>>>       if (0 /* FIXME: conditional unknown */ ) {
>>>               b43_write16(dev, B43_MMIO_GPIO_MASK,
>>>                           b43_read16(dev, B43_MMIO_GPIO_MASK)
>>> @@ -2730,7 +2728,7 @@ static int b43_gpio_init(struct b43_wldev *dev)
>>>       case B43_BUS_BCMA:
>>>               bcma_cc_write32(&dev->dev->bdev->bus->drv_cc, BCMA_CC_GPIOCTL,
>>>                               (bcma_cc_read32(&dev->dev->bdev->bus->drv_cc,
>>> -                                     BCMA_CC_GPIOCTL) & mask) | set);
>>> +                                     BCMA_CC_GPIOCTL) & ~mask) | set);
>>>               break;
>>>  #endif
>>>  #ifdef CONFIG_B43_SSB
>>> @@ -2739,7 +2737,7 @@ static int b43_gpio_init(struct b43_wldev *dev)
>>>               if (gpiodev)
>>>                       ssb_write32(gpiodev, B43_GPIO_CONTROL,
>>>                                   (ssb_read32(gpiodev, B43_GPIO_CONTROL)
>>> -                                 & mask) | set);
>>> +                                 & ~mask) | set);
>>>               break;
>>>  #endif
>>>       }
>>
>> Hi,
>>
>> This patch did not helped fixing my problem. The ucode still takes over
>> the GPIOs of the buttons with firmware version 666.2. I am getting the
>> following messages:
>>
>> [   83.620000] b43-phy0: Loading firmware version 666.2 (2011-02-23
>> 01:15:07)
>> [   83.624000] Init value of B43_GPIO_CONTROL: 0x0
>> [   83.632000] b43-phy0 debug: b2062: Using crystal tab entry 19200 kHz.
>> [   83.640000] hotplug_button: action: pressed, name: reset, seen: 17179652
>> [   83.644000] hotplug_button: action: pressed, name: ses, seen: 17179652
>> [   89.404000] b43-phy0 debug: Chip initialized
>
> Interesting/weird. I suspected there are some bits set in
> B43_GPIO_CONTROL we should not clean. And you just adjusted "set" to
> keep them set. But now it seems B43_GPIO_CONTROL is *zero* at the
> beginning and we actually have to *set* 0xFF00 to stop firmware
> touching them? Really tricky, I didn't suspect we may need to change
> default state of non-b43-related GPIOs.

Ahh, sorry. For all the time I believed the code you added was:
set |= 0xff02;

However the code you *really* added is:
set &= 0xff02;

Sorry for messing. OK, let's short analyze that. By default we set "set" to:
set = 0x0000000F;
so you code basically makes it
set = 0x00000002;

0x2 (BIT 1) is wlan led on your device. So you let firmware use wlan
led, but you stop it from touching power led (0x1), reset button (0x4)
and ses button (0x8). OK, it makes sense.

In the brcm80211 code there was unused si_gpioreserve function. I
guess it used to be called in some way like:
if (dev->dev->chip_id == 0x5354)
si_gpioreserve(sih, 0x2, 1+)

-- 
Rafał
