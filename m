Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:35151 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752584AbdBNNHO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 08:07:14 -0500
Received: by mail-wr0-f181.google.com with SMTP id c4so11730928wrd.2
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2017 05:07:14 -0800 (PST)
Subject: Re: [RFC V2 1/5] nl80211: allow multiple active scheduled scan
 requests
To: Johannes Berg <johannes@sipsolutions.net>
References: <1484566941-27000-1-git-send-email-arend.vanspriel@broadcom.com>
 <1484566941-27000-2-git-send-email-arend.vanspriel@broadcom.com>
 <1485250815.7244.8.camel@sipsolutions.net>
 <fd4c2573-caea-1cdc-ee33-f010bb0aad58@broadcom.com>
 <1487076714.4705.11.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <deef3e83-b6d8-f99d-516d-dc6e99013560@broadcom.com> (sfid-20170214_140802_516671_BD04D8C1)
Date: Tue, 14 Feb 2017 14:07:11 +0100
MIME-Version: 1.0
In-Reply-To: <1487076714.4705.11.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14-2-2017 13:51, Johannes Berg wrote:
> On Tue, 2017-02-14 at 13:35 +0100, Arend Van Spriel wrote:
>> On 24-1-2017 10:40, Johannes Berg wrote:
>>>
>>>> + * @max_sched_scan_reqs: maximum number of scheduled scan
>>>> requests
>>>> that
>>>> + *	the device can run concurrently.
>>>
>>> Perhaps we should get rid of WIPHY_FLAG_SUPPORTS_SCHED_SCAN and
>>> just
>>> set this to 1 for such devices? Otherwise we have two different
>>> requirements, and we need to track that 0 is an invalid value here
>>> if
>>> WIPHY_FLAG_SUPPORTS_SCHED_SCAN is set, or something like that?
>>
>> Ok. Doesn't that cause issues in user-space. Or do you only want to
>> get rid of it in cfg80211 api and report the flag to user-space when
>> max_sched_scan_reqs equals 1?
> 
> WIPHY_FLAG_* aren't directly reported to userspace at all.

I noticed diving in the code. Indirectly it is used for reporting
support of sched_scan_start command. Anyway, I got rid of it.

>>> This might break older userspace - you'll have to put it in a later
>>> portion of the code.
>>>
>>> I'm also a bit surprised the attributes aren't actually optional
>>> for when sched scan isn't supported, I'd make the new one optional
>>> and I guess we can fix the others later too, if desired.
>>
>> Why would it break user-space. Is the order in which attributes are
>> added into the stream something user-space relies on.
> 
> No. But there was a size limit on how much older userspace could
> process before we did the splitting.

I see. So basically adding stuff to (split_start == 0) is not wanted.
Just trying to get a clear requirement/rule here. Do we (still) know the
exact size limit?

>>>> +static struct cfg80211_sched_scan_request *
>>>> +cfg80211_find_sched_scan_req(struct cfg80211_registered_device
>>>> *rdev, u64 reqid)
>>>> +{
>>>> +	struct cfg80211_sched_scan_request *pos;
>>>> +
>>>> +	list_for_each_entry(pos, &rdev->sched_scan_req_list,
>>>> list) {
>>>> +		if (pos->reqid == reqid)
>>>> +			return pos;
>>>> +	}
>>>> +	return ERR_PTR(-ENOENT);
>>>> +}
>>>
>>> Here too, I guess, since you don't actually use RCU.
>>
>> So should I use RCU here? Not sure what is the better choice here.
> 
> No no, I just meant to add locking assertions :)

Sure. Did that already pending your reply ;-)

Regards,
Arend
