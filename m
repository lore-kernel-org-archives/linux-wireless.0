Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50629 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab2GIQCn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 12:02:43 -0400
Message-ID: <4FFB009D.7080400@candelatech.com> (sfid-20120709_180258_085752_5B90A744)
Date: Mon, 09 Jul 2012 09:02:37 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: use full power if off-channel
References: <1341740130-6199-1-git-send-email-johannes@sipsolutions.net>   <4FF99A80.9040700@candelatech.com>  <1341822596.4455.6.camel@jlt3.sipsolutions.net>  <4FFAEFCB.2080109@candelatech.com> <1341845721.4455.50.camel@jlt3.sipsolutions.net>
In-Reply-To: <1341845721.4455.50.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/09/2012 07:55 AM, Johannes Berg wrote:
> On Mon, 2012-07-09 at 07:50 -0700, Ben Greear wrote:
>> On 07/09/2012 01:29 AM, Johannes Berg wrote:
>>> On Sun, 2012-07-08 at 07:34 -0700, Ben Greear wrote:
>>>> On 07/08/2012 02:35 AM, Johannes Berg wrote:
>>>>> From: Johannes Berg <johannes.berg@intel.com>
>>>>>
>>>>> Instead of using full power when scanning, use
>>>>> full power when off-channel. This is different
>>>>> since off-channel can be remain-on-channel.
>>>>
>>>> What if we are scanning on our current channel?  Shouldn't
>>>> it be full-power then as well?
>>>
>>> Arguable. If we're on the channel that the AP explicitly told us to use
>>> less power on, and we're not stopping normal traffic, then I'm not sure
>>> we should.
>>
>> Well, if you are scanning, you might be wanting to find other APs that
>> perhaps require full power to reach, so it seems to me it should scan
>> at full power...
>
> Yes, but you're not supposed to send the data packets at the higher
> power. So unless you have per-packet power control you'd be breaking
> your TPC implementation (which is regulatory relevant) if you do
> on-channel scan.
>
> I suppose the other option would be to skip the optimisation in that
> case, but ...

I guess I'd rather keep the scan-on-channel optimization and just tx
at lower power.  Another thing..with your change, we can skip a hardware
config at the start of scan-on-channel since it was only there to configure
the tx power anyway...

In general, I'd like the ability to choose the tx power on a per-packet
basis so that one virtual station could tx at a different power-setting
than another..but I've no time to work on that now, and I'm not sure hardware
would support that kind of thing anyway.

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


