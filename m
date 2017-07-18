Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:35310 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751465AbdGRUoL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Jul 2017 16:44:11 -0400
Received: by mail-wr0-f176.google.com with SMTP id w4so44834577wrb.2
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jul 2017 13:44:11 -0700 (PDT)
Subject: Re: brcmfmac bus level addressing issues.
To: Ian Molton <ian@mnementh.co.uk>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Franky Lin <franky.lin@broadcom.com>,
        brcm80211-dev-list@broadcom.com,
        Hante Meuleman <hante.meuleman@broadcom.com>
References: <aacfa1fd-ac34-b3c1-b078-4b6a5eefe4ca@mnementh.co.uk>
 <87cdbbc12b504e89d2bd1c33df6a6bf6@mail.gmail.com>
 <5eb895bd-58cf-70fd-3c00-c8fed86aed79@mnementh.co.uk>
 <6fe08666ca09bf3c1d4476fdad8ce97a@mail.gmail.com>
 <222e2bc1-4d8f-8133-4fa7-51a48f3de785@mnementh.co.uk>
 <0395e3f6-6bd9-cbad-0fe2-9a5d32a9baa6@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <701af0be-87b6-a397-ae29-a5ba75605588@broadcom.com> (sfid-20170718_224416_422428_2507E045)
Date: Tue, 18 Jul 2017 22:44:08 +0200
MIME-Version: 1.0
In-Reply-To: <0395e3f6-6bd9-cbad-0fe2-9a5d32a9baa6@mnementh.co.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 18-07-17 17:14, Ian Molton wrote:
> Reposting as CC's got reset (not by me).
> 
> On 18/07/17 15:36, Ian Molton wrote:
>> On 18/07/17 13:50, Hante Meuleman wrote:
>>> Hi Ian,
>>>
>>> - Ok, I may not have been reading all the code that well, but I'm pretty
>>> sure, you cannot do without brcmf_pcie_select_core, at least that is how I
>>> "intended" it when I wrote it. Try buying a macbook with a 43602, remove
>>> the function and all calls (8 in total) and try booting it. I might be
>>> mistaken but I'm 99% sure that it won't, give it a try I would say.
>>
>> I'm not buying a macbook just to make a point.
>>
>>> - brcmf_pcie_buscore_{read,write}32() are not the main functions, they are
>>> the corner cases. They exist to satisfy chip.c which is a common module to
>>> support different bus types (SDIO and PCIE). Chip.c just identifies the
>>> cores on the chip and does some magic reset stuff. The main functions to
>>> access memory (during normal operation) are brcmf_pcie_read/write_{all
>>> variants} functions. They matter when it comes to performance, and I was
>>> under the impression you were familiar with the code and wanted to add
>>> window selection functionality to those functions, and that would have
>>> been bad.
>>
>> Did I mention them even once?
>>
>>> Chip.c is just init, we don't care about performance there.
>>
>> Then you invalidated your whole argument for not cleaning it up.
>>
>>> - I'm unfamiliar with sbwad, perhaps it has caused issues in the past. You
>>> wrote : " Can we standardise how this is supposed to work? Its ugly, and
>>> its going to cause bugs" and then you talk about a lot of changes in the
>>> PCIE code.
>>
>> ->swbad is used in the SDIO code to store the last value the window
>> register was programmed with, so as to avoid programming it twice.
>>
>> Im talking about making some attempt to unify the PCIE and SDIO bus
>> code, since they BOTH have the same constraint - an IO window that needs
>> to be moved about depending on the addresses being accessed.
>>
>> Whhat is really needed is for brcmf_pcie_select_core and a variant of it
>> for SDIO (and presumably USB, but I havent looked) to share common code.
>>
>> When you pull the code apart, its really not THAT dissimilar, but it
>> *looks* it and thats not a good thing.
>>
>> The major differences are:
>>
>> The PCIe code sets the window address in ALL the _{read,write}32 calls,
>> wheras the SDIO code does not.
>> The SDIO code does not have an analogue to brcmf_pcie_select_core() -
>> but it should, since it has similar restrictions. It works by good luck.
>>
>>> I don't see a need to cleanup just because we might change
>>> something in the future which could result in a bug because it was
>>> programmed perfectly pretty.
>>
>> -EPARSE
>>
>>> As far as I can see (and I can see a long way)
>>
>> Oh please.
>>
>>> there are not going to be a lot of changes in the pcie code in the
>>> near future.
>>
>> Maybe so - its a lot better than the SDIO code.
>>
>>>  - I don't need to justify to you why the code is different. I wrote the
>>> code and I'll be the one adding new functionality.
>>
>> You realise that this is Linux, right? its public code, and worked on
>> publicly, by many people. You might be a maintainer of a driver, but
>> that does not make you "king of Linux".
>>
>>> You need to justify
>>> prettying up the code while I'm familiar with the code after working on it
>>> for the last 3 years.
>>
>> "Its illegible shite (the SDIO code certainly is) and it should never
>> have got into mainline" sounds like pretty damn good justification to me.
>>
>> If you've been working on this crap for 3 YEARS then *hang your damn
>> head in shame* - I've been working on it for about 5 DAYS now, and I've
>> found 2 complete breakages (one admittedly patched now), a possible
>> firmware bug, and undefined behaviour in the SDIO bus code.
>>
>> But its NOT a pissing contest. I've sent patches. It doesn't matter how
>> long you've been working on the code - if the patches make it better,
>> then take the damn patches. Or at least explain why you aren't going to.
>>
>>> No offence,
>>
>> Too late for that.
>>
>>> but "Im going to be one to get familiarized with your prettifying
>>> changes while you just hop on to the next driver.....
>>
>> You cheeky bastard. "hop onto the next driver". As if that means anything.
>>
>> Just because you're familiar with the stinking pile of crap doesn't mean
>> it should not be touched for fear of breaking it.
>>
>> You're the one ploughing ahead adding new features on top of a garbage
>> driver core.
>>
>> Stop. Listen. Fix it.

Hi Ian,

Now stop yourself and listen. This is no collaboration in any sense. You
mentioned you don't know the maintainers, but you seem to easily
disregard us. Also you said it yourself all your patches are cleanup.
What needs fixing is the gscan feature detection and that one is on me.
So I am chasing that although I am actually on vacation. As long as my
wife does not notice we are ok :-p

>> Then add the new features.
>>
>> You could at the very least give some feedback on the 29 patches I sent
>> cleaning it up.

That really has to wait until I return as well as running some tests on
older 4329 and some newer chipsets.

>> For reference, I've noticed a couple of minor nits in my patchset ( one
>> spelling error in a commit message, one dangling variable, and some
>> minor shenannigans around f0 writes which needs a trivial re-work for
>> compliance with the linux mmc framework (I should use a QUIRK for the
>> func0 accesses - although the original driver code was worse and
>> actively worked around the quirk instead). I will re-spin and post them.
>>
>> In the mean time, I'd appreciate some review on the rest. Since you're
>> clearly full time on this driver, bloody well get on with it.

Actually, Hante is not working full-time on this driver. Neither am I.

Now please stop the insults when you hit some push back or in generalf
for that matter. It is awfully counterproductive for both you and others.

Regards,
Arend

>> -Ian
>>
>>>
>>> Regards, Hante
>>>
>>> -----Original Message-----
>>> From: Ian Molton [mailto:ian@mnementh.co.uk]
>>> Sent: Tuesday, July 18, 2017 1:28 PM
>>> To: Hante Meuleman; linux-wireless@vger.kernel.org
>>> Cc: Arend Van Spriel; Franky Lin
>>> Subject: Re: brcmfmac bus level addressing issues.
>>>
>>> On 18/07/17 11:35, Hante Meuleman wrote:
>>>> Hi Ian,
>>>>
>>>> I've really no idea what you mean.
>>>
>>> You should look at the code...
>>>
>>>> brcmf_pcie_select_core is redundant?
>>>
>>> Essentially yes - there may be a couple of corner cases where the IO
>>> accesses are not performed via brcmf_pcie_buscore_{read,write}32() - but
>>> other than that, brcmf_pcie_buscore_prep_addr() sets the IO window
>>> unconditionally on every access.
>>>
>>>> Care to try to boot a device without this function?
>>>
>>> I strongly suspect it would work. Perhaps try it? Give me a device and
>>> I'll try it.
>>>
>>>> Called all over the  place? Hell no, it is default pointing to PCIE2
>>>> and functions which need to map the window to another core will do so,
>>>> temporarily, but move it back to PCIE2, at least that is the idea, may
>>>> be you found a bug?
>>>
>>> brcmf_pcie_select_core() looks up the core structure from the core id.
>>>
>>> it then sets BRCMF_PCIE_BAR0_WINDOW according to the core base address.
>>>
>>> it actually goes to the length of reading it back and trying again if its
>>> not set, even, which is at least a little bit horrifying.
>>>
>>> ------------
>>>
>>> brcmf_pcie_buscore_{read,write}32() both call
>>> brcmf_pcie_buscore_prep_addr()
>>>
>>> brcmf_pcie_buscore_prep_addr() *unconditionally* programs
>>> BRCMF_PCIE_BAR0_WINDOW on *every single* IO access.
>>>
>>> If you want inefficient - its right there.
>>>
>>>
>>> The SDIO version of the code is actually considerably more efficient on
>>> this point - it at least only programs the window register only when it
>>> changes, not on every single IO access.
>>>
>>>> We are
>>>> for sure not going to hide the selecting of the window in the
>>>> read/write routines, that would result in a giant amount of overhead.
>>>
>>> Actually it would result in *considerably* less overhead than the current
>>> code, that blindly sets the window on every access.
>>>
>>>> Currently PCIE
>>>> devices reach 1.5Gpbs, we need to go faster than that in the near
>>> future.
>>>
>>> I dont need a lesson on writing efficient code, thanks.
>>>
>>>> We don't want just change that to make it bit nicer..... Why do you
>>>> need to see the same in the SDIO and PCIE drivers? SDIO and PCIE
>>>> differ in many aspects. Sure some things can be improved in or the
>>>> other, but they sure don't need to look alike.
>>>
>>> I dont "need" to see the same in both drivers. Not where it isnt
>>> appropriate.
>>>
>>> but every part of the drivers that can share code without noticeably
>>> impacting performance *should* do so. You should be justifying to me why
>>> the code has to be different, not the other way around. Are you sreiously
>>> arguing that sharing common code is a bad idea?
>>>
>>>> It may be ugly, but thusfar it has not caused bugs
>>>
>>> Oh, I bet you it has... try reading the SDIO version (note the reliance on
>>> the dangling ->sbwad pointer) and tell me again that this hasnt caused
>>> bugs.
>>>
>>> Right now, the bulk of the driver code is sat on top of at least two bus
>>> drivers with differing IO models, and is working via good luck alone.
>>>
>>>> The concept in pcie bus part is simple.
>>>
>>> And differs completely from the SDIO part.
>>>
>>>> The main core to select is PCIE2 (once you have booted and established
>>>> initial communication with firmware) and every routine which needs to
>>>> access another core will change the window temporarily and set it back
>>>> once done. Please don't mess with this, it works, it is clear and it
>>>> is fast.
>>>
>>> If is anything but fast. changing the window involves traversiong the list
>>> of cores. Every. Single. Time. It doesnt *have* to - but thats what
>>> brcmf_chip_get_core() does, and brcmf_pcie_select_core() calls it.
>>>
>>
> 
