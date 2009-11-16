Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.irobot.com ([206.83.81.187]:63368 "EHLO smtp1.irobot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585AbZKPXjA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 18:39:00 -0500
Message-ID: <4B01E298.3030602@irobot.com>
Date: Mon, 16 Nov 2009 15:39:04 -0800
From: Adam Wozniak <awozniak@irobot.com>
MIME-Version: 1.0
To: Derek Smithies <derek@indranet.co.nz>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: Re: Adhoc networking, was Re: compat-wireless and minstrel
References: <4AF0D54D.4090303@irobot.com>  <alpine.DEB.2.00.0911111508391.6214@kauri.acheron.indranet.co.nz>  <4AFC655A.5020706@irobot.com> <200911122103.27455.chunkeey@googlemail.com>  <4AFC8E4F.5090307@irobot.com>  <4AFC8F0D.5020700@irobot.com>  <1258097352.3899.75.camel@johannes.local>  <4AFDDF19.8060202@irobot.com>  <1258191039.6167.40.camel@johannes.local>  <4B018B26.2070008@irobot.com> <1258392453.32159.28.camel@johannes.local> <4B0192A6.9050808@irobot.com> <alpine.DEB.2.00.0911170938380.3829@kauri.acheron.indranet.co.nz> <4B01D4A5.7060204@irobot.com> <alpine.DEB.2.00.0911171156210.3829@kauri.acheron.indranet.co.nz>
In-Reply-To: <alpine.DEB.2.00.0911171156210.3829@kauri.acheron.indranet.co.nz>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems like the code I pointed out earlier in rx.c is certainly wrong 
then; bitrates used in absence of other information should not be 
guessed based on the received rate, but should come instead from the 
BSSID. Correct?

Although, once you start these silly examples, it seems to me like the 
best thing to do is just assume the receiver can handle anything and let 
minstrel sort out what works and what doesn't. This has obvious problems 
for PID and similar rate algorithms.

Derek Smithies wrote:
> Hi,
>
> Referring back to my letter below, you see that when A&B agree on 
> their BSSID, this implies that A&B have agreed on:
>
>>> a)supported rates
>>> b)the value of X, the value of x
>>> c)the channel
>>> d)the ESSSID
>
>
> When B&C start talking, and C adopts the same BSSID as B, then we have 
> (by inference) that C has agreed to the same rates as A. There is no 
> need to pass rate information between C and A.
>
> ===========================
> Ok, now here is a silly example. Suppose C supports bitrates b4,b5 and 
> b6.
>
> B does not support bitrates b4,b5 and b6.
>
> Further, A does support bitrates b4,b5,b6
>
> This could be that B only does 1, 2, 5.5 and 11MBits/sec. But A&C do 
> everything up to 54Mbit/sec.
>
>
> B has caused a problem cause he is deficient (not doing G-Rates)
>
> In one view, B should report that he has all the rates of A. B would 
> then hope that A's rate control algorithm will detect that B cannot do 
> the G-rates. Minstrel will do this fine. Stepup-Stepdown rate 
> algorithms will struggle here if their table is constructed in the 
> wrong order.
>
> For this network, the BSSID defines the basic service set. you cannot 
> have nodes on the same BSSID who report as handling different rate sets.
>
>
>
> Derek.
>
>
>
> On Mon, 16 Nov 2009, Adam Wozniak wrote:
>
>> In your example where A&C can pass data, but not hear each other's 
>> beacons, how is rate information passed between them? ProbeReq/Resp ?
>>
>> Derek Smithies wrote:
>>> Hi,
>>> Statistics is a wonderful thing.
>>> Every node is required to send a beacon at time
>>> X+r, X+x+r, X+2x+r, X+3x+r, ......
>>>
>>> All nodes are agreed on the value of x (which is the beacon interval).
>>> All nodes are agreed on the value of X
>>> r is a random value, and is (from memory) 20 slots long.
>>>
>>> given this, all nodes work (to borrow an analogy from music) in 
>>> time, or beat in sync with each other.
>>>
>>> Now, if a node hears a beacon on its BSSID inside that r period, the 
>>> node will not transmit a beacon. This way, for a 20 node network in 
>>> a room, you should only get 1 (or sometimes 2) beacons transmitted 
>>> every beacon interval.
>>>
>>> If we assume that every node correctly attempts to send a beacon 
>>> somewhere in that period r, and that somewhere is randomly 
>>> distributed, then we will hear a beacon from most nodes, which is 
>>> good enough.
>>>
>>> Consider the case of three nodes, A, B, C.
>>>
>>> A and B are turned on, and create an Adhoc network. A and B agree on
>>> a)supported rates
>>> b)the value of X, the value of x
>>> c)the channel
>>> d)the ESSSID
>>> and so start sending a beacon. Inside this beacon is BSSID. The 
>>> BSSID is a random value. The particular random value used implies 
>>> acceptance of a,b,c,d. Look at the name. Basic Service Set ID. The 
>>> basic service set is the collection of those values a,b,c,d.
>>>
>>> Now, node C is turned on. A is positioned such that A&C cannot 
>>> communicate. However, B can communicate with A&C.
>>>
>>> C is turned on, detects the presence of B, likes B's beacons, and 
>>> agrees on all the settings in B's beacons. In other words, C likes 
>>> and agrees with a,b,c,d.
>>> So C starts sending beacons with the same BSSID as B.
>>> At this point, it does not matter that A cannot set C's beacons. A 
>>> and C have agreed on the BSSID.
>>>
>>> Change the story a little bit.
>>> In this locality, there is often a burst of 1ms of noise every 2ms. 
>>> This means that most beacons are shotdown. However, data packets at 
>>> 54Mbit/sec get through.
>>> A&B saw each others beacons and agreed on a BSSID. C was turned on, 
>>> and agreed with the BSSID of B.
>>>
>>> C sends out data packets, with the BSSID of B. A sees the 
>>> datapackets of C. Since the datapackets of C have A's BSSID, A has 
>>> to accept them.
>>>
>>> Now, you see where this is all going. What is the meaning of a 
>>> beacon containing a BSSID of all zero ?
>>> Further, you see that all nodes do need to send a beacon. This makes 
>>> node discovery a little easier.
>>> Even though A and C cannot see each others beacons, they should 
>>> still communicate as they have the same agreed on BSSID.
>>>
>>> Derek.
>>>
>>>
>>> On Mon, 16 Nov 2009, Adam Wozniak wrote:
>>>
>>>> This assumption seems too stoichastic. Reading 802.11-2007 section 
>>>> 11.1.2.2, it doesn't seem that we're guaranteed to always receive 
>>>> beacons from all stations. Stations will cancel their pending 
>>>> beacon transmission if they receive a beacon before their random 
>>>> delay times out. In the extreme case where the number of stations 
>>>> is very large, it seems possible that you may never hear beacons 
>>>> for some stations.
>>>>
>>>> Johannes Berg wrote:
>>>>> On Mon, 2009-11-16 at 09:25 -0800, Adam Wozniak wrote:
>>>>>
>>>>>> If we have only three stations in an ad-hoc network, where all 
>>>>>> three can hear the other two, only one of them should be 
>>>>>> beaconing, correct? 
>>>>>
>>>>> No, if they all behave correctly beaconing will be distributed.
>>>>>
>>>>> johannes
>>>>>
>>>>
>>>>
>>>>
>>>
>>
>>
>>
>

