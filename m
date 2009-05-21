Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:59386 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbZEUXxT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 19:53:19 -0400
Received: by gxk10 with SMTP id 10so2587538gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 21 May 2009 16:53:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200905212349.n4LNnxQH029607@ms.infomax.com.tw>
References: <60ce8d250905191048t46e3848fw3416ecd793dab9d1@mail.gmail.com>
	 <45e8e6c40905211611q256a71f1pb08e2014f7ed0775@mail.gmail.com>
	 <200905212349.n4LNnxQH029607@ms.infomax.com.tw>
Date: Thu, 21 May 2009 16:53:20 -0700
Message-ID: <45e8e6c40905211653mf2b2c4do4bd371d64fb475fd@mail.gmail.com>
Subject: Re: Throughput is not changed when setting to a much higher bit rate
From: Andrey Yurovsky <andrey@cozybit.com>
To: "benson.dong" <benson.dong@infomax.com.tw>
Cc: Dan Williams <dcbw@redhat.com>, Dongas <dongas86@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 21, 2009 at 4:49 PM, benson.dong <benson.dong@infomax.com.tw> wrote:
> <20090519175336.GF2691@tuxdriver.com>
> <60ce8d250905200748p5984df0bl1984f0d3bdaf79b5@mail.gmail.com>
> <1242854588.7048.13.camel@localhost.localdomain>
> <60ce8d250905201700v13fe1394l6a9704bb02be3807@mail.gmail.com>
> <1242945500.6444.24.camel@localhost.localdomain> <45e8e6c40905211611q256a71f1pb08e2014f7ed0775@mail.gmail.com>
> Message-ID: <a12bc4a4a4cdf5f2ec75810d8e113d92@infomax.com.tw>
> X-Sender: benson.dong@infomax.com.tw
> Received: from 34.141.227.121.broad.sz.js.dynamic.163data.com.cn
>        [121.227.141.34] with HTTP/1.1 (POST); Fri, 22 May 2009 07:49:59
>        +0800
> User-Agent: INFOMAX Webmail/0.1
> Content-Type: text/plain; charset="UTF-8"
> Content-Transfer-Encoding: 8bit
>
> On Thu, 21 May 2009 16:11:17 -0700, Andrey Yurovsky <andrey@cozybit.com>
> wrote:
>> On Thu, May 21, 2009 at 3:38 PM, Dan Williams <dcbw@redhat.com> wrote:
>>> On Thu, 2009-05-21 at 08:00 +0800, Dongas wrote:
>>>> 2009/5/21 Dan Williams <dcbw@redhat.com>:
>>>> > On Wed, 2009-05-20 at 22:48 +0800, Dongas wrote:
>>>> >> 2009/5/20 John W. Linville <linville@tuxdriver.com>:
>>>> >> > On Wed, May 20, 2009 at 01:48:32AM +0800, Dongas wrote:
>>>> >> >
>>>> >> >> Why the bandwidth is not changed when bit rate is changed to
>> 11Mb/s?
>>>> >> >> Any thing wrong?
>>>> >> >
>>>> >> > More errors at higher bit rate, resulting in more retries?  Just
>> a
>>>> >> > thought...
>>>> >> >
>>>> >> Is there a quick way to verify this possible reason? I'm using
>> Libertas driver.
>>>> >>
>>>> >> BTW, my sdio host driver is using polling mode to handle SDIO IRQ.
>>>> >> Could this be the cause of such poor performance?
>>>> >
>>>> > Definitely.  With libertas, the largest class of issues by *far*
>> that
>>>> > we've seen are controller related.  I seem to recall that I've
>> pulled
>>>> > about 6Mbps through the card using a normal Ricoh controller from a
>>>> > Fujitsu laptop.  I can recheck that.
>>>>
>>>> AFAIK, most old laptop ,including my x61, doesn't support SDIO in HW.
>>>> So did Ricoh controller you tested use polling mode to handle SDIO IRQ?
>>>> Which clock of controller and which bit rate did you test?
>>>
>>> Actually, most of the older machines *can* do SDIO, those made from
>>> about 2006 - 2009.  These days a lot of the SD "controllers" are
>>> actually USB-based mass-storage converters and cannot do SDIO, they are
>>> essentially 10-in-1 cardreaders.
>>>
>>> What is the 'lspci' output for your Thinkpad?  If the controller isn't
>>> in 'lspci' but is in 'lsusb', then it's quite unlikely to work because
>>> of the above reason, I think.
>>
>> Right, you need a real SDIO (vs. SD storage) controller on the PCI
>> bus.  However I can confirm that the ThinkPad X61 (and T61) controller
>> does full SDIO and you can plug Libertas SDIO cards into it.  The
>> older X-series ThinkPads (I tried the X40 and X41) work great too.
>
> Great, since the os running on x61 is windows vista, i just run linux in
> vmware.
> So do you know whether the windows driver for x61 supports full SDIO
> well(including SDIO interrupt in HW)?

Oh.  Well, you need to run Linux right on the hardware (ie: not in
VMWare or any visualization software) for SDIO to work.  I don't know
anything about Windows.  I can confirm, from personal experience, that
the X61's SDIO works fine for Libertas in Linux.

>>>> >> (However I just can't believe the performance is so poor ,only
>> around
>>>> >> 1.1Mbps, with polling mode of SDIO IRQ)
>>>> >
>>>> > What specific kernel version are you using?  There have been some
>>>> > latency fixes in recent kernels, but would be good to know just to
>> make
>>>> > sure.
>>>>
>>>> I'm using kenrel 2.6.25.
>>>>
>>>> Thanks
>>>>
>>>> Regards
>>>> Dongas
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>> linux-wireless" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
