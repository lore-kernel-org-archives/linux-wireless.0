Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32948 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab0KEJWH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Nov 2010 05:22:07 -0400
Received: by bwz11 with SMTP id 11so2477214bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 05 Nov 2010 02:22:06 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: Interrupt threads vs. tasklets (rt2x00 related)
Date: Fri, 5 Nov 2010 10:21:13 +0100
Cc: Ivo van Doorn <ivdoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011051021.13290.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

we've just discussed a rt2x00 related problem that resulted in a few questions
around interrupt threads vs. tasklets.

At the moment, we do the following:

interrupt_handler()
	ack_irq
	save_irq_value
	mask_all_irqs_in_hw
	wake_irq_thread

interrupt_thread()
	read_irq_value
	if (irq & RX_INT)
		process_rx
	if (irq & TBTT)
		process_tbtt
	...
	enable_all_irqs_in_hw

The same approach is also taken by b43 for example.

The problem I've seen (on a slow MIPS machine under high load) was that a new
RX int could happen in the time window between process_rx finished and the 
enabling of the device irqs.

Basically this wouldn't be such a big problem since we will process the
received frame together with the next rx irq invocation. But in some unlikely
situations (which are reproducible under high traffic + CPU load after "some"
time) that didn't happen due to the rx queue filling up completely and the
last free buffer is the one not getting processed. Hence, the hw won't emit
a new interrupt since it still thinks the queue is full (even though the other
entries are already marked as free). This results in the RX queue getting
stuck ...

Second, disabling all other interrupts while processing just one interrupt
might results in other interrupts getting dropped. For example while processing
rx interrupts the tbtt interrupt might get lost. However, I haven't managed to
really make that happen while experimenting.

Now, with tasklets for example, we could do the following:

interrupt_handler()
	ack_irq
	if (irq & RX_INT)
		mask_rx_int
		schedule_rx_tasklet
	if (irq & TBTT)
		mask_tbtt_int
		schedule_tbtt_tasklet

rx_tasklet()
	process_rx
	enable_rx_int

tbtt_tasklet()
	process_tbtt
	enable_tbtt_int

That should mitigate the race since the interrupts are enabled directly before
the tasklet finishes.

Another possibility to achieve the same (?) would be something like this (using
interrupt threads):

interrupt_handler()
	ack_irq
	update_irqvalue
	wake_irq_thread

interrupt_thread()
	while(read_irq_value)
		if (irq & RX_INT)
			disable_rx_int
			process_rx
			enable_rx_int
		if (irq & TBTT)
			disable_tbtt_int
			process_tbtt
			enable_tbtt_int

This would disable single interrupts just while they get processed which should
have the same effect as the tasklet approach.

So, what would be a reasonable way to solve that issue?
What about b43, does that suffer from the same?

Thanks a lot,
Helmut
