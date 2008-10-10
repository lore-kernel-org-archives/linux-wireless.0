Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:46925 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755860AbYJJM7u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 08:59:50 -0400
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
Date: Fri, 10 Oct 2008 14:59:28 +0200
In-Reply-To: <alpine.LFD.2.00.0810101432540.3271@apollo> (Thomas Gleixner's
	message of "Fri, 10 Oct 2008 14:34:57 +0200 (CEST)")
Message-ID: <87y70wli6n.fsf@denkblock.local> (sfid-20081010_145954_239308_394471E4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 10 Oct 2008, Elias Oltmanns wrote:
>> That printk() has not been hit, I'm afraid. The output of
>
>> sysrq_timer_list_show() looks much the same but there is no message
>> about softirqs. Just for the record, I've switched to 2.6.27 because I'm
>> debugging something else at the same time, but it doesn't make any
>> difference.
>> 
>> Now, here is another question: There are various snippets like the
>> following in the ath5k driver:
>> 
>> 	/* Wait until the noise floor is calibrated and read the value */
>> 	for (i = 20; i > 0; i--) {
>> 		mdelay(1);
>
> Uurgh. That's broken. mdelay sleeps so this should not be called in
> softirq context.

That was my first thought when I discovered this. However, from what I
read on the web, I somehow got the impression that [um]delay() was
alright as opposed to msleep(). What exactly is the difference then?

Regards,

Elias
