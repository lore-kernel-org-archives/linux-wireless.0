Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:33659 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbYJJLu4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 07:50:56 -0400
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
Date: Fri, 10 Oct 2008 13:50:48 +0200
Message-ID: <87abdck6sn.fsf@denkblock.local> (sfid-20081010_135101_812614_F8CB32EE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 10 Oct 2008, Elias Oltmanns wrote:
>> Thomas Gleixner <tglx@linutronix.de> wrote:
>
>> > On Wed, 8 Oct 2008, Thomas Gleixner wrote:
>> >> There is no significant deviation between jiffies and ktime in the
>> >> debug output, but I noticed that you run with HZ=100, right ? So the
>> >> timeout you run is 100/50 = 2. I would have a reasonable explanation
>> >> if it would be 1, but I need to think about it more when I'm awake.
>> >
>> > I think I know what happens. Can you please apply the following debug
>> > patch and provide the output?
>> 
>> Just because I didn't quite get your meaning in your earlier email, I'd
>> like to avoid any misunderstanding and emphasise that NO_HZZ=off +
>> HIGH_RES=off doesn't triger the problem, whereas NO_HZ=off + HIGH_RES=on
>> does, as does NO_HZ=on + HIGH_RES=*. As for the HZ=100 vs HZ=250 issue,
>> it doesn't seem to make much difference. As you suggested, I've tested
>> HZ=250 now and as you can see below, the problem remains for NO_HZ=off +
>> HIGH_RES=on, and there still is no problem for both off (as expected).
>
> Yeah, the HZ=250 was a tired wild guess. As I said "I need to think
> about it more when I'm awake" :)
>
> So lets analyse the new data:
>
>> [  121.611352] ath0: associated
>
>> [  136.838264] b:    136.838234395 n:    136.838258980 e: 4294926505 j: 4294926505
>
>> [  136.838325]  #0: <c02e4f18>, tick_sched_timer, S:01, tick_setup_sched_timer, init/355
>> [  136.838346]  # expires at 136840000000 nsecs [in 1721465 nsecs]
>
> tick_sched_timer is the one which updates jiffies. next expiry: 136.840
>
> So at HZ=250 we expect that it expired at:
>
>    136.836, 136.832, 136.828, 136.824, 136.820, 136.816, 136.812
>
> so we would have expected to see
>
>    .last_events0 	  136.828
>    .last_events1 	  136.832
>    .last_events2 	  136.836
>
> but we get:
>
>> [  136.838434]   .last_events0   : 136812009783 nsecs
>> [  136.838437]   .last_events1   : 136816009783 nsecs
>> [  136.838440]   .last_events2   : 136838253113 nsecs
>
> The last event was 22.24333 ms (4 ticks) after the previous one.
>
>         	 b:    	       136.838234395 
> is right before
> 		.last_event2   136.838253113
> and
> 		n:             136.838258980		
> is right after that.
>
> That explains your problem quite well :)
>
> So now the question is why was the interrupt blocked for that time.
>
> Can you please add the following debug patch as well ?

That printk() has not been hit, I'm afraid. The output of
sysrq_timer_list_show() looks much the same but there is no message
about softirqs. Just for the record, I've switched to 2.6.27 because I'm
debugging something else at the same time, but it doesn't make any
difference.

Now, here is another question: There are various snippets like the
following in the ath5k driver:

	/* Wait until the noise floor is calibrated and read the value */
	for (i = 20; i > 0; i--) {
		mdelay(1);
		noise_floor = ath5k_hw_reg_read(ah, AR5K_PHY_NF);
		noise_floor = AR5K_PHY_NF_RVAL(noise_floor);
		if (noise_floor & AR5K_PHY_NF_ACTIVE) {
			noise_floor = AR5K_PHY_NF_AVAL(noise_floor);

			if (noise_floor <= AR5K_TUNE_NOISE_FLOOR)
				break;
		}
	}

This particular one is in
drivers/net/wireless/ath5k/phy.c:ath5k_hw_noise_floor_calibration()
which is called from ath5k_calibrate(), the callback executed every ten
seconds in softirq context. Could this have anything to do with our
problem? Perhaps I should insert some printks in this callback and check
how much time is spent executing various pieces of code. Unless you have
a better suggestion, I'll do that later.

Regards,

Elias
