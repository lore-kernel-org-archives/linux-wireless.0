Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540Ab1HYQMF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 12:12:05 -0400
Date: Thu, 25 Aug 2011 18:11:04 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [compat-wireless-3.1-rc1-1] rt2800usb crashes the machine
Message-ID: <20110825161103.GA8586@redhat.com> (sfid-20110825_181209_723549_E941C411)
References: <4E536DD8.6030308@01019freenet.de>
 <20110824090340.GA2277@redhat.com>
 <4E54ECDF.9030804@01019freenet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E54ECDF.9030804@01019freenet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 24, 2011 at 02:21:51PM +0200, Andreas Hartmann wrote:
> Stanislaw Gruszka schrieb:
> > On Tue, Aug 23, 2011 at 11:07:36AM +0200, Andreas Hartmann wrote:
> >> using rt2800usb with a Linksys WUSB600N v2 (rt3572) crashes the complete
> >> machine (SMP, Core i5, linux 3.0) on unloading the module after using it
> >> for a short period of time:
> >> - 2 times netperf -t TCP_MAERTS -H host
> >> - 2 times netperf -t TCP_STREAM -H host
> >>
> >> The error message in /var/log/messages is:
> >>
> >> phy0 -> rt2800_wait_wpdma_ready: Error - WPDMA TX/RX busy, aborting
> >>
> >> After the crash, you have to hard reset the machine.
> 
> [...]
> 
> > Otherwise perhaps you could photo crash logs on virtual terminal
> > (switched by Alt+Ctrl+F2 from X-window) or by using netconsole or kdump.
> 
> There is no crash dump - the machine just hangs up itself and the fan is
> getting loader and loader (until max), because the machine is getting
> hot more and more.

Kernel should generate some information when it hangs, at least when 
debug options are enabled like CONFIG_DEBUG_SPINLOCK,
CONFIG_DEBUG_OBJECTS, CONFIG_LOCKUP_DETECTOR, ... 

I just realized that compat-wireless-3.1-rc1-1, does not contain some
rt2x00 fixes:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=4b1bfb7d2d125af6653d6c2305356b2677f79dc6
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=df71c9cfceea801e7e26e2c74241758ef9c042e5
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=674db1344443204b6ce3293f2df8fd1b7665deea

Try to apply them first, or use compat-wireless-next. If they not help
just try to reconfigure kernel to print messages on lockup.

Note, I'm not able to reproduce hangup using steps you provide. However
I have bad performance, between 6 and 16 Mbits/s measured by netperf
on connection between two rt2800usb stations through WRT160NL AP.
I'm going to look at this problem when I'll have a chance.
 
Stanislaw

