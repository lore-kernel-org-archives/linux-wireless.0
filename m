Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48503 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab0LHPlE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 10:41:04 -0500
Message-ID: <4CFFA70A.2050307@candelatech.com>
Date: Wed, 08 Dec 2010 07:40:58 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vasanth@Atheros.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"greearb@gmail.com" <greearb@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [PATCH] ath9k: Check for NULL sta in ath_tx_start
References: <1291698829-22765-1-git-send-email-greearb@candelatech.com> <AANLkTik20SkL0Y5gK_ysYpW46gvb73m4h3SDcGb+d_LA@mail.gmail.com> <4CFDC7D8.3080100@candelatech.com> <20101207074237.GA2179@vasanth-laptop> <4CFDE702.3020301@candelatech.com> <20101207083147.GA19720@vasanth-laptop> <4CFE6B42.8000806@candelatech.com> <20101208051745.GA24465@vasanth-laptop>
In-Reply-To: <20101208051745.GA24465@vasanth-laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/07/2010 09:17 PM, Vasanthakumar Thiagarajan wrote:
> On Tue, Dec 07, 2010 at 10:43:38PM +0530, Ben Greear wrote:
>> On 12/07/2010 12:31 AM, Vasanthakumar Thiagarajan wrote:
>>> On Tue, Dec 07, 2010 at 01:19:22PM +0530, Ben Greear wrote:
>>>> On 12/06/2010 11:42 PM, Vasanthakumar Thiagarajan wrote:
>>>>> On Tue, Dec 07, 2010 at 11:06:24AM +0530, Ben Greear wrote:
>>>>>> On 12/06/2010 09:21 PM, Luis R. Rodriguez wrote:
>>>>>>> On Mon, Dec 6, 2010 at 9:13 PM,<greearb@gmail.com>     wrote:
>>>>>>>> From: Ben Greear<greearb@candelatech.com>
>>>>>>>>
>>>>>>>> It can be NULL according to docs, and logging showed it
>>>>>>>> to be NULL in practice.
>>>>>>>>
>>>>>>>> Signed-off-by: Ben Greear<greearb@candelatech.com>
>>>>>>>
>>>>>>> Does this fix an oops? If so can you explain and provide the trace and
>>>>>>> resubmit and cc stable in the commit log?
>>>>>>
>>>>>> I think it fixes the TID corruption I posted about earlier.  It seems
>>>>>> so obvious though, that I'm curious why no one else sees problems,
>>>>>> and why I didn't see more crashes in my setup.
>>>>>>
>>>>>> (The paprd code appears to send with null STA, for instance, and my
>>>>>> printks showed lots of NULL stas in my 16-sta test setup, though I
>>>>>> don't think I'm using the paprd code path.)
>>>>>
>>>>> paprd is used only with>= AR9003.
>>>>
>>>> Whoever coded it up hopefully had that hardware...so why didn't
>>>> they see lots of crashes?
>>>
>>> I myself tested it lot of times, but did not see any crash, weird.
>>
>> Looks like the offending change when in recently (11/4/10, one of Felix's
>> patches).
>>
>> That is probably why no one else is hitting this yet, and it
>> isn't needed for stable I'm guessing....
>
> Nice, care to send a patch?. Yeah, it is not needed for stable.

The same patch I originally posted to to start this thread
should do just fine.

If someone really wants an oops report, I can add an artificial BUG_ON
to catch this, but for whatever reason, it normally just crashes things
weirdly and perhaps sometimes screwed up the file-system, so I'd rather
just have the patch go in as it is..I think it is obviously more correct
than the existing code.

Thanks,
Ben

>
> Vasanth


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
