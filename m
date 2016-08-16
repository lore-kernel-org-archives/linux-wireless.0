Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.taht.net ([176.58.107.8]:35857 "EHLO mail.taht.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbcHPXW0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2016 19:22:26 -0400
Subject: Re: [Make-wifi-fast] On the ath9k performance regression with FQ and
 crypto
To: Eric Dumazet <eric.dumazet@gmail.com>,
	=?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>
References: <87pop85tvr.fsf@toke.dk>
 <1471380444.4943.17.camel@edumazet-glaptop3.roam.corp.google.com>
Cc: make-wifi-fast@lists.bufferbloat.net,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
From: =?UTF-8?Q?Dave_T=c3=a4ht?= <dave@taht.net>
Message-ID: <80cb3441-64bc-e1f2-e649-db74c76b5085@taht.net> (sfid-20160817_012229_948797_18D4FCA4)
Date: Wed, 17 Aug 2016 01:16:33 +0200
MIME-Version: 1.0
In-Reply-To: <1471380444.4943.17.camel@edumazet-glaptop3.roam.corp.google.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 8/16/16 10:47 PM, Eric Dumazet wrote:
> 
> Do you have tcpdumps of
> 
> 1) sample with crypto
> 
> 2) sample without crypto.


decrypted aircaps (ssid: borgen-public key: mysecret) for 1 flow and for
2 flows are at:

http://www.taht.net/~d/fqcryptbug/

There are also regular captures...

flent results for all test scenarios comparison graphed here:

http://www.taht.net/~d/fqcryptbug/cryptvsfqwndr3800.svg

Total throughput degrades somewhat relative of the total number of flows
in the crypted scenario - 80 mbits total with one flow. ~35 with 12.

(elsewhere: 120mbit without encryption, with fq, any number of flows,
and you can see codel working at least somewhat)

> 
> Looks like some TCP Small queue interaction with skb->truesize, if GSO
> is involved, or encapsulation adding overhead.

My own suspicion has been around breaking the block ack window, or on
misunderstanding how complex aggregates are hw/sw retried.

> 
> 
> On Tue, 2016-08-16 at 22:41 +0200, Toke Høiland-Jørgensen wrote:
>> So Dave and I have been spending the last couple of days trying to
>> narrow down why there's a performance regression in some cases on ath9k
>> with the softq-FQ patches. Felix first noticed this regression, and LEDE
>> currently carries a patch [1] to disable the FQ portion of the softq
>> patches to avoid it.
>>
>> While we have been able to narrow it down a little bit, no solution has
>> been forthcoming, so this is an attempt to describe the bug in the hope
>> that someone else will have an idea about what could be causing it.
>>
>> What we're seeing is the following (when the access point is running
>> ath9k with the softq patches):
>>
>> When running two or more flows to a station, their combined throughput
>> will be roughly 20-30% lower than the throughput of a single flow to the
>> same station. This happens:
>>
>> - for both TCP and UDP traffic.
>> - independent of the base rate (i.e. signal quality).
>> - but only with crypto enabled (WPA2 CCMP in this case).
>>
>> However, the regression completely disappears if either of the
>> following is true:
>>
>> - no crypto is enabled.
>> - the FQ part of mac80211 is disabled (as in [1]).
>>
>> We have been able to reproduce this behaviour on two different ath9k
>> hardware chips and two different architectures.
>>
>> The cause of the regression seems to be that the aggregates are smaller
>> when there are two flows than when there is only one. Adding debug
>> statements to the aggregate forming code indicates that this is because
>> no more packets are available when the aggregates are built (i.e.
>> ieee80211_tx_dequeue() returns NULL).
>>
>> We have not been able to determine why the queues run empty when this
>> combination of circumstances arise. Since we easily get upwards of 120
>> Mbps of TCP throughput without crypto but with full FQ, it's clearly not
>> the hashing overhead in itself that does it (and the hashing also
>> happens with just one flow, so the overhead is still there). And the
>> crypto itself should be offloaded to hardware (shouldn't it? we do see a
>> marked drop in overall throughput from just enabling crypto), so how
>> would the queueing (say, mixing of packets from different flows)
>> influence that?
>>
>> Does anyone have any ideas? We are stumped...
>>
>> -Toke
>>
>> [1] https://git.lede-project.org/?p=lede/nbd/staging.git;a=blob;f=package/kernel/mac80211/patches/220-fq_disable_hack.patch;h=7f420beea56335d5043de6fd71b5febae3e9bd79;hb=HEAD
>> _______________________________________________
>> Make-wifi-fast mailing list
>> Make-wifi-fast@lists.bufferbloat.net
>> https://lists.bufferbloat.net/listinfo/make-wifi-fast
> 
> 
> _______________________________________________
> Make-wifi-fast mailing list
> Make-wifi-fast@lists.bufferbloat.net
> https://lists.bufferbloat.net/listinfo/make-wifi-fast
> 
