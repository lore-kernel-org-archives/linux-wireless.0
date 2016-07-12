Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41771 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbcGLNV2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2016 09:21:28 -0400
Subject: Re: TCP performance regression in mac80211 triggered by the fq code
To: Dave Taht <dave.taht@gmail.com>,
	make-wifi-fast@lists.bufferbloat.net
References: <11fa6d16-21e2-2169-8d18-940f6dc11dca@nbd.name>
 <CAA93jw6=_pemSUjk3dje1GmnTzrs+=pEdza4j1Wjtrw+VKNdNg@mail.gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>,
	=?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <097af8e4-5393-8e1b-1748-36233e605867@nbd.name> (sfid-20160712_152131_701591_DDEEBDE8)
Date: Tue, 12 Jul 2016 15:21:21 +0200
MIME-Version: 1.0
In-Reply-To: <CAA93jw6=_pemSUjk3dje1GmnTzrs+=pEdza4j1Wjtrw+VKNdNg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-07-12 14:13, Dave Taht wrote:
> On Tue, Jul 12, 2016 at 12:09 PM, Felix Fietkau <nbd@nbd.name> wrote:
>> Hi,
>>
>> With Toke's ath9k txq patch I've noticed a pretty nasty performance
>> regression when running local iperf on an AP (running the txq stuff) to
>> a wireless client.
> 
> Your kernel? cpu architecture?
QCA9558, 720 MHz, running Linux 4.4.14

> What happens when going through the AP to a server from the wireless client?
Will test that next.

> Which direction?
AP->STA, iperf running on the AP. Client is a regular MacBook Pro
(Broadcom).

>> Here's some things that I found:
>> - when I use only one TCP stream I get around 90-110 Mbit/s
> 
> with how much cpu left over?
~20%

>> - when running multiple TCP streams, I get only 35-40 Mbit/s total
> with how much cpu left over?
~30%

> context switch difference between the two tests?
What's the easiest way to track that?

> tcp_limit_output_bytes is?
262144

> got perf?
Need to make a new build for that.

>> - fairness between TCP streams looks completely fine
> 
> A codel will get to long term fairness pretty fast. Packet captures
> from a fq will show much more regular interleaving of packets,
> regardless.
> 
>> - there's no big queue buildup, the code never actually drops any packets
> 
> A "trick" I have been using to observe codel behavior has been to
> enable ecn on server and client, then checking in wireshark for ect(3)
> marked packets.
I verified this with printk. The same issue already appears if I have
just the fq patch (with the codel patch reverted).

>> - if I put a hack in the fq code to force the hash to a constant value
> 
> You could also set "flows" to 1 to keep the hash being generated, but
> not actually use it.
> 
>> (effectively disabling fq without disabling codel), the problem
>> disappears and even multiple streams get proper performance.
> 
> Meaning you get 90-110Mbits ?
Right.

> Do you have a "before toke" figure for this platform?
It's quite similar.

>> Please let me know if you have any ideas.
> 
> I am in berlin, packing hardware...
Nice!

- Felix

