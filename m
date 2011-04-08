Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54973 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab1DHFoM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 01:44:12 -0400
Received: by bwz15 with SMTP id 15so2558382bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2011 22:44:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201101212324.29978.anarsoul@gmail.com>
References: <1295642690-16646-1-git-send-email-anarsoul@gmail.com>
	<1295642690-16646-2-git-send-email-anarsoul@gmail.com>
	<201101212222.37667.marek.vasut@gmail.com>
	<201101212324.29978.anarsoul@gmail.com>
Date: Thu, 7 Apr 2011 22:44:09 -0700
Message-ID: <BANLkTinHOn0-yZwpB=vPP9yJNVM1YZhsbQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] libertas_spi: Use workqueue in hw_host_to_card
From: Colin McCabe <cmccabe@alumni.cmu.edu>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: Marek Vasut <marek.vasut@gmail.com>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org, Colin McCabe <colin@cozybit.com>,
	libertas-dev@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for fixing up if_spi.c, Vasily. I was aware that breakage had
entered the driver, but I didn't have access to the hardware any more,
so I couldn't fix it.

Together with Andrey, I implemented the original driver in a week or
two. We always hoped to find a better solution than the giant list of
buffers that ended up being created in if_spi_host_to_card. However,
time was a factor and we ended up merging the giant list solution.
(Yes, I'm aware that if_sdio.c uses the same approach, but that
doesn't make it right.)

At the very least, we should be keeping track of the length of that
list, and failing in if_spi_host_to_card if it gets too long.
Otherwise, we could theoretically allocate an unlimited amount of
kernel memory in that function. It's especially bad because the
allocations are being done with GFP_ATOMIC. Buffering the packets in
this way also introduces unwanted latency (also called bufferbloat).

I wish that there were some way to just put the sk_buff into a list of
our own in the GSPI driver, rather than copying its entire contents.
It might also be feasible to avoid calling if_spi_host_to_card (and
the other libertas host-to-card functions) from atomic contexts. In
that case, we could just send the data immediately. You'd have to
change the core driver somewhat to make either change happen, though.

Such a change would improve both latency and throughput, of course :)

cheers,
Colin


On Fri, Jan 21, 2011 at 1:24 PM, Vasily Khoruzhick <anarsoul@gmail.com> wrote:
> On Friday 21 January 2011 23:22:37 Marek Vasut wrote:
>> On Friday 21 January 2011 21:44:48 Vasily Khoruzhick wrote:
>> > Use workqueue to perform SPI xfers, it's necessary to fix
>> > nasty "BUG: scheduling while atomic", because
>> > spu_write() calls spi_sync() and spi_sync() may sleep, but
>> > hw_host_to_card() callback can be called from atomic context.
>> > Remove kthread completely, workqueue now does its job.
>> > Restore intermediate buffers which were removed in commit
>> > 86c34fe89e9cad9e1ba4d1a8bbf98259035f4caf that introduced
>> > mentioned bug.
>>
>> I have two questions:
>>
>> 1) Why not leave kthread there? ie. why switch to workqueue
>
> Because it's not easy to ensure that kthread did its job in suspend handler,
> and to make if_spi.c look similar to if_sdio.c.
>
>> 2) This should be split into two patches I guess -- a) revert the change b)
>> convert to workqueue -- so they can be (N)ACKed separatedly
>
> Actually just reverting commit does not make driver work (it will fail on
> rmmod), and it can impact on future bisect (if it'll be necessary). But if
> it's requirement - ok.
>
>> Cheers
>
> _______________________________________________
> libertas-dev mailing list
> libertas-dev@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/libertas-dev
>
