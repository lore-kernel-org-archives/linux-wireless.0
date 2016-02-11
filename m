Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:33325 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbcBKQJh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2016 11:09:37 -0500
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA0E809@hasmsx107.ger.corp.intel.com>
References: <1455199701-25767-1-git-send-email-emmanuel.grumbach@intel.com>
	<1455201038.19473.12.camel@edumazet-glaptop2.roam.corp.google.com>
	<0BA3FCBA62E2DC44AF3030971E174FB32EA0E6FD@hasmsx107.ger.corp.intel.com>
	<1455203555.19473.14.camel@edumazet-glaptop2.roam.corp.google.com>
	<0BA3FCBA62E2DC44AF3030971E174FB32EA0E809@hasmsx107.ger.corp.intel.com>
Date: Thu, 11 Feb 2016 08:09:34 -0800
Message-ID: <CAA93jw5=6zxg8P77VkgDEZFM+u+5zHBuW5ODoWqFV59PoSWtgQ@mail.gmail.com> (sfid-20160211_170955_266820_F397AA0B)
Subject: Re: [PATCH] codel: add forgotten inline to functions in header file
From: Dave Taht <dave.taht@gmail.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 11, 2016 at 7:29 AM, Grumbach, Emmanuel
<emmanuel.grumbach@intel.com> wrote:
>
>
> On 02/11/2016 05:12 PM, Eric Dumazet wrote:
>> On Thu, 2016-02-11 at 15:05 +0000, Grumbach, Emmanuel wrote:
>>
>>
>>> Yeah :) codel_should_drop seemed very long indeed... I wanted to use the
>>> codel_get_time and associated utils (_before, _after) in iwlwifi.
>>> They're better than jiffies... So maybe I can just copy that code to
>>> iwlwifi.

Definately better than jiffies.

>>
>> You certainly can submit a patch adding the inline, but not on all
>> functions present in this file ;)
>>
>> Thanks !
>>
>
> Actually... All I need *has* the inline, but if I include codel.h,
> codel_dequeue is defined but not used and you definitely don't want to
> inline that one. So I guess the only other option I have is to split
> that header file which I don't think is really worth it. So, unless you
> object it, I'll just copy the code.

I think it is best to start with another base implementation of codel
for wifi, yes.

What I think is the currently best performing codel implementation (on
the wire, for ethernet) we have is in:

https://github.com/dtaht/bcake/codel5.h

which has a few differences from eric's implementation (64 bit
timestamps, inlining, not a lot of cpu profiling on it - still aiming
for algorithmic correctness here, it is closer to the original
paper... We'd used a different means of injecting the callback in it,
too)

The one currently in the main cake had issues in the last test round
but has been updated since. (sch_cake is also on github).

In neither case it is the right thing for wifi either.

the "starting plan" such as it was was to get to "one aggregate in the
hardware, one in the driver, one ready to be formed on the completion
interrupt", and pull a smoothed service time from start to completion
interrupt to dynamically modify the codel target. (other headaches,
like multicast, abound).

(It's the per station queue + fq as close to the hardware as possible
that matters most, IMHO.)

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
