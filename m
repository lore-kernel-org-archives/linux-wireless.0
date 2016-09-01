Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:37936 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757447AbcIAVb2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Sep 2016 17:31:28 -0400
Subject: Re: Ath10k probe response error related to mac80211 commit.
To: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <cf9852df-6d14-baf6-af0a-9cc78c448fde@candelatech.com>
 <1472752911.9608.11.camel@sipsolutions.net>
 <c7eb32b4-84c5-41ae-1fe6-89df7cbbe7d4@candelatech.com>
 <1472756034.9608.15.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <29e9cfdd-9354-a65b-ac02-7de5d9f91566@candelatech.com> (sfid-20160901_233141_547323_9C4001F3)
Date: Thu, 1 Sep 2016 12:00:19 -0700
MIME-Version: 1.0
In-Reply-To: <1472756034.9608.15.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/01/2016 11:53 AM, Johannes Berg wrote:
> On Thu, 2016-09-01 at 11:23 -0700, Ben Greear wrote:
>>
>> Could easily be that others are corrupted too, but since probe resp
>> is bad, the association will not proceed.
>
> makes sense.
>
>> Heh, I spent 4 days tracking this down, so I wanted to be precise in
>> my bug report :)
>
> Ahrg, ouch. Sorry about that. I really didn't think the flag would
> cause any issues for anyone.

It took so much time because for whatever reason git bisect couldn't
find the issue, and I spent a day thinking it was in ath10k driver and
poking hard at that.

Anyway, no worries...it happens, and could easily just be a bug in
my firmware modifications that are somehow triggered by this.

>> The result I see is that there is an extra 10 bytes at the end of the
>> frame on air.  But, it looks like the exact same pkt is sent to the
>> firmware both with and without this patch.  Maybe the firmware is
>> using the wrong tid or something like that due to how the station is
>> created differently with this patch.
>
> That makes no sense though, unless this only happens on say the second
> station that connects? Until the first station sends an authentication
> frame, that patch really should have no impact whatsoever.

'makes no sense' is the ath10k motto.

I have verified that it is not an obvious difference in the ath10k driver
though...copying 4.5 ath10k driver onto 4.4 works fine, and copying 4.4
ath10k driver into 4.5 is broken.

I don't think any stations connect, but I didn't look precisely for that
yet.  I know the stations I'm trying to connect will not.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
