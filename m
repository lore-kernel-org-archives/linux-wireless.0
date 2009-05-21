Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:51012 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230AbZEUAA1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 20:00:27 -0400
Received: by yx-out-2324.google.com with SMTP id 3so479705yxj.1
        for <linux-wireless@vger.kernel.org>; Wed, 20 May 2009 17:00:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242854588.7048.13.camel@localhost.localdomain>
References: <60ce8d250905191048t46e3848fw3416ecd793dab9d1@mail.gmail.com>
	 <20090519175336.GF2691@tuxdriver.com>
	 <60ce8d250905200748p5984df0bl1984f0d3bdaf79b5@mail.gmail.com>
	 <1242854588.7048.13.camel@localhost.localdomain>
Date: Thu, 21 May 2009 08:00:28 +0800
Message-ID: <60ce8d250905201700v13fe1394l6a9704bb02be3807@mail.gmail.com>
Subject: Re: Throughput is not changed when setting to a much higher bit rate
From: Dongas <dongas86@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/5/21 Dan Williams <dcbw@redhat.com>:
> On Wed, 2009-05-20 at 22:48 +0800, Dongas wrote:
>> 2009/5/20 John W. Linville <linville@tuxdriver.com>:
>> > On Wed, May 20, 2009 at 01:48:32AM +0800, Dongas wrote:
>> >
>> >> Why the bandwidth is not changed when bit rate is changed to 11Mb/s?
>> >> Any thing wrong?
>> >
>> > More errors at higher bit rate, resulting in more retries?  Just a
>> > thought...
>> >
>> Is there a quick way to verify this possible reason? I'm using Libertas driver.
>>
>> BTW, my sdio host driver is using polling mode to handle SDIO IRQ.
>> Could this be the cause of such poor performance?
>
> Definitely.  With libertas, the largest class of issues by *far* that
> we've seen are controller related.  I seem to recall that I've pulled
> about 6Mbps through the card using a normal Ricoh controller from a
> Fujitsu laptop.  I can recheck that.

AFAIK, most old laptop ,including my x61, doesn't support SDIO in HW.
So did Ricoh controller you tested use polling mode to handle SDIO IRQ?
Which clock of controller and which bit rate did you test?

>> (However I just can't believe the performance is so poor ,only around
>> 1.1Mbps, with polling mode of SDIO IRQ)
>
> What specific kernel version are you using?  There have been some
> latency fixes in recent kernels, but would be good to know just to make
> sure.

I'm using kenrel 2.6.25.

Thanks

Regards
Dongas
