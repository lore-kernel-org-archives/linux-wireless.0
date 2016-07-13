Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42992 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbcGMIxR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 04:53:17 -0400
Subject: Re: TCP performance regression in mac80211 triggered by the fq code
To: Dave Taht <dave.taht@gmail.com>
References: <11fa6d16-21e2-2169-8d18-940f6dc11dca@nbd.name>
 <CAA93jw6=_pemSUjk3dje1GmnTzrs+=pEdza4j1Wjtrw+VKNdNg@mail.gmail.com>
 <097af8e4-5393-8e1b-1748-36233e605867@nbd.name>
 <CAA93jw4GQknawtp6Lo3ZM8=qW=p2eTnZ_krC7AvnNbKwp8R5SQ@mail.gmail.com>
 <CAA93jw7y_dp=AMFB3Nj7TK08PXmdypKBnfAZ_FfnWXOt-+aL2Q@mail.gmail.com>
Cc: make-wifi-fast@lists.bufferbloat.net,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>,
	=?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <cac14ead-1af5-ff1d-5b35-592933882aae@nbd.name> (sfid-20160713_105353_010396_90EBEEBF)
Date: Wed, 13 Jul 2016 10:53:08 +0200
MIME-Version: 1.0
In-Reply-To: <CAA93jw7y_dp=AMFB3Nj7TK08PXmdypKBnfAZ_FfnWXOt-+aL2Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-07-13 09:57, Dave Taht wrote:
> On Tue, Jul 12, 2016 at 4:02 PM, Dave Taht <dave.taht@gmail.com> wrote:
>> On Tue, Jul 12, 2016 at 3:21 PM, Felix Fietkau <nbd@nbd.name> wrote:
>>> On 2016-07-12 14:13, Dave Taht wrote:
>>>> On Tue, Jul 12, 2016 at 12:09 PM, Felix Fietkau <nbd@nbd.name> wrote:
>>>>> Hi,
>>>>>
>>>>> With Toke's ath9k txq patch I've noticed a pretty nasty performance
>>>>> regression when running local iperf on an AP (running the txq stuff) to
>>>>> a wireless client.
>>>>
>>>> Your kernel? cpu architecture?
>>> QCA9558, 720 MHz, running Linux 4.4.14
> 
> So this is a single core at the near-bottom end of the range. I guess
> we also should find a MIPS 24c derivative that runs at 400Mhz or so.
> 
> What HZ? (I no longer know how much higher HZ settings make any
> difference, but I'm usually at NOHZ and 250, rather than 100.)
> 
> And all the testing to date was on much higher end multi-cores.
> 
>>>> What happens when going through the AP to a server from the wireless client?
>>> Will test that next.
> 
> Anddddd?
Single stream: 130 Mbit/s, 70% idle
Two streams: 50-80 Mbit/s (wildly fluctuating), 73% idle.

>>>> Which direction?
>>> AP->STA, iperf running on the AP. Client is a regular MacBook Pro
>>> (Broadcom).
>>
>> There are always 2 wifi chips in play. Like the Sith.
>>
>>>>> Here's some things that I found:
>>>>> - when I use only one TCP stream I get around 90-110 Mbit/s
>>>>
>>>> with how much cpu left over?
>>> ~20%
>>>
>>>>> - when running multiple TCP streams, I get only 35-40 Mbit/s total
>>>> with how much cpu left over?
>>> ~30%
> 
> To me this implies a contending lock issue, too much work in the irq
> handler or too delayed work in the softirq handler....
> 
> I thought you were very brave to try and backport this.
I don't think this has anything to do with contending locks, CPU
utilization, etc. The code does something to the packets that TCP really
doesn't like.

- Felix
