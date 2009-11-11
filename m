Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:41590 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614AbZKKEKG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 23:10:06 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1N84X4-0008BO-Cf
	for linux-wireless@vger.kernel.org; Wed, 11 Nov 2009 05:10:10 +0100
Received: from 76-10-155-41.dsl.teksavvy.com ([76.10.155.41])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 11 Nov 2009 05:10:10 +0100
Received: from monnier by 76-10-155-41.dsl.teksavvy.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 11 Nov 2009 05:10:10 +0100
To: linux-wireless@vger.kernel.org
From: Stefan Monnier <monnier@iro.umontreal.ca>
Subject: Re: rtl8187se locks up when switching network
Date: Tue, 10 Nov 2009 23:09:47 -0500
Message-ID: <jwvzl6tiuim.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
References: <jwvljidrhm3.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
	<4AFA22DF.8060907@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> I've just dine a few more tests, and switching network works just fine
>> if I "modprobe -r rtl8187se" and then "modprobe rth8187se" between the
>> disconnect and the reconnect, but otherwise the system almost always
>> hangs during the connection to the other network.  The way it hangs is
>> always the same: everything just freezes and 2 of the status
>> leds blink.  The exact moment at which the freeze takes place seems to
>> vary: sometimes it's while getting the IP address, other times its
>> earlier.

> Do you mean that the "Caps Lock" and "num lock" LEDs are blinking?

Could be (the label got washed away fairly quickly, but since those
leds are normally always off and I never use num-lock nor caps-lock,
that sounds right).

> If so, that is a kernel panic. You will be able to capture some
> information about that crash by switching to the logging console
> (CTRL-ALT-F10) just after you initiate the process that causes
> the crash.

It wasn't easy to do it quickly enough, but I just got a backtrace
there.  The 1024x600 display doesn't let me see the whole backtrace and
I don't seem to be able to scroll, so here's the part I can see:

   do_invalid_op+0x6c/0x75
   skb_put+0x5d/0x67
   vt_console_print+0x0/0x247
   up+0x9/0x2a
   release_console_sem+0x174/0x1a2
   error_code+0x66/0x6c
   do_invalid_op+0x0/0x75
   skb_put+0x5d/0x67
   ieee80211_association_req+0x189/0x1f8 [rtl8187se]
   ieee80211_association_req+0x189/0x1f8 [rtl8187se]
   ieee80211_associate_step+0x24/0x5b [rtl8187se]
   ieee80211_rx_frame_softmac+0x358/0x498 [rtl8187se]
   cpumask_next_and+0x23/0x33
   ieee80211_rx+0x542/0xc9c [rtl8187se]
   __alloc_skb+0x46/0x111
   rtl8180_rx+0x728/0x828 [rtl8187se]
   hrtimer_get_next_event+0x8c/0xa0
   tasklet_action+0x67/0xad
   rtl8180_interrupt+0x35d/0x368 [rtl8187se]
   __do_softirq+0xaa/0x151
   do_softirq+0x31/0x3c
   irq_exit+0x26/0x58
   do_IRQ+0x78/0x89
   common_interrup+0x29/0x30
   acpi_idle_enter_bm+0x246/0x281 [processor]
   cpuidle_idle_call+0x68/0xbb
   cpu_idle+0x46/0x5f
   start_kernel+0x2c7/0x2ca

>> IIUC this driver is not under active development, but maybe someone
>> knows it enough to try and fix it, or maybe there's some alternative
>> driver for this card that I should try?
> The vendor driver in staging is not really under active development.
> We are currently writing a mainline driver that uses mac80211 from the
> vendor code.  Of course, it is not possible to predict when this
> driver will be ready.

If/when there's something I can do to help test it, please let me know,


        Stefan

