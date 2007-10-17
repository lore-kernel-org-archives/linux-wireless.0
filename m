Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:22410 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692AbXJQORJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 10:17:09 -0400
Date: Wed, 17 Oct 2007 16:16:40 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: iwl3945 doesn't work
Message-ID: <20071017141639.GN5043@kernel.dk> (sfid-20071017_151716_458466_E672BBE6)
References: <20071017135452.GJ5043@kernel.dk> <1192630271.10567.32.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1192630271.10567.32.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 17 2007, Dan Williams wrote:
> On Wed, 2007-10-17 at 15:54 +0200, Jens Axboe wrote:
> > Hi,
> > 
> > Seeing that iwl3945 is now merged, I decided to switch my x60 to use
> > that instead of ipw3945. That would leave me with zero kernel
> > dependencies.
> > 
> > Unfortunately it doesn't work. Loading the module reveals the device:
> > 
> > iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for
> > Linux, 1.1.17ks
> > iwl3945: Copyright(c) 2003-2007 Intel Corporation
> > ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 21
> > PCI: Setting latency timer of device 0000:03:00.0 to 64
> > iwl3945: Detected Intel PRO/Wireless 3945ABG Network Connection
> > iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
> > phy0: Selected rate control algorithm 'iwl-3945-rs'
> > 
> > # iwconfig wlan0
> > wlan0     IEEE 802.11g  ESSID:"xxxxxxxxxxxxxx"  
> >           Mode:Managed  Channel:0  Access Point: Not-Associated   
> >           Tx-Power=0 dBm   
> >           Retry min limit:7   RTS thr:off   Fragment thr=2346 B   
> >           Encryption key:XXXX-XXXX-XX
> >           Link Quality:0  Signal level:0  Noise level:0
> >           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
> >           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> > 
> > and iwconfig sees it, essid/enc settings are fine, but I don't get a
> > link.
> 
> You do have the updated firmware, right?  I don't think iwl3945 would
> even load if you didn't, but it doesn't hurt to check.

I'm using the suse firmware package, it claims to be version 2.14.1.5.

> Also, what exact kernel version are you using?  2.6.23 release kernel?
> Or something from development series?

It's -git as of last night, so current 2.6.23-git.

As per the last hint, using iwlist scan wlan0 makes it work. I'd prefer
it it worked out of the box, though :-)

-- 
Jens Axboe

