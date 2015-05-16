Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:32899 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbbEPRlO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2015 13:41:14 -0400
Received: by oica37 with SMTP id a37so103765879oic.0
        for <linux-wireless@vger.kernel.org>; Sat, 16 May 2015 10:41:13 -0700 (PDT)
Message-ID: <55578136.30501@lwfinger.net> (sfid-20150516_194118_027808_77F338C6)
Date: Sat, 16 May 2015 12:41:10 -0500
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
>
> Here's what I get:
>
> (gdb) l *r8712_free_recvframe+0x2c
> 0x16714 is in r8712_free_recvframe (drivers/staging/rtl8712/rtl8712_recv.c:145).
> 140             struct _adapter *padapter = precvframe->u.hdr.adapter;
> 141             struct recv_priv *precvpriv = &padapter->recvpriv;
> 142
> 143             if (precvframe->u.hdr.pkt) {
> 144
> dev_kfree_skb_any(precvframe->u.hdr.pkt);/*free skb by driver*/
> 145                     precvframe->u.hdr.pkt = NULL;
> 146             }
> 147             spin_lock_irqsave(&pfree_recv_queue->lock, irqL);
> 148             list_del_init(&(precvframe->u.hdr.list));
> 149             list_add_tail(&(precvframe->u.hdr.list),
> &pfree_recv_queue->queue);
>
> It seems that dev_kfree_skb_any is an inline function that calls
> __dev_kfree_skb_any,
> so that should explain why that call didn't show up in the stack dump.

Thanks. From your original posting, the bad address for precvframe->u.hdr.pkt is 
a9d797d7. I'm a little bothered by that odd address. I would have expected it to 
be even, at least. The actual definition should be OK with the alignment, but 
there are a number of places where there is a cast. If the alignment of the 
object of the cast is wrong, then that might cause the problem. It will take a 
while to trace back through your call chain to see if any of these are involved 
here.

I will be back to you later.

Larry


