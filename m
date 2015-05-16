Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:34055 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbbEPRQW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2015 13:16:22 -0400
Received: by laat2 with SMTP id t2so164520747laa.1
        for <linux-wireless@vger.kernel.org>; Sat, 16 May 2015 10:16:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55575AC8.2060301@lwfinger.net>
References: <CAJ=9Czbh2cT-qvkEmvVWPCwWdAJ5H_kAcRXirW4MQDhrMb4XRg@mail.gmail.com>
	<55575AC8.2060301@lwfinger.net>
Date: Sat, 16 May 2015 20:16:20 +0300
Message-ID: <CAJ=9CzasMnjhMSWT0P=eenvaeDA04Q2aGhY0z1npD-NDuh7YeQ@mail.gmail.com> (sfid-20150516_191625_613686_87D48A30)
Subject: Re: kernel page fault in r8712u
From: Haggai Eran <haggai.eran@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 May 2015 at 17:57, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> The problem appears to be from r8712u. From the stack dump, the problem
> happens when r8712_free_recvframe() calls __dev_kfree_skb_any(). A
> complication is that my copy of the kernel source does not show such a call.
> :(
>
> Please use gdb to help with the debugging. From the main directory of your
> source, enter the command 'gdb drivers/staging/rtl8712/r8712u.ko'. Once it
> prompts you, enter 'l *r8712_free_recvframe+0x2c'. The first character is
> ell, not one. That will show the actual line of code. Please post that info.

Here's what I get:

(gdb) l *r8712_free_recvframe+0x2c
0x16714 is in r8712_free_recvframe (drivers/staging/rtl8712/rtl8712_recv.c:145).
140             struct _adapter *padapter = precvframe->u.hdr.adapter;
141             struct recv_priv *precvpriv = &padapter->recvpriv;
142
143             if (precvframe->u.hdr.pkt) {
144
dev_kfree_skb_any(precvframe->u.hdr.pkt);/*free skb by driver*/
145                     precvframe->u.hdr.pkt = NULL;
146             }
147             spin_lock_irqsave(&pfree_recv_queue->lock, irqL);
148             list_del_init(&(precvframe->u.hdr.list));
149             list_add_tail(&(precvframe->u.hdr.list),
&pfree_recv_queue->queue);

It seems that dev_kfree_skb_any is an inline function that calls
__dev_kfree_skb_any,
so that should explain why that call didn't show up in the stack dump.

Haggai
