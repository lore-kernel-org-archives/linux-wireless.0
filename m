Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:36238 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030191AbbE2P6U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2015 11:58:20 -0400
Received: by iepj10 with SMTP id j10so65895588iep.3
        for <linux-wireless@vger.kernel.org>; Fri, 29 May 2015 08:58:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55681D51.1070503@broadcom.com>
References: <1432813063-30922-1-git-send-email-zajec5@gmail.com>
	<556701E9.8090807@broadcom.com>
	<CACna6rwm5L1tSd7S=9PNKnju-sxHxhYPbA0EcdJ5K=MwJzJvUA@mail.gmail.com>
	<55678789.60802@broadcom.com>
	<CACna6rz=jrkFDkePMvPNRk_X4UwxdwGecGxtdynXgpJCkN-0FA@mail.gmail.com>
	<55681D51.1070503@broadcom.com>
Date: Fri, 29 May 2015 17:58:19 +0200
Message-ID: <CACna6rzqc910-ZX15SXZajf6gPgjakDO9_yWDuBzc1sfWvd+PA@mail.gmail.com> (sfid-20150529_175829_875064_1E32C8E3)
Subject: Re: [PATCH] brcmfmac: use direct data pointer in NVRAM parser struct
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 May 2015 at 10:03, Arend van Spriel <arend@broadcom.com> wrote:
> On 05/29/15 07:20, Rafał Miłecki wrote:
>> On 28 May 2015 at 23:24, Arend van Spriel<arend@broadcom.com>  wrote:
>>> On 05/28/15 14:34, Rafał Miłecki wrote:
>>>> On 28 May 2015 at 13:54, Arend van Spriel<arend@broadcom.com>   wrote:
>>>>> On 05/28/15 13:37, Rafał Miłecki wrote:
>>>>>> As we plan to add support for platform NVRAM we should store direct
>>>>>> data pointer without the extra struct firmware layer. This will allow
>>>>>> us to support other sources with the only requirement being u8 buffer.
>>>>>>
>>>>>> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
>>>>>> Signed-off-by: Hante Meuleman<meuleman@broadcom.com>
>>>>>> Signed-off-by: Arend van Spriel<arend@broadcom.com>
>>>>>> ---
>>>>>> Tested on router with BCM43602-s using
>>>>>> /lib/firmware/brcm/brcmfmac43602-pcie.txt
>>>>>>
>>>>>> I've written this patch from scratch, it's inspired by the dropped:
>>>>>> [PATCH 6/6] brcmfmac: Add support for host platform NVRAM loading.
>>>>>
>>>>> So what is your goal here. The inspirational patch was dropped so it
>>>>> can
>>>>> be
>>>>> resubmitted when the mips change it relies on has made its way
>>>>> upstream.
>>>>> So
>>>>> I have to rebase the patch over here and your patch will just give me
>>>>> conflicts during that rebase. So can we please wait or do you need this
>>>>> change right now.
>>>>
>>>> The dropped patch will require rebasing/rewriting anyway. There were
>>>> few changes to firmware.c already, I've few more planned, you'll have
>>>> to drop some code form your patch (parts that will go into MIPS tree)
>>>> and probably apply few changes as requested in comments.
>>>
>>> I already did that and submitted the mips part to Ralf. I am sorry to say
>>> this but what annoys me is that since then you started submitting patches
>>> that seem to be taken from the dropped patch. So I have a problem seeing
>>> the
>>> bright side. If Ralf takes the mips part it ends up in linux-next and we
>>> can
>>> submit the brcmfmac part.
>>
>> This is truly the first patch based on your dropped one. All other 5
>> patches were addressing problems I noticed by myself. One of them
>> fixed the same issue you /silently/ did in the dropped one, but I
>> wasn't even aware of that until I started rebasing your patch. We
>> simply noticed the same problem and fixed it on our owns.
>>
>> So I think this patch is the only one that could annoy you, but
>> *honestly* my intention was exactly the opposite. As already said, I
>> just wanted to do possible cleanup early and let you maintain 50% of
>> your original patch instead the whole one.
>>
>> I really don't want to have you annoyed because the need of rebasing
>> your patch. What you said about Ralf's tree and linux-next isn't
>> exactly true. I do believe Kalle won't merge linux-next into
>> wireless-driver-next, so we have to wait for 4.2-rc1, then for Dave
>> merging Linus's tree, then Kalle merging Dave's tree.
>
> Well, it is an integration issue. So yes, wireless-drivers-next (and
> net-next) would not build for CONFIG_BCM47XX with the brcmfmac patch,
> because of the missing mips patch. However, the linux-next tree will have no
> build issue and consequently 4.2-rc1 will have no build issue. I think this
> is acceptable although I would like to hear the opinion of Kalle on this.

First, I don't really like the idea of breaking building of a tree,
even if it affects a one architecture only.

Secondly, limiting breakage to one arch only will require you to use
some magic #if-s we want to avoid. And then (after having 4.2 in
wireless-drivers-next) you'll have to drop them anyway (just to clean
the code). So I think leaving this stuff for 4.3 is the best choice.

-- 
Rafał
