Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:64546 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbbJNNgY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 09:36:24 -0400
Message-ID: <561E5A55.5070607@broadcom.com> (sfid-20151014_153629_103055_A9E9557A)
Date: Wed, 14 Oct 2015 15:36:21 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: kbuild test robot <lkp@intel.com>, <kbuild-all@01.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 01/11] brcmfmac: expose device memory to devcoredump subsystem
References: <201510090203.zZSsJ7qb%fengguang.wu@intel.com>	<87wpuspilw.fsf@kamboji.qca.qualcomm.com>	<561C1291.8060607@broadcom.com> <87lhb5n27c.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87lhb5n27c.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/14/2015 01:01 PM, Kalle Valo wrote:
> Arend van Spriel <arend@broadcom.com> writes:
>
>> On 10/12/2015 10:59 AM, Kalle Valo wrote:
>>> kbuild test robot <lkp@intel.com> writes:
>>>
>>>> Hi Arend,
>>>>
>>>> [auto build test ERROR on next-20151008 -- if it's inappropriate base, please ignore]
>>>>
>>>> config: x86_64-randconfig-x011-201540 (attached as .config)
>>>> reproduce:
>>>>           # save the attached .config to linux build tree
>>>>           make ARCH=x86_64
>>>>
>>>> All errors (new ones prefixed by >>):
>>>>
>>>>      drivers/net/wireless/brcm80211/brcmfmac/debug.c:58:6: error: redefinition of 'brcmf_debugfs_init'
>>>>       void brcmf_debugfs_init(void)
>>>>            ^
>>>>      In file included from drivers/net/wireless/brcm80211/brcmfmac/bus.h:20:0,
>>>>                       from drivers/net/wireless/brcm80211/brcmfmac/debug.c:24:
>>>>      drivers/net/wireless/brcm80211/brcmfmac/debug.h:118:20: note: previous definition of 'brcmf_debugfs_init' was here
>>>>       static inline void brcmf_debugfs_init(void)
>>>>                          ^
>>>
>>> Arend, are the kbuild errors valid? I would guess they are as
>>> wireless-drivers-next should be in linux-next.
>>
>> Actually they are not. I am not sure about the build infrastructure,
>> but the errors above can only occur when CONFIG_BRCMDBG is set, but
>> DEBUG is not. However, that can not happen as we have following line
>> in drivers/net/wireless/brcm80211/Makefile:
>>
>> subdir-ccflags-$(CONFIG_BRCMDBG)	+= -DDEBUG
>
> I didn't check the details but I'm still not convinced :) In my opinion
> the code should always compile, with and without -DDEBUG. Anyways, I
> pushed this script to the pending branch to get kbuild test this patch
> once again.

Ok, Kalle

Let me try to be a bit more convincing ;-)

I checked out linux-next/master, taken the provided .config and ran:

$ make prepare
$ make M=scripts
$ make M=drivers/net/wireless/brcm80211

   WARNING: Symbol version dump ./Module.symvers
            is missing; modules will have no dependencies and modversions.

   CC      drivers/net/wireless/brcm80211/brcmfmac/cfg80211.o
   CC      drivers/net/wireless/brcm80211/brcmfmac/chip.o
   CC      drivers/net/wireless/brcm80211/brcmfmac/fwil.o
   CC      drivers/net/wireless/brcm80211/brcmfmac/fweh.o
   CC      drivers/net/wireless/brcm80211/brcmfmac/fwsignal.o
   CC      drivers/net/wireless/brcm80211/brcmfmac/p2p.o
   CC      drivers/net/wireless/brcm80211/brcmfmac/proto.o
   CC      drivers/net/wireless/brcm80211/brcmfmac/common.o
   CC      drivers/net/wireless/brcm80211/brcmfmac/core.o
   CC      drivers/net/wireless/brcm80211/brcmfmac/firmware.o
   CC      drivers/net/wireless/brcm80211/brcmfmac/feature.o
   CC      drivers/net/wireless/brcm80211/brcmfmac/btcoex.o
   CC      drivers/net/wireless/brcm80211/brcmfmac/vendor.o
   CC      drivers/net/wireless/brcm80211/brcmfmac/bcdc.o
   CC      drivers/net/wireless/brcm80211/brcmfmac/sdio.o
   CC      drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.o
   CC      drivers/net/wireless/brcm80211/brcmfmac/debug.o
   CC      drivers/net/wireless/brcm80211/brcmfmac/tracepoint.o
   CC      drivers/net/wireless/brcm80211/brcmfmac/of.o
   LD      drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.o
   LD      drivers/net/wireless/brcm80211/brcmfmac/built-in.o
   CC      drivers/net/wireless/brcm80211/brcmutil/utils.o
   CC      drivers/net/wireless/brcm80211/brcmutil/d11.o
   LD      drivers/net/wireless/brcm80211/brcmutil/brcmutil.o
   LD      drivers/net/wireless/brcm80211/brcmutil/built-in.o
   LD      drivers/net/wireless/brcm80211/built-in.o
   Building modules, stage 2.
   MODPOST 0 modules

No compile issues.

Regards,
Arend
