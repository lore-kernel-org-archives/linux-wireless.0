Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:26683 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754761AbdBQBpQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Feb 2017 20:45:16 -0500
Date: Fri, 17 Feb 2017 09:45:11 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kbuild-all@01.org,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [kbuild-all]
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c:58:6: error:
 redefinition of 'brcmf_debugfs_init'
Message-ID: <20170217014511.vmjvote5mkgcmm2w@wfg-t540p.sh.intel.com> (sfid-20170217_024541_343895_4B04ADEA)
References: <201702071839.Ej9MjmlI%fengguang.wu@intel.com>
 <ce7467a9-12d5-f64e-8b59-f9581db9f7c8@infradead.org>
 <87inoamqh6.fsf@kamboji.qca.qualcomm.com>
 <e8c43505-1e7a-635c-dc27-45422acb25a6@milecki.pl>
 <59013c13-af43-cf9f-8e3e-14d97e48f0dd@broadcom.com>
 <87efyymp2q.fsf@kamboji.qca.qualcomm.com>
 <8ff44e41-97c7-4ae5-6850-65ad407fd788@broadcom.com>
 <8737fe46kn.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
In-Reply-To: <8737fe46kn.fsf@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Thu, Feb 16, 2017 at 03:18:48PM +0200, Kalle Valo wrote:
>Arend Van Spriel <arend.vanspriel@broadcom.com> writes:
>
>> On 16-2-2017 11:01, Kalle Valo wrote:
>>> Arend Van Spriel <arend.vanspriel@broadcom.com> writes:
>>>
>>>> On 16-2-2017 10:39, Rafał Miłecki wrote:
>>>>> On 02/16/2017 10:31 AM, Kalle Valo wrote:
>>>>>> (Adding linux-wireless)
>>>>>>
>>>>>> Arend or Rafał, would you be able to look at this build problem? Kbuild
>>>>>> found the build errors below, apparently a very old issue. It just
>>>>>> blames me now because I moved the driver to a new directory :)
>>>>
>>>> It is a very old issue. The thing is that the issue can not really occur
>>>> because we have this:
>>>>
>>>> # common flags
>>>> subdir-ccflags-$(CONFIG_BRCMDBG)        += -DDEBUG
>>>>
>>>> in drivers/net/wireless/broadcom/brcm80211/Makefile. So no clue what
>>>> happens in the "kbuild test robot" scenario.
>>>
>>> I actually tried to reproduce this with kbuild bot's instructions and
>>> was surprised to see that the build worked ok for me. So the issue is
>>> not that simple.
>>
>> Hi Kalle,
>>
>> Here is the old email exchange we had about this [1]. In my opinion this
>> is a Kbuild issue that needs to be looked into.
>>
>> Regards,
>> Arend
>>
>> [1] http://www.spinics.net/lists/linux-wireless/msg142122.html
>
>Heh, I had completely forgotten that we had discussed this before :)
>
>Fengguang and the kbuild bot team, do you have any ideas why only the
>bot is seeing this?

I guess the root cause is due to the robot's doing partial builds like
these

        make drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.o
        make drivers/net/wireless/broadcom/brcm80211/brcmfmac/

The solution I come about is to climb up to higher level dirs like 

        make drivers/net/wireless/

which is less likely to have Makefile tricks and still maintain fast
enough build tests.

Thanks,
Fengguang
