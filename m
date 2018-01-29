Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:58417 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751690AbeA2Vr2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Jan 2018 16:47:28 -0500
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k will not tx packets sometimes.
In-Reply-To: <f021a32c-6f12-1cfe-970f-eae7dd334416@candelatech.com>
References: <c383b64d-d028-3d83-f1c1-b4e32ca04c26@candelatech.com> <87a7wzv43j.fsf@toke.dk> <f021a32c-6f12-1cfe-970f-eae7dd334416@candelatech.com>
Date: Mon, 29 Jan 2018 22:47:25 +0100
Message-ID: <87d11stk0i.fsf@toke.dk> (sfid-20180129_224732_940909_4C6E6498)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 01/27/2018 05:11 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Ben Greear <greearb@candelatech.com> writes:
>>
>>> I'm doing a test with 200 virtual stations on each of 6 ath9k radios.
>>>
>>> When I configure stations for DHCP, I see cases where stations on a par=
ticular
>>> radio will not transmit anything sometimes.  I see no 'XMIT' logs that =
show indication of
>>> frames being received in the driver from the upper stack, but if I use =
'tshark' on
>>> a station interface, it shows frames being 'transmitted'.
>>>
>>> I do, however, see this, which looks like it might show
>>> an issue.  It looks like whatever 'aqm' is, it has an ever expanding nu=
mber
>>> of backlog packets:
>>
>> The aqm is the intermediate queues in mac80211. So this indicates that
>> the driver is not pulling packets for transmission.
>>
>> With that many stations, I wonder whether it is due to the airtime
>> fairness scheduler throttling the station? What is the contents of
>> debug/ieee80211/wiphy2/netdev\:sta30194/stations/00\:0e\:8e\:69\:b8\:f7/=
airtime
>> while the station is not transmitting? And is it all stations on that
>> particular radio, or only some of them?
>
> Here is the output of airtime and aqm on a hung station:
>
> # cat /debug/ieee80211/wiphy0/netdev\:sta10057/stations/00\:0e\:8e\:50\:7=
4\:8a/airtime
> RX: 83706 us
> TX: 4202 us
> Deficit: VO: 198 us VI: 300 us BE: -8306 us BK: 300 us

Right. This looks like incoming traffic is depleting the airtime quantum
faster than it can be replenished by the scheduler, which means that the
station gets completely starved.

Could you try turning off the airtime scheduler?

echo 0 > /sys/kernel/debug/ieee80211/wiphy0/ath9k/airtime_flags

and see if the problem goes away.

If it does, please check if the problem persists when setting
airtime_flags to 1 (which means only include TX airtime).

-Toke
