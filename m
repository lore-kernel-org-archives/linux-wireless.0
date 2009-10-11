Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:45453 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829AbZJKKSQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 06:18:16 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: NOHZ: local_softirq_pending 08
Date: Sun, 11 Oct 2009 12:17:30 +0200
Cc: Dave Young <hidave.darkstar@gmail.com>,
	linux-kernel@vger.kernel.org, tglx@linutronix.de,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
References: <20091011095217.GA2200@darkstar> <1255255735.4095.53.camel@johannes.local>
In-Reply-To: <1255255735.4095.53.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200910111217.31883.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 11 October 2009 12:08:55 Johannes Berg wrote:
> On Sun, 2009-10-11 at 17:52 +0800, Dave Young wrote:
> 
> > With kernel 2.6.32-rc3-00052-g0eca52a I got following KERN_ERR
> > messages just while using firefox:
> > 
> > [  130.527399] NOHZ: local_softirq_pending 08
> 
> > Any idea? or known issue?
> 
> Are you using b43 (or wl12x1)? If so, it's a known issue, but the driver
> was recently left without an active maintainer in a brouhaha about a bug
> fix.
> 
> Cf. http://thread.gmane.org/gmane.linux.kernel.wireless.general/39440
> 
> Absent proof that mac80211 is safe to run with BHs enabled, the correct
> solution is disabling tasklets around the RX function, unlike all the
> proposed patches. However, Michael thinks it's such a bad solution that
> he has refused to implement it.

Ehm, no. That's not exactly true.
We call the non-_irqsafe functions, which by definition are designed to
run in non-irq (soft or hard) context. At least that's how I understand the
documentation, last time I read it.
Why don't you simply do local_bh_disable() in those functions, if they
require bh disabled, instead of depending on the driver doing it?

> FWIW, I believe the bug to be in b43 and wl12x1, and not as Michael
> thinks in the stack.

If mac80211 requires BHs disabled, it should do this.

-- 
Greetings, Michael.
