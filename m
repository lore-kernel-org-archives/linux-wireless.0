Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:17105 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754622AbdBPNIb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Feb 2017 08:08:31 -0500
Date: Thu, 16 Feb 2017 21:08:25 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kbuild-all@01.org,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Philip Li <philip.li@intel.com>
Subject: Re: [kbuild-all]
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c:58:6: error:
 redefinition of 'brcmf_debugfs_init'
Message-ID: <20170216130825.zj3cx4v7o3n5m7jl@wfg-t540p.sh.intel.com> (sfid-20170216_140903_559061_2E359DA6)
References: <201702071839.Ej9MjmlI%fengguang.wu@intel.com>
 <ce7467a9-12d5-f64e-8b59-f9581db9f7c8@infradead.org>
 <87inoamqh6.fsf@kamboji.qca.qualcomm.com>
 <e8c43505-1e7a-635c-dc27-45422acb25a6@milecki.pl>
 <59013c13-af43-cf9f-8e3e-14d97e48f0dd@broadcom.com>
 <87efyymp2q.fsf@kamboji.qca.qualcomm.com>
 <8ff44e41-97c7-4ae5-6850-65ad407fd788@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
In-Reply-To: <8ff44e41-97c7-4ae5-6850-65ad407fd788@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Yes sorry, it's a false report related to how we do bisects.

>>>>>> CONFIG_BRCM_TRACING=y
>>>>>> CONFIG_BRCMDBG=y
>>>>>>
>>>>>> but DEBUG is not defined.
>>>>>>
>>>>>> I think it would help if CONFIG_BRCMDBG set DEBUG
>>>>>> or if some of the tests for DEBUG used CONFIG_BRCMDBG instead.
>>>>>
>>>>> Arend or Rafał, would you be able to look at this build problem? Kbuild
>>>>> found the build errors below, apparently a very old issue. It just
>>>>> blames me now because I moved the driver to a new directory :)
>>>
>>> It is a very old issue. The thing is that the issue can not really occur
>>> because we have this:
>>>
>>> # common flags
>>> subdir-ccflags-$(CONFIG_BRCMDBG)        += -DDEBUG
>>>
>>> in drivers/net/wireless/broadcom/brcm80211/Makefile. So no clue what
>>> happens in the "kbuild test robot" scenario.

As an optimization, the robot often does "partial builds" during bisects.
For example, when the error is found in

        drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c

It'll try

        make drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.o

And verify the bisect result with

        make drivers/net/wireless/broadcom/brcm80211/brcmfmac/

However in this case the whole dir is moved, so both logics failed to
give correct results. We'll check how to improve this. Sorry for the
confusions!

>> I actually tried to reproduce this with kbuild bot's instructions and
>> was surprised to see that the build worked ok for me. So the issue is
>> not that simple.
>
>Hi Kalle,
>
>Here is the old email exchange we had about this [1]. In my opinion this
>is a Kbuild issue that needs to be looked into.
>
>Regards,
>Arend
>
>[1] http://www.spinics.net/lists/linux-wireless/msg142122.html

Thanks,
Fengguang
