Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:46835 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552AbYJKUa5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2008 16:30:57 -0400
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
Date: Sat, 11 Oct 2008 22:30:17 +0200
Message-ID: <87k5ceeuxy.fsf@denkblock.local> (sfid-20081011_223104_277469_BAAC6D6A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 10 Oct 2008, Thomas Gleixner wrote:
>> On Fri, 10 Oct 2008, Elias Oltmanns wrote:
[...]
>> > This particular one is in
>> > drivers/net/wireless/ath5k/phy.c:ath5k_hw_noise_floor_calibration()
>> > which is called from ath5k_calibrate(), the callback executed every ten
>> > seconds in softirq context. Could this have anything to do with our
>> 
>> That makes sense. The timer expires early events are multiples of 10s
>> apart.
>
> Ok, I thought more about it and aside of the fact that the ath5k is
> doing something nasty, you unearthed a weakness in the broadcast code.
>
> Can you please try the following:
>
> Compile the acpi_processor module in to the kernel
> (CONFIG_ACPI_PROCESSOR=y) and add processor.max_cstate=1 to the kernel
> command line. If I analysed the problem correctly this will make the
> jiffies problem go away. I'm working on a fix.

Spot on, it does go away regardless whether NO_HZ or HIGH_RES are
enabled or disabled. Looking forward to testing your fix ;-).

Regards,

Elias
