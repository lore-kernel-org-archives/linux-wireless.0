Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:36499 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968634AbdDZJF2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 05:05:28 -0400
Received: by mail-qk0-f172.google.com with SMTP id u75so69223952qka.3
        for <linux-wireless@vger.kernel.org>; Wed, 26 Apr 2017 02:05:27 -0700 (PDT)
Subject: Re: [PATCH V3 1/9] nl80211: allow multiple active scheduled scan
 requests
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1492776308-15120-1-git-send-email-arend.vanspriel@broadcom.com>
 <1492776308-15120-2-git-send-email-arend.vanspriel@broadcom.com>
 <1493149747.15192.0.camel@sipsolutions.net>
 <3ce6aed5-7d00-3446-a39b-b5da4b788358@broadcom.com>
 <1493196583.2464.14.camel@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <4323eaab-39c2-1946-a4dd-3d37361e3d8c@broadcom.com> (sfid-20170426_112906_075614_48AC1547)
Date: Wed, 26 Apr 2017 11:05:22 +0200
MIME-Version: 1.0
In-Reply-To: <1493196583.2464.14.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 4/26/2017 10:49 AM, Johannes Berg wrote:
> FWIW:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git/commit/?id=978812b3f43dda86e20588cfe0a4a244c4fab141
> 
> 
> On Wed, 2017-04-26 at 10:46 +0200, Arend van Spriel wrote:
> 
>> Sure. In the worker we are already iterating so I guess we could.
>> The number of internal fields in struct cfg80211_sched_scan_request
>> with one of them being the list_head. Thinking about hiding those
>> from the drivers. Is it worth it?
> 
> I guess it could be done, but I'm tending towards doing that less
> again, I have no strong preference in this case. If it was something
> that seems likely to get abused, perhaps, but here...

Ok. As long as drivers don't think they can use the list_head to push it 
on a private list. The internal use comment does not end up in 
kerneldoc. So maybe we can improve that? Would work for me.

Regards,
Arend
