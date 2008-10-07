Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.tglx.de ([62.245.132.106]:41540 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbYJGSpO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 14:45:14 -0400
Date: Tue, 7 Oct 2008 20:44:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Elias Oltmanns <eo@nebensachen.de>
cc: Jiri Slaby <jirislaby@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: ath5k: kernel timing screwed - due to unserialised register
 access?
In-Reply-To: <alpine.LFD.2.00.0810071946460.3166@apollo>
Message-ID: <alpine.LFD.2.00.0810072042140.3166@apollo> (sfid-20081007_204520_431347_8C372D07)
References: <87k5cm3ee2.fsf@denkblock.local> <alpine.LFD.2.00.0810052354000.3398@apollo> <87d4id3jmr.fsf@denkblock.local> <alpine.LFD.2.00.0810061614490.3166@apollo> <87skr8h1de.fsf@denkblock.local> <alpine.LFD.2.00.0810071946460.3166@apollo>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 7 Oct 2008, Thomas Gleixner wrote:
> On Tue, 7 Oct 2008, Elias Oltmanns wrote:
> > Thomas Gleixner <tglx@linutronix.de> wrote:
> > > On Mon, 6 Oct 2008, Elias Oltmanns wrote:
> > >> Make sure that event1 is the right device. chktimer usually reports
> > >> several premature timer expiries in less than a minute.
> > [...]
> > > Your measuring method is wrong. You really want to measure the delta
> > > of the timer events in the kernel via ktime_get(), not the delta of
> > > something else in userspace.
> > 
> > Alright, here is a stripped down version of the test case. This time,
> > you only need to load the timer-test module and start up the ath5k
> > interface. The glitch is triggered slightly less reliably, but I can
> 
> -ENOATH5KHARDWARE
> 
> > still easily verify that the problem is present when running 2.6.27-rc9
> > on my system.
> 
> Hmm. Can you please add some real info to the printk :)
> 
> > +	if (timespec_to_ns(&diff) < TSTM_THRESH)
> > +		printk(KERN_INFO "Timer expired prematurely.\n");
> 
> e.g.:
> 
>   		printk(KERN_INFO "b: %6ld.%09ld n: %6ld.09ld e: %lu j: %lu\n",
> 			before.tv_sec, before.tv_nsec, now.tv_sec, now.tv_nsec,
> 			tstm_timer.expires, jiffies);
> 
> Does this happen w/o the ath5k driver as well ?

Some more questions:

Does this happen with any on the combinations of highres/nohz
enabled/disabled ?

Can you please add:

    sysrq_timer_list_show();

    after the printk. You have to export it in kernel/time/timer_list.c
    to use it with a module

Please do cat /proc/timer_list right before you start the module as well.

Thanks,

	tglx

    
