Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:50631 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab3BOTru (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 14:47:50 -0500
Received: by mail-ob0-f181.google.com with SMTP id ni5so3963546obc.26
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2013 11:47:49 -0800 (PST)
Message-ID: <511E90E3.9020001@lwfinger.net> (sfid-20130215_204754_430592_A0567DD7)
Date: Fri, 15 Feb 2013 13:47:47 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: openwrt-devel@lists.openwrt.org, linux-wireless@vger.kernel.org
Subject: Re: WRT54g / b43 / mac802.11 BREAKTHROUGH
References: <1342612598.5006a476022c6@mail.bluebottle.com> <20130214203553.GA27934@medion.lan>
In-Reply-To: <20130214203553.GA27934@medion.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/14/2013 02:35 PM, Bastian Bittorf wrote:
Bastian,

> * Bastian Bittorf <bittorf@bluebottle.com> [18.07.2012 17:43]:
>> hi devs!
>>
>> yesterday we had a breaktrough debugging b43 in our hackspace maschinenraum/m18[1,2]
>> at weimar.freifunk.net[3,4] - since a long time our darling wrt54g suffers from a
>> hanging wifi and bad performance[5], but the workaround is easy: now it's up to
>> you to fix the rootcause.
>
> [...]
>
> another issues was found, see https://dev.openwrt.org/ticket/7552#comment:69
>
> "...under high load and have found that probably some of the silent freezes
> are due to overflow of the RX DMA buffer, seems like b43 does not
> handlre such a situation at all."
>
> https://dev.openwrt.org/attachment/ticket/7552/840-b43-workaround-rx-fifo-overflow.patch
>
> the patch is working so far, but is only a workaround.
> has somebody a better code-idea?

I am looking into this problem; however, as it has been several years since I 
looked at the dma code, it might take a while. In the meantime, I have some 
questions, and one thing for you to try.

How frequently do you hit the buffer overflow?

Is the problem caused by a load with high bursts, or is the high load relatively 
constant?

Please change B43_RXRING_SLOTS in drivers/net/wireless/b43.h from 64 to 128 
while keeping your recovery patch in place. Unless you are extremely limited in 
the memory, that should help. I think that change has helped on one of my 32-bit 
systems. I still want to keep track of the minimum in the free slots and expose 
that quantity in /sys, but first we should see if changing the number of slots 
helps you.

Larry

