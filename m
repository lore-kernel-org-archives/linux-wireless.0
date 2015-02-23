Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:54936 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbbBWRnm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 12:43:42 -0500
Message-ID: <54EB66CC.1030800@candelatech.com> (sfid-20150223_184345_307787_75924070)
Date: Mon, 23 Feb 2015 09:43:40 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211_hwsim: notify user-space about channel change.
References: <1424217588-29558-1-git-send-email-greearb@candelatech.com>  (sfid-20150218_005956_617537_D2A9B91F) <1424692155.2782.6.camel@sipsolutions.net>
In-Reply-To: <1424692155.2782.6.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/23/2015 03:49 AM, Johannes Berg wrote:
> On Tue, 2015-02-17 at 15:59 -0800, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> The goal is to allow the user-space application to properly
>> filter packets before sending them down to the kernel.  This
>> should more closely mimic what a real piece of hardware would
>> do.
> 
>> + * @HWSIM_CMD_NOTIFY: notify user-space about driver changes.  This is
>> + * designed to help the user-space app better emulate radio hardware.
>> + * This command uses:
>> + *      %HWSIM_ATTR_FREQ # Notify current operating center frequency.
>> + *      %HWSIM_ATTR_ADDR_TRANSMITTER # ID which radio we are notifying about.
>>   * @__HWSIM_CMD_MAX: enum limit
> 
> This seems a bit strange - don't we already tag packets with the
> frequency? Why would you need the channel change separately? What does
> that even mean? Depending on how you use this it could entirely break
> off-channel operation, for example.

I was thinking about passive scans.  In that case, we would not always get a packet transmitted
when the channel changes?

I was thinking user-space would mimic a real radio that can only listen on
one channel at once (can any real radios actually listen on two channels at once?)

So, if we are off-channel, and pkt arrives for the 'main' channel, then
a real radio should drop it, right?

Of course, if user-space does not care, then it can simply ignore the channel-change
logic so I think this would be backwards compat with existing hwsim user-space apps.

Thanks,
Ben

> 
> johannes
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

