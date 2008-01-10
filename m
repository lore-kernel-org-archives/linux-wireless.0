Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:35101 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751065AbYAJUcu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 15:32:50 -0500
From: Stefan Lippers-Hollmann <s.L-H@gmx.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [Rt2400-devel] Please pull 'upstream' branch of rt2x00
Date: Thu, 10 Jan 2008 21:32:40 +0100
Cc: "Will Dyson" <will.dyson@gmail.com>,
	"Ivo van Doorn" <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	rt2400-devel@lists.sourceforge.net
References: <200801062337.35904.IvDoorn@gmail.com> <8e6f94720801100352t615025b6j1c2cc0081626fee5@mail.gmail.com>
In-Reply-To: <8e6f94720801100352t615025b6j1c2cc0081626fee5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801102132.42666.s.L-H@gmx.de> (sfid-20080110_203253_744619_C5DD6DCF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Donnerstag, 10. Januar 2008, Will Dyson wrote:
[...]
> Sorry to be out of the loop, but what is wrong with rt61pci? It works
> really really well for me, using John's "everything" branch.
> 
> Hmm. Looking at Linus's tree, I can see that rt61pci is missing at
> least 1 critical fix from Mattias Nissler that has been in
> wireless-2.6 for a long time now.
> 
> rt2x00: Allow rt61 to catch up after a missing tx report
> 
> I'd be pretty disappointed if we released 2.6.24 without this. It is a
> simple fix for a really obnoxious problem (although one that triggers
> rarely on my hardware).

The same goes for (which can be easily rediffed against linux-2.6):
	[PATCH 06/12] rt2x00: Put 802.11 data on 4 byte boundary
without it, at least rt61pci, rt73usb and rt2500usb (plain 
2.6.24-rc7-git2) trigger the well known:

WARNING: at net/mac80211/rx.c:1486 __ieee80211_rx()
Pid: 0, comm: swapper Not tainted 2.6.24-rc7-git2-slh64-smp-1 #1

Call Trace:
 <IRQ>  [<ffffffff80232e4a>] __wake_up_common+0x5a/0x90
 [<ffffffff881fed9e>] :mac80211:__ieee80211_rx+0xbde/0xd00
 [<ffffffff880cb3e6>] :ehci_hcd:ehci_work+0x5d6/0x8e0
 [<ffffffff881f028b>] :mac80211:ieee80211_tasklet_handler+0xbb/0x120
 [<ffffffff80243507>] tasklet_action+0x47/0xb0
 [<ffffffff80243415>] __do_softirq+0x75/0xe0
 [<ffffffff8020d62c>] call_softirq+0x1c/0x30
 [<ffffffff8020f9f5>] do_softirq+0x35/0x90
 [<ffffffff802432a6>] irq_exit+0x96/0xa0
 [<ffffffff8020fad0>] do_IRQ+0x80/0x100
 [<ffffffff8020af60>] default_idle+0x0/0x40
 [<ffffffff8020af60>] default_idle+0x0/0x40
 [<ffffffff8020c981>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80220e60>] lapic_next_event+0x0/0x10
 [<ffffffff8020af89>] default_idle+0x29/0x40
 [<ffffffff8020b00f>] cpu_idle+0x6f/0xe0

> There are also a bunch of antenna selection fixes that never went
> upstream. These are required for my card to operate well at rates
> greater than 1Mbit, even when fairly close to the AP.
> 
> But aside from these issues, the latest 2.6.24-rc7 seems ok for me. My
> testing of it is somewhat limited, due to the terrible performance.
> But I can associate, browse the web and run iperf tests.

I can just agree to this statement, rt73usb works really well (at steady 
~2.4 MB/s) and rt61pci is the first driver to actually work at all (yes, 
the same performance issues, but rt61-legacy freezes using wpa2psk; 
rt2500usb seems to have more problems).

All tests based on plain 2.6.24-rc7-git2 (amd64 and wpa2psk/ CCMP) + the 
following patches:
- [PATCH 06/12] rt2x00: Put 802.11 data on 4 byte boundary
- [PATCH] rt2x00: Corectly initialize rt2500usb MAC

Thanks a lot
	Stefan Lippers-Hollmann
