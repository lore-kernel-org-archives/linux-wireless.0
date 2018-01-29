Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:35752 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751574AbeA2Vy2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Jan 2018 16:54:28 -0500
Subject: Re: ath9k will not tx packets sometimes.
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <c383b64d-d028-3d83-f1c1-b4e32ca04c26@candelatech.com>
 <87a7wzv43j.fsf@toke.dk>
 <f021a32c-6f12-1cfe-970f-eae7dd334416@candelatech.com>
 <87d11stk0i.fsf@toke.dk>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <11a30dfe-842a-8b1e-0d7e-d4159bf4b2bb@candelatech.com> (sfid-20180129_225432_578712_E9BF429A)
Date: Mon, 29 Jan 2018 13:54:25 -0800
MIME-Version: 1.0
In-Reply-To: <87d11stk0i.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/29/2018 01:47 PM, Toke Høiland-Jørgensen wrote:
> Ben Greear <greearb@candelatech.com> writes:
>
>> On 01/27/2018 05:11 AM, Toke Høiland-Jørgensen wrote:
>>> Ben Greear <greearb@candelatech.com> writes:
>>>
>>>> I'm doing a test with 200 virtual stations on each of 6 ath9k radios.
>>>>
>>>> When I configure stations for DHCP, I see cases where stations on a particular
>>>> radio will not transmit anything sometimes.  I see no 'XMIT' logs that show indication of
>>>> frames being received in the driver from the upper stack, but if I use 'tshark' on
>>>> a station interface, it shows frames being 'transmitted'.
>>>>
>>>> I do, however, see this, which looks like it might show
>>>> an issue.  It looks like whatever 'aqm' is, it has an ever expanding number
>>>> of backlog packets:
>>>
>>> The aqm is the intermediate queues in mac80211. So this indicates that
>>> the driver is not pulling packets for transmission.
>>>
>>> With that many stations, I wonder whether it is due to the airtime
>>> fairness scheduler throttling the station? What is the contents of
>>> debug/ieee80211/wiphy2/netdev\:sta30194/stations/00\:0e\:8e\:69\:b8\:f7/airtime
>>> while the station is not transmitting? And is it all stations on that
>>> particular radio, or only some of them?
>>
>> Here is the output of airtime and aqm on a hung station:
>>
>> # cat /debug/ieee80211/wiphy0/netdev\:sta10057/stations/00\:0e\:8e\:50\:74\:8a/airtime
>> RX: 83706 us
>> TX: 4202 us
>> Deficit: VO: 198 us VI: 300 us BE: -8306 us BK: 300 us
>
> Right. This looks like incoming traffic is depleting the airtime quantum
> faster than it can be replenished by the scheduler, which means that the
> station gets completely starved.
>
> Could you try turning off the airtime scheduler?
>
> echo 0 > /sys/kernel/debug/ieee80211/wiphy0/ath9k/airtime_flags
>
> and see if the problem goes away.
>
> If it does, please check if the problem persists when setting
> airtime_flags to 1 (which means only include TX airtime).
>
> -Toke
>

That did not seem to help:

# cat /debug/ieee80211/wiphy0/netdev\:sta10058/stations/00\:0e\:8e\:50\:74\:8a/node_aggr
Max-AMPDU: 65535
MPDU Density: 8


TID  SEQ_START  SEQ_NEXT  BAW_SIZE  BAW_HEAD  BAW_TAIL  BAR_IDX SCHED HAS-QUED
   0          0         0        64         0         0       -1     1        1

# cat /debug/ieee80211/wiphy0/netdev\:sta10058/stations/00\:0e\:8e\:50\:74\:8a/airtime
RX: 0 us
TX: 4682 us
Deficit: VO: 300 us VI: 300 us BE: 300 us BK: 300 us

# cat /debug/ieee80211/wiphy0/netdev\:sta10058/stations/00\:0e\:8e\:50\:74\:8a/aqm
target 49999us interval 299999us ecn no
tid ac backlog-bytes backlog-packets new-flows drops marks overlimit collisions tx-bytes tx-packets flags
0 2 2406 11 3 0 0 0 7 0 0 0x6(RUN AMPDU NO-AMSDU)
1 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
2 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
3 2 0 0 0 0 0 0 0 0 0 0x0(RUN)
4 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
5 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
6 0 0 0 0 0 0 0 0 0 0 0x0(RUN)
7 0 0 0 12 0 0 0 13 312 13 0x0(RUN)
8 2 0 0 0 0 0 0 0 0 0 0x0(RUN)
9 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
10 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
11 2 0 0 0 0 0 0 0 0 0 0x0(RUN)
12 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
13 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
14 0 0 0 0 0 0 0 0 0 0 0x0(RUN)
15 0 0 0 0 0 0 0 0 0 0 0x0(RUN)


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
