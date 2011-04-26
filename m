Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54907 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab1DZPVg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 11:21:36 -0400
Received: by pzk9 with SMTP id 9so337837pzk.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2011 08:21:36 -0700 (PDT)
Message-ID: <4DB6E2FB.9060701@lwfinger.net> (sfid-20110426_172148_915644_B091FC9B)
Date: Tue, 26 Apr 2011 10:21:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: francesco.gringoli@ing.unibs.it,
	b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: problems with b43 and greedy (UDP) traffic
References: <F77781A1-9992-4893-AA53-8D1FE37D772F@ing.unibs.it>	<4DB09CE6.9020405@lwfinger.net>	<3B553863-8A0A-4B8D-8F51-02FFF4B7A95C@ing.unibs.it> <BANLkTi=xabq-2S_kr2NJjUc8Wk2YzEa-Bg@mail.gmail.com>
In-Reply-To: <BANLkTi=xabq-2S_kr2NJjUc8Wk2YzEa-Bg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/26/2011 09:53 AM, Rafał Miłecki wrote:
> Hi Francesco,
>
> W dniu 26 kwietnia 2011 12:11 użytkownik
> <francesco.gringoli@ing.unibs.it>  napisał:
>> On Apr 21, 2011, at 11:08 PM, Larry Finger wrote:
>>
>>> On 04/21/2011 01:31 PM, francesco.gringoli@ing.unibs.it wrote:
>>>> Hello Michael,
>>>>
>>>> I'm doing experiments sending greedy udp traffic from a b43 station to a b43 access point. I have noticed that switching from 2.6.34-rc7 to 2.6.35 the sendmsg call becomes "almost" non blocking when sending from a Broadcom nic while it is still as usual with other nics.
>>>>
>>>> If I load the channel with a 54Mb/s iperf stream (iperf -b54M ...) on<    2.6.35 I see that the application is blocked times to times when calling sendmsg() so that it is slowed down to the channel capabilities and packets are not internally dropped. Clearly they can still be lost on the air :-)
>>>>
>>>> With>= 2.6.35 the application is never blocked and all the packets exceeding the channel capabilities are internally lost by the kernel: in particular it is the asynchronous tx worker (b43_tx_work) that drops them, since it calls b43_dma_tx even if the interface has been stopped because the dma FIFO queue was full. Apart from packets being lost, the CPU load increases since packets cross all the kernel code, from udp_sendmsg down to b43_dma_tx even if they will be dropped.
>>>>
>>>> I don't think this is the expected behavior on Linux: I did some testing to check what happens with other devices and I can experience only the first behavior on Intel and Atheros WiFi nics as well as on Fast Ethernet nics (in this case I run iperf -b100M :-) independently of the kernel version.
>>>>
>>>> Strangely the b43 sources in 2.6.35 are really similar to those in 2.6.34-rc7 and the differences do not seem to justify the different behavior. There are also other weird observations (like qdisc never used in<    2.6.34-rc7) but I would like to have a first opinion from your side.
>>>>
>>>> Many thanks,
>>>> -Francesco
>>>>
>>>> P.S. what reported does not depend on the firmware version. I also tried a few cards (4306, 4311 and 4318) and nothing changed.
>>>
>>> Francesco,
>>>
>>> I agree that there are no changes in b43 between 2.6.34-rc7 and 2.6.35 that would cause this problem. All but one of the changes are for N PHYs, and that one only removes some braces that are not needed. In addition, there are no changes in ssb that would affect anything other than SPROM loading.
>>>
>>> Have you tried your test with a 2.6.38 kernel? Perhaps the problem has already been fixed. The other thing to do would be to try to bisect between .35 and .34-rc7. If you do that, consider the entire kernel, not just b43. If it is impossible for you to do either of the tests, please send me any command files that you are using, and I'll try it here.
>>>
>>> Larry
>> Hi Larry,
>>
>> I tested SMP kernel and it is affected too. Do you think we should report this as a bug to the kernel bug list? Or could this depend on b43?
>>
>> Unfortunately skb_orphan_try is called before the skb is sent down to the mac80211/driver: it is hence useless setting the "avoid orphan flag" in the skb within the b43 driver as suggested by Thomas. The next packet will have a different flag (I suppose) and it will be orphaned again.
>
> I don't really have big knowledge about net architecture. I believe we
> should try asking patch commiters about this issue. 	Eric Dumazet and
> davem maybe?

Francesco,

Sorry that I have not gotten back to this issue. You said that Intel and Atheros 
cards work the way that b43 did before the orphan_skb patch. Which specific 
driver/card combinations? I suspect that the others are stopping the mac80211 
queues in a way that b43 is not, but I would need to analyze the other code first.

I have Cc'd the wireless-testing mailing list. My suspicion is that this is a 
b43 problem, but the mac80211 gurus might have some ideas.

Larry
