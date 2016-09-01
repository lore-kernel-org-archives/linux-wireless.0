Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:35990 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754595AbcIAU6D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Sep 2016 16:58:03 -0400
Subject: Re: Ath10k probe response error related to mac80211 commit.
To: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>
References: <cf9852df-6d14-baf6-af0a-9cc78c448fde@candelatech.com>
 <1472752911.9608.11.camel@sipsolutions.net>
 <c7eb32b4-84c5-41ae-1fe6-89df7cbbe7d4@candelatech.com>
 <1472756034.9608.15.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <79ab7dfa-f485-ffcd-963c-b91f7d5a8386@candelatech.com> (sfid-20160901_225806_621505_028F3376)
Date: Thu, 1 Sep 2016 13:52:15 -0700
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
>
>> The result I see is that there is an extra 10 bytes at the end of the
>> frame on air.  But, it looks like the exact same pkt is sent to the
>> firmware both with and without this patch.  Maybe the firmware is
>> using the wrong tid or something like that due to how the station is
>> created differently with this patch.
>
> That makes no sense though, unless this only happens on say the second
> station that connects? Until the first station sends an authentication
> frame, that patch really should have no impact whatsoever.

Ok, I found the problem.

In the 10.1 firmware (at least), it will force the TID to be NON-QOS-TID
if the peer object does not have the qos_enabled flag set.  This is probably
a work-around for some other thing lost in antiquity.

When using my firmware that puts mgt frames over HTT, the TID for mgt
frames was being over-ridden and set to non-qos TID.  Due to other
hackery and work-arounds, mgt frames cannot be sent on the non-qos
TID because they will be put on-air 10 bytes too long.  They must be
sent on the mgt-tid or non-pause tid.

I am guessing that somehow this mac80211 change creates a peer early
that does not have the qos logic enabled, and so that is why I suddenly
started hitting this bug.

Probably stock firmware is OK since it uses a second tx path for management,
and I guess that by whatever time it starts sending non-mgt frames the
qos-enabled logic is set properly.

I can fix this in my firmware by making it not over-ride the TID in
this case.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
