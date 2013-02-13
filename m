Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:38297 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755164Ab3BMO3I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 09:29:08 -0500
Message-ID: <511BA1E5.40402@neratec.com> (sfid-20130213_152912_671445_E3A50048)
Date: Wed, 13 Feb 2013 15:23:33 +0100
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: start auth/assoc timeout on frame status
References: <1359638935-16613-1-git-send-email-johannes@sipsolutions.net>   (sfid-20130131_142837_609017_1B1D23D2) <1359992600.10311.25.camel@jlt4.sipsolutions.net>  <511B9807.6000200@neratec.com> <1360765274.8868.13.camel@jlt4.sipsolutions.net>
In-Reply-To: <1360765274.8868.13.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/13/2013 03:21 PM, Johannes Berg wrote:
> On Wed, 2013-02-13 at 14:41 +0100, Wojciech Dubowik wrote:
>> There is a regression introduced with this patch.
>> On my ath9k AP + ath9k STA I get timeout for
>> management frames even when they are acked.
>>
>> Attached syslog and iw event before and after
>> this patch.
>>
>> I have seen it before in my testing and it gets
>> a lot worse with system load.  Sometimes it can
>> retry auth/assoc frames for 10 seconds before
>> connecting.
>> Anyway it always looses the first authentication frame.
> I think I see what's happening -- can you try this patch?
>
> http://p.sipsolutions.net/61f4271fed0e446b.txt
>
I have tried and it doesn't do timeout anymore. I will continue
testing with more load.

Thanks,
Wojtek
