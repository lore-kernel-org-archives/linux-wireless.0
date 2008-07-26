Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:58634 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757300AbYGZVLF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jul 2008 17:11:05 -0400
Message-ID: <488B92E3.6050200@lwfinger.net> (sfid-20080726_231109_579067_2E010AEA)
Date: Sat, 26 Jul 2008 16:10:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?Q8OpZHJpYyBBdWdlcg==?= <cedric@grisbi.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: iwl3945 slow for downloading
References: <20080726161140.59041730@grisbi.org>	<488B3969.4050405@openwrt.org>	<488B48C1.6090506@lwfinger.net> <20080726183237.02a1e28e@grisbi.org>
In-Reply-To: <20080726183237.02a1e28e@grisbi.org>
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

C=C3=A9dric Auger wrote:
> Le Sat, 26 Jul 2008 10:54:41 -0500,
> Larry Finger <Larry.Finger@lwfinger.net> a =C3=A9crit :
>=20
>> Felix Fietkau wrote:
>>> I don't know if it helps with debugging this issue, but I've seen
>>> the same on a laptop from a friend of mine (same card).
>>>
>>> After some searching I found that setting the AP to g-only mode
>>> instead of b+g mixed made it work at decent speeds. Another symptom
>>> of this slowdown is that there is typically an unnaturally high
>>> number of retransmissions on the air, which eats up a lot of
>>> airtime.
>>>
>>> I've spent some time looking through the code to find the reason
>>> for this but couldn't find anything yet (maybe somebody from Intel
>>> could help).
>> Just for comparison, my BCM4312 running b43 from the latest
>> wireless-testing gets the following tcpperf throughput:
>>
>> AP Mode          TX          RX
>>
>> Mixed b/g    19.8 MB/s   23.0 MB/s
>> g-only       20.5 MB/s   23.1 MB/s
>>
>> For these tests, the connecting end was wired to the router. The
>> difference in TX speeds was about what I expected - the small
>> difference in RX speeds was not. In any case, if you see a large
>> difference with iwl3945, that would be useful information.
>>
>> You can obtain tcpperf from
>> http://wand.cs.waikato.ac.nz/~stj2/nsc/software.html
>=20
> hello
> thanks for your answers.
> i tried to set my ap to g-only, but i cannot :-( the wifi box is give=
n
> by my provider and it seems cannot be changed...
> so i tried tcpperf, this is the result :
>=20
> cedric:/home/grisbi/tcpperf-1.754# ./tcpperf -c 192.168.0.4 -t 30
> Duration: 30 9482usec
> Bytes sent: 5481472 (5353 kB 5 MB 0 GB)
> Bandwidth: 1461264 b/s (1461.26 kb/s 1.46 Mb/s)
> Close duration: 0s 22usec
>=20
> then i tried to download an image of ubuntu and i had about 900kb/s,
> so very good and i don't understand...  then i tried to send a big fi=
le
> with scp to the other computer, as user and as root, it begins at
> 2,2MB/s and decrease untill 150kb/s and stays between 130-200kb/s
> i did again a tcpperf with -t 300 to check if it's not with the time,
> but i have 1,30MB/s, seems correct.
>=20
> second test :
> i stop the wifi and plug a cable. the second computer is still in wif=
i.
> tcpperf gives me 17Mb/s and the same file with scp is sent with about
> 2,2MB/s...
> so now i really don't understand, from internet, loading work untill
> 900kb/s (ok for me), but beween 2 computers on my network i have max
> 200kb/s...
> hopes this can be usefull

It looks as if your receive rate is a lot higher than the transmit rate=
=2E You can=20
check that by using the computer with the iwl3945 as the server and ini=
tiate=20
tcpperf from the other end.

Larry
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
