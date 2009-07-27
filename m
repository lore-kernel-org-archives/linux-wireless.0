Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:3305 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbZG0PUI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 11:20:08 -0400
Message-ID: <4A6DC59E.4000703@tpi.com>
Date: Mon, 27 Jul 2009 09:19:58 -0600
From: Tim Gardner <timg@tpi.com>
Reply-To: timg@tpi.com
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: mjg@redhat.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] dell-laptop: Fix rfkill state setting
References: <20090727144747.E7F4EF891B@sepang.rtg.net> <1248707418.8500.1.camel@johannes.local>
In-Reply-To: <1248707418.8500.1.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Mon, 2009-07-27 at 08:47 -0600, Tim Gardner wrote:
>> Matthew,
>>
>> I think the rfkill state change logic is inverted. I've tried the original
>> code on 3 different Dell models. Once 'rfkill block all' is run, then you
>> can never unblock 'dell-wifi: Wireless LAN'. With this change you can get
>> it unblocked, but you need to run 'rfkill unblock all' twice (which is
>> likely an issue with rfkill).
>>
>> rtg
>>
>> From 778aec563a251418e455d63f711aab1c936bff73 Mon Sep 17 00:00:00 2001
>> From: Tim Gardner <tim.gardner@canonical.com>
>> Date: Mon, 27 Jul 2009 08:30:54 -0600
>> Subject: [PATCH] UBUNTU: [Upstream] dell-laptop: Fix rfkill state setting.
>>
>> rfkill enable/disable transitions are predicated on the state of the
>> external hardware switch, i.e., if the external switch is in the on position,
>> then no rfkill state transitions are allowed.
>>
>> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
>> ---
>>  drivers/platform/x86/dell-laptop.c |    7 +++++--
>>  1 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
>> index 74909c4..cf40c4e 100644
>> --- a/drivers/platform/x86/dell-laptop.c
>> +++ b/drivers/platform/x86/dell-laptop.c
>> @@ -197,8 +197,11 @@ static void dell_rfkill_query(struct rfkill *rfkill, void *data)
>>  	dell_send_request(&buffer, 17, 11);
>>  	status = buffer.output[1];
>>  
>> -	if (status & BIT(bit))
>> -		rfkill_set_hw_state(rfkill, !!(status & BIT(16)));
>> +	/*
>> +	 * Don't change state unless the read-only HW rfkill switch is disabled.
>> +	 */
>> +	if (status & BIT(16))
>> +		rfkill_set_hw_state(rfkill, !!(status & BIT(bit)));
> 
> Hmm. The previous code was
> 
> -       if (status & (1<<16))
> -               new_state = RFKILL_STATE_SOFT_BLOCKED;
> -
> -       if (status & (1<<bit))
> -               *state = new_state;
> -       else
> -               *state = RFKILL_STATE_UNBLOCKED;
> -
> -       return 0;
> 
> where new_state was initialised to RFKILL_STATE_HARD_BLOCKED.
> 
> So doesn't that mean that 1<<bit is the hard-block bit? Or was the
> previous code just bogus, but happened to work since rfkill didn't
> separate the hard/soft kill concepts?
> 
> johannes

I'm not as familiar with the semantics of soft/hard block in the
previous incarnation of rfkill, but the above code kind of looks
correct. At least the transmitter states are forced to blocked if the
rfkill switch is enabled.

rtg
-- 
Tim Gardner timg@tpi.com www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357
