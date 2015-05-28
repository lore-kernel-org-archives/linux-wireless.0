Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:23970 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbbE1VYa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 17:24:30 -0400
Message-ID: <55678789.60802@broadcom.com> (sfid-20150528_232433_451515_E931CCF5)
Date: Thu, 28 May 2015 23:24:25 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Subject: Re: [PATCH] brcmfmac: use direct data pointer in NVRAM parser struct
References: <1432813063-30922-1-git-send-email-zajec5@gmail.com>	<556701E9.8090807@broadcom.com> <CACna6rwm5L1tSd7S=9PNKnju-sxHxhYPbA0EcdJ5K=MwJzJvUA@mail.gmail.com>
In-Reply-To: <CACna6rwm5L1tSd7S=9PNKnju-sxHxhYPbA0EcdJ5K=MwJzJvUA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/28/15 14:34, Rafał Miłecki wrote:
> On 28 May 2015 at 13:54, Arend van Spriel<arend@broadcom.com>  wrote:
>> On 05/28/15 13:37, Rafał Miłecki wrote:
>>>
>>> As we plan to add support for platform NVRAM we should store direct
>>> data pointer without the extra struct firmware layer. This will allow
>>> us to support other sources with the only requirement being u8 buffer.
>>>
>>> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
>>> Signed-off-by: Hante Meuleman<meuleman@broadcom.com>
>>> Signed-off-by: Arend van Spriel<arend@broadcom.com>
>>> ---
>>> Tested on router with BCM43602-s using
>>> /lib/firmware/brcm/brcmfmac43602-pcie.txt
>>>
>>> I've written this patch from scratch, it's inspired by the dropped:
>>> [PATCH 6/6] brcmfmac: Add support for host platform NVRAM loading.
>>
>>
>> Hi Rafał,
>>
>> So what is your goal here. The inspirational patch was dropped so it can be
>> resubmitted when the mips change it relies on has made its way upstream. So
>> I have to rebase the patch over here and your patch will just give me
>> conflicts during that rebase. So can we please wait or do you need this
>> change right now.
>
> The dropped patch will require rebasing/rewriting anyway. There were
> few changes to firmware.c already, I've few more planned, you'll have
> to drop some code form your patch (parts that will go into MIPS tree)
> and probably apply few changes as requested in comments.

I already did that and submitted the mips part to Ralf. I am sorry to 
say this but what annoys me is that since then you started submitting 
patches that seem to be taken from the dropped patch. So I have a 
problem seeing the bright side. If Ralf takes the mips part it ends up 
in linux-next and we can submit the brcmfmac part.

Regards,
Arend

> I also don't think it makes much sense to pause any development
> because of having some out-of-tree patch queued for later submitting.
>
> And after all, hey, look at the bright side! :) With this patch you'll
> have to maintain smaller amount of out-of-tree(-for-now) code :)
>
> So my goals are:
> 1) Have all required cleanups pushed mainline early.
> 2) Make it easier to main out-of-tree changes.
> The personal reason behind that is to add OpenWrt support for BCM43602
> as early as possible. Having clean backports + tiny NVRAM patch make
> it much easier to do now, maintain and update in the future.

