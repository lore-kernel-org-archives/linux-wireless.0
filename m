Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54105 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab1FKSF7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jun 2011 14:05:59 -0400
Received: by qwk3 with SMTP id 3so1723143qwk.19
        for <linux-wireless@vger.kernel.org>; Sat, 11 Jun 2011 11:05:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110611195721.735dcf4c@maggie>
References: <BANLkTimaUBe6kszbvSeSPTXR6m1t8C8O-A@mail.gmail.com>
	<20110611195721.735dcf4c@maggie>
Date: Sat, 11 Jun 2011 20:05:58 +0200
Message-ID: <BANLkTi=Wr=HmveLN9VOQmUNFAP7ygWAwkA@mail.gmail.com> (sfid-20110611_200602_867031_678582AD)
Subject: Re: Can iperf work with no qos? (TCP mode)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 11 czerwca 2011 19:57 użytkownik Michael Büsch <m@bues.ch> napisał:
> On Sat, 11 Jun 2011 19:47:31 +0200
> Rafał Miłecki <zajec5@gmail.com> wrote:
>
>> I can not get any results when trying to use iperf in TCP mode with
>> driver not supporting qos.
>>
>> Is this expected? Does iperf fill connection with so many packets,
>> it's not possible to get response from the iperf receiver? Should not
>> Linux somehow schedule packet to allow bi-direction communication,
>> even on really filled connection?
>
> iperf will only fill the best effort queue. At least that's what it did
> last time when I looked into the code.
> You can verify that with b43's ring statistics.

It's BE queue we create for qos=0 in b43:
else
	q = dev->pio.tx_queue_AC_BE;
so this should not limit iperf

As another test, I've just tried dma mode with qos=0. iperf was fine.

So now we know iperf does not need multiple queues. It seems that:
GOOD: b43 & dma & no qos
BAD: b43 & pio & no qos

In the second case connection is started (I can see that from "iperf
-s" on my receiving machine), but it seems sender does not receive any
confirmations.

-- 
Rafał
