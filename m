Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.tglx.de ([62.245.132.106]:50316 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852AbYJHVO0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 17:14:26 -0400
Date: Wed, 8 Oct 2008 23:14:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Elias Oltmanns <eo@nebensachen.de>
cc: Jiri Slaby <jirislaby@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: ath5k: kernel timing screwed - due to unserialised register
 access?
In-Reply-To: <87myhfnwne.fsf@denkblock.local>
Message-ID: <alpine.LFD.2.00.0810082203360.3237@apollo> (sfid-20081008_231431_540858_115818BF)
References: <87k5cm3ee2.fsf@denkblock.local> <alpine.LFD.2.00.0810052354000.3398@apollo> <87d4id3jmr.fsf@denkblock.local> <alpine.LFD.2.00.0810061614490.3166@apollo> <87skr8h1de.fsf@denkblock.local> <alpine.LFD.2.00.0810071946460.3166@apollo>
 <alpine.LFD.2.00.0810072042140.3166@apollo> <87hc7ot804.fsf@denkblock.local> <87myhfnwne.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 8 Oct 2008, Elias Oltmanns wrote:
> Elias Oltmanns <eo@nebensachen.de> wrote:
> > Thomas Gleixner <tglx@linutronix.de> wrote:
> [...]
> >> Some more questions:
> >>
> >> Does this happen with any on the combinations of highres/nohz
> >> enabled/disabled ?
> >
> > From my tests in the past it would appear that NO_HZ enabled is the most
> > important option to trigger the problem speedily. HIGHRES_TIMERS didn't
> > seem to make much difference and I am quite sure that I observed this
> > issue with NO_HZ disabled too, but very rarely. I'll keep testing and
> > reporting. Meanwhile, ...
> 
> As it turns out, it is all a bit different: Yesterday, I tried for quite
> some time to reproduce the problem on a system with both, NO_HZ and
> HIGH_RES_TIMERS disabled, but in vain. All other combinations trigger
> the described problem, so I have appended the requested data. There is
> one more odd thing: with NO_HZ disabled and HIGH_RES_TIMERS enabled, I
> cannot reliably associate with the AP (WPA encrypted). Still, the timer
> issue remains as you can see below and I rather suspect that this is a
> separate issue.

Hmm, highres=off, nohz=off has one significant difference: jiffies are
incremented by the timer interrupt and not derived from ktime.

I'm twisting my brain to get to the root cause of this.

There is no significant deviation between jiffies and ktime in the
debug output, but I noticed that you run with HZ=100, right ? So the
timeout you run is 100/50 = 2. I would have a reasonable explanation
if it would be 1, but I need to think about it more when I'm awake.

Can you try to reproduce with HZ=250 ? I'm pretty sure it makes the
problem go away.

Thanks,

	tglx
