Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:17895 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbbJLUFl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 16:05:41 -0400
Message-ID: <561C1291.8060607@broadcom.com> (sfid-20151012_220544_270914_3613C820)
Date: Mon, 12 Oct 2015 22:05:37 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: kbuild test robot <lkp@intel.com>, <kbuild-all@01.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 01/11] brcmfmac: expose device memory to devcoredump subsystem
References: <201510090203.zZSsJ7qb%fengguang.wu@intel.com> <87wpuspilw.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87wpuspilw.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/12/2015 10:59 AM, Kalle Valo wrote:
> kbuild test robot <lkp@intel.com> writes:
>
>> Hi Arend,
>>
>> [auto build test ERROR on next-20151008 -- if it's inappropriate base, please ignore]
>>
>> config: x86_64-randconfig-x011-201540 (attached as .config)
>> reproduce:
>>          # save the attached .config to linux build tree
>>          make ARCH=x86_64
>>
>> All errors (new ones prefixed by >>):
>>
>>     drivers/net/wireless/brcm80211/brcmfmac/debug.c:58:6: error: redefinition of 'brcmf_debugfs_init'
>>      void brcmf_debugfs_init(void)
>>           ^
>>     In file included from drivers/net/wireless/brcm80211/brcmfmac/bus.h:20:0,
>>                      from drivers/net/wireless/brcm80211/brcmfmac/debug.c:24:
>>     drivers/net/wireless/brcm80211/brcmfmac/debug.h:118:20: note: previous definition of 'brcmf_debugfs_init' was here
>>      static inline void brcmf_debugfs_init(void)
>>                         ^
>
> Arend, are the kbuild errors valid? I would guess they are as
> wireless-drivers-next should be in linux-next.

Hi Kalle,

Actually they are not. I am not sure about the build infrastructure, but 
the errors above can only occur when CONFIG_BRCMDBG is set, but DEBUG is 
not. However, that can not happen as we have following line in 
drivers/net/wireless/brcm80211/Makefile:

subdir-ccflags-$(CONFIG_BRCMDBG)	+= -DDEBUG

Regards,
Arend

