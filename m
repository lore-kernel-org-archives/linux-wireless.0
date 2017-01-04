Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:33768 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752970AbdADKUx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 05:20:53 -0500
Received: by mail-pg0-f44.google.com with SMTP id g1so186848796pgn.0
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jan 2017 02:20:53 -0800 (PST)
Subject: Re: [RFC] nl80211: allow multiple active scheduled scan requests
To: Johannes Berg <johannes@sipsolutions.net>
References: <1481645071.20412.30.camel@sipsolutions.net>
 <1482315616-4721-1-git-send-email-arend.vanspriel@broadcom.com>
 <1483353841.4596.2.camel@sipsolutions.net>
 <ba1cb1a1-3d27-7421-47ea-a5625a886518@broadcom.com>
 <1483523988.15591.9.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Dmitry Shmidt <dimitrysh@google.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5ad9a594-29b3-8c52-a88f-c4186511fe4f@broadcom.com> (sfid-20170104_112112_589774_4D9E58A7)
Date: Wed, 4 Jan 2017 11:20:47 +0100
MIME-Version: 1.0
In-Reply-To: <1483523988.15591.9.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4-1-2017 10:59, Johannes Berg wrote:
> On Tue, 2017-01-03 at 13:25 +0100, Arend Van Spriel wrote:
>> On 2-1-2017 11:44, Johannes Berg wrote:
>>>
>>>> +	/*
>>>> +	 * allow only one legacy scheduled scan if user-space
>>>> +	 * does not indicate multiple scheduled scan support.
>>>> +	 */
>>>> +	if (!info->attrs[NL80211_ATTR_SCHED_SCAN_MULTI] &&
>>>> +	    cfg80211_legacy_sched_scan_active(rdev))
>>>>  		return -EINPROGRESS;
>>>
>>> That probably doesn't go far enough - if legacy one is active then
>>> we
>>> probably shouldn't allow a new MULTI one either (or abandon the
>>> legacy
>>> one) so that older userspace doesn't get confused with multiple
>>> notifications from sched scans it didn't start.
>>
>> I considered that although not taking the notifications into account.
>> Will change it. Abandoning the legacy one would be a behavioral
>> change so probably not acceptable, right?
> 
> Well, it would be acceptable since it's documented that it's possible
> it might stop for any reason. However, we need to prefer something -
> always preferring the new sched scan could lead to bounces, so we can
> prefer (1) existing, (2) legacy-single type or (3) new-multi type, but
> not (4) new sched scan.

Not sure I can follow. What is the difference between (1) and (2). Also
what do you consider (4) new sched scan. You mean the additional
parameterization of the scheduled scan?

> I think preferring the existing would probably be best, i.e. refuse
> legacy if any sched scan is running, and refuse multi if legacy is
> running?

Whatever the response above, I can understand this and it seems most
straightforward. So I tend agree this is our best option although maybe
for the wrong reason.

>> I guess your remark means this clarifies your earlier question about
>> the request id, right?
> 
> yeah.

Thanks,
Arend
