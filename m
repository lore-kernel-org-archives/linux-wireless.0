Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1971 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375Ab1FCQ6s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 12:58:48 -0400
Message-ID: <4DE912BA.6060805@broadcom.com> (sfid-20110603_185852_577046_C2E6EA12)
Date: Fri, 3 Jun 2011 18:58:34 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: "Julian Calaby" <julian.calaby@gmail.com>
cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 01/83] staging: brcm80211: removed unused Broadcom
 specific ioctls codes
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
 <BANLkTi=Mwbm_yrtL1u8mNboXdYYQz2HbDQ@mail.gmail.com>
In-Reply-To: <BANLkTi=Mwbm_yrtL1u8mNboXdYYQz2HbDQ@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/02/2011 05:06 AM, Julian Calaby wrote:
> Roland,
>
> I've passed an eye over the entire patch set.
>
> My comments are pretty minor, but I've replied to the patches that I
> have concerns for. Please note that I'm not really a developer, and my
> comments are mostly style issues, not actual functional issues. Oh,
> and also, I read most of the patches out of order, so some of the
> comments may not make complete sense.
>
> Overall, my comments are these:
> 1. If you're doing typedef removals in a patch, mention it in the summary.
> 2. Work on your summaries, there are a few cases where I think they're
> a little too terse.
> 3. Good work!
> 4. Keep going =)

Thanks ! Your comments are noted. Btw, this patch train is not just the 
fruit of my labor, so Arend and Franky deserve this credit as well :-)

> A couple of items you might want to add to your TODO list:
> 1. Replace the REG_[RW] macros with inline functions or equivalent
> because they're ugly.

Noted it down.

> 2. You shouldn't need to #ifdef on BIG_ENDIAN - there are a set of
> macros to help with working with different endian systems.

Noted that one down as well.

> 3. Do a typedef removal sweep over the code because typedefs are ugly =)

Agree. At the end of the patch train, all typedefs have been moved over 
to one file. Next step is to get rid of them.

> 4. I had a glance at /Documentation/CodingStyle and saw that there
> were some issues mentioned in there that could be fixed in your code.
> You might also want to play with checkpatch.

When writing new code, we adhere to checkpatch. But in these patches, a 
lot of (existing) code was moved around. We could have placed a separate 
commit after each move that fixed up checkpatch issues (not in the same 
commit since that blocks tools from detecting the movement of code), but 
at the moment the focus is on structural code cleanup (reducing number 
of .c and .h files, removing dead code, etc).

> 5. Personally, I'd avoid void pointers, but I'm not sure of the exact
> rules. Could someone else weigh in on this?

I am curious too, the CodingStyle doc says nothing about it.

>
> I'm probably missing a whole lot of other, much more important, stuff,
> but this is what I saw.

Valuable feedback, taken into account. Thanks for investing time in this.

Bye, Roland.

