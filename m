Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:44050 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbaIKTPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 15:15:04 -0400
Received: by mail-qg0-f52.google.com with SMTP id i50so7046902qgf.11
        for <linux-wireless@vger.kernel.org>; Thu, 11 Sep 2014 12:15:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5951819DB12F1@SC-VEXCH1.marvell.com>
References: <CAAfyv35k1mgQh6FcWaaMciAo8Vkp055k=5xF7zu+yrHmrQbbLA@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951819DB12F1@SC-VEXCH1.marvell.com>
Date: Thu, 11 Sep 2014 21:14:58 +0200
Message-ID: <CAAfyv34tVPRYZG9xqGDMZ3TznoghcjLMa032vStSFucGn46eoQ@mail.gmail.com> (sfid-20140911_211509_221274_2A56F13A)
Subject: Re: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed when conected to 5GHz
From: Belisko Marek <marek.belisko@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Amitkumar Karwar,

On Thu, Sep 11, 2014 at 5:09 PM, Amitkumar Karwar <akarwar@marvell.com> wrote:
> Hi BR,
>
>>
>> I'm using 3.9 mainline mwifiex driver for wireless usb card. Doing some
>> throughput testing (with iperf) in 5GHz I got following failures:
>> [ 221.521799] usb 1-1: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed
>
> This is skb allocation failure returned by kernel. 4k buffer is always allocated for Rx packets. This issue doesn't seem to be specific to 5Ghz.
OK. But I cannot reproduce this issue when connected to 2.4GHz (same
steps as described below).
>.
>>
>> I checked which which size fails to allocate and it's 4096 bytes. I was
>> looking to changes in never kernel releases but I cannot find anything
>> obvious. When connected to 2.4GHz I cannot reproduce issue though. I'm
>> using FW version mwifiex 1.0 (14.68.29.p26).
>>
>
> Could you please provide the platform details?
> How often the problem occurs during throughput testing? Are there any specific steps?
I can reproduce problem 100% by running iperf as server on board where
wifi is connected to  (iperf -s -u -w1M -i1)
and connecting with iperf client from other PC (iperf -c IPADDR -u -b 100m).
Then immediately I can see allocation failures. If you need more info
please let me know. Thanks.
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
