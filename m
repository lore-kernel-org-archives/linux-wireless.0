Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:35066 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbbLENWb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Dec 2015 08:22:31 -0500
Received: by wmuu63 with SMTP id u63so92369417wmu.0
        for <linux-wireless@vger.kernel.org>; Sat, 05 Dec 2015 05:22:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5660CC65.3000507@candelatech.com>
References: <5660A31E.3010507@candelatech.com>
	<1449174081.31265.3.camel@sipsolutions.net>
	<5660CC65.3000507@candelatech.com>
Date: Sat, 5 Dec 2015 18:52:29 +0530
Message-ID: <CA+BoTQmU8Wnrazg8M5GFCaONNuZvFveRwe0tAyu9wh8-CXYghA@mail.gmail.com> (sfid-20151205_142235_005603_55D3EA23)
Subject: Re: Can we increase IEEE80211_MAX_QUEUES
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/12/2015, Ben Greear <greearb@candelatech.com> wrote:
> On 12/03/2015 12:21 PM, Johannes Berg wrote:
>> On Thu, 2015-12-03 at 12:16 -0800, Ben Greear wrote:
>>> ath10k wants to use vdev-id as a queue-id, and I want to support up
>>> to
>>> 64 vdevs.  In the 4.2 kernel, this is causing splats when using lots
>>> of
>>> vdevs because then queue is out of range.
>>>
>>> Can we just increase IEEE80211_MAX_QUEUES to 64?
>>>
>>
>> I think not, that would likely cause a lot of data structures to grow
>> too much. We'd have to do more dynamic things in that case, I suppose.
>>
>> Does the original premise even make sense though? A single queue for
>> each vdev seems a bit strange.
>
> Comments in ath10k claim that the approach makes per-vif tx locking
> much easier and that is why that code was added....

This was introduced for qca6174 firmware which can do multi-channel
and can hint host driver to stop/wake tx queues associated per vdev.


Michal
