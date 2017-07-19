Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:33554 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753281AbdGSIjh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jul 2017 04:39:37 -0400
Received: by mail-ua0-f176.google.com with SMTP id y47so29755584uag.0
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jul 2017 01:39:37 -0700 (PDT)
From: Hante Meuleman <hante.meuleman@broadcom.com>
References: <aacfa1fd-ac34-b3c1-b078-4b6a5eefe4ca@mnementh.co.uk>
 <87cdbbc12b504e89d2bd1c33df6a6bf6@mail.gmail.com> <5eb895bd-58cf-70fd-3c00-c8fed86aed79@mnementh.co.uk>
 <6fe08666ca09bf3c1d4476fdad8ce97a@mail.gmail.com> <222e2bc1-4d8f-8133-4fa7-51a48f3de785@mnementh.co.uk>
 <0395e3f6-6bd9-cbad-0fe2-9a5d32a9baa6@mnementh.co.uk> <701af0be-87b6-a397-ae29-a5ba75605588@broadcom.com>
 <feb0cba3-27da-6cab-316f-164867867cd6@mnementh.co.uk>
In-Reply-To: <feb0cba3-27da-6cab-316f-164867867cd6@mnementh.co.uk>
MIME-Version: 1.0
Date: Wed, 19 Jul 2017 10:39:35 +0200
Message-ID: <1ca886ff99c569faad930b6b4d6c0d3f@mail.gmail.com> (sfid-20170719_103944_451068_D6842FC2)
Subject: RE: brcmfmac bus level addressing issues.
To: Ian Molton <ian@mnementh.co.uk>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: Franky Lin <franky.lin@broadcom.com>,
        brcm80211-dev-list@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Ian,

Yes, I was intentionally provocative. Sure, you made no personal attacks,
but this is how you entered my space; I've been working (partrly) for the
last 5 years on brcmfmac and to be honest, I don't work much on it
anymore. But here it is; my screen filled with mails from you with a
number of patches on brcmfmac and some of them were on code I wrote, and
then you use words like:

- horrid
- crap
- awfully
- hideous
- spaghetti mess

No matter what, how impersonal code is supposed to be, I took it personal,
and I got agitated. Now I never directly reply on patches, so I let it be,
but then you start with "brcmfac bus level addressing issues" and you come
with claims I really didn't understand.

Stuff like " The PCIe code sets the window *regardless* of wether its
changed, on *every single* write." Is totally incorrect. Sure if you limit
yourself to the function brcmf_pcie_buscore_{read,write}32(). But you
talked about performance, and msgbuf prototocol is where performance
counts and that don't use those functions. You wrote: " The PCIe code uses
brcmf_pcie_select_core(), which, ultimately, appears to be totally
redundant" and that is simply not true. So I decided to answer that mail
and provoke you a bit. I'm sorry for that, I shouldn't have done that. But
really you may not be directly insulting persons, but when you write: "
Can we standardise how this is supposed to work? Its ugly, and its going
to cause bugs, ultimately" then I just read another negative strong word
(in this case ugly) and it is partly about code I wrote.

You obviously spent some time on creating all these patches, but why
provoke/agitate people? Why use such strong words? You may not consider
them personally, but I just explained why I do. Can you at least
understand that? Just some word of advice and then I hope we can leave it
to that. You can achieve much more without those negative strong words,
the words I listed above are what pop up with me every mail you wrote, not
the code.

Regards,
Hante


-----Original Message-----
From: Ian Molton [mailto:ian@mnementh.co.uk]
Sent: Wednesday, July 19, 2017 12:45 AM
To: Arend van Spriel; linux-wireless@vger.kernel.org
Cc: Franky Lin; brcm80211-dev-list@broadcom.com; Hante Meuleman
Subject: Re: brcmfmac bus level addressing issues.

On 18/07/17 21:44, Arend van Spriel wrote:
>
>
>>> Stop. Listen. Fix it.
>
> Hi Ian,
>
> Now stop yourself and listen. This is no collaboration in any sense.

Arend - This is not directed at you - you've been polite, and I've no
issue with you.

I had felt that the initial conflict over this was over, but then Hante
wrote his last post. I may have been a bit blunt about the code initially,
but I made *no personal attacks* up until Hante's post (I've just read
*all* my posts on this thread and checked to be sure). I hop you can
understand that his comments earlier were well out of line. I've actually
chosen to take the day off today, before I replied to him with something
I'd really regret posting. I was furious.

> but you seem to easily disregard us.

Actually, no. You yourself have been helpful and responsive.

> Also you said it yourself all your patches are cleanup. What needs
> fixing is the gscan feature detection and that one is on me.

Fair enough - I guess now that its in the kernel it needs fixing before
4.13 - but I would argue that no new features should go into the driver
for the short term once that is done. Lets give it a good spring clean.

I am, actually, able to put some time into this, and *want* to help - MY
current employer would benefit greatly from this driver becoming stable.

(as it stands, back to back wpasuplpicant runs make it keel over, as does
module unload and reload).

> So I am chasing that although I am actually on vacation.

Dude - enjoy your vacation. Seriously.

> As long as my wife does not notice we are ok :-p

Shhh :)

>>> You could at the very least give some feedback on the 29 patches I
>>> sent cleaning it up.
>
> That really has to wait until I return as well as running some tests
> on older 4329 and some newer chipsets.

Fair. When do you return? No pressure - it just means I know I can hold
off and do something else on my project until then.

> Actually, Hante is not working full-time on this driver. Neither am I.

Fair enough. He did wax lyrical about his "seniority" on the driver
though. Pulling rank does not sit well with me.

> Now please stop the insults when you hit some push back or in generalf
> for that matter.

I'd recommend re-reading these threads. Whilst I'd grant my initial
comments in the first cut of the patchset were a little harsh, they were
NOT personally directed.

Hante crossed that line, but I've said my piece on the matter now. I have
nothing further to say to Hante on the matter and consider it over, if he
will do the same.

> It is awfully counterproductive for both you and others.

It certainly is - it cost me a days work, as I couldnt think straight
after this morning.

So - Lets let this be the end of it.

I propose that in the near future we sit down and plan some cleanup work
for this driver (*after* your vacation). Get it stable, make it a shining
example of how to do WiFi.

Deal?

-Ian

>
> Regards,
> Arend
>
>>> -Ian
>>>
>>>>
>>>> Regards, Hante
>>>>
>>>> -----Original Message-----
>>>> From: Ian Molton [mailto:ian@mnementh.co.uk]
>>>> Sent: Tuesday, July 18, 2017 1:28 PM
>>>> To: Hante Meuleman; linux-wireless@vger.kernel.org
>>>> Cc: Arend Van Spriel; Franky Lin
>>>> Subject: Re: brcmfmac bus level addressing issues.
>>>>
>>>> On 18/07/17 11:35, Hante Meuleman wrote:
>>>>> Hi Ian,
>>>>>
>>>>> I've really no idea what you mean.
>>>>
>>>> You should look at the code...
>>>>
>>>>> brcmf_pcie_select_core is redundant?
>>>>
>>>> Essentially yes - there may be a couple of corner cases where the
>>>> IO accesses are not performed via
>>>> brcmf_pcie_buscore_{read,write}32() - but other than that,
>>>> brcmf_pcie_buscore_prep_addr() sets the IO window unconditionally on
every access.
>>>>
>>>>> Care to try to boot a device without this function?
>>>>
>>>> I strongly suspect it would work. Perhaps try it? Give me a device
>>>> and I'll try it.
>>>>
>>>>> Called all over the  place? Hell no, it is default pointing to
>>>>> PCIE2 and functions which need to map the window to another core
>>>>> will do so, temporarily, but move it back to PCIE2, at least that
>>>>> is the idea, may be you found a bug?
>>>>
>>>> brcmf_pcie_select_core() looks up the core structure from the core
id.
>>>>
>>>> it then sets BRCMF_PCIE_BAR0_WINDOW according to the core base
address.
>>>>
>>>> it actually goes to the length of reading it back and trying again
>>>> if its not set, even, which is at least a little bit horrifying.
>>>>
>>>> ------------
>>>>
>>>> brcmf_pcie_buscore_{read,write}32() both call
>>>> brcmf_pcie_buscore_prep_addr()
>>>>
>>>> brcmf_pcie_buscore_prep_addr() *unconditionally* programs
>>>> BRCMF_PCIE_BAR0_WINDOW on *every single* IO access.
>>>>
>>>> If you want inefficient - its right there.
>>>>
>>>>
>>>> The SDIO version of the code is actually considerably more
>>>> efficient on this point - it at least only programs the window
>>>> register only when it changes, not on every single IO access.
>>>>
>>>>> We are
>>>>> for sure not going to hide the selecting of the window in the
>>>>> read/write routines, that would result in a giant amount of
overhead.
>>>>
>>>> Actually it would result in *considerably* less overhead than the
>>>> current code, that blindly sets the window on every access.
>>>>
>>>>> Currently PCIE
>>>>> devices reach 1.5Gpbs, we need to go faster than that in the near
>>>> future.
>>>>
>>>> I dont need a lesson on writing efficient code, thanks.
>>>>
>>>>> We don't want just change that to make it bit nicer..... Why do
>>>>> you need to see the same in the SDIO and PCIE drivers? SDIO and
>>>>> PCIE differ in many aspects. Sure some things can be improved in
>>>>> or the other, but they sure don't need to look alike.
>>>>
>>>> I dont "need" to see the same in both drivers. Not where it isnt
>>>> appropriate.
>>>>
>>>> but every part of the drivers that can share code without
>>>> noticeably impacting performance *should* do so. You should be
>>>> justifying to me why the code has to be different, not the other
>>>> way around. Are you sreiously arguing that sharing common code is a
bad idea?
>>>>
>>>>> It may be ugly, but thusfar it has not caused bugs
>>>>
>>>> Oh, I bet you it has... try reading the SDIO version (note the
>>>> reliance on the dangling ->sbwad pointer) and tell me again that
>>>> this hasnt caused bugs.
>>>>
>>>> Right now, the bulk of the driver code is sat on top of at least
>>>> two bus drivers with differing IO models, and is working via good
luck alone.
>>>>
>>>>> The concept in pcie bus part is simple.
>>>>
>>>> And differs completely from the SDIO part.
>>>>
>>>>> The main core to select is PCIE2 (once you have booted and
>>>>> established initial communication with firmware) and every routine
>>>>> which needs to access another core will change the window
>>>>> temporarily and set it back once done. Please don't mess with
>>>>> this, it works, it is clear and it is fast.
>>>>
>>>> If is anything but fast. changing the window involves traversiong
>>>> the list of cores. Every. Single. Time. It doesnt *have* to - but
>>>> thats what
>>>> brcmf_chip_get_core() does, and brcmf_pcie_select_core() calls it.
>>>>
>>>
>>
