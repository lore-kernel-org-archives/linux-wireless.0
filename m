Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:34943 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759591AbcLPMVX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Dec 2016 07:21:23 -0500
Received: by mail-pg0-f44.google.com with SMTP id p66so32015580pga.2
        for <linux-wireless@vger.kernel.org>; Fri, 16 Dec 2016 04:21:05 -0800 (PST)
Subject: Re: [RFC V3 03/11] nl80211: add support for gscan
To: Johannes Berg <johannes@sipsolutions.net>
References: <1481543997-24624-1-git-send-email-arend.vanspriel@broadcom.com>
 <1481543997-24624-4-git-send-email-arend.vanspriel@broadcom.com>
 <1481645962.20412.41.camel@sipsolutions.net>
 <3dd64ef5-f05e-4a80-0c98-9a2548affd1c@broadcom.com>
 <1481668194.22319.0.camel@sipsolutions.net>
 <f4f83c57-3e46-b017-fa36-b3776d71670a@broadcom.com>
 <1481883237.27953.22.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <4c0467cd-032e-2786-4714-2e6fd46ed553@broadcom.com> (sfid-20161216_132127_411556_B7883AB8)
Date: Fri, 16 Dec 2016 13:21:02 +0100
MIME-Version: 1.0
In-Reply-To: <1481883237.27953.22.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16-12-2016 11:13, Johannes Berg wrote:
> On Wed, 2016-12-14 at 10:01 +0100, Arend Van Spriel wrote:
> 
>> Had to look for "> 16" ;-)
> 
> Sorry.
> 
>> Here an instance of the tab vs. space issue you mentioned. Will go
>> over the patch and fix that.
> 
> There were a few, not really interesting though - git would probably
> flag it anyway, or checkpatch :)
> 
>>> +	if (num_chans > 16)
>>> +		return -EINVAL;
>>
>> I suspect this is the restriction you were referring to. 
> 
> Yes.
> 
>> There is no
>> reason for this although the android wifi hal has max 16 channels in
>> a bucket so I might have picked that up. 
> 
> I thought I saw something with a u16 bitmap that seemed related, but I
> don't see that now so I'm probably just confused.
> 
>> So could a driver have a similar limit and should we add such to the
>> gscan capabilities? For instance our firmware api has a nasty
>> restriction of 64 channels for all buckets together, eg. can do 4
>> buckets of 16 channels each.
> 
> We do have a limit of the maximum scan buckets, which seems to be 16
> right now. We also have a limit on the number of channels per bucket,
> which is also 16, but no combined limit afaict (so 16x16 seems fine).
> 
> Maybe we do need some advertisement in that area then? Right now,
> wifihal seems to be able to read as capabilities the number of buckets
> (wifi_gscan_capabilities), but assumes the number of channels:
> 
> const unsigned MAX_CHANNELS                = 16;
> const unsigned MAX_BUCKETS                 = 16;
> 
> I guess we took that and combined it, and you had more negotiation with
> Google ;-)

I was not so much involved with the initial gscan effort, but I guess
for brcm it might be true.

> We may then have to actually advertise the limit you have ("64 channels
> combined over all buckets"), unless you can get away with just
> advertising 4 buckets (and us saying 16 channels per bucket is enough?)
> 
> I'm a bit tempted to make this more forward compatible though and not
> hard-limit the number of channels per bucket in the code.

Indeed so I will remove it.

Regards,
Arend
