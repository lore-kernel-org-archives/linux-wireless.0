Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:60823 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751845AbeA2Wfz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Jan 2018 17:35:55 -0500
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k will not tx packets sometimes.
In-Reply-To: <11a30dfe-842a-8b1e-0d7e-d4159bf4b2bb@candelatech.com>
References: <c383b64d-d028-3d83-f1c1-b4e32ca04c26@candelatech.com> <87a7wzv43j.fsf@toke.dk> <f021a32c-6f12-1cfe-970f-eae7dd334416@candelatech.com> <87d11stk0i.fsf@toke.dk> <11a30dfe-842a-8b1e-0d7e-d4159bf4b2bb@candelatech.com>
Date: Mon, 29 Jan 2018 23:35:52 +0100
Message-ID: <871si81eev.fsf@toke.dk> (sfid-20180129_233600_013845_D9342AE6)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 01/29/2018 01:47 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Ben Greear <greearb@candelatech.com> writes:
>>
>>> On 01/27/2018 05:11 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>> Ben Greear <greearb@candelatech.com> writes:
>>>>
>>>>> I'm doing a test with 200 virtual stations on each of 6 ath9k radios.
>>>>>
>>>>> When I configure stations for DHCP, I see cases where stations on a p=
articular
>>>>> radio will not transmit anything sometimes.  I see no 'XMIT' logs tha=
t show indication of
>>>>> frames being received in the driver from the upper stack, but if I us=
e 'tshark' on
>>>>> a station interface, it shows frames being 'transmitted'.
>>>>>
>>>>> I do, however, see this, which looks like it might show
>>>>> an issue.  It looks like whatever 'aqm' is, it has an ever expanding =
number
>>>>> of backlog packets:
>>>>
>>>> The aqm is the intermediate queues in mac80211. So this indicates that
>>>> the driver is not pulling packets for transmission.
>>>>
>>>> With that many stations, I wonder whether it is due to the airtime
>>>> fairness scheduler throttling the station? What is the contents of
>>>> debug/ieee80211/wiphy2/netdev\:sta30194/stations/00\:0e\:8e\:69\:b8\:f=
7/airtime
>>>> while the station is not transmitting? And is it all stations on that
>>>> particular radio, or only some of them?
>>>
>>> Here is the output of airtime and aqm on a hung station:
>>>
>>> # cat /debug/ieee80211/wiphy0/netdev\:sta10057/stations/00\:0e\:8e\:50\=
:74\:8a/airtime
>>> RX: 83706 us
>>> TX: 4202 us
>>> Deficit: VO: 198 us VI: 300 us BE: -8306 us BK: 300 us
>>
>> Right. This looks like incoming traffic is depleting the airtime quantum
>> faster than it can be replenished by the scheduler, which means that the
>> station gets completely starved.
>>
>> Could you try turning off the airtime scheduler?
>>
>> echo 0 > /sys/kernel/debug/ieee80211/wiphy0/ath9k/airtime_flags
>>
>> and see if the problem goes away.
>>
>> If it does, please check if the problem persists when setting
>> airtime_flags to 1 (which means only include TX airtime).
>>
>> -Toke
>>
>
> That did not seem to help:
>
> # cat /debug/ieee80211/wiphy0/netdev\:sta10058/stations/00\:0e\:8e\:50\:7=
4\:8a/node_aggr
> Max-AMPDU: 65535
> MPDU Density: 8
>
>
> TID  SEQ_START  SEQ_NEXT  BAW_SIZE  BAW_HEAD  BAW_TAIL  BAR_IDX SCHED HAS=
-QUED
>    0          0         0        64         0         0       -1     1   =
     1

Hmm, SCHED and HAS-QUED are both set, so it should be scheduled. Is the
scheduler maybe simply taking too long to get round to scheduling that
station again?

What happens if you don't kill things after 30 seconds? Is it hanging
forever, or just long enough for your tools to lose patience?

If you have 200 stations all requesting DHCP addresses I could see how
things might take a while...

-Toke
