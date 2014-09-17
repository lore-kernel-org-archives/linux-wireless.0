Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:64656 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463AbaIQMHY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2014 08:07:24 -0400
Received: by mail-we0-f174.google.com with SMTP id x48so447034wes.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Sep 2014 05:07:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5951821351855@SC-VEXCH1.marvell.com>
References: <CAAfyv35k1mgQh6FcWaaMciAo8Vkp055k=5xF7zu+yrHmrQbbLA@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951819DB12F1@SC-VEXCH1.marvell.com>
	<CAAfyv35j-77AURB4fHcecbEvyGS6U+1APNRFCf3FDAd_rrWnJw@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821351855@SC-VEXCH1.marvell.com>
Date: Wed, 17 Sep 2014 14:07:21 +0200
Message-ID: <CAAfyv36KrG5SjsJjPqaXp4SuE2hnG-EsXpTE-WrhM8zOdye2-g@mail.gmail.com> (sfid-20140917_140727_370169_EA53141F)
Subject: Re: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed when conected to 5GHz
From: Belisko Marek <marek.belisko@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Amitkumar Karwar,

On Wed, Sep 17, 2014 at 12:52 PM, Amitkumar Karwar <akarwar@marvell.com> wrote:
> Hi BR,
>
>> Dear Amitkumar Karwar,
>>
>> some additional info.
>>
>> On Thu, Sep 11, 2014 at 5:09 PM, Amitkumar Karwar <akarwar@marvell.com>
>> wrote:
>> > Hi BR,
>> >
>> >>
>> >> I'm using 3.9 mainline mwifiex driver for wireless usb card. Doing
>> >> some throughput testing (with iperf) in 5GHz I got following
>> failures:
>> >> [ 221.521799] usb 1-1: mwifiex_usb_submit_rx_urb: dev_alloc_skb
>> >> failed
>> >
>> > This is skb allocation failure returned by kernel. 4k buffer is
>> always allocated for Rx packets. This issue doesn't seem to be specific
>> to 5Ghz.
>> Yes you're right. I can reproduce issue also with 2.4GHz (doing iperf
>> testing as mentioned in other email) by pinging device with card.
>> >
>> >>
>> >> I checked which which size fails to allocate and it's 4096 bytes. I
>> >> was looking to changes in never kernel releases but I cannot find
>> >> anything obvious. When connected to 2.4GHz I cannot reproduce issue
>> >> though. I'm using FW version mwifiex 1.0 (14.68.29.p26).
>> >>
>> >
>> > Could you please provide the platform details?
>> > How often the problem occurs during throughput testing? Are there any
>> specific steps?
>> One more observation is that when problem occurred complete system is
>> unresponsive (console is almost completely dead).
>
> Thanks for the more information.
> Skb alloc failure should be gracefully handled. We will look into this issue.
OK. Thanks. Can you please
>
>> I can workaround issue by decreasing iperf bandwidth to ~40m. I think
>> in this situation we're running out of memory by exhaustive skb
>> allocations.
>
> Actually 6 4K size buffers are being allocated for Rx and Tx data during traffic.
> Probably your platform runs out of memory after these allocations.
This could be the issue. I'm running some apps when performing
throughput test and this could lead
to out of memory. When I stop all apps and perform the test it behave
better (I cannot reproduce issue) except of
fact that whole system is unresponsive for ~ 10 secs as was already mentioned.
>
> Could you please try changing this number(MWIFIEX_TX_DATA_URB/MWIFIEX_RX_DATA_URB macros) to 3?
>
> Regards,
> Amitkumar Karwar

Best Regards,

marekb

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
