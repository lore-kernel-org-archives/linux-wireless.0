Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41836 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbeGKHGz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jul 2018 03:06:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 11 Jul 2018 12:34:07 +0530
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/7] cfg80211: Add new NL command to configure peer
 specific rssi threshold
In-Reply-To: <1530877252.3197.5.camel@sipsolutions.net>
References: <1528886747-26342-1-git-send-email-tamizhr@codeaurora.org>
 <1528886747-26342-3-git-send-email-tamizhr@codeaurora.org>
 <1530264578.3481.34.camel@sipsolutions.net>
 <5d7f6ec9ffe0272b41102828f37706db@codeaurora.org>
 <1530877252.3197.5.camel@sipsolutions.net>
Message-ID: <c8560bc51468cb1bd3f876aa6906afae@codeaurora.org> (sfid-20180711_090410_512749_C0BB622A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-07-06 17:10, Johannes Berg wrote:
> On Wed, 2018-07-04 at 11:39 +0530, Tamizh chelvam wrote:
>> On 2018-06-29 14:59, Johannes Berg wrote:
>> > On Wed, 2018-06-13 at 16:15 +0530, Tamizh chelvam wrote:
>> > >
>> > > + * @NL80211_ATTR_STA_MON: Station's connection monitor configuration
>> > > in a
>> > > + *	nested attribute with %NL80211_ATTR_STA_MON_* sub-attributes.
>> >
>> > Can't we reuse the existing attributes in this nesting?
>> 
>> This new attributes introduced as per the previous discussion.
>> https://patchwork.kernel.org/patch/10240697/
>> Is my understanding correct ?
> 
> Yeah ok ... I'm thinking perhaps we could share some part of it, but
> it's not really worth making it more complex due to that.
> 
Sure, i'll reuse those cqm attributes and event notification enum as 
well.

>> > Wait, you went to all this effort in the first patch and now you don't
>> > add this to the list?
>> >
>> No, the list and the rssi_config structure is for multi threshold 
>> value
>> and not for single threshold.
> 
> Yeah, though I'm still not sure why we need the single threshold thing
> at all.
For taking steering kind of decision single threshold value can be used 
to monitor
the station's rssi.

> List should always be a superset.
> 
I believe superset you meant will accept a signle threshold 
configuration also from user ?
If so, we can remove the single threshold api implementation.

Thanks,
Tamizh.
