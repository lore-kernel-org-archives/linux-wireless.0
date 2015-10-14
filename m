Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39258 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbbJNLBt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 07:01:49 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: kbuild test robot <lkp@intel.com>, <kbuild-all@01.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 01/11] brcmfmac: expose device memory to devcoredump subsystem
References: <201510090203.zZSsJ7qb%fengguang.wu@intel.com>
	<87wpuspilw.fsf@kamboji.qca.qualcomm.com>
	<561C1291.8060607@broadcom.com>
Date: Wed, 14 Oct 2015 14:01:43 +0300
In-Reply-To: <561C1291.8060607@broadcom.com> (Arend van Spriel's message of
	"Mon, 12 Oct 2015 22:05:37 +0200")
Message-ID: <87lhb5n27c.fsf@kamboji.qca.qualcomm.com> (sfid-20151014_130152_462457_4B2B9E4C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> On 10/12/2015 10:59 AM, Kalle Valo wrote:
>> kbuild test robot <lkp@intel.com> writes:
>>
>>> Hi Arend,
>>>
>>> [auto build test ERROR on next-20151008 -- if it's inappropriate base, please ignore]
>>>
>>> config: x86_64-randconfig-x011-201540 (attached as .config)
>>> reproduce:
>>>          # save the attached .config to linux build tree
>>>          make ARCH=x86_64
>>>
>>> All errors (new ones prefixed by >>):
>>>
>>>     drivers/net/wireless/brcm80211/brcmfmac/debug.c:58:6: error: redefinition of 'brcmf_debugfs_init'
>>>      void brcmf_debugfs_init(void)
>>>           ^
>>>     In file included from drivers/net/wireless/brcm80211/brcmfmac/bus.h:20:0,
>>>                      from drivers/net/wireless/brcm80211/brcmfmac/debug.c:24:
>>>     drivers/net/wireless/brcm80211/brcmfmac/debug.h:118:20: note: previous definition of 'brcmf_debugfs_init' was here
>>>      static inline void brcmf_debugfs_init(void)
>>>                         ^
>>
>> Arend, are the kbuild errors valid? I would guess they are as
>> wireless-drivers-next should be in linux-next.
>
> Actually they are not. I am not sure about the build infrastructure,
> but the errors above can only occur when CONFIG_BRCMDBG is set, but
> DEBUG is not. However, that can not happen as we have following line
> in drivers/net/wireless/brcm80211/Makefile:
>
> subdir-ccflags-$(CONFIG_BRCMDBG)	+= -DDEBUG

I didn't check the details but I'm still not convinced :) In my opinion
the code should always compile, with and without -DDEBUG. Anyways, I
pushed this script to the pending branch to get kbuild test this patch
once again.

-- 
Kalle Valo
