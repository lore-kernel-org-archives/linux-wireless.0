Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:35929 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbbEPRyW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2015 13:54:22 -0400
Received: by oift201 with SMTP id t201so103832278oif.3
        for <linux-wireless@vger.kernel.org>; Sat, 16 May 2015 10:54:22 -0700 (PDT)
Message-ID: <5557844B.4040108@lwfinger.net> (sfid-20150516_195430_917946_FD9C85E2)
Date: Sat, 16 May 2015 12:54:19 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Haggai Eran <haggai.eran@gmail.com>
CC: Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: kernel page fault in r8712u
References: <CAJ=9Czbh2cT-qvkEmvVWPCwWdAJ5H_kAcRXirW4MQDhrMb4XRg@mail.gmail.com>	<55575AC8.2060301@lwfinger.net> <CAJ=9CzasMnjhMSWT0P=eenvaeDA04Q2aGhY0z1npD-NDuh7YeQ@mail.gmail.com>
In-Reply-To: <CAJ=9CzasMnjhMSWT0P=eenvaeDA04Q2aGhY0z1npD-NDuh7YeQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/16/2015 12:16 PM, Haggai Eran wrote:
> On 16 May 2015 at 17:57, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> The problem appears to be from r8712u. From the stack dump, the problem
>> happens when r8712_free_recvframe() calls __dev_kfree_skb_any(). A
>> complication is that my copy of the kernel source does not show such a call.
>> :(
>>
>> Please use gdb to help with the debugging. From the main directory of your
>> source, enter the command 'gdb drivers/staging/rtl8712/r8712u.ko'. Once it
>> prompts you, enter 'l *r8712_free_recvframe+0x2c'. The first character is
>> ell, not one. That will show the actual line of code. Please post that info.

Another location needed from gdb is "l *recv_func+0x8c".

Thanks,

Larry


