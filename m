Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:50254 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbYF1Ur3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 16:47:29 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KChKR-00076E-J5
	for linux-wireless@vger.kernel.org; Sat, 28 Jun 2008 20:47:27 +0000
Received: from cpc1-cwma5-0-0-cust137.swan.cable.ntl.com ([80.4.12.138])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2008 20:47:27 +0000
Received: from sitsofe by cpc1-cwma5-0-0-cust137.swan.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2008 20:47:27 +0000
To: linux-wireless@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: WARNING: at net/mac80211/rx.c:319 __ieee80211_rx_handle_packet+0x325/0x775()
Date: Sat, 28 Jun 2008 21:47:11 +0100
Message-ID: <4866A34F.2060708@yahoo.com> (sfid-20080628_224734_441284_D2019454)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: kernel-testers@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I boot 2.6.26-rc8 on an x86_64 system I receive the following trace
in the logs:

> [   72.384009] ------------[ cut here ]------------
> [   72.384021] WARNING: at net/mac80211/rx.c:319 __ieee80211_rx_handle_packet+0x325/0x775()
> [   72.384026] Modules linked in:
> [   72.384033] Pid: 3780, comm: glxinfo Not tainted 2.6.26-rc8skw #3
> [   72.384037]
> [   72.384039] Call Trace:
> [   72.384042]  <IRQ>  [<ffffffff8023234f>] warn_on_slowpath+0x58/0x94
> [   72.384061]  [<ffffffff804da926>] ? _spin_unlock_irqrestore+0x38/0x47
> [   72.384071]  [<ffffffff80237145>] ? __tasklet_schedule+0x97/0xa6
> [   72.384080]  [<ffffffff804bfd04>] ? ieee80211_rx_irqsafe+0x63/0x6a
> [   72.384090]  [<ffffffff80248bcd>] ? ktime_get+0x11/0x42
> [   72.384100]  [<ffffffff80211b37>] ? native_sched_clock+0x50/0x6d
> [   72.384109]  [<ffffffff804c0283>] __ieee80211_rx_handle_packet+0x325/0x775
> [   72.384119]  [<ffffffff802533b3>] ? __lock_acquire+0xdb4/0xdc3
> [   72.384128]  [<ffffffff802533b3>] ? __lock_acquire+0xdb4/0xdc3
> [   72.384136]  [<ffffffff804c0af6>] ? __ieee80211_rx+0x63/0x538
> [   72.384143]  [<ffffffff804c0af6>] ? __ieee80211_rx+0x63/0x538
> [   72.384151]  [<ffffffff804c0f57>] __ieee80211_rx+0x4c4/0x538
> [   72.384161]  [<ffffffff804b2fc6>] ieee80211_tasklet_handler+0x75/0x11b
> [   72.384169]  [<ffffffff80236f18>] ? tasklet_action+0x44/0xdf
> [   72.384176]  [<ffffffff80236f56>] tasklet_action+0x82/0xdf
> [   72.384183]  [<ffffffff8023789f>] __do_softirq+0x70/0xf1
> [   72.384191]  [<ffffffff8020c5bc>] call_softirq+0x1c/0x28
> [   72.384200]  [<ffffffff8020e181>] do_softirq+0x39/0x8a
> [   72.384207]  [<ffffffff802373d8>] irq_exit+0x4e/0x8f
> [   72.384214]  [<ffffffff8020e48e>] do_IRQ+0x148/0x16a
> [   72.384222]  [<ffffffff8020b8b6>] ret_from_intr+0x0/0xf
> [   72.384229]  <EOI>
> [   72.384236] ---[ end trace 4e9264cea4c3b5b9 ]---

The config I am using can be found on
http://sucs.org/~sits/test/config-20080628.txt . I don't remember seeing
this error in old 32 bit kernels but this the first 64 bit kernel I've
started testing with.

