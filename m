Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63229 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab1KCKDc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 06:03:32 -0400
Received: by qyk27 with SMTP id 27so164728qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Nov 2011 03:03:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1320313141.3950.35.camel@jlt3.sipsolutions.net>
References: <CAMG6FYiV8F=MFBeUQCGSj__h=REVLMvTZCvLEvDPT7GP2KWsWw@mail.gmail.com>
	<1320310524.3950.29.camel@jlt3.sipsolutions.net>
	<CAMG6FYhgeNg3CbDZg7GkJkq1ArJ=5n+bD=zPx=6ZFe7-Kj4Jmw@mail.gmail.com>
	<1320313141.3950.35.camel@jlt3.sipsolutions.net>
Date: Thu, 3 Nov 2011 11:03:31 +0100
Message-ID: <CAMG6FYjQWc2fXDM8eWpEi7OqS+tVfjh5onf_332R3pzq8ks0aQ@mail.gmail.com> (sfid-20111103_110335_527153_BDC6C784)
Subject: Re: [PATCH] cfg80211: merge in beacon ies of hidden bss.
From: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Thu, Nov 3, 2011 at 10:39 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Hi Dmitry,
>
>> >> +     if (!ie1 && !ie2)
>> >> +             return 0;
>> > I don't think it's valid to leave out the SSID IE, so I'd rather not
>> > have that test here. It might interact badly with other uses (mesh?)
>> ie1 and ie2 could not NULL at the same time, otherwise the bss
>> would be found in the first search attempt. However, I would prefer
>> to have some water-proof check here. WARN_ON? BUG_ON?
> Maybe a warning? But I don't see why it'll just fall through to the next
> line and return -1 if one of them is missing.
>
-1 means "lesser", which is not true if both of ies are absent.
0 means "equal", which is correct (but logically impossible with the
current usage of the comparator). Now I think even WARN_ON is a bad
idea, the comparator can be reused for other purposes when both
SSID ies are missing.

>> Key comparator must use same algorithm in any rb-tree search function
>> (order is important), otherwise ordering of items in the tree is broken
>> and search gives incorrect results.
>> This code uses same order as cmp_ies() does.
> Oh. Good point. Add a comment?
>
Yes, I will.

> Eliad pointed out another thing: It is possible to have multiple SSIDs
> hidden behind a single hidden SSID. Therefore, this should update all of
> those BSS structs. Also, I'm a tad confused about the matching code
> here, this code path executes for both received beacons and probe
> responses, but probe responses would typically have found the BSS
> already? But what if we only have a beacon and then receive a probe
> response? Or vice versa? Some comments would be good outlining how that
> works.
>
I will add some comments in the code. Is a word, the code searches for a beacon
of the hidden BSS and copies beacon IEs (with nullified SSID) into the probe
response bss entry (with real SSID). It works fine in case of multi-SSID hidden
BSS too.

> what if we only have a beacon and then receive a probe response?
It's the typical usecase for association with hidden BSS.  The probe
response will
be updated with beacon IEs.

> Or vice versa?
It will not work. Update of beacon IEs of probe response is not implemented.
The code is not trying to update existing probe response bss entries when beacon
IEs are getting changed. Technically it's possible to update them, but
I think it's a bit
overkill, I'm addressing only PSM in this commit.

Thank you and with best regards,
Dmitry
