Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.osadl.org ([213.239.205.134]:58345 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751944AbXFDGjv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2007 02:39:51 -0400
Subject: Re: b44: regression in 2.6.22 (resend)
From: Thomas Gleixner <tglx@linutronix.de>
To: Maximilian Engelhardt <maxi@daemonizer.de>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	Jeff Garzik <jgarzik@pobox.com>,
	Gary Zambrano <zambrano@broadcom.com>, netdev@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200706031826.06891.maxi@daemonizer.de>
References: <20070525172431.60affaca@freepuppy>
	 <200705281944.05030.maxi@daemonizer.de> <1180380230.3657.3.camel@chaos>
	 <200706031826.06891.maxi@daemonizer.de>
Content-Type: text/plain
Date: Mon, 04 Jun 2007 08:39:48 +0200
Message-Id: <1180939188.4404.5.camel@chaos>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2007-06-03 at 18:26 +0200, Maximilian Engelhardt wrote:
> > Is there any other strange behavior of the high res enabled kernel than
> > the b44 problem ?
> 
> I didn't notice anything in the past (as I wrote). But today I did some tests 
> for an updated version of the p54 mac80211 wlan driver and I noticed exactly 
> the same problem:
> 
> when booting with highres=off everything is fine.
> But when I boot an highres enabled kernel and I do the iperf-test with the p54 
> driver, my systems becomes unresponsive during the test. It seems to be 
> exactly the same problem I have with the b44 driver.
> So this might not be a bug in the b44 code but a bug somewhere in the linux 
> networking code.
> 
> I did the test with an 2.6.22-rc3-git4 kernel and the p54 driver built 
> external as module. 

Can you look at iperf to figure out, whether it does some weird timer
stuff (high frequency interval timer or such) ? Either check the code or
strace it.

	tglx


