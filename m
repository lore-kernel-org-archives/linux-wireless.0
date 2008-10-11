Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.tglx.de ([62.245.132.106]:39119 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbYJKJyO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2008 05:54:14 -0400
Date: Sat, 11 Oct 2008 11:54:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Elias Oltmanns <eo@nebensachen.de>
cc: Jiri Slaby <jirislaby@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: ath5k: kernel timing screwed - due to unserialised register
 access?
In-Reply-To: <alpine.LFD.2.00.0810101432540.3271@apollo>
Message-ID: <alpine.LFD.2.00.0810111149420.3356@apollo> (sfid-20081011_115428_394241_09176478)
References: <87k5cm3ee2.fsf@denkblock.local> <alpine.LFD.2.00.0810052354000.3398@apollo> <87d4id3jmr.fsf@denkblock.local> <alpine.LFD.2.00.0810061614490.3166@apollo> <87skr8h1de.fsf@denkblock.local> <alpine.LFD.2.00.0810071946460.3166@apollo>
 <alpine.LFD.2.00.0810072042140.3166@apollo> <87hc7ot804.fsf@denkblock.local> <87myhfnwne.fsf@denkblock.local> <alpine.LFD.2.00.0810082203360.3237@apollo> <alpine.LFD.2.00.0810091313380.3237@apollo> <87k5cgg87j.fsf@denkblock.local> <alpine.LFD.2.00.0810101127560.3271@apollo>
 <87abdck6sn.fsf@denkblock.local> <alpine.LFD.2.00.0810101432540.3271@apollo>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 10 Oct 2008, Thomas Gleixner wrote:
> On Fri, 10 Oct 2008, Elias Oltmanns wrote:
> > That printk() has not been hit, I'm afraid. The output of
> > sysrq_timer_list_show() looks much the same but there is no message
> > about softirqs. Just for the record, I've switched to 2.6.27 because I'm
> > debugging something else at the same time, but it doesn't make any
> > difference.
> > 
> > Now, here is another question: There are various snippets like the
> > following in the ath5k driver:
> > 
> > 	/* Wait until the noise floor is calibrated and read the value */
> > 	for (i = 20; i > 0; i--) {
> > 		mdelay(1);
> 
> Uurgh. That's broken. mdelay sleeps so this should not be called in
> softirq context.
> 
> > 		noise_floor = ath5k_hw_reg_read(ah, AR5K_PHY_NF);
> > 		noise_floor = AR5K_PHY_NF_RVAL(noise_floor);
> > 		if (noise_floor & AR5K_PHY_NF_ACTIVE) {
> > 			noise_floor = AR5K_PHY_NF_AVAL(noise_floor);
> > 
> > 			if (noise_floor <= AR5K_TUNE_NOISE_FLOOR)
> > 				break;
> > 		}
> > 	}
> > 
> > This particular one is in
> > drivers/net/wireless/ath5k/phy.c:ath5k_hw_noise_floor_calibration()
> > which is called from ath5k_calibrate(), the callback executed every ten
> > seconds in softirq context. Could this have anything to do with our
> 
> That makes sense. The timer expires early events are multiples of 10s
> apart.

Ok, I thought more about it and aside of the fact that the ath5k is
doing something nasty, you unearthed a weakness in the broadcast code.

Can you please try the following:

Compile the acpi_processor module in to the kernel
(CONFIG_ACPI_PROCESSOR=y) and add processor.max_cstate=1 to the kernel
command line. If I analysed the problem correctly this will make the
jiffies problem go away. I'm working on a fix.

Thanks,
	tglx


