Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:34390 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752213AbcIBMJf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 08:09:35 -0400
Received: by mail-wm0-f52.google.com with SMTP id w207so11257370wmw.1
        for <linux-wireless@vger.kernel.org>; Fri, 02 Sep 2016 05:09:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <79ab7dfa-f485-ffcd-963c-b91f7d5a8386@candelatech.com>
References: <cf9852df-6d14-baf6-af0a-9cc78c448fde@candelatech.com>
 <1472752911.9608.11.camel@sipsolutions.net> <c7eb32b4-84c5-41ae-1fe6-89df7cbbe7d4@candelatech.com>
 <1472756034.9608.15.camel@sipsolutions.net> <79ab7dfa-f485-ffcd-963c-b91f7d5a8386@candelatech.com>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Fri, 2 Sep 2016 14:09:32 +0200
Message-ID: <CA+BoTQmehZSR71LzJtzy+N+ANZJ8N=c7tg+XX9_NUQjL4R-phQ@mail.gmail.com> (sfid-20160902_140944_024794_933214BC)
Subject: Re: Ath10k probe response error related to mac80211 commit.
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 September 2016 at 22:52, Ben Greear <greearb@candelatech.com> wrote:
> On 09/01/2016 11:53 AM, Johannes Berg wrote:
>> On Thu, 2016-09-01 at 11:23 -0700, Ben Greear wrote:
>>>
>>> Could easily be that others are corrupted too, but since probe resp
>>> is bad, the association will not proceed.
>>
>> makes sense.
>>
>>> Heh, I spent 4 days tracking this down, so I wanted to be precise in
>>> my bug report :)
>>
>> Ahrg, ouch. Sorry about that. I really didn't think the flag would
>> cause any issues for anyone.
>>
>>> The result I see is that there is an extra 10 bytes at the end of the
>>> frame on air.  But, it looks like the exact same pkt is sent to the
>>> firmware both with and without this patch.  Maybe the firmware is
>>> using the wrong tid or something like that due to how the station is
>>> created differently with this patch.
>>
>> That makes no sense though, unless this only happens on say the second
>> station that connects? Until the first station sends an authentication
>> frame, that patch really should have no impact whatsoever.
>
> Ok, I found the problem.
>
> In the 10.1 firmware (at least), it will force the TID to be NON-QOS-TID
> if the peer object does not have the qos_enabled flag set.  This is proba=
bly
> a work-around for some other thing lost in antiquity.
>
> When using my firmware that puts mgt frames over HTT, the TID for mgt
> frames was being over-ridden and set to non-qos TID.  Due to other
> hackery and work-arounds, mgt frames cannot be sent on the non-qos
> TID because they will be put on-air 10 bytes too long.  They must be
> sent on the mgt-tid or non-pause tid.

Sounds like 802.11 header vs 802.3 header length problem (24 - 14 =3D
10). You can hit this if you start playing around tx encap mode as
well.

You could try fooling firmware into thinking the frame has a different
length either in htt TX_FRM or tx fragment list (or both) but since
this seems to be related to RA/DA peer state at xmit time it's
probably not going to be reliable unless you introduce extra tx
flushing barriers in the driver.


Micha=C5=82
