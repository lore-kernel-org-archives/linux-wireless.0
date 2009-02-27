Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:36395 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757364AbZB0VVy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 16:21:54 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: b43/mac80211: RX rate_idx warning triggers
Date: Fri, 27 Feb 2009 22:20:10 +0100
Cc: linux-wireless@vger.kernel.org
References: <200902241514.31289.mb@bu3sch.de> <1235755182.7426.62.camel@johannes.local>
In-Reply-To: <1235755182.7426.62.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200902272220.10889.mb@bu3sch.de> (sfid-20090227_222159_217942_F5A9CDDC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 27 February 2009 18:19:42 Johannes Berg wrote:
> On Tue, 2009-02-24 at 15:14 +0100, Michael Buesch wrote:
> > Any idea why this could happen?
> > 
> > [ 2860.155778] Badness at net/mac80211/rx.c:2488
> > [ 2860.155782] NIP: f2797fdc LR: f2784528 CTR: 00000000
> > [ 2860.155787] REGS: eeaf3d60 TRAP: 0700   Not tainted  (2.6.29-rc5-wl-wltest)
> > [ 2860.155791] MSR: 00029032 <EE,ME,CE,IR,DR>  CR: 22000446  XER: 20000000
> > [ 2860.155804] TASK = eea92d00[2771] 'Xorg' THREAD: eeaf2000
> > [ 2860.155807] GPR00: 00000001 eeaf3e10 eea92d00 edde9220 edc1a9c0 eeaf3e48 eeaf3e6c 000000ff 
> > [ 2860.155818] GPR08: 00000002 000000ff 00000000 f2a30274 42000442 101f3d44 00000000 00000000 
> > [ 2860.155829] GPR16: 0000029e 00000199 00000240 5168a060 00000099 c07d47cc 00000000 c09458c0 
> > [ 2860.155839] GPR24: c09458c0 f27ade88 edde93d0 edde9220 eeaf3e48 edde93b4 edc1a9c0 edc1a9c0 
> > [ 2860.155909] NIP [f2797fdc] __ieee80211_rx+0x8c/0x690 [mac80211]
> > [ 2860.155921] LR [f2784528] ieee80211_tasklet_handler+0x114/0x130 [mac80211]
> > [ 2860.155925] Call Trace:
> > [ 2860.155929] [eeaf3e10] [edde93c0] 0xedde93c0 (unreliable)
> > [ 2860.155942] [eeaf3e40] [f2784528] ieee80211_tasklet_handler+0x114/0x130 [mac80211]
> > [ 2860.155954] [eeaf3ea0] [c003e85c] tasklet_action+0x80/0x100
> > [ 2860.155961] [eeaf3ec0] [c003f240] __do_softirq+0x90/0x128
> > [ 2860.155970] [eeaf3f00] [c0006f74] do_softirq+0x58/0x5c
> > [ 2860.155975] [eeaf3f10] [c003f118] irq_exit+0x8c/0xb8
> > [ 2860.155980] [eeaf3f20] [c0007028] do_IRQ+0xb0/0xec
> > [ 2860.155988] [eeaf3f40] [c00171a8] ret_from_except+0x0/0x14
> > [ 2860.155992] --- Exception: 501 at 0xff05c40
> > [ 2860.155994]     LR = 0xf6838e8
> > [ 2860.155996] Instruction dump:
> > [ 2860.156001] 80050024 70090200 408200c8 81250020 38000001 2f890000 419c0018 800b0010 
> > [ 2860.156011] 7f890000 4fdce042 7c000026 5400fffe <0f000000> 2f800000 40beff98 55202036 
> > 
> > We have the following code in b43:
> > 
> > 604         if (phystat0 & B43_RX_PHYST0_OFDM)
> > 605                 status.rate_idx = b43_plcp_get_bitrate_idx_ofdm(plcp,
> > 606                                                 phytype == B43_PHYTYPE_A);
> > 607         else
> > 608                 status.rate_idx = b43_plcp_get_bitrate_idx_cck(plcp);
> > 609         if (unlikely(status.rate_idx == -1))
> > 610                 goto drop;
> > 
> > So IMO the only possible way for the WARN_ON to trigger is
> > (status->rate_idx >= sband->n_bitrates)
> > 
> > Why is rate_idx bigger than n_bitrates?
> 
> Did you ever see this again? It seems weird, since you never return any
> value larger than the max afaict.

This was the only time I saw this after we patched b43 to not pass -1 anymore.

> Some form of corruption? Can you make 
> that warning should print out the entire skb->cb as a hex dump so we can
> tell what's in there, and maybe the header of the 802.11 packet as well.
> And please submit the patch, it'll be useful :)

Yeah, lemme do that. But I can't reproduce it.

-- 
Greetings, Michael.
