Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:35330 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751373AbeA2Vej (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Jan 2018 16:34:39 -0500
Subject: Re: ath9k will not tx packets sometimes.
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <c383b64d-d028-3d83-f1c1-b4e32ca04c26@candelatech.com>
 <87a7wzv43j.fsf@toke.dk>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <f021a32c-6f12-1cfe-970f-eae7dd334416@candelatech.com> (sfid-20180129_223444_109108_C2BB9FF4)
Date: Mon, 29 Jan 2018 13:34:36 -0800
MIME-Version: 1.0
In-Reply-To: <87a7wzv43j.fsf@toke.dk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/27/2018 05:11 AM, Toke Høiland-Jørgensen wrote:
> Ben Greear <greearb@candelatech.com> writes:
>
>> I'm doing a test with 200 virtual stations on each of 6 ath9k radios.
>>
>> When I configure stations for DHCP, I see cases where stations on a particular
>> radio will not transmit anything sometimes.  I see no 'XMIT' logs that show indication of
>> frames being received in the driver from the upper stack, but if I use 'tshark' on
>> a station interface, it shows frames being 'transmitted'.
>>
>> I do, however, see this, which looks like it might show
>> an issue.  It looks like whatever 'aqm' is, it has an ever expanding number
>> of backlog packets:
>
> The aqm is the intermediate queues in mac80211. So this indicates that
> the driver is not pulling packets for transmission.
>
> With that many stations, I wonder whether it is due to the airtime
> fairness scheduler throttling the station? What is the contents of
> debug/ieee80211/wiphy2/netdev\:sta30194/stations/00\:0e\:8e\:69\:b8\:f7/airtime
> while the station is not transmitting? And is it all stations on that
> particular radio, or only some of them?

Here is the output of airtime and aqm on a hung station:

# cat /debug/ieee80211/wiphy0/netdev\:sta10057/stations/00\:0e\:8e\:50\:74\:8a/airtime
RX: 83706 us
TX: 4202 us
Deficit: VO: 198 us VI: 300 us BE: -8306 us BK: 300 us

# cat /debug/ieee80211/wiphy0/netdev\:sta10057/stations/00\:0e\:8e\:50\:74\:8a/aqm
target 49999us interval 299999us ecn no
tid ac backlog-bytes backlog-packets new-flows drops marks overlimit collisions tx-bytes tx-packets flags
0 2 3476 14 6 0 0 0 8 326 3 0x6(RUN AMPDU NO-AMSDU)
1 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
2 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
3 2 0 0 0 0 0 0 0 0 0 0x0(RUN)
4 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
5 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
6 0 0 0 0 0 0 0 0 0 0 0x0(RUN)
7 0 0 0 4 0 0 0 6 168 7 0x0(RUN)
8 2 0 0 0 0 0 0 0 0 0 0x0(RUN)
9 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
10 3 0 0 0 0 0 0 0 0 0 0x0(RUN)
11 2 0 0 0 0 0 0 0 0 0 0x0(RUN)
12 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
13 1 0 0 0 0 0 0 0 0 0 0x0(RUN)
14 0 0 0 0 0 0 0 0 0 0 0x0(RUN)
15 0 0 0 0 0 0 0 0 0 0 0x0(RUN)


My tool will effectively down/up the interface after 30 seconds if DHCP has not
been acquired...here is another set of debug after that has happened:

# cat /debug/ieee80211/wiphy0/netdev\:sta10057/stations/00\:0e\:8e\:50\:74\:8a/airtime
RX: 0 us
TX: 3946 us
Deficit: VO: 254 us VI: 300 us BE: 300 us BK: 300 us

# cat /debug/ieee80211/wiphy0/netdev\:sta10057/stations/00\:0e\:8e\:50\:74\:8a/aqm
target 49999us interval 299999us ecn no
tid ac backlog-bytes backlog-packets new-flows drops marks overlimit collisions tx-bytes tx-packets flags
0 2 1376 6 2 0 0 0 4 0 0 0x6(RUN AMPDU NO-AMSDU)
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

I was able to reproduce this on a system by configuring "only" 200 stations on
a single ath9k radio, so probably the dedicated individual could reproduce
this on their own system as well.  Stock kernels are less optimized for this, but at least
for ath9k, it should function with multiple virtual station devices...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
