Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.tglx.de ([62.245.132.106]:55040 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920AbYJEV7P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Oct 2008 17:59:15 -0400
Date: Sun, 5 Oct 2008 23:59:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Elias Oltmanns <eo@nebensachen.de>
cc: Jiri Slaby <jirislaby@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: ath5k: kernel timing screwed - due to unserialised register
 access?
In-Reply-To: <87k5cm3ee2.fsf@denkblock.local>
Message-ID: <alpine.LFD.2.00.0810052354000.3398@apollo> (sfid-20081005_235940_235744_CF5DEF11)
References: <87k5cm3ee2.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 5 Oct 2008, Elias Oltmanns wrote:
> Hi there,
> 
> on my system, I observe some odd symptoms which I have troubled Thomas
> with before. After some more investigation, I have come to the
> conclusion that ath5k is at the bottom of this, but since I don't really
> understand the connection, I thought that Thomas may perhaps throw some
> light on the matter, after all, even though I still think that ath5k
> will have to be fixed. The Behaviour I'm seeing is this: sometimes,
> timers fire prematurely, i.e. a timer x started with
> 
> 	mod_timer(&x, HZ/50);
> 
> fires after less than 10 or even 1 msec rather than 20 msec. Trying to
> get to the bottom of this, it struck me that these glitches only occur
> when ath5k is loaded and an interface is brought up (ifconfig wlan0 up
> is quite sufficient). Some more digging revealed that the occurrences of
> such ``fast forward events'' coincided with the expiry of the
> recalibration timer started for the interface. The same behaviour can be
> observed on kernels 2.6.25.16, 2.6.26.5, 2.6.27-rc8-git8 and
> next-20080919.

We had an intermittent problem with jffies based timers between
2.6.27-rc6 and -rc8-latest. This is fixed in current mainline. It only
happened when CONFIG_NOHZ=n and CONFIG_HIGH_RES_TIMERS=n or both
options were disabled at the kernel commandline.

I have no idea why this should happen on any other kernel versions.

Can you please point me to the code in question (file, line number) ?

Thanks,

	tglx

