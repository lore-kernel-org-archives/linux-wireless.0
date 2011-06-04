Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41616 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab1FDBBJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 21:01:09 -0400
Received: by iwn34 with SMTP id 34so1799790iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jun 2011 18:01:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DE91429.9090903@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
 <BANLkTi=Mwbm_yrtL1u8mNboXdYYQz2HbDQ@mail.gmail.com> <4DE91429.9090903@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sat, 4 Jun 2011 11:00:49 +1000
Message-ID: <BANLkTikhJZzc+PmjBFU1tO-NGCV0=ka4xg@mail.gmail.com> (sfid-20110604_030117_521474_83655A0B)
Subject: Re: [PATCH 01/83] staging: brcm80211: removed unused Broadcom
 specific ioctls codes
To: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 4, 2011 at 03:04, Henry Ptasinski <henryp@broadcom.com> wrote:
> On 06/01/2011 08:06 PM, Julian Calaby wrote:
>>
>> Roland,
>>
>> I've passed an eye over the entire patch set.
>
> Thanks for taking the time and putting in the effort to reveiw them all.

No problem!

>> 2. You shouldn't need to #ifdef on BIG_ENDIAN - there are a set of
>> macros to help with working with different endian systems.
>
> Any specific ones we should be looking at?

All of them, to be quite honest. The ones that stuck out for me were
the ones around the REG_[RW] macros, but any that are in the drivers
are worthy targets.

>> 3. Do a typedef removal sweep over the code because typedefs are ugly =)
>
> Definitely on the list of cleanup.
>
>> 4. I had a glance at /Documentation/CodingStyle and saw that there
>> were some issues mentioned in there that could be fixed in your code.
>> You might also want to play with checkpatch.
>
> A few of the patches have complaints from checkpatch, but I believe that in
> all cases the complaints are on existing code that's being moved from one
> file to another to help consolidate things.  We'll keep working on cleaning
> up those issues as we go along.

That's perfectly valid. This point was more a future-work sort of
thing, not something I expect you to deal with right now.

> Any specific checkpatch issues in this series that we should take a second
> look at?

Not really. I was more trying to point out that there are a lot of
issues with the code as a whole that could be fixed, not that there
were any specific issues.

> Thanks again for all the effort.

Again, no problem!

> At this point, should we regenerate the whole series to try and address your
> concerns, or should we do the additional cleanup as followup patches?

I don't see any reason to - unless anyone else has issues. My comments
are more things to work on in the future - I understand that this
patch set is about moving and re-organising code, not making it clean
and shiny.

Unless anyone else has a reason to, I see no reason to re-generate
this patch set.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
