Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51195 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab2HFVPs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 17:15:48 -0400
Received: by obbuo13 with SMTP id uo13so6435001obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 14:15:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50202A06.7090308@hauke-m.de>
References: <1344095900.5982.0.camel@jlt3.sipsolutions.net>
 <1344162581.4513.1.camel@jlt3.sipsolutions.net> <CAB=NE6XLMTwG65EhExSES-rPsKK7SDBx4+MgwqxuJL__ZtN=zw@mail.gmail.com>
 <50202A06.7090308@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 6 Aug 2012 14:15:27 -0700
Message-ID: <CAB=NE6V+ze=1FOQj5F3AhdF94um+coMY3Y+V9QyFdSUUg_Sryw@mail.gmail.com> (sfid-20120806_231552_684023_C4DA362A)
Subject: Re: [PATCH v2] compat: deal with backported codel
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Hutchings <bhutchings@solarflare.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 6, 2012 at 1:33 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> On 08/06/2012 09:53 PM, Luis R. Rodriguez wrote:
>> On Sun, Aug 5, 2012 at 3:29 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>>> From: Johannes Berg <johannes.berg@intel.com>
>>>
>>> Some distro kernels (in particular the Debian 3.2.0-3
>>> kernel I'm running) backport codel already, so trying
>>> to backport it again causes issues. Protect the compat
>>> backport with #ifdef TCA_CODEL_MAX.
>>>
>>> Also link the flow_dissector code into the codel module
>>> which then won't be loaded on kernels that already have
>>> codel backported.
>>>
>>> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>>
>> Applied and pushed, thanks!
>>
>>   Luis
>>
> This breaks my build if net/codel.h is not in the kernel headers:
>
> In file included from
> /home/hauke/compat-wireless/compat-wireless/compat/sch_fq_codel_core.c:27:0:
> /home/hauke/compat-wireless/compat-wireless/include/net/codel.h:5:28:
> fatal error: net/codel.h: No such file or directory
> compilation terminated.
>
> TCA_CODEL_MAX is defined in include/linux/compat-3.5.h and this file is
> included ever time, so the check around #include_next <net/codel.h> is
> never false.
>
> You could define something like COMPAT_CODEL_BACKPORT in
> include/linux/compat-3.5.h and extend the check in include/net/codel.h
> that this has to be unset.

Dah, reverting for now, I need to get some compiles through.

  Luis
