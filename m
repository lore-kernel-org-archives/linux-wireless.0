Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f20.google.com ([209.85.219.20]:33989 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756575AbZAVPnY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 10:43:24 -0500
Received: by ewy13 with SMTP id 13so2628938ewy.13
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 07:43:22 -0800 (PST)
Message-ID: <49789418.40606@gmail.com> (sfid-20090122_164342_968897_345BCC91)
Date: Thu, 22 Jan 2009 16:43:20 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Artur Skawina <art.08.09@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [RFC][RFT][PATCH] p54usb: rx refill revamp
References: <200901211450.50880.chunkeey@web.de> <200901212156.27152.chunkeey@web.de> <4977AE28.2080109@gmail.com> <200901221600.14130.chunkeey@web.de>
In-Reply-To: <200901221600.14130.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> On Thursday 22 January 2009 00:22:16 Artur Skawina wrote:
>> Christian Lamparter wrote:
>>> On Wednesday 21 January 2009 20:32:43 Artur Skawina wrote:
>>>> Not allocating-on-receive at all worries me a bit. Will test under load. (i already
>>>> had instrumented the cb, but the crashes prevented any useful testing).
>>> no problem... I'll wait for your data before removing the RFC/RFT tags
>> That part is probably fine, and i'm just being paranoid. Ignore me.
> so, green light? (I'll wait till friday / saturday anyway)

see the email i sent after testing -- rx queue starvation seems indeed possible.
I'll send a patch after i figure out and test a solution (hopefully only
allocating the skb if the skb_queue_len is low will fix it).


>> I'll try stealing^Hborrowing the urbs from the refill queue (fixing up
>> the rx code to allow for this first, of course).
> 
> Ah, well you have to increase the number of urbs in the "rx_list" to a total of 64 (for LM87) / 96 (for usb v1 and the old isl3887 fws)
> And then add a check into the p54u_rx_refill so that it will stop as soon as there're 32 urb (with a skb) in the rx_queue. 

Why would you want to increase the number? I'll send a patch, after this one
becomes stable.

>> ok, I was just saying that that all this:
>>
>>>         reg = kmalloc(sizeof(*reg), GFP_ATOMIC);
>>>         if (!reg) {
>>>                 printk(KERN_INFO "tx_net2280 kmalloc(reg), txqlen = %d\n",
>>>                           skb_queue_len(&priv->common.tx_queue) );
>>>                 return;
>>>         }
>>> [...]
>>>         reg->port = cpu_to_le16(NET2280_DEV_U32);
>>>         reg->addr = cpu_to_le32(P54U_DEV_BASE);
>>>         reg->val = cpu_to_le32(ISL38XX_DEV_INT_DATA);
>> does not need to happen for every single tx-ed frame.
> Ah, yes that's true. what do you say about this...
> Instead of using kmalloc in the init procedure, we let gcc already do it.

apparently there are archs where dmaing from not-kmalloced areas doesn't work
that well, this mostly applies to the stack, but i'd rather be safe and 
stick to a kmalloc buffer. one allocation on device init isn't worth avoiding.

> +	if (unlikely(!priv->common.hw->workqueue)) {
> +		/*
> +		 * Huh? mac80211 isn't fully initialized yet?
> +		 * Please check your system, something bad is going on.
> +		 */
> +		WARN_ON(1);

please do not add WARN_ON's unless you're actually interested in the
stacktrace, In this case it's a usb completion, so in most cases the
backtrace isn't very interesting, wouldn't a printk be enough?
[i was hitting this when testing, and it took several seconds to 
get all the data to the console]

> I hope I addressed all concerns this time...

I'll send a patch later today ;)

artur

