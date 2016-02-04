Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:36309 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbcBDMvG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 07:51:06 -0500
Received: by mail-wm0-f44.google.com with SMTP id p63so210243167wmp.1
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2016 04:51:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABPxzYK5oHJOzX=s0=VzGRqX+M7kvfVHtQOPTRyD_TFtnKFruw@mail.gmail.com>
References: <CABPxzY+HpP=NTrAaUEzV5nFm=LK93m=kxPV14-cdftt+VPsWNw@mail.gmail.com>
	<CA+BoTQ=s_SMgs9zkgYjKOHKDwRORWk-Re7XZ=AiKiHCuNc0L8A@mail.gmail.com>
	<CABPxzYJRS8fLzxPiy1J4jKRvgVaS-OCKK08_bjP2Amo_V54pPA@mail.gmail.com>
	<CA+BoTQ=Dg11cP+TJ2_ZkMnjqma62we-JKNWMx8RHJX7ORnvc1A@mail.gmail.com>
	<CABPxzYKuja-X4DHqgcRkK=bRR0aUAyFz1LvB57-64pdcbqHUyQ@mail.gmail.com>
	<CABPxzYK5oHJOzX=s0=VzGRqX+M7kvfVHtQOPTRyD_TFtnKFruw@mail.gmail.com>
Date: Thu, 4 Feb 2016 13:51:04 +0100
Message-ID: <CA+BoTQkEonFDujoVYOJ+ByeRK3w1pCgbfL+Z4FOVt5TK1PcM5g@mail.gmail.com> (sfid-20160204_135111_122601_820FCEA5)
Subject: Re: mac80211_hwsim + iperf + netns
From: Michal Kazior <michal.kazior@tieto.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 February 2016 at 13:46, Krishna Chaitanya <chaitanya.mgit@gmail.com> wrote:
> On Thu, Feb 4, 2016 at 5:57 PM, Krishna Chaitanya
> <chaitanya.mgit@gmail.com> wrote:
>> On Thu, Feb 4, 2016 at 5:23 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
>>> On 4 February 2016 at 12:49, Krishna Chaitanya <chaitanya.mgit@gmail.com> wrote:
>>>> On Thu, Feb 4, 2016 at 5:02 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
>>>>> On 4 February 2016 at 12:22, Krishna Chaitanya <chaitanya.mgit@gmail.com> wrote:
>>>>>> Hi All,
>>>>>>
>>>>>> I am trying to run some iperf tests using mac80211_hwsim b/w AP and STA.
>>>>>> Even after tweaking the routing table, the packets are still not going through
>>>>>> mac80211_hwsim instead they are just looping back.
>>>>>>
>>>>>> After a quick search i found that we should use different network namespaces.
>>>>>> Can anyone tell me the exact procedure for this? I have found a procedure
>>>>>> in the below link, but i dont have the lxc-unshare for my embedded box.
>>>>>> Is there any alternate way for this.
>>>>>
>>>>> If you have a recent enough iproute2 package you can use:
>>>> Unfortunately i dont, will try to get the latest.
>>>>>  ip netns add ns1
>>>>>  ip netns exec ns1 bash # get the PID in the session and don't close it
>>>>>  iw phy phyX set netns $pid_of_that_shell
>>>>>  # you can close the bash now; phyX will remain in ns1
>>>>>
>>>>> Or you could try using ipv6 link-local addresses which will not
>>>>> require you to use namespaces at all.
>>>> Tried this but still not able to excite mac80211_hwsim TX path.
>>>> below are commands and config.
>>>>
>>>> wlan0     Link encap:Ethernet  HWaddr 02:00:00:00:00:00
>>>>           inet addr:10.0.0.1  Bcast:10.255.255.255  Mask:255.0.0.0
>>>>           inet6 addr: fe80::ff:fe00:0/64 Scope:Link
>>>>           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>>>>           RX packets:8 errors:0 dropped:1 overruns:0 frame:0
>>>>           TX packets:38 errors:0 dropped:0 overruns:0 carrier:0
>>>>           collisions:0 txqueuelen:1000
>>>>           RX bytes:648 (648.0 B)  TX bytes:3680 (3.5 KiB)
>>>>
>>>> wlan1     Link encap:Ethernet  HWaddr 02:00:00:00:01:00
>>>>           inet addr:20.0.0.1  Bcast:20.255.255.255  Mask:255.0.0.0
>>>>           inet6 addr: fe80::ff:fe00:100/64 Scope:Link
>>>>           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>>>>           RX packets:3 errors:0 dropped:0 overruns:0 frame:0
>>>>           TX packets:8 errors:0 dropped:0 overruns:0 carrier:0
>>>>           collisions:0 txqueuelen:1000
>>>>           RX bytes:126 (126.0 B)  TX bytes:808 (808.0 B)
>>>>
>>>> iperf -s  -B fe80::ff:fe00:0 &
>>>> iperf -c fe80::ff:fe00:0 -B fe80::ff:fe00:100 -t 60 -i 1
>>>>
>>>> Something wrong?
>>>
>>> For link-local addresses you must specify interface you want to use them.
>>>
>>> Also, there's an iperf switch to understand ipv6 "-V".
>>>
>>>  iperf -V -i1 -s
>>>  iperf -V -i1 -c fe80::ff:fe00:0%wlan1
>>>  iperf -V -i1 -c fe80::ff:fe00:100%wlan0
>>>
>> Thanks a lot Michal. It worked like a charm.
> Whenever i use the iperf -c, it starts a bi-directional stream,
> How do i limit it to only for single direction?
>
> #  iperf -V -i1 -c fe80::ff:fe00:0%wlan1
> ------------------------------------------------------------
> Client connecting to fe80::ff:fe00:0%wlan1, TCP port 5001
> TCP window size: 43.8 KByte (default)
> ------------------------------------------------------------
> [  3] local fe80::ff:fe00:100 port 34808 connected with
> fe80::ff:fe00:0 port 5001
> [  5] local fe80::ff:fe00:0 port 5001 connected with fe80::ff:fe00:100
> port 34808

Hmm.. Are you perhaps running `iperf -V -i1 -s &` (i.e. in the
background) with the same stdout as the client :-) You're probably
just seeing both the server and the client saying a connection has
established at their ends.


Michał
