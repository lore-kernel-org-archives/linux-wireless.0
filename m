Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34681 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbbFLPWO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2015 11:22:14 -0400
Message-ID: <557AF925.4000609@candelatech.com> (sfid-20150612_172218_501807_D5099CC1)
Date: Fri, 12 Jun 2015 08:22:13 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
CC: Michal Kazior <michal.kazior@tieto.com>,
	ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Question on beacon-miss offloading.
References: <5579F87F.4070601@candelatech.com> <557A1BE9.7070305@candelatech.com> <CA+BoTQkLyaP-2sHiu7Wn-ZzGj2JnZs4qzQKGu7PiTtUy4d9xLQ@mail.gmail.com> <557ADEAB.80504@candelatech.com> <CABPxzYK6LWZW1JWoBBTs_QPWtupU17Pr7w3J-H6=QD1Xd5uLrg@mail.gmail.com>
In-Reply-To: <CABPxzYK6LWZW1JWoBBTs_QPWtupU17Pr7w3J-H6=QD1Xd5uLrg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/12/2015 07:10 AM, Krishna Chaitanya wrote:
> On Fri, Jun 12, 2015 at 6:59 PM, Ben Greear <greearb@candelatech.com> wrote:
>>
>>
>> On 06/11/2015 11:03 PM, Michal Kazior wrote:
>>>
>>> On 12 June 2015 at 01:38, Ben Greear <greearb@candelatech.com> wrote:
>>>>
>>>> On 06/11/2015 02:07 PM, Ben Greear wrote:
>>>>>
>>>>> In my ath10k CT firmware, I am disabling the beacon-miss offloading
>>>>> to save space and because it will not work with lots of virtual
>>>>> stations.
>>>>>
>>>>> But, it must be that I need some way to tell the stack that this
>>>>> feature is not enabled, because when suddenly kill my AP, then
>>>>> the ath10k station connected to it shows endless 'beacon loss' events
>>>>> in 'iw events' output, but it never actually loses connection.
>>>>>
>>>>> Stock firmware works fine, so probably I just need to disable
>>>>> some feature flag when registering the ath10k hardware
>>>>> when using CT firmware.
>>>>>
>>>>> With stock firmware, I see a quick dissassociation due to inactivity.
>>>>>
>>>>> I am having poor luck finding how a driver tells the stack
>>>>> it has beacon miss offload or not, so, does anyone know how
>>>>> this is controlled?
>>>>
>>>>
>>>> I still am not sure why stock firmware works, but it appears
>>>> the reason mine is failing is that the ACK status for mgt frames
>>>> is always set to TRUE since the ath10k wmi-mgt-tx API is so
>>>> lame.  So, mac80211 does a probe, ath10k lies and says it was
>>>> acked, and mac80211 then things all is well for another few
>>>> seconds.
>>>
>>>
>>> mac80211 shouldn't do a Probe Req to an AP on beacon loss because
>>> ath10k advertises it supports tx-status report. Hence mac80211 should
>>> use NullFunc frames which shouldn't go through wmi-mgmt-tx but htt
>>> tx-frm.
>>>
>>> But then again: NullFunc status reporting via htt tx-frm was broken on
>>> 10.1 if memory serves right. I believe it was fixed in 10.2 or 10.2.4.
>>>
>>> This problem has been effectively obscured on stock 10.1 by the
>>> offloaded beacon miss.
>>
>>
>> For what it's worth, I looked at the 4.0.4 ath10k yesterday, and it appears
>> it
>> ignores the message that the 10.1 firmware sends when beacon loss happens
>> anyway.  Maybe I misread the firmware code..it's a pile of indirection.
>>
>> Do you know how the firmware is supposed to signal beacon loss to
>> the host (from the host's perspective).
> 
> Normally driver would advertise IEEE80211_HW_CONNECTION_MONITOR
> to disable mac80211 from tracking connection. and driver should call
> ieee80211_beacon_loss up on receiving beacon loss event from FW
> which triggers disconnection in mac80211.


I do not see any calls to beacon_loss() in the ath10k driver,
so probably that firmware feature is not just fully wired up
to the driver.  Just as well since that firmware feature is
disabled in my (-diet variant) firmware entirely.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

