Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zmx1.ing.unibs.it ([192.167.20.248]:55556 "EHLO
	zmx1.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab1D3RMm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 13:12:42 -0400
Subject: Re: problems with b43 and greedy (UDP) traffic
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=utf-8
From: francesco.gringoli@ing.unibs.it
In-Reply-To: <4DB6E2FB.9060701@lwfinger.net>
Date: Sat, 30 Apr 2011 19:03:14 +0200
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Message-Id: <1FC93024-A33D-47CC-95CF-B78D17BBEC0D@ing.unibs.it> (sfid-20110430_191255_249410_D4AE50AB)
References: <F77781A1-9992-4893-AA53-8D1FE37D772F@ing.unibs.it>	<4DB09CE6.9020405@lwfinger.net>	<3B553863-8A0A-4B8D-8F51-02FFF4B7A95C@ing.unibs.it> <BANLkTi=xabq-2S_kr2NJjUc8Wk2YzEa-Bg@mail.gmail.com> <4DB6E2FB.9060701@lwfinger.net>
To: Larry Finger <larry.finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Apr 26, 2011, at 5:21 PM, Larry Finger wrote:

> On 04/26/2011 09:53 AM, Rafał Miłecki wrote:
>> Hi Francesco,
>> 
>> W dniu 26 kwietnia 2011 12:11 użytkownik
>> <francesco.gringoli@ing.unibs.it>  napisał:
>>> On Apr 21, 2011, at 11:08 PM, Larry Finger wrote:
>>> 
>>>> On 04/21/2011 01:31 PM, francesco.gringoli@ing.unibs.it wrote:
>>>>> Hello Michael,
>>>>> 
>>>>> I'm doing experiments sending greedy udp traffic from a b43 station to a b43 access point. I have noticed that switching from 2.6.34-rc7 to 2.6.35 the sendmsg call becomes "almost" non blocking when sending from a Broadcom nic while it is still as usual with other nics.
>>>>> 
>>>>> If I load the channel with a 54Mb/s iperf stream (iperf -b54M ...) on<    2.6.35 I see that the application is blocked times to times when calling sendmsg() so that it is slowed down to the channel capabilities and packets are not internally dropped. Clearly they can still be lost on the air :-)
>>>>> 
>>>>> With>= 2.6.35 the application is never blocked and all the packets exceeding the channel capabilities are internally lost by the kernel: in particular it is the asynchronous tx worker (b43_tx_work) that drops them, since it calls b43_dma_tx even if the interface has been stopped because the dma FIFO queue was full. Apart from packets being lost, the CPU load increases since packets cross all the kernel code, from udp_sendmsg down to b43_dma_tx even if they will be dropped.
>>>>> 
>>>>> I don't think this is the expected behavior on Linux: I did some testing to check what happens with other devices and I can experience only the first behavior on Intel and Atheros WiFi nics as well as on Fast Ethernet nics (in this case I run iperf -b100M :-) independently of the kernel version.
>>>>> 
>>>>> Strangely the b43 sources in 2.6.35 are really similar to those in 2.6.34-rc7 and the differences do not seem to justify the different behavior. There are also other weird observations (like qdisc never used in<    2.6.34-rc7) but I would like to have a first opinion from your side.
>>>>> 
>>>>> Many thanks,
>>>>> -Francesco
>>>>> 
>>>>> P.S. what reported does not depend on the firmware version. I also tried a few cards (4306, 4311 and 4318) and nothing changed.
>>>> 
>>>> Francesco,
>>>> 
>>>> I agree that there are no changes in b43 between 2.6.34-rc7 and 2.6.35 that would cause this problem. All but one of the changes are for N PHYs, and that one only removes some braces that are not needed. In addition, there are no changes in ssb that would affect anything other than SPROM loading.
>>>> 
>>>> Have you tried your test with a 2.6.38 kernel? Perhaps the problem has already been fixed. The other thing to do would be to try to bisect between .35 and .34-rc7. If you do that, consider the entire kernel, not just b43. If it is impossible for you to do either of the tests, please send me any command files that you are using, and I'll try it here.
>>>> 
>>>> Larry
>>> Hi Larry,
>>> 
>>> I tested SMP kernel and it is affected too. Do you think we should report this as a bug to the kernel bug list? Or could this depend on b43?
>>> 
>>> Unfortunately skb_orphan_try is called before the skb is sent down to the mac80211/driver: it is hence useless setting the "avoid orphan flag" in the skb within the b43 driver as suggested by Thomas. The next packet will have a different flag (I suppose) and it will be orphaned again.
>> 
>> I don't really have big knowledge about net architecture. I believe we
>> should try asking patch commiters about this issue. 	Eric Dumazet and
>> davem maybe?
> 
> Francesco,
> 
> Sorry that I have not gotten back to this issue. You said that Intel and Atheros cards work the way that b43 did before the orphan_skb patch. Which specific driver/card combinations? I suspect that the others are stopping the mac80211 queues in a way that b43 is not, but I would need to analyze the other code first.
Hi Larry,

oops, I should include cc in my filters. I was not checking the b43-dev since a few days.

Atheros:  TP-Link, TL_WN821N, it is a USB stick based on ar9170 chipset. I tested with ar9170 driver. I works as expected also with >=2.6.35
Intel: ipw2200 b/g but I can't now check the exact model. I used the iw2200 driver. Works as expected also with >=2.6.35.

About stopping the queues: I believe there is a code design mismatch in the b43 source. It is the b43_tx_work code, in fact, responsible to send packet to the board: after 2.6.31.14 when mac80211 calls b43_op_tx, packets are simply queueud. Unfortunately the worker does its job without checking the state of the dma, and when dma is stopped, all packets are dropped ultimately by b43_dma_tx. This should not happen, so that packets are kept in the device queue, and new packets from the upper layers are simply enqueued in the qdisc.

I tried to set up a check in the while loop inside b43_tx_work but if I stop sending packets before the queue is empty because the dma is stopped, then the worker is never called again. The station loses the association and the interface dies (though there is no crash). Actually I don't really know how the work_queue code style works.

Many thanks,
-Francesco

> 
> I have Cc'd the wireless-testing mailing list. My suspicion is that this is a b43 problem, but the mac80211 gurus might have some ideas.
> 
> Larry

