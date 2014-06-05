Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34577 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaFEPvk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 11:51:40 -0400
Message-ID: <5390920B.7000903@candelatech.com> (sfid-20140605_175150_176354_82BA9145)
Date: Thu, 05 Jun 2014 08:51:39 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Emmanuel Grumbach <egrumbach@gmail.com>,
	ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Firmware debugging patches?
References: <53891ACD.7070902@candelatech.com> <87wqczz3h9.fsf@kamboji.qca.qualcomm.com> <538CA904.4000508@candelatech.com> <87ioojz1b1.fsf@kamboji.qca.qualcomm.com> <538CB782.1000509@candelatech.com> <538CC68C.10808@gmail.com> <538CC949.5020901@candelatech.com> <CANUX_P2vbKD3zkwE=DvJJWpo=gEMORCBy=XFoC2YSFpmg9sr_A@mail.gmail.com> <538CD507.1050803@candelatech.com> <CANUX_P1iaTtFccraAF_p1dFZ3SJFpdNfF=i=eAVXP8yM3GrM4A@mail.gmail.com> <538F7381.4070100@candelatech.com> <877g4vpq6i.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <877g4vpq6i.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/05/2014 04:10 AM, Kalle Valo wrote:
> Ben Greear <greearb@candelatech.com> writes:
> 
>> On 06/04/2014 12:23 PM, Emmanuel Grumbach wrote:
>>
>>>> Do you have a link to your patch that defines the types you used?
>>>>
>>>
>>> Take a look at 1bd3cbc1a0e9ed977a6bd470c5bc7bd36fd87e26.
>>> But I am adding more and more content to this file.
>>
>> Yeah, after implementing it in ath10k it seems there would
>> be very little over-lap, so probably each driver should just
>> do their own.
>>
>> We can keep the debugfs file names the same, and the udev
>> event types the same, which should help user-space a bit.
> 
> In the future I would actually want to take this a step further and put
> all that to cfg80211. That way the driver would only need to call
> cfg80211_firmware_crashed(wiphy, dump) and cfg80211 will handle the
> rest. This would make sure that all drivers use the exactly same user
> space interfaces and hopefully also motivate other drivers to use it.

Sounds like a good goal, but let's get the drivers well implemented first
while we have flexibility to change the API.  When things are solid, can
move some common functionality upwards in the stack.

For instance, the ath10k can get wedged where even cold resets fail
over and over...I'm thinking that could have it's own uevent so
user-space can know we need a reboot to recover the NIC...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

