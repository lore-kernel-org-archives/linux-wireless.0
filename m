Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:37300 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033AbYJOQcw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 12:32:52 -0400
From: Elias Oltmanns <eo@nebensachen.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: ath5k: kernel timing screwed - due to unserialised register  access?
References: <87k5cm3ee2.fsf@denkblock.local>
	<alpine.LFD.2.00.0810052354000.3398@apollo>
	<87d4id3jmr.fsf@denkblock.local>
	<alpine.LFD.2.00.0810061614490.3166@apollo>
	<87skr8h1de.fsf@denkblock.local>
	<alpine.LFD.2.00.0810071946460.3166@apollo>
	<alpine.LFD.2.00.0810072042140.3166@apollo>
	<87hc7ot804.fsf@denkblock.local> <87myhfnwne.fsf@denkblock.local>
	<alpine.LFD.2.00.0810082203360.3237@apollo>
	<alpine.LFD.2.00.0810091313380.3237@apollo>
	<87k5cgg87j.fsf@denkblock.local>
	<alpine.LFD.2.00.0810101127560.3271@apollo>
	<87abdck6sn.fsf@denkblock.local>
	<alpine.LFD.2.00.0810101432540.3271@apollo>
	<alpine.LFD.2.00.0810111149420.3356@apollo>
	<87k5ceeuxy.fsf@denkblock.local>
	<alpine.LFD.2.00.0810142054580.6848@apollo>
	<87skqyj0ps.fsf@denkblock.local>
	<alpine.LFD.2.00.0810150752380.6848@apollo>
Date: Wed, 15 Oct 2008 18:32:46 +0200
Message-ID: <87tzbdzump.fsf@denkblock.local> (sfid-20081015_183256_572024_D22E149A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 15 Oct 2008, Elias Oltmanns wrote:
>> Thomas Gleixner <tglx@linutronix.de> wrote:
>
>> > On Sat, 11 Oct 2008, Elias Oltmanns wrote:
>> >> > Compile the acpi_processor module in to the kernel
>> >
>> >> > (CONFIG_ACPI_PROCESSOR=y) and add processor.max_cstate=1 to the kernel
>> >> > command line. If I analysed the problem correctly this will make the
>> >> > jiffies problem go away. I'm working on a fix.
>> >> 
>> >> Spot on, it does go away regardless whether NO_HZ or HIGH_RES are
>> >> enabled or disabled. Looking forward to testing your fix ;-).
>> >
>> > Here you go.
>> 
>> Bad luck, I'm afraid. Your patch seems to fix the issue for NO_HZ=n +
>> HIGH_RES=y. As soon as NO_HZ=y, however, the problem reappears. See the
>
> Hmm. You should have seen the same problem w/o that patch in the
> "CONFIG_ACPI_PROCESSOR=y / processor.max_cstate=1" test with NOHZ=y.

Right you are, I've just retested that case. The reason why I didn't hit
this the last time is that it seems to be triggered far less often than
without the processor.max_cstate=1 option.

>
> Anyway, I can see what the NOHZ problem is. Updated patch below.

Nice, it seems to have done the trick. I'll keep an eye on my logs to
make sure it doesn't pop up again.

>
>> output below. (Still testing on 2.6.27, mind. Should I test something
>> more up-to-date?)
>
> .27 is fine. 
>
> Did you make any progress finding out why the ath5k softirq runs for
> >20ms ?  We need to fix this madness as well :)

Well, it wasn't obvious to me so far, whether the logs really indicated
that 20 msecs had been spent in te callback or whether all this was due
to the bug in the timing code. With your patch applied, I have
eventually made further investigations into the matter. The problem is
the following snippet from
drivers/net/wireless/ath5k/phy.c:ath5k_hw_noise_floor_calibration():

	/*
	 * Enable noise floor calibration
	 */
	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGCCTL,
				AR5K_PHY_AGCCTL_NF);

	ret = ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
			AR5K_PHY_AGCCTL_NF, 0, false);

The first call sets a bit in the AR5K_PHY_AGCCTL register and the second
waits for that bit to be cleared by the hardware again. Apparently, it
takes roughly 20 ms to clear that bit.

In order to execute ath5k_hw_noise_floor_calibration() in process
context, I'd suggest introducing a single threaded workqueue for the
ath5k driver and scheduling calibration from the calib_timer callback.
Additionally, it would be necessary to schedule resets in a similar
manner instead of using the ath5k_tasklet_reset() tasklet. This requires
some serialisation but in my opinion there are various serialisation
issues in ath5k as it is that need fixing. Unfortunately, none of the
concerns I have raised wrt the ath5k driver seem to have resulted in a
commit that I'm aware of even though patches have been supplied. Perhaps
it's the merge window that consumes people's resources. Maybe I'll post
a patch addressing this particular issue in the next few days.

Regards,

Elias
