Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.211.193]:56759 "EHLO
	mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbZHKVFN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 17:05:13 -0400
Received: by ywh31 with SMTP id 31so5189446ywh.4
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2009 14:05:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A81DA33.1050405@hauke-m.de>
References: <1249735096-27071-1-git-send-email-hauke@hauke-m.de>
	<1249735096-27071-3-git-send-email-hauke@hauke-m.de> <43e72e890908101520x19fddcddx72215fb0851baf2f@mail.gmail.com>
	<4A81DA33.1050405@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 11 Aug 2009 14:04:54 -0700
Message-ID: <43e72e890908111404k780a3a8ehd8745142e9c01f56@mail.gmail.com>
Subject: Re: [PATCH 3/7] [compat-2.6] pcmcia_parse_tuple was redefined in
	pcmcia/cistpl.h
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 11, 2009 at 1:53 PM, Hauke Mehrtens<hauke@hauke-m.de> wrote:
> Hi Luis,
>
> Thank you for applying the rest of the patches. Next time I will use
> --cover-letter when generating the patches.
>
> Luis R. Rodriguez wrote:
>> On Sat, Aug 8, 2009 at 5:38 AM, Hauke Mehrtens<hauke@hauke-m.de> wrote:
>>> fix build:
>>> undef pcmcia_parse_tuple before redefine it again.
>>>
>>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>>> ---
>>>  compat/compat-2.6.28.h |    8 +++++++-
>>>  1 files changed, 7 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/compat/compat-2.6.28.h b/compat/compat-2.6.28.h
>>> index fdc021a..e25259f 100644
>>> --- a/compat/compat-2.6.28.h
>>> +++ b/compat/compat-2.6.28.h
>>> @@ -29,7 +29,13 @@
>>>  })
>>>  #endif /* From include/asm-generic/bug.h */
>>>
>>> -#define pcmcia_parse_tuple(tuple, parse) pcmcia_parse_tuple(NULL, tuple, parse)
>>> +#include <pcmcia/cs_types.h>
>>> +#include <pcmcia/cs.h>
>>> +#include <pcmcia/cistpl.h>
>>> +#ifdef pcmcia_parse_tuple
>>> +#undef pcmcia_parse_tuple
>>> +#define pcmcia_parse_tuple(tuple, parse) pccard_parse_tuple(tuple, parse)
>>> +#endif
>>
>> Where did pccard_parse_tuple() come from?
> In include/pcmcia/cistpl.h pcmcia_parse_tuple(p_dev, tuple, parse) is
> defined as pccard_parse_tuple(tuple, parse)
>
>> Did you see the commit 0df8084caf53774113c8f118e9dd43e660cf9e15 by any
>> chance? That fixed compilation for me against older kernels.
> I still get a compile error with recent compat-wireless including commit
> 0df8084caf53774113c8f118e9dd43e660cf9e15 with kernel <= 2.6.27 in Ubuntu:
>
> In file included from
> /compat-wireless-git/drivers/net/wireless/b43/pcmcia.c:30:
> include/pcmcia/cistpl.h:610:1: warning: "pcmcia_parse_tuple" redefined
> In file included from /compat-wireless-git/include/net/compat.h:19,
>                 from <command-line>:0:
> /compat-wireless-git/include/net/compat-2.6.28.h:32:1: warning: this is
> the location of the previous definition
>
> The above patch fixes it for me. The patch does not look relay nice, do
> you have a better idea how to solve this problem?

Hm odd, compilation worked for me against 2.6.27 using KLIB and
KLIB_BUILD. I'll try to do that again today see if I still can compile
ok or not.

  Luis
