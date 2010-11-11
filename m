Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50674 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab0KKNpm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 08:45:42 -0500
Received: by iwn10 with SMTP id 10so2183786iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 05:45:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ibgpgg$a5m$1@dough.gmane.org>
References: <ibgpgg$a5m$1@dough.gmane.org>
Date: Thu, 11 Nov 2010 14:45:41 +0100
Message-ID: <AANLkTikLoz-7LuhkcuRWGr+he+S3D=K_tmVHcmj3AZ-O@mail.gmail.com>
Subject: Re: rt61pci issue
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Tim Blechmann <tim@klingt.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Nov 11, 2010 at 2:02 PM, Tim Blechmann <tim@klingt.org> wrote:
> hi all,
>
> i am using tn rt61pci driver and besides having not the best wireless
> performance, it network transfer sometimes disturbs the audio playback on my
> machine. sometimes it works fine, but the machine can get into a state, where i
> will have to reboot the machine to get back to normal. i suppose, this is
> because of the rt61pci driver.
>
> in general if found, that the specific irq thread produces a lot of interrupts
> and does quite a lot of work. the specific irq thread takes quite some cpu time
> (currently i have an uptime of 5 hours and the irq thread used 4 minutes of cpu
> time) and about 200 interupts are issued per second:

You get ~200 interrupts/second from rt61pci while the device is idle? Or
while transmitting/receiving?

> cat /proc/interrupts |grep 16\: && sleep 1 && cat /proc/interrupts | grep 16\:
>  16:          0    5140126          0          0   IO-APIC-fasteoi
> uhci_hcd:usb3, ahci, 0000:08:00.0
>  16:          0    5140357          0          0   IO-APIC-fasteoi
> uhci_hcd:usb3, ahci, 0000:08:00.0
>
> using perf, i get the following data about the spent cpu time:
> # Events: 106  cycles
> #
> # Overhead          Command      Shared Object  Symbol
> # ........  ...............  .................  ......
> #
>    61.17%  irq/16-0000:08:  [rt61pci]          [k] rt61pci_interrupt_thread
>    12.77%  irq/16-0000:08:  [rt61pci]          [k] rt61pci_set_device_state
>     3.72%  irq/16-0000:08:  [kernel.kallsyms]  [k] __ticket_spin_lock
>     3.17%  irq/16-0000:08:  [kernel.kallsyms]  [k] local_bh_disable
>     2.14%  irq/16-0000:08:  [kernel.kallsyms]  [k] schedule
>     1.81%  irq/16-0000:08:  [rt61pci]          [k] rt61pci_kick_tx_queue
>     1.50%  irq/16-0000:08:  [mac80211]         [k] prepare_for_handlers
>     1.38%  irq/16-0000:08:  [rt2x00pci]        [k] rt2x00pci_rxdone
>     1.03%  irq/16-0000:08:  [kernel.kallsyms]  [k] __ticket_spin_unlock
>     0.87%  irq/16-0000:08:  [kernel.kallsyms]  [k] __inet_lookup_established
>     0.87%  irq/16-0000:08:  [kernel.kallsyms]  [k] tcp_event_data_recv
>     0.82%  irq/16-0000:08:  [kernel.kallsyms]  [k] irq_thread
>     0.66%  irq/16-0000:08:  [kernel.kallsyms]  [k] update_curr_rt
>     0.64%  irq/16-0000:08:  [rt2x00lib]        [k] rt2x00lib_rxdone
>     0.64%  irq/16-0000:08:  [kernel.kallsyms]  [k] mod_timer
>     0.51%  irq/16-0000:08:  [kernel.kallsyms]  [k] pick_next_task_rt
>     0.51%  irq/16-0000:08:  [kernel.kallsyms]  [k] cpupri_set
>     0.51%  irq/16-0000:08:  [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore
>     0.50%  irq/16-0000:08:  [kernel.kallsyms]  [k] hrtick_update
>     0.49%  irq/16-0000:08:  [kernel.kallsyms]  [k] __phys_addr
>     0.49%  irq/16-0000:08:  [kernel.kallsyms]  [k] update_shares
>     0.49%  irq/16-0000:08:  [kernel.kallsyms]  [k] dequeue_task
>     0.49%  irq/16-0000:08:  [kernel.kallsyms]  [k] dequeue_rt_stack
>     0.49%  irq/16-0000:08:  [kernel.kallsyms]  [k] skb_release_data
>     0.44%  irq/16-0000:08:  [kernel.kallsyms]  [k] load_balance
>     0.40%  irq/16-0000:08:  [kernel.kallsyms]  [k] memcpy
>     0.36%  irq/16-0000:08:  [kernel.kallsyms]  [k] map_single
>     0.36%  irq/16-0000:08:  [kernel.kallsyms]  [k] ip_output
>     0.36%  irq/16-0000:08:  [kernel.kallsyms]  [k] tcp_ack
>     0.22%  irq/16-0000:08:  [mac80211]         [k] minstrel_ht_tx_status
>     0.22%  irq/16-0000:08:  [kernel.kallsyms]  [k] tcp_v4_rcv
>     0.00%  irq/16-0000:08:  [kernel.kallsyms]  [k] native_write_msr_safe
>
> not sure, if this is really helpful, but this amount of interrupts doesn't look
> good to me. if i can be on any further help to track down this issue, i would be
> happy to assist.

Looks to me as if the interrupt thread gets scheduled but doesn't do
anything useful as
otherwise we should also see the rxdone/txdone functions etc in the perf output.

Mind to put a (maybe rate limited) printk into the interrupt thread
that prints out "reg"
and "reg_mcu" so that we can see which interrupts get triggered?

Helmut
