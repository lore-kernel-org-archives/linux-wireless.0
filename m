Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:56961 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbZG3Pwe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 11:52:34 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Ath5k/mac80211 triggers WARN_ON in kernel/softirq.c
Date: Thu, 30 Jul 2009 17:52:23 +0200
Cc: Bob Copeland <me@bobcopeland.com>, jirislaby@gmail.com,
	mickflemm@gmail.com, lrodriguez@atheros.com,
	wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
References: <200907301631.50780.mb@bu3sch.de> <b6c5339f0907300745l3e7ec63eu9819503c4e7766bb@mail.gmail.com> <1248968229.16129.9.camel@johannes.local>
In-Reply-To: <1248968229.16129.9.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200907301752.23855.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 30 July 2009 17:37:09 Johannes Berg wrote:
> On Thu, 2009-07-30 at 10:45 -0400, Bob Copeland wrote:
> > On Thu, Jul 30, 2009 at 10:31 AM, Michael Buesch<mb@bu3sch.de> wrote:
> > > Ath5k from today's compat-wireless triggers the following WARNing
> > > on hostapd startup.
> > > [ 1669.799870] ------------[ cut here ]------------
> > > [ 1669.799934] WARNING: at kernel/softirq.c:141 local_bh_enable_ip+0x8b/0xb0()
> > 
> > because ath5k calls ieee80211_beacon_get inside a spin_lock_irqsave()
> > and this is WARN_ON_ONCE(in_irq() || irqs_disabled).
> 
> > > [ 1669.800493]  [<ffffffff807e0fef>] _spin_unlock_bh+0xf/0x20
> > > [ 1669.800564]  [<ffffffffa0040b92>] ieee80211_beacon_get+0x2c2/0x2d0 [mac80211]
> > 
> > I guess this is the first victim of spin_lock_bh conversion?
> 
> Indeed. I think this means we need to convert the local->sta_lock back
> to _irqsave/restore.
> 
> John, can you revert the BH patch ("mac80211: do not use irq locks where
> not necessary") and I'll send a new one with those changes removed?

I didn't look at the code, but can't we simply request the beacon from
mac80211 before locking? Or isn't the spin_lock_irqsave() done in the driver?

-- 
Greetings, Michael.
