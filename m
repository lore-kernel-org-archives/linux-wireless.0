Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39328 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbbJOKGu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 06:06:50 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: kbuild test robot <lkp@intel.com>, <kbuild-all@01.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 01/11] brcmfmac: expose device memory to devcoredump subsystem
References: <201510090203.zZSsJ7qb%fengguang.wu@intel.com>
	<87wpuspilw.fsf@kamboji.qca.qualcomm.com>
	<561C1291.8060607@broadcom.com>
	<87lhb5n27c.fsf@kamboji.qca.qualcomm.com>
	<561E5A55.5070607@broadcom.com>
Date: Thu, 15 Oct 2015 13:06:40 +0300
In-Reply-To: <561E5A55.5070607@broadcom.com> (Arend van Spriel's message of
	"Wed, 14 Oct 2015 15:36:21 +0200")
Message-ID: <874mhsjvin.fsf@kamboji.qca.qualcomm.com> (sfid-20151015_120654_140863_5B0BFDA7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> On 10/14/2015 01:01 PM, Kalle Valo wrote:
>> Arend van Spriel <arend@broadcom.com> writes:
>>
>>> On 10/12/2015 10:59 AM, Kalle Valo wrote:
>>>
>>>> Arend, are the kbuild errors valid? I would guess they are as
>>>> wireless-drivers-next should be in linux-next.
>>>
>>> Actually they are not. I am not sure about the build infrastructure,
>>> but the errors above can only occur when CONFIG_BRCMDBG is set, but
>>> DEBUG is not. However, that can not happen as we have following line
>>> in drivers/net/wireless/brcm80211/Makefile:
>>>
>>> subdir-ccflags-$(CONFIG_BRCMDBG)	+= -DDEBUG
>>
>> I didn't check the details but I'm still not convinced :) In my opinion
>> the code should always compile, with and without -DDEBUG. Anyways, I
>> pushed this script to the pending branch to get kbuild test this patch
>> once again.
>
> Ok, Kalle
>
> Let me try to be a bit more convincing ;-)
>
> I checked out linux-next/master, taken the provided .config and ran:
>
> $ make prepare
> $ make M=scripts
> $ make M=drivers/net/wireless/brcm80211

Thanks, I'm convinced now :) But the kbuild found this warning (I guess
you also got an email about that):

drivers/net/wireless/brcm80211/brcmfmac/sdio.c:3562:2: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'unsigned int' [-Wformat=]

Can you fix that and respin, please?

-- 
Kalle Valo
