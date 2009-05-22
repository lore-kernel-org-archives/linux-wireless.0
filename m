Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:59491 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbZEVQhr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 12:37:47 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1083522ywb.1
        for <linux-wireless@vger.kernel.org>; Fri, 22 May 2009 09:37:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242964193.8569.42.camel@localhost.localdomain>
References: <60ce8d250905191048t46e3848fw3416ecd793dab9d1@mail.gmail.com>
	 <20090519175336.GF2691@tuxdriver.com>
	 <60ce8d250905200748p5984df0bl1984f0d3bdaf79b5@mail.gmail.com>
	 <1242854588.7048.13.camel@localhost.localdomain>
	 <60ce8d250905211727m71f2d17eice895fa961d82e17@mail.gmail.com>
	 <1242964193.8569.42.camel@localhost.localdomain>
Date: Sat, 23 May 2009 00:37:48 +0800
Message-ID: <60ce8d250905220937n5df48dadt41c4ed7ea459dfa9@mail.gmail.com>
Subject: Re: Throughput is not changed when setting to a much higher bit rate
From: Dongas <dongas86@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/5/22 Dan Williams <dcbw@redhat.com>:
> On Fri, 2009-05-22 at 08:27 +0800, Dongas wrote:
>> 2009/5/21 Dan Williams <dcbw@redhat.com>:
>> > On Wed, 2009-05-20 at 22:48 +0800, Dongas wrote:
>> >> 2009/5/20 John W. Linville <linville@tuxdriver.com>:
>> >> > On Wed, May 20, 2009 at 01:48:32AM +0800, Dongas wrote:
>> >> >
>> >> >> Why the bandwidth is not changed when bit rate is changed to 11Mb/s?
>> >> >> Any thing wrong?
>> >> >
>> >> > More errors at higher bit rate, resulting in more retries?  Just a
>> >> > thought...
>> >> >
>> >> Is there a quick way to verify this possible reason? I'm using Libertas driver.
>> >>
>> >> BTW, my sdio host driver is using polling mode to handle SDIO IRQ.
>> >> Could this be the cause of such poor performance?
>> >
>> > Definitely.  With libertas, the largest class of issues by *far* that
>> > we've seen are controller related.  I seem to recall that I've pulled
>> > about 6Mbps through the card using a normal Ricoh controller from a
>> > Fujitsu laptop.  I can recheck that.
>> >
>>
>> Thanks for your info,Dan.
>> For Libertas driver , do you know which reason would be the cause of
>> the issue i encounterred?
>> Basically if i set the bit rate of Marvell card to a much higher value
>> such as 11Mb/s or even 48Mb/s, the HW should be capable of
>> transferring in hign bit rate.
>> However , the result from iperf indicates that the real bandwidth is
>> remain around 1.1Mbps, even no improvement.
>> It seems Marvell 8686 WiFi module will adjust the bit rate according
>> to the real situation.
>> So the bottleneck would be host side , HW or driver, right?
>> If there a way for me to debug this issue in libertas driver to find
>> out the root reason?
>> If the issue is related to our HW, we would like to take some
>> modifications on it.
>
> Tests with my *unshielded* 8686 dev module with 15 other APs in the
> area, running v9 firmware from the linux-firmware git tree, pulling a
> 240123904 byte file off a host connected via ethernet to a Netgear
> WGR614 802.11g router using WPA-PSK:
>
> HP EliteBook 2530p  (1.40 MB/s)
> ------------------------------
> Core 2 Duo LV 1.86GHz
> 2.6.29.3-140.fc11.x86_64
> Ricoh R5C822 (rev 22)
>
> Fujitsu Lifebook P7230  (1015 KB/s)
> ------------------------------
> Core Duo LV 1.2GHz
> 2.6.29.2-126.fc11.i586
> Ricoh R5C822 (rev 17)
>
> Fujitsu LifeBook P1510  (1.26 MB/s)
> ------------------------------
> Pentium M 1.2GHz
> 2.6.27.15-170.2.24.fc10.i686
> Ricoh R5C822 (rev 13)
>
>
> So that's up to 11Mbps (bursting to 12.5 Mbps) on the Ricoh controller,
> which is a pretty sane, standard SDIO controller on many laptops.
> Unfortunately, all I have to test with are Ricoh controllers...

Thanks for the info you provided , Ricoh controller seems work well
with Libertas.

I think the throughput should be related to the running bit rate of wifi card,
from the command "iwlist eth0 rate", i can see the maximum supported
bit rate of my card is 54Mb/s.However, its default bit rate when
associating with a AP is alway 1Mb/s which seems a little
strange.Thus, i'd like to know how does libertas driver select the
default bit rate for Marvell 8686 card when it associates with a AP?

> In the past, most of the issues we've had are due to the host controller
> used, not really the libertas driver or the chip itself.  Yes, there are
> deficiencies in the driver, but apparently speed isn't one of them when
> it's used in combination with a Ricoh controller on a laptop.  There
> were some questions earlier about speed with embedded controllers being
> correlated to HZ somehow, but I think we took care of that with
> 9b02f419a7dbd956b2c293e5cb1790b6b687f367 in February.
>
I believe the issue may lies on our host side ,either HW or driver and
i'm going to find it out.
Since my host driver is using polling mode to handle SDIO IRQ and the
performance of the adaptive SDIO IRQ polling algorism of Linux SDIO
Stack is related with HZ and high resolution timer, i'm going to check
if our GPTimer driver in kernel supports HRTimer well.

Thanks

Regards
Dongas
