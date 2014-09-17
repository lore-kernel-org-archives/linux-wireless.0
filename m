Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54481 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbaIQJ5O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2014 05:57:14 -0400
Received: by mail-wi0-f174.google.com with SMTP id n3so876897wiv.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Sep 2014 02:57:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5951819DB12F1@SC-VEXCH1.marvell.com>
References: <CAAfyv35k1mgQh6FcWaaMciAo8Vkp055k=5xF7zu+yrHmrQbbLA@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951819DB12F1@SC-VEXCH1.marvell.com>
Date: Wed, 17 Sep 2014 11:57:12 +0200
Message-ID: <CAAfyv35j-77AURB4fHcecbEvyGS6U+1APNRFCf3FDAd_rrWnJw@mail.gmail.com> (sfid-20140917_115722_821158_37E9D09A)
Subject: Re: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed when conected to 5GHz
From: Belisko Marek <marek.belisko@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Amitkumar Karwar,

some additional info.

On Thu, Sep 11, 2014 at 5:09 PM, Amitkumar Karwar <akarwar@marvell.com> wrote:
> Hi BR,
>
>>
>> I'm using 3.9 mainline mwifiex driver for wireless usb card. Doing some
>> throughput testing (with iperf) in 5GHz I got following failures:
>> [ 221.521799] usb 1-1: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed
>
> This is skb allocation failure returned by kernel. 4k buffer is always allocated for Rx packets. This issue doesn't seem to be specific to 5Ghz.
Yes you're right. I can reproduce issue also with 2.4GHz (doing iperf
testing as mentioned in other email) by pinging device with card.
>
>>
>> I checked which which size fails to allocate and it's 4096 bytes. I was
>> looking to changes in never kernel releases but I cannot find anything
>> obvious. When connected to 2.4GHz I cannot reproduce issue though. I'm
>> using FW version mwifiex 1.0 (14.68.29.p26).
>>
>
> Could you please provide the platform details?
> How often the problem occurs during throughput testing? Are there any specific steps?
One more observation is that when problem occurred complete system is
unresponsive (console is almost completely dead).
I can workaround issue by decreasing iperf bandwidth to ~40m. I think
in this situation we're running out of memory by exhaustive skb
allocations.
>
> Regards,
> Amitkumar Karwar

BR,

marek

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
