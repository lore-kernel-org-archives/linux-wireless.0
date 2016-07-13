Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:35676 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbcGMH5y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 03:57:54 -0400
Received: by mail-oi0-f43.google.com with SMTP id r2so58843830oih.2
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2016 00:57:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA93jw4GQknawtp6Lo3ZM8=qW=p2eTnZ_krC7AvnNbKwp8R5SQ@mail.gmail.com>
References: <11fa6d16-21e2-2169-8d18-940f6dc11dca@nbd.name>
 <CAA93jw6=_pemSUjk3dje1GmnTzrs+=pEdza4j1Wjtrw+VKNdNg@mail.gmail.com>
 <097af8e4-5393-8e1b-1748-36233e605867@nbd.name> <CAA93jw4GQknawtp6Lo3ZM8=qW=p2eTnZ_krC7AvnNbKwp8R5SQ@mail.gmail.com>
From: Dave Taht <dave.taht@gmail.com>
Date: Wed, 13 Jul 2016 09:57:47 +0200
Message-ID: <CAA93jw7y_dp=AMFB3Nj7TK08PXmdypKBnfAZ_FfnWXOt-+aL2Q@mail.gmail.com> (sfid-20160713_095804_360403_B8BBE15E)
Subject: Re: TCP performance regression in mac80211 triggered by the fq code
To: Felix Fietkau <nbd@nbd.name>
Cc: make-wifi-fast@lists.bufferbloat.net,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>,
	=?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 12, 2016 at 4:02 PM, Dave Taht <dave.taht@gmail.com> wrote:
> On Tue, Jul 12, 2016 at 3:21 PM, Felix Fietkau <nbd@nbd.name> wrote:
>> On 2016-07-12 14:13, Dave Taht wrote:
>>> On Tue, Jul 12, 2016 at 12:09 PM, Felix Fietkau <nbd@nbd.name> wrote:
>>>> Hi,
>>>>
>>>> With Toke's ath9k txq patch I've noticed a pretty nasty performance
>>>> regression when running local iperf on an AP (running the txq stuff) to
>>>> a wireless client.
>>>
>>> Your kernel? cpu architecture?
>> QCA9558, 720 MHz, running Linux 4.4.14

So this is a single core at the near-bottom end of the range. I guess
we also should find a MIPS 24c derivative that runs at 400Mhz or so.

What HZ? (I no longer know how much higher HZ settings make any
difference, but I'm usually at NOHZ and 250, rather than 100.)

And all the testing to date was on much higher end multi-cores.

>>> What happens when going through the AP to a server from the wireless client?
>> Will test that next.

Anddddd?

>>
>>> Which direction?
>> AP->STA, iperf running on the AP. Client is a regular MacBook Pro
>> (Broadcom).
>
> There are always 2 wifi chips in play. Like the Sith.
>
>>>> Here's some things that I found:
>>>> - when I use only one TCP stream I get around 90-110 Mbit/s
>>>
>>> with how much cpu left over?
>> ~20%
>>
>>>> - when running multiple TCP streams, I get only 35-40 Mbit/s total
>>> with how much cpu left over?
>> ~30%

To me this implies a contending lock issue, too much work in the irq
handler or too delayed work in the softirq handler....

I thought you were very brave to try and backport this.

>
> Hmm.
>
> Care to try netperf?
>
>>
>>> context switch difference between the two tests?
>> What's the easiest way to track that?
>
> if you have gnu "time" time -v the_process
>
> or:
>
> perf record -e context-switches -ag
>
> or: process /proc/$PID/status for cntx
>
>>> tcp_limit_output_bytes is?
>> 262144
>
> I keep hoping to be able to reduce this to something saner like 4096
> one day. It got bumped to 64k based on bad wifi performance once, and
> then to it's current size to make the Xen folk happier.
>
> The other param I'd like to see fiddled with is tcp_notsent_lowat.
>
> In both cases reductions will increase your context switches but
> reduce memory pressure and lead to a more reactive tcp.
>
> And in neither case I think this is the real cause of this problem.
>
>
>>> got perf?
>> Need to make a new build for that.
>>
>>>> - fairness between TCP streams looks completely fine
>>>
>>> A codel will get to long term fairness pretty fast. Packet captures
>>> from a fq will show much more regular interleaving of packets,
>>> regardless.
>>>
>>>> - there's no big queue buildup, the code never actually drops any packets
>>>
>>> A "trick" I have been using to observe codel behavior has been to
>>> enable ecn on server and client, then checking in wireshark for ect(3)
>>> marked packets.
>> I verified this with printk. The same issue already appears if I have
>> just the fq patch (with the codel patch reverted).
>
> OK. A four flow test "should" trigger codel....
>
> Running out of cpu (or hitting some other bottleneck), without
> loss/marking "should" result in a tcptrace -G and xplot.org of the
> packet capture showing the window continuing to increase....
>
>
>>>> - if I put a hack in the fq code to force the hash to a constant value
>>>
>>> You could also set "flows" to 1 to keep the hash being generated, but
>>> not actually use it.
>>>
>>>> (effectively disabling fq without disabling codel), the problem
>>>> disappears and even multiple streams get proper performance.
>>>
>>> Meaning you get 90-110Mbits ?
>> Right.
>>
>>> Do you have a "before toke" figure for this platform?
>> It's quite similar.
>>
>>>> Please let me know if you have any ideas.
>>>
>>> I am in berlin, packing hardware...
>> Nice!
>>
>> - Felix
>>
>
>
>
> --
> Dave Täht
> Let's go make home routers and wifi faster! With better software!
> http://blog.cerowrt.org



-- 
Dave Täht
Let's go make home routers and wifi faster! With better software!
http://blog.cerowrt.org
