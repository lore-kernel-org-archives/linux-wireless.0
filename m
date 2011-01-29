Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55291 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab1A2A6f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 19:58:35 -0500
Message-ID: <4D436634.3070506@candelatech.com>
Date: Fri, 28 Jan 2011 16:58:28 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Daniel Halperin <dhalperi@cs.washington.edu>
CC: linux-wireless@vger.kernel.org
Subject: Re: hti->control_chan is 15??
References: <4D4345A8.6060806@candelatech.com> <4D435D76.2040703@candelatech.com> <AANLkTimji+Y0KfDCzWDX63KfOjRFzxgKbVAq6HhMcw20@mail.gmail.com> <4D4362BF.7050208@candelatech.com> <AANLkTimG05o=y2xGXh0YAmRqbuixifKp7xgmU7sH61Uf@mail.gmail.com>
In-Reply-To: <AANLkTimG05o=y2xGXh0YAmRqbuixifKp7xgmU7sH61Uf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/28/2011 04:48 PM, Daniel Halperin wrote:
> On Fri, Jan 28, 2011 at 4:43 PM, Ben Greear<greearb@candelatech.com>  wrote:
>> My AP is an off-the-shelf Netgear:
>> WNDR3700
>>
>> It's only rate configuration option is '300Mbps', which appears to
>> turn on HT40.
>>
>> It is configured for channel 10 (for the packet capture) and actually
>> passes traffic there.  It's just this HT Info thing with (primary-channel ==
>> (real_channel + 4))
>> that seems wrong.  Note that when I had the channel set to 11, it was
>> reporting
>> 15 for the primary channel in the HT info.
>>
>> Looks like a bug in that AP to me...but would be nice if there were a way to
>> work around it, in case others have similar issues.
>
> Set it to channel 6, then?

It will still fail the control_chan test and so HT will not be enabled.

That's the symptom I've been chasing all day...just turns out that
the cause, for once, appears to not be my system :)

I'll look into adding a hack to allow HT to be enabled
if the channel is off-by-4.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

