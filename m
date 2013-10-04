Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f175.google.com ([209.85.128.175]:39504 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab3JDLLk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Oct 2013 07:11:40 -0400
Received: by mail-ve0-f175.google.com with SMTP id jy13so2348629veb.20
        for <linux-wireless@vger.kernel.org>; Fri, 04 Oct 2013 04:11:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFSJ42Ydrput-ojxtf0unZj13euZHCePZByN=AB3HemY-XgTMw@mail.gmail.com>
References: <1380234106-12802-1-git-send-email-k.eugene.e@gmail.com>
	<CAFSJ42bybEGtkzJ99fZHrcPs=gTnvJVHxM7d8anJvn1VOs7V7A@mail.gmail.com>
	<20131003205710.GH3142@tuxdriver.com>
	<CAFSJ42ZwJzd46UXE2crzuaMVRLzre9SVm_vFcQ-KAVY6Q9c3QQ@mail.gmail.com>
	<524E72B7.5000102@broadcom.com>
	<CAFSJ42Ydrput-ojxtf0unZj13euZHCePZByN=AB3HemY-XgTMw@mail.gmail.com>
Date: Fri, 4 Oct 2013 12:11:38 +0100
Message-ID: <CAFSJ42Y+1=yvBpC7+H49FgPSdqcu0YJo8kw4h67_zXOMQ-GYpA@mail.gmail.com> (sfid-20131004_131152_076923_2EE5CA3D)
Subject: Re: [PATCH] wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Sorry for inconvenience!
I managed to reproduce this error, will fix and send a new patch later on today.

2013/10/4 Eugene Krasnikov <k.eugene.e@gmail.com>:
> Hi Arend,
>
> Yes, i am building it as a module. Let me try to build it into the
> kernel, may be that is the reason why build fails.
>
> 2013/10/4 Arend van Spriel <arend@broadcom.com>:
>> On 10/03/2013 11:22 PM, Eugene Krasnikov wrote:
>>>
>>> Hm, weird... do not see this problem myself. Let me try to sync latest
>>> wireless-next and will try to apply latest patch from this mailthread
>>> on top.
>>
>>
>> Hi Eugene,
>>
>> Do you build the driver as module. John is building it built-in then kernel.
>>
>> Gr. AvS
>>
>>
>>> P.S. If somebody esle can try to apply this patch and build that would
>>> be useful to know if problem is visible on others PCs as well.
>>>
>>> 2013/10/3 John W. Linville <linville@tuxdriver.com>:
>>>>
>>>> On Thu, Sep 26, 2013 at 11:25:18PM +0100, Eugene Krasnikov wrote:
>>>>>
>>>>> Hi John,
>>>>>
>>>>> This is the latest version of wcn36xx driver on top of current
>>>>> wireless-next tree. Please let me know if you have any problems with
>>>>> applying it.
>>>>>
>>>>> 2013/9/26 Eugene Krasnikov <k.eugene.e@gmail.com>:
>>>>>>
>>>>>> This is a mac80211 driver for Qualcomm WCN3660/WCN3680 devices. So
>>>>>> far WCN3660/WCN3680 is available only on MSM platform.
>>>>>>
>>>>>> Firmware can be found here:
>>>>>>
>>>>>> https://www.codeaurora.org/cgit/external/hisense/platform/vendor/qcom-opensource/wlan/prima/tree/firmware_bin?h=8130_CS
>>>>>>
>>>>>> Wiki page is available here:
>>>>>> http://wireless.kernel.org/en/users/Drivers/wcn36xx
>>>>>>
>>>>>> A lot people made a contribution to this driver. Here is the list in
>>>>>> alphabetical order:
>>>>>>
>>>>>> Eugene Krasnikov <k.eugene.e@gmail.com>
>>>>>> Kalle Valo <kvalo@qca.qualcomm.com>
>>>>>> Olof Johansson <dev@skyshaper.net>
>>>>>> Pontus Fuchs <pontus.fuchs@gmail.com>
>>>>>> Yanbo Li <yanbol@qti.qualcomm.com>
>>>>>>
>>>>>> Signed-off-by: Eugene Krasnikov <k.eugene.e@gmail.com>
>>>>
>>>>
>>>> 'make allyesconfig' yield this:
>>>>
>>>>    LD      drivers/net/wireless/ath/ath.o
>>>>    LD      drivers/net/wireless/ath/built-in.o
>>>> drivers/net/wireless/ath/wcn36xx/built-in.o: In function
>>>> `_GLOBAL__sub_I_65535_0_wcn36xx_set_default_rates':
>>>>
>>>> /home/linville/git/wireless-next/drivers/net/wireless/ath/wcn36xx/main.c:302:
>>>> multiple definition of `debug_mask'
>>>>
>>>> drivers/net/wireless/ath/ath6kl/built-in.o:/home/linville/git/wireless-next/drivers/net/wireless/ath/ath6kl/cfg80211.c:1208:
>>>> first defined here
>>>> make[2]: *** [drivers/net/wireless/ath/built-in.o] Error 1
>>>> make[1]: *** [drivers/net/wireless/ath] Error 2
>>>> make: *** [drivers/net/wireless/] Error 2
>>>>
>>>> --
>>>> John W. Linville                Someday the world will need a hero, and
>>>> you
>>>> linville@tuxdriver.com                  might be all we have.  Be ready.
>>>
>>>
>>>
>>>
>>
>>
>
>
>
> --
> Best regards,
> Eugene



-- 
Best regards,
Eugene
