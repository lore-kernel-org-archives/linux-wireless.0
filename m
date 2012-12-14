Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:35972 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750756Ab2LNFAS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 00:00:18 -0500
Message-ID: <50CAB259.4020704@posedge.com> (sfid-20121214_060024_317312_85FF8235)
Date: Fri, 14 Dec 2012 10:30:09 +0530
From: Chaitanya <chaitanyatk@posedge.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	viro@parcelfarce.linux.theplanet.co.uk,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: apparmor: Strlen oops in 3.7.0-rc1 (mac80211-next)
References: <50C9D469.8010809@posedge.com> <CAGRGNgUUb8iBtmRDyZz=jG8jYVTNmG=beCjAf7wDT0nbsLMDwg@mail.gmail.com>
In-Reply-To: <CAGRGNgUUb8iBtmRDyZz=jG8jYVTNmG=beCjAf7wDT0nbsLMDwg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi Julian,

I have no problems to submit the patch, but thought it would be good if the person who fixed it submits.
If there is still no response from Viro, will submit the patch myself.

Thanks.

On Friday 14 December 2012 05:13 AM, Julian Calaby wrote:
> Hi Chaitanya,
>
> On Fri, Dec 14, 2012 at 12:13 AM, Chaitanya <chaitanyatk@posedge.com> wrote:
>> Hi Johannes/Al Viro,
>>
>> Can you submit the below patch?
> Why don't you submit it?
>
> Read Documentation/SubmittingPatches for instructions on how to format
> your patch correctly.
>
> Looking at what you've sent so far, you're pretty much there, all you
> need to do is:
> 1. Check that your email client is sending patches that are formatted
> correctly (send one to yourself and make sure it applies.)
> 2. Make the patch message a bit more descriptive, a listing of the
> error would be useful, as would some background on what introduced it
> 3. Sign it off
> 4. Send it to the correct maintainers of the appropriate parts of the
> kernel - check MAINTAINERS in the top level directory of the kernel
> tree - from the content of the patch, I'd guess that this is for the
> AppArmour maintainers
>
> Once you've done all that, there shouldn't be any reason why it won't
> be applied, and once that happens, it'll make it's way to the
> mac80211-next tree shortly. You should CC Johannes and linux-wireless
> just to make sure that everyone's aware of it.
>
> Thanks,
>
> Julian Calaby
>
>> When moved to mac80211-next kernel was facing the crash related to strlen failure in the audit module.
>> After some searching found a fix from Al Viro (http://lkml.indiana.edu/hypermail/linux/kernel/1210.2/01060.html) .
>>
>> This is recurrent.
>> ---
>>  security/apparmor/Makefile |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/security/apparmor/Makefile b/security/apparmor/Makefile
>> index 7b3021c..5706b74 100644
>> --- a/security/apparmor/Makefile
>> +++ b/security/apparmor/Makefile
>> @@ -57,7 +57,7 @@ cmd_make-rlim = echo "static const char *const rlim_names[RLIM_NLIMITS] = {" \
>>
>>  $(obj)/capability.o : $(obj)/capability_names.h
>>  $(obj)/resource.o : $(obj)/rlim_names.h
>> -$(obj)/capability_names.h : $(srctree)/include/linux/capability.h \
>> +$(obj)/capability_names.h : $(srctree)/include/uapi/linux/capability.h \
>>                             $(src)/Makefile
>>         $(call cmd,make-caps)
>>  $(obj)/rlim_names.h : $(srctree)/include/uapi/asm-generic/resource.h \
>>
>> Regards,
>> Chaitanya T K.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

