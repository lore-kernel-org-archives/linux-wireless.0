Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46487 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab1KCVM2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 17:12:28 -0400
Received: by qabj40 with SMTP id j40so1519109qab.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Nov 2011 14:12:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEeaF+Vy+7THnh62Q2ZeH0oWLa6W=JZZNegUA9TeVdwFWw@mail.gmail.com>
References: <CAMG6FYiV8F=MFBeUQCGSj__h=REVLMvTZCvLEvDPT7GP2KWsWw@mail.gmail.com>
	<CAB3XZEeaF+Vy+7THnh62Q2ZeH0oWLa6W=JZZNegUA9TeVdwFWw@mail.gmail.com>
Date: Thu, 3 Nov 2011 22:12:26 +0100
Message-ID: <CAMG6FYhhDs3145NAviUfDoDzmx_FHKjy8WXv=PvC6n1OTGaMnA@mail.gmail.com> (sfid-20111103_221232_903278_781D30EA)
Subject: Re: [PATCH] cfg80211: merge in beacon ies of hidden bss.
From: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eliad,

>> +       if (!ie1 && !ie2)
>> +               return 0;
>> +       if (!ie1 || !ie2)
>> +               return -1;
>> +       ielen = min(ie1[1], ie2[1]);
>> +       for (i = 0; i < ielen; ++i)
>> +               if (ie2[i + 2])
>> +                       return -1;
>> +       return ie2[1] - ie1[1];
>
> you don't account for the ssid = "" case.
>
Yes, true. And also incorrectly handle !ie2 case. I'll fix it.

>> +static int
>> +merge_hidden_ies(struct cfg80211_internal_bss *res,
[...]
>
> i think the "merge" here is a bit misleading - there is no actual merge.
> you copy the beacon_ies from the beacon, but we still end up with 2 bss nodes.
> your solution does workaround the specific psm problem, but we still
> end up with a duplicate bss conf node that will never get updated
> (because the beacons will update the "original" bss node).
>
Yes, correct. I'm addressing only the obvious PSM problem now.
Further implementation is a subject of a discussion.

> i guess this problem already exists with the current code.
> not sure what is the correct way solve it, though.
> maybe check for both the hidden name and the actual name?
>
The whole idea of multi-ssid list of bss'es is a bit unclear for me.
That is the benefit of having ssid ie as a part of the key in the tree?
Are there multi-ssid APs which broadcasts different ies (apart form ssid)
on the same bssid in real live?
If not, I'm thinking about a separate refcounted list of bss ies keeping
all bss information except ssid. But it is a quite big change, definitely
not for this commit.

Thank you and with best regards,
Dmitry
