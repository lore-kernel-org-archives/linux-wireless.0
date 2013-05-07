Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:32778 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab3EGFQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 01:16:16 -0400
Received: by mail-ob0-f173.google.com with SMTP id 6so143373oba.32
        for <linux-wireless@vger.kernel.org>; Mon, 06 May 2013 22:16:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201305051742.58822.chunkeey@googlemail.com>
References: <CAJ7BrsQ2xrgC=XQU7cTLjdcL-H8AjNMBco5bUacQ14AvJJsbiQ@mail.gmail.com>
	<201305051742.58822.chunkeey@googlemail.com>
Date: Tue, 7 May 2013 07:16:15 +0200
Message-ID: <CAJ7BrsS9rK_LW+kBqN5gL-fTcS2cguCgs=ZUmQZ6ojH-=a6-qg@mail.gmail.com> (sfid-20130507_071620_079960_9E38076C)
Subject: Re: Carl9170 is working very slow (linux 3.6.9 and WN111(v2))
From: =?UTF-8?Q?Rub=C3=A9n_Porras?= <nahoo82@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian,

thank you for the patch, I tried it and it works fine.

No, I am not running OpenWRT, it is just a normal Desktop with an USB
wireless connection.

Kind Regards.

2013/5/5 Christian Lamparter <chunkeey@googlemail.com>:
> Hello Rubén,
>
> On Sunday, May 05, 2013 03:20:30 PM Rubén Porras wrote:
>> the module carl9170 is working very slow in linux version 3.6.9 with the
>> dongle WN111(v2), although I am able to transmit/receive information for a
>> while using it, eventually the transmission hangs and it is not possible to
>> send any data, and I must reset the connection (ifdown wlan0 and ifup
>> wlan0). Several warnings follows which are available in the kernel
>> messages, which probably help to track the problem. If it helps to track
>> the problem I can test any patches you send me.
>>
>> PD: From the post https://forum.openwrt.org/viewtopic.php?id=43243 I
>> suppose that I am not the only one having the problem.
>>
>> [   25.543551] ------------[ cut here ]------------
>> [   25.543570] WARNING: at drivers/net/wireless/ath/carl9170/tx.c:992
>> carl9170_op_tx+0x1f0/0x72f [carl9170]()
>
> Ah, this sounds familiar. The good news is that the interoperability
> problem between minstrel_ht and carl9170 was discovered and
> fixed back in February already [the mainline is not affected].
>
> If you know how to apply patches and compile drivers, then you can
> easily fix it yourself by applying the following patch:
> "carl9170: fix frame drop and WARN due to minstrel_ht change"
> <https://patchwork.kernel.org/patch/2174121/>
>
> and compile the new carl9170 module.
>
> Regards,
>         Christian
>
> BTW: I assume you are also running some version of openwrt. Is this
> correct? Can you tell me which one? Since if this affects a stable
> release, we should notify the OpenWRT folks, so they can take action.
