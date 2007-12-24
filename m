Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:47903 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbXLXVlz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Dec 2007 16:41:55 -0500
From: Michael Buesch <mb@bu3sch.de>
To: linux-wireless@vger.kernel.org
Subject: Strange mac80211 oops
Date: Mon, 24 Dec 2007 22:37:28 +0100
Cc: Daniel Drake <dsd@gentoo.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200712242237.28913.mb@bu3sch.de> (sfid-20071224_214205_637666_99745003)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just had a strange exception using the zd1211rw driver on mac80211
from latest wireless-2.6 tree.
I'm not sure what happened.

[   98.415423] ------------[ cut here ]------------
[   98.415627] Badness at e221c924 [verbose debug info unavailable]
[   98.415843] NIP: e221c924 LR: e221c904 CTR: 00000000
[   98.416030] REGS: c056dcc0 TRAP: 0700   Not tainted  (2.6.24-rc5-wl26)
[   98.416262] MSR: 00029032 <EE,ME,IR,DR>  CR: 44000024  XER: 20000000
[   98.416648] TASK = c052d5d0[0] 'swapper' THREAD: c056c000
[   98.416844] GPR00: 00000001 c056dd70 c052d5d0 0000001a 00000000 00000000 c056dddc 00000000 
[   98.416877] GPR08: 00000000 e2240000 00000a88 00000018 00000000 00000000 00000000 00000000 
[   98.416886] GPR16: 00000000 00000000 00000000 00000000 00000000 00000000 00d85b70 00d87474 
[   98.416895] GPR24: df8409c0 005b7000 c056de20 de564220 df190210 df8409c0 de564220 00000008 
[   98.416905] NIP [e221c924] __ieee80211_rx+0x48c/0xd44 [mac80211]
[   98.417204] LR [e221c904] __ieee80211_rx+0x46c/0xd44 [mac80211]
[   98.417458] Call Trace:
[   98.417562] [c056dd70] [e221d16c] __ieee80211_rx+0xcd4/0xd44 [mac80211] (unreliable)
[   98.417929] [c056de10] [e220d30c] ieee80211_tasklet_handler+0x74/0xf4 [mac80211]
[   98.418239] [c056de70] [c00344a0] tasklet_action+0x84/0xe0
[   98.418504] [c056de80] [c0034560] __do_softirq+0x64/0xd4
[   98.418755] [c056dea0] [c0006788] do_softirq+0x40/0x58
[   98.419003] [c056deb0] [c0034158] irq_exit+0x44/0x94
[   98.419244] [c056dec0] [c0006c78] do_IRQ+0xb0/0xcc
[   98.419478] [c056ded0] [c0014584] ret_from_except+0x0/0x14
[   98.419740] --- Exception: 501 at cpu_idle+0x94/0x100
[   98.419962]     LR = cpu_idle+0x94/0x100
[   98.420112] [c056df90] [c000a05c] cpu_idle+0x48/0x100 (unreliable)
[   98.420421] [c056dfa0] [c0004454] rest_init+0x74/0xa0
[   98.420664] [c056dfc0] [c04fa9b0] start_kernel+0x26c/0x280
[   98.420927] [c056dff0] [00003860] 0x3860
[   98.421135] Instruction dump:
[   98.421281] 7c030378 541f073a b0010048 48003d19 801800a0 7c001a14 70090003 41a2002c 
[   98.421800] 3d20e224 80098eb8 7c000034 5400d97e <0f000000> 2f800000 41be0010 38000001 
