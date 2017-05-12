Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:40130 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758005AbdELToF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 15:44:05 -0400
Subject: Re: [v2,1/3] ath9k: Support channels in licensed bands
To: Steve deRosier <derosier@gmail.com>
References: <20170323133048.30062-2-sw@simonwunderlich.de>
 <1811221.G4Vz0DPyQ8@prime>
 <12133a0e-b030-5b21-8de1-3bf7334d47df@fit.fraunhofer.de>
 <1863250.VEhGCjvYY0@prime> <87efvvvd0t.fsf@kamboji.qca.qualcomm.com>
 <1c5720d5-8264-26a8-a63e-b225524471cc@candelatech.com>
 <CALLGbR+3JZL4=t78TQbLwKdq938B3cw0qj369dd6sY4q5A5ctw@mail.gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        ath10k@lists.infradead.org,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        Julian Calaby <julian.calaby@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath9k-devel@qca.qualcomm.com
From: Ben Greear <greearb@candelatech.com>
Message-ID: <e0dbe905-5520-c634-694c-dd57489180ab@candelatech.com> (sfid-20170512_214429_530837_314506C0)
Date: Fri, 12 May 2017 12:44:04 -0700
MIME-Version: 1.0
In-Reply-To: <CALLGbR+3JZL4=t78TQbLwKdq938B3cw0qj369dd6sY4q5A5ctw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/12/2017 12:21 PM, Steve deRosier wrote:
> Hi Ben,
>
> On Fri, May 12, 2017 at 7:12 AM, Ben Greear <greearb@candelatech.com> wrote:
>>
>>
>> On 05/11/2017 04:38 AM, Kalle Valo wrote:
>>>
>>> Simon Wunderlich <sw@simonwunderlich.de> writes:
>>>
>>>> it seems like there was some discussion here and I wouldn't expect too
>>>> many
>>>> more opinions ... do you think we can have a decision based on what has
>>>> been
>>>> discussed here?
>>>
>>>
>>> Well, there was an excellent reply from Steve and quite a few "in my
>>> opinion this is safe" type of answers. [1] But bluntly said it does not
>>> really matter what we (the engineers) think. What really matters here
>>> are regulatory authorities' opinions and rulings. In that respect here
>>> are few items I want to point out:
>>>
>>> o I suspect that from someone's, who is not familiar with software
>>>   engineering, point of view there is still quite a diffference from
>>>   modifiying source code or just enabling few options from Kconfig with
>>>   a custom regdb rule.
>>
>>
>> If someone with real authority ever complains, then the code could be
>> backed out again.  Your opinion seems not much more informed than the
>> rest of us discussing this.
>>
>
> With all due respect, _I_ am quite well informed about this issue.
> From my conversations with him, I'd also judge Kalle to be quite
> informed likewise.

>> Anyway, if upstream is blocked, then maybe we could work on getting this
>> into LEDE?
>>
>
> Honestly, I don't see how this solves any problems. You're just moving
> the chair. A chair that someone will stand on and fall off and get
> hurt. LEDE, OpenWRT or even Buildroot is essentially just a big patch
> and build system. For a closed-ecosystem manufacturer, which by
> definition a public-safety band licensed equipment manufacturer must
> be, can just as easily maintain their own internal fork of the kernel
> with these patches sitting there.
>
> That's not something I'd normally advocate, but it does seem
> appropriate in this specific application.

Maintaining outside patches means work for everyone..but if there
is a single set of outside patches, then at least it is easier.
That is what LEDE might be able to offer.

As for keeping lame users from causing trouble, maybe we can merge
much of the code that often conflicts with upstream code but leave out a few key patches
to actually enable the feature.  Then no one can just re-build
with a different kernel option (after hacking their regdb) and
get it to work.

All that said, I doubt this will matter at all to FCC because
if LEDE can boot on a device, it can already be put out of spec
without much trouble.  Making it take 2 days of effort vs 1 hour
surely doesn't make a difference?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
