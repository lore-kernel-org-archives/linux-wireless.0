Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966171Ab0BZVqY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 16:46:24 -0500
Date: Fri, 26 Feb 2010 13:45:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: =?ISO-8859-15?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Make b43 driver fall back gracefully to PIO mode after fatal
 DMA  errors
In-Reply-To: <4B8836BF.7000403@lwfinger.net>
Message-ID: <alpine.LFD.2.00.1002261337460.4513@localhost.localdomain>
References: <alpine.LFD.2.00.1002261034140.4513@localhost.localdomain>  <4B881C70.9030004@lwfinger.net> <alpine.LFD.2.00.1002261112590.4513@localhost.localdomain>  <alpine.LFD.2.00.1002261205160.4513@localhost.localdomain> <69e28c911002261209m2b10ca27j5a62c91350e3597c@mail.gmail.com>
 <alpine.LFD.2.00.1002261246330.4513@localhost.localdomain> <4B8836BF.7000403@lwfinger.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Fri, 26 Feb 2010, Larry Finger wrote:
> 
> If you do the following (as root):
> 
> modprobe -r b43
> echo 6400 > /sys/kernel/debug/tracing/buffer_size_kb
> echo mmiotrace > /sys/kernel/debug/tracing/current_tracer
> cat /sys/kernel/debug/tracing/trace_pipe > mydump.txt &
> modprobe b43
> 
> do some network activity, then
> 
> echo nop > /sys/kernel/debug/tracing/current_tracer
> sleep 1
> killproc cat
> 
> That should be a good enough test. If your machine behaves the same as has been
> reported, you should see a DMA error at the point that tracing is turned off.

Nope. I get the DMA error immediately, even if I'm tracing. Here:

 - turn on tracing:

	Feb 26 13:35:45 localhost kernel: mmiotrace: Disabling non-boot CPUs...
	Feb 26 13:35:45 localhost kernel: Broke affinity for irq 9
	Feb 26 13:35:45 localhost kernel: Broke affinity for irq 12
	Feb 26 13:35:45 localhost kernel: Broke affinity for irq 26
	Feb 26 13:35:45 localhost kernel: CPU 1 is now offline
	Feb 26 13:35:45 localhost kernel: SMP alternatives: switching to UP code
	Feb 26 13:35:45 localhost kernel: mmiotrace: CPU1 is down.
	Feb 26 13:35:45 localhost kernel: mmiotrace: enabled.

 - insmod b43:

	Feb 26 13:36:31 localhost kernel: cfg80211: Calling CRDA to update world regulatory domain
	...
	Feb 26 13:36:31 localhost kernel: b43 ssb0:0: firmware: requesting b43/lp0initvals15.fw
	Feb 26 13:36:31 localhost kernel: b43 ssb0:0: firmware: requesting b43/lp0bsinitvals15.fw
	Feb 26 13:36:32 localhost kernel: b43-phy0: Loading firmware version 478.104 (2008-07-01 00:50:23)
	Feb 26 13:36:34 localhost kernel: b43-phy0 ERROR: Fatal DMA error: 0x00000400, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
	Feb 26 13:36:34 localhost kernel: b43-phy0 ERROR: This device does not support DMA on your system. Please use PIO instead.
	Feb 26 13:36:34 localhost kernel: b43-phy0 ERROR: CONFIG_B43_FORCE_PIO must be set in your kernel configuration.
	Feb 26 13:36:34 localhost kernel: b43-phy0: Controller RESET (DMA error) ...
	Feb 26 13:36:34 localhost kernel: b43-phy0: Loading firmware version 478.104 (2008-07-01 00:50:23)
	..

 - networking works (because this kernel had the PIO fallback patch)

 - turn off tracing:

	Feb 26 13:37:15 localhost kernel: mmiotrace: purging non-iounmapped trace @0xffffc90022560000, size 0x4000.
	Feb 26 13:37:15 localhost kernel: mmiotrace: Re-enabling CPUs...
	Feb 26 13:37:15 localhost kernel: SMP alternatives: switching to SMP code
	Feb 26 13:37:15 localhost kernel: Booting Node 0 Processor 1 APIC 0x1
	Feb 26 13:37:15 localhost kernel: mmiotrace: enabled CPU1.
	Feb 26 13:37:15 localhost kernel: mmiotrace: disabled.

so even if mmiotrace fixes it for others, it's not working for me.

		Linus
