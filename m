Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42548 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755531Ab3GWVgj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jul 2013 17:36:39 -0400
Message-ID: <51EEF75F.9060203@hauke-m.de> (sfid-20130723_233642_807042_ECEB3596)
Date: Tue, 23 Jul 2013 23:36:31 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Make BCMA_HOST_SOC depend on BCM47XX
References: <1374546675-384-1-git-send-email-linville@tuxdriver.com> <51EE3018.4000507@hauke-m.de> <CACna6rwU6-jC_cnU=vGv2u2D11aUCKNZN-YOuM9GYt_R9E79oA@mail.gmail.com> <CAGVrzcZfxei-p12+TDcJNg3TGSuJKfL3NvxvtWSfKEkxkZmYXw@mail.gmail.com>
In-Reply-To: <CAGVrzcZfxei-p12+TDcJNg3TGSuJKfL3NvxvtWSfKEkxkZmYXw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/23/2013 01:06 PM, Florian Fainelli wrote:
> 2013/7/23 Rafał Miłecki <zajec5@gmail.com>:
>> 2013/7/23 Hauke Mehrtens <hauke@hauke-m.de>:
>>> On 07/23/2013 04:31 AM, John W. Linville wrote:
>>>> From: "John W. Linville" <linville@tuxdriver.com>
>>>>
>>>> Otherwise, 'make allyesconfig' generates this:
>>>>
>>>>   CC [M]  drivers/net/ethernet/broadcom/bgmac.o
>>>> drivers/net/ethernet/broadcom/bgmac.c:19:27: fatal error:
>>>> bcm47xx_nvram.h: No such file or directory
>>>> compilation terminated.
>>>> make[4]: *** [drivers/net/ethernet/broadcom/bgmac.o] Error 1
>>>> make[3]: *** [drivers/net/ethernet/broadcom] Error 2
>>>> make[2]: *** [drivers/net/ethernet] Error 2
>>>> make[1]: *** [drivers/net] Error 2
>>>> make: *** [drivers] Error 2
>>>>
>>>> Signed-off-by: John W. Linville <linville@tuxdriver.com>
>>>> ---
>>>>  drivers/bcma/Kconfig | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
>>>> index 7c081b3..a2bdab1 100644
>>>> --- a/drivers/bcma/Kconfig
>>>> +++ b/drivers/bcma/Kconfig
>>>> @@ -36,7 +36,7 @@ config BCMA_DRIVER_PCI_HOSTMODE
>>>>
>>>>  config BCMA_HOST_SOC
>>>>       bool "Support for BCMA in a SoC"
>>>> -     depends on BCMA
>>>> +     depends on BCMA && BCM47XX
>>>>       help
>>>>         Host interface for a Broadcom AIX bus directly mapped into
>>>>         the memory. This only works with the Broadcom SoCs from the
>>>>
>>> I think bgmac should depend on BCM47XX.
>>
>> Yeah, I'm wondering about that.
>>
>> It's bgmac that calls BCM47XX specific functions (nvram).
> 
> And this is bad, make that a platform_data callback or something like
> that such that there is no build-time dependency on nvram functions.

Ok, I will try that. I still have no idea how to handle the nvram stuff
properly with DT on arm. My current plan is to do this stuff properly
for arm and try to use most of the improvements also for mips.

>> On the other hand it doesn't make much sense to use BCMA_HOST_SOC on
>> anything else than BCM47XX, does it?
> 
> Hauke has been working on BCM53XX which is an ARM-based BCM47XX-like
> SoC, but that just means depends on (BCM47XX || ARCH_BCM53XX) then.

Yes preparing for adding arm support was the intention of this patch
series, it was some code which should not harm the mips part or any other.

Hauke
