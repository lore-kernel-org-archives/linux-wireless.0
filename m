Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43909 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab2HGRKD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2012 13:10:03 -0400
Received: by yenl2 with SMTP id l2so3917839yen.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Aug 2012 10:10:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50203B17.9010606@hauke-m.de>
References: <1344095900.5982.0.camel@jlt3.sipsolutions.net>
 <1344162581.4513.1.camel@jlt3.sipsolutions.net> <CAB=NE6XLMTwG65EhExSES-rPsKK7SDBx4+MgwqxuJL__ZtN=zw@mail.gmail.com>
 <50202A06.7090308@hauke-m.de> <50203B17.9010606@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 7 Aug 2012 10:09:42 -0700
Message-ID: <CAB=NE6UYq5g-Jg+O3UX9zpRwt0-QhK5CeJ4G+ke0ov0wCR42wQ@mail.gmail.com> (sfid-20120807_191021_596591_719CF8C5)
Subject: Re: [PATCH v2] compat: deal with backported codel
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Hutchings <bhutchings@solarflare.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 6, 2012 at 2:45 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> On 08/06/2012 10:33 PM, Hauke Mehrtens wrote:
>> On 08/06/2012 09:53 PM, Luis R. Rodriguez wrote:
>>> On Sun, Aug 5, 2012 at 3:29 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>>>> From: Johannes Berg <johannes.berg@intel.com>
>>>>
>>>> Some distro kernels (in particular the Debian 3.2.0-3
>>>> kernel I'm running) backport codel already, so trying
>>>> to backport it again causes issues. Protect the compat
>>>> backport with #ifdef TCA_CODEL_MAX.
>>>>
>>>> Also link the flow_dissector code into the codel module
>>>> which then won't be loaded on kernels that already have
>>>> codel backported.
>>>>
>>>> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>>>
>>> Applied and pushed, thanks!
>>>
>>>   Luis
>>>
>> This breaks my build if net/codel.h is not in the kernel headers:
>>
>> In file included from
>> /home/hauke/compat-wireless/compat-wireless/compat/sch_fq_codel_core.c:27:0:
>> /home/hauke/compat-wireless/compat-wireless/include/net/codel.h:5:28:
>> fatal error: net/codel.h: No such file or directory
>> compilation terminated.
>>
>> TCA_CODEL_MAX is defined in include/linux/compat-3.5.h and this file is
>> included ever time, so the check around #include_next <net/codel.h> is
>> never false.
>>
>> You could define something like COMPAT_CODEL_BACKPORT in
>> include/linux/compat-3.5.h and extend the check in include/net/codel.h
>> that this has to be unset.
>>
>> Hauke
>
> With the attached patch in addition to Johannes' patch it works for me.
> Anyone feel free to integrate it or use it in any other way.

I've merged the two patches together and applied, thanks! Also
throwing this into the linux-3.5.y branch.

  Luis
