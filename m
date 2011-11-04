Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59546 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab1KDI7R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 04:59:17 -0400
Received: by qyk27 with SMTP id 27so570463qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Nov 2011 01:59:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1320395185.3969.4.camel@jlt3.sipsolutions.net>
References: <CAMG6FYg__nsSLa93AmzcMgckg8HG3FjD3LxpyDfA77WTsVm0oA@mail.gmail.com>
	<1320395185.3969.4.camel@jlt3.sipsolutions.net>
Date: Fri, 4 Nov 2011 09:59:16 +0100
Message-ID: <CAMG6FYgvkjYENbE9ud16HthVF4aeSDqM5McnKDr77XxOD542eA@mail.gmail.com> (sfid-20111104_095921_426197_B12C6C47)
Subject: Re: [PATCH v2] cfg80211: merge in beacon ies of hidden bss.
From: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

>> +     /* Absence of SSID or zero-sized SSID is used as
>> +      * an indication of the hidden bss. */
>> +     if (!ie2 || !ie2[1])
>> +             return 0;
>
> I don't think that's right -- I never saw anything w/o an SSID IE except
> for mesh networks I think. Also this has different semantics from the
> regular rb-tree search which will return -1 if not present (which is
> actually a bug).
Ok, agree.

> Since we need to fix cmp_ie() anyway, how about we change it there as
> well. I'm going to post a patch.
>
I assume there is some (unclear for me) idea behind the order of operation
in the cmp_ie comparator. Natural order of scan output?

>> +             /* TODO: The code is not trying to update existing probe
>> +              * response bss entries when beacon ies are
>> +              * getting changed. */
>
> This is nicer, though I'd prefer the TODO was addressed as well since
> now we'll forever show stale data, this seems a bit bad.
>
We'll discuss it and maybe will redesign bss cache a bit, but not in a scope
of this patch. I do not like stale data in IEs as well - from end-user
prospective
WPS likely will not work.

With best regards,
Dmitry
