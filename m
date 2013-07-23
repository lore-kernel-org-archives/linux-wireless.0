Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:55714 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048Ab3GWLGp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jul 2013 07:06:45 -0400
Received: by mail-pa0-f43.google.com with SMTP id hz11so8197631pad.30
        for <linux-wireless@vger.kernel.org>; Tue, 23 Jul 2013 04:06:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rwU6-jC_cnU=vGv2u2D11aUCKNZN-YOuM9GYt_R9E79oA@mail.gmail.com>
References: <1374546675-384-1-git-send-email-linville@tuxdriver.com>
 <51EE3018.4000507@hauke-m.de> <CACna6rwU6-jC_cnU=vGv2u2D11aUCKNZN-YOuM9GYt_R9E79oA@mail.gmail.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Tue, 23 Jul 2013 12:06:04 +0100
Message-ID: <CAGVrzcZfxei-p12+TDcJNg3TGSuJKfL3NvxvtWSfKEkxkZmYXw@mail.gmail.com> (sfid-20130723_130648_429897_526DEB9D)
Subject: Re: [PATCH] Make BCMA_HOST_SOC depend on BCM47XX
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/7/23 Rafał Miłecki <zajec5@gmail.com>:
> 2013/7/23 Hauke Mehrtens <hauke@hauke-m.de>:
>> On 07/23/2013 04:31 AM, John W. Linville wrote:
>>> From: "John W. Linville" <linville@tuxdriver.com>
>>>
>>> Otherwise, 'make allyesconfig' generates this:
>>>
>>>   CC [M]  drivers/net/ethernet/broadcom/bgmac.o
>>> drivers/net/ethernet/broadcom/bgmac.c:19:27: fatal error:
>>> bcm47xx_nvram.h: No such file or directory
>>> compilation terminated.
>>> make[4]: *** [drivers/net/ethernet/broadcom/bgmac.o] Error 1
>>> make[3]: *** [drivers/net/ethernet/broadcom] Error 2
>>> make[2]: *** [drivers/net/ethernet] Error 2
>>> make[1]: *** [drivers/net] Error 2
>>> make: *** [drivers] Error 2
>>>
>>> Signed-off-by: John W. Linville <linville@tuxdriver.com>
>>> ---
>>>  drivers/bcma/Kconfig | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
>>> index 7c081b3..a2bdab1 100644
>>> --- a/drivers/bcma/Kconfig
>>> +++ b/drivers/bcma/Kconfig
>>> @@ -36,7 +36,7 @@ config BCMA_DRIVER_PCI_HOSTMODE
>>>
>>>  config BCMA_HOST_SOC
>>>       bool "Support for BCMA in a SoC"
>>> -     depends on BCMA
>>> +     depends on BCMA && BCM47XX
>>>       help
>>>         Host interface for a Broadcom AIX bus directly mapped into
>>>         the memory. This only works with the Broadcom SoCs from the
>>>
>> I think bgmac should depend on BCM47XX.
>
> Yeah, I'm wondering about that.
>
> It's bgmac that calls BCM47XX specific functions (nvram).

And this is bad, make that a platform_data callback or something like
that such that there is no build-time dependency on nvram functions.

>
> On the other hand it doesn't make much sense to use BCMA_HOST_SOC on
> anything else than BCM47XX, does it?

Hauke has been working on BCM53XX which is an ARM-based BCM47XX-like
SoC, but that just means depends on (BCM47XX || ARCH_BCM53XX) then.
--
Florian
